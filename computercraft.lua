local mystring = "RFFF"
local baseString = "RRR"
local chars = { }
local backchar = { }
local rechar = { }
local waiting = false

function checkIfFuel()
  return turtle.refuel(0)
end
function checkfuel()
 local fuelLimit = turtle.getFuelLimit()
  while true do
    if turtle.getFuelLevel() < fuelLimit / 4 then
      -- if the fuel level is less than a quarter of a tank...
      -- find an item that we can use as fuel
      for i = 1, 16 do
        -- for every slot in the inventory, do...
        turtle.select(i)
        if checkIfFuel() then
          -- if inventory[i] is a fuel, then...
          turtle.refuel()
          -- refuel by consuming the whole stack
        end
      end
    end
    os.sleep(someDelayTime)
  end
end
function startMove()
for i = 1, #mystring do
chars[#chars + 1] = mystring:sub(i,i)
vetor = chars[#chars]
if vetor == "L" then

turtle.turnLeft()
end

if vetor == "R" then

turtle.turnRight()
end

if vetor == "F" then

turtle.forward()
end

if vetor == "B" then

turtle.back()
end

end
end
function backHome()
local backstring = string.reverse(mystring)
for i = 1, #backstring do
backchar[#backchar + 1] = backstring:sub(i,i)
vetor = backchar[#backchar]
if vetor == "L" then

turtle.turnRight()

end
if vetor == "R" then

turtle.turnLeft()

end

if vetor == "F" then


turtle.back()

end
if vetor == "B" then

turtle.forward()
end

end
end
function selectItem(name)
   -- check all inventory slots
   local item
   for slot = 2, 16 do
     item = turtle.getItemDetail(slot)
     if item ~= nil and item['name'] == name then
       turtle.select(slot)
       return true
    end
   end

  return false  -- couldn't find item
 end
  function selectEmptySlot()
   -- loop through all slots
   for slot = 1, 16 do  
     if turtle.getItemCount(slot) == 0 then
       turtle.select(slot)
       return true
     end
  end
   return false
 end
 function ChargeBase()
for i = 1, #baseString do
rechar[#rechar + 1] = baseString:sub(i,i)
vetor = rechar[#rechar]
if vetor == "L" then

turtle.turnLeft()
end

if vetor == "R" then

turtle.turnRight()
end

if vetor == "F" then

turtle.forward()
end

if vetor == "B" then

turtle.back()
end

end
end
function NeedChargeBase()
    if turtle.getFuelLevel() < 10 then
ChargeBase()
turtle.suck()
end
function WaitForge()
repeat
turtle.suck()
 until turtle.suck() == true
 end
function init()
rednet.open("right")
while true do
local sender, message, protocol = rednet.receive()

for i=1, tonumber(message) do 
checkfuel()
WaitForge()
startMove()
selectItem("Cobalt Sharpening Kit")
turtle.drop()
backHome()
NeedChargeBase()
 os.sleep(3)
end
end
end


init()