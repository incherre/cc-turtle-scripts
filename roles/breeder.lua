--This is the startup script for the breeder turtle
os.loadAPI("common.lua")
local common = _G["common.lua"]

local tArgs = { ... }
if #tArgs ~= 5 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: breeder <x_home> <y_home> <z_home> <d_home> <reciever_id>")
  return
end

--home:
local x = tonumber(tArgs[1])
local y = tonumber(tArgs[2])
local z = tonumber(tArgs[3])
local d = tonumber(tArgs[4])

local id = tonumber(tArgs[5])
local errStr = "Movement Error: "
local role = "Breeder "

local cowTime = 5 * 60 --The time it takes for a cow to be breedable again

local function hasWheat()
  local item
  for i = 1, 16 do
    turtle.select(i)
    item = turtle.getItemDetail()
    if item and item.name == "minecraft:wheat" and item.count >= 2 then
      return true
    end
  end
  turtle.select(1)
  return false
end

local function push()
  turtle.turnLeft()
  os.sleep(4)
  redstone.setOutput("front", true)
  os.sleep(.5)
  redstone.setOutput("front", false)
  turtle.turnRight()
end

local function feed()
  local item
  for i = 1, 16 do
    turtle.select(i)
    item = turtle.getItemDetail()
    if item and item.name == "minecraft:wheat" then
      turtle.placeDown()
      break
    end
  end
  turtle.select(1)
end

local function breed()
  common.try(turtle.back, id, errStr, role)
  feed()
  common.try(turtle.back, id, errStr, role)
  common.try(turtle.back, id, errStr, role)
  feed()
end

common.goToLocation(x, y, z, d)

while true do
  if turtle.getFuelLevel() < 500 then
    common.sendLog(id, role .. os.computerLabel() .. " fuel low.")
  end

  while not hasWheat() do
    if not turtle.suck() then
      os.sleep(30)
    end
  end

  common.sendLog(id, role .. os.computerLabel() .. " breeding.")
  breed()
  push()
  for i = 1, 3 do
    common.try(turtle.forward, id, errStr, role)
  end

  os.sleep(cowTime)
end


