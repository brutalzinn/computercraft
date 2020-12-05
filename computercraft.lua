local mystring = "BB"
local chars = { }

function checkfuel()
turtle.select(1)
if turtle.refuel(0) then
local halfStack = math.ceil(turtle.getItemCount(i)/2)
end
end

for i = 1, #mystring do
chars[#chars + 1] = mystring:sub(i,i)
vetor = chars[#chars]
if vet == "L" then
turtle.turnLeft()
end
if vet == "R" then
turtle.turnRight()
end
if vet == "F" then
checkrefuel()
turtle.forward()
end
if vet == "B" then
checkfuel()
turtle.back()
end
end