-- Get Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Ball Detection Settings
local Ball = nil  -- This will hold the ball object when detected
local ParryDistance = 10 -- Distance at which the parry should trigger

-- Create the Indicator Part (Circle)
local Indicator = Instance.new("Part")
Indicator.Shape = Enum.PartType.Ball
Indicator.Size = Vector3.new(5, 5, 5) -- Make it a circle
Indicator.Color = Color3.fromRGB(255, 0, 0) -- Default: Red (Wait)
Indicator.Material = Enum.Material.Neon
Indicator.Anchored = true
Indicator.CanCollide = false
Indicator.Parent = game.Workspace

-- Function to Detect the Ball in the Game
function FindBall()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") and obj.Name == "Ball" then
            Ball = obj
            return
        end
    end
end

-- Function to Auto-Parry When the Ball is Close
function AutoParry()
    if Ball and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
        local ballPos = Ball.Position
        local distance = (playerPos - ballPos).Magnitude

        -- Update Indicator Position
        Indicator.Position = playerPos + Vector3.new(0, 3, 0) -- Keep it floating above player

        -- Change Indicator Color Based on Distance
        if distance > ParryDistance then
            Indicator.Color = Color3.fromRGB(255, 0, 0) -- Red (Wait)
        else
            Indicator.Color = Color3.fromRGB(0, 255, 0) -- Green (Ready)
            
            -- Perform Auto Click / Parry
            task.spawn(function()
                while distance <= ParryDistance do
                    mouse1click() -- Simulate mouse click
                    task.wait(0.00000001) -- Super fast reaction
                end
            end)
        end
    end
end

-- Run the Detection & Auto Parry Loop
RunService.RenderStepped:Connect(function()
    FindBall()
    AutoParry()
end)
