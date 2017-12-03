--This is a library for crafty turtles

glass_pane = {
  ["minecraft:glass"] = {10, 11, 12, 14, 15, 16}
}

computer = {
  ["minecraft:glass_pane"] = {15},
  ["minecraft:redstone"] = {11},
  ["minecraft:stone"] = {6, 7, 8, 10, 12, 14, 16}
}

planks = {
  ["minecraft:log"] = {11}
}

chest = {
  ["minecraft:planks"] = {6, 7, 8, 10, 12, 14, 15, 16}
}

turtle = {
  ["minecraft:chest"] = {15},
  ["minecraft:iron_ingot"] = {6, 7, 8, 10, 12, 14, 16},
  ["computercraft:CC-Computer"] = {11}
}

local turtlelib = turtle

local function belongsIn(item, recipe)
  return item and recipe[item.name]
end

local funtion getTotal(recipe)
  local total = 0
  for item,poss in recipe do
    total = total + #poss
  end
  return total
end

function craft(recipe, amount)
  local count = 0
  local total = getTotal(recipe) * amount
  local item, position
  local totals = {[6]  = 0, [7]  = 0, [8]  = 0,
            [10] = 0, [11] = 0, [12] = 0,
            [14] = 0, [15] = 0, [16] = 0}
  
  turtlelib.select(1)
  while count < total do
    if turtlelib.suckUp() then
      item = turtlelib.getItemDetail()
      if belongsIn(item, recipe) then
        for i = 1, math.min(item.count, (#recipe[item.name] * amount)) do
          for j = 1, #recipe[item.name] do
            position = recipe[item.name][j]

            if totals[position] < amount then
              turtlelib.transferTo(position, 1)
              totals[position] = totals[position] + 1
              count = count + 1
              break
            end
          end
      end
      
      turtlelib.dropDown()
    else
      os.sleep(10)
    end
  end
    
  turtlelib.craft()
end

function putBack()
  while turtlelib.suckDown() do
    turtlelib.dropUp()
  end
end

function doHave(name, amount)
  local item
  local count = 0
  
  turtlelib.select(1)
  while turtlelib.suckUp() do
    item = turtlelib.getItemDetail()
    if item and item.name == name then
      count = count + item.count
    end
    turtlelib.dropDown()
    
    if count >= amount then
      putBack()
      return true
    end
  end
  
  putBack()
  return false
end
