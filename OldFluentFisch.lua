-- 🍪 Cookie Hub (Fluent UI) - Complete Script
-- by Zepthical

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "🍪| Cookie Hub Fisch " .. Fluent.Version,
    SubTitle = "By Zepthical",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 420),
    Acrylic = true,
    Theme = "Dark",
    -- Removed MinimizeKey argument (not valid in Fluent)
})

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RunService = game:GetService("RunService")


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
    local Rod = Char:FindFirstChildOfClass("Tool")
end

local function Cast()
    local rod = getRod()
    if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
    	task.wait(.1)
    	Rod.events.cast:FireServer(100,1)
    end
end

local function Shake()
    local PlayerGUI = LocalPlayer:FindFirstChild("PlayerGui")
    if not PlayerGUI then return end -- ถ้าไม่เจอ PlayerGui ก็หยุดทำงาน

    local shakeUI = PlayerGUI:FindFirstChild("shakeui")
    if not shakeUI or not shakeUI.Enabled then return end -- ถ้าไม่เจอ shakeUI หรือมันปิด ก็หยุดทำงาน

    local safezone = shakeUI:FindFirstChild("safezone")
    if not safezone then return end -- ถ้าไม่เจอ safezone ก็หยุดทำงาน

    local button = safezone:FindFirstChild("button")
    if button and button:IsA("ImageButton") and button.Visible then
        pcall(function() -- ใช้ pcall เพื่อกัน error
            GuiService.SelectedObject = button
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end)
    end
end

local function Reel()
    -- ลองลดเวลา wait() ให้เร็วที่สุด
    local rod = getRod()
    if not rod then return end
    
    -- ตรวจสอบค่าต่างๆ
    local reelUI = nil
    for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "reel" then
            reelUI = v
            break
        end
    end

    if not reelUI then return end
    local bar = reelUI:FindFirstChild("bar")
    if not bar then return end

    local playerbar = bar:FindFirstChild("playerbar")
    if not playerbar then return end

    local events = ReplicatedStorage:FindFirstChild("events")
    if not events then return end
    local reelFinished = events:FindFirstChild("reelfinished")
    if not reelFinished then return end

    -- รีลให้เต็ม
    playerbar.Size = UDim2.new(1, 0, 1, 0)
    bar.Visible = false

    -- ส่ง event ให้รีลเสร็จ
    pcall(function()
        reelFinished:FireServer(100, true)
    end)
end

local function Reset()
    local rod = getRod()
    if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("reset") then
        task.wait(0.1)
        rod.events.reset:FireServer()

        local equipRemote = ReplicatedStorage.packages.Net:FindFirstChild("RE/Backpack/Equip")
        if equipRemote then
            pcall(function()
                equipRemote:FireServer(rod)
                task.wait(0.1)
                equipRemote:FireServer(rod)
            end)
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
             if rod and rod:FindFirstChild("values") then
	      local casted = rod.values:FindFirstChild("casted")
	      if casted.Value == false then
		  pcall(function()
		  Cast()
	      end)
	   end
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
            task.wait() 
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
                -- ทำงานจนกว่าจะไม่มี bite
                while rod.values.bite.Value do
                    -- รีลในขณะที่ยังมี bite
                    local success, errorMessage = pcall(function()
                        Reel()
                    end)
                    if not success then
                        warn("Error in Reel: " .. errorMessage)
                    end

                    -- ใช้เวลารอให้เร็วที่สุด แต่ไม่บัค
                    task.wait(0.1) -- ใช้ wait แบบเร็วเพื่อไม่ให้เกิดการหน่วงมากเกินไป
                end
            end
            -- รอให้ครบเวลาจาก task.wait เพื่อให้การทำงานไม่กระทบกับ frame rate
            task.wait(0.1)
        end
    end
})

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
