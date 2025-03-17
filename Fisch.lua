-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "🍪 | Cookie Hub",
   Icon = 124714113910876,
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
   local character = LocalPlayer.Character
   if not character then
       character = LocalPlayer.CharacterAdded:Wait()
   end
   return character
end

local Char = getCharacter()
local Backpack = LocalPlayer:FindFirstChild("Backpack")

-- Auto Variables
_G.AutoCast = false
_G.AutoShake = false
_G.AutoReel = false
_G.FreezeCharacter = false
_G.InstantShake = false
_G.AutoDropBobber = false
_G.InstantReel = false

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
            if Rod and Rod:FindFirstChild("events") then
               local castEvent = Rod.events:FindFirstChild("cast")
               if castEvent then
                  if _G.FreezeCharacter then
                     Char.HumanoidRootPart.Anchored = false
                  end
                  castEvent:FireServer(100, 1)
                  if _G.FreezeCharacter then
                     Char.HumanoidRootPart.Anchored = true
                  end
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
            if PlayerGUI then
               local shakeUI = PlayerGUI:FindFirstChild("shakeui")
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
                  if bar and ReplicatedStorage:FindFirstChild("events") then
                     local reelFinished = ReplicatedStorage.events:FindFirstChild("reelfinished")
                     if reelFinished then
                        reelFinished:FireServer(100, true)
                     end
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

-- Auto Drop Bobber Toggle
MainTab:CreateToggle({
   Name = "Auto Drop Bobber",
   Callback = function(v)
      _G.AutoDropBobber = v
      spawn(function()
         while _G.AutoDropBobber do
            task.wait(0.1)
            Char = getCharacter()
            local Rod = Char:FindFirstChildOfClass("Tool")
            if Rod and Rod:FindFirstChild("events") then
               local castEvent = Rod.events:FindFirstChild("cast")
               if castEvent then
                  if _G.FreezeCharacter then
                     Char.HumanoidRootPart.Anchored = false
                  end
                  castEvent:FireServer(100, 1)
                  if _G.FreezeCharacter then
                     Char.HumanoidRootPart.Anchored = true
                  end
               end
            end
         end
      end)
   end
})

-- Auto Sell Toggle
local AutoTab = Window:CreateTab("Auto", 124714113910876)
local AutoSection = AutoTab:CreateSection("Auto")

AutoTab:CreateToggle({
   Name = "Auto Sell",
   Callback = function(v)
      _G.AutoSell = v
      spawn(function()
         while _G.AutoSell do
            local sellEvent = ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("SellAll")
            if sellEvent then
               sellEvent:InvokeServer()
            else
               warn("Sell event not found.")
            end
            task.wait(1.5)
         end
      end)
   end
})
