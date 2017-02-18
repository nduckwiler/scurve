local PI_OVER_SIX = math.pi / 6
local winW,winH = love.graphics.getWidth(), love.graphics.getHeight()
local cX, cY = winW / 2, winH / 2
local plyrX, plyrY = cX - 20, cY + 25 - 20 -- assume player is 40x40 square
local oX, oY = 12.5 / 2, 12.5 / 2 -- assume enemy is 12.5x12.5
local function enemyX(r, angle)
  return cX + (r * math.cos(angle)) - oX
end
local function enemyY(r, angle)
  return cY + (r * math.sin(angle)) - oY
end
local enemies = {}
for i = 0,23 do
  enemies[i+1] = {
    type = "enemy",
    mode = "straight",
    x = enemyX((i<12 and 1 or 2) * 125, (i % 12) * PI_OVER_SIX),
    y = enemyY((i<12 and 1 or 2) * 125, (i % 12) * PI_OVER_SIX),
    w = 12.5,
    h = 12.5,
    control = ai.new()
  }
end
return {
  tileString = [[
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
--------------------------------
]],
-- Player.x (number)
  playerX = plyrX,
-- Player.y (number)
  playerY = plyrY,
-- Enemies (table of tables)
  enemies = enemies
}
