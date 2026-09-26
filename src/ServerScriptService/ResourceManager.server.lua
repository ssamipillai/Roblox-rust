local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events")
local hitResourceEvent = Events:WaitForChild("HitResourceEvent")

local MAX_HARVEST_DISTANCE = 20
local RESPAWN_TIME = 10
local WOOD_GIVEN = 10

-- We assume MapGenerator will spawn trees, but for now we also initialize any manually placed ones.
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj.Name == "TreeTemplate" or obj:GetAttribute("IsTree") then
        if not obj:GetAttribute("TreeHealth") then
            obj:SetAttribute("TreeHealth", 5)
        end
    end
end

hitResourceEvent.OnServerEvent:Connect(function(player, resourceInstance)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- 1. Validate it's a valid resource
    local currentHealth = resourceInstance:GetAttribute("TreeHealth")
    if not currentHealth or currentHealth <= 0 then return end
    
    -- 2. Validate distance (Exploit prevention)
    local resourcePos = resourceInstance:IsA("Model") and resourceInstance:GetPivot().Position or resourceInstance.Position
    local distance = (character.HumanoidRootPart.Position - resourcePos).Magnitude
    
    if distance > MAX_HARVEST_DISTANCE then 
        warn(player.Name .. " tried to harvest a tree from too far away!")
        return 
    end
    
    -- 3. Damage tree
    currentHealth = currentHealth - 1
    resourceInstance:SetAttribute("TreeHealth", currentHealth)
    
    -- Optional: Play a hit sound or particle here via a separate RemoteEvent to all clients
    
    if currentHealth <= 0 then
        -- 4. Harvest complete
        resourceInstance.Parent = nil -- Hide it temporarily instead of destroying to respawn it
        
        -- Add Wood to leaderstats
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local wood = leaderstats:FindFirstChild("Wood")
            if wood then
                wood.Value = wood.Value + WOOD_GIVEN
            end
        end
        
        -- 5. Respawn logic
        task.delay(RESPAWN_TIME, function()
            resourceInstance:SetAttribute("TreeHealth", 5)
            resourceInstance.Parent = workspace
        end)
    end
end)
