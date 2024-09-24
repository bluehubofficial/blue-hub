-- Define main account's username
local mainAccountUsername = "88l9" -- Replace with your main account's username
local altAccountUsername = "887Q" -- Replace with your alt account's username

-- Get services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Keep track of the loop connection and animation track
local loopConnection = nil
local currentAnimationTrack = nil

-- Function to teleport the alt account closer behind the target player
local function teleportBehindTarget(altCharacter, targetCharacter)
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart")

    if targetHRP and altHRP then
        -- Position the alt account 1 stud behind the target
        local behindPosition = targetHRP.CFrame * CFrame.new(0, 0, 1)
        altHRP.CFrame = behindPosition
    end
end

-- Function to play the appropriate animation based on the player's rig type
local function playAnimation(altCharacter, isR15)
    local humanoid = altCharacter:FindFirstChild("Humanoid")
    if humanoid then
        -- R15 animation (ID: 5938365243)
        if isR15 then
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://5938365243" -- Updated R15 Animation ID
            local track = humanoid:LoadAnimation(animation)
            track:Play()
            track:AdjustSpeed(10) -- Speed up the R15 animation 10x
            return track
        else
            -- R6 animation (ID: 148831003) with 10x speed
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://148831003" -- R6 Animation ID
            local track = humanoid:LoadAnimation(animation)
            track:Play()
            track:AdjustSpeed(10) -- Speed up the R6 animation 10x
            return track
        end
    end
end

-- Function to handle chat message
local function onPlayerChatted(player, message)
    -- Check if the message sender is the main account
    if player.Name == mainAccountUsername then
        -- Get the main and alt players
        local mainPlayer = Players:FindFirstChild(mainAccountUsername)
        local altPlayer = Players:FindFirstChild(altAccountUsername)

        -- Check if both players are in the game
        if mainPlayer and altPlayer then
            local mainCharacter = mainPlayer.Character
            local altCharacter = altPlayer.Character

            if mainCharacter and altCharacter then
                -- Handle "!bring" command
                if message:lower() == "!bring" then
                    -- Get the HumanoidRootPart for positioning
                    local mainHRP = mainCharacter:FindFirstChild("HumanoidRootPart")
                    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart")

                    if mainHRP and altHRP then
                        -- Teleport the alt player's character to the main player's position
                        altHRP.CFrame = mainHRP.CFrame
                    end

                -- Handle "!bang (player)" command
                elseif string.sub(message:lower(), 1, 6) == "!bang " then
                    local targetUsername = string.sub(message, 7)
                    local targetPlayer = Players:FindFirstChild(targetUsername)

                    if targetPlayer and targetPlayer.Character then
                        local targetCharacter = targetPlayer.Character

                        -- Detect if the alt account is using R15 or R6
                        local humanoid = altCharacter:FindFirstChild("Humanoid")
                        local isR15 = humanoid and humanoid.RigType == Enum.HumanoidRigType.R15

                        -- Continuously teleport the alt account behind the target player
                        if loopConnection then
                            loopConnection:Disconnect() -- Stop any previous loop
                        end

                        loopConnection = RunService.Heartbeat:Connect(function()
                            if targetCharacter and altCharacter then
                                teleportBehindTarget(altCharacter, targetCharacter)
                            else
                                loopConnection:Disconnect() -- Stop the loop if the target or alt character is missing
                            end
                        end)

                        -- Play the animation once
                        currentAnimationTrack = playAnimation(altCharacter, isR15)
                    end

                -- Handle "!unbang" command
                elseif message:lower() == "!unbang" then
                    if loopConnection then
                        loopConnection:Disconnect() -- Stop the loop
                        loopConnection = nil
                    end

                    -- Stop the alt character's current animation
                    local humanoid = altCharacter:FindFirstChild("Humanoid")
                    if humanoid and currentAnimationTrack then
                        currentAnimationTrack:Stop() -- Stop the current animation
                        currentAnimationTrack = nil
                    end

                -- Handle "!reset" command
                elseif message:lower() == "!reset" then
                    -- Kill the alt account by setting its health to 0
                    local humanoid = altCharacter:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Health = 0
                    end
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
