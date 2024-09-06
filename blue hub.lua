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
local SpeedSection = UPTab:CreateSection("changes your walkspeed")
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

local JumpSection = UPTab:CreateSection("changes your jumppower")
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

local HipHeightSection = UPTab:CreateSection("changes your hipheight")
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
