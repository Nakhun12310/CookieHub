local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/zepthical/Vayfield/refs/heads/main/README.md'))()

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
      FileName = "sigma.lua"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 124714113910876)


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
_G.InstantShake = false
_G.AutoDropBobber = false
_G.InstantReel = false

local CharSection = MainTab:CreateSection("Character")

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

local MainSection = MainTab:CreateSection("Main")

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
               if _G.FreezeCharacter then
                  Char.HumanoidRootPart.Anchored = false
               end
               Rod.events.cast:FireServer(100, 1)
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
                     local playerbar = bar:FindFirstChild("playerbar")
                     playerbar.Size = UDim2.new(1, 0, 1, 0)
                     ReplicatedStorage.events.reelfinished:FireServer(100, true)
                  end
               end
            end
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
            task.wait(0.1) -- Adjust delay as needed
            Char = getCharacter()
            local Rod = Char:FindFirstChildOfClass("Tool")
            if Rod and Rod:FindFirstChild("events") and Rod.events:FindFirstChild("cast") then
               -- Temporarily unfreeze character if frozen
               if _G.FreezeCharacter then
                  Char.HumanoidRootPart.Anchored = false
               end
               -- Fire the cast event (drop bobber)
               Rod.events.cast:FireServer(100, 1) -- Adjust parameters if needed
               -- Re-freeze character if needed
               if _G.FreezeCharacter then
                  Char.HumanoidRootPart.Anchored = true
               end
            end
         end
      end)
   end
})

local Divider = MainTab:CreateDivider()

-- Instant Shake Toggle
MainTab:CreateToggle({
   Name = "Instant Shake",
   Callback = function(v)
      _G.InstantShake = v
      spawn(function()
         while _G.InstantShake do
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


-- Instant Reel Toggle
MainTab:CreateToggle({
   Name = "Instant Reel",
   Callback = function(v)
      _G.InstantReel = v
      spawn(function()
         while _G.InstantReel do
            for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
               if v:IsA("ScreenGui") and v.Name == "reel" then
                  local bar = v:FindFirstChild("bar")
                  if bar then
                     local playerbar = bar:FindFirstChild("playerbar")
                     playerbar.Size = UDim2.new(1, 0, 1, 0)
                     local Rod = Char:FindFirstChildOfClass("Tool")
                     if Rod and Rod:FindFirstChild("events") and Rod.events:FindFirstChild("cast") then
                       game:GetService("Players").LocalPlayer.Character:FindFirstChild(Rod).events.reset:FireServer()
                       task.wait(0.01)
                       game:GetService("Players").LocalPlayer.Character:FindFirstChild(Rod).events.reset:FireServer()
                       task.wait()
                       ReplicatedStorage.events.reelfinished:FireServer(100, true)
                       task.wait(0.01)
                       ReplicatedStorage.events.reelfinished:FireServer(100, true)
                    end
                  end
               end
            end
         end
      end)
   end
})

local AutoTab = Window:CreateTab("Auto", 124714113910876)
local AutoSection = MainTab:CreateSection("Auto")

-- Add this toggle under the other toggles in the script
AutoTab:CreateToggle({
   Name = "Auto Sell",
   Callback = function(v)
      _G.AutoSell = v
      spawn(function()
         while _G.AutoSell do
            game:GetService("ReplicatedStorage").events.SellAll:InvokeServer()
            task.wait(1.5)
         end
      end)
   end
})
