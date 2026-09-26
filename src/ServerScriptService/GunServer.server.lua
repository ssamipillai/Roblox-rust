local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage:WaitForChild("Events")
local gunShotEvent = Events:WaitForChild("GunShotEvent")

local MAX_DISTANCE = 1000
local DAMAGE = 25

gunShotEvent.OnServerEvent:Connect(function(player, hitInstance, hitPosition)
    local character = player.Character
    if not character or not character:FindFirstChild("Head") then return end
    
    -- Validate distance (prevent exploiters from firing across the whole map instantly)
    local distance = (character.Head.Position - hitPosition).Magnitude
    if distance > MAX_DISTANCE then 
        warn(player.Name .. " fired a bullet beyond the max distance threshold.")
        return 
    end
    
    -- Optional Server-side Raycast verification could go here for absolute security.
    
    if hitInstance then
        local targetModel = hitInstance:FindFirstAncestorOfClass("Model")
        if targetModel then
            local humanoid = targetModel:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- Make sure we aren't shooting ourselves
                local targetPlayer = game:GetService("Players"):GetPlayerFromCharacter(targetModel)
                if targetPlayer == player then return end
                
                -- Deal damage
                humanoid:TakeDamage(DAMAGE)
                
                -- If they died, the SurvivalManager will handle the Loot Bag drop,
                -- but we can log the kill here.
                if humanoid.Health <= 0 then
                    print("[KILL FEED]: " .. player.Name .. " eliminated " .. targetModel.Name .. " with a Rifle!")
                end
            end
        end
    end
end)
