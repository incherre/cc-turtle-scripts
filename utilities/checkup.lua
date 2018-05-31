--A program to get block/item info

local success, data = turtle.inspect()

if success then
  print(data.name, "meta:", data.metadata)
else
  print("No block.")
end

turtle.select(1)
local item = turtle.getItemDetail()

if item then
  print(item.name, "damage:", item.damage)
else
  print("No item.")
end
