--This function tells you if the turtle needs
--fuel or not
function isHungry(tolerance)
  return turtle.getFuelLevel() + tolerance < turtle.getFuelLimit()
end

--This function makes the turtle drop until it
--hits something
function drop()
  while turtle.down() do
    print("|")
  end
  print("V")
end

--These functions attemps to place the first block
--they can find
function placeBlockDown()
  for i = 1, 16 do
    turtle.select(i)
    if turtle.getItemCount() > 0 then
      if turtle.placeDown() then
        break
      end
    end
  end
end

function placeBlockFront()
  for i = 1, 16 do
    turtle.select(i)
    if turtle.getItemCount() > 0 then
      if turtle.place() then
        return true
      end
    end
  end
  
  return false
end

--This function gets the integer location
function getIntLoc()
  local x, y, z = gps.locate()
  if not x then print("No GPS") error() end
  x = math.floor(x)
  y = math.floor(y)
  z = math.floor(z)
  return x, y, z
end

--This function checks if at a specific point
function amHome(x, y, z)
  local x2, y2, z2 = getIntLoc()  
  return x == x2 and y == y2 and z == z2
end

--This function orients a lost turtle
function pointNorth() --north is negative z
  local sx, sy, sz = getIntLoc()

  if turtle.forward() then
  elseif turtle.turnRight() and turtle.forward() then
  elseif turtle.turnRight() and turtle.forward() then
  elseif turtle.turnRight() and turtle.forward() then
  else
    return false
  end
  
  local nx, ny, nz = getIntLoc()
  turtle.back()

  if sx == nx and sy == ny and sz == nz then
    return false
  elseif sz > nz then
  elseif sz < nz then
    turtle.turnRight()
    turtle.turnRight()
  elseif sx > nx then
    turtle.turnRight()
  elseif sx < nx then
    turtle.turnLeft()
  end
  
  return true
end

--This function return the direction the turtle was pointing
function getDir() --north is negative z
  local sx, sy, sz = getIntLoc()
  local turns
  local dir

  if turtle.forward() then
    turns = 0
  elseif turtle.turnRight() and turtle.forward() then
    turns = 1
  elseif turtle.turnRight() and turtle.forward() then
    turns = 2
  elseif turtle.turnRight() and turtle.forward() then
    turns = 3
  else
    return false
  end
  
  local nx, ny, nz = getIntLoc()
  turtle.back()

  if sx == nx and sy == ny and sz == nz then
    return false
  elseif sz > nz then
    dir = 0
  elseif sz < nz then
    dir = 2
  elseif sx > nx then
    dir = 3
  elseif sx < nx then
    dir = 1
  end
  
  dir = dir + 4
  for i = 1, turns do
    turtle.turnLeft()
    dir = dir - 1
  end

  return dir % 4
end
  


--This function goes to a specific point
function goToLocation(x, y, z, d) --d: direction, 0=north, 1=east, etc.
  if not pointNorth() then
    return false
  end
  
  local x2, y2, z2 = getIntLoc()
  while x ~= x2 or y ~= y2 or z ~= z2 do
    while y > y2 and turtle.up() do
      x2, y2, z2 = getIntLoc()
    end
    while y < y2 and turtle.down() do
      x2, y2, z2 = getIntLoc()
    end
    
    while z > z2 and turtle.back() do
      x2, y2, z2 = getIntLoc()
    end
    while z < z2 and turtle.forward() do
      x2, y2, z2 = getIntLoc()
    end
    
    if x > x2 then
      turtle.turnRight()
      while x > x2 and turtle.forward() do
        x2, y2, z2 = getIntLoc()
      end
      turtle.turnLeft()
    elseif x < x2 then
      turtle.turnLeft()
      while x < x2 and turtle.forward() do
        x2, y2, z2 = getIntLoc()
      end
      turtle.turnRight()
    end

    x2, y2, z2 = getIntLoc()
  end
  
  if d > 0 then
    turtle.turnRight()
  end
  if d > 1 then
    turtle.turnRight()
  end
  if d > 2 then
    turtle.turnRight()
  end
  
  return true
end

--This function tries something and handles failure
function try(funct, id, errStr, role)
  if not funct() then
    local message = errStr .. role .. os.computerLabel()
    print(message)

    sendLog(id, message)
    error()
  end
end

--This function does a function at every spot in an area
--  x is forward, y is down, z is rightward
function doInArea(funct, x_dist, y_dist, z_dist, movErr)
  for y = 1, y_dist do
    for z = 1, z_dist do
      for x = 1, (x_dist - 1) do
        funct()

        if not turtle.forward() then
          movErr()
        end
      end

      funct()

      if z % 2 == 1 then turtle.turnRight() else turtle.turnLeft() end
      if z < z_dist then
        if not turtle.forward() then
          movErr()
        end
      end
      if z % 2 == 1 then turtle.turnRight() else turtle.turnLeft() end
    end

    if z_dist % 2 == 1 then
      for i = 1, (x_dist - 1) do
        if not turtle.forward() then
          movErr()
        end
      end

      turtle.turnRight()
    else
      turtle.turnLeft()
    end

    for i = 1, (z_dist - 1) do
      if not turtle.forward() then
        movErr()
      end
    end

    turtle.turnRight()

    if y < y_dist then
      if not turtle.down() then
        movErr()
      end
    end
  end
end

--A function to send a log message
function sendLog(id, message)
  rednet.open("left")
  if rednet.isOpen("left") then
    rednet.send(id, message, "turtle_report")
    rednet.close()
    return true
  else
    print("No Rednet!")
    return false
  end
end