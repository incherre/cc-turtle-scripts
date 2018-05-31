--A program for refueling from a chest

turtle.select(1)
while turtle.getFuelLevel() < turtle.getFuelLimit() and turtle.suck() do
  while turtle.getFuelLevel() < turtle.getFuelLimit() and turtle.getItemCount() > 0 do
    turtle.refuel(1)
    print("Fuel at:", turtle.getFuelLevel())
  end
  
  turtle.drop()
end
