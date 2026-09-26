local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local store = DataStoreService:GetDataStore(Config.Data.StoreName)

local DataService = {}

local function retry(fn)
    local lastError
    for attempt = 1, Config.Data.Retries do
        local ok, result = pcall(fn)
        if ok then return true, result end
        lastError = result
        task.wait(attempt)
    end
    return false, lastError
end

function DataService:SerializeWalls(player)
    local walls = {}
    for _, instance in workspace:GetChildren() do
        if instance:IsA("BasePart") and instance:GetAttribute("Owner") == player.UserId then
            local cf = instance.CFrame
            table.insert(walls, { p = {cf.Position.X, cf.Position.Y, cf.Position.Z}, r = {cf:ToOrientation()} })
        end
    end
    return { schemaVersion = Config.Data.SchemaVersion, walls = walls }
end

function DataService:Save(player)
    local payload = self:SerializeWalls(player)
    return retry(function()
        store:SetAsync(tostring(player.UserId), payload)
        return true
    end)
end

function DataService:Load(player)
    local ok, data = retry(function()
        return store:GetAsync(tostring(player.UserId))
    end)
    if not ok or typeof(data) ~= "table" then return false end
    local template = ReplicatedStorage.Templates:FindFirstChild("WallTemplate")
    if not template then return false end
    for _, wallData in ipairs(data.walls or {}) do
        local p, r = wallData.p, wallData.r
        if typeof(p) == "table" and #p == 3 and typeof(r) == "table" and #r == 3 then
            local wall = template:Clone()
            wall.CFrame = CFrame.new(p[1], p[2], p[3]) * CFrame.fromOrientation(r[1], r[2], r[3])
            wall:SetAttribute("Owner", player.UserId)
            wall.Parent = workspace
        end
    end
    return true
end

return DataService
