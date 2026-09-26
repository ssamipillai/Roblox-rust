local tool = script.Parent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local event = ReplicatedStorage.Events.HitTreeEvent
local player = game.Players.LocalPlayer

tool.Activated:Connect(function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local closest, distance
    for _, node in CollectionService:GetTagged("Tree") do
        local part = node:IsA("Model") and node.PrimaryPart or node
        if part then
            local d = (root.Position - part.Position).Magnitude
            if d <= 15 and (not distance or d < distance) then closest, distance = node, d end
        end
    end
    if closest then event:FireServer(closest) end
end)
