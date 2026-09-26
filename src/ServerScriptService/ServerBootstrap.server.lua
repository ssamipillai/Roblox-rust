local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerState = require(script.Parent.Services.PlayerState)
local BuildingService = require(script.Parent.Services.BuildingService)
local ResourceService = require(script.Parent.Services.ResourceService)
local SurvivalService = require(script.Parent.Services.SurvivalService)
local LootService = require(script.Parent.Services.LootService)
local CombatService = require(script.Parent.Services.CombatService)
local DataService = require(script.Parent.Services.DataService)
local MapGenerator = require(script.Parent.Services.MapGenerator)

local Events = ReplicatedStorage:WaitForChild("Events")

MapGenerator:Generate()

Players.PlayerAdded:Connect(function(player)
    PlayerState:Initialize(player)
    task.spawn(function() DataService:Load(player) end)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then LootService:Create(player, root.Position) end
        end)
    end)
end)

Events.PlaceWallEvent.OnServerEvent:Connect(function(player, position)
    BuildingService:Place(player, position)
end)

Events.HitTreeEvent.OnServerEvent:Connect(function(player, node)
    ResourceService:Harvest(player, node)
end)

SurvivalService:Start()

Events.GunShotEvent.OnServerEvent:Connect(function(player, hitInstance, hitPosition)
    CombatService:Fire(player, hitInstance, hitPosition)
end)

Players.PlayerRemoving:Connect(function(player)
    DataService:Save(player)
end)

game:BindToClose(function()
    for _, player in Players:GetPlayers() do
        DataService:Save(player)
    end
end)
