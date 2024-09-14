-- Define main account's username
local mainAccountUsername = "88l9" -- Replace with your main account's username
local altAccountUsername = "887Q" -- Replace with your alt account's username

-- Get services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function to teleport the alt account behind the target player, closer this time
local function teleportBehindTarget(altCharacter, targetCharacter)
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart")

    if targetHRP and altHRP then
        -- Calculate the position slightly closer behind the target player
        local behindPosition = targetHRP.CFrame * CFrame.new(0, 0, 2) -- Adjusted distance
        altHRP.CFrame = behindPosition
    end
end

-- Function to play the appropriate animation based on the player's rig type
local function playAnimation(altCharacter, isR15)
    local humanoid = altCharacter:FindFirstChild("Humanoid")
    if humanoid then
        -- R15 Dolphin Flop emote
        if isR15 then
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://2510202577" -- Dolphin Flop emote ID
            local track = humanoid:LoadAnimation(animation)
            track:Play()
        else
            -- R6 custom animation (new ID provided)
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://148831003" -- Updated R6 animation
            local track = humanoid:LoadAnimation(animation)
            track:Play()
        end
    end
end

-- Function to handle chat message
local function onPlayerChatted(player, message)
    if player.Name == mainAccountUsername then
        local mainPlayer = Players:FindFirstChild(mainAccountUsername)
        local altPlayer = Players:FindFirstChild(altAccountUsername)

        if mainPlayer and altPlayer then
            local mainCharacter = mainPlayer.Character
            local altCharacter = altPlayer.Character

            if mainCharacter and altCharacter then
                -- Handle "!bring" command
                if message:lower() == "!bring" then
                    local mainHRP = mainCharacter:FindFirstChild("HumanoidRootPart")
                    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart")

                    if mainHRP and altHRP then
                        altHRP.CFrame = mainHRP.CFrame
                    end
                -- Handle "!bang (player)" command
                elseif string.sub(message:lower(), 1, 6) == "!bang " then
                    local targetUsername = string.sub(message, 7)
                    local targetPlayer = Players:FindFirstChild(targetUsername)

                    if targetPlayer and targetPlayer.Character then
                        local targetCharacter = targetPlayer.Character
                        local altHRP = altCharacter:FindFirstChild("HumanoidRootPart")

                        -- Detect if the alt account is using R15 or R6
                        local humanoid = altCharacter:FindFirstChild("Humanoid")
                        local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15

                        -- Loop to keep teleporting the alt account behind the target player
                        RunService.Stepped:Connect(function()
                            if altCharacter and targetCharacter then
                                teleportBehindTarget(altCharacter, targetCharacter)
                            end
                        end)

                        -- Play the appropriate animation once after teleporting
                        playAnimation(altCharacter, isR15)
                    end
                end
            end
        end
    end
end

-- Connect to the PlayerAdded event for current and new players
Players.PlayerAdded:Connect(function(player)
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
