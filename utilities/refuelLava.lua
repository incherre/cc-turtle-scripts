--A program for refueling from a pool of lava
os.loadAPI("common.lua")
local common = _G["common.lua"]

local tArgs = { ... }
if #tArgs ~= 1 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: refuelLava <diameter>")
  return
end

local diameter = tonumber(tArgs[1])

local function isBucket()
  turtle.select(1)
  local item = turtle.getItemDetail()
  return item and item.name == "minecraft:bucket"
end

local function isLava()
  local success, data = turtle.inspectDown()
  if success then
    if string.find(data.name, "lava") then
      return true
    end
  end
  return false
end

local function getLava()
  if isLava() and common.isHungry(50) then
    turtle.placeDown()
    turtle.refuel()
  end
end

local function movErr()
  turtle.dig()
  turtle.forward()
end

if not isBucket() then
  print("Need bucket in slot 1")
  error()
end

common.doInArea(getLava, diameter, 1, diameter, movErr)