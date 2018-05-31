--A program for dropping items on cactus

while true do
  if turtle.suck() then
    turtle.dropDown()
  else
    os.sleep(60)
  end
end
