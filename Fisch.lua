local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Cookie Hub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading Please wait.",
   LoadingSubtitle = "by Nakhun12310",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Cookie Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Cookie Hub",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"BetaAccess"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("🏠 | Main", 124714113910876) -- Title, Image
local MainSection = MainTab:CreateSection("Main")
Rayfield:Notify({
   Title = "Welcome to Cookie Hub!",
   Content = "Enjoy Your Scripts!",
   Duration = 6.5,
   Image = 124714113910876,
})

local Button = MainTab:CreateButton({
   Name = "Auto Farm",
   Callback = function()
   --[[
    Open Src AutoFisch Script By : NOOBHUB
]]
local Player = game:GetService("Players")
local LocalPlayer = Player.LocalPlayer
local Char = LocalPlayer.Character
local Humanoid = Char.Humanoid
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

equipitem = function(v)
if LocalPlayer.Backpack:FindFirstChild(v) then
    local a = LocalPlayer.Backpack:FindFirstChild(v)
        Humanoid:EquipTool(a)
    end
end


local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fisch", "DarkTheme")
local Tab = Window:NewTab("MAIN")
local Section = Tab:NewSection("MAIN")

-- AutoCast
Section:NewToggle("AutoCast", "", function(v)
_G.AutoCast = v
     pcall(function()
while _G.AutoCast do wait()
    local Rod = Char:FindFirstChildOfClass("Tool")
                task.wait(.1)
                    Rod.events.cast:FireServer(100,1)
        end
    end)
end)

Section:NewToggle("AutoShake", "", function(v)
    _G.AutoShake = v
pcall(function()
while _G.AutoShake do wait()
              task.wait(0.01)
                local PlayerGUI = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
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
    end)
end)
-- AutoReel
Section:NewToggle("AutoReel", "", function(v)
     _G.AutoReel = v
pcall(function()
    while _G.AutoReel do wait()
            for i,v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
                if v:IsA "ScreenGui" and v.Name == "reel"then
                    if v:FindFirstChild "bar" then
                        wait(.15)
                            ReplicatedStorage.events.reelfinished:FireServer(100,true)
                    end
                end
            end
        end
    end)
end)

Section:NewToggle("Freeze Character", "", function(v)
    Char.HumanoidRootPart.Anchored = v
end)

-- equipitem
spawn(function()
    while wait() do
        if _G.AutoCast then
            pcall(function()
                for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:IsA ("Tool") and v.Name:lower():find("rod") then
                    equipitem(v.Name)
                    end
                end
            end)
        end
    end
end)
   end,
})
