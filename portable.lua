rednet.open("back")
print("Digite a quantidade de kits de reparos de cobalto")
local read = read()
rednet.broadcast(read)