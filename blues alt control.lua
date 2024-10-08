-- Define main account's username
local mainAccountUsername = "88l9" -- Replace with your main account's username
local altAccountUsername = "887Q" -- Replace with your alt account's username

-- Get services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Keep track of loop connections, follow connections, shield connections, and animation tracks
local bangConnection = nil
local followConnection = nil
local shieldConnection = nil
local spinConnection = nil
local currentAnimationTrack = nil

-- Keep track of whitelisted and blacklisted players
local whitelistedPlayers = {}
local blacklistedPlayers = {}

-- Function to teleport the alt account closer behind the target player
local function teleportBehindTarget(altCharacter, targetCharacter)
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Torso")
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart") or altCharacter:FindFirstChild("Torso")

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
        -- R15 animation (ID: 10714068222)
        if isR15 then
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://10714068222" -- Updated R15 Animation ID
            local track = humanoid:LoadAnimation(animation)
            track:Play()
            track:AdjustSpeed(50) -- Speed up the R15 animation 50x
            return track
        else
            -- R6 animation (ID: 148831003) with 50x speed
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://148831003" -- R6 Animation ID
            local track = humanoid:LoadAnimation(animation)
            track:Play()
            track:AdjustSpeed(50) -- Speed up the R6 animation 50x
            return track
        end
    end
end

-- Function to make the alt account walk to and follow the target player
local function followTarget(altCharacter, targetCharacter)
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Torso")
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart") or altCharacter:FindFirstChild("Torso")
    local altHumanoid = altCharacter:FindFirstChild("Humanoid")

    if targetHRP and altHRP and altHumanoid then
        -- Move the alt account towards the target player's position
        altHumanoid:MoveTo(targetHRP.Position)
    end
end

-- Function to make the alt account act as a shield
local function shieldTarget(altCharacter, targetCharacter)
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart") or targetCharacter:FindFirstChild("Torso")
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart") or altCharacter:FindFirstChild("Torso")

    if targetHRP and altHRP then
        -- Position the alt account slightly in front of the target player (2 studs away)
        altHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2) -- 2 studs in front of the target
    end
end

-- Function to make the alt account spin around its position
local function spinAlt(altCharacter)
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart") or altCharacter:FindFirstChild("Torso")

    if altHRP then
        local spinAngle = 0
        local spinSpeed = math.rad(5) -- Increase the spin speed by 5x
        if spinConnection then
            spinConnection:Disconnect()
        end
        spinConnection = RunService.RenderStepped:Connect(function()
            if altHRP then
                spinAngle = spinAngle + spinSpeed
                altHRP.CFrame = altHRP.CFrame * CFrame.fromEulerAnglesXYZ(0, spinSpeed, 0)
            end
        end)
    end
end

-- Function to move the alt account to a specific position by teleporting
local function gotoPosition(altCharacter, position)
    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart") or altCharacter:FindFirstChild("Torso")

    if altHRP then
        -- Teleport the alt account to the specified position
        altHRP.CFrame = CFrame.new(position)
    end
end

-- Function to stop any ongoing bang, follow, shield, or spin loop
local function stopAllActions()
    if bangConnection then
        bangConnection:Disconnect()
        bangConnection = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    if shieldConnection then
        shieldConnection:Disconnect()
        shieldConnection = nil
    end
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
    if currentAnimationTrack then
        currentAnimationTrack:Stop()
        currentAnimationTrack = nil
    end
end

-- Function to reset (kill) the alt account
local function resetAlt()
    local altPlayer = Players:FindFirstChild(altAccountUsername)
    if altPlayer and altPlayer.Character then
        local humanoid = altPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0 -- Kills the alt account
        end
    end
end

-- Function to handle chat messages
local function onPlayerChatted(player, message)
    -- Check if the message sender is the main account, a whitelisted player, or not blacklisted
    if (player.Name == mainAccountUsername or whitelistedPlayers[player.Name]) and not blacklistedPlayers[player.Name] then
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
                    local mainHRP = mainCharacter:FindFirstChild("HumanoidRootPart") or mainCharacter:FindFirstChild("Torso")
                    local altHRP = altCharacter:FindFirstChild("HumanoidRootPart") or altCharacter:FindFirstChild("Torso")

                    if mainHRP and altHRP then
                        -- Teleport the alt player to the main player's position
                        altHRP.CFrame = mainHRP.CFrame
                    end
                end

                -- Handle "!bang (player)" command
                local bangCommand, targetUsername = message:match("^(%S+)%s+(%S+)$")
                if bangCommand and targetUsername then
                    local targetPlayer = Players:FindFirstChild(targetUsername)

                    if targetPlayer and targetPlayer.Character then
                        -- Start looping teleport behind the target player
                        stopAllActions() -- Stop any previous bang, follow, or shield loop

                        bangConnection = RunService.RenderStepped:Connect(function()
                            teleportBehindTarget(altCharacter, targetPlayer.Character)
                        end)

                        -- Play animation (R15 or R6 based on rig type)
                        local isR15 = (altCharacter:FindFirstChild("Humanoid").RigType == Enum.HumanoidRigType.R15)
                        currentAnimationTrack = playAnimation(altCharacter, isR15)
                    end
                end

                -- Handle "!follow (player)" command
                if string.sub(message:lower(), 1, 7) == "!follow" then
                    local targetUsername = string.sub(message, 8):gsub("%s+", "")
                    local targetPlayer = Players:FindFirstChild(targetUsername)

                    if targetPlayer and targetPlayer.Character then
                        -- Start following the target player by walking
                        stopAllActions() -- Stop any previous bang, follow, or shield loop

                        followConnection = RunService.Heartbeat:Connect(function()
                            followTarget(altCharacter, targetPlayer.Character)
                        end)
                    end
                end

                -- Handle "!shield (player)" command
                if string.sub(message:lower(), 1, 7) == "!shield" then
                    local targetUsername = string.sub(message, 8):gsub("%s+", "")
                    local targetPlayer = Players:FindFirstChild(targetUsername)

                    if targetPlayer and targetPlayer.Character then
                        -- Start shielding the target player
                        stopAllActions() -- Stop any previous bang, follow, or shield loop

                        shieldConnection = RunService.RenderStepped:Connect(function()
                            shieldTarget(altCharacter, targetPlayer.Character)
                        end)
                    end
                end

                -- Handle "!spin" command
                if message:lower() == "!spin" then
                    stopAllActions() -- Stop any previous action
                    spinAlt(altCharacter) -- Start spinning the alt account
                end

                -- Handle "!unspin" command
                if message:lower() == "!unspin" then
                    if spinConnection then
                        spinConnection:Disconnect()
                        spinConnection = nil
                    end
                end

                -- Handle "!goto (player)" command
                local gotoCommand, targetUsername = message:match("^(%S+)%s+(%S+)$")
                if gotoCommand == "!goto" and targetUsername then
                    local targetPlayer = Players:FindFirstChild(targetUsername)

                    if targetPlayer and targetPlayer.Character then
                        -- Teleport the alt account to the target player's position
                        stopAllActions() -- Stop any previous action

                        gotoPosition(altCharacter, targetPlayer.Character.HumanoidRootPart.Position)
                    end
                end

                -- Handle "!unfollow", "!unbang", and "!unshield" commands
                if message:lower() == "!unfollow" or message:lower() == "!unbang" or message:lower() == "!unshield" then
                    stopAllActions() -- Stop following, teleporting behind, or shielding the target
                end

                -- Handle "!reset" command
                if message:lower() == "!reset" then
                    resetAlt() -- Kill the alt account
                end

                -- Handle "!whitelist (player)" command
                local whitelistCommand, targetUsername = message:match("^(%S+)%s+(%S+)$")
                if whitelistCommand == "!whitelist" and targetUsername then
                    local targetPlayer = Players:FindFirstChild(targetUsername)
                    if targetPlayer then
                        whitelistedPlayers[targetUsername] = true
                        blacklistedPlayers[targetUsername] = nil -- Remove from blacklist
                    end
                end

                -- Handle "!blacklist (player)" command
                local blacklistCommand, targetUsername = message:match("^(%S+)%s+(%S+)$")
                if blacklistCommand == "!blacklist" and targetUsername then
                    local targetPlayer = Players:FindFirstChild(targetUsername)
                    if targetPlayer then
                        blacklistedPlayers[targetUsername] = true
                        whitelistedPlayers[targetUsername] = nil -- Remove from whitelist
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
