local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local tool = script.Parent

local Events = ReplicatedStorage:WaitForChild("Events")
local gunShotEvent = Events:WaitForChild("GunShotEvent")

local FIRE_RATE = 0.2
local canFire = true

-- Visual Hitscan Tracer
local function createTracer(origin, targetPos)
    local distance = (targetPos - origin).Magnitude
    local tracer = Instance.new("Part")
    tracer.Name = "BulletTracer"
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.Size = Vector3.new(0.1, 0.1, distance)
    tracer.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -distance / 2)
    tracer.Material = Enum.Material.Neon
    tracer.BrickColor = BrickColor.new("New Yeller")
    tracer.Parent = workspace
    
    -- Destroys the part safely after 0.1 seconds to prevent lag
    Debris:AddItem(tracer, 0.1)
end

tool.Activated:Connect(function()
    if not canFire then return end
    canFire = false
    
    local character = player.Character
    if not character or not character:FindFirstChild("Head") then return end
    
    -- Using the Camera as the origin for accurate crosshair shooting
    local origin = workspace.CurrentCamera.CFrame.Position
    local targetPosition = mouse.Hit.Position
    local direction = (targetPosition - origin).Unit
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(origin, direction * 1000, raycastParams)
    
    local hitInstance = nil
    local hitPos = origin + (direction * 1000)
    
    if result then
        hitInstance = result.Instance
        hitPos = result.Position
    end
    
    -- Show client-side tracer starting from character's head/gun
    local tracerOrigin = character:FindFirstChild("RightHand") and character.RightHand.Position or character.Head.Position
    createTracer(tracerOrigin, hitPos)
    
    -- Transmit Hitscan event to the server
    gunShotEvent:FireServer(hitInstance, hitPos)
    
    task.wait(FIRE_RATE)
    canFire = true
end)
