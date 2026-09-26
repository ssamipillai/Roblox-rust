local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local Events = ReplicatedStorage:WaitForChild("Events")
local requestCraftItem = Events:WaitForChild("RequestCraftItem")

-- Create the UI completely via code so it runs instantly without manual Studio UI building
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InventoryScreen"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Layout: Inventory Grid Section
local inventoryGrid = Instance.new("Frame")
inventoryGrid.Name = "InventoryGrid"
inventoryGrid.Size = UDim2.new(0.6, -10, 1, -20)
inventoryGrid.Position = UDim2.new(0, 10, 0, 10)
inventoryGrid.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inventoryGrid.Parent = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 100, 0, 100)
gridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
gridLayout.Parent = inventoryGrid

local woodSlot = Instance.new("TextLabel")
woodSlot.Name = "WoodSlot"
woodSlot.Text = "Wood: 0"
woodSlot.BackgroundColor3 = Color3.fromRGB(139, 69, 19) -- Brown
woodSlot.TextColor3 = Color3.new(1, 1, 1)
woodSlot.Font = Enum.Font.SourceSansBold
woodSlot.TextSize = 20
woodSlot.Parent = inventoryGrid

local stoneSlot = Instance.new("TextLabel")
stoneSlot.Name = "StoneSlot"
stoneSlot.Text = "Stone: 0"
stoneSlot.BackgroundColor3 = Color3.fromRGB(105, 105, 105) -- Gray
stoneSlot.TextColor3 = Color3.new(1, 1, 1)
stoneSlot.Font = Enum.Font.SourceSansBold
stoneSlot.TextSize = 20
stoneSlot.Parent = inventoryGrid

-- Layout: Crafting Menu Section
local craftingMenu = Instance.new("Frame")
craftingMenu.Name = "CraftingMenu"
craftingMenu.Size = UDim2.new(0.4, -20, 1, -20)
craftingMenu.Position = UDim2.new(0.6, 10, 0, 10)
craftingMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
craftingMenu.Parent = mainFrame

local craftTitle = Instance.new("TextLabel")
craftTitle.Size = UDim2.new(1, 0, 0, 40)
craftTitle.BackgroundTransparency = 1
craftTitle.Text = "Crafting Menu"
craftTitle.TextColor3 = Color3.new(1, 1, 1)
craftTitle.Font = Enum.Font.SourceSansBold
craftTitle.TextSize = 24
craftTitle.Parent = craftingMenu

local craftWallBtn = Instance.new("TextButton")
craftWallBtn.Name = "CraftWallBtn"
craftWallBtn.Size = UDim2.new(0.9, 0, 0, 60)
craftWallBtn.Position = UDim2.new(0.05, 0, 0, 50)
craftWallBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
craftWallBtn.Text = "Craft Wall\n(Cost: 20 Wood)"
craftWallBtn.TextColor3 = Color3.new(1, 1, 1)
craftWallBtn.Font = Enum.Font.SourceSansBold
craftWallBtn.TextSize = 18
craftWallBtn.Parent = craftingMenu

-- Input Toggle Logic ('E' or 'I' key)
local isOpen = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.I then
        isOpen = not isOpen
        mainFrame.Visible = isOpen
    end
end)

-- Sync Leaderstats dynamically
task.spawn(function()
    local leaderstats = player:WaitForChild("leaderstats", 10)
    if leaderstats then
        local woodStat = leaderstats:WaitForChild("Wood", 5)
        if woodStat then
            woodSlot.Text = "Wood: " .. woodStat.Value
            
            woodStat.Changed:Connect(function(newVal)
                woodSlot.Text = "Wood: " .. newVal
            end)
            
            -- Craft Button Logic
            craftWallBtn.MouseButton1Click:Connect(function()
                if woodStat.Value >= 20 then
                    requestCraftItem:FireServer("Wall")
                else
                    warn("Not enough wood to craft a Wall!")
                end
            end)
        end
    end
end)
