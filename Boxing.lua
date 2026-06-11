--[[
    ╔══════════════════════════════════════════╗
    ║           E P L I S M A                  ║
    ║       Professional Cheat Suite           ║
    ║                                          ║
    ║   Developer: Frost                       ║
    ║   Telegram: @Jokerfros                   ║
    ║   Version: 1.0                           ║
    ╚══════════════════════════════════════════╝
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
local CoreGui = game:GetService("CoreGui")

--// Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

--// Character
local Character, Humanoid, HRP

local function RefreshCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end

RefreshCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
LocalPlayer.CharacterAdded:Connect(RefreshCharacter)

--// ═══════════════════════════════════════════
--//  TOGGLE HOTKEY — Клавіша "E"
--// ═══════════════════════════════════════════

local MenuOpen = true
local TOGGLE_KEY = Enum.KeyCode.E

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        MenuOpen = not MenuOpen
        pcall(function()
            local screens = {CoreGui, LocalPlayer.PlayerGui}
            for _, parent in ipairs(screens) do
                for _, gui in ipairs(parent:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
                        gui.Main.Visible = MenuOpen
                    end
                end
            end
        end)
    end
end)

--// ═══════════════════════════════════════════
--//  LIBRARY SETUP
--// ═══════════════════════════════════════════

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"
))()

local Window = Library:CreateWindow({
    Title = "Eplisma",
    Theme = "Dark",
    Size = UDim2.fromOffset(560, 360),
    Transparency = 0.15,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.RightControl,
})

local Themes = {
    Dark = {
        Primary = Color3.fromRGB(18, 18, 22),
        Secondary = Color3.fromRGB(22, 22, 28),
        Component = Color3.fromRGB(28, 28, 35),
        Interactables = Color3.fromRGB(35, 35, 44),
        Tab = Color3.fromRGB(180, 180, 200),
        Title = Color3.fromRGB(235, 235, 245),
        Description = Color3.fromRGB(160, 160, 180),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(35, 35, 45),
        Icon = Color3.fromRGB(200, 200, 220),
    },
    Void = {
        Primary = Color3.fromRGB(8, 8, 10),
        Secondary = Color3.fromRGB(12, 12, 16),
        Component = Color3.fromRGB(18, 18, 22),
        Interactables = Color3.fromRGB(24, 24, 30),
        Tab = Color3.fromRGB(170, 170, 190),
        Title = Color3.fromRGB(230, 230, 240),
        Description = Color3.fromRGB(140, 140, 160),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(25, 25, 32),
        Icon = Color3.fromRGB(180, 180, 200),
    },
    Amethyst = {
        Primary = Color3.fromRGB(16, 12, 24),
        Secondary = Color3.fromRGB(22, 16, 34),
        Component = Color3.fromRGB(30, 22, 46),
        Interactables = Color3.fromRGB(42, 32, 62),
        Tab = Color3.fromRGB(170, 150, 210),
        Title = Color3.fromRGB(220, 200, 255),
        Description = Color3.fromRGB(150, 130, 190),
        Shadow = Color3.fromRGB(5, 2, 12),
        Outline = Color3.fromRGB(50, 38, 72),
        Icon = Color3.fromRGB(170, 140, 230),
    },
    Midnight = {
        Primary = Color3.fromRGB(6, 10, 22),
        Secondary = Color3.fromRGB(10, 16, 32),
        Component = Color3.fromRGB(16, 22, 44),
        Interactables = Color3.fromRGB(22, 32, 58),
        Tab = Color3.fromRGB(130, 160, 220),
        Title = Color3.fromRGB(175, 200, 250),
        Description = Color3.fromRGB(120, 145, 200),
        Shadow = Color3.fromRGB(0, 2, 12),
        Outline = Color3.fromRGB(30, 42, 72),
        Icon = Color3.fromRGB(140, 170, 240),
    },
    Crimson = {
        Primary = Color3.fromRGB(22, 10, 10),
        Secondary = Color3.fromRGB(32, 14, 14),
        Component = Color3.fromRGB(44, 20, 20),
        Interactables = Color3.fromRGB(60, 28, 28),
        Tab = Color3.fromRGB(220, 150, 150),
        Title = Color3.fromRGB(255, 200, 200),
        Description = Color3.fromRGB(200, 140, 140),
        Shadow = Color3.fromRGB(12, 0, 0),
        Outline = Color3.fromRGB(72, 32, 32),
        Icon = Color3.fromRGB(240, 150, 150),
    },
}

Window:SetTheme(Themes.Dark)

--// ═══════════════════════════════════════════
--//  TAB SECTIONS
--// ═══════════════════════════════════════════

Window:AddTabSection({ Name = "Modules",  Order = 1 })
Window:AddTabSection({ Name = "Visuals",  Order = 2 })
Window:AddTabSection({ Name = "Settings", Order = 3 })

--// ═══════════════════════════════════════════
--//  STATE
--// ═══════════════════════════════════════════

local CFG = {
    Speed = 16, JumpPower = 50, Gravity = 196.2,
    InfJump = false, Noclip = false,
    Fly = false, FlySpeed = 60,
    GodMode = false,
    
    Aimbot = false, AimFOV = 250, AimSmooth = 5,
    AimBone = "Head", ShowFOV = false,
    HitboxExp = false, HitboxSize = 5,
    KillAura = false, AuraRange = 15,
    
    ESP = false, BoxESP = false, NameESP = false,
    HealthESP = false, DistESP = false,
    TracerESP = false, ChamsESP = false, TeamCheck = false,
    
    Fullbright = false, NoFog = false,
    AntiAFK = false, CustomTime = false, TimeVal = 14,
    ClickTP = false, Spin = false,
    ChatSpam = false, SpamMsg = "", SpamDelay = 2,
    SavedCF = nil, TpTarget = "",
}

--// ═══════════════════════════════════════════
--//  TAB: CHARACTER
--// ═══════════════════════════════════════════

local TabChar = Window:AddTab({
    Title = "Character",
    Section = "Modules",
    Icon = "rbxassetid://11963373994",
})

Window:AddSection({ Name = "Movement", Tab = TabChar })

Window:AddSlider({
    Title = "WalkSpeed",
    Description = "Movement speed modifier",
    Tab = TabChar,
    MaxValue = 500,
    AllowDecimals = false,
    Callback = function(v)
        CFG.Speed = v
        pcall(function() Humanoid.WalkSpeed = v end)
    end,
})

Window:AddSlider({
    Title = "JumpPower",
    Description = "Jump height modifier",
    Tab = TabChar,
    MaxValue = 500,
    AllowDecimals = false,
    Callback = function(v)
        CFG.JumpPower = v
        pcall(function()
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = v
        end)
    end,
})

Window:AddSlider({
    Title = "Gravity",
    Description = "World gravity (default: 196.2)",
    Tab = TabChar,
    MaxValue = 500,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v)
        CFG.Gravity = v
        Workspace.Gravity = v
    end,
})

Window:AddToggle({
    Title = "Infinite Jump",
    Description = "Multi-jump while airborne",
    Default = false,
    Tab = TabChar,
    Callback = function(v) CFG.InfJump = v end,
})

Window:AddToggle({
    Title = "Noclip",
    Description = "Phase through solid objects",
    Default = false,
    Tab = TabChar,
    Callback = function(v) CFG.Noclip = v end,
})

Window:AddSection({ Name = "Flight", Tab = TabChar })

Window:AddToggle({
    Title = "Fly",
    Description = "Free flight mode",
    Default = false,
    Tab = TabChar,
    Callback = function(v)
        CFG.Fly = v
        if not v then
            pcall(function()
                if HRP:FindFirstChild("_BV") then HRP._BV:Destroy() end
                if HRP:FindFirstChild("_BG") then HRP._BG:Destroy() end
            end)
        end
    end,
})

Window:AddSlider({
    Title = "Fly Speed",
    Description = "Flight velocity",
    Tab = TabChar,
    MaxValue = 300,
    AllowDecimals = false,
    Callback = function(v) CFG.FlySpeed = v end,
})

Window:AddSection({ Name = "Survivability", Tab = TabChar })

Window:AddToggle({
    Title = "God Mode",
    Description = "Constant max health (client)",
    Default = false,
    Tab = TabChar,
    Callback = function(v) CFG.GodMode = v end,
})

Window:AddButton({
    Title = "Force Reset",
    Description = "Kill your character instantly",
    Tab = TabChar,
    Callback = function()
        pcall(function() Humanoid.Health = 0 end)
    end,
})

Window:AddButton({
    Title = "Respawn",
    Description = "Force character respawn",
    Tab = TabChar,
    Callback = function()
        pcall(function() LocalPlayer:LoadCharacter() end)
    end,
})

--// ═══════════════════════════════════════════
--//  TAB: COMBAT
--// ═══════════════════════════════════════════

local TabCombat = Window:AddTab({
    Title = "Combat",
    Section = "Modules",
    Icon = "rbxassetid://11293977610",
})

Window:AddSection({ Name = "Aim Assist", Tab = TabCombat })

Window:AddToggle({
    Title = "Aimbot",
    Description = "Lock-on aim assist (hold RMB)",
    Default = false,
    Tab = TabCombat,
    Callback = function(v) CFG.Aimbot = v end,
})

Window:AddSlider({
    Title = "FOV Radius",
    Description = "Detection circle radius",
    Tab = TabCombat,
    MaxValue = 900,
    AllowDecimals = false,
    Callback = function(v) CFG.AimFOV = v end,
})

Window:AddSlider({
    Title = "Smoothing",
    Description = "Aim interpolation factor (1 = instant)",
    Tab = TabCombat,
    MaxValue = 50,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v) CFG.AimSmooth = v end,
})

Window:AddToggle({
    Title = "Show FOV Circle",
    Description = "Render the FOV boundary",
    Default = false,
    Tab = TabCombat,
    Callback = function(v) CFG.ShowFOV = v end,
})

Window:AddDropdown({
    Title = "Target Part",
    Description = "Body part to track",
    Tab = TabCombat,
    Options = {
        ["Head"] = "Head",
        ["Torso"] = "UpperTorso",
        ["Root"] = "HumanoidRootPart",
    },
    Callback = function(v) CFG.AimBone = v end,
})

Window:AddSection({ Name = "Melee Assist", Tab = TabCombat })

Window:AddToggle({
    Title = "Hitbox Expander",
    Description = "Enlarge enemy collision boxes",
    Default = false,
    Tab = TabCombat,
    Callback = function(v)
        CFG.HitboxExp = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("HumanoidRootPart")
                if h then
                    h.Size = v and Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize) or Vector3.new(2,2,1)
                    h.Transparency = v and 0.5 or 1
                end
            end
        end
    end,
})

Window:AddSlider({
    Title = "Hitbox Scale",
    Description = "Size multiplier for hitboxes",
    Tab = TabCombat,
    MaxValue = 30,
    AllowDecimals = false,
    Callback = function(v) CFG.HitboxSize = v end,
})

Window:AddToggle({
    Title = "Kill Aura",
    Description = "Auto-attack nearby enemies",
    Default = false,
    Tab = TabCombat,
    Callback = function(v) CFG.KillAura = v end,
})

Window:AddSlider({
    Title = "Aura Range",
    Description = "Kill aura detection distance",
    Tab = TabCombat,
    MaxValue = 60,
    AllowDecimals = false,
    Callback = function(v) CFG.AuraRange = v end,
})

--// ═══════════════════════════════════════════
--//  TAB: TELEPORT
--// ═══════════════════════════════════════════

local TabTP = Window:AddTab({
    Title = "Teleport",
    Section = "Modules",
    Icon = "rbxassetid://11963373994",
})

Window:AddSection({ Name = "Player Transport", Tab = TabTP })

Window:AddInput({
    Title = "Target Name",
    Description = "Enter partial or full player name",
    Tab = TabTP,
    Callback = function(t) CFG.TpTarget = t end,
})

Window:AddButton({
    Title = "Teleport to Target",
    Description = "Move to the specified player",
    Tab = TabTP,
    Callback = function()
        local query = CFG.TpTarget:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer
            and (p.Name:lower():find(query) or p.DisplayName:lower():find(query))
            and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                HRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                Window:Notify({ Title = "Teleport",
                    Description = "Moved to " .. p.DisplayName, Duration = 3 })
                return
            end
        end
        Window:Notify({ Title = "Error",
            Description = "Player not found", Duration = 3 })
    end,
})

Window:AddButton({
    Title = "Random Player",
    Description = "Teleport to a random online player",
    Tab = TabTP,
    Callback = function()
        local pool = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(pool, p)
            end
        end
        if #pool == 0 then
            Window:Notify({ Title = "Error", Description = "No players available", Duration = 3 })
            return
        end
        local t = pool[math.random(#pool)]
        HRP.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        Window:Notify({ Title = "Random TP",
            Description = "Moved to " .. t.DisplayName, Duration = 3 })
    end,
})

Window:AddSection({ Name = "Waypoints", Tab = TabTP })

Window:AddButton({
    Title = "Save Position",
    Description = "Store current coordinates",
    Tab = TabTP,
    Callback = function()
        CFG.SavedCF = HRP.CFrame
        Window:Notify({ Title = "Saved", Description = "Position stored", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Load Position",
    Description = "Return to stored coordinates",
    Tab = TabTP,
    Callback = function()
        if CFG.SavedCF then
            HRP.CFrame = CFG.SavedCF
            Window:Notify({ Title = "Loaded", Description = "Position restored", Duration = 2 })
        else
            Window:Notify({ Title = "Error", Description = "Nothing saved", Duration = 2 })
        end
    end,
})

Window:AddToggle({
    Title = "Click Teleport",
    Description = "Click any surface to teleport there",
    Default = false,
    Tab = TabTP,
    Callback = function(v) CFG.ClickTP = v end,
})

--// ═══════════════════════════════════════════
--//  TAB: ESP
--// ═══════════════════════════════════════════

local TabESP = Window:AddTab({
    Title = "ESP",
    Section = "Visuals",
    Icon = "rbxassetid://11293977610",
})

Window:AddSection({ Name = "Rendering", Tab = TabESP })

Window:AddToggle({
    Title = "Enable ESP",
    Description = "Master switch for all ESP features",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.ESP = v end,
})

Window:AddToggle({
    Title = "Bounding Box",
    Description = "Draw rectangles around players",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.BoxESP = v end,
})

Window:AddToggle({
    Title = "Name Tags",
    Description = "Display player names overhead",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.NameESP = v end,
})

Window:AddToggle({
    Title = "Health Bars",
    Description = "Show health indicator beside players",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.HealthESP = v end,
})

Window:AddToggle({
    Title = "Distance Tags",
    Description = "Show distance in studs",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.DistESP = v end,
})

Window:AddToggle({
    Title = "Tracers",
    Description = "Lines from screen edge to targets",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.TracerESP = v end,
})

Window:AddToggle({
    Title = "Chams",
    Description = "Highlight players through geometry",
    Default = false,
    Tab = TabESP,
    Callback = function(v)
        CFG.ChamsESP = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local ex = p.Character:FindFirstChild("_Highlight")
                if v and not ex then
                    local h = Instance.new("Highlight")
                    h.Name = "_Highlight"
                    h.FillColor = Color3.fromRGB(130, 80, 220)
                    h.FillTransparency = 0.4
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = p.Character
                elseif not v and ex then
                    ex:Destroy()
                end
            end
        end
    end,
})

Window:AddSection({ Name = "Filters", Tab = TabESP })

Window:AddToggle({
    Title = "Team Filter",
    Description = "Exclude teammates from ESP and aimbot",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.TeamCheck = v end,
})

--// ═══════════════════════════════════════════
--//  TAB: ENVIRONMENT
--// ═══════════════════════════════════════════

local TabEnv = Window:AddTab({
    Title = "Environment",
    Section = "Visuals",
    Icon = "rbxassetid://11963373994",
})

Window:AddSection({ Name = "Lighting Control", Tab = TabEnv })

Window:AddToggle({
    Title = "Fullbright",
    Description = "Remove all shadows and darkness",
    Default = false,
    Tab = TabEnv,
    Callback = function(v)
        CFG.Fullbright = v
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
    Title = "No Fog",
    Description = "Disable fog rendering",
    Default = false,
    Tab = TabEnv,
    Callback = function(v)
        CFG.NoFog = v
        Lighting.FogEnd = v and 9999999 or 100000
        Lighting.FogStart = 0
    end,
})

Window:AddToggle({
    Title = "Time Lock",
    Description = "Lock the in-game clock",
    Default = false,
    Tab = TabEnv,
    Callback = function(v) CFG.CustomTime = v end,
})

Window:AddSlider({
    Title = "Clock Time",
    Description = "Set hour of day (0-24)",
    Tab = TabEnv,
    MaxValue = 24,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v)
        CFG.TimeVal = v
        if CFG.CustomTime then Lighting.ClockTime = v end
    end,
})

Window:AddSection({ Name = "Optimization", Tab = TabEnv })

Window:AddButton({
    Title = "Strip Post-Effects",
    Description = "Remove bloom, blur, DOF, sun rays",
    Tab = TabEnv,
    Callback = function()
        local n = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect")
            or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then
                e:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "Cleanup", Description = n .. " effects removed", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Strip Particles",
    Description = "Remove fire, smoke, sparkles, particles",
    Tab = TabEnv,
    Callback = function()
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
                o:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "Cleanup", Description = n .. " particles removed", Duration = 2 })
    end,
})

--// ═══════════════════════════════════════════
--//  TAB: UTILITIES
--// ═══════════════════════════════════════════

local TabUtil = Window:AddTab({
    Title = "Utilities",
    Section = "Modules",
    Icon = "rbxassetid://11963373994",
})

Window:AddSection({ Name = "Protection", Tab = TabUtil })

Window:AddToggle({
    Title = "Anti-AFK",
    Description = "Prevent idle disconnection",
    Default = false,
    Tab = TabUtil,
    Callback = function(v) CFG.AntiAFK = v end,
})

Window:AddSection({ Name = "Actions", Tab = TabUtil })

Window:AddToggle({
    Title = "Character Spin",
    Description = "Continuous rotation",
    Default = false,
    Tab = TabUtil,
    Callback = function(v) CFG.Spin = v end,
})

Window:AddButton({
    Title = "Spawn Platform",
    Description = "Create a neon platform below you",
    Tab = TabUtil,
    Callback = function()
        local p = Instance.new("Part")
        p.Size = Vector3.new(20, 1, 20)
        p.CFrame = HRP.CFrame * CFrame.new(0, -4, 0)
        p.Anchored = true
        p.BrickColor = BrickColor.new("Bright violet")
        p.Material = Enum.Material.Neon
        p.Transparency = 0.3
        p.Parent = Workspace
        Window:Notify({ Title = "Platform", Description = "Platform created", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Force Sit",
    Description = "Make character sit immediately",
    Tab = TabUtil,
    Callback = function()
        pcall(function() Humanoid.Sit = true end)
    end,
})

Window:AddSection({ Name = "Chat Automation", Tab = TabUtil })

Window:AddInput({
    Title = "Message",
    Description = "Text to send repeatedly",
    Tab = TabUtil,
    Callback = function(t) CFG.SpamMsg = t end,
})

Window:AddSlider({
    Title = "Interval",
    Description = "Delay between messages (seconds)",
    Tab = TabUtil,
    MaxValue = 10,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v) CFG.SpamDelay = v end,
})

Window:AddToggle({
    Title = "Chat Spam",
    Description = "Repeat message in chat",
    Default = false,
    Tab = TabUtil,
    Callback = function(v) CFG.ChatSpam = v end,
})

Window:AddSection({ Name = "Server", Tab = TabUtil })

Window:AddButton({
    Title = "Rejoin Server",
    Description = "Reconnect to this server",
    Tab = TabUtil,
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

Window:AddButton({
    Title = "Server Hop",
    Description = "Jump to a different server",
    Tab = TabUtil,
    Callback = function()
        task.spawn(function()
            local ok, data = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(
                    ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
                ))
            end)
            if not ok then
                Window:Notify({ Title = "Error", Description = "Failed to fetch servers", Duration = 3 })
                return
            end
            for _, sv in ipairs(data.data) do
                if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
                    return
                end
            end
            Window:Notify({ Title = "Error", Description = "No available servers", Duration = 3 })
        end)
    end,
})

--// ═══════════════════════════════════════════
--//  TAB: CONFIG
--// ═══════════════════════════════════════════

local TabConfig = Window:AddTab({
    Title = "Configuration",
    Section = "Settings",
    Icon = "rbxassetid://11293977610",
})

Window:AddSection({ Name = "Interface", Tab = TabConfig })

Window:AddDropdown({
    Title = "Theme",
    Description = "Visual style preset",
    Tab = TabConfig,
    Options = {
        ["Dark"] = "Dark",
        ["Void"] = "Void",
        ["Amethyst"] = "Amethyst",
        ["Midnight"] = "Midnight",
        ["Crimson"] = "Crimson",
    },
    Callback = function(v)
        Window:SetTheme(Themes[v])
    end,
})

Window:AddSlider({
    Title = "Transparency",
    Description = "Window background opacity",
    Tab = TabConfig,
    MaxValue = 1,
    AllowDecimals = true,
    DecimalAmount = 2,
    Callback = function(v)
        Window:SetSetting("Transparency", v)
    end,
})

Window:AddToggle({
    Title = "Background Blur",
    Description = "Blur behind window (requires Graphics 8+)",
    Default = true,
    Tab = TabConfig,
    Callback = function(v)
        Window:SetSetting("Blur", v)
    end,
})

Window:AddKeybind({
    Title = "Toggle Keybind",
    Description = "Key to open/close menu",
    Tab = TabConfig,
    Callback = function(key)
        Window:SetSetting("Keybind", key)
    end,
})

Window:AddSection({ Name = "Window", Tab = TabConfig })

Window:AddDropdown({
    Title = "Window Size",
    Description = "Resize the menu window",
    Tab = TabConfig,
    Options = {
        ["Compact (480x300)"] = "Compact",
        ["Default (560x360)"] = "Default",
        ["Large (650x420)"] = "Large",
        ["Wide (720x380)"] = "Wide",
    },
    Callback = function(v)
        local sizes = {
            Compact = UDim2.fromOffset(480, 300),
            Default = UDim2.fromOffset(560, 360),
            Large = UDim2.fromOffset(650, 420),
            Wide = UDim2.fromOffset(720, 380),
        }
        Window:SetSetting("Size", sizes[v])
    end,
})

Window:AddSection({ Name = "About", Tab = TabConfig })

Window:AddParagraph({
    Title = "Eplisma v1.0",
    Description = "Developer: Frost\nTelegram: @Jokerfros\n\nProfessional cheat suite.\nPress [E] to toggle menu.",
    Tab = TabConfig,
})

Window:AddButton({
    Title = "Destroy Eplisma",
    Description = "Completely remove the cheat from memory",
    Tab = TabConfig,
    Callback = function()
        pcall(function() _G._CleanESP() end)
        pcall(function() _G._FOV:Remove() end)
        pcall(function()
            if HRP:FindFirstChild("_BV") then HRP._BV:Destroy() end
            if HRP:FindFirstChild("_BG") then HRP._BG:Destroy() end
        end)
        CFG.Fly = false
        CFG.Noclip = false
        CFG.ESP = false
        CFG.Aimbot = false
        pcall(function()
            for _, g in ipairs(CoreGui:GetChildren()) do
                if g:FindFirstChild("Main") then
                    g:Destroy()
                end
            end
        end)
    end,
})

--// ═══════════════════════════════════════════
--//  DRAWING: FOV CIRCLE
--// ═══════════════════════════════════════════

local FOV = Drawing.new("Circle")
FOV.Thickness = 1.5
FOV.NumSides = 64
FOV.Radius = CFG.AimFOV
FOV.Filled = false
FOV.Visible = false
FOV.ZIndex = 999
FOV.Transparency = 0.75
FOV.Color = Color3.fromRGB(130, 80, 220)
_G._FOV = FOV

--// ═══════════════════════════════════════════
--//  DRAWING: ESP
--// ═══════════════════════════════════════════

local ESPCache = {}

local function MkDraw(cls, props)
    local d = Drawing.new(cls)
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function AddESP(plr)
    if plr == LocalPlayer or ESPCache[plr] then return end
    ESPCache[plr] = {
        Box    = MkDraw("Square", { Thickness=1.5, Filled=false, Color=Color3.fromRGB(130,80,220), Visible=false, ZIndex=5 }),
        Name   = MkDraw("Text",   { Size=13, Center=true, Outline=true, Color=Color3.fromRGB(255,255,255), Visible=false, ZIndex=5, Font=2 }),
        HpBG   = MkDraw("Line",   { Thickness=4, Color=Color3.fromRGB(0,0,0), Visible=false, ZIndex=4 }),
        Hp     = MkDraw("Line",   { Thickness=2, Color=Color3.fromRGB(0,255,0), Visible=false, ZIndex=5 }),
        Dist   = MkDraw("Text",   { Size=11, Center=true, Outline=true, Color=Color3.fromRGB(180,180,200), Visible=false, ZIndex=5, Font=2 }),
        Tracer = MkDraw("Line",   { Thickness=1.5, Color=Color3.fromRGB(130,80,220), Visible=false, ZIndex=5 }),
    }
end

local function DelESP(plr)
    if ESPCache[plr] then
        for _, d in pairs(ESPCache[plr]) do pcall(d.Remove, d) end
        ESPCache[plr] = nil
    end
end

local function HideAll(esp)
    for _, d in pairs(esp) do d.Visible = false end
end

_G._CleanESP = function()
    for p in pairs(ESPCache) do DelESP(p) end
end

for _, p in ipairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(DelESP)

--// ═══════════════════════════════════════════
--//  HELPERS
--// ═══════════════════════════════════════════

local function IsAlly(plr)
    if not CFG.TeamCheck then return false end
    local ok, res = pcall(function() return plr.Team == LocalPlayer.Team end)
    return ok and res
end

local function FindTarget()
    local best, bestD = nil, CFG.AimFOV
    local mp = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or IsAlly(p) then continue end
        local c = p.Character
        if not c then continue end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local part = c:FindFirstChild(CFG.AimBone) or c:FindFirstChild("HumanoidRootPart")
        if not (hum and hum.Health > 0 and part) then continue end
        local sp, vis = Camera:WorldToScreenPoint(part.Position)
        if not vis then continue end
        local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
        if d < bestD then bestD = d; best = p end
    end
    return best
end

--// ═══════════════════════════════════════════
--//  RENDER LOOP
--// ═══════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    local mp = UserInputService:GetMouseLocation()

    -- FOV
    FOV.Visible = CFG.ShowFOV
    FOV.Radius = CFG.AimFOV
    FOV.Position = mp

    -- Aimbot
    if CFG.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = FindTarget()
        if t and t.Character then
            local part = t.Character:FindFirstChild(CFG.AimBone) or t.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local s = 1 / math.max(CFG.AimSmooth, 0.01)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), s)
            end
        end
    end

    -- ESP
    local vp = Camera.ViewportSize
    for plr, esp in pairs(ESPCache) do
        local c = plr.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local head = c and c:FindFirstChild("Head")

        if not (c and hum and hum.Health > 0 and hrp and head and CFG.ESP) or IsAlly(plr) then
            HideAll(esp); continue
        end

        local wp, vis = Camera:WorldToViewportPoint(hrp.Position)
        local hp = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, .5, 0))
        local fp = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

        if not vis then HideAll(esp); continue end

        local bH = math.abs(hp.Y - fp.Y)
        local bW = bH * 0.55
        local cx = wp.X

        esp.Box.Visible = CFG.BoxESP
        esp.Box.Size = Vector2.new(bW, bH)
        esp.Box.Position = Vector2.new(cx - bW * .5, hp.Y)

        esp.Name.Visible = CFG.NameESP
        esp.Name.Text = plr.DisplayName
        esp.Name.Position = Vector2.new(cx, hp.Y - 16)

        local pct = hum.Health / hum.MaxHealth
        esp.HpBG.Visible = CFG.HealthESP
        esp.HpBG.From = Vector2.new(cx - bW * .5 - 5, fp.Y)
        esp.HpBG.To = Vector2.new(cx - bW * .5 - 5, hp.Y)
        esp.Hp.Visible = CFG.HealthESP
        esp.Hp.From = Vector2.new(cx - bW * .5 - 5, fp.Y)
        esp.Hp.To = Vector2.new(cx - bW * .5 - 5, fp.Y - bH * pct)
        esp.Hp.Color = Color3.new(1 - pct, pct, 0)

        local dist = (HRP.Position - hrp.Position).Magnitude
        esp.Dist.Visible = CFG.DistESP
        esp.Dist.Text = math.floor(dist) .. "m"
        esp.Dist.Position = Vector2.new(cx, fp.Y + 3)

        esp.Tracer.Visible = CFG.TracerESP
        esp.Tracer.From = Vector2.new(vp.X * .5, vp.Y)
        esp.Tracer.To = Vector2.new(cx, fp.Y)
    end

    -- Fly
    if CFG.Fly and HRP then
        local bv = HRP:FindFirstChild("_BV")
        local bg = HRP:FindFirstChild("_BG")
        if not bv then
            bv = Instance.new("BodyVelocity"); bv.Name = "_BV"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Parent = HRP
        end
        if not bg then
            bg = Instance.new("BodyGyro"); bg.Name = "_BG"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.D = 200; bg.P = 10000; bg.Parent = HRP
        end
        bg.CFrame = Camera.CFrame
        local dir = Vector3.zero
        local u = UserInputService
        if u:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if u:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if u:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if u:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if u:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if u:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.yAxis end
        bv.Velocity = dir * CFG.FlySpeed
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Flying) end)
    end

    -- Spin
    if CFG.Spin and HRP then
        HRP.CFrame *= CFrame.Angles(0, math.rad(10), 0)
    end

    -- Time Lock
    if CFG.CustomTime then
        Lighting.ClockTime = CFG.TimeVal
    end
end)

--// ═══════════════════════════════════════════
--//  HEARTBEAT LOOP
--// ═══════════════════════════════════════════

RunService.Heartbeat:Connect(function()
    if CFG.GodMode and Humanoid then
        pcall(function() Humanoid.Health = Humanoid.MaxHealth end)
    end
    if CFG.Noclip and Character then
        for _, p in ipairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

--// ═══════════════════════════════════════════
--//  INPUT EVENTS
--// ═══════════════════════════════════════════

UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump and Humanoid then
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end)

Mouse.Button1Down:Connect(function()
    if CFG.ClickTP and Mouse.Hit then
        pcall(function() HRP.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end)
    end
end)

--// ═══════════════════════════════════════════
--//  BACKGROUND TASKS
--// ═══════════════════════════════════════════

LocalPlayer.Idled:Connect(function()
    if CFG.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

task.spawn(function()
    while true do
        if CFG.ChatSpam and CFG.SpamMsg ~= "" then
            pcall(function()
                ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents", true)
                    :FindFirstChild("SayMessageRequest"):FireServer(CFG.SpamMsg, "All")
            end)
        end
        task.wait(math.max(CFG.SpamDelay, 0.5))
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if not CFG.KillAura or not HRP then continue end
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or IsAlly(p) then continue end
            local c = p.Character
            local hrp2 = c and c:FindFirstChild("HumanoidRootPart")
            local hum2 = c and c:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum2 and hum2.Health > 0 then
                if (HRP.Position - hrp2.Position).Magnitude <= CFG.AuraRange then
                    pcall(function()
                        local tool = Character:FindFirstChildOfClass("Tool")
                        if tool then
                            local h = tool:FindFirstChild("Handle")
                            if h then
                                firetouchinterest(h, hrp2, 0)
                                task.wait()
                                firetouchinterest(h, hrp2, 1)
                            end
                        end
                    end)
                end
            end
        end
    end
end)

-- Auto-apply hitbox expansion for new players
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if CFG.HitboxExp then
            task.wait(1)
            local h = char:FindFirstChild("HumanoidRootPart")
            if h then
                h.Size = Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize)
                h.Transparency = 0.5
            end
        end
        if CFG.ChamsESP then
            task.wait(1)
            if not char:FindFirstChild("_Highlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "_Highlight"
                hl.FillColor = Color3.fromRGB(130, 80, 220)
                hl.FillTransparency = 0.4
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = char
            end
        end
    end)
end)

--// ═══════════════════════════════════════════
--//  STARTUP
--// ═══════════════════════════════════════════

Window:Notify({
    Title = "Eplisma Loaded",
    Description = "Welcome, " .. LocalPlayer.DisplayName .. "\nPress [E] to toggle menu\nby Frost | @Jokerfros",
    Duration = 6,
})

print([[
╔══════════════════════════════════════╗
║         E P L I S M A  v1.0         ║
║     Developer: Frost                ║
║     Telegram: @Jokerfros            ║
╠══════════════════════════════════════╣
║  Player: ]] .. LocalPlayer.Name .. [[

║  Place: ]] .. game.PlaceId .. [[

╚══════════════════════════════════════╝
]])
