--This function prints a 3d file

local tArgs = { ... }
if #tArgs ~= 1 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: print3d <name_of_input_file>")
  print("  place turtle above the lower left space of the first layer")
  return
end

local function getStructInfo(struct)
  local max_x, max_y, max_z = 0, 0, 0
  local requirements = { }

  for x_num, y_tab in pairs(struct) do
    for y_num, z_tab in pairs(y_tab) do
      for z_num, name in pairs(z_tab) do
        if requirements[name] then
          requirements[name] = requirements[name] + 1
        else
          requirements[name] = 1
        end

        if z_num > max_z then
          max_z = z_num
        end
      end

      if y_num > max_y then
        max_y = y_num
      end
    end

    if x_num > max_x then
      max_x = x_num
    end
  end

  return (max_x + 1), (max_y + 1), (max_z + 1), requirements
end

local function placeBlock(name, ran_out)
  local item
  if not ran_out[name] then
    for i = 1, 16 do
      turtle.select(i)
      item = turtle.getItemDetail()
      if item and name == item.name then
        turtle.placeDown()
        return true
      end
    end

    --If we get to here we didn't find it
    print("Ran out of " .. name .. ". Continuing the print")
    ran_out[name] = true
    return false
  else
    return false
  end
end

dofile(tArgs[1]) --This generates the struct table
local x_dist, y_dist, z_dist, requirements = getStructInfo(struct)
local ran_out = { }

local xPos, yPos, zPos = 0, 0, 0

--The goods start here
print("This build will require:")
for name,amount in pairs(requirements) do
  print(" -'" .. name .. "': ", amount)
end
print("Press enter to continue.")
io.read()

for y = 1, y_dist do
  for z = 1, z_dist do
    for x = 1, (x_dist - 1) do
      if struct[xPos] and struct[xPos][yPos] and struct[xPos][yPos][zPos] then
        placeBlock(struct[xPos][yPos][zPos], ran_out)
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

    if struct[xPos] and struct[xPos][yPos] and struct[xPos][yPos][zPos] then
      placeBlock(struct[xPos][yPos][zPos], ran_out)
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

turtle.back()

for i = 1, (y_dist - 1) do
  turtle.down()
end