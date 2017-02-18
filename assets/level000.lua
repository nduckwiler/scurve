local winW,winH = love.graphics.getWidth(), love.graphics.getHeight()
local enemySize = 12.5
local targs = {
  {x = 375 - enemySize/2, y = 75},
  {x = 382 - enemySize/2, y = 82},
  {x = 387.5 - enemySize/2, y = 87.5},
  {x = 393.5 - enemySize/2, y = 93.5},
  {x = 400 - enemySize/2, y = 100},
  {x = 400 - enemySize/2, y = 400},
}

return {
  tileString = [[
################################
################################
----------------################
-----------------###############
###############--###############
#############-#--#-#############
############--------############
############--------############
############--------############
############--------############
############--------############
#############------#############
##############----##############
###############--###############
################################
################################
################################
################################
################################
################################
################################
################################
################################
################################
]],

-- Player.x (number)
  playerX = winW * .475,
-- Player.y (number)
  playerY = winH * .45,
-- Enemies (table of tables)
  enemies = {
  {type = "enemy", mode = "straight", x = 20, y = 70,
                    w = enemySize, h = enemySize, control = ai.new(targs)}
  }
}