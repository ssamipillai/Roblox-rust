local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local event = ReplicatedStorage.Events.PlaceWallEvent
local Config = require(ReplicatedStorage.Shared.Config)

local ghost = Instance.new("Part")
ghost.Name = "WallPreview"
ghost.Size = Config.Build.WallSize
ghost.Anchored = true
ghost.CanCollide = false
ghost.Transparency = 0.65
ghost.Parent = workspace

local function snap(v) return math.round(v / Config.Build.GridSize) * Config.Build.GridSize end

RunService.RenderStepped:Connect(function()
    local mouse = player:GetMouse()
    local hit = mouse.Hit
    local p = hit.Position
    ghost.Position = Vector3.new(snap(p.X), p.Y + 0.5, snap(p.Z))
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        event:FireServer(ghost.Position)
    end
end)
