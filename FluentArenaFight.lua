-- Load the latest version of Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Optimization and variable declarations
local game = game
local players = game:GetService("Players")
local player = players.LocalPlayer
local UIS = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local cg = cloneref(game:GetService("CoreGui"))
local camera = workspace.CurrentCamera
local instance = Instance.new
local udim2 = UDim2.new
local vector2 = Vector2.new
local vector3 = Vector3.new
local color3 = Color3.new
local cframe = CFrame.new
local enum = Enum.KeyCode
local silentaim = false
local silentkeybindtoggle = false
local silentkeybind = false
local noforcefields = false
local weapons = {}
local camos = {}

-- Populate weapons and camos from ReplicatedStorage
for _, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetChildren()) do
    table.insert(weapons, v.Name)
end

for _, v in pairs(game:GetService("ReplicatedStorage").Camos:GetChildren()) do
    table.insert(camos, v.Name)
end

local primary
local secondary
local primarycamo
local secondarycamo

-- Functions to handle modifiers
local s = player.PlayerScripts.Vortex.Modifiers.Steadiness
local m = player.PlayerScripts.Vortex.Modifiers.Mobility

local function resetModifiers()
    if s and s.Value > 0 then s.Value = 0 end
    if m and m.Value > 0 then m.Value = 0 end
end

if s then s.Changed:Connect(resetModifiers) end
if m then m.Changed:Connect(resetModifiers) end
resetModifiers()

-- Function to check visibility
local function isVisible(origin, direction, target, ignore)
    local params = RaycastParams.new()
    local filterList = {player.Character, target}

    if ignore then
        for _, v in ipairs(ignore) do
            table.insert(filterList, v)
        end
    end

    params.FilterDescendantsInstances = filterList
    return not workspace:Raycast(origin, direction, params)
end

-- Function to get the closest player
local function getClosestPlayer()
    local team = player:GetAttribute("Team")
    local closest, distance = nil, math.huge

    for _, character in ipairs(workspace:GetChildren()) do
        local humanoid = character:FindFirstChild("Humanoid")
        if character and humanoid and humanoid.Health > 0 then
            local targetPlayer = players:FindFirstChild(character.Name)
            if targetPlayer and targetPlayer:GetAttribute("Team") ~= team then
                local head = character:FindFirstChild("Head")
                if head then
                    local screenPosition, onScreen = camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local dist = (vector2(screenPosition.X, screenPosition.Y) - vector2(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                        if dist < distance then
                            local origin = camera.CFrame.Position
                            local direction = head.Position - origin
                            if isVisible(origin, direction, character, nil) then
                                closest = character
                                distance = dist
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- Update closest player each frame
rs.RenderStepped:Connect(function()
    closestPlayer = getClosestPlayer()
end)

-- Hook to modify aiming behavior
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, index)
    local func = debug.getinfo(3, "n")
    if func and func.name then
        if func.name == "Fire" and index == "CFrame" and closestPlayer then
            local head = closestPlayer:FindFirstChild("Head")
            if head then
                local origin = camera.CFrame.Position
                local direction = head.Position - origin
                if isVisible(origin, direction, closestPlayer, nil) and silentaim then
                    if silentkeybindtoggle then
                        if silentkeybind then
                            return cframe(head.Position)
                        end
                    else
                        return cframe(head.Position)
                    end
                end
            end
        end
    end
    return oldIndex(self, index)
end)

-- Remove enemy forcefields if enabled
rs.RenderStepped:Connect(function()
    for _, v in pairs(workspace.Env:GetChildren()) do
        if string.find(v.Name, "Forcefield") and noforcefields then
            if v.FullSphere.Color ~= Color3.fromRGB(0, 102, 255) then
                v:Destroy()
            end
        end
    end
end)

-- Initialize Fluent UI Window
local Window = Fluent:CreateWindow({
    Title = "Gunfight Arena",
    SubTitle = "Silent Aim & Weapon Changer",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- Create Tabs
local aimTab = Window:AddTab({ Title = "Aim", Icon = "rbxassetid://4483345998" })
local weaponTab = Window:AddTab({ Title = "Weapons", Icon = "rbxassetid://4483345998" })
local settingsTab = Window:AddTab({ Title = "Settings", Icon = "rbxassetid://4483345998" })

-- Aim Tab Elements
aimTab:AddToggle("Silent Aim", {
    Default = false,
    Callback = function(value)
        silentaim = value
    end
})

aimTab:AddToggle("SilentAim Keybind Toggle", {
    Default = false,
    Callback = function(value)
        silentkeybindtoggle = value
    end
})

aimTab:AddKeybind("Silent Aim Keybind", {
    Default = enum.E,
    Callback = function()
        if silentkeybindtoggle then
            silentkeybind = not silentkeybind
        end
    end
})

aimTab:AddToggle("No Enemy Forcefields", {
    Default = false,
    Callback = function(value)
        noforcefields = value
    end
})

-- Weapon Tab Elements
weaponTab:AddDropdown("Primary Weapon", {
    Options = weapons,
    Default = weapons[1],
    Callback = function(value)
        primary = value
    end
})

weaponTab:AddButton("Equip Primary", function()
    player:SetAttribute("Primary", primary)
end)

weaponTab:AddDropdown("Primary Camo", {
    Options = camos,
    Default = camos[1],
    Callback = function(value)
        primarycamo = value
    end
})

weaponTab:AddButton("Equip Primary Camo", function()
    player:SetAttribute("PrimaryCamo", primarycamo)
end)

weaponTab:AddDropdown("Secondary Weapon", {

::contentReference[oaicite:0]{index=0}
 
