-- 🍪 Cookie Hub (Fluent UI)
-- by Zepthical

-- Load Fluent UI (Updated Working Link)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/source.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/addons/InterfaceManager.lua"))()

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
    Main = Window:AddTab({ Title = "Main", Icon = "fishing-pole" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "settings" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" })
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- States
local States = {
    AutoCast = false,
    AutoShake = false,
    AutoReel = false,
    InstantReel = false,
    FreezeChar = false,
    AutoEquipRod = false,
    AutoSell = false
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
                game:GetService("GuiService").SelectedObject = button
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end
        end
    end
end

-- Main Tab
Tabs.Main:AddParagraph({
    Title = "Fishing Automation",
    Content = "Control all fishing features"
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

-- Initialize UI
if SaveManager then
    SaveManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    SaveManager:Load()
end

if InterfaceManager then
    InterfaceManager:SetLibrary(Fluent)
    InterfaceManager:BuildInterfaceSection(Tabs.Player)
    InterfaceManager:Load()
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "🍪 Cookie Hub",
    Content = "Successfully loaded!",
    Duration = 5
})
