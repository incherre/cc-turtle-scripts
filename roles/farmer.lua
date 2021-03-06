--This is the startup script for the farmer turtle
os.loadAPI("common.lua")
local common = _G["common.lua"]

local tArgs = { ... }
if #tArgs ~= 6 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: farmer <x_home> <y_home> <z_home> <d_home> <diameter> <reciever_id>")
  return
end

--home:
local x = tonumber(tArgs[1])
local y = tonumber(tArgs[2])
local z = tonumber(tArgs[3])
local d = tonumber(tArgs[4])

local diameter = tonumber(tArgs[5])

local id = tonumber(tArgs[6])
local errStr = "Movement Error: "
local role = "Farmer "

local function try(funct)
  common.try(funct, id, errStr, role)
end

local function falseFunct()
  return false
end

local function isGrownDown()
  local success, block = turtle.inspectDown()
  return success and ((block.name == "minecraft:wheat" and block.metadata == 7) or (block.name == "minecraft:nether_wart" and block.metadata == 3))
end

local function isGrownFront()
  local success, block = turtle.inspect()
  return success and ((block.name == "minecraft:wheat" and block.metadata == 7) or (block.name == "minecraft:nether_wart" and block.metadata == 3))
end

local function plant()
  local item
  for i = 16, 1, -1 do
    turtle.select(i)
    item = turtle.getItemDetail()
    if item and (item.name == "minecraft:wheat_seeds" or item.name == "minecraft:nether_wart") and (i > 1 or item.count > 1) then
      turtle.placeDown()
      turtle.select(1)
      break
    end
  end
end

local function harvest()
  if isGrownDown() then
    turtle.digDown()
    plant()
  end
end

local function movErr()
  try(falseFunct)
end

local function harvestSquare()
  try(turtle.up)
  try(turtle.forward)
  
  common.doInArea(harvest, diameter, 1, diameter, movErr)
  
  try(turtle.back)
  
  try(turtle.down) 
end

local function dropOff()
  turtle.turnRight()

  for i = 2, 16 do
    turtle.select(i)
    turtle.drop()
  end

  turtle.select(1)
  turtle.turnLeft()
end

common.goToLocation(x, y, z, d)

while true do
  if turtle.getFuelLevel() < 500 then
    common.sendLog(id, role .. os.computerLabel() .. " fuel low.")
  end
  
  while not isGrownFront() do
    os.sleep(120)
  end

  common.sendLog(id, role .. os.computerLabel() .. " harvesting.")
  harvestSquare()
  dropOff()
end
