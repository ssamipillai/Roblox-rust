local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)

local CombatService = {}
local lastShot = {}

function CombatService:Fire(shooter, hitInstance, hitPosition)
    local now = os.clock()
    if now - (lastShot[shooter] or 0) < Config.Combat.FireCooldown then return false end
    lastShot[shooter] = now
    if typeof(hitPosition) ~= "Vector3" then return false end
    local character = shooter.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position - hitPosition).Magnitude > Config.Combat.RifleRange + 20 then return false end
    if typeof(hitInstance) ~= "Instance" then return false end
    local model = hitInstance:FindFirstAncestorOfClass("Model")
    local humanoid = model and model:FindFirstChildOfClass("Humanoid")
    local target = model and Players:GetPlayerFromCharacter(model)
    if humanoid and target and target ~= shooter then
        humanoid:TakeDamage(Config.Combat.RifleDamage)
        return true
    end
    return false
end

return CombatService
