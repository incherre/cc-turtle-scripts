--This is a program to place ladders along a wall
os.loadAPI("common.lua")
local common = _G["common.lua"]

hitC = false

while turtle.detect() do
  if turtle.up() then
    common.placeBlockDown()
  else
    turtle.back()
    common.placeBlockFront()
    hitC = true
    break
  end
end

if not hitC then
  turtle.back()
end

common.drop()
