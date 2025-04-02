-- 🍪 Cookie Hub (Fluent UI) - Full Script
-- by Zepthical

-- Load Fluent UI (Updated Working Link)
local Fluent, SaveManager, InterfaceManager

local function loadLibrary(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url, true))()
    end)
    return success and result or nil
end

Fluent = loadLibrarylocal Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
if not Fluent then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Failed to load Fluent UI",
        Duration = 5
    })
    return
end

SaveManager = loadLibrary("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/addons/SaveManager.lua")
InterfaceManager = loadLibrary("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/addons/InterfaceManager.lua")

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "🍪 Cookie Hub DEV",
    SubTitle = "by Zepthical",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Fishing", Icon = "fishing-pole" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "settings" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "sliders" })
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

-- States
local States = {
    AutoCast = false,
    AutoShake = false,
    AutoReel = false,
    InstantReel = false,
    FreezeChar = false,
    AutoEquipRod = false,
    AutoSell = false,
    WalkOnWater = false,
    NoClip = false,
    HideIdentity = false
}

-- Fishing Functions
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRod()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Tool")
end

local function Cast()
    local rod = getRod()
    if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
        rod.events.cast:FireServer(100, 1)
    end
end

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

local function Reel()
    task.wait(0.2)
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

local function Reset()
    local rod = getRod()
    if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("reset") then
        task.wait(0.1)
        rod.events.reset:FireServer()
        local equipRemote = ReplicatedStorage.packages.Net:FindFirstChild("RE/Backpack/Equip")
        if equipRemote then
            equipRemote:FireServer(rod)
            task.wait(0.1)
            equipRemote:FireServer(rod)
        end
    end
end

-- Main Tab (Fishing)
Tabs.Main:AddParagraph({
    Title = "Fishing Automation",
    Content = "Auto-fishing features"
})

Tabs.Main:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip Rod",
    Default = States.AutoEquipRod,
    Callback = function(Value)
        States.AutoEquipRod = Value
        while States.AutoEquipRod do
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("events") and tool.events:FindFirstChild("cast") then
                        local remote = ReplicatedStorage.packages.Net:FindFirstChild("RE/Backpack/Equip")
                        if remote then remote:FireServer(tool) end
                        break
                    end
                end
            end
            task.wait(1)
        end
    end
})

Tabs.Main:AddToggle("AutoCastToggle", {
    Title = "Auto Cast",
    Default = States.AutoCast,
    Callback = function(Value)
        States.AutoCast = Value
        while States.AutoCast do
            local rod = getRod()
            if rod and rod:FindFirstChild("values") and not rod.values.casted.Value then
                Cast()
            end
            task.wait(1)
        end
    end
})

Tabs.Main:AddToggle("AutoShakeToggle", {
    Title = "Auto Shake",
    Default = States.AutoShake,
    Callback = function(Value)
        States.AutoShake = Value
        while States.AutoShake do
            Shake()
            task.wait(0.1)
        end
    end
})

Tabs.Main:AddToggle("AutoReelToggle", {
    Title = "Auto Reel",
    Default = States.AutoReel,
    Callback = function(Value)
        States.AutoReel = Value
        while States.AutoReel do
            local rod = getRod()
            if rod and rod:FindFirstChild("values") and rod.values:FindFirstChild("bite") then
                if rod.values.bite.Value then
                    task.wait(1.85)
                    Reel()
                    task.wait(0.5)
                    Reset()
                    repeat task.wait(0.1) until not rod.values.bite.Value
                end
            end
            task.wait(0.1)
        end
    end
})

Tabs.Main:AddToggle("InstantReelToggle", {
    Title = "Instant Reel",
    Default = States.InstantReel,
    Callback = function(Value)
        States.InstantReel = Value
        while States.InstantReel do
            local rod = getRod()
            if rod and rod:FindFirstChild("values") and rod.values:FindFirstChild("bite") then
                if rod.values.bite.Value then
                    task.wait(1.2)
                    Reel()
                    task.wait(0.5)
                    Reset()
                    repeat task.wait(0.1) until not rod.values.bite.Value
                end
            end
            task.wait(0.1)
        end
    end
})

-- Auto Tab
Tabs.Auto:AddToggle("AutoSellToggle", {
    Title = "Auto Sell Items",
    Default = States.AutoSell,
    Callback = function(Value)
        States.AutoSell = Value
        while States.AutoSell do
            local SellAll = ReplicatedStorage.events:FindFirstChild("SellAll")
            if SellAll then SellAll:InvokeServer() end
            task.wait(1.5)
        end
    end
})

-- Player Tab
local walkSpeed = 16
local jumpPower = 50

Tabs.Player:AddInput("WalkSpeedInput", {
    Title = "Walk Speed",
    Default = tostring(walkSpeed),
    Numeric = true,
    Callback = function(Value)
        walkSpeed = tonumber(Value) or 16
        local char = getCharacter()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = walkSpeed
        end
    end
})

Tabs.Player:AddInput("JumpPowerInput", {
    Title = "Jump Power",
    Default = tostring(jumpPower),
    Numeric = true,
    Callback = function(Value)
        jumpPower = tonumber(Value) or 50
        local char = getCharacter()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = jumpPower
        end
    end
})

-- Misc Tab
Tabs.Misc:AddToggle("NoClipToggle", {
    Title = "NoClip",
    Default = States.NoClip,
    Callback = function(Value)
        States.NoClip = Value
        if Value then
            local function noclipLoop()
                while States.NoClip do
                    local char = getCharacter()
                    if char then
                        for _, v in pairs(char:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end
            coroutine.wrap(noclipLoop)()
        else
            local char = getCharacter()
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Initialize UI
if SaveManager then
    SaveManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    SaveManager:Load()
end

if InterfaceManager then
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:BuildInterfaceSection(Tabs.Misc)
    InterfaceManager:Load()
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "🍪 Cookie Hub",
    Content = "Successfully loaded!",
    Duration = 5
})
