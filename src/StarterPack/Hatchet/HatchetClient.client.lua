local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local tool = script.Parent

local Events = ReplicatedStorage:WaitForChild("Events")
local hitResourceEvent = Events:WaitForChild("HitResourceEvent")

local canSwing = true
local SWING_COOLDOWN = 0.5
local REACH = 15

tool.Activated:Connect(function()
    if not canSwing then return end
    canSwing = false
    
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rayOrigin = character.HumanoidRootPart.Position
        local rayDirection = character.HumanoidRootPart.CFrame.LookVector * REACH
        
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if result and result.Instance then
            local hitPart = result.Instance
            -- The tree might be a Model or a single Part
            local targetTree = nil
            
            if hitPart:GetAttribute("TreeHealth") then
                targetTree = hitPart
            else
                local model = hitPart:FindFirstAncestorOfClass("Model")
                if model and model:GetAttribute("TreeHealth") then
                    targetTree = model
                end
            end
            
            if targetTree then
                hitResourceEvent:FireServer(targetTree)
            end
        end
    end
    
    task.wait(SWING_COOLDOWN)
    canSwing = true
end)
