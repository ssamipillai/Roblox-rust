local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Events = ReplicatedStorage:WaitForChild("Events")
local placeWallEvent = Events:WaitForChild("PlaceWallEvent")

local WallDataStore = DataStoreService:GetDataStore("PlayerBaseWalls_V1")
local MAX_PLACEMENT_DISTANCE = 50
local GRID_SIZE = 4

-- A folder to hold placed objects cleanly in the Workspace
local PlacedObjects = Instance.new("Folder")
PlacedObjects.Name = "PlacedObjects"
PlacedObjects.Parent = workspace

local function snapToGrid(value, gridSize)
    return math.round(value / gridSize) * gridSize
end

-- 1. SERVER PLACEMENT VALIDATION
local WALL_WOOD_COST = 20

placeWallEvent.OnServerEvent:Connect(function(player, targetPosition)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local distance = (character.HumanoidRootPart.Position - targetPosition).Magnitude
    if distance > MAX_PLACEMENT_DISTANCE then
        warn("Player " .. player.Name .. " tried to place a wall too far away! (Exploit prevention)")
        return
    end
    
    -- Check Leaderstats for Wood Cost
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    local wood = leaderstats:FindFirstChild("Wood")
    if not wood or wood.Value < WALL_WOOD_COST then
        -- Optional: Fire a RemoteEvent back to the client to show "Insufficient Resources"
        warn(player.Name .. " tried to build without enough wood.")
        return
    end
    
    -- Deduct Wood
    wood.Value = wood.Value - WALL_WOOD_COST
    
    -- Re-validate grid mathematically on server to prevent floating point exploits
    local snappedX = snapToGrid(targetPosition.X, GRID_SIZE)
    local snappedZ = snapToGrid(targetPosition.Z, GRID_SIZE)
    local finalPosition = Vector3.new(snappedX, targetPosition.Y, snappedZ)
    
    -- Create the permanent wall
    local newWall = Instance.new("Part")
    newWall.Name = "PlayerWall"
    newWall.Size = Vector3.new(10, 1, 10)
    newWall.Position = finalPosition
    newWall.Anchored = true
    newWall.Material = Enum.Material.Wood
    newWall.BrickColor = BrickColor.new("Brown")
    
    -- Tag with owner info for saving later
    newWall:SetAttribute("OwnerId", player.UserId)
    newWall.Parent = PlacedObjects
end)

-- 2. DATASTORE LOADING & LEADERSTATS SETUP
Players.PlayerAdded:Connect(function(player)
    -- Leaderstats Setup
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local woodStat = Instance.new("IntValue")
    woodStat.Name = "Wood"
    woodStat.Value = 0 -- Default starting wood
    woodStat.Parent = leaderstats

    local success, savedWalls = pcall(function()
        return WallDataStore:GetAsync(tostring(player.UserId))
    end)
    
    if success and savedWalls then
        for _, wallData in ipairs(savedWalls) do
            local newWall = Instance.new("Part")
            newWall.Name = "PlayerWall"
            newWall.Size = Vector3.new(10, 1, 10)
            -- Load coordinates
            newWall.Position = Vector3.new(wallData.X, wallData.Y, wallData.Z)
            newWall.Anchored = true
            newWall.Material = Enum.Material.Wood
            newWall.BrickColor = BrickColor.new("Brown")
            newWall:SetAttribute("OwnerId", player.UserId)
            newWall.Parent = PlacedObjects
        end
        print("Loaded base for " .. player.Name)
    elseif not success then
        warn("Failed to load base for " .. player.Name)
    end
end)

-- 3. DATASTORE SAVING
Players.PlayerRemoving:Connect(function(player)
    local wallsToSave = {}
    
    for _, wall in ipairs(PlacedObjects:GetChildren()) do
        if wall:GetAttribute("OwnerId") == player.UserId then
            table.insert(wallsToSave, {
                X = wall.Position.X,
                Y = wall.Position.Y,
                Z = wall.Position.Z
            })
            -- Optional: Despawn their base when they leave. We will destroy it to keep the map clean.
            wall:Destroy()
        end
    end
    
    local success, err = pcall(function()
        WallDataStore:SetAsync(tostring(player.UserId), wallsToSave)
    end)
    
    if success then
        print("Saved base for " .. player.Name)
    else
        warn("Failed to save base for " .. player.Name .. ": " .. tostring(err))
    end
end)
