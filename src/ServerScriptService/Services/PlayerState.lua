local Players = game:GetService("Players")

local PlayerState = {}

function PlayerState:Initialize(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local wood = Instance.new("IntValue")
    wood.Name = "Wood"
    wood.Value = 0
    wood.Parent = leaderstats

    player:SetAttribute("Hunger", 100)
    player:SetAttribute("Thirst", 100)
end

function PlayerState:GetWood(player)
    local stats = player:FindFirstChild("leaderstats")
    local wood = stats and stats:FindFirstChild("Wood")
    return wood
end

return PlayerState
