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
-- LocalScript in StarterPlayerScripts

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Variables
local nametagEnabled = Value; -- Initial state of nametags

-- Function to create a nametag for a player's character
local function createNametag(character)
    if not character or not character:IsA("Model") then return end

    local head = character:FindFirstChild("Head")
    if not head then return end

    local nametag = head:FindFirstChild("Nametag")
    if not nametag then
        nametag = Instance.new("BillboardGui")
        nametag.Name = "Nametag"
        nametag.Parent = head
        nametag.Size = UDim2.new(0, 150, 0, 75) -- Smaller size
        nametag.StudsOffset = Vector3.new(0, 2, 0) -- Adjusted offset
        nametag.AlwaysOnTop = true
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = nametag
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = character.Name
        textLabel.TextSize = 20 -- Smaller text size
        textLabel.TextScaled = true -- Adjust text size to fit the label
    end
end

-- Function to remove the nametag from a player's character
local function removeNametag(character)
    if character then
        local nametag = character:FindFirstChild("Head"):FindFirstChild("Nametag")
        if nametag then
            nametag:Destroy()
        end
    end
end

-- Function to update nametags for all players
local function updateNametags()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            if nametagEnabled then
                createNametag(player.Character)
            else
                removeNametag(player.Character)
            end
        end
    end
end

-- Function to toggle nametags
local function toggleNametags()
    nametagEnabled = not nametagEnabled
    updateNametags()
end

-- Bind the toggle function to a keypress (for debugging)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then -- Press 'N' to toggle nametags
        toggleNametags()
    end
end)

-- Optional: Initialize nametags on script start
updateNametags()

-- Handle new player characters
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if nametagEnabled then
            createNametag(character)
        end
    end)
end)

-- Handle player character removal
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeNametag(player.Character)
    end
end)
   end,
})

local BoxesToggle = Tab:CreateToggle({
   Name = "boxes",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   getgenv().ESPEnabled = Value; -- Default state (true = enabled, false = disabled)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create a table to hold ESP boxes
local espBoxes = {}

-- Function to create a 2D ESP box
local function createESPBox(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false -- Makes sure it's not filled
    box.Visible = false

    espBoxes[player] = box
end

-- Function to remove the ESP box
local function removeESPBox(player)
    if espBoxes[player] then
        espBoxes[player]:Remove()
        espBoxes[player] = nil
    end
end

-- Function to update the ESP boxes
local function updateESPBox(player, box)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

        if humanoid and humanoid.Health > 0 then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

            if onScreen and getgenv().ESPEnabled then
                local size = Vector3.new(2, 3, 0) * (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.5, 0)).Y)

                box.Size = Vector2.new(size.X, size.Y)
                box.Position = Vector2.new(rootPos.X - size.X / 2, rootPos.Y - size.Y / 2)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    else
        box.Visible = false
    end
end

-- Function to toggle ESP on or off
local function toggleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if getgenv().ESPEnabled and not espBoxes[player] then
                createESPBox(player)
            elseif not getgenv().ESPEnabled and espBoxes[player] then
                removeESPBox(player)
            end
        end
    end
end

-- Update ESP boxes constantly
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and espBoxes[player] then
            updateESPBox(player, espBoxes[player])
        end
    end
end)

-- Toggle ESP with right-click
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then -- Right-click
        getgenv().ESPEnabled = not getgenv().ESPEnabled
        toggleESP() -- Refresh the ESP status
    end
end)

-- Player handling (create ESP when a new player joins)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- Wait for character to load
        if getgenv().ESPEnabled then
            createESPBox(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESPBox(player)
end)

-- Initial ESP setup for current players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        createESPBox(player)
    end
end
   end,
})
