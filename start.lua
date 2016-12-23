local love, pairs, ipairs, gameMode = love, pairs, ipairs, gameMode

local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M
setfenv(1,M)

function load()
  winW, winH = love.graphics.getWidth(), love.graphics.getHeight()

  levels = {"level001", "level002", "level003","level004","level005"} --TODO search for level files using gmatch
  selected = 1
  switch = false
end

function update(dt)
end

function draw() --TODO add keyboard icon
  love.graphics.printf("Scurve", 0, winH/3 - 15, winW, "center")
  for i,str in pairs(levels) do
    if i == selected then love.graphics.setColor(0, 200, 50) end
    love.graphics.printf(str, 0, winH/3 + 30*i, winW, "center")
    love.graphics.setColor(255, 255, 255)
  end
end

function keypressed(key)
  if key == "down" and selected < #levels then
      selected = selected + 1
  end
  if key == "up" and selected > 1 then
      selected = selected - 1
  end
  if key == "return" or key == "space" then
    gameMode:load("game",levels[selected])
  end
end
