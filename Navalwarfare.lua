-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/zepthical/Vayfield/refs/heads/main/README.md'))()

local Window = Rayfield:CreateWindow({
   Name = "🍪 | Cookie Hub",
   Icon = 124714113910876,
   LoadingTitle = "Loading, please wait...",
   LoadingSubtitle = "Mash", -- Changed subtitle here
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Cookie Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 124714113910876)
local MainSection = MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "Welcome to Cookie Hub!",
   Content = "Enjoy Your Scripts!",
   Duration = 6.5,
   Image = 124714113910876,
})

-- Created by: Mash
print("Script Created by: Mash") -- Added message in console

-- Define essential variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

-- Ensure Character Loads Properly
local function getCharacter()
   local character = LocalPlayer.Character
   if not character then
       character = LocalPlayer.CharacterAdded:Wait()
   end
   return character
end

local Char = getCharacter()
local Backpack = LocalPlayer:FindFirstChild("Backpack")

-- Teleport Variables
_G["Harbour Japan"] = false
_G["Harbour America"] = false
_G["Island A"] = false
_G["Island B"] = false
_G["Island C"] = false

-- Function for teleportation
local function TeleportPlayer(position)
    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Teleport locations coordinates (Adjust these according to the game)
local teleportPositions = {
    ["Harbour Japan"] = Vector3.new(-100, 10, 200),
    ["Harbour America"] = Vector3.new(150, 10, -300),
    ["Island A"] = Vector3.new(500, 20, 100),
    ["Island B"] = Vector3.new(-250, 15, -500),
    ["Island C"] = Vector3.new(750, 25, 400)
}

-- Function to check and execute teleportation
local function CheckAndTeleport(location)
    if _G[location] then
        print("Teleport to " .. location .. " is active!")
        TeleportPlayer(teleportPositions[location])
    else
        print("Teleport to " .. location .. " is not active. Teleportation stopped.")
    end
end

-- UI Buttons for Teleportation
for location, _ in pairs(teleportPositions) do
    MainTab:CreateButton({
        Name = "Teleport to " .. location,
        Callback = function()
            _G[location] = not _G[location] -- Toggle teleport activation
            CheckAndTeleport(location)
        end
    })
end
