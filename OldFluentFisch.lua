-- 🍪 Cookie Hub (Fluent UI) - Complete Script
-- by Zepthical

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    -- Removed MinimizeKey argument (not valid in Fluent)
})

Window:Show()

local Button = Instance.new("TextButton")
Button.Parent = game.CoreGui
Button.Size = UDim2.new(0, 120, 0, 30)
Button.Position = UDim2.new(0.5, -60, 0, 100)
Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button.Text = "Open UI"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Active = true
Button.Draggable = true -- This makes it draggable easily

local open = true

Button.MouseButton1Click:Connect(function()
	open = not open
	if open then
		Window:Show()
		Button.Text = "Close UI"
	else
		Window:Hide()
		Button.Text = "Open UI"
	end
end)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Tabs
local Tabs = {
    Fishing = Window:AddTab({ Title = "Fishing", Icon = "fishing-pole" })
    --Auto = Window:AddTab({ Title = "Auto", Icon = "layers" }),
    --Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    --Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- States
local States = {
    AutoCast = false,
    AutoShake = false,
    AutoReel = false,
    InstantReel = false,
    AutoEquipRod = false,
    FreezeChar = false,
    AutoSell = false,
    WalkOnWater = false,
    NoClip = false,
    NoCamShake = false,
    DisableResources = false,
    HideIdenity = false,
    Speed = false,
    Jump = false
}

-- Fishing Functions
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getRod()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Tool")
end

local function Cast()
    local rod = getRod()
    if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
        rod.events.cast:FireServer(100, 1)
    end
end

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

local function Reel()
    task.wait(0.2)
    for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "reel" then
            local bar = v:FindFirstChild("bar")
            if bar and ReplicatedStorage:FindFirstChild("events") then
                local playerbar = bar:FindFirstChild("playerbar")
                if playerbar then
                    playerbar.Size = UDim2.new(1, 0, 1, 0)
                    bar.Visible = false
                    local reelFinished = ReplicatedStorage.events:FindFirstChild("reelfinished")
                    if reelFinished then
                        reelFinished:FireServer(100, true)
                    end
                end
            end
        end
    end
end

local function Reset()
    local rod = getRod()
    if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("reset") then
        task.wait(0.1)
        rod.events.reset:FireServer()
        local equipRemote = ReplicatedStorage.packages.Net:FindFirstChild("RE/Backpack/Equip")
        if equipRemote then
            equipRemote:FireServer(rod)
            task.wait(0.1)
            equipRemote:FireServer(rod)
        end
    end
end

local function RemoveExtraReels()
    local player = game.Players.LocalPlayer
    local playerGui = player:FindFirstChild("PlayerGui")
    
    if playerGui then
        local reels = playerGui:GetChildren()
        local reelCount = 0

        for _, child in ipairs(reels) do
            if child.Name == "reel" then
                reelCount = reelCount + 1
                if reelCount > 1 then
                    child:Destroy()
                end
            end
        end
    end
end

-- Fishing Tab
Tabs.Fishing:AddParagraph({
    Title = "Fishing Automation",
    Content = "Auto-fishing features"
})

Tabs.Fishing:AddToggle("AutoEquip", {
    Title = "Auto Equip Rod",
    Default = States.AutoEquipRod,
    Callback = function(Value)
        States.AutoEquipRod = Value
        while States.AutoEquipRod do
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("events") and tool.events:FindFirstChild("cast") then
                        local remote = ReplicatedStorage.packages.Net:FindFirstChild("RE/Backpack/Equip")
                        if remote then remote:FireServer(tool) end
                        break
                    end
                end
            end
            task.wait(1)
        end
    end
})

Tabs.Fishing:AddToggle("AutoCast", {
    Title = "Auto Cast",
    Default = States.AutoCast,
    Callback = function(Value)
        States.AutoCast = Value
        while States.AutoCast do
            local rod = getRod()
            if rod and rod:FindFirstChild("values") and not rod.values.casted.Value then
                Cast()
            end
            task.wait(0.45)
        end
    end
})

Tabs.Fishing:AddToggle("AutoShake", {
    Title = "Auto Shake",
    Default = States.AutoShake,
    Callback = function(Value)
        States.AutoShake = Value
        while States.AutoShake do
            Shake()
            Shake()
            task.wait(0.1)
        end
    end
})

Tabs.Fishing:AddToggle("AutoReel", {
    Title = "Auto Reel",
    Default = States.AutoReel,
    Callback = function(Value)
        States.AutoReel = Value
        while States.AutoReel do
            local rod = getRod()
            if rod and rod:FindFirstChild("values") and rod.values:FindFirstChild("bite") then
                if rod.values.bite.Value then
                    for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
                         if v:IsA("ScreenGui") and v.Name == "reel" then
                            local bar = v:FindFirstChild("bar")
                            if bar and ReplicatedStorage:FindFirstChild("events") then
                                local playerbar = bar:FindFirstChild("playerbar")
                                if playerbar then				
                                playerbar.Size = UDim2.new(1, 0, 1, 0) 
				task.wait(1.5)
                                Reel()
                                task.wait(0.5)
                                Reel()
				task.wait(1)
				if rod.values.bite.Value == true then
				   Reel()
				end
                                Reset()	
                             end
                          end
                       end
                    end                    
                    repeat task.wait(0.1) until not rod.values.bite.Value
                end
            end
            task.wait(0.1)
        end
    end
})

-- Fixed Duplicate InstantReel Toggle (only one should be kept)
Tabs.Main:AddToggle("InstantReel", 
{
    Title = "Instant Reel", 
    Description = "Instant Reel",
    Default = States.InstantReel,
    Callback = function(state)
        States.InstantReel = state
        while States.InstantReel do
            task.wait(0.1)
            local Rod = getRod()
            if Rod and Rod:FindFirstChild("values") and Rod.values:FindFirstChild("bite") then
                if Rod.values.bite.Value == true then
                    task.wait(1)
                    Reel()
                    task.wait(1)
                    if Rod.values.bite.Value == true then
                        Reel()
                    end
                end
            end
        end
    end
}) 


--[[Tabs.Auto:AddToggle("AutoSell", 
{
    Title = "Auto Sell All", 
    Description = "Sell all your fishes",
    Default = States.AutoSell,
    Callback = function(state)
	States.AutoSell = state
	while States.AutoSell do
	   local SellAll = ReplicatedStorage.events:FindFirstChild("SellAll")
	   if SellAll then
	      SellAll:InvokeServer()
	      task.wait(1.5)
	   end
	end
    end 
})

Tabs.Auto:AddToggle("AutoSell", {
    Title = "Auto Sell Items",
    Default = States.AutoSell,
    Callback = function(Value)
        States.AutoSell = Value
        while States.AutoSell do
            local SellAll = ReplicatedStorage.events:FindFirstChild("SellAll")
            if SellAll then SellAll:InvokeServer() end
            task.wait(1.5)
        end
    end
}) ]]

--[[ Player Tab
local walkSpeed = 16
local jumpPower = 50

Tabs.Player:AddInput("WalkSpeed", {
    Title = "WalkSpeed",
    Description = "Your WalkSpeed",
    Default = walkSpeed,
    Placeholder = "Default : 16",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
	States.Speed = Value
	while States.Speed do
           local char = getCharacter()
	   if char and char:FindFirstChild("Humanoid") then
	      char.Humanoid.WalkSpeed = Value
	      task.wait(1)
	   end
	end
    end
})

Tabs.Player:AddInput("JumpPower", {
    Title = "JumpPower",
    Description = "Your JumpPower",
    Default = jumpPower,
    Placeholder = "Default : 50",
    Numeric = true, -- Only allows numbers
    Finished = true, -- Only calls callback when you press enter
    Callback = function(Value)
	States.Jump = Value
	while States.Jump do
           local char = getCharacter()
	   if char and char:FindFirstChild("Humanoid") then
	      char.Humanoid.JumpPower = Value
	      task.wait(1)
	   end
	end
    end
}) ]]

--[[ Misc Tab

Tabs.Misc:AddToggle("Noclip", 
{
    Title = "Noclip", 
    Description = "Phase through walls",
    Default = States.NoClip,
    Callback = function(state)
	States.NoClip = state
	if Value then
	   local function nocliploop()
		while States.NoClip do
		local char = getCharacter()
		for _, v in pairs(char:GetDescendants()) do
		 if v:ISA("BasePart") then
		    v.CanCollide = false
		 end
	      end
	      task.wait(0.1)
	   end
	   coroutine.wrap(noclipLoop)()
	   else
	   	local char = getCharacter()
	   	for _, v in pairs(char:GetDescendants()) do
              	if v:IsA("BasePart") then
                 v.CanCollide = true
              end
           end
	end
    end 
}) ]]

--[[Tabs.Misc:AddToggle("NoClip", {
    Title = "NoClip",
    Default = States.NoClip,
    Callback = function(Value)
        States.NoClip = Value
        if Value then
            local function noclipLoop()
                while States.NoClip do
                    local char = getCharacter()
                    if char then
                        for _, v in pairs(char:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end
            coroutine.wrap(noclipLoop)()
        else
            local char = getCharacter()
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end
}) ]]

--[[ local Player = game.Players.LocalPlayer
local Character = Player and Player.Character
local Resources = Character and Character:FindFirstChild("Resources")
local gas = Resources and Resources:FindFirstChild("gas")
local oxygen = Resources and Resources:FindFirstChild("oxygen")
local peaksoxygen = Resources and Resources:FindFirstChild("oxygen(peaks)")
local temp = Resources and Resources:FindFirstChild("temperature")
local heat = Resources and Resources:FindFirstChild("temperature(heat)")

Tab.Misc:AddToggle("DisableResources", 
{
    Title = "Disable Resources", 
    Description = "Disable oxygen, heat, etc.",
    Default = States.DisableResources,
    Callback = function(state)
	if state then
	   gas.Disabled = Value
           oxygen.Disbaled = Value
           peaksoxygen.Disabled = Value
           temp.Disabled = Value
      	   heat.Disabled = Value
        end
    end 
})
	
Tabs.Misc:AddToggle("DisableResources", { -- old
   Title = "Disable Resources",
   Default = States.DisableResources,
   Callback = function(Value)
      if Value then				
          gas.Disabled = Value
          oxygen.Disbaled = Value
          peaksoxygen.Disabled = Value
          temp.Disabled = Value
      	  heat.Disabled = Value
       end			
   end
}) ]]

--[[Tabs.Misc:AddToggle("HideIdenity", 
{
    Title = "Hide Idenity", 
    Default = States.HideIdenity,
    Callback = function(state)
	_G.HideIdenity = state
	 while _G.HideIdentity do
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidrp = character and character:FindFirstChild("HumanoidRootPart")
            local usr = humanoidrp and humanoidrp:FindFirstChild("user")
            local hud = player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("hud")
            local sfzone = hud and hud:FindFirstChild("safezone") -- Fixed typo

            if sfzone then
                local lvl = sfzone:FindFirstChild("lvl")
                local coins = sfzone:FindFirstChild("coins")

                if lvl then 
                    lvl.Text = "Cookie Hub" 
                end
                if coins then 
                    coins.Text = "Cookie Hub" 
                end
            end
            
            if usr then
                local level = usr:FindFirstChild("level")
                local streak = usr:FindFirstChild("streak")
                local title = usr:FindFirstChild("title")
                local usertitle = usr:FindFirstChild("user")

                if level and level:IsA("TextLabel") then 
                    level.Text = "Cookie Hub" -- Fixed incorrect property
                end
                if streak and streak:IsA("TextLabel") then 
                    streak.Text = "Cookie Hub" -- Fixed incorrect property
                end
                if title and title:IsA("TextLabel") then 
                    title.Text = "Cookie Hub" -- Fixed incorrect property
                end
                if usertitle and usertitle:IsA("TextLabel") then 
                    usertitle.Text = "Cookie Hub" -- Fixed incorrect property
                end
            end

            task.wait(1) -- i love you guys :D
    end 
}) 
	
Tabs.Misc:AddToggle("HideIdenity", {
   Title = "Hide Idenity",
   Default = States.HideIdenity,
   Callback = function(Value)
        _G.HideIdentity = Value 

        while _G.HideIdentity do
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidrp = character and character:FindFirstChild("HumanoidRootPart")
            local usr = humanoidrp and humanoidrp:FindFirstChild("user")
            local hud = player:FindFirstChildOfClass("PlayerGui") and player.PlayerGui:FindFirstChild("hud")
            local sfzone = hud and hud:FindFirstChild("safezone") -- Fixed typo

            if sfzone then
                local lvl = sfzone:FindFirstChild("lvl")
                local coins = sfzone:FindFirstChild("coins")

                if lvl then 
                    lvl.Text = "Cookie Hub" 
                end
                if coins then 
                    coins.Text = "Cookie Hub" 
                end
            end
            
            if usr then
                local level = usr:FindFirstChild("level")
                local streak = usr:FindFirstChild("streak")
                local title = usr:FindFirstChild("title")
                local usertitle = usr:FindFirstChild("user")

                if level and level:IsA("TextLabel") then 
                    level.Text = "Cookie Hub" -- Fixed incorrect property
                end
                if streak and streak:IsA("TextLabel") then 
                    streak.Text = "Cookie Hub" -- Fixed incorrect property
                end
                if title and title:IsA("TextLabel") then 
                    title.Text = "Cookie Hub" -- Fixed incorrect property
                end
                if usertitle and usertitle:IsA("TextLabel") then 
                    usertitle.Text = "Cookie Hub" -- Fixed incorrect property
                end
            end

            task.wait(1) -- i love you guys :D
        end
    end
}) ]]

-- Initialize UI
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Misc)
SaveManager:BuildConfigSection(Tabs.Misc)

Window:SelectTab(1)

Fluent:Notify({
    Title = "🍪 Cookie Hub",
    Content = "Successfully loaded!",
    Duration = 5
})
