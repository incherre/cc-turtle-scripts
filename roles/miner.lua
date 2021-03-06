--This is the startup script for the mining turtle
os.loadAPI("common.lua")
local common = _G["common.lua"]

local tArgs = { ... }
if #tArgs ~= 6 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: miner <x_home> <y_home> <z_home> <d_home> <diameter> <reciever_id>")
  return
end

--home:
local x = tonumber(tArgs[1])
local y = tonumber(tArgs[2])
local z = tonumber(tArgs[3])
local d = tonumber(tArgs[4])

local lastx = x
local lasty = y
local lastz = z
local lastd = (d + 2) % 4

local diameter = tonumber(tArgs[5])

local id = tonumber(tArgs[6])
local errStr = "Movement Error: "
local role = "Miner "

local function down()
  while not turtle.down() do
    turtle.attackDown()
  end
end

local function up()
  while not turtle.up() do
    turtle.attackUp()
    turtle.digUp()
  end
end

local function shouldDescend()
  local x, y, z = common.getIntLoc()
  if ((x * 2) + z) % 5 == 0 then
    local success, block = turtle.inspectDown() --This operation is expensive, do it as little as possible
    return not success or block.name ~= "minecraft:cobblestone"
  else
    return false
  end
end

local function shouldMineForward()
  local success, block = turtle.inspect()
  if success and (block.name == "minecraft:chest" or block.name == "minecraft:mob_spawner") then
    local fx, fy, fz = common.getIntLoc()
    local message =  role .. os.computerLabel() .. " found " .. block.name .. " at " .. tostring(fx) .. "," .. tostring(fy) .. "," .. tostring(fz) .. "."
    common.sendLog(id, message)
  end

  return success and block.name ~= "minecraft:chest" and block.name ~= "minecraft:mob_spawner" and block.name ~= "minecraft:stone"
end

local function shouldMineDown()
  local success, block = turtle.inspectDown()
  if success and (block.name == "minecraft:chest" or block.name == "minecraft:mob_spawner") then
    local fx, fy, fz = common.getIntLoc()
    local message =  role .. os.computerLabel() .. " found " .. block.name .. " at " .. tostring(fx) .. "," .. tostring(fy) .. "," .. tostring(fz) .. "."
    common.sendLog(id, message)
  end

  return not success or (success and block.name ~= "minecraft:chest" and block.name ~= "minecraft:mob_spawner" and block.name ~= "minecraft:bedrock")
end

local function mineLayer()
  for i = 1, 4 do
    if shouldMineForward() then
      turtle.dig()
    end
    turtle.turnRight()
  end
end

local function isFull()
  local count = 0
  for i = 1, 16 do
    turtle.select(i)
    if turtle.getItemCount() > 0 then
      count = count + 1
    end
  end

  turtle.select(1)
  return count >= 15
end

local function goUp()
  local tempx, tempy, tempz = common.getIntLoc()
  while tempy < y do
    up()
    tempx, tempy, tempz = common.getIntLoc()
  end
end

local function dropOff()
  lastx, lasty, lastz = common.getIntLoc()
  goUp()
  lastd = common.getDir()
  common.goToLocation(x, y, z, d)
  for i = 1, 16 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.select(1)
end

local function descend()
  while shouldMineDown() do
    if isFull() then
      dropOff()
      common.goToLocation(lastx, y, lastz, lastd)
      common.goToLocation(lastx, lasty, lastz, lastd)
    end
    turtle.digDown()
    down()
    mineLayer()
  end

  goUp()
end

local function mineOnce()
  if shouldDescend() then
    descend()
  end

  local item
  for i = 1, 16 do
    turtle.select(i)
    item = turtle.getItemDetail()
    if item and item.name == "minecraft:cobblestone" then
      turtle.placeDown()
      break
    end
  end
  turtle.select(1)

  if turtle.getFuelLevel() < 500 then
    common.sendLog(id, role .. os.computerLabel() .. " fuel low.")
    dropOff()
    print("Type 'done' to continue")
    while io.read() ~= "done" do
      turtle.refuel()
      print(tostring(turtle.getFuelLevel()))
    end

    common.goToLocation(lastx, y, lastz, lastd)
    common.goToLocation(lastx, lasty, lastz, lastd)
  end
end

local function movErr()
  turtle.dig()
  turtle.digUp()
  turtle.forward()
end

common.goToLocation(x, y, z, d)
turtle.turnRight()
turtle.turnRight()
common.doInArea(mineOnce, diameter, 1, diameter, movErr)
dropOff()