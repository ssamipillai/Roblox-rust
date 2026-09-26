local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Config = require(ReplicatedStorage.Shared.Config)
local PlayerState = require(script.Parent.PlayerState)

local ResourceService = {}
local busy = {}

function ResourceService:Harvest(player, node)
    if typeof(node) ~= "Instance" or not node:IsDescendantOf(workspace) then return false end
    if not CollectionService:HasTag(node, "Tree") then return false end
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local primary = node:IsA("Model") and node.PrimaryPart or node
    if not root or not primary then return false end
    if (root.Position - primary.Position).Magnitude > Config.Resources.HarvestRange then return false end
    if busy[node] then return false end

    local health = node:GetAttribute("TreeHealth")
    if typeof(health) ~= "number" or health <= 0 then return false end
    node:SetAttribute("TreeHealth", health - 1)
    if health - 1 <= 0 then
        busy[node] = true
        local wood = PlayerState:GetWood(player)
        if wood then wood.Value += Config.Resources.WoodPerTree end
        node.Parent = nil
        task.delay(Config.Resources.RespawnSeconds, function()
            node:SetAttribute("TreeHealth", Config.Resources.TreeHealth)
            node.Parent = workspace
            busy[node] = nil
        end)
    end
    return true
end

return ResourceService
