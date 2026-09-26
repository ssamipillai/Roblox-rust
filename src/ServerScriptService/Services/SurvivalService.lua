local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

local SurvivalService = {}

local function clamp(v) return math.clamp(v, 0, 100) end

function SurvivalService:AddResource(player, resourceType, amount)
    if resourceType ~= "Hunger" and resourceType ~= "Thirst" then return false end
    local current = player:GetAttribute(resourceType)
    if typeof(current) ~= "number" then return false end
    player:SetAttribute(resourceType, clamp(current + amount))
    return true
end

function SurvivalService:Start()
    task.spawn(function()
        while true do
            task.wait(Config.Survival.TickSeconds)
            for _, player in Players:GetPlayers() do
                if player.Parent then
                    player:SetAttribute("Hunger", clamp((player:GetAttribute("Hunger") or 100) - Config.Survival.HungerDecay))
                    player:SetAttribute("Thirst", clamp((player:GetAttribute("Thirst") or 100) - Config.Survival.ThirstDecay))
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(Config.Survival.DamageTickSeconds)
            for _, player in Players:GetPlayers() do
                local h, t = player:GetAttribute("Hunger"), player:GetAttribute("Thirst")
                if (h or 0) <= 0 or (t or 0) <= 0 then
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then humanoid:TakeDamage(Config.Survival.Damage) end
                end
            end
        end
    end)
end

return SurvivalService
