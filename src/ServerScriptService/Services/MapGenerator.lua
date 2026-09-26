local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Config = require(ReplicatedStorage.Shared.Config)

local MapGenerator = {}

local function clearExisting()
    for _, child in workspace:GetChildren() do
        if child:GetAttribute("GeneratedResource") then child:Destroy() end
    end
end

local function spawnNode(templateName, tag, count, existing)
    local template = ReplicatedStorage.Templates:FindFirstChild(templateName)
    if not template then return end
    local placed = 0
    local attempts = 0
    while placed < count and attempts < count * 20 do
        attempts += 1
        local x = math.random(-Config.Map.Size / 2, Config.Map.Size / 2)
        local z = math.random(-Config.Map.Size / 2, Config.Map.Size / 2)
        local hit = workspace:Raycast(Vector3.new(x, 300, z), Vector3.new(0, -600, 0))
        if hit and hit.Instance then
            local position = hit.Position
            local valid = true
            for _, other in existing do
                if (other - position).Magnitude < Config.Map.MinSpacing then valid = false break end
            end
            if valid then
                local node = template:Clone()
                if node:IsA("Model") then node:PivotTo(CFrame.new(position)) else node.Position = position end
                node:SetAttribute("GeneratedResource", true)
                if tag == "Tree" then node:SetAttribute("TreeHealth", Config.Resources.TreeHealth) end
                CollectionService:AddTag(node, tag)
                node.Parent = workspace
                table.insert(existing, position)
                placed += 1
            end
        end
    end
end

function MapGenerator:Generate()
    clearExisting()
    local existing = {}
    spawnNode("TreeTemplate", "Tree", Config.Map.Trees, existing)
    spawnNode("RockTemplate", "Rock", Config.Map.Rocks, existing)
end

return MapGenerator
