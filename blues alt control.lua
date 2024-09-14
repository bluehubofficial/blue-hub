-- Define main account's username
local mainAccountUsername = mainacc -- Replace with your main account's username
local altAccountUsername = altacc -- Replace with your alt account's username

-- Get services
local Players = game:GetService("Players")

-- Function to handle chat message
local function onPlayerChatted(player, message)
    -- Check if the message sender is the main account and the message is "!bring"
    if player.Name == mainAccountUsername and message:lower() == "!bring" then
        -- Get the main and alt players
        local mainPlayer = Players:FindFirstChild(mainAccountUsername)
        local altPlayer = Players:FindFirstChild(altAccountUsername)

        -- Check if both players are in the game
        if mainPlayer and altPlayer then
            -- Get their characters
            local mainCharacter = mainPlayer.Character
            local altCharacter = altPlayer.Character

            if mainCharacter and altCharacter then
                -- Get the HumanoidRootPart for positioning
                local mainHRP = mainCharacter:FindFirstChild("HumanoidRootPart")
                local altHRP = altCharacter:FindFirstChild("HumanoidRootPart")

                if mainHRP and altHRP then
                    -- Teleport the alt player's character to the main player's position
                    altHRP.CFrame = mainHRP.CFrame
                end
            end
        end
    end
end

-- Connect to the PlayerAdded event for current and new players
Players.PlayerAdded:Connect(function(player)
    -- Connect the Chatted event to the new player
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)

-- For players already in the game when the script runs (optional)
for _, player in pairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end
