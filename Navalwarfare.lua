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
      FileName = "CookieHubDR"
   },
   Discord = {
      Enabled = true,
      Invite = "https://discord.gg/Z3UCyhVpBz",
      RememberJoins = true
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Teleport", 124714113910876)
local MainSection = MainTab:CreateSection("Select a Location")

Rayfield:Notify({
   Title = "Welcome to Cookie Hub!",
   Content = "Enjoy Your Scripts!",
   Duration = 6.5,
   Image = 124714113910876,
})

print("Script Created by: Mash")

-- Essential services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ensure the character loads properly
local function getCharacter()
   local character = LocalPlayer.Character
   if not character then
       character = LocalPlayer.CharacterAdded:Wait()
   end
   return character
end

-- Teleport Variables (stored in _G without spaces)
_G.HarbourJapan = false
_G.HarbourAmerica = false
_G.IslandA = false
_G.IslandB = false
_G.IslandC = false

-- Teleport locations coordinates (adjust these coordinates as needed)
local teleportPositions = {
    HarbourJapan = Vector3.new(-100, 10, 200),
    HarbourAmerica = Vector3.new(150, 10, -300),
    IslandA = Vector3.new(500, 20, 100),
    IslandB = Vector3.new(-250, 15, -500),
    IslandC = Vector3.new(750, 25, 400)
}

-- Function to teleport the player to the given position
local function TeleportPlayer(position)
    local character = getCharacter()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position)
        print("Teleported to position: " .. tostring(position))
    else
        warn("HumanoidRootPart not found!")
    end
end

-- Function to check the teleport variable and execute teleport
local function CheckAndTeleport(locationKey)
    if _G[locationKey] then
        print("Teleport to " .. locationKey .. " is active!")
        TeleportPlayer(teleportPositions[locationKey])
    else
        print("Teleport to " .. locationKey .. " is not active. Teleportation stopped.")
    end
end

-- Create teleport buttons for each location in the UI
local locations = {"HarbourJapan", "HarbourAmerica", "IslandA", "IslandB", "IslandC"}
for _, loc in ipairs(locations) do
    MainTab:CreateButton({
        Name = "Teleport to " .. loc,
        Callback = function()
            -- Toggle the teleport variable for this location
            _G[loc] = not _G[loc]
            CheckAndTeleport(loc)
        end
    })
end
