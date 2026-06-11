--[[
    🎮 Ultra Cheat Script v3.0
    Built with lxte's UI Library
    Mobile & PC Friendly
]]

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

--// Character References
local Character, Humanoid, HRP, RootPart

local function UpdateCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
    RootPart = HRP
end

UpdateCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

--// ════════════════════════════════
--// Library Setup
--// ════════════════════════════════

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"
))()

local Window = Library:CreateWindow({
    Title = "🎮 Ultra Cheat v3.0",
    Theme = "Dark",
    Size = UDim2.fromOffset(570, 370),
    Transparency = 0.1,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.RightControl,
})

--// ════════════════════════════════
--// Themes
--// ════════════════════════════════

local Themes = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40),
        Interactables = Color3.fromRGB(45, 45, 45),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220),
    },
    Light = {
        Primary = Color3.fromRGB(232, 232, 232),
        Secondary = Color3.fromRGB(255, 255, 255),
        Component = Color3.fromRGB(245, 245, 245),
        Interactables = Color3.fromRGB(235, 235, 235),
        Tab = Color3.fromRGB(50, 50, 50),
        Title = Color3.fromRGB(0, 0, 0),
        Description = Color3.fromRGB(100, 100, 100),
        Shadow = Color3.fromRGB(255, 255, 255),
        Outline = Color3.fromRGB(210, 210, 210),
        Icon = Color3.fromRGB(100, 100, 100),
    },
    Void = {
        Primary = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Component = Color3.fromRGB(20, 20, 20),
        Interactables = Color3.fromRGB(25, 25, 25),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240, 240, 240),
        Description = Color3.fromRGB(180, 180, 180),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(30, 30, 30),
        Icon = Color3.fromRGB(200, 200, 200),
    },
    Purple = {
        Primary = Color3.fromRGB(20, 15, 35),
        Secondary = Color3.fromRGB(28, 20, 48),
        Component = Color3.fromRGB(38, 28, 62),
        Interactables = Color3.fromRGB(50, 38, 80),
        Tab = Color3.fromRGB(180, 160, 220),
        Title = Color3.fromRGB(220, 200, 255),
        Description = Color3.fromRGB(170, 150, 210),
        Shadow = Color3.fromRGB(10, 5, 20),
        Outline = Color3.fromRGB(60, 45, 90),
        Icon = Color3.fromRGB(180, 150, 255),
    },
    Midnight = {
        Primary = Color3.fromRGB(8, 12, 25),
        Secondary = Color3.fromRGB(12, 18, 35),
        Component = Color3.fromRGB(18, 25, 48),
        Interactables = Color3.fromRGB(25, 35, 65),
        Tab = Color3.fromRGB(140, 170, 230),
        Title = Color3.fromRGB(180, 210, 255),
        Description = Color3.fromRGB(130, 160, 210),
        Shadow = Color3.fromRGB(0, 0, 15),
        Outline = Color3.fromRGB(35, 50, 85),
        Icon = Color3.fromRGB(150, 185, 255),
    },
}

Window:SetTheme(Themes.Dark)

--// ════════════════════════════════
--// Tab Sections
--// ════════════════════════════════

Window:AddTabSection({ Name = "⚡ Main",    Order = 1 })
Window:AddTabSection({ Name = "🎯 Combat",  Order = 2 })
Window:AddTabSection({ Name = "🌍 World",   Order = 3 })
Window:AddTabSection({ Name = "⚙️ Config",  Order = 4 })

--// ════════════════════════════════
--// STATE TABLE
--// ════════════════════════════════

local State = {
    -- Movement
    Speed           = 16,
    JumpPower       = 50,
    Gravity         = 196.2,
    InfiniteJump    = false,
    Noclip          = false,
    Fly             = false,
    FlySpeed        = 60,
    -- Character
    GodMode         = false,
    -- Combat
    Aimbot          = false,
    AimbotFOV       = 250,
    AimbotSmooth    = 5,
    AimbotBone      = "Head",
    ShowFOV         = false,
    HitboxExpand    = false,
    HitboxSize      = 5,
    KillAura        = false,
    KillAuraRange   = 15,
    -- ESP
    ESPEnabled      = false,
    ESPBoxes        = false,
    ESPNames        = false,
    ESPHealth       = false,
    ESPDistance     = false,
    ESPTracers      = false,
    ESPChams        = false,
    ESPTeamCheck    = false,
    -- World
    Fullbright      = false,
    NoFog           = false,
    AntiAFK         = false,
    CustomTime      = false,
    TimeValue       = 14,
    -- Misc
    ClickTP         = false,
    Spin            = false,
    ChatSpam        = false,
    SpamMsg         = "Hello!",
    SpamDelay       = 2,
    SavedCF         = nil,
    TpTarget        = "",
}

--// ════════════════════════════════════════════
--// TAB ▶ PLAYER
--// ════════════════════════════════════════════

local TabPlayer = Window:AddTab({
    Title = "🏃 Player",
    Section = "⚡ Main",
    Icon = "rbxassetid://11963373994",
})

-- ── Movement ──────────────────────────────────
Window:AddSection({ Name = "Movement", Tab = TabPlayer })

Window:AddSlider({
    Title = "🏃 WalkSpeed",
    Description = "Change your movement speed",
    Tab = TabPlayer,
    MaxValue = 500,
    AllowDecimals = false,
    Callback = function(v)
        State.Speed = v
        pcall(function() Humanoid.WalkSpeed = v end)
    end,
})

Window:AddSlider({
    Title = "⬆ JumpPower",
    Description = "Change your jump height",
    Tab = TabPlayer,
    MaxValue = 500,
    AllowDecimals = false,
    Callback = function(v)
        State.JumpPower = v
        pcall(function()
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = v
        end)
    end,
})

Window:AddSlider({
    Title = "🌍 Gravity",
    Description = "Change world gravity (default 196)",
    Tab = TabPlayer,
    MaxValue = 500,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v)
        State.Gravity = v
        Workspace.Gravity = v
    end,
})

Window:AddToggle({
    Title = "♾ Infinite Jump",
    Description = "Jump endlessly in mid-air",
    Default = false,
    Tab = TabPlayer,
    Callback = function(v) State.InfiniteJump = v end,
})

Window:AddToggle({
    Title = "👻 Noclip",
    Description = "Walk through walls",
    Default = false,
    Tab = TabPlayer,
    Callback = function(v) State.Noclip = v end,
})

Window:AddToggle({
    Title = "🕊 Fly",
    Description = "Fly freely around the map",
    Default = false,
    Tab = TabPlayer,
    Callback = function(v)
        State.Fly = v
        if not v then
            pcall(function()
                HRP:FindFirstChild("_FlyBV"):Destroy()
                HRP:FindFirstChild("_FlyBG"):Destroy()
            end)
        end
    end,
})

Window:AddSlider({
    Title = "🕊 Fly Speed",
    Description = "Speed while flying",
    Tab = TabPlayer,
    MaxValue = 300,
    AllowDecimals = false,
    Callback = function(v) State.FlySpeed = v end,
})

-- ── Character ──────────────────────────────────
Window:AddSection({ Name = "Character", Tab = TabPlayer })

Window:AddToggle({
    Title = "❤ God Mode",
    Description = "Keep your HP at maximum (client-sided)",
    Default = false,
    Tab = TabPlayer,
    Callback = function(v) State.GodMode = v end,
})

Window:AddButton({
    Title = "💀 Kill Character",
    Description = "Instantly kills your character",
    Tab = TabPlayer,
    Callback = function()
        pcall(function() Humanoid.Health = 0 end)
    end,
})

Window:AddButton({
    Title = "🔄 Respawn",
    Description = "Force-respawn your character",
    Tab = TabPlayer,
    Callback = function()
        LocalPlayer:LoadCharacter()
    end,
})

--// ════════════════════════════════════════════
--// TAB ▶ TELEPORT
--// ════════════════════════════════════════════

local TabTP = Window:AddTab({
    Title = "📍 Teleport",
    Section = "⚡ Main",
    Icon = "rbxassetid://11963373994",
})

Window:AddSection({ Name = "Player Teleport", Tab = TabTP })

Window:AddInput({
    Title = "👤 Player Name",
    Description = "Type a player name then press Teleport",
    Tab = TabTP,
    Callback = function(t) State.TpTarget = t end,
})

Window:AddButton({
    Title = "🚀 Teleport to Player",
    Description = "Teleport to the entered player",
    Tab = TabTP,
    Callback = function()
        local name = State.TpTarget:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer
            and (p.Name:lower():find(name) or p.DisplayName:lower():find(name))
            and p.Character
            and p.Character:FindFirstChild("HumanoidRootPart")
            then
                HRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                Window:Notify({ Title = "📍 Teleported",
                    Description = "Teleported to " .. p.DisplayName, Duration = 3 })
                return
            end
        end
        Window:Notify({ Title = "❌ Not Found",
            Description = "Could not find player: " .. State.TpTarget, Duration = 3 })
    end,
})

Window:AddButton({
    Title = "🎲 Random Teleport",
    Description = "Teleport to a random player",
    Tab = TabTP,
    Callback = function()
        local pool = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(pool, p)
            end
        end
        if #pool == 0 then
            Window:Notify({ Title = "❌ Error", Description = "No other players found!", Duration = 3 })
            return
        end
        local target = pool[math.random(#pool)]
        HRP.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        Window:Notify({ Title = "🎲 Random TP",
            Description = "Teleported to " .. target.DisplayName, Duration = 3 })
    end,
})

Window:AddSection({ Name = "Position", Tab = TabTP })

Window:AddButton({
    Title = "💾 Save Position",
    Description = "Save your current CFrame",
    Tab = TabTP,
    Callback = function()
        State.SavedCF = HRP.CFrame
        Window:Notify({ Title = "💾 Saved", Description = "Position saved!", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "📂 Load Position",
    Description = "Return to saved position",
    Tab = TabTP,
    Callback = function()
        if State.SavedCF then
            HRP.CFrame = State.SavedCF
            Window:Notify({ Title = "📂 Loaded", Description = "Returned to saved position!", Duration = 2 })
        else
            Window:Notify({ Title = "❌ Error", Description = "No position saved!", Duration = 2 })
        end
    end,
})

Window:AddToggle({
    Title = "🖱 Click Teleport",
    Description = "Click anywhere to teleport there",
    Default = false,
    Tab = TabTP,
    Callback = function(v) State.ClickTP = v end,
})

--// ════════════════════════════════════════════
--// TAB ▶ AIMBOT
--// ════════════════════════════════════════════

local TabAimbot = Window:AddTab({
    Title = "🎯 Aimbot",
    Section = "🎯 Combat",
    Icon = "rbxassetid://11293977610",
})

Window:AddSection({ Name = "Aimbot", Tab = TabAimbot })

Window:AddToggle({
    Title = "🎯 Enable Aimbot",
    Description = "Auto-aim at the nearest enemy (Hold RMB)",
    Default = false,
    Tab = TabAimbot,
    Callback = function(v) State.Aimbot = v end,
})

Window:AddSlider({
    Title = "🔴 FOV Radius",
    Description = "Size of the aimbot detection circle",
    Tab = TabAimbot,
    MaxValue = 900,
    AllowDecimals = false,
    Callback = function(v) State.AimbotFOV = v end,
})

Window:AddSlider({
    Title = "🎯 Smoothness",
    Description = "Higher = slower aim (1 = instant)",
    Tab = TabAimbot,
    MaxValue = 50,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v) State.AimbotSmooth = v end,
})

Window:AddToggle({
    Title = "⭕ Show FOV",
    Description = "Display the FOV circle on screen",
    Default = false,
    Tab = TabAimbot,
    Callback = function(v) State.ShowFOV = v end,
})

Window:AddDropdown({
    Title = "🦴 Target Bone",
    Description = "Which body part to aim at",
    Tab = TabAimbot,
    Options = {
        ["Head"]           = "Head",
        ["Upper Torso"]    = "UpperTorso",
        ["Root"]           = "HumanoidRootPart",
    },
    Callback = function(v) State.AimbotBone = v end,
})

Window:AddSection({ Name = "Other Combat", Tab = TabAimbot })

Window:AddToggle({
    Title = "📦 Hitbox Expander",
    Description = "Make enemy hitboxes larger",
    Default = false,
    Tab = TabAimbot,
    Callback = function(v)
        State.HitboxExpand = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = v and Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                                  or Vector3.new(2, 2, 1)
                    hrp.Transparency = v and 0.5 or 1
                end
            end
        end
    end,
})

Window:AddSlider({
    Title = "📦 Hitbox Size",
    Description = "Size of expanded hitboxes",
    Tab = TabAimbot,
    MaxValue = 30,
    AllowDecimals = false,
    Callback = function(v) State.HitboxSize = v end,
})

Window:AddToggle({
    Title = "💫 Kill Aura",
    Description = "Auto-damage nearby players",
    Default = false,
    Tab = TabAimbot,
    Callback = function(v) State.KillAura = v end,
})

Window:AddSlider({
    Title = "💫 Aura Range",
    Description = "Kill aura detection radius",
    Tab = TabAimbot,
    MaxValue = 60,
    AllowDecimals = false,
    Callback = function(v) State.KillAuraRange = v end,
})

--// ════════════════════════════════════════════
--// TAB ▶ ESP
--// ════════════════════════════════════════════

local TabESP = Window:AddTab({
    Title = "👁 ESP",
    Section = "🎯 Combat",
    Icon = "rbxassetid://11293977610",
})

Window:AddSection({ Name = "Player ESP", Tab = TabESP })

Window:AddToggle({
    Title = "👁 Master ESP Switch",
    Description = "Enable/disable all ESP features",
    Default = false,
    Tab = TabESP,
    Callback = function(v)
        State.ESPEnabled = v
    end,
})

Window:AddToggle({
    Title = "📦 Box ESP",
    Description = "Draw boxes around players",
    Default = false,
    Tab = TabESP,
    Callback = function(v) State.ESPBoxes = v end,
})

Window:AddToggle({
    Title = "📛 Name ESP",
    Description = "Show player names",
    Default = false,
    Tab = TabESP,
    Callback = function(v) State.ESPNames = v end,
})

Window:AddToggle({
    Title = "❤ Health ESP",
    Description = "Show health bar beside players",
    Default = false,
    Tab = TabESP,
    Callback = function(v) State.ESPHealth = v end,
})

Window:AddToggle({
    Title = "📏 Distance ESP",
    Description = "Show distance to each player",
    Default = false,
    Tab = TabESP,
    Callback = function(v) State.ESPDistance = v end,
})

Window:AddToggle({
    Title = "📍 Tracers",
    Description = "Draw lines from screen bottom to players",
    Default = false,
    Tab = TabESP,
    Callback = function(v) State.ESPTracers = v end,
})

Window:AddToggle({
    Title = "🌈 Chams (Highlight)",
    Description = "Highlight players through walls",
    Default = false,
    Tab = TabESP,
    Callback = function(v)
        State.ESPChams = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local existing = p.Character:FindFirstChild("_ESPHighlight")
                if v and not existing then
                    local h = Instance.new("Highlight")
                    h.Name            = "_ESPHighlight"
                    h.FillColor       = Color3.fromRGB(255, 50, 50)
                    h.FillTransparency = 0.4
                    h.OutlineColor    = Color3.fromRGB(255, 255, 255)
                    h.DepthMode       = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent          = p.Character
                elseif not v and existing then
                    existing:Destroy()
                end
            end
        end
    end,
})

Window:AddToggle({
    Title = "👥 Team Check",
    Description = "Skip teammates in ESP & aimbot",
    Default = false,
    Tab = TabESP,
    Callback = function(v) State.ESPTeamCheck = v end,
})

--// ════════════════════════════════════════════
--// TAB ▶ WORLD
--// ════════════════════════════════════════════

local TabWorld = Window:AddTab({
    Title = "🌍 World",
    Section = "🌍 World",
    Icon = "rbxassetid://11963373994",
})

Window:AddSection({ Name = "Lighting", Tab = TabWorld })

Window:AddToggle({
    Title = "💡 Fullbright",
    Description = "Remove all darkness",
    Default = false,
    Tab = TabWorld,
    Callback = function(v)
        State.Fullbright = v
        if v then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end,
})

Window:AddToggle({
    Title = "🌫 No Fog",
    Description = "Remove all fog effects",
    Default = false,
    Tab = TabWorld,
    Callback = function(v)
        State.NoFog = v
        Lighting.FogEnd = v and 9999999 or 100000
        Lighting.FogStart = 0
    end,
})

Window:AddToggle({
    Title = "🕐 Custom Time",
    Description = "Lock the time of day",
    Default = false,
    Tab = TabWorld,
    Callback = function(v) State.CustomTime = v end,
})

Window:AddSlider({
    Title = "🕐 Time of Day",
    Description = "0 = midnight  |  14 = day  |  24 = midnight",
    Tab = TabWorld,
    MaxValue = 24,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v)
        State.TimeValue = v
        if State.CustomTime then Lighting.ClockTime = v end
    end,
})

Window:AddSection({ Name = "Cleanup", Tab = TabWorld })

Window:AddButton({
    Title = "🎨 Remove Atmosphere",
    Description = "Delete all lighting post-effects",
    Tab = TabWorld,
    Callback = function()
        local n = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect")
            or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then
                e:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "✅ Done",
            Description = n .. " effects removed!", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "🧹 Remove Particles",
    Description = "Delete all particles, fire, smoke, sparks",
    Tab = TabWorld,
    Callback = function()
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Fire")
            or o:IsA("Smoke") or o:IsA("Sparkles") then
                o:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "✅ Done",
            Description = n .. " particles removed!", Duration = 2 })
    end,
})

--// ════════════════════════════════════════════
--// TAB ▶ MISC
--// ════════════════════════════════════════════

local TabMisc = Window:AddTab({
    Title = "🛠 Misc",
    Section = "🌍 World",
    Icon = "rbxassetid://11963373994",
})

Window:AddSection({ Name = "Utility", Tab = TabMisc })

Window:AddToggle({
    Title = "🚫 Anti-AFK",
    Description = "Prevent automatic AFK kick",
    Default = false,
    Tab = TabMisc,
    Callback = function(v) State.AntiAFK = v end,
})

Window:AddToggle({
    Title = "🌀 Spin",
    Description = "Rotate your character continuously",
    Default = false,
    Tab = TabMisc,
    Callback = function(v) State.Spin = v end,
})

Window:AddButton({
    Title = "🟩 Spawn Platform",
    Description = "Create a platform below your feet",
    Tab = TabMisc,
    Callback = function()
        local p = Instance.new("Part")
        p.Size = Vector3.new(20, 1, 20)
        p.CFrame = HRP.CFrame * CFrame.new(0, -4, 0)
        p.Anchored = true
        p.BrickColor = BrickColor.new("Bright green")
        p.Material = Enum.Material.Neon
        p.Transparency = 0.3
        p.Parent = Workspace
        Window:Notify({ Title = "🟩 Platform", Description = "Platform spawned!", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "🪑 Sit Down",
    Description = "Force your character to sit",
    Tab = TabMisc,
    Callback = function()
        pcall(function() Humanoid.Sit = true end)
    end,
})

Window:AddSection({ Name = "Chat", Tab = TabMisc })

Window:AddInput({
    Title = "💬 Spam Message",
    Description = "Message to repeat in chat",
    Tab = TabMisc,
    Callback = function(t) State.SpamMsg = t end,
})

Window:AddSlider({
    Title = "⏱ Spam Delay",
    Description = "Seconds between each message",
    Tab = TabMisc,
    MaxValue = 10,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v) State.SpamDelay = v end,
})

Window:AddToggle({
    Title = "💬 Chat Spam",
    Description = "Repeatedly send the message above",
    Default = false,
    Tab = TabMisc,
    Callback = function(v) State.ChatSpam = v end,
})

Window:AddSection({ Name = "Server", Tab = TabMisc })

Window:AddButton({
    Title = "🔄 Rejoin",
    Description = "Rejoin the current server",
    Tab = TabMisc,
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

Window:AddButton({
    Title = "🔀 Server Hop",
    Description = "Jump to a different server",
    Tab = TabMisc,
    Callback = function()
        task.spawn(function()
            local ok, servers = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(
                    ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100")
                    :format(game.PlaceId)
                ))
            end)
            if not ok then
                Window:Notify({ Title = "❌ Error", Description = "Failed to fetch servers.", Duration = 3 })
                return
            end
            for _, sv in ipairs(servers.data) do
                if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
                    return
                end
            end
            Window:Notify({ Title = "❌ Error", Description = "No suitable server found.", Duration = 3 })
        end)
    end,
})

--// ════════════════════════════════════════════
--// TAB ▶ SETTINGS
--// ════════════════════════════════════════════

local TabSettings = Window:AddTab({
    Title = "⚙️ Settings",
    Section = "⚙️ Config",
    Icon = "rbxassetid://11293977610",
})

Window:AddSection({ Name = "UI Settings", Tab = TabSettings })

Window:AddDropdown({
    Title = "🎨 Theme",
    Description = "Choose a colour theme",
    Tab = TabSettings,
    Options = {
        ["🌑 Dark"]      = "Dark",
        ["☀️ Light"]     = "Light",
        ["⬛ Void"]      = "Void",
        ["💜 Purple"]    = "Purple",
        ["🌌 Midnight"]  = "Midnight",
    },
    Callback = function(v)
        Window:SetTheme(Themes[v])
    end,
})

Window:AddSlider({
    Title = "💧 UI Transparency",
    Description = "Window background opacity",
    Tab = TabSettings,
    MaxValue = 1,
    AllowDecimals = true,
    DecimalAmount = 2,
    Callback = function(v)
        Window:SetSetting("Transparency", v)
    end,
})

Window:AddToggle({
    Title = "🌀 UI Blur",
    Description = "Blur behind the window (needs Graphics 8+)",
    Default = true,
    Tab = TabSettings,
    Callback = function(v)
        Window:SetSetting("Blur", v)
    end,
})

Window:AddKeybind({
    Title = "⌨ Minimize Keybind",
    Description = "Key to show / hide the menu",
    Tab = TabSettings,
    Callback = function(key)
        Window:SetSetting("Keybind", key)
    end,
})

Window:AddSection({ Name = "Info", Tab = TabSettings })

Window:AddParagraph({
    Title = "🎮 Ultra Cheat v3.0",
    Description = "Universal Roblox cheat.\nDefault toggle key: Right Control\n\nMobile: drag the 🎮 button to anywhere.",
    Tab = TabSettings,
})

Window:AddButton({
    Title = "🗑 Destroy UI",
    Description = "Completely remove this cheat menu",
    Tab = TabSettings,
    Callback = function()
        -- cleanup drawings
        pcall(function() _G._ESPClean() end)
        pcall(function() _G._FOVCircle:Remove() end)
        pcall(function()
            game.CoreGui:FindFirstChild("UltraCheat"):Destroy()
        end)
    end,
})

--// ════════════════════════════════════════════
--// DRAWING – FOV CIRCLE
--// ════════════════════════════════════════════

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness    = 1.5
FOVCircle.NumSides     = 64
FOVCircle.Radius       = State.AimbotFOV
FOVCircle.Filled       = false
FOVCircle.Visible      = false
FOVCircle.ZIndex       = 999
FOVCircle.Transparency = 0.8
FOVCircle.Color        = Color3.fromRGB(255, 60, 60)
_G._FOVCircle          = FOVCircle

--// ════════════════════════════════════════════
--// DRAWING – ESP OBJECTS
--// ════════════════════════════════════════════

local ESPData = {}

local function NewDrawing(class, props)
    local d = Drawing.new(class)
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function CreateESPFor(player)
    if player == LocalPlayer or ESPData[player] then return end
    ESPData[player] = {
        Box      = NewDrawing("Square", { Thickness=1.5, Filled=false,
                        Color=Color3.fromRGB(255,80,80), Visible=false, ZIndex=5 }),
        Name     = NewDrawing("Text",   { Size=13, Center=true, Outline=true,
                        Color=Color3.fromRGB(255,255,255), Visible=false, ZIndex=5, Font=2 }),
        HpBG     = NewDrawing("Line",   { Thickness=4,
                        Color=Color3.fromRGB(0,0,0), Visible=false, ZIndex=4 }),
        Hp       = NewDrawing("Line",   { Thickness=2,
                        Color=Color3.fromRGB(0,255,0), Visible=false, ZIndex=5 }),
        Dist     = NewDrawing("Text",   { Size=11, Center=true, Outline=true,
                        Color=Color3.fromRGB(200,200,200), Visible=false, ZIndex=5, Font=2 }),
        Tracer   = NewDrawing("Line",   { Thickness=1.5,
                        Color=Color3.fromRGB(255,220,0), Visible=false, ZIndex=5 }),
    }
end

local function DestroyESPFor(player)
    if ESPData[player] then
        for _, d in pairs(ESPData[player]) do pcall(function() d:Remove() end) end
        ESPData[player] = nil
    end
end

local function HideESP(esp)
    for _, d in pairs(esp) do d.Visible = false end
end

_G._ESPClean = function()
    for p in pairs(ESPData) do DestroyESPFor(p) end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESPFor(p) end
Players.PlayerAdded:Connect(CreateESPFor)
Players.PlayerRemoving:Connect(DestroyESPFor)

--// ════════════════════════════════════════════
--// AIMBOT HELPERS
--// ════════════════════════════════════════════

local function IsTeammate(player)
    if not State.ESPTeamCheck then return false end
    return pcall(function() return player.Team == LocalPlayer.Team end) and player.Team == LocalPlayer.Team
end

local function GetClosestEnemy()
    local best, bestDist = nil, State.AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or IsTeammate(p) then continue end
        local char = p.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local part = char:FindFirstChild(State.AimbotBone) or char:FindFirstChild("HumanoidRootPart")
        if not (hum and hum.Health > 0 and part) then continue end

        local sp, onScreen = Camera:WorldToScreenPoint(part.Position)
        if not onScreen then continue end
        local dist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
        if dist < bestDist then bestDist = dist; best = p end
    end
    return best
end

--// ════════════════════════════════════════════
--// MAIN RENDER LOOP
--// ════════════════════════════════════════════

RunService.RenderStepped:Connect(function(dt)
    local mouse = UserInputService:GetMouseLocation()

    --// FOV Circle
    FOVCircle.Visible  = State.ShowFOV
    FOVCircle.Radius   = State.AimbotFOV
    FOVCircle.Position = mouse

    --// Aimbot (hold RMB)
    if State.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestEnemy()
        if target and target.Character then
            local part = target.Character:FindFirstChild(State.AimbotBone)
                      or target.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local smooth = 1 / math.max(State.AimbotSmooth, 0.01)
                Camera.CFrame = Camera.CFrame:Lerp(
                    CFrame.new(Camera.CFrame.Position, part.Position), smooth)
            end
        end
    end

    --// ESP update
    local vp = Camera.ViewportSize
    for player, esp in pairs(ESPData) do
        local char = player.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        if not (char and hum and hum.Health > 0 and hrp and head and State.ESPEnabled)
        or IsTeammate(player) then
            HideESP(esp); continue
        end

        local wp, vis = Camera:WorldToViewportPoint(hrp.Position)
        local hp2     = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,.5,0))
        local fp2     = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))

        if not vis then HideESP(esp); continue end

        local bH = math.abs(hp2.Y - fp2.Y)
        local bW = bH * 0.55
        local cx = wp.X

        -- Box
        esp.Box.Visible  = State.ESPBoxes
        esp.Box.Size     = Vector2.new(bW, bH)
        esp.Box.Position = Vector2.new(cx - bW*.5, hp2.Y)

        -- Name
        esp.Name.Visible  = State.ESPNames
        esp.Name.Text     = player.DisplayName
        esp.Name.Position = Vector2.new(cx, hp2.Y - 16)

        -- Health
        local pct = hum.Health / hum.MaxHealth
        esp.HpBG.Visible = State.ESPHealth
        esp.HpBG.From    = Vector2.new(cx - bW*.5 - 5, fp2.Y)
        esp.HpBG.To      = Vector2.new(cx - bW*.5 - 5, hp2.Y)
        esp.Hp.Visible   = State.ESPHealth
        esp.Hp.From      = Vector2.new(cx - bW*.5 - 5, fp2.Y)
        esp.Hp.To        = Vector2.new(cx - bW*.5 - 5, fp2.Y - bH * pct)
        esp.Hp.Color     = Color3.new(1-pct, pct, 0)

        -- Distance
        local dist3d = (HRP.Position - hrp.Position).Magnitude
        esp.Dist.Visible  = State.ESPDistance
        esp.Dist.Text     = math.floor(dist3d) .. " st"
        esp.Dist.Position = Vector2.new(cx, fp2.Y + 3)

        -- Tracer
        esp.Tracer.Visible = State.ESPTracers
        esp.Tracer.From    = Vector2.new(vp.X*.5, vp.Y)
        esp.Tracer.To      = Vector2.new(cx, fp2.Y)
    end

    --// Fly
    if State.Fly and HRP then
        local bv = HRP:FindFirstChild("_FlyBV")
        local bg = HRP:FindFirstChild("_FlyBG")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "_FlyBV"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = HRP
        end
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.Name = "_FlyBG"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.D = 200; bg.P = 10000
            bg.Parent = HRP
        end
        bg.CFrame = Camera.CFrame
        local dir = Vector3.zero
        local uis = UserInputService
        if uis:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) or uis:IsKeyDown(Enum.KeyCode.ButtonA) then
            dir += Vector3.new(0,1,0)
        end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        bv.Velocity = dir * State.FlySpeed
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Flying) end)
    end

    --// Spin
    if State.Spin and HRP then
        HRP.CFrame *= CFrame.Angles(0, math.rad(10), 0)
    end

    --// Custom time
    if State.CustomTime then
        Lighting.ClockTime = State.TimeValue
    end
end)

--// ════════════════════════════════════════════
--// HEARTBEAT LOOP
--// ════════════════════════════════════════════

RunService.Heartbeat:Connect(function()
    --// God Mode
    if State.GodMode and Humanoid then
        pcall(function() Humanoid.Health = Humanoid.MaxHealth end)
    end

    --// Noclip
    if State.Noclip and Character then
        for _, p in ipairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

--// ════════════════════════════════════════════
--// INPUT EVENTS
--// ════════════════════════════════════════════

--// Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump and Humanoid then
        pcall(function()
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

--// Click Teleport
Mouse.Button1Down:Connect(function()
    if State.ClickTP and Mouse.Hit then
        pcall(function()
            HRP.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
        end)
    end
end)

--// ════════════════════════════════════════════
--// TASK LOOPS
--// ════════════════════════════════════════════

--// Anti-AFK
LocalPlayer.Idled:Connect(function()
    if State.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

--// Chat Spam
task.spawn(function()
    while true do
        if State.ChatSpam and State.SpamMsg ~= "" then
            pcall(function()
                ReplicatedStorage
                    :FindFirstChild("DefaultChatSystemChatEvents", true)
                    :FindFirstChild("SayMessageRequest")
                    :FireServer(State.SpamMsg, "All")
            end)
        end
        task.wait(math.max(State.SpamDelay, 0.5))
    end
end)

--// Kill Aura
task.spawn(function()
    while task.wait(0.15) do
        if not State.KillAura or not HRP then continue end
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or IsTeammate(p) then continue end
            local char = p.Character
            local hrp2 = char and char:FindFirstChild("HumanoidRootPart")
            local hum2 = char and char:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum2 and hum2.Health > 0 then
                if (HRP.Position - hrp2.Position).Magnitude <= State.KillAuraRange then
                    -- simulate a tool click / touch event
                    pcall(function()
                        local tool = Character:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            local re = tool:FindFirstChildOfClass("RemoteEvent")
                                    or tool:FindFirstChildOfClass("RemoteFunction")
                            if re then re:FireServer(hrp2.CFrame) end
                        end
                    end)
                end
            end
        end
    end
end)

--// ════════════════════════════════════════════
--// MOBILE BUTTON
--// ════════════════════════════════════════════

if UserInputService.TouchEnabled then
    local MobileGui = Instance.new("ScreenGui")
    MobileGui.Name            = "UltraCheatMobile"
    MobileGui.ResetOnSpawn    = false
    MobileGui.DisplayOrder    = 999
    MobileGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling

    local Btn = Instance.new("TextButton")
    Btn.Size                  = UDim2.fromOffset(54, 54)
    Btn.Position              = UDim2.new(0, 8, 0.5, -27)
    Btn.BackgroundColor3      = Color3.fromRGB(100, 90, 200)
    Btn.TextColor3            = Color3.new(1,1,1)
    Btn.Text                  = "🎮"
    Btn.TextScaled            = true
    Btn.Font                  = Enum.Font.GothamBold
    Btn.BackgroundTransparency = 0.2
    Btn.Parent                = MobileGui

    local c1 = Instance.new("UICorner"); c1.CornerRadius = UDim.new(0,27); c1.Parent = Btn
    local c2 = Instance.new("UIStroke"); c2.Color = Color3.fromRGB(140,130,255); c2.Thickness = 2; c2.Parent = Btn

    --// Drag logic
    local dragging, dStart, dPos = false, nil, nil
    Btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dStart = inp.Position; dPos = Btn.Position
        end
    end)
    Btn.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.Touch then
            local d = inp.Position - dStart
            Btn.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset+d.X,
                                     dPos.Y.Scale, dPos.Y.Offset+d.Y)
        end
    end)
    Btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    -- Toggle menu visibility
    local menuVisible = true
    Btn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        -- fire the library's built-in keybind handler indirectly
        pcall(function()
            local screen = game.CoreGui:FindFirstChild("UILibrary")
                        or game.Players.LocalPlayer.PlayerGui:FindFirstChild("UILibrary")
            if screen then screen.Main.Visible = menuVisible end
        end)
    end)

    pcall(function() MobileGui.Parent = game.CoreGui end)
    if not MobileGui.Parent then MobileGui.Parent = LocalPlayer.PlayerGui end
end

--// ════════════════════════════════════════════
--// STARTUP NOTIFICATION
--// ════════════════════════════════════════════

Window:Notify({
    Title = "🎮 Ultra Cheat v3.0 Ready!",
    Description = ("Welcome, %s!\nToggle: RightCtrl  |  Mobile: tap 🎮"):format(LocalPlayer.DisplayName),
    Duration = 6,
})

print(("[ Ultra Cheat v3.0 ] Loaded — %s | PlaceId %d"):format(LocalPlayer.Name, game.PlaceId))
