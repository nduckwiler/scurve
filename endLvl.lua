local love, pairs, ipairs, gameMode, game = love, pairs, ipairs, gameMode, game
--TODO should we be saving game to our namespace? perhaps access it through gameMode

local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M
setfenv(1,M)

loseImg = love.graphics.newImage("assets/dead-square 1.2.png")

function load(lvl, gameStatus)
  winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
  level = lvl
  outcome = gameStatus
  if outcome == "win" then
    msg = "you win!"
  else
    msg = "you lose..."
  end
end

function update(dt)
end

function draw()
  game.draw()
  love.graphics.setColor(0, 0, 0, 100)
  love.graphics.rectangle("fill", 0, 0, winW, winH)
  love.graphics.setColor(255, 255, 255, 255)
  if outcome == "win" then
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("fill", game.player.x, game.player.y, game.player.w, game.player.h)
  else
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", game.player.x, game.player.y, game.player.w, game.player.h)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(loseImg, game.player.x, game.player.y)
  end
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(msg, 0, winH/2 - 150, winW, "center")
end

function keypressed(key)
  if key then
    gameMode:load("start", level, (outcome=="win"))
  end
end
