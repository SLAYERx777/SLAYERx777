-- Define fruit locations and spawn timers (example)
local fruitLocations = {
    {Name = "Dragon Fruit", Position = Vector3.new(100, 10, 100), spawnTime = 300},  -- 5 minutes spawn time
    {Name = "Dough Fruit", Position = Vector3.new(200, 10, 200), spawnTime = 180},   -- 3 minutes spawn time
    {Name = "Light Fruit", Position = Vector3.new(300, 10, 300), spawnTime = 240},   -- 4 minutes spawn time
}

-- GUI setup for the timer display
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 300, 0, 50)
TextLabel.Position = UDim2.new(0, 50, 0, 50)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 0.5
TextLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.Text = "Waiting for fruit spawn..."
TextLabel.Parent = ScreenGui

-- Teleport player to fruit location
local function teleportToFruit(fruit)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(fruit.Position)
        print("Teleported to " .. fruit.Name)
    end
end

-- Update GUI to show remaining time
local function updateGui(fruit)
    TextLabel.Text = fruit.Name .. " - Time Left: " .. fruit.spawnTime .. "s"
end

-- Main loop to check for fruit spawns
local function checkForFruits()
    while true do
        for _, fruit in pairs(fruitLocations) do
            -- Reduce the spawn time countdown
            fruit.spawnTime = fruit.spawnTime - 5
            updateGui(fruit)
            
            -- If fruit is found, teleport to it
            local fruitPart = game.Workspace:FindFirstChild(fruit.Name)
            if fruitPart and fruitPart:IsA("Model") and fruitPart.Parent == game.Workspace then
                print(fruit.Name .. " spawned at " .. tostring(fruit.Position))
                teleportToFruit(fruit)
                
                -- Reset spawn time for next spawn
                fruit.spawnTime = math.random(180, 300)  -- Random next spawn time between 3 to 5 minutes
            end

            -- If spawn time reaches 0, reset the timer and check again
            if fruit.spawnTime <= 0 then
                fruit.spawnTime = math.random(180, 300)
            end
        end
        wait(5)  -- Check every 5 seconds
    end
end

-- Start checking for fruit spawns
checkForFruits()
