local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Fetch or wait for RemoteEvent
local Events = ReplicatedStorage:WaitForChild("Events")
local placeWallEvent = Events:WaitForChild("PlaceWallEvent")

local GRID_SIZE = 4
local isPlacing = false
local ghostWall = nil

-- Create a ghost wall for preview
local function createGhostWall()
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 1, 10)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.5
    part.BrickColor = BrickColor.new("Lime green")
    part.Material = Enum.Material.Neon
    part.Parent = Workspace
    return part
end

-- Math to snap a value to a grid
local function snapToGrid(value, gridSize)
    return math.round(value / gridSize) * gridSize
end

-- Raycast to find placement position
local function getPlacementPosition()
    local unitRay = mouse.UnitRay
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    -- Ignore the player and the ghost wall
    raycastParams.FilterDescendantsInstances = {player.Character, ghostWall}
    
    local raycastResult = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
    
    if raycastResult then
        local pos = raycastResult.Position
        
        -- Snap X and Z to the grid, keep Y relative to the hit position (could be terrain)
        local snappedX = snapToGrid(pos.X, GRID_SIZE)
        local snappedZ = snapToGrid(pos.Z, GRID_SIZE)
        
        -- The wall is 1 stud high, so we offset Y by 0.5 to rest exactly on the surface
        local finalY = raycastResult.Position.Y + 0.5
        
        return Vector3.new(snappedX, finalY, snappedZ)
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    -- Enable placing by default for Phase 1 testing
    isPlacing = true 
    
    if isPlacing then
        if not ghostWall then
            ghostWall = createGhostWall()
        end
        
        local placementPos = getPlacementPosition()
        if placementPos then
            ghostWall.Position = placementPos
        end
    else
        if ghostWall then
            ghostWall:Destroy()
            ghostWall = nil
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 and isPlacing and ghostWall then
        local placementPos = getPlacementPosition()
        if placementPos then
            -- Send placement request to server
            placeWallEvent:FireServer(placementPos)
        end
    end
end)
