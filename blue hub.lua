local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "blue's script hub lmfao",
   LoadingTitle = "welcome.",
   LoadingSubtitle = "by blue",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local UPTab = Window:CreateTab("Universal/Player", 4483362458) -- Title, Image
local UPSection = UPTab:CreateSection("player controls")
local SpeedSlider = UPTab:CreateSlider({
   Name = "walkspeed",
   Range = {0, 500},
   Increment = 1,
   Suffix = "",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

local JumpSlider = UPTab:CreateSlider({
   Name = "jumppower",
   Range = {0, 500},
   Increment = 1,
   Suffix = "",
   CurrentValue = 50,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

local HipHeightSlider = UPTab:CreateSlider({
   Name = "hipheight",
   Range = {0, 500},
   Increment = 1,
   Suffix = "",
   CurrentValue = 0,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   game.Players.LocalPlayer.Character.Humanoid.HipHeight = Value
   end,
})

local ResetButton = UPTab:CreateButton({
   Name = "reset",
   Callback = function()
   game.Players.LocalPlayer.Character.Humanoid.Health = 0
   end,
})

local ESPSection = UPTab:CreateSection("highlights all the players")
local ESPToggle = UPTab:CreateToggle({
   Name = "esp",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- LocalScript in StarterPlayerScripts or StarterCharacterScripts

-- Define a global environment toggle
getgenv().highlightToggle = Value; -- Set initial state to true or false

-- Function to add highlight to a player
local function highlightPlayer(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChildOfClass("Highlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Adornee = character
            highlight.Parent = character
        end
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
    end
end

-- Function to remove highlight from a player
local function removeHighlightFromPlayer(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Function to update highlights based on the global toggle
local function updateHighlight()
    local isEnabled = getgenv().highlightToggle
    for _, player in ipairs(game.Players:GetPlayers()) do
        if isEnabled then
            highlightPlayer(player)
        else
            removeHighlightFromPlayer(player)
        end
    end
end

-- Initial update
updateHighlight()

-- Monitor player addition and removal
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        updateHighlight()
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeHighlightFromPlayer(player)
end)

-- Watch for changes to the global toggle
while true do
    updateHighlight()
    wait(1) -- Check every second
end
   end,
})

local NameTagToggle = UPTab:CreateToggle({
   Name = "nametag",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- LocalScript in StarterPlayerScripts or StarterCharacterScripts

-- Define a global environment toggle
getgenv().highlightToggle = Value;  -- Set initial state to true or false

-- Function to add highlight to a player
local function highlightPlayer(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChildOfClass("Highlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Highlight"
            highlight.Adornee = character
            highlight.Parent = character
        end
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red color
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
    end
end

-- Function to remove highlight from a player
local function removeHighlightFromPlayer(player)
    local character = player.Character
    if character then
        local highlight = character:FindFirstChild("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Function to update highlights based on the global toggle
local function updateHighlight()
    local isEnabled = getgenv().highlightToggle
    for _, player in ipairs(game.Players:GetPlayers()) do
        if isEnabled then
            highlightPlayer(player)
        else
            removeHighlightFromPlayer(player)
        end
    end
end

-- Initial update
updateHighlight()

-- Monitor player addition and removal
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        updateHighlight()
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeHighlightFromPlayer(player)
end)

-- Watch for changes to the global toggle
while true do
    updateHighlight()
    wait(1) -- Check every second
end
   end,
})

local Toggle = UPTab:CreateToggle({
   Name = "Toggle Example",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   -- LocalScript in StarterPlayerScripts or StarterCharacterScripts

-- Define a global environment toggle
getgenv().tracerToggle = Value; -- Set initial state to true or false

-- Function to create a tracer for a player
local function createTracer(player)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Create an Attachment on HumanoidRootPart
            local attachment0 = Instance.new("Attachment")
            attachment0.Name = "TracerAttachment"
            attachment0.Parent = humanoidRootPart

            -- Create an Attachment in world space to act as the target
            local attachment1 = Instance.new("Attachment")
            attachment1.Name = "TargetAttachment"
            attachment1.Parent = game.Workspace

            -- Create a Beam
            local beam = Instance.new("Beam")
            beam.Name = "Tracer"
            beam.Parent = humanoidRootPart
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0)) -- Red color
            beam.Width0 = 0.2
            beam.Width1 = 0.2
            beam.Attachment0 = attachment0
            beam.Attachment1 = attachment1
            beam.CurveSize0 = 0
            beam.CurveSize1 = 0
            beam.Enabled = true
            
            -- Update attachment1 position to camera center
            local function updateTracer()
                local camera = game.Workspace.CurrentCamera
                if camera then
                    attachment1.WorldPosition = camera.CFrame.Position
                end
            end

            -- Run update function every frame
            game:GetService("RunService").RenderStepped:Connect(updateTracer)
        end
    end
end

-- Function to remove tracers from a player
local function removeTracerFromPlayer(player)
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local tracer = humanoidRootPart:FindFirstChild("Tracer")
            if tracer then
                tracer:Destroy()
            end
            local attachment = humanoidRootPart:FindFirstChild("TracerAttachment")
            if attachment then
                attachment:Destroy()
            end
        end
    end
end

-- Function to update tracers based on the global toggle
local function updateTracers()
    local isTracerEnabled = getgenv().tracerToggle
    for _, player in ipairs(game.Players:GetPlayers()) do
        if isTracerEnabled then
            createTracer(player)
        else
            removeTracerFromPlayer(player)
        end
    end
end

-- Initial update
updateTracers()

-- Monitor player addition and removal
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        updateTracers()
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeTracerFromPlayer(player)
end)

-- Watch for changes to the global toggle
while true do
    updateTracers()
    wait(1) -- Check every second
end
   end,
})
