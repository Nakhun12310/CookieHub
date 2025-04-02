-- Fluent UI Implementation for Cookie Hub
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/addons/InterfaceManager.lua"))()

-- Create window with Fluent styling
local Window = Fluent:CreateWindow({
    Title = "Cookie Hub" .. " " .. "DEV",
    SubTitle = "by Zepthical",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Create tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "fishing-pole" }),
    Auto = Window:AddTab({ Title = "Auto", Icon = "settings" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "sliders" })
}

-- Variables
local fishingStates = {
    AutoCast = false,
    AutoShake = false,
    AutoReel = false,
    InstantReel = false,
    FreezeChar = false,
    AutoEquipRod = false
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fishing functions
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
    Content = "Control all fishing-related automation features"
})

Tabs.Main:AddToggle("AutoEquip", {
    Title = "Auto Equip Rod",
    Default = fishingStates.AutoEquipRod,
    Callback = function(Value)
        fishingStates.AutoEquipRod = Value
        while fishingStates.AutoEquipRod do
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("events") and tool.events:FindFirstChild("cast") then
                        local remote = ReplicatedStorage:WaitForChild("packages"):WaitForChild("Net"):WaitForChild("RE/Backpack/Equip")
                        remote:FireServer(tool)
                        break
                    end
                end
            end
            task.wait(1)
        end
    end
})

Tabs.Main:AddToggle("AutoCast", {
    Title = "Auto Cast",
    Default = fishingStates.AutoCast,
    Callback = function(Value)
        fishingStates.AutoCast = Value
        while fishingStates.AutoCast do
            local rod = getRod()
            if rod and rod:FindFirstChild("values") and rod.values:FindFirstChild("casted") then
                if not rod.values.casted.Value then
                    Cast()
                end
            end
            task.wait(1)
        end
    end
})

Tabs.Main:AddToggle("AutoShake", {
    Title = "Auto Shake",
    Default = fishingStates.AutoShake,
    Callback = function(Value)
        fishingStates.AutoShake = Value
        while fishingStates.AutoShake do
            Shake()
            task.wait(0.1)
        end
    end
})

-- Auto Tab
Tabs.Auto:AddParagraph({
    Title = "Automation Features",
    Content = "Various quality-of-life automation"
})

Tabs.Auto:AddToggle("AutoSell", {
    Title = "Auto Sell Items",
    Default = false,
    Callback = function(Value)
        while Value do
            local SellAllEvent = ReplicatedStorage.events:FindFirstChild("SellAll")
            if SellAllEvent then
                SellAllEvent:InvokeServer()
            end
            task.wait(1.5)
        end
    end
})

-- Save configuration
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:BuildInterfaceSection(Tabs.Misc)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Cookie Hub",
    Content = "Successfully loaded!",
    Duration = 5
})
