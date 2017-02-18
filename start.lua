local love, pairs, ipairs, gameMode = love, pairs, ipairs, gameMode

local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M
setfenv(1,M)

-- Returns index of x in table or 1 if not found.
-- Assumes table is a one-dimensional (non-nested), ordered array
function find(x, table)
  local index
  for i,v in ipairs(table) do
    if v == x then
      index = i
    end
  end
  return index or 1
end

function load(lvl, selectNext)
  winW, winH = love.graphics.getWidth(), love.graphics.getHeight()
  levels = {"level000", "level001", "level002", "level003","level004","level005"}
  if selectNext then
    selected = find(lvl, levels) + 1
  else
    selected = find(lvl, levels)
  end
  if selected > #levels then selected = 1 end
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
  if key == "down" then
    if selected < #levels then selected = selected + 1
    else selected = 1 end
  elseif key == "up" then
    if selected > 1 then selected = selected - 1
    else selected = #levels end
  elseif key == "return" or key == "space" then
    gameMode:load("quote",levels[selected])
  end
end
