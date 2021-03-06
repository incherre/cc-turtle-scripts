--Von Neumann Probe v0.8
--This program allows turtles to exploit a glitch with hoppers in Minecraft 1.8.9 to self replicate

local hasSecondaryFunction = false
local secondaryFunction = ""

--This function selects an item by name if it exists and returns whether it was successful
local function selectItem(name)
  local item
  for i = 1, 16 do
    item = turtle.getItemDetail(i)
    if item and item.name == name then
      turtle.select(i)
      return true
    end
  end
  return false
end

--This is a helper function for the place item functions
local function placeItemHelper(name, placeFunct)
  local oldSlot = turtle.getSelectedSlot()

  local found = selectItem(name)
  if found then
    placeFunct()
  end

  turtle.select(oldSlot)
  return found
end

--This function places an item by name in front
local function placeItem(name)
  return placeItemHelper(name, turtle.place)
end

--This function places an item by name above
local function placeItemUp(name)
  return placeItemHelper(name, turtle.placeUp)
end

--This function places an item by name below
local function placeItemDown(name)
  return placeItemHelper(name, turtle.placeDown)
end

--This function returns a table with item names as the key and location as the value
local function getItems()
  local items = {}
  local item

  for i = 1, 16 do
    item = turtle.getItemDetail(i)
    if item then
      items[item.name] = i
    end
  end

  return items
end

--This function puts one of a specific item at the specific position in an external inventory
--That inventory should be empty and the turtle needs several other items that do not stack with the specified item
local function dropAt(name, pos)
  local items = getItems()
  local placedCount = 0
  local oldSlot = turtle.getSelectedSlot()

  for item, slot in pairs(items) do
    if placedCount >= (pos - 1) then
      break
    elseif item ~= name then
      turtle.select(slot)
      turtle.drop()
      placedCount = placedCount + 1
    end
  end
  
  turtle.select(items[name])
  turtle.drop(1)
  turtle.select(oldSlot)

  for i = 1, (pos - 1) do
    turtle.suck()
  end
end

--This function sends the turtle to some random location to build a new setup
local function travel()
  local rotation = math.random(4) -- One to four
  local distance = 19 + math.random(181) -- Twenty to two-hundred

  for i = 1, rotation do
    turtle.turnRight()
  end

  for i = 1, distance do
    if not turtle.forward() then
      break
    end
  end
  
  for i = 1, 3 do
    turtle.up()
  end
end

--This function moves the turtle to the starting position
local function orient()
  for i = 1, 3 do 
    if not turtle.up() then
      break
    end
  end

  local oldSlot = turtle.getSelectedSlot()
  for i = 1, 16 do
    turtle.select(i)
    turtle.dropUp()
  end
  turtle.select(oldSlot)
end

--This function builds the item duplication and turtle reprogramming setup
local function buildCopier()
  placeItemUp("minecraft:chest")
  placeItem("minecraft:chest")
  turtle.down()
  turtle.down()
  placeItem("minecraft:chest")
  turtle.up()
  placeItem("minecraft:hopper")
  turtle.up()

  local item
  local oldSlot = turtle.getSelectedSlot()
  local placedPaper, placedRedstone = false, false

  for i = 16, 1, -1 do
    item = turtle.getItemDetail(i)
    if item and item.name == "minecraft:paper" and not placedPaper then
      turtle.select(i)
      turtle.transferTo(11)
      placedPaper = true
    elseif item and item.name == "minecraft:redstone" and not placedRedstone then
      turtle.select(i)
      turtle.transferTo(7)
      placedRedstone = true
    elseif item then
      turtle.select(i)
      turtle.dropUp()
    end
  end

  turtle.select(oldSlot)
  turtle.craft(1)

  while turtle.suckUp() do end

  for i = 1, 3 do turtle.down() end
  placeItemDown("computercraft:CC-Peripheral")

  for i = 1, 16 do
    item = turtle.getItemDetail(i)
    if item and item.name == "computercraft:disk" then
      turtle.select(i)
      turtle.dropDown(1)
      break
    end
  end

  fs.copy(shell.getRunningProgram(), fs.combine("disk", "VonNeumann.lua"))
  if hasSecondaryFunction then
    fs.copy(secondaryFunction, fs.combine("disk", secondaryFunction))
  end

  local startFile = fs.open("disk/startup", "w")
  startFile.writeLine("os.setComputerLabel(\"VonNeumann\")")
  startFile.writeLine("fs.copy(\"disk/VonNeumann.lua\", \"startup\")")

  if hasSecondaryFunction then
    commandstring = "fs.copy(\"disk/" .. secondaryFunction .. "\", \"" .. secondaryFunction .. "\")"
    startFile.writeLine(commandstring)
    startFile.writeLine("shell.run(\"startup\", \"" .. secondaryFunction .. "\")") --Please disable for limited-expansion testing
  else
    startFile.writeLine("shell.run(\"startup\")") --Please disable for limited-expansion testing
  end

  --startFile.writeLine("shell.run(\"refuel\", \"all\")") --Please enable for limited-expansion testing
  --startFile.writeLine("for i = 1, 16 do turtle.forward() end") --Please enable for limited-expansion testing
  
  startFile.close()

  for i = 1, 3 do turtle.up() end

  for i = 1, 16 do
    turtle.select(i)
    turtle.dropUp()
  end

  turtle.select(oldSlot)
end

--This function finds some coal blocks and uses up to n of them to refuel itself
local function refuel(n)
  local item
  local oldSlot = turtle.getSelectedSlot()

  for i = 1, 16 do
    item = turtle.getItemDetail(i)
    if item and item.name == "minecraft:coal_block" then
      turtle.select(i)
      turtle.refuel(n)
      break
    end
  end

  turtle.select(oldSlot)
end

--This function refills the item copier
local function refillCopier()
  local coal = "minecraft:coal_block"

  while turtle.suckUp() do end
  turtle.down()
  redstone.setOutput("front", true)
  while turtle.suck() do end
  dropAt(coal, 5)
  dropAt(coal, 4)
  dropAt(coal, 3)
  dropAt(coal, 2)
  selectItem(coal)
  turtle.drop(28)
  redstone.setOutput("front", false)
  turtle.up()
  
  local needCoal = true
  local item
  for i = 16, 1, -1 do
    item = turtle.getItemDetail(i)
    if item and item.name == coal and needCoal then
      turtle.select(i)
      turtle.transferTo(11)
      if turtle.getItemCount(11) >= 64 then
        needCoal = false
      end
    elseif item
      turtle.select(i)
      turtle.dropUp()
    end
  end

  turtle.select(1)

  local strikes = 0
  while strikes < 3 do
    while turtle.craft() do
      while turtle.getItemCount() > 0 do
        turtle.drop()
        if turtle.getItemCount() > 0 then
          strikes = strikes + 1
          os.sleep(2)
        end
      end
    end

    if strikes < 3 then
      turtle.down()
      turtle.down()

    
      while turtle.getItemCount() < 64 do
        turtle.suck()
      end
    

      if turtle.getFuelLevel() < 100 then
        refuel(32)
      end

      turtle.transferTo(11)

      turtle.up()
      turtle.up()
    end
  end
end

--This function uses the item copier to make a new stack of the specified item
local function makeStack(name)
  redstone.setOutput("front", true)
  while turtle.suck() do end
  dropAt(name, 5)
  dropAt(name, 4)
  dropAt(name, 3)
  dropAt(name, 2)
  selectItem(name)
  turtle.drop()
  redstone.setOutput("front", false)

  turtle.down()
  while not turtle.suck() do
    os.sleep(1)
  end
  while not selectItem(name) do
    turtle.suck()
  end
  while turtle.getItemCount() < 64 do
    turtle.suck()
  end
end

--This function makes a turtle, places it, and fills it with everything it needs to make more turtles
local function buildTurtle()
  local paper = "minecraft:paper"
  local redstone = "minecraft:redstone"
  local hopper = "minecraft:hopper"
  local chest = "minecraft:chest"
  local coal_block = "minecraft:coal_block"
  local disk_drive = "computercraft:CC-Peripheral"
  local turtle_item = "computercraft:CC-TurtleAdvanced"

  local item_load = {paper, redstone, hopper, chest, coal_block, disk_drive}

  while turtle.suckUp() do end
  turtle.down()

  makeStack(turtle_item)
  selectItem(turtle_item)
  turtle.placeDown()
  turtle.dropDown()
  turtle.up()

  for i, name in pairs(item_load) do
    makeStack(name)
    selectItem(name)
    turtle.dropDown()
    turtle.up()
  end

  makeStack(coal_block)
  selectItem(coal_block)
  turtle.dropDown()

  peripheral.call("bottom", "turnOn")

  turtle.up()
  turtle.up()
end

--Program start
local tArgs = { ... }
if #tArgs >= 1 then
  secondaryFunction = tArgs[1]
  hasSecondaryFunction = true
  if not fs.exists(secondaryFunction) then
    print("The program " .. secondaryFunction .. " does not exist on this turtle.")
    error()
  end
end

local items = getItems()
if not fs.exists("built") and not (items["minecraft:paper"] and items["minecraft:redstone"] and
        items["minecraft:hopper"] and items["minecraft:chest"] and
        items["minecraft:coal_block"] and items["computercraft:CC-Peripheral"] and
        items["computercraft:CC-TurtleAdvanced"]) then
  print("Paper, redstone, hoppers, chests, coal blocks, disk drives, and advanced turtles required to operate.")
  error()
end

if not fs.exists("built") then
  if turtle.getFuelLevel() < 500 then refuel(64) end
  travel()
  buildCopier()
  local built = fs.open("built", "w")
  built.write("built")
  built.close()
else
  if turtle.getFuelLevel() < 50 then refuel(16) end
  orient()
end

for i = 1, 4 do
  refillCopier()
  buildTurtle()
end

if hasSecondaryFunction then
  orient()
  fs.delete("startup")
  fs.copy(secondaryFunction, "startup")
  shell.run("startup")
end