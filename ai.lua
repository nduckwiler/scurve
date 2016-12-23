-- ai.lua
-- version: 1.1.1
-- special 1.1.1 version for rcMissile add seeks to seek function

ai = {
  stepsToClear = {x=0,y=0},
  __index = ai
}

function ai.new(...)
  --stepsToClear = {x=0, y=0}
  --instance = {stepsToClear}
  mt = {__index = ai}
  return setmetatable({targs = ..., step = 1},mt)
end

function ai.move(self,enemy_x,enemy_y,target_x,target_y, mode, speed)
  local vx,vy
  if self.targs then
    vx,vy = ai.seeks(self, enemy_x, enemy_y, mode, speed)
  else
    vx,vy = ai.seek(self,enemy_x,enemy_y,target_x,target_y, mode, speed)
  end
  return vx,vy
end

-- ai.seek returns a vector that determines the NPC's next movement
-- If the mode is straight, return vector in the direction of the target, with length of value speed
-- Otherwise take detour around an obstacle
function ai.seek(self,enemy_x,enemy_y,target_x,target_y, mode, speed)
    if self.stepsToClear.x ~= 0 or self.stepsToClear.y ~= 0 then
      local theta = math.atan2(self.stepsToClear.y, self.stepsToClear.x)
      local vx,vy = speed*math.cos(theta), speed*math.sin(theta)
      if math.abs(self.stepsToClear.x) < math.abs(vx) then
        self.stepsToClear.x = 0
      else
        self.stepsToClear.x = self.stepsToClear.x - vx
      end
      if math.abs(self.stepsToClear.y) < math.abs(vy) then
        self.stepsToClear.y = 0
      else
        self.stepsToClear.x = self.stepsToClear.x - vx
      end
      return vx,vy
    else
      local dist = dist(enemy_x,enemy_y,target_x,target_y)
      local vx = target_x - enemy_x
      local vy = target_y - enemy_y
      return (vx/dist)*speed,(vy/dist)*speed
    end
end

--TODO create function that builds TARGSETS tracing a given shape
function ai.seeks(self, enemy_x,enemy_y, mode, speed)
  local vx,vy = 0,0
  if self.step <= #self.targs then
    if dist(enemy_x,enemy_y, self.targs[self.step].x,self.targs[self.step].y) >= speed then
      vx,vy = ai.seek(self, enemy_x,enemy_y, self.targs[self.step].x,self.targs[self.step].y, mode, speed)
    else
      self.step = self.step + 1
      vx,vy = 0,0
    end
  end
  return vx,vy
end

-- ai:detour stores the x and y vectors required to clear an obstacle
function ai:detour(x,y)
  self.stepsToClear.x, self.stepsToClear.y = x,y
end

-- ai.circle returns the location of a NPC after it has moved around a circle
-- with linear speed of value speed.
function ai.circle(enemy_x,enemy_y, circle_x,circle_y,radius, speed)
  local theta = math.acos(enemy_x/radius) -- starting angle in radians
  theta = theta + (speed/radius) -- increase angle by angular speed
  return circle_x + math.cos(theta)*radius, circle_y + math.sin(theta)*radius
end

function ai:__string()
  return "stepsToClear: "..self.stepsToClear.x..", "..self.stepsToClear.y.."\n"
end

-- Distance formula
function dist(x1,y1,x2,y2)
  return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

return ai
