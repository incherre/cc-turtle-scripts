--This is the startup script for the lumberjack turtle
os.loadAPI("common.lua")
local common = _G["common.lua"]

local tArgs = { ... }
if #tArgs ~= 9 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: farmer <x_home> <y_home> <z_home> <d_home> <x_tree> <y_tree> <z_tree> <d_tree> <reciever_id>")
  return
end

--home:
local hx = tonumber(tArgs[1])
local hy = tonumber(tArgs[2])
local hz = tonumber(tArgs[3])
local hd = tonumber(tArgs[4])

--treeCorner:
local tx = tonumber(tArgs[5])
local ty = tonumber(tArgs[6])
local tz = tonumber(tArgs[7])
local td = tonumber(tArgs[8])

local id = tonumber(tArgs[9])
local errStr = "Movement Error: "
local role = "Lumberjack "

local function try(funct)
  common.try(funct, id, errStr, role)
end

local function falseFunct()
  return false
end

local function plant()
  local item
  for i = 16, 1, -1 do
    turtle.select(i)
    item = turtle.getItemDetail()
    if item and item.name == "minecraft:sapling" and (i > 1 or item.count > 1) then
      turtle.placeDown()
      turtle.select(1)
      break
    end
  end
end

local function isTreeDown()
  local success, block = turtle.inspectDown()
  return success and (block.name == "minecraft:log" or block.name == "minecraft:leaves")
end

local function isTreeFront()
  local success, block = turtle.inspect()
  return success and block.name == "minecraft:log"
end

local function harvest()
  if isTreeDown() then
    turtle.digDown()
  end
end

local function movErr()
  try(falseFunct)
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

local function harvestTree()
  for i = 1, 5 do
    if not turtle.detectUp() then
      try(turtle.up)
    else
      break
    end
  end

  for i = 1, 2 do try(turtle.back) end
  for i = 1, 5 do try(turtle.up) end
  try(turtle.forward)
  turtle.turnLeft()
  for i = 1, 2 do try(turtle.forward) end
  turtle.turnRight()

  common.doInArea(harvest, 5, 4, 5, movErr)

  for i = 1, 2 do try(turtle.forward) end
  turtle.turnRight()
  for i = 1, 2 do try(turtle.forward) end
  turtle.turnLeft()
  try(turtle.down)

  while isTreeDown() do
    turtle.digDown()
    try(turtle.down)
  end

  try(turtle.up)
end

while true do
  if turtle.getFuelLevel() < 500 then
    common.sendLog(id, role .. os.computerLabel() .. " fuel low.")
  end

  common.goToLocation(tx, ty, tz, td)

  while not isTreeFront() do
    os.sleep(60)
  end

  common.sendLog(id, role .. os.computerLabel() .. " felling.")
  harvestTree()
  plant()
  common.goToLocation(hx, hy, hz, hd)
  dropOff()
end
