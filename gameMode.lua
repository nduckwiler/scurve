-- gameMode holds one table at a time in the currentState variable.
-- gameMode calls the callback functions of its currentState.
-- VERSION: 1.0


local modname = ...       --require(...) passes the file name to the module
local M = {}              --table M will hold the module functions
_G[modname] = M           --add the table to the set of global vars
package.loaded[modname] = M  --this makes require(...) return M
setfenv(1,M)

local modes = {}
local currentState = nil

function addModes(t)
  if #t % 2 ~= 0 then
    error("modes table must include string label for each mode")
  end
  for i=1,#t,2 do
    modes[t[i]] = t[i+1]
  end
end

function load(self,mode,...)
  self.currentState = modes[mode]
  self.currentState.load(...)
end

function update(self,dt)
  self.currentState.update(dt)
end

function draw(self)
  self.currentState.draw()
end

function keypressed(self,key)
  self.currentState.keypressed(key)
end
