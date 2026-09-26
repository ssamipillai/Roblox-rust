local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

local TICK_RATE = 10
local HUNGER_DROP = 1
local THIRST_DROP = 2
local STARVATION_DAMAGE = 5
local STARVATION_RATE = 2

-- Framework function for other scripts to use (e.g., when eating food)
_G.addResources = function(player, resourceType, amount)
    if resourceType == "Hunger" then
        local current = player:GetAttribute("Hunger") or 100
        player:SetAttribute("Hunger", math.clamp(current + amount, 0, 100))
    elseif resourceType == "Thirst" then
        local current = player:GetAttribute("Thirst") or 100
        player:SetAttribute("Thirst", math.clamp(current + amount, 0, 100))
    end
end

-- Survival loop logic
local function startSurvivalLoop(player, character)
    local humanoid = character:WaitForChild("Humanoid")
    local isAlive = true
    
    humanoid.Died:Connect(function()
        isAlive = false
    end)
    
    task.spawn(function()
        while isAlive and player.Parent do
            task.wait(TICK_RATE)
            if not isAlive then break end
            
            local hunger = player:GetAttribute("Hunger") or 100
            local thirst = player:GetAttribute("Thirst") or 100
            
            hunger = math.max(0, hunger - HUNGER_DROP)
            thirst = math.max(0, thirst - THIRST_DROP)
            
            player:SetAttribute("Hunger", hunger)
            player:SetAttribute("Thirst", thirst)
            
            if hunger == 0 or thirst == 0 then
                -- Start starvation damage
                task.spawn(function()
                    while isAlive and (player:GetAttribute("Hunger") == 0 or player:GetAttribute("Thirst") == 0) do
                        humanoid:TakeDamage(STARVATION_DAMAGE)
                        task.wait(STARVATION_RATE)
                    end
                end)
            end
        end
    end)
end

-- Player death and Loot Drop Logic
local function handleDeath(player, character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Died:Connect(function()
        local leaderstats = player:FindFirstChild("leaderstats")
        if not leaderstats then return end
        
        local woodStat = leaderstats:FindFirstChild("Wood")
        if not woodStat or woodStat.Value <= 0 then return end
        
        local woodAmount = woodStat.Value
        woodStat.Value = 0 -- Reset dead player's wood
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        -- Spawn Loot Bag
        local lootBag = Instance.new("Part")
        lootBag.Name = player.Name .. "_LootBag"
        lootBag.Size = Vector3.new(2, 2, 2)
        lootBag.Position = rootPart.Position + Vector3.new(0, 1, 0)
        lootBag.Color = Color3.fromRGB(139, 69, 19)
        lootBag.Material = Enum.Material.Fabric
        lootBag.Anchored = false
        lootBag.CanCollide = true
        
        local prompt = Instance.new("ProximityPrompt")
        prompt.ActionText = "Loot Wood (" .. woodAmount .. ")"
        prompt.ObjectText = "Loot Bag"
        prompt.HoldDuration = 1
        prompt.MaxActivationDistance = 10
        prompt.Parent = lootBag
        
        prompt.Triggered:Connect(function(looter)
            local looterStats = looter:FindFirstChild("leaderstats")
            if looterStats then
                local looterWood = looterStats:FindFirstChild("Wood")
                if looterWood then
                    looterWood.Value = looterWood.Value + woodAmount
                    lootBag:Destroy() -- Consume the bag
                end
            end
        end)
        
        lootBag.Parent = workspace
        
        -- Cleanup bag after 5 minutes to prevent lag if unlooted
        Debris:AddItem(lootBag, 300)
    end)
end

Players.PlayerAdded:Connect(function(player)
    -- Initialize Attributes
    player:SetAttribute("Hunger", 100)
    player:SetAttribute("Thirst", 100)
    
    player.CharacterAdded:Connect(function(character)
        -- Reset attributes on spawn
        player:SetAttribute("Hunger", 100)
        player:SetAttribute("Thirst", 100)
        
        startSurvivalLoop(player, character)
        handleDeath(player, character)
    end)
end)
