local mystring = "RFFF"
local rechargeBase = "RR"
local chars = { }
local backchar = { }
local rechar = { }
local waiting = false
function recharge()
for i = 1, #rechargeBase do
rechar[#rechar + 1] = rechargeBase:sub(i,i)
vetor = rechar[#rechar]
if vetor == "L" then
checkfuel()
turtle.turnLeft()
end

if vetor == "R" then
checkfuel()
turtle.turnRight()
end

if vetor == "F" then
checkfuel()
turtle.forward()
end

if vetor == "B" then
checkfuel()
turtle.back()
end

end

end
function checkfuel()
turtle.select(1)
if turtle.getFuelLevel() ~= "unlimited" and turtle.getFuelLevel() < 1 then
	if turtle.getItemCount(1) > 10 then
	turtle.refuel()
	else
	recharge()
	end
end
end
function startMove()
for i = 1, #mystring do
chars[#chars + 1] = mystring:sub(i,i)
vetor = chars[#chars]
if vetor == "L" then
checkfuel()
turtle.turnLeft()
end

if vetor == "R" then
checkfuel()
turtle.turnRight()
end

if vetor == "F" then
checkfuel()
turtle.forward()
end

if vetor == "B" then
checkfuel()
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
checkfuel()
turtle.turnRight()

end
if vetor == "R" then
checkfuel()
turtle.turnLeft()

end

if vetor == "F" then

checkfuel()
turtle.back()

end
if vetor == "B" then
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
   return false
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
selectItem("Cobalt Sharpening Kit")
turtle.drop()
backHome()
 os.sleep(3)
end
end
end
init()