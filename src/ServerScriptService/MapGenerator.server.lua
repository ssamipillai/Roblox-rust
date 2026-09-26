local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Templates = ReplicatedStorage:WaitForChild("Templates")
local treeTemplate = Templates:WaitForChild("TreeTemplate")
local rockTemplate = Templates:WaitForChild("RockTemplate")

local MAP_SIZE = 500
local MIN_X, MAX_X = -250, 250
local MIN_Z, MAX_Z = -250, 250
local RAYCAST_HEIGHT = 500

local NUM_TREES = 50
local NUM_ROCKS = 30
local MIN_PROXIMITY = 8 -- Minimum distance between objects

local placedPositions = {}

local function isValidPosition(pos)
    for _, existingPos in ipairs(placedPositions) do
        if (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(existingPos.X, 0, existingPos.Z)).Magnitude < MIN_PROXIMITY then
            return false
        end
    end
    return true
end

local function spawnNode(template, count)
    local spawnedCount = 0
    local attempts = 0
    local maxAttempts = count * 10
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    -- Assume we spawn on the baseplate or terrain
    raycastParams.FilterDescendantsInstances = {workspace.Terrain, workspace:FindFirstChild("Baseplate")}
    
    while spawnedCount < count and attempts < maxAttempts do
        attempts = attempts + 1
        
        local randX = math.random(MIN_X, MAX_X)
        local randZ = math.random(MIN_Z, MAX_Z)
        
        local rayOrigin = Vector3.new(randX, RAYCAST_HEIGHT, randZ)
        local rayDirection = Vector3.new(0, -RAYCAST_HEIGHT * 2, 0)
        
        local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if result and result.Instance then
            if isValidPosition(result.Position) then
                local newNode = template:Clone()
                
                -- Adjust Y offset depending on if it's a Model or Part
                local offset = newNode:IsA("Model") and newNode:GetExtentsSize().Y / 2 or newNode.Size.Y / 2
                local finalPos = result.Position + Vector3.new(0, offset, 0)
                
                if newNode:IsA("Model") then
                    newNode:PivotTo(CFrame.new(finalPos))
                else
                    newNode.CFrame = CFrame.new(finalPos)
                end
                
                newNode.Parent = workspace
                table.insert(placedPositions, finalPos)
                spawnedCount = spawnedCount + 1
                
                -- Initialize health attributes for ResourceManager
                if template.Name == "TreeTemplate" then
                    newNode:SetAttribute("TreeHealth", 5)
                end
            end
        end
    end
    print("MapGenerator: Spawned " .. spawnedCount .. "/" .. count .. " " .. template.Name)
end

-- Wait a frame to ensure the baseplate or terrain is loaded
task.wait(1)
print("MapGenerator: Starting procedural generation...")
spawnNode(treeTemplate, NUM_TREES)
spawnNode(rockTemplate, NUM_ROCKS)
print("MapGenerator: Finished map generation.")
