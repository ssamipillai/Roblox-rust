local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local PlayerState = require(script.Parent.PlayerState)

local LootService = {}

function LootService:Create(player, position)
    local wood = PlayerState:GetWood(player)
    if not wood or wood.Value <= 0 then return end
    local bag = Instance.new("Part")
    bag.Name = "LootBag"
    bag.Size = Vector3.new(2, 1, 2)
    bag.Position = position + Vector3.new(0, 1, 0)
    bag.Anchored = true
    bag:SetAttribute("Wood", wood.Value)
    bag:SetAttribute("Claimed", false)
    bag.Parent = workspace

    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Loot"
    prompt.ObjectText = "Loot Bag"
    prompt.MaxActivationDistance = Config.Loot.ClaimRange
    prompt.Parent = bag
    wood.Value = 0

    prompt.Triggered:Connect(function(claimer)
        if bag:GetAttribute("Claimed") then return end
        if claimer == player then return end
        bag:SetAttribute("Claimed", true)
        local targetWood = PlayerState:GetWood(claimer)
        if targetWood then targetWood.Value += bag:GetAttribute("Wood") or 0 end
        bag:Destroy()
    end)
end

return LootService
