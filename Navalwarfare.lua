-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/zepthical/Vayfield/refs/heads/main/README.md"))()

local Window = Rayfield:CreateWindow({
   Name = "🍪 | Cookie Hub",
   Icon = 124714113910876,
   LoadingTitle = "Loading, please wait...",
   LoadingSubtitle = "Created by: Mash",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "CookieHub"
   },
   Discord = {
      Enabled = true,
      Invite = "EHDTC8P7rb",  -- Discord invite code (just the code)
      RememberJoins = true
   },
   KeySystem = false,
})

-- Create a single Main Tab
local MainTab = Window:CreateTab("Main", 124714113910876)

-- Create two sections: Teleportation and Combat
local TeleportSection = MainTab:CreateSection("Teleportation")
local CombatSection   = MainTab:CreateSection("Combat")

Rayfield:Notify({
   Title = "Welcome to Cookie Hub!",
   Content = "Enjoy Your Scripts!",
   Duration = 6.5,
   Image = 124714113910876,
})

print("Script Created by: Mash")

-- Essential Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Ensure character loads properly
local function getCharacter()
   local character = LocalPlayer.Character
   if not character then
       character = LocalPlayer.CharacterAdded:Wait()
   end
   return character
end

------------------------------------------------------------------
-- TELEPORTATION
------------------------------------------------------------------

-- Fixed Teleport Locations for Harbours
local harbourLocations = {
    JapanHarbour   = Vector3.new(150.0011, 23.0, -8165.7509),
    AmericaHarbour = Vector3.new(153.0501, 23.0, 8163.7847)
}

-- Function to teleport the player
local function TeleportPlayer(position)
    local character = getCharacter()
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position)
        print("Teleported to: " .. tostring(position))
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Create fixed teleport buttons for harbours
for locationName, position in pairs(harbourLocations) do
    TeleportSection:CreateButton({
        Name = "Teleport to " .. locationName,
        Callback = function()
            TeleportPlayer(position)
        end
    })
end

-- Dynamic Teleportation for Islands (Search by name)
local function findIsland(islandName)
    for _, object in pairs(Workspace:GetChildren()) do
        if object:IsA("Model") and object.Name:lower():find(islandName:lower()) then
            local primaryPart = object.PrimaryPart or object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("Part")
            if primaryPart then
                return primaryPart.Position
            end
        end
    end
    return nil
end

local islands = {"Island A", "Island B", "Island C"}

for _, islandName in ipairs(islands) do
    TeleportSection:CreateButton({
        Name = "Search & Teleport to " .. islandName,
        Callback = function()
            local pos = findIsland(islandName)
            if pos then
                TeleportPlayer(pos)
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = islandName .. " not found!",
                    Duration = 4,
                    Image = 124714113910876,
                })
            end
        end
    })
end

------------------------------------------------------------------
-- COMBAT FEATURES
------------------------------------------------------------------

-- Kill Aura Toggle: Kills players within 80 meters (approx. 80 meters = 80 studs, adjust if needed)
_G.KillAura = false
MainTab:CreateToggle({
    Name = "Kill Aura (80m)",
    Callback = function(state)
        _G.KillAura = state
        if state then
            spawn(function()
                while _G.KillAura do
                    local myChar = getCharacter()
                    local hrp = myChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if dist <= 80 then
                                    local enemyHumanoid = player.Character:FindFirstChild("Humanoid")
                                    if enemyHumanoid then
                                        enemyHumanoid.Health = 0
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Additional Combat Features (example toggles/buttons)
CombatSection:CreateToggle({
    Name = "Auto Bomb Harbour (Plane)",
    Callback = function(state)
        _G.AutoBombHarbour = state
        if state then
            spawn(function()
                while _G.AutoBombHarbour do
                    for _, object in pairs(Workspace:GetChildren()) do
                        if object:IsA("Model") and object.Name:lower():find("harbour") then
                            local pivot = object:GetPivot() or (object.PrimaryPart and object.PrimaryPart.Position)
                            if pivot then
                                local explosion = Instance.new("Explosion")
                                explosion.Position = pivot
                                explosion.Parent = Workspace
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

CombatSection:CreateToggle({
    Name = "Auto Bomb Ship (Plane)",
    Callback = function(state)
        _G.AutoBombShip = state
        if state then
            spawn(function()
                while _G.AutoBombShip do
                    for _, object in pairs(Workspace:GetChildren()) do
                        if object:IsA("Model") and object.Name:lower():find("ship") then
                            local pivot = object:GetPivot() or (object.PrimaryPart and object.PrimaryPart.Position)
                            if pivot then
                                local explosion = Instance.new("Explosion")
                                explosion.Position = pivot
                                explosion.Parent = Workspace
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

CombatSection:CreateButton({
    Name = "Kamikaze Plan (Plane)",
    Callback = function()
        local character = getCharacter()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local explosion = Instance.new("Explosion")
            explosion.Position = hrp.Position
            explosion.Parent = Workspace
            character:BreakJoints()
        end
    end
})

CombatSection:CreateToggle({
    Name = "Auto Shoot Plane (Ship)",
    Callback = function(state)
        _G.AutoShootPlane = state
        if state then
            spawn(function()
                while _G.AutoShootPlane do
                    local character = getCharacter()
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local projectile = Instance.new("Part")
                        projectile.Size = Vector3.new(1,1,1)
                        projectile.Position = hrp.Position
                        projectile.Velocity = hrp.CFrame.LookVector * 100
                        projectile.Parent = Workspace
                        projectile.Touched:Connect(function(hit)
                            projectile:Destroy()
                        end)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

CombatSection:CreateToggle({
    Name = "Auto Shoot Player (Ship)",
    Callback = function(state)
        _G.AutoShootPlayer = state
        if state then
            spawn(function()
                while _G.AutoShootPlayer do
                    for _, enemy in pairs(Players:GetPlayers()) do
                        if enemy ~= LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                            local enemyHumanoid = enemy.Character:FindFirstChild("Humanoid")
                            if enemyHumanoid then
                                enemyHumanoid.Health = 0
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

CombatSection:CreateToggle({
    Name = "Auto Bomb Harbour (Ship)",
    Callback = function(state)
        _G.AutoBombHarbourShip = state
        if state then
            spawn(function()
                while _G.AutoBombHarbourShip do
                    for _, object in pairs(Workspace:GetChildren()) do
                        if object:IsA("Model") and object.Name:lower():find("harbour") then
                            local pivot = object:GetPivot() or (object.PrimaryPart and object.PrimaryPart.Position)
                            if pivot then
                                local explosion = Instance.new("Explosion")
                                explosion.Position = pivot
                                explosion.Parent = Workspace
                            end
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

------------------------------------------------------------
-- Auto Join Discord in Background
------------------------------------------------------------
local HttpService = game:GetService("HttpService")
local function autoJoinDiscord()
    local url = "https://discord.gg/EHDTC8P7rb"
    pcall(function()
        HttpService:PostAsync(url, "")
    end)
end
task.spawn(autoJoinDiscord)
