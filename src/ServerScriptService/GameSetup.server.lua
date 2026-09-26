-- GameSetup.server.lua
-- This ensures all required Folders and RemoteEvents exist so we don't have to manually create them in Studio.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Ensure Events folder exists
local Events = ReplicatedStorage:FindFirstChild("Events")
if not Events then
    Events = Instance.new("Folder")
    Events.Name = "Events"
    Events.Parent = ReplicatedStorage
end

-- 2. Ensure specific RemoteEvents exist
local requiredEvents = {
    "PlaceWallEvent",
    "RequestCraftItem",
    "HitResourceEvent",
    "GunShotEvent"
}

for _, eventName in ipairs(requiredEvents) do
    if not Events:FindFirstChild(eventName) then
        local event = Instance.new("RemoteEvent")
        event.Name = eventName
        event.Parent = Events
    end
end

-- 3. Ensure Templates folder exists
local Templates = ReplicatedStorage:FindFirstChild("Templates")
if not Templates then
    Templates = Instance.new("Folder")
    Templates.Name = "Templates"
    Templates.Parent = ReplicatedStorage
end

print("Atlas Agent: Game Setup Complete - Folders and RemoteEvents successfully provisioned.")
