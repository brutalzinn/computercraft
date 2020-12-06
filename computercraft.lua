local mystring = "RFFF"
local chars = { }
local backchar = { }
local waiting = false
function checkfuel()
turtle.select(1)
if turtle.refuel(0) then
turtle.refuel(1)
end
end
function startMove()
for i = 1, #mystring do
chars[#chars + 1] = mystring:sub(i,i)
vetor = chars[#chars]
if vet == "L" then
checkfuel()
turtle.turnLeft()
end

if vet == "R" then
checkfuel()
turtle.turnRight()
end

if vet == "F" then
checkfuel()
turtle.forward()
end

if vet == "B" then
checkfuel()
turtle.back()
end

end
end
function backHome()
local backstring = string.reverse(mystring)
for i = 1, #backstring do
backchar[#backchar + 1] = backstring:sub(i,i)
if vet == "L" then
checkfuel()
turtle.turnLeft()

if i == 1 then
checkfuel()
turtle.turnLeft()
end
end
if vet == "R" then
checkfuel()
turtle.turnRight()

if i == 1 then
turtle.turnRight()
end
end

if vet == "F" then

checkfuel()
turtle.back()

end
if vet == "B" then
checkfuel()
turtle.forward()
end

end
end
function selectItem(name)
   -- check all inventory slots
   local item
   for slot = 1, 16 do
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
   return false -- couldn't find empty space
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
WaitForge()
startMove()
turtle.drop()
backHome()
 os.sleep(3)

end
end
end
init()