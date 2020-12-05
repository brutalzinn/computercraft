local direction = 0

local function GetXFromDirection()
        if              (direction == 1)                 then    return -1
        elseif   (direction == 3)               then     return 1
        else                                                                     return 0
        end
end

local function GetZFromDirection()
        if              (direction == 0)                 then    return 1
        elseif   (direction == 2)               then     return -1
        else                                                                     return 0
        end
end

local x = 0
local y = 0
local z = 0

-- Save direction and coordinates to file.
local function Store()
        local h = fs.open("location", "w")
        h.writeLine(x)
        h.writeLine(y)
        h.writeLine(z)
        h.writeLine(direction)
        h.close()
end

-- Reads direction and coordinates from file.
local function Read()   
        if fs.exists("location") then
                local h = fs.open("location", "r")
                x                       = tonumber(h.readLine())
                y                       = tonumber(h.readLine())
                z                       = tonumber(h.readLine())
                direction       = tonumber(h.readLine())
                h.close()
                
                return true
        end
        
        return false
end

function moveBackOnce()
        -- Try and move.
        moved = turtle.back()
        -- If move success increment coordinates.
        if(moved) then
                x = x - GetXFromDirection()
                z = z - GetZFromDirection()
                
                Store()
        end
        
        return moved
end

function moveForwardOnce()
        -- Try and move.
        moved = turtle.forward()
        -- If move success increment coordinates.
        if(moved) then
                x = x + GetXFromDirection()
                z = z + GetZFromDirection()
                
                Store()
        end
                return moved
end

-- Turn Right.
local function TurnLeftOnce()
        if(direction > 0) then
                direction = direction - 1
        else
                direction = 3
        end
        
        turtle.turnLeft()
                
        Store()
end

-- Turn Left.
local function TurnRightOnce()
        if(direction < 3) then
                direction = direction + 1
        else
                direction = 0
        end
        
        turtle.turnRight()

        Store()
end

-- Move up.
local function moveUpOnce()
        moved = turtle.up()
        
        if(moved) then
                y = y + 1
                
                Store()
        end
        
        return moved
end

-- Move down.
local function moveDownOnce()
        moved = turtle.down()
        
        if(moved) then
                y = y - 1
                
                Store()
        end
        
        return moved
end

-- =======================================================================================================================================================
-- Public API
-- =======================================================================================================================================================
-- Initalization:
-- =======================================================================================================================================================
-- Sets the position and heading of the turtle. Use for initialization.
-- FACING:
--[[
        0 = South
        1 = West
        2 = North
        3 = East
--]]
function SetPosition(X, Y, Z, FACING)
        x                       = X
        y                       = Y
        z                       = Z
        direction       = FACING
        Store()
end

-- Initializes the navigator from file backed storage.
function InitializeNavigator()
        return Read()
end

-- Prints the direction enumeration in a user readable format.
function PrintDirections()
        print("0 = South")
        print("1 = West")
        print("2 = North")
        print("3 = East")       
end

-- Takes N, S, E, W and converts it to numbers.
function GetDirectionINT(dir)
        dir = string.lower(dir)

        if(dir == "s") or (dir == "south")       then return 0 end
        if(dir == "n") or (dir == "north")      then return 2 end
        if(dir == "e") or (dir == "east")         then return 3 end
        if(dir == "w") or (dir == "west")        then return 1 end
end

-- Returns the current position of the turtle.
function GetPosition()
        Read()
        return x, y, z, direction
end
-- =======================================================================================================================================================
-- Rotation:
-- =======================================================================================================================================================

-- Turns left.
-- Goal (optinal): The target heading to turn toward.
-- Returns if movement succesfull.
function TurnLeft( goal )
        goal = goal or "T"
                
        if(goal == "T") then
                TurnLeftOnce()
        else
                while (direction ~= goal) do
                        TurnLeftOnce()
                end
        end
end

-- Turns right.
-- Goal (optinal): The target heading to turn toward.
-- Returns if movement succesfull.
function TurnRight( goal )
        goal = goal or "T"
        --print(goal .. " : " .. direction)
        
        if(goal == "T") then
                TurnRightOnce()
        else
                while (direction ~= goal) do
                        --print(goal .. " : " .. direction)
                        TurnRightOnce()
                end
        end
end
-- =======================================================================================================================================================
-- Moving:
-- =======================================================================================================================================================
local function Navigate(mainMovementFunction, resetMovementFunction, goal)
        goal = goal or "T"
        steps = 0
        
        -- If no steps required return true.
        if(goal == 0) then return true end
        
        -- If only a single step is required than do it.
        if(goal == "T") then return mainMovementFunction() end
        
        -- Try and move to the target position
        moved = false
        while goal > steps do
                moved = mainMovementFunction()
                
                if(moved == true) then
                        steps = steps + 1
                else
                        -- If cant move reset
                        while steps > 0 do
                                resetMovementFunction()
                                steps = steps - 1
                        end
                        -- And break out of the movement loop
                        return false
                end
        end
        
        return true
end

-- Moves Up and returns if succesfull.
-- Goal (optinal): Number of steps taken. If movement is obstructed turtle will reset to its starting position.
-- Returns if movement succesfull.
function Up(goal)
        return Navigate(moveUpOnce, moveDownOnce, goal)
end

-- Moves Down and returns if succesfull.
-- Goal (optinal): Number of steps taken. If movement is obstructed turtle will reset to its starting position.
-- Returns if movement succesfull.
function Down(goal)
        return Navigate(moveDownOnce, moveUpOnce, goal)
end

-- Moves back and returns if succesfull.
-- Goal (optinal): Number of steps taken. If movement is obstructed turtle will reset to its starting position.
-- Returns if movement succesfull.
function Back(goal)
        return Navigate(moveBackOnce, moveForwardOnce, goal)
end

-- Moves forward and returns if succesfull.
-- Goal (optinal): Number of steps taken. If movement is obstructed turtle will reset to its starting position.
-- Returns if movement succesfull.
function Forward(goal)
        return Navigate(moveForwardOnce, moveBackOnce, goal)
end

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
  
       local x, y, z, direction = NAVIGATOR.GetPosition()
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
