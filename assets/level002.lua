local winW,winH = love.graphics.getWidth(), love.graphics.getHeight()
local plyrW = 40
local lTargs = {
    {x = 375, y = 400},
    {x = 400, y = 450},
  }
local rTargs = {
  {x = 425, y = 400},
  {x = 400, y = 450}
}

return {
  tileString = [[
--------------------------------
--------------------------------
--------------------------------
--####--------------------####--
-#---##------------------##---#-
##----####################----##
###----##################----###
####----################----####
#####----##############----#####
######----############----######
#######----##########----#######
########----########----########
#########----######----#########
##########----####----##########
###########----##----###########
############--------############
#############------#############
##############----##############
###############--###############
###############--###############
################################
################################
################################
################################
]],
-- Player.x (number)
  playerX = 400 - plyrW/2,
-- Player.y (number)
  playerY = 390,
-- Enemies (table of tables)
  enemies = {
    {type = "enemy", mode = "straight", x = 50, y = 100,
                      w = 12.5, h = 12.5, control = ai.new(lTargs)},
    {type = "enemy", mode = "straight", x = 725, y = 100,
                      w = 12.5, h = 12.5, control = ai.new(rTargs)},
  }
}
