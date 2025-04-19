local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

-- Create Fluent Window
local Window = Library:CreateWindow{
    Title = `Cookie Hub {Library.Version}`,
    SubTitle = "by Cookie Hub Developer Team",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
}

-- Tabs
local Tabs = {
    Main = Window:CreateTab{ Title = "Main", Icon = "leaf" },
    Settings = Window:CreateTab{ Title = "Settings", Icon = "settings" }
}

-- Toggles
local AutoCollectToggle = Tabs.Main:CreateToggle("AutoCollect", {
    Title = "Auto Collect",
    Default = false
})

local AutoWalkToggle = Tabs.Main:CreateToggle("AutoWalk", {
    Title = "Auto Walk to Plants",
    Default = false
})

local SellInventoryToggle = Tabs.Main:CreateToggle("AutoSell", {
    Title = "Auto Sell Inventory Anywhere",
    Default = false
})

-- Game Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Sell Function
local function sellInventory()
    local remote = ReplicatedStorage:FindFirstChild("SellItems") -- Replace if needed
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer()
        print("Inventory sold via RemoteEvent.")
    else
        warn("Sell RemoteEvent not found.")
    end
end

-- Find Your Plot
local function getOwnedPlot()
    for _, plot in pairs(workspace.Farm:GetChildren()) do
        local important = plot:FindFirstChild("Important") or plot:FindFirstChild("Importanert")
        if important then
            local data = important:FindFirstChild("Data")
            if data and data:FindFirstChild("Owner") and data.Owner.Value == player.Name then
                return plot
            end
        end
    end
    return nil
end

-- Auto Collect Logic
AutoCollectToggle:OnChanged(function(v)
    if v then
        task.spawn(function()
            while AutoCollectToggle.Value do
                local plot = getOwnedPlot()
                local farm = plot and plot:FindFirstChild("Important"):FindFirstChild("Plants_Physical")
                local character = player.Character
                if farm and character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChild("Humanoid")
                    if root and humanoid then
                        for _, prompt in ipairs(farm:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                local dist = (root.Position - prompt.Parent.Position).Magnitude
                                if dist <= 20 then
                                    prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                    prompt.MaxActivationDistance = 100
                                    prompt.RequiresLineOfSight = false
                                    prompt.Enabled = true
                                    fireproximityprompt(prompt, 1, true)
                                elseif AutoWalkToggle.Value then
                                    humanoid:MoveTo(prompt.Parent.Position + Vector3.new(0, 5, 0))
                                end
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

-- Auto Sell Logic
SellInventoryToggle:OnChanged(function(v)
    if v then
        task.spawn(function()
            while SellInventoryToggle.Value do
                sellInventory()
                task.wait(0.1)
            end
        end)
    end
end)

-- Save + Interface
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Select tab and notify
Window:SelectTab(1)
Library:Notify{
    Title = "Fluent",
    Content = "Auto Farm script loaded.",
    Duration = 6
}

SaveManager:LoadAutoloadConfig()
