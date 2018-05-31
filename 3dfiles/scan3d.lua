--This function breaks a structure down and records what it finds

local tArgs = { ... }
if #tArgs ~= 4 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: scan3d <name_of_output_file> <x_dist> <y_dist> <z_dist>")
  print("  x is forward, y is upward, z is rightward")
  print("  place turtle under the lowest layer of a structure")
  return
end

local out_name = tArgs[1]
local x_dist = tonumber(tArgs[2])
local y_dist = tonumber(tArgs[3])
local z_dist = tonumber(tArgs[4])

local struct = { }
local xPos, yPos, zPos = 0, 0, 0

local success, block

local function addBlock(x, y, z, name)
  if not struct[x] then
    struct[x] = {}
  end
  if not struct[x][y] then
    struct[x][y] = {}
  end
  struct[x][y][z] = name
end

--The goods start here
for y = 1, y_dist do
  for z = 1, z_dist do
    for x = 1,(x_dist - 1) do
      success, block = turtle.inspectUp()
      if success then
        addBlock(xPos, yPos, zPos, block.name)
        turtle.digUp()
      end
      
      if not turtle.forward() then
        print("Failed to move forward at", xPos, yPos, zPos)
        error()
      end

      if z % 2 == 1 then
        xPos = xPos + 1
      else
        xPos = xPos - 1
      end
    end

    success, block = turtle.inspectUp()
    if success then
      addBlock(xPos, yPos, zPos, block.name)
      turtle.digUp()
    end

    if z % 2 == 1 then turtle.turnRight() else turtle.turnLeft() end
    if z < z_dist then
      if not turtle.forward() then
        print("Failed to move forward at", xPos, yPos, zPos)
        error()
      end
      zPos = zPos + 1
    end
    if z % 2 == 1 then turtle.turnRight() else turtle.turnLeft() end
  end

  if z_dist % 2 == 1 then
    for i = 1, (x_dist - 1) do
      if not turtle.forward() then
        print("Failed to move forward at", xPos, yPos, zPos)
        error()
      end
      xPos = xPos - 1
    end

    turtle.turnRight()
  else
    turtle.turnLeft()
  end

  for i = 1, (z_dist - 1) do
    if not turtle.forward() then
      print("Failed to move forward at", xPos, yPos, zPos)
      error()
    end
    zPos = zPos - 1
  end

  turtle.turnRight()
  assert(xPos == 0 and zPos == 0)

  if y < y_dist then
    if not turtle.up() then
      print("Failed to move up at", xPos, yPos, zPos)
      error()
    end
    yPos = yPos + 1
  end
end

for i = 1, (y_dist - 1) do
  turtle.down()
end

local f = fs.open(out_name, "w")
if not f then
  print("File handling error")
  error()
end

f.write("--File named \"")
f.write(out_name)
f.write("\" created on day ")
f.write(tostring(os.day()))
f.write(" at ")
f.writeLine(textutils.formatTime(os.time(), false))
f.writeLine("--  File structure is struct[relative x][relative y][relative z] = \"modname:blockname\"")
f.writeLine("--  x is forward, y is upward, z is rightward")

f.writeLine("struct = {")
for x_num, y_tab in pairs(struct) do
  f.write("  [")
  f.write(tostring(x_num))
  f.writeLine("] = {")
  for y_num, z_tab in pairs(y_tab) do
    f.write("    [")
    f.write(tostring(y_num))
    f.writeLine("] = {")
    for z_num, name in pairs(z_tab) do
      f.write("      [")
      f.write(tostring(z_num))
      f.write("] = \"")
      f.write(name)
      f.writeLine("\", ")
    end
    f.writeLine("    }, ")
  end
  f.writeLine("  }, ")
end
f.writeLine("}")

f.close()