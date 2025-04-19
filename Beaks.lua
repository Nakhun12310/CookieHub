--// UI using Rayfield

loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// Cache

local select = select local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, type, mousemoverel or (Input and Input.MouseMove))

--// Preventing Multiple Processes

pcall(function() getgenv().Aimbot.Functions:Exit() end)

--// Environment

getgenv().Aimbot = {} local Environment = getgenv().Aimbot

--// Services

local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local TweenService = game:GetService("TweenService") local Players = game:GetService("Players") local Camera = workspace.CurrentCamera local LocalPlayer = Players.LocalPlayer

--// Variables

local RequiredDistance, Typing, Running, Animation, ServiceConnections = 2000, false, false, nil, {} local ClientBirdsFolder = workspace:WaitForChild("Regions"):WaitForChild("Beakwoods"):WaitForChild("ClientBirds")

--// Script Settings

Environment.Settings = { Enabled = true, Sensitivity = 0, ThirdPerson = false, ThirdPersonSensitivity = 3, TriggerKey = "MouseButton2", Toggle = false, Prediction = true, PredictionVelocity = 0.08 }

Environment.FOVSettings = { Enabled = true, Visible = true, Amount = 90, Color = Color3.fromRGB(255, 255, 255), LockedColor = Color3.fromRGB(255, 70, 70), Transparency = 0.5, Sides = 60, Thickness = 1, Filled = false }

Environment.FOVCircle = Drawing.new("Circle")

--// Functions

local function CancelLock() Environment.Locked = nil if Animation then Animation:Cancel() end Environment.FOVCircle.Color = Environment.FOVSettings.Color end

local function GetClosestBird() if not Environment.Locked then RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

for _, bird in next, ClientBirdsFolder:GetChildren() do
        if bird:IsA("Model") and bird:FindFirstChild("HumanoidRootPart") then
            local part = bird:FindFirstChild("HumanoidRootPart")
            local Vector, OnScreen = Camera:WorldToViewportPoint(part.Position)

            local Distance = (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Vector.X, Vector.Y)).Magnitude

            if Distance < RequiredDistance and OnScreen then
                RequiredDistance = Distance
                Environment.Locked = bird
            end
        end
    end
elseif (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Camera:WorldToViewportPoint(Environment.Locked.HumanoidRootPart.Position).X, Camera:WorldToViewportPoint(Environment.Locked.HumanoidRootPart.Position).Y)).Magnitude > RequiredDistance then
    CancelLock()
end

end

local Window = Rayfield:CreateWindow({
    Name = "Beaks | CookieHub/PolleserHub",
    LoadingTitle = "Just Aimbot for now",
    LoadingSubtitle = "by Polleser Hub | Cookie Hub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BirdAimbotConfig",
        FileName = "settings"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
})

local Tab = Window:CreateTab("Aimbot")

Tab:CreateToggle({Name = "Enable Aimbot", CurrentValue = true, Callback = function(v) Environment.Settings.Enabled = v end})

Tab:CreateToggle({Name = "Use Prediction", CurrentValue = true, Callback = function(v) Environment.Settings.Prediction = v end})

Tab:CreateSlider({Name = "Prediction Velocity", Range = {0, 0.2}, Increment = 0.01, CurrentValue = Environment.Settings.PredictionVelocity, Callback = function(v) Environment.Settings.PredictionVelocity = v end})

Tab:CreateToggle({Name = "Third Person Mode", CurrentValue = false, Callback = function(v) Environment.Settings.ThirdPerson = v end})

Tab:CreateSlider({Name = "Third Person Sensitivity", Range = {0.1, 5}, Increment = 0.1, CurrentValue = Environment.Settings.ThirdPersonSensitivity, Callback = function(v) Environment.Settings.ThirdPersonSensitivity = v end})

Tab:CreateSlider({Name = "FOV Amount", Range = {20, 360}, Increment = 5, CurrentValue = Environment.FOVSettings.Amount, Callback = function(v) Environment.FOVSettings.Amount = v end})

--// Main Logic

local function Load() ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function() if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then Environment.FOVCircle.Radius = Environment.FOVSettings.Amount Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness Environment.FOVCircle.Filled = Environment.FOVSettings.Filled Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides Environment.FOVCircle.Color = Environment.FOVSettings.Color Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency Environment.FOVCircle.Visible = Environment.FOVSettings.Visible Environment.FOVCircle.Position = Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) else Environment.FOVCircle.Visible = false end

if Running and Environment.Settings.Enabled then
        GetClosestBird()

        if Environment.Locked then
            local bird = Environment.Locked
            local predictedPos = bird.HumanoidRootPart.Position

            if Environment.Settings.Prediction then
                predictedPos = predictedPos + (bird.HumanoidRootPart.Velocity * Environment.Settings.PredictionVelocity)
            end

            if Environment.Settings.ThirdPerson then
                local Vector = Camera:WorldToViewportPoint(predictedPos)
                mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
            else
                if Environment.Settings.Sensitivity > 0 then
                    Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)})
                    Animation:Play()
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
                end
            end
            Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor
        end
    end
end)

ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
    if not Typing then
        pcall(function()
            if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                if Environment.Settings.Toggle then
                    Running = not Running
                    if not Running then CancelLock() end
                else
                    Running = true
                end
            end
        end)
        pcall(function()
            if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                if Environment.Settings.Toggle then
                    Running = not Running
                    if not Running then CancelLock() end
                else
                    Running = true
                end
            end
        end)
    end
end)

ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
    if not Typing then
        if not Environment.Settings.Toggle then
            pcall(function()
                if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                    Running = false
                    CancelLock()
                end
            end)
            pcall(function()
                if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                    Running = false
                    CancelLock()
                end
            end)
        end
    end
end)

end

--// Functions

Environment.Functions = {}

function Environment.Functions:Exit() for _, v in next, ServiceConnections do v:Disconnect() end if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end getgenv().Aimbot.Functions = nil getgenv().Aimbot = nil Load = nil; GetClosestBird = nil; CancelLock = nil end

function Environment.Functions:Restart() for _, v in next, ServiceConnections do v:Disconnect() end Load() end

--// Load

Load()
