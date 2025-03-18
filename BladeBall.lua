-- Get Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager") -- For simulating clicks

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Load Vayfield GUI
local Vayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/zepthical/Vayfield/main/source.lua"))()

-- Create GUI Window
local Window = Vayfield:CreateWindow({
    Name = "Auto Parry Script",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "By YourName",
    ConfigurationSaving = {
        Enabled = false, -- Set true if you want to save settings
        FolderName = nil,
        FileName = "AutoParryConfig"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

-- Toggle for Auto Parry
local AutoParryEnabled = false
local Toggle = Window:CreateToggle({
    Name = "Enable Auto Parry",
    CurrentValue = false,
    Flag = "AutoParry", 
    Callback = function(Value)
        AutoParryEnabled = Value
    end
})

-- Slider for Parry Distance
local ParryDistance = 10
local Slider = Window:CreateSlider({
    Name = "Parry Distance",
    Range = {1, 20}, 
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 10,
    Flag = "ParryDistance",
    Callback = function(Value)
        ParryDistance = Value
    end
})

-- Ball Detection
local Ball = nil

function FindBall()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name == "Ball" then
            Ball = obj
            return
        end
    end
    Ball = nil -- Reset if no ball is found
end

-- Create Indicator (Floating Circle)
local Indicator = Instance.new("Part")
Indicator.Shape = Enum.PartType.Ball
Indicator.Size = Vector3.new(5, 5, 5)
Indicator.Color = Color3.fromRGB(255, 0, 0) -- Default Red
Indicator.Material = Enum.Material.Neon
Indicator.Anchored = true
Indicator.CanCollide = false
Indicator.Parent = game.Workspace

-- Auto Parry Function
function AutoParry()
    if AutoParryEnabled and Ball and RootPart then
        local playerPos = RootPart.Position
        local ballPos = Ball.Position
        local distance = (playerPos - ballPos).Magnitude

        -- Update Indicator Position
        Indicator.Position = playerPos + Vector3.new(0, 3, 0)

        -- Change Indicator Color Based on Distance
        if distance > ParryDistance then
            Indicator.Color = Color3.fromRGB(255, 0, 0) -- Red (Wait)
        else
            Indicator.Color = Color3.fromRGB(0, 255, 0) -- Green (Ready)

            -- Perform Auto Click / Parry
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end

-- Run the Detection & Auto Parry Loop
RunService.RenderStepped:Connect(function()
    FindBall()
    AutoParry()
end)
