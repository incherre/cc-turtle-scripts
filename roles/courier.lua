--This is the startup script for the courier turtles
os.loadAPI("common.lua")
local common = _G["common.lua"]

local tArgs = { ... }
if #tArgs ~= 9 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: courier <x_from> <y_from> <z_from> <d_from> <x_to> <y_to> <z_to> <d_to> <reciever_id>")
  print("  directions: 0 = north, 1 = east, 2 = south, 3 = west, 4 = up, 5 = down")
  return
end

--from:
local fx = tonumber(tArgs[1])
local fy = tonumber(tArgs[2])
local fz = tonumber(tArgs[3])
local fd = tonumber(tArgs[4])

--to:
local tx = tonumber(tArgs[5])
local ty = tonumber(tArgs[6])
local tz = tonumber(tArgs[7])
local td = tonumber(tArgs[8])

local id = tonumber(tArgs[9])
local errStr = "Movement Error: "
local role = "Courier "

local function take()
  if fd == 4 then
    return turtle.suckUp()
  elseif fd == 5 then
    return turtle.suckDown()
  else
    return turtle.suck()
  end
end

local function put()
  if td == 4 then
    return turtle.dropUp()
  elseif td == 5 then
    return turtle.dropDown()
  else
    return turtle.drop()
  end
end

local function hasItems()
  local result = false
  for i = 1, 16 do
    turtle.select(i)
    if turtle.getItemCount() > 0 then
      result = true
      break
    end
  end

  turtle.select(1)
  return result
end

local function dropOff()
  for i = 1, 16 do
    turtle.select(i)
    put()
  end
  turtle.select(1)
end

local function pickUp()
  turtle.select(1)
  while not take() do
    os.sleep(60)
  end
  for i = 2, 16 do
    turtle.select(i)
    take()
  end
  turtle.select(1)
end

if hasItems() then
  common.goToLocation(tx, ty, tz, td)
  dropOff()
end

while true do
  if turtle.getFuelLevel() < 500 then
    common.sendLog(id, role .. os.computerLabel() .. " fuel low.")
  end

  common.goToLocation(fx, fy, fz, fd)
  pickUp()
  common.goToLocation(tx, ty, tz, td)
  dropOff()
end