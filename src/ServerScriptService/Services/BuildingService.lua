local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

local BuildingService = {}

local function snap(value)
    return math.round(value / Config.Build.GridSize) * Config.Build.GridSize
end

function BuildingService:ValidatePosition(player, position)
    if typeof(position) ~= "Vector3" then return false end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    if (root.Position - position).Magnitude > 40 then return false end
    if position.Y > root.Position.Y + Config.Build.MaxBuildHeight then return false end
    return true
end

function BuildingService:Snap(position)
    return Vector3.new(snap(position.X), position.Y, snap(position.Z))
end

function BuildingService:Place(player, position)
    if not self:ValidatePosition(player, position) then return false, "Invalid placement" end
    local wood = require(script.Parent.PlayerState):GetWood(player)
    if not wood or wood.Value < Config.Build.CostWood then return false, "Insufficient Resources" end
    local template = ReplicatedStorage.Templates:FindFirstChild("WallTemplate")
    if not template then return false, "Missing WallTemplate" end

    wood.Value -= Config.Build.CostWood
    local wall = template:Clone()
    wall.Position = self:Snap(position)
    wall:SetAttribute("Owner", player.UserId)
    wall.Parent = workspace
    return true, wall
end

return BuildingService
