local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🍪 | Cookie Hub",
   Icon = 0,
   LoadingTitle = "Loading, please wait...",
   LoadingSubtitle = "by Nakhun12310",
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

-- Define essential variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

-- Ensure Character Loads Properly
local function getCharacter()
   return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local Char = getCharacter()
local Backpack = LocalPlayer:FindFirstChild("Backpack")

-- Auto Variables
_G.AutoCast = false
_G.AutoShake = false
_G.AutoReel = false
_G.FreezeCharacter = false

-- Auto Cast Toggle
MainTab:CreateToggle({
   Name = "Auto Cast",
   Callback = function(v)
      _G.AutoCast = v
      spawn(function()
         while _G.AutoCast do
            task.wait(0.1)
            Char = getCharacter()
            local Rod = Char:FindFirstChildOfClass("Tool")
            if Rod and Rod:FindFirstChild("events") and Rod.events:FindFirstChild("cast") then
               -- Temporarily unfreeze the character for casting
               if _G.FreezeCharacter then
                  Char.HumanoidRootPart.Anchored = false
               end
               Rod.events.cast:FireServer(100, 1)
               -- Optionally, freeze the character again after casting
               if _G.FreezeCharacter then
                  Char.HumanoidRootPart.Anchored = true
               end
            end
         end
      end)
   end
})

-- Auto Shake Toggle
MainTab:CreateToggle({
   Name = "Auto Shake",
   Callback = function(v)
      _G.AutoShake = v
      spawn(function()
         while _G.AutoShake do
            task.wait(0.01)
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
      end)
   end
})

-- Auto Reel Toggle
MainTab:CreateToggle({
   Name = "Auto Reel",
   Callback = function(v)
      _G.AutoReel = v
      spawn(function()
         while _G.AutoReel do
            task.wait(0.15)
            for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
               if v:IsA("ScreenGui") and v.Name == "reel" then
                  local bar = v:FindFirstChild("bar")
                  if bar then
                     ReplicatedStorage.events.reelfinished:FireServer(100, true)
                  end
               end
            end
         end
      end)
   end
})

-- Freeze Character Toggle
MainTab:CreateToggle({
   Name = "Freeze Character",
   Callback = function(v)
      _G.FreezeCharacter = v
      spawn(function()
         while _G.FreezeCharacter do
            Char = getCharacter()
            if Char and Char:FindFirstChild("HumanoidRootPart") then
               Char.HumanoidRootPart.Anchored = true
            end
            task.wait(0.1)
         end
         -- Unfreeze when toggled off
         Char = getCharacter()
         if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char.HumanoidRootPart.Anchored = false
         end
      end)
   end
})

-- Auto Equip Fishing Rod
spawn(function()
   while task.wait(0.5) do
      if _G.AutoCast then
         Char = getCharacter()
         Backpack = LocalPlayer:FindFirstChild("Backpack")
         if Backpack then
            for _, v in pairs(Backpack:GetChildren()) do
               if v:IsA("Tool") and v.Name:lower():find("rod") then
                  v.Parent = Char
               end
            end
         end
      end
   end
end)
local TeleportTab = Window:CreateTab("Teleport", 4483362458) -- Title, Image
local Section = TeleportTab:CreateSection("Teleport")
local FishIslandLocations = {
   ["Moosewood"] = CFrame.new(100, 10, 50), -- Replace with actual coordinates
   ["Zone 2"] = CFrame.new(200, 10, 60), -- Replace with actual coordinates
   ["Zone 3"] = CFrame.new(300, 10, 70), -- Replace with actual coordinates
   ["Zone 4"] = CFrame.new(400, 10, 80), -- Replace with actual coordinates
   ["Zone 5"] = CFrame.new(500, 10, 90), -- Replace with actual coordinates
   ["Megalodon Spawn"] = CFrame.new(600, 10, 100), -- Replace with actual coordinates
   -- Add more zones as needed
}

-- Add buttons for each location
for zoneName, zoneCFrame in pairs(FishIslandLocations) do
   TeleportSection:CreateButton({
      Name = "Teleport to " .. zoneName,
      Callback = function()
         local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if rootPart then
            rootPart.CFrame = zoneCFrame -- Teleport to the specified location
            Rayfield:Notify({
               Title = "Teleported to " .. zoneName,
               Content = "You have been teleported to " .. zoneName .. "!",
               Duration = 3,
            })
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "Failed to teleport. Character not found.",
               Duration = 3,
            })
         end
      end,
   })
end
