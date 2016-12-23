-- deejay.lua
-- dj = require 'deejay'
-- VERSION: 1.1

deejay = {}
deejay.sources = {}

function deejay.new()
  return setmetatable({sources = {}}, {__index = deejay})
end

-- @param source  the Source to be played
-- @param loop    true if source should be looped
function deejay:play(source, loop)
  local src = source:clone()
  src:setLooping(loop or false)
  src:play()
  table.insert(self.sources, src)
end

function deejay:update()
  for i,src in ipairs(self.sources) do
    if src:isStopped() then
      table.remove(self.sources, i)
    end
  end
end

-- returns master volume
function deejay:getVol()
  return love.audio.getVolume()
end

-- sets master volume
function deejay:setVol(vol)
  if vol > 1.0 or vol < 0 then
    error("Volume must be between 0.0 and 1.0, inclusive")
  end
  love.audio.setVolume(vol)
end

--[[TODO allow tags and access to individ sources
-- sets volume for all sources
function deejay:setVol(vol)
  if vol > 1.0 or vol < 0 then
    error("Volume must be between 0.0 and 1.0, inclusive")
  end
  for i,src in ipairs(self.sources) do
    src:setVolume(vol)
  end
end
]]

-- stops and removes all Sources
function deejay:squelch()
  for i,src in ipairs(self.sources) do
    src:stop()
    table.remove(self.sources,i)
  end
end


return deejay
