-- Define main account's username
local mainAccountUsername = "88l9" -- Replace with your main account's username
local altAccountUsername = "887Q" -- Replace with your alt account's username

-- Get services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Function to teleport the alt account closer behind the target player
local function teleportBehindTarget(altCharacter, targetCharacter)
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart")

    if targetHRP and altHRP then
        -- Position the alt account closer behind the target (closer than before)
        local behindPosition = targetHRP.CFrame * CFrame.new(0, 0, 2) -- 2 studs behind the target
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
            -- R6 animation (ID: 148831003) with 5x speed
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://148831003" -- R6 Animation ID
            local track = humanoid:LoadAnimation(animation)
            track:Play()
            track:AdjustSpeed(5) -- Speed up the animation 5x
        end
    end
end

-- Function to handle the "!bang" command and continuously teleport the alt account
local function startTeleportLoop(targetPlayer, altPlayer)
    local targetCharacter = targetPlayer.Character
    local altCharacter = altPlayer.Character

    if targetCharacter and altCharacter then
        local humanoid = altCharacter:FindFirstChild("Humanoid")
        local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15

        -- Play the animation once at the start
        playAnimation(altCharacter, isR15)

        -- Continuously teleport behind the target
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if targetCharacter and altCharacter then
                teleportBehindTarget(altCharacter, targetCharacter)
            else
                -- Stop the loop if characters are not found
                connection:Disconnect()
            end
        end)
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
                        startTeleportLoop(targetPlayer, altPlayer)
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

-- For players already in the game when the script runs
for _, player in pairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end
