--[[
Licenses
FORCED SQUARE.ttf by DrawPerfect http://www.dafont.com/paul-ijsendoorn.d2557
251949__tjandrasounds__mouse-mice-rat-terrarium-squeak.wav by tjandrasounds https://www.freesound.org/people/tjandrasounds/
--]]
gameMode = require('gameMode') --TODO gameMode must be declared before start and game are declared
start = require('start')
game = require('game')
endLvl = require('endLvl')

gameMode.addModes{"start",start,"game",game,"endLvl",endLvl}
font = love.graphics.newFont("/assets/FORCED SQUARE.ttf", 20)
love.graphics.setFont(font)

function love.load()
  gameMode:load("start")
end

function love.update(dt)
  gameMode:update(dt)
end

function love.draw()
  gameMode:draw()
end

function love.keypressed(key)
  gameMode:keypressed(key)
end
