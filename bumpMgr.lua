-- bumpMgr
-- version: 3.1

local bump = require 'bump'

local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M

function M:addWorld()
  self.world = bump.newWorld()
  setmetatable(M, {__index = self.world})
end

function M:find(obj,array)
  for i,v in pairs(array) do
    if v == obj then
      return i
    end
  end
  error('obj not found in lookup table')
end

function M:count(array)
  ctr = 0
  for i,v in pairs(array) do
    ctr = ctr+1
  end
  return ctr
end

function M:addObj(obj,array)
  if array then
    array[#array + 1] = obj
  end
  self.world:add(obj, obj.x, obj.y, obj.w, obj.h)
end

function M:removeObj(obj,array)
  if array then
    local index = M:find(obj,array)
    array[index] = nil
  end
  self.world:remove(obj)
end
