--TODO not a good idea to load the whole package table into the namespace

local love, math, table, require, pairs, ipairs, loadfile, gameMode, package =
  love, math, table, require, pairs, ipairs, loadfile, gameMode, package
PI_OVER_TWO = math.pi/2

-- Distance formula
local function dist(x1,y1,x2,y2)
  return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

local function sign(x)
  return (x > 0 and 1) or (x < 0 and -1) or 0
end

local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M
setfenv(1, M)

--------
-- Love functions
--------

function load(lvl)

  Camera = require "camera"
  bumpMgr = require "bumpMgr"
  bumpMgr:addWorld()

  ai = require "ai"
  map_fns = require "map_functions"
  dj = require "deejay"

  debugText = {}
  gameStatus = "play"
  level = lvl

  windowW = love.graphics.getWidth()
  windowH = love.graphics.getHeight()

  package.loaded["assets/"..level] = nil
  local levelInfo = require("assets/"..level)
  tileString, plyrx, plyry, enemies =
    levelInfo.tileString, levelInfo.playerX, levelInfo.playerY, levelInfo.enemies

  map_fns.loadMap(25,25,tileString)

  player = {}
  player.type = "player"
  player.control = true
  player.w = 40
  player.h = 40
  player.x, player.y = plyrx, plyry
  player.xSpeed = 0
  player.ySpeed = 0
  player.xAcc = 10
  player.yAcc = 10
  player.xDec = 2 --positive val expected
  player.yDec = 2 --same
  player.xMax = 125
  player.yMax = 125
  bumpMgr:addObj(player)

  bounds = {}
  bumpMgr:addObj({type = "bound", x=0, y=-1, w=windowW, h=1}, bounds) --top
  bumpMgr:addObj({type = "bound", x=0, y=windowH, w=windowW, h=1}, bounds) --bottom
  bumpMgr:addObj({type = "bound", x=-1, y=0, w=1, h=windowH}, bounds) --left
  bumpMgr:addObj({type = "bound", x=windowW, y=0, w=1, h=windowH}, bounds) --right


  obstacles = {}
  local tileW, tileH = map_fns.tileSize()
  for columnIndex,column in ipairs(map_fns.tileTable()) do
    for rowIndex,character in ipairs(column) do
        if character == "#" then
          local x,y = (columnIndex-1)*tileW, (rowIndex-1)*tileH
          bumpMgr:addObj({type="obstacle", x=x, y=y, w=tileW, h=tileH}, obstacles)
        end
    end
  end

  enemy_speed = 25
  for _,enemy in pairs(enemies) do
    bumpMgr:addObj(enemy)
  end

  bullets = {}
  bullet_width = 5
  bullet_height = 10
  bullet_speed = 126
  bullet_rspeed = 5

  -- Make a new instance of the camera class
  camera = Camera()

  src = love.audio.newSource("assets/251949__tjandrasounds__mouse-mice-rat-terrarium-squeak.wav", "stream")
  dj:setVol(0.1)
  dj:play(src,true)
end

function update(dt)
  -- Update DJ
  local minDist = 600
  for i,enemy in pairs(enemies) do
    local d = dist(enemy.x,enemy.y,player.x,player.y)
    minDist = (d < minDist and d) or minDist
  end
  local scaleVto1 = 1 - minDist/600
  dj:setVol((scaleVto1 < 1 or scaleVto1 > 0) and scaleVto1 or dj:getVol())
  dj:update()


  -- User controls
    if love.keyboard.isDown('up') and player.control then
      local yspd = player.ySpeed - player.yAcc
      player.ySpeed = (yspd < -player.yMax) and -player.yMax or yspd
    end
    if love.keyboard.isDown('down') and player.control then
      local yspd = player.ySpeed + player.yAcc
      player.ySpeed = (yspd < player.yMax) and yspd or player.yMax
    end
    if love.keyboard.isDown('left') then
      if player.control then
        local xspd = player.xSpeed - player.xAcc
        player.xSpeed = (xspd < -player.xMax) and -player.xMax or xspd
      else
        for _,bv in pairs(bullets) do
          bv.angle = bv.angle - (bullet_rspeed * dt)
        end
      end
    end
    if love.keyboard.isDown('right') then
      if player.control then
        local xspd = player.xSpeed + player.xAcc
        player.xSpeed = (xspd < player.xMax) and xspd or player.xMax
      else
        for _,bv in pairs(bullets) do
          bv.angle = bv.angle + (bullet_rspeed * dt)
        end
      end
    end

  -- Player physics
  player.ySpeed = player.ySpeed - sign(player.ySpeed) * player.yDec
  player.xSpeed = player.xSpeed - sign(player.xSpeed) * player.xDec
  player.x, player.y, cols, len = bumpMgr:move(player, player.x + player.xSpeed * dt,
                                                player.y + player.ySpeed * dt, colsFilter)
  for i=1,len do
    if cols[i].other.type == "enemy" then gameStatus = "lose" end
  end

  -- Move enemies
  if bumpMgr:count(enemies) == 0 then gameStatus = "win" end
  for i,enemy in pairs(enemies) do
    -- Move enemy based on mode
    local vx,vy = enemy.control:move(enemy.x, enemy.y, player.x + player.w/2, player.y + player.h/2,
                                      enemy.mode, enemy_speed*dt)
    local goalX, goalY = enemy.x + vx, enemy.y + vy
    enemy.x, enemy.y, cols, len = bumpMgr:move(enemy, goalX, goalY)
    for i=1,len do
      if cols[i].other.type == "player" then gameStatus = "lose" end
    end
  end


  -- Update bullets
  -- Note that we cannot rotate bump object. object now approximates the rotated bullet
  for _,bul in pairs(bullets) do
    local goalX, goalY = bul.x + (math.sin(bul.angle) * bullet_speed * dt),
                          bul.y - (math.cos(bul.angle) * bullet_speed * dt)
    bul.x, bul.y, cols, len = bumpMgr:move(bul, goalX, goalY)
    if len > 0 then
      bumpMgr:removeObj(bul, bullets)
      player.control = true
      for i=1,len do
        if cols[i].other.type == "enemy" then bumpMgr:removeObj(cols[i].other, enemies) end
      end
    end
  end

  if gameStatus ~= "play" then
    dj:squelch()
    gameMode:load("endLvl", level, gameStatus)
  end

end

function draw()
  camera:lockPosition(windowW/2, windowH/2)

  --push transformation onto stack
  camera:attach()
  love.graphics.setColor(255,255,255)
  map_fns.drawMap()

  -- Draw bounds
  for _,bnd in pairs(bounds) do
    love.graphics.rectangle("fill", bnd.x, bnd.y, bnd.w, bnd.h)
  end

  -- Draw enemies
  for _,enemy in pairs(enemies) do
    local d = dist(enemy.x,enemy.y,player.x,player.y)
    local clr = d < 255 and d or 255
    local avgSide = (enemy.w + enemy.h) / 2
    love.graphics.setColor(255, clr, clr)
    love.graphics.circle("fill", enemy.x + enemy.w/2, enemy.y + enemy.h/2, avgSide / 2)
  end

  -- Draw player
  love.graphics.setColor(189,255,205)
  love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

  -- Draw bullets --TODO consider using camera instead of push/pop directly
  love.graphics.setColor(255,255,255)
  for _,bul in pairs(bullets) do
    local midbx, midby = bul.x + bullet_width/2, bul.y + bullet_height/2
    love.graphics.push()
  	love.graphics.translate(midbx, midby)
  	love.graphics.rotate(bul.angle)
  	love.graphics.translate(-midbx, -midby)
    love.graphics.rectangle("fill", bul.x, bul.y, bul.w, bul.h)
    love.graphics.pop()
  end

  camera:detach()

  -- Print debugText
  love.graphics.setColor(0, 255, 0)
  for i,string in pairs(debugText) do
    love.graphics.print(debugText)
  end
  love.graphics.setColor(255, 255, 255)

end

function keypressed(key)
  -- Fire bullets with space bar
  if key == 'space' and player.control == true then
    player.control = false
    local bx, by = player.x + player.w/2, player.y - bullet_height - 3
    bumpMgr:addObj({type = "bullet", x = bx, y = by, w = bullet_width,
                    h = bullet_height, angle = 0}, bullets)
  end
  -- Return to menu with escape
  if key == 'escape' then
    dj:squelch()
    gameMode:load("start") end
end

--------
-- Helper vars/functions
--------

local colTypes = {
  player = {
    enemy = "slide",
    bullet = "cross",
    obstacle = "slide",
    bound = "slide"
  },

  enemy = {
    player = "slide",
    enemy = "slide",
    bullet = "slide",
    obstacle = "slide",
    bound = "slide"
  },

  bullet = {
    player = "cross",
    enemy = "touch",
    bullet = "cross",
    obstacle = "touch",
    bound = "slide"
  }
  --may need an obstacle table later. Currently, only player table is used
}

-- Returns collision type for bump.lua based on colTypes table
function colsFilter(item, other)
  local iType, oType = item.type, other.type
  return colTypes[iType][oType]
end

-- Returns Euclidean distance
function dist(x1,y1,x2,y2)
  return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end
