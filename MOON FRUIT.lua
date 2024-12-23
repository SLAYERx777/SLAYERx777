-- Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local spawnInterval = 3600 -- Default to 1 hour (in seconds)
local weekendInterval = 2700 -- 45 minutes (in seconds)
local despawnTime = 1200 -- 20 minutes (in seconds)
local fruitSpawned = false
local timer = 0
local moonPhases = {"New Moon", "Half Moon", "Full Moon"} -- Example phases

-- Check Day of the Week
local function isWeekend()
    local day = os.date("*t").wday
    return (day == 7 or day == 1) -- Saturday (7) or Sunday (1)
end

-- Set Spawn Timer
if isWeekend() then
    spawnInterval = weekendInterval
end

-- GUI to Display Timer
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local TimerLabel = Instance.new("TextLabel", ScreenGui)
TimerLabel.Size = UDim2.new(0.3, 0, 0.05, 0)
TimerLabel.Position = UDim2.new(0.35, 0, 0.05, 0)
TimerLabel.TextScaled = true
TimerLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TimerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerLabel.Text = "Time Until Next Spawn: " .. spawnInterval .. "s"

-- Function to Update Timer
local function updateTimer()
    if fruitSpawned then
        TimerLabel.Text = "Fruit is spawned! Collect it before it despawns!"
    else
        TimerLabel.Text = "Time Until Next Spawn: " .. math.max(0, spawnInterval - timer) .. "s"
    end
end

-- Function to Simulate Moon Phase (Optional for Roleplay)
local function getMoonPhase()
    return moonPhases[(math.floor(timer / 1200) % #moonPhases) + 1]
end

-- Function to Check for Fruit Spawn
local function checkForFruit()
    local fruit = Workspace:FindFirstChild("Fruit") -- Replace "Fruit" with the actual fruit model's name
    if fruit then
        fruitSpawned = true
        TimerLabel.Text = "Fruit Found: " .. fruit.Name
        -- Teleport to Fruit
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = fruit.CFrame
        end
        wait(despawnTime) -- Wait until the despawn time passes
        fruitSpawned = false
        timer = 0 -- Reset timer after despawn
    end
end

-- Main Loop
spawn(function()
    while true do
        if not fruitSpawned then
            timer = timer + 1
            updateTimer()
            if timer >= spawnInterval then
                checkForFruit()
            end
        end
        wait(1)
    end
end)

-- Optional: Display Moon Phase
spawn(function()
    while true do
        print("Current Moon Phase: " .. getMoonPhase())
        wait(10) -- Print every 10 seconds
    end
end)
