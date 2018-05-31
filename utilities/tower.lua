--A script to get a turtle to build a transmission tower

local function comeBack()
  while turtle.down() do
    print("Going down")
  end
end

local function placeBlock()
  for i = 1, 16 do
    turtle.select(i)
    if turtle.getItemCount() > 0 then
      turtle.placeDown()
      break
    end
  end
end

local function goN(n)
  for i = 1, (n - 1) do
    turtle.forward()
  end
end

local function placeRad(rad)
  placeBlock()
  goN(rad)
  turtle.turnRight()
  
  for i = 1, 4 do
    goN(rad)
    placeBlock()
    turtle.turnRight()
    goN(rad)
  end
  
  turtle.turnRight()
  goN(rad)
  turtle.turnRight()
  turtle.turnRight()
end

start = 5 --9
height = 2 --20

for i = start, 2, -1 do
  for j = 1, height do
    turtle.up()
    placeRad(i)
  end
end

for j = 1, height do
  turtle.up()
  placeBlock()
end

turtle.forward()
comeBack()
