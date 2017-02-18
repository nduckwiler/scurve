local love, require, loadfile, pairs, ipairs, gameMode =
    love, require, loadfile, pairs, ipairs, gameMode

local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M
setfenv(1,M)

function load(lvl)
  timer = require "timer"
  winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
  level = lvl

  quoteInfo = require("assets/"..level.."quote")
  quoteStr, waitTime = quoteInfo.quoteString, quoteInfo.waitTime
  fade = {
    value = 0,
    max = 255
  }

  -- wait some number of seconds, then do a fade transition to "game"
  timer.script(function(wait)
    wait(waitTime or 5)
    timer.tween(1,fade,{value = fade.max},"linear", function() gameMode:load("game",level) end)
  end)

end

function update(dt)
  timer.update(dt)
end

function draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(quoteStr, winW * .1, winH * .6, winW * .7, "left")
  love.graphics.setColor(0, 0, 0, fade.value)
  love.graphics.rectangle("fill", 0, 0, winW, winH)
end

-- immediately begin fade transition if key is pressed
function keypressed(key)
  timer.clear()
  timer.tween(1,fade,{value = fade.max},"linear", function() gameMode:load("game",level) end)
end
