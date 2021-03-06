--A script for a sorting turtle
os.loadAPI("common.lua")
local common = _G["common.lua"]

local tArgs = { ... }
if #tArgs ~= 1 or (#tArgs >= 1 and tArgs[1] == "help") then
  print("Usage: sorter <reciever_id>")
  return
end

local id = tonumber(tArgs[1])
local role = "Sorter "

local source = {5, 61, 199, 2}
local misc = {5, 61, 194, 1}
local trash = {5, 62, 194, 0}

local uncommonMinerals = {5, 63, 199, 1}
local commonMinerals = {5, 62, 199, 1}
local cobblestone = {5, 61, 199, 1}
local organics = {5, 63, 198, 1}
local dirt = {5, 62, 198, 1}
local stone = {5, 61, 198, 1}
local mobDrops = {5, 63, 197, 1}
local redstone = {5, 62, 197, 1}
local computers = {5, 61, 197, 1}
local building = {5, 63, 196, 1}
local tools = {5, 62, 196, 1}
local enchanting = {5, 61, 196, 1}
local dyes = {5, 63, 195, 1}
local potions = {5, 62, 195, 1}
local food = {5, 61, 195, 1}
local nether = {5, 63, 194, 1}

local fuel = {4, 61, 198, 3}
local smelt = {4, 62, 199, 3}
local cowFarm = {4, 61, 194, 3}
local flintMaker = trash --TODO, temp set to trash
local compressor =  misc --TODO, temp set to misc

local sortingKey = {
  ["minecraft:sapling"] = {organics, fuel},
  ["minecraft:wheat_seeds"] = {organics},
  ["minecraft:log"] = {organics, smelt},
  ["minecraft:wheat"] = {organics, cowFarm},
  ["minecraft:nether_wart"] = {potions, nether},

  ["minecraft:cobblestone"] = {cobblestone},
  ["minecraft:stone"] = {stone, building},
  ["minecraft:dirt"] = {dirt},
  ["minecraft:sand"] = {commonMinerals, smelt},
  ["minecraft:gravel"] = {commonMinerals, flintMaker},
  ["minecraft:flint"] = {commonMinerals},

  ["minecraft:coal"] = {fuel, uncommonMinerals},
  ["minecraft:redstone"] = {uncommonMinerals, compressor},
  ["minecraft:redstone_block"] = {uncommonMinerals},
  ["minecraft:obsidian"] = {uncommonMinerals},
  ["minecraft:diamond"] = {uncommonMinerals},
  ["minecraft:iron_ore"] = {smelt, uncommonMinerals},
  ["minecraft:iron_ingot"] = {uncommonMinerals},
  ["minecraft:gold_ore"] = {smelt, uncommonMinerals},
  ["minecraft:gold_ingot"] = {uncommonMinerals},
  ["minecraft:dye"] = {uncommonMinerals, enchanting, dyes},

  --["minecraft:"] = {},
}

local function take()
  if fd == 4 then
    return turtle.suckUp()
  elseif fd == 5 then
    return turtle.suckDown()
  else
    return turtle.suck()
  end
end

local function put(td)
  if td == 4 then
    return turtle.dropUp()
  elseif td == 5 then
    return turtle.dropDown()
  else
    return turtle.drop()
  end
end

local function goToLocation(location)
  common.goToLocation(location[1], location[2], location[3], location[4])
end

turtle.select(1)
local item
local destinations
local delivered

while true do
  if turtle.getFuelLevel() < 500 then
    common.sendLog(id, role .. os.computerLabel() .. " fuel low.")
  end

  item = turtle.getItemDetail()
  if item then
    if sortingKey[item.name] then
      destinations = sortingKey[item.name]
    else
      destinations = {misc}
    end

    delivered = false

    for i = 1, #destinations do
      goToLocation(destinations[i])
      put(destinations[i][4])
      if turtle.getItemCount() == 0 then
        delivered = true
        break
      end
    end

    if not delivered then
      goToLocation(trash)
      put(trash[4])
    end
  end

  goToLocation(source)

  while not take() do
    os.sleep(30)
  end
end 
