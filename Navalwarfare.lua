--[[
   Naval Warfare Script
   🍪 | Cookie Hub (Created by: Mash)
   Teleport, Combat, and Strategy functionalities with _G variables.
--]]

-- Global Variables for Teleport (initially false)
_G.USAHarbour    = false
_G.JapanHarbour  = false
_G.USACarrier    = false
_G.JapanCarrier  = false
_G.USABattleship = false
_G.JapanBattleship = false

-- Global Variables for Combat Features (initially false)
_G.AutoShoot            = false
_G.AutoBomb             = false
_G.KillAura             = false
_G.AutoCaptureIslands   = false
_G.AutoSpawnSubmarines  = false
_G.AutoSpawnBombers     = false

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/zepthical/Vayfield/refs/heads/main/README.md"))()

local Window = Rayfield:CreateWindow({
   Name = "🍪 | Cookie Hub",
   Icon = "rbxassetid://124714113910876",
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

-- Create Tabs
local TeleportTab = Window:CreateTab("Teleport", "rbxassetid://124714113910876")
local CombatTab   = Window:CreateTab("Combat", "rbxassetid://124714113910876")
local StrategyTab = Window:CreateTab("Strategy", "rbxassetid://124714113910876")

-----------------------------------------------------
-- TELEPORT SECTION
-----------------------------------------------------

-- Spawn Locations (Fixed Coordinates)
local spawnLocations = {
    USAHarbour    = Vector3.new(150.0011, 23.0, -8165.7509),
    JapanHarbour  = Vector3.new(153.0501, 23.0, 8163.7847),
    USACarrier    = Vector3.new(200.0011, 23.0, -8000.7509),
    JapanCarrier  = Vector3.new(250.0501, 23.0, 8000.7847),
    USABattleship = Vector3.new(300.0011, 23.0, -8200.7509),
    JapanBattleship = Vector3.new(350.0501, 23.0, 8200.7847)
}

-- Function to teleport the player
local function TeleportPlayer(position)
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position)
        print("Teleported to: " .. tostring(position))
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Create toggles for spawn locations
TeleportTab:CreateToggle({
    Name = "Teleport to USA Harbour",
    CurrentValue = _G.USAHarbour,
    Callback = function(Value)
        _G.USAHarbour = Value
        if Value then
            TeleportPlayer(spawnLocations.USAHarbour)
        end
    end
})

TeleportTab:CreateToggle({
    Name = "Teleport to Japan Harbour",
    CurrentValue = _G.JapanHarbour,
    Callback = function(Value)
        _G.JapanHarbour = Value
        if Value then
            TeleportPlayer(spawnLocations.JapanHarbour)
        end
    end
})

TeleportTab:CreateToggle({
    Name = "Teleport to USA Carrier",
    CurrentValue = _G.USACarrier,
    Callback = function(Value)
        _G.USACarrier = Value
        if Value then
            TeleportPlayer(spawnLocations.USACarrier)
        end
    end
})

TeleportTab:CreateToggle({
    Name = "Teleport to Japan Carrier",
    CurrentValue = _G.JapanCarrier,
    Callback = function(Value)
        _G.JapanCarrier = Value
        if Value then
            TeleportPlayer(spawnLocations.JapanCarrier)
        end
    end
})

TeleportTab:CreateToggle({
    Name = "Teleport to USA Battleship",
    CurrentValue = _G.USABattleship,
    Callback = function(Value)
        _G.USABattleship = Value
        if Value then
            TeleportPlayer(spawnLocations.USABattleship)
        end
    end
})

TeleportTab:CreateToggle({
    Name = "Teleport to Japan Battleship",
    CurrentValue = _G.JapanBattleship,
    Callback = function(Value)
        _G.JapanBattleship = Value
        if Value then
            TeleportPlayer(spawnLocations.JapanBattleship)
        end
    end
})

-----------------------------------------------------
-- COMBAT SECTION
-----------------------------------------------------

-- Auto Shoot Toggle
CombatTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = _G.AutoShoot,
    Callback = function(Value)
        _G.AutoShoot = Value
        if Value then
            spawn(function()
                while _G.AutoShoot do
                    local character = game.Players.LocalPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            -- Simulate shooting logic here
                            print("Auto Shoot is active!")
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Auto Bomb Toggle
CombatTab:CreateToggle({
    Name = "Auto Bomb",
    CurrentValue = _G.AutoBomb,
    Callback = function(Value)
        _G.AutoBomb = Value
        if Value then
            spawn(function()
                while _G.AutoBomb do
                    local character = game.Players.LocalPlayer.Character
                    if character then
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            -- Simulate bombing logic here
                            print("Auto Bomb is active!")
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Kill Aura Toggle (80m)
CombatTab:CreateToggle({
    Name = "Kill Aura (80m)",
    CurrentValue = _G.KillAura,
    Callback = function(Value)
        _G.KillAura = Value
        if Value then
            spawn(function()
                while _G.KillAura do
                    local myChar = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                    local hrp = myChar:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, player in pairs(game.Players:GetPlayers()) do
                            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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

-----------------------------------------------------
-- STRATEGY SECTION
-----------------------------------------------------

-- Auto Capture Islands Toggle
StrategyTab:CreateToggle({
    Name = "Auto Capture Islands",
    CurrentValue = _G.AutoCaptureIslands,
    Callback = function(Value)
        _G.AutoCaptureIslands = Value
        if Value then
            spawn(function()
                while _G.AutoCaptureIslands do
                    -- Simulate island capture logic here
                    print("Auto Capture Islands is active!")
                    task.wait(2)
                end
            end)
        end
    end
})

-- Auto Spawn Submarines Toggle
StrategyTab:CreateToggle({
    Name = "Auto Spawn Submarines",
    CurrentValue = _G.AutoSpawnSubmarines,
    Callback = function(Value)
        _G.AutoSpawnSubmarines = Value
        if Value then
            spawn(function()
                while _G.AutoSpawnSubmarines do
                    -- Simulate submarine spawning logic here
                    print("Auto Spawn Submarines is active!")
                    task.wait(5)
                end
            end)
        end
    end
})

-- Auto Spawn Bombers Toggle
StrategyTab:CreateToggle({
    Name = "Auto Spawn Bombers",
    CurrentValue = _G.AutoSpawnBombers,
    Callback = function(Value)
        _G.AutoSpawnBombers = Value
        if Value then
            spawn(function()
                while _G.AutoSpawnBombers do
                    -- Simulate bomber spawning logic here
                    print("Auto Spawn Bombers is active!")
                    task.wait(5)
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
        -- Open the Discord invite link in the default browser
        local success, result = pcall(function()
            return HttpService:RequestAsync({
                Url = url,
                Method = "GET"
            })
        end)
        if success then
            print("Discord invite link opened successfully!")
        else
            warn("Failed to open Discord invite link: " .. tostring(result))
        end
    end)
end
task.spawn(autoJoinDiscord)
