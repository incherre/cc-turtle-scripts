--A turtle to sit and grow trees
os.loadAPI("common.lua")
local common = _G["common.lua"]

local function isSapling()
  local success, block = turtle.inspect()
  return success and block.name == "minecraft:sapling"
end

while true do
  while isSapling() do
    if not common.placeBlockFront() then
      print("Out of bonemeal!")
      break
    end
  end
  
  os.sleep(60)
end
