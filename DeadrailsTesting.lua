-- Rayfield UI Setup
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Create a window
local Window = Rayfield:CreateWindow({
    Name = "Deadrail Cookie Hub",
    LoadingTitle = "Deadrail Detected!",
    LoadingSubtitle = "Made By Nakhun12310",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "Deadrail",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    }
})

-- Create a tab for money-related tools
local MoneyTab = Window:CreateTab("Money Tools", 4483362458)

-- Add a button to "duplicate" money (for testing purposes)
MoneyTab:CreateButton({
    Name = "Duplicate Money",
    Callback = function()
        -- Replace this with your game's logic to add money
        local currentMoney = game:GetService("Players").LocalPlayer.leaderstats.Money.Value
        game:GetService("Players").LocalPlayer.leaderstats.Money.Value = currentMoney * 2
        Rayfield:Notify({
            Title = "Money Duplicated",
            Content = "Your money has been doubled for testing purposes.",
            Duration = 5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay",
                    Callback = function()
                        print("User acknowledged money duplication.")
                    end
                }
            }
        })
    end
})

-- Add a slider to set money to a specific amount
MoneyTab:CreateSlider({
    Name = "Set Money",
    Range = {0, 1000000},
    Increment = 1000,
    Suffix = "Money",
    CurrentValue = 0,
    Flag = "SetMoney",
    Callback = function(Value)
        -- Replace this with your game's logic to set money
        game:GetService("Players").LocalPlayer.leaderstats.Money.Value = Value
        Rayfield:Notify({
            Title = "Money Set",
            Content = "Money has been set to " .. Value,
            Duration = 5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay",
                    Callback = function()
                        print("User acknowledged money set.")
                    end
                }
            }
        })
    end
})
