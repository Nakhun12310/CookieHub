local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/zepthical/Vayfield/refs/heads/main/README.md'))()
 
 local Window = Rayfield:CreateWindow({
    Name = "🍪 | Cookie Hub DEV",
    Icon = 0,
    LoadingTitle = "CookieHub DEV",
    LoadingSubtitle = "by Zepthical",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "cdev.lua"
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
    Content = "Don't forget to save the configs! [Settings]",
    Duration = 6.5,
    Image = 124714113910876,
 })
 
 -- Define essential variables
 local Players = game:GetService("Players")
 local LocalPlayer = Players.LocalPlayer
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
 local VirtualInputManager = game:GetService("VirtualInputManager")
 local GuiService = game:GetService("GuiService")
 
 --------------------------------------------------------------------

local function Shake()
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

local function Shake2()
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

--------------------------------------------------------------------


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
 _G.AutoDropBobber = false
 _G.InstantReel = false
 
 local CharSection = MainTab:CreateSection("Character")
 
 -- Freeze Character Toggle
 MainTab:CreateToggle({
    Name = "Freeze Character",
    Flag = "FChar",
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
 
local function getRod()
    local Char = LocalPlayer.Character
    if Char then
        return Char:FindFirstChildOfClass("Tool")
    end
    return nil
end

local function Cast()
    local Char = game:GetService("Players").LocalPlayer.Character
    if not Char then return end

    local Rod = Char:FindFirstChildOfClass("Tool") -- Finds the fishing rod
    if Rod and Rod:FindFirstChild("events") and Rod.events:FindFirstChild("cast") then
        Rod.events.cast:FireServer(100, 1)
    else
        warn("Rod or cast event not found!")
    end
end

-- Auto Cast Toggle
MainTab:CreateToggle({
    Name = "Auto Cast",
    Flag = "ACast",
    Callback = function(v)
        _G.AutoCast = v
        spawn(function()
            while _G.AutoCast do
                task.wait(0.1)
                local Rod = getRod()
                if Rod and Rod:FindFirstChild("values") and Rod.values:FindFirstChild("casted") then
                    if Rod.values.casted.Value == false then
                        Cast()
                    end
                else
                    warn("rod is missing egypt properties.")
                end
            end
        end)
    end
})



 
 MainTab:CreateToggle({
    Name = "Auto Shake",
    Flag = "AShake",
    Callback = function(v)
    _G.AutoShake = v
       spawn(function()
          while _G.AutoShake do
             Shake()
             Shake2()
             task.wait(0.01)
          end
       end)
    end
 })

local function Reel()
      task.wait(0.15)
      for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
      if v:IsA("ScreenGui") and v.Name == "reel" then
       local bar = v:FindFirstChild("bar")
       if bar and ReplicatedStorage:FindFirstChild("events") then
         local playerbar = bar:FindFirstChild("playerbar")
         if playerbar then
           playerbar.Size = UDim2.new(1, 0, 1, 0)
           local reelFinished = ReplicatedStorage.events:FindFirstChild("reelfinished")
           if reelFinished then
             reelFinished:FireServer(100, true)
          end   
        end
      end
    end
  end
end


-- Auto Reel Toggle
MainTab:CreateToggle({
    Name = "Auto Reel",
    Flag = "AReel",
    Callback = function(v)
        _G.AutoReel = v
        spawn(function()
            while _G.AutoReel do
                task.wait(0.1)
                local Rod = getRod()
                if Rod and Rod:FindFirstChild("values") and Rod.values:FindFirstChild("bite") then
                    if Rod.values.bite.Value == true then  -- Only reel if fish is biting
                        Reel()
                    end
                end
            end
        end)
    end
})

 
 
 -- Auto Drop Bobber Toggle
 MainTab:CreateToggle({
    Name = "Auto Drop Bobber",
    Flag = "DropBob",
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

 local function Reset()
  local Rod = Char and Char:FindFirstChildOfClass("Tool")
  if Rod and Rod:FindFirstChild("events") and Rod.events:FindFirstChild("reset") then
     task.wait(0.1)
     Rod.events.reset:FireServer()
  end                              
end


-- Instant Reel Toggle
MainTab:CreateToggle({
    Name = "Instant Reel[In-dev]",
    Flag = "InsReel",
    Callback = function(v)
        _G.InstantReel = v
        spawn(function()
            while _G.InstantReel do
                task.wait(0.1)
                local Rod = getRod()
                if Rod and Rod:FindFirstChild("values") and Rod.values:FindFirstChild("bite") then
                    if Rod.values.bite.Value == true then  -- Only instant reel if fish is biting
                        Reset()
                        task.wait(0.03)
                        Reset()
                        task.wait(0.01)

                        local PlayerGUI = LocalPlayer:FindFirstChild("PlayerGui")
                        local reelUI = PlayerGUI and PlayerGUI:FindFirstChild("reel")
                        if reelUI then
                            local bar = reelUI:FindFirstChild("bar")
                            if bar then
                                local playerbar = bar:FindFirstChild("playerbar")
                                if playerbar then
                                    playerbar.Size = UDim2.new(1, 0, 1, 0)
                                    task.wait(0.02)
                                    local reelFinished = ReplicatedStorage:FindFirstChild("events") and ReplicatedStorage.events:FindFirstChild("reelfinished")
                                    if reelFinished then
                                        reelFinished:FireServer(100, true)
                                        task.wait(0.04)
                                        reelFinished:FireServer(100, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
})
 
 
 
 local AutoTab = Window:CreateTab("Auto", 124714113910876)
 local AutoSection = AutoTab:CreateSection("Auto")
 
AutoTab:CreateToggle({
    Name = "Auto Sell",
    Flag = "ASell",
    Callback = function(v)
        _G.AutoSell = v
        spawn(function()
            while _G.AutoSell do
                local SellAllEvent = game:GetService("ReplicatedStorage").events:FindFirstChild("SellAll")
                if SellAllEvent then
                    SellAllEvent:InvokeServer()
                end
                task.wait(1.5)
            end
        end)
    end
})

Rayfield:LoadConfiguration()
