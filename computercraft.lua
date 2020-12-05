os.loadAPI("nav")
rednet.open("right")
messaging = false


local function Pickup()
        NAVIGATOR.TurnRight(NAVIGATOR.GetDirectionINT("west"))  --facing +z
        turtle.suck(64)
end

local function Drop()     
        NAVIGATOR.TurnRight(NAVIGATOR.GetDirectionINT("west"))  --facing +z
        turtle.drop(64)
end

local function MoveToSlot(slot)
        x, y, z, direction = NAVIGATOR.GetPosition()
  
        dist = math.abs(slot - z)
  
        --print("Moveto " .. slot .. " from " .. z .. " dist: " .. dist)
        if(slot > z) then
                --print("N")
                NAVIGATOR.TurnRight(0)
                NAVIGATOR.Forward(dist)
        elseif(slot < z) then
                --print("S")
                NAVIGATOR.TurnRight(2)
                NAVIGATOR.Forward(dist)
        end
end

local function Dump()
        detail = turtle.getItemDetail(1)
  
        if(detail) then
                MoveToSlot(-8)
                Drop()
        end
end

local function DoStack(stack)
        Pickup()
        Dump()
        MoveToSlot(stack)
  
        NAVIGATOR.Up(1)
        Pickup()
        NAVIGATOR.Down(1)
        Dump()
        MoveToSlot(stack)
  
        NAVIGATOR.Down(1)
        Pickup()
        NAVIGATOR.Up(1)
        Dump()
        MoveToSlot(stack)
end

-- Reset Position
-- Initialize Navigator
if (NAVIGATOR.InitializeNavigator()) then
        --print("Navigator file found, resetting position.")
  
        x, y, z, direction = NAVIGATOR.GetPosition()
        -- First Y:
        if (y > 0) then
                --print("Moving down.")
                NAVIGATOR.Down(y)
        elseif (y < 0) then
                --print("Moving up.")
                NAVIGATOR.Up(-y)
        else
                --print("Vertical is fine.")
        end
  
        -- Now Z:
        if(z > 0) then
                --print("Moving north.")
                -- Turn to positive z and move.
                NAVIGATOR.TurnRight(2)  --facing -z  
        elseif(z < 0) then
                --print("Moving south.")
                -- Turn to negative z and move.  
                NAVIGATOR.TurnRight(0)  --facing +z  
        end
                NAVIGATOR.Forward(math.abs(z))
  
        -- X is not needed as the unit only moves in one line.
else
        --print("Resetting navigator")
        NAVIGATOR.SetPosition(0, 0, 0, 0)
end

while true do
        DoStack(0)
        os.sleep(1)
  
        DoStack(-3)
        os.sleep(1)
  
        DoStack(-6)
        os.sleep(1)
end
