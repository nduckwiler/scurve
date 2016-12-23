local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M

local tileW, tileH, tileTable

--load.filesystem.load(path) gets a chunk. If that chunk is a function, then we call it with ()
function M.loadMap(tW, tH, tileString)
  M.newMap(tW, tH, tileString)
end

function M.newMap(tW, tH, tileString)

  tileW, tileH = tW, tH
  tileTable = {}

  local width = #(tileString:match("[^\n]+")) --get width of first line

  for x = 1,width,1 do tileTable[x] = {} end --fill M.tileTable with columns

  local rowIndex,columnIndex = 1,1
  for row in tileString:gmatch("[^\n]+") do
    assert(#row == width, 'Map is not aligned: width of row '..tostring(rowIndex)..' is '..tostring(#row)..' but it should be '..tostring(width))
    columnIndex = 1
    for character in row:gmatch(".") do
      tileTable[columnIndex][rowIndex] = character
      columnIndex = columnIndex + 1
    end
    rowIndex = rowIndex + 1
  end
end

function M.drawMap()
  for columnIndex,column in ipairs(tileTable) do
    for rowIndex,character in ipairs(column) do
        if character == "#" then
          local x,y = (columnIndex-1)*tileW, (rowIndex-1)*tileH
          love.graphics.rectangle("fill", x, y, tileW, tileH)
        end
    end
  end
end

function M.tileTable()
  return tileTable
end

function M.tileSize()
  return tileW, tileH
end
