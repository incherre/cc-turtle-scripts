--A program to turn gravel into flint

turtle.select(1)
while turtle.getItemCount() > 0 and turtle.placeUp() do
  turtle.digUp()
end
