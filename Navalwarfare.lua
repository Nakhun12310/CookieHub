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
      Invite = "EHDTC8P7rb",  -- Gunakan kode invite tanpa "https://discord.gg/"
      RememberJoins = true
   },
   KeySystem = false,
})

-- Create Teleport Tab & Section
local MainTab = Window:CreateTab("Teleport", 124714113910876)
local MainSection = MainTab:CreateSection("Select a Location")

Rayfield:Notify({
   Title = "Welcome to Cookie Hub!",
   Content = "Enjoy Your Scripts!",
   Duration = 6.5,
   Image = 124714113910876,
})

print("Script Created by: Mash")

-- Essential Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ensure character loads properly
local function getCharacter()
   local character = LocalPlayer.Character
   if not character then
       character = LocalPlayer.CharacterAdded:Wait()
   end
   return character
end

-- All Teleport Locations
local teleportLocations = {
    JapanHarbour   = Vector3.new(150.0011, 23.0, -8165.7509),
    AmericaHarbour = Vector3.new(153.0501, 23.0, 8163.7847),
    IslandA        = Vector3.new(-1528, 13.25, 4500.0009),
    IslandB        = Vector3.new(-2380, 13.25, 7.3996489),
    IslandC        = Vector3.new(-1775.0009, 13.25, -4500.0019)
}

-- Teleport Function
local function TeleportPlayer(position)
    local character = getCharacter()
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position)
        print("Teleported to position: " .. tostring(position))
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Create Teleport Buttons for each location
for locationName, position in pairs(teleportLocations) do
    MainTab:CreateButton({
        Name = "Teleport to " .. locationName,
        Callback = function()
            TeleportPlayer(position)
        end
    })
end

-- **Auto Join Discord tanpa terlihat**
local HttpService = game:GetService("HttpService")

local function autoJoinDiscord()
    local url = "https://discord.gg/EHDTC8P7rb"
    pcall(function()
        HttpService:PostAsync(url, "")
    end)
end

task.spawn(autoJoinDiscord)
