local tool = script.Parent
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local event = ReplicatedStorage.Events.GunShotEvent
local lastShot = 0

local function tracer(from, to)
    local part = Instance.new("Part")
    part.Anchored, part.CanCollide, part.CanQuery = true, false, false
    part.Material = Enum.Material.Neon
    part.Size = Vector3.new(0.05, 0.05, (to - from).Magnitude)
    part.CFrame = CFrame.lookAt((from + to) / 2, to)
    part.Parent = workspace
    task.delay(0.1, function() part:Destroy() end)
end

tool.Activated:Connect(function()
    if os.clock() - lastShot < 0.15 then return end
    lastShot = os.clock()
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = camera.CFrame.LookVector * 500
    local result = workspace:Raycast(origin, direction)
    local hitPosition = result and result.Position or origin + direction
    tracer(origin, hitPosition)
    event:FireServer(result and result.Instance or nil, hitPosition)
end)
