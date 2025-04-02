local Fluent = loadstring(game:HttpGet('https://raw.githubusercontent.com/username/fluent/main/source.lua'))()

local Window = Fluent:CreateWindow({
    Title = "🍪 | Cookie Hub DEV",
    SubTitle = "by Zepthical",
    TabWidth = 120
})

local MainTab = Window:AddTab("Main")

Fluent:Notify({
    Title = "Welcome to Cookie Hub!",
    Content = "Don't forget to save the configs!",
    Duration = 6.5
})

-- Essential Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

-- Shake Function
local function Shake()
    local PlayerGUI = LocalPlayer:FindFirstChild("PlayerGui")
    local shakeUI = PlayerGUI and PlayerGUI:FindFirstChild("shakeui")
    
    if shakeUI and shakeUI.Enabled then
        local safezone = shakeUI:FindFirstChild("safezone")
        if safezone then
            local button = safezone:FindFirstChild("button")
            if button and button:IsA("ImageButton") and button.Visible then
                GuiService.SelectedObject = button
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end
end

-- Character Freeze Toggle
_G.FreezeCharacter = false
MainTab:AddToggle("Freeze Character", function(state)
    _G.FreezeCharacter = state
    spawn(function()
        while _G.FreezeCharacter do
            local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            if Char and Char:FindFirstChild("HumanoidRootPart") then
                Char.HumanoidRootPart.Anchored = true
            end
            task.wait(0.1)
        end
        local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char.HumanoidRootPart.Anchored = false
        end
    end)
end)

-- Auto Shake Toggle
_G.AutoShake = false
MainTab:AddToggle("Auto Shake", function(state)
    _G.AutoShake = state
    spawn(function()
        while _G.AutoShake do
            Shake()
            task.wait(0.01)
        end
    end)
end)

-- Auto Reel Function
local function Reel()
    task.wait(0.15)
    for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "reel" then
            local bar = v:FindFirstChild("bar")
            if bar and ReplicatedStorage:FindFirstChild("events") then
                local playerbar = bar:FindFirstChild("playerbar")
                if playerbar then
                    playerbar.Size = UDim2.new(1, 0, 1, 0)
                    local reelFinished = ReplicatedStorage.events:FindFirstChild("reelfinished")
                    if reelFinished then
                        reelFinished:FireServer(100, true)
                    end
                end
            end
        end
    end
end

-- Auto Reel Toggle
_G.AutoReel = false
MainTab:AddToggle("Auto Reel", function(state)
    _G.AutoReel = state
    spawn(function()
        while _G.AutoReel do
            task.wait(0.1)
            local Rod = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Rod and Rod:FindFirstChild("values") and Rod.values:FindFirstChild("bite") then
                if Rod.values.bite.Value == true then
                    task.wait(1.85)
                    Reel()
                end
            end
        end
    end)
end)
