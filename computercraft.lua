rednet.open("right")
while true do
local sender,message, protocol = rednet.receive()
print("Solicitação de " .. message)
redstone.setOutput("left",true)
end
end