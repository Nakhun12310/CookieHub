local placeId = game.PlaceId
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.35, 0, 0.4, 0)
frame.Position = UDim2.new(0.325, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.Parent = frame

local linkBox = Instance.new("TextBox")
linkBox.Size = UDim2.new(0.9, 0, 0.3, 0)
linkBox.Position = UDim2.new(0.05, 0, 0.3, 0)
linkBox.BackgroundTransparency = 0.2
linkBox.TextScaled = true
linkBox.TextColor3 = Color3.fromRGB(0, 255, 0)
linkBox.Text = "Loading..."
linkBox.ClearTextOnFocus = false
linkBox.Parent = frame

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.25, 0, 0.15, 0)
copyButton.Position = UDim2.new(0.375, 0, 0.65, 0)
copyButton.Text = "Copy"
copyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0.15, 0)
closeButton.Position = UDim2.new(0.35, 0, 0.8, 0)
closeButton.Text = "Close"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 5)
copyCorner.Parent = copyButton

-- Mapping place IDs to raw GitHub links
local repoUrl = "https://raw.githubusercontent.com/yourusername/yourrepo/main/"
local placeHubMapping = {
    [123456789] = {name = "Fisch", link = "https://raw.githubusercontent.com/Nakhun12310/CookieHub/refs/heads/main/Fisch.lua", file = "map1.lua"},
    [987654321] = {name = "Hub for Map 2", link = "https://github.com/yourrepo2", file = "map2.lua"},
    [112233445] = {name = "Hub for Map 3", link = "https://github.com/yourrepo3", file = "map3.lua"}
}

-- Set the correct title and link based on the place ID
if placeHubMapping[placeId] then
    title.Text = "Welcome to " .. placeHubMapping[placeId].name
    linkBox.Text = placeHubMapping[placeId].link
    
    -- Attempt to load the corresponding GitHub script
    local fileUrl = repoUrl .. placeHubMapping[placeId].file
    local success, response = pcall(function()
        return game:HttpGet(fileUrl, true)
    end)

    if success then
        loadstring(response)()
    else
        warn("Failed to load script from GitHub: " .. fileUrl)
    end
else
    title.Text = "Welcome to the Cookie Hub"
    linkBox.Text = "No specific hub found."
end

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    setclipboard(linkBox.Text)
    copyButton.Text = "Copied!"
    wait(1)
    copyButton.Text = "Copy"
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
