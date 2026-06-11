--[[
    ╔══════════════════════════════════════════╗
    ║           E P L I S M A                  ║
    ║       Professional Cheat Suite           ║
    ║                                          ║
    ║   Developer: Frost                       ║
    ║   Telegram: @Jokerfros                   ║
    ║   Version: 2.0                           ║
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
local StarterGui = game:GetService("StarterGui")

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
--//  LIBRARY SETUP
--// ═══════════════════════════════════════════

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"
))()

local Window = Library:CreateWindow({
    Title = "Eplisma",
    Theme = "Dark",
    Size = UDim2.fromOffset(560, 360),
    Transparency = 0,
    Blurring = false,
    MinimizeKeybind = Enum.KeyCode.RightControl,
})

--// Прибираємо блюр що міг створитись
task.delay(0.5, function()
    pcall(function()
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") and (obj.Name == "Blur" or obj.Name == "blur") then
                obj:Destroy()
            end
        end
    end)
end)

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
    Emerald = {
        Primary = Color3.fromRGB(10, 20, 14),
        Secondary = Color3.fromRGB(14, 28, 18),
        Component = Color3.fromRGB(20, 38, 26),
        Interactables = Color3.fromRGB(28, 52, 36),
        Tab = Color3.fromRGB(140, 210, 160),
        Title = Color3.fromRGB(200, 255, 210),
        Description = Color3.fromRGB(130, 190, 145),
        Shadow = Color3.fromRGB(2, 10, 4),
        Outline = Color3.fromRGB(32, 62, 40),
        Icon = Color3.fromRGB(140, 230, 160),
    },
    Ocean = {
        Primary = Color3.fromRGB(8, 18, 24),
        Secondary = Color3.fromRGB(12, 24, 34),
        Component = Color3.fromRGB(18, 34, 48),
        Interactables = Color3.fromRGB(24, 48, 65),
        Tab = Color3.fromRGB(120, 190, 220),
        Title = Color3.fromRGB(180, 230, 255),
        Description = Color3.fromRGB(110, 170, 200),
        Shadow = Color3.fromRGB(2, 8, 14),
        Outline = Color3.fromRGB(28, 55, 75),
        Icon = Color3.fromRGB(130, 200, 240),
    },
}

Window:SetTheme(Themes.Dark)

--// ═══════════════════════════════════════════
--//  КНОПКА E — toggle чіту
--// ═══════════════════════════════════════════

local _mainGui = nil

-- Знаходимо головний GUI чіту
task.delay(1, function()
    pcall(function()
        local screens = {CoreGui, LocalPlayer.PlayerGui}
        for _, parent in ipairs(screens) do
            for _, gui in ipairs(parent:GetChildren()) do
                if gui:IsA("ScreenGui") and gui:FindFirstChild("Main") then
                    _mainGui = gui
                    break
                end
            end
            if _mainGui then break end
        end
    end)
end)

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "EplismaToggleBtn"
ToggleGui.ResetOnSpawn = false
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.DisplayOrder = 999999
pcall(function() ToggleGui.Parent = CoreGui end)
if not ToggleGui.Parent then ToggleGui.Parent = LocalPlayer.PlayerGui end

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "EBtn"
ToggleButton.Size = UDim2.fromOffset(36, 36)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "E"
ToggleButton.TextColor3 = Color3.fromRGB(160, 120, 240)
ToggleButton.TextSize = 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = false
ToggleButton.ZIndex = 999999
ToggleButton.Parent = ToggleGui

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(100, 60, 180)
ToggleStroke.Thickness = 1.4
ToggleStroke.Transparency = 0.3
ToggleStroke.Parent = ToggleButton

do
    local dragging, dragStart, startPos, hasMoved = false, nil, nil, false
    local MenuOpen = true

    ToggleButton.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = inp.Position
            startPos = ToggleButton.Position
        end
    end)

    ToggleButton.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 4 then hasMoved = true end
            ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local function DoToggle()
        if hasMoved then hasMoved = false return end
        MenuOpen = not MenuOpen

        -- Метод 1: через збережений GUI
        if _mainGui and _mainGui:FindFirstChild("Main") then
            _mainGui.Main.Visible = MenuOpen
        end

        -- Метод 2: пошук по всіх GUI
        pcall(function()
            local screens = {CoreGui, LocalPlayer.PlayerGui}
            for _, parent in ipairs(screens) do
                for _, gui in ipairs(parent:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui ~= ToggleGui and gui:FindFirstChild("Main") then
                        gui.Main.Visible = MenuOpen
                        if not _mainGui then _mainGui = gui end
                    end
                end
            end
        end)

        -- Метод 3: через Library якщо є
        pcall(function()
            if Library and Library.Main then
                Library.Main.Visible = MenuOpen
            end
        end)

        -- Метод 4: MinimizeKeybind simulation
        pcall(function()
            Window:SetSetting("Visible", MenuOpen)
        end)

        if MenuOpen then
            TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(140, 100, 240), Transparency = 0}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 24, 42)}):Play()
        else
            TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 60, 180), Transparency = 0.3}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 26)}):Play()
        end
    end

    ToggleButton.MouseButton1Click:Connect(DoToggle)

    -- Клавіша E на ПК
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.E then
            DoToggle()
        end
    end)
end

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
    GodMode = false, FreezeCam = false,
    FOV = 70, ThirdPerson = false, ThirdDist = 10,

    Aimbot = false, AimFOV = 250, AimSmooth = 5,
    AimBone = "Head", ShowFOV = false,
    HitboxExp = false, HitboxSize = 5,
    KillAura = false, AuraRange = 15,
    SilentAim = false,
    AutoShoot = false,

    ESP = false, BoxESP = false, NameESP = false,
    HealthESP = false, DistESP = false,
    TracerESP = false, ChamsESP = false, TeamCheck = false,

    Fullbright = false, NoFog = false,
    AntiAFK = false, CustomTime = false, TimeVal = 14,
    ClickTP = false, Spin = false, SpinSpeed = 10,
    ChatSpam = false, SpamMsg = "", SpamDelay = 2,
    SavedCF = nil, TpTarget = "",
    CurrentTheme = "Dark",

    -- Нові
    AntiKick = false, HideName = false,
    FakeHealth = false, NoReset = false,
    AutoJump = false, LongJump = false,
    BunnyHop = false, SpeedGlitch = false,
    NoClipFly = false, Platform = false,
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
    Description = "Movement speed",
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
    Description = "Jump height",
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
    Description = "World gravity (196.2 default)",
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
    Description = "Jump mid-air",
    Default = false,
    Tab = TabChar,
    Callback = function(v) CFG.InfJump = v end,
})

Window:AddToggle({
    Title = "Auto Jump",
    Description = "Automatically jump when walking",
    Default = false,
    Tab = TabChar,
    Callback = function(v)
        CFG.AutoJump = v
        pcall(function() Humanoid.AutoJumpEnabled = v end)
    end,
})

Window:AddToggle({
    Title = "Bunny Hop",
    Description = "Jump instantly on landing",
    Default = false,
    Tab = TabChar,
    Callback = function(v) CFG.BunnyHop = v end,
})

Window:AddToggle({
    Title = "Noclip",
    Description = "Walk through walls",
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

Window:AddSection({ Name = "Camera", Tab = TabChar })

Window:AddSlider({
    Title = "Field of View",
    Description = "Camera FOV (70 default)",
    Tab = TabChar,
    MaxValue = 120,
    AllowDecimals = false,
    Callback = function(v)
        CFG.FOV = v
        Camera.FieldOfView = v
    end,
})

Window:AddSection({ Name = "Survivability", Tab = TabChar })

Window:AddToggle({
    Title = "God Mode",
    Description = "Max health always (client)",
    Default = false,
    Tab = TabChar,
    Callback = function(v) CFG.GodMode = v end,
})

Window:AddToggle({
    Title = "No Reset",
    Description = "Disable reset character button",
    Default = false,
    Tab = TabChar,
    Callback = function(v)
        CFG.NoReset = v
        pcall(function()
            StarterGui:SetCore("ResetButtonCallback", not v)
        end)
    end,
})

Window:AddButton({
    Title = "Force Reset",
    Description = "Kill character instantly",
    Tab = TabChar,
    Callback = function()
        pcall(function() Humanoid.Health = 0 end)
    end,
})

Window:AddButton({
    Title = "Respawn",
    Description = "Force respawn",
    Tab = TabChar,
    Callback = function()
        pcall(function() LocalPlayer:LoadCharacter() end)
    end,
})

Window:AddButton({
    Title = "Freeze Character",
    Description = "Stop all movement",
    Tab = TabChar,
    Callback = function()
        pcall(function()
            HRP.Anchored = not HRP.Anchored
            Window:Notify({ Title = "Freeze", Description = HRP.Anchored and "Frozen" or "Unfrozen", Duration = 2 })
        end)
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
    Description = "Lock-on aim (hold RMB)",
    Default = false,
    Tab = TabCombat,
    Callback = function(v) CFG.Aimbot = v end,
})

Window:AddSlider({
    Title = "FOV Radius",
    Description = "Detection radius",
    Tab = TabCombat,
    MaxValue = 900,
    AllowDecimals = false,
    Callback = function(v) CFG.AimFOV = v end,
})

Window:AddSlider({
    Title = "Smoothing",
    Description = "Aim speed (1 = instant)",
    Tab = TabCombat,
    MaxValue = 50,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v) CFG.AimSmooth = v end,
})

Window:AddToggle({
    Title = "Show FOV Circle",
    Description = "Render FOV boundary",
    Default = false,
    Tab = TabCombat,
    Callback = function(v) CFG.ShowFOV = v end,
})

Window:AddSection({ Name = "Melee", Tab = TabCombat })

Window:AddToggle({
    Title = "Hitbox Expander",
    Description = "Enlarge enemy hitboxes",
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
    Description = "Hitbox size",
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
    Description = "Detection distance",
    Tab = TabCombat,
    MaxValue = 60,
    AllowDecimals = false,
    Callback = function(v) CFG.AuraRange = v end,
})

Window:AddSection({ Name = "Info", Tab = TabCombat })

Window:AddButton({
    Title = "Show Nearest Player",
    Description = "Display closest player info",
    Tab = TabCombat,
    Callback = function()
        local closest, dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; closest = p end
            end
        end
        if closest then
            Window:Notify({ Title = "Nearest Player", Description = closest.DisplayName .. " — " .. math.floor(dist) .. " studs", Duration = 4 })
        else
            Window:Notify({ Title = "Error", Description = "No players nearby", Duration = 3 })
        end
    end,
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
    Description = "Partial or full player name",
    Tab = TabTP,
    Callback = function(t) CFG.TpTarget = t end,
})

Window:AddButton({
    Title = "Teleport to Target",
    Description = "Move to player",
    Tab = TabTP,
    Callback = function()
        local query = CFG.TpTarget:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer
            and (p.Name:lower():find(query) or p.DisplayName:lower():find(query))
            and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                HRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                Window:Notify({ Title = "Teleport", Description = "Moved to " .. p.DisplayName, Duration = 3 })
                return
            end
        end
        Window:Notify({ Title = "Error", Description = "Player not found", Duration = 3 })
    end,
})

Window:AddButton({
    Title = "Random Player",
    Description = "Teleport to random player",
    Tab = TabTP,
    Callback = function()
        local pool = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(pool, p)
            end
        end
        if #pool == 0 then
            Window:Notify({ Title = "Error", Description = "No players", Duration = 3 })
            return
        end
        local t = pool[math.random(#pool)]
        HRP.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        Window:Notify({ Title = "Random TP", Description = "Moved to " .. t.DisplayName, Duration = 3 })
    end,
})

Window:AddButton({
    Title = "Teleport to Spawn",
    Description = "Return to spawn point",
    Tab = TabTP,
    Callback = function()
        pcall(function()
            local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildOfClass("SpawnLocation")
            if spawn then
                HRP.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                Window:Notify({ Title = "Teleport", Description = "Moved to spawn", Duration = 2 })
            else
                HRP.CFrame = CFrame.new(0, 50, 0)
                Window:Notify({ Title = "Teleport", Description = "Moved to origin", Duration = 2 })
            end
        end)
    end,
})

Window:AddButton({
    Title = "Teleport Forward 100",
    Description = "Jump 100 studs forward",
    Tab = TabTP,
    Callback = function()
        pcall(function()
            HRP.CFrame = HRP.CFrame + HRP.CFrame.LookVector * 100
        end)
    end,
})

Window:AddSection({ Name = "Waypoints", Tab = TabTP })

Window:AddButton({
    Title = "Save Position",
    Description = "Store coordinates",
    Tab = TabTP,
    Callback = function()
        CFG.SavedCF = HRP.CFrame
        Window:Notify({ Title = "Saved", Description = "Position stored", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Load Position",
    Description = "Return to saved spot",
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
    Description = "Click surface to teleport",
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
    Description = "Master ESP switch",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.ESP = v end,
})

Window:AddToggle({
    Title = "Bounding Box",
    Description = "Rectangles around players",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.BoxESP = v end,
})

Window:AddToggle({
    Title = "Name Tags",
    Description = "Show player names",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.NameESP = v end,
})

Window:AddToggle({
    Title = "Health Bars",
    Description = "Health indicators",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.HealthESP = v end,
})

Window:AddToggle({
    Title = "Distance Tags",
    Description = "Distance in studs",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.DistESP = v end,
})

Window:AddToggle({
    Title = "Tracers",
    Description = "Lines to targets",
    Default = false,
    Tab = TabESP,
    Callback = function(v) CFG.TracerESP = v end,
})

Window:AddToggle({
    Title = "Chams",
    Description = "Highlight through walls",
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
    Description = "Exclude teammates",
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

Window:AddSection({ Name = "Lighting", Tab = TabEnv })

Window:AddToggle({
    Title = "Fullbright",
    Description = "Remove shadows/darkness",
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
    Description = "Disable fog",
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
    Description = "Lock time of day",
    Default = false,
    Tab = TabEnv,
    Callback = function(v) CFG.CustomTime = v end,
})

Window:AddSlider({
    Title = "Clock Time",
    Description = "Hour (0-24)",
    Tab = TabEnv,
    MaxValue = 24,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v)
        CFG.TimeVal = v
        if CFG.CustomTime then Lighting.ClockTime = v end
    end,
})

Window:AddSection({ Name = "Cleanup", Tab = TabEnv })

Window:AddButton({
    Title = "Remove All Effects",
    Description = "Bloom, blur, DOF, sun rays, atmosphere",
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
    Title = "Remove Particles",
    Description = "Fire, smoke, sparkles",
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

Window:AddButton({
    Title = "Remove Decals & Textures",
    Description = "Strip all decals and textures",
    Tab = TabEnv,
    Callback = function()
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("Decal") or o:IsA("Texture") then
                o:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "Cleanup", Description = n .. " removed", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Remove Sounds",
    Description = "Kill all workspace sounds",
    Tab = TabEnv,
    Callback = function()
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("Sound") then
                o:Stop(); o:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "Cleanup", Description = n .. " sounds removed", Duration = 2 })
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
    Description = "Prevent idle disconnect",
    Default = false,
    Tab = TabUtil,
    Callback = function(v) CFG.AntiAFK = v end,
})

Window:AddToggle({
    Title = "Anti-Kick",
    Description = "Block kick attempts (not guaranteed)",
    Default = false,
    Tab = TabUtil,
    Callback = function(v)
        CFG.AntiKick = v
        if v then
            local old = LocalPlayer.Kick
            LocalPlayer.Kick = function() end
        end
    end,
})

Window:AddSection({ Name = "Actions", Tab = TabUtil })

Window:AddToggle({
    Title = "Character Spin",
    Description = "Continuous rotation",
    Default = false,
    Tab = TabUtil,
    Callback = function(v) CFG.Spin = v end,
})

Window:AddSlider({
    Title = "Spin Speed",
    Description = "Rotation speed",
    Tab = TabUtil,
    MaxValue = 50,
    AllowDecimals = false,
    Callback = function(v) CFG.SpinSpeed = v end,
})

Window:AddButton({
    Title = "Spawn Platform",
    Description = "Neon platform below you",
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
    end,
})

Window:AddButton({
    Title = "Force Sit",
    Description = "Sit immediately",
    Tab = TabUtil,
    Callback = function()
        pcall(function() Humanoid.Sit = true end)
    end,
})

Window:AddButton({
    Title = "Force Jump",
    Description = "Jump right now",
    Tab = TabUtil,
    Callback = function()
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end,
})

Window:AddButton({
    Title = "Copy Position",
    Description = "Copy coordinates to clipboard",
    Tab = TabUtil,
    Callback = function()
        local pos = HRP.Position
        local txt = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        pcall(function() setclipboard(txt) end)
        Window:Notify({ Title = "Copied", Description = txt, Duration = 3 })
    end,
})

Window:AddButton({
    Title = "Copy Game Link",
    Description = "Copy Roblox place link",
    Tab = TabUtil,
    Callback = function()
        local link = "https://www.roblox.com/games/" .. game.PlaceId
        pcall(function() setclipboard(link) end)
        Window:Notify({ Title = "Copied", Description = link, Duration = 3 })
    end,
})

Window:AddSection({ Name = "Chat", Tab = TabUtil })

Window:AddInput({
    Title = "Spam Message",
    Description = "Text to repeat",
    Tab = TabUtil,
    Callback = function(t) CFG.SpamMsg = t end,
})

Window:AddSlider({
    Title = "Spam Interval",
    Description = "Delay (seconds)",
    Tab = TabUtil,
    MaxValue = 10,
    AllowDecimals = true,
    DecimalAmount = 1,
    Callback = function(v) CFG.SpamDelay = v end,
})

Window:AddToggle({
    Title = "Chat Spam",
    Description = "Repeat in chat",
    Default = false,
    Tab = TabUtil,
    Callback = function(v) CFG.ChatSpam = v end,
})

Window:AddSection({ Name = "Server", Tab = TabUtil })

Window:AddButton({
    Title = "Rejoin",
    Description = "Reconnect to this server",
    Tab = TabUtil,
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end,
})

Window:AddButton({
    Title = "Server Hop",
    Description = "Jump to different server",
    Tab = TabUtil,
    Callback = function()
        task.spawn(function()
            local ok, data = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(
                    ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
                ))
            end)
            if not ok then
                Window:Notify({ Title = "Error", Description = "Failed to fetch", Duration = 3 })
                return
            end
            for _, sv in ipairs(data.data) do
                if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
                    return
                end
            end
            Window:Notify({ Title = "Error", Description = "No servers", Duration = 3 })
        end)
    end,
})

Window:AddButton({
    Title = "Server Info",
    Description = "Show server details",
    Tab = TabUtil,
    Callback = function()
        local info = string.format(
            "Players: %d/%d\nPlace: %d\nJobId: %s\nPing: ~%dms",
            #Players:GetPlayers(),
            Players.MaxPlayers,
            game.PlaceId,
            game.JobId:sub(1, 12) .. "...",
            math.floor(LocalPlayer:GetNetworkPing() * 1000)
        )
        Window:Notify({ Title = "Server Info", Description = info, Duration = 6 })
    end,
})

--// ═══════════════════════════════════════════
--//  TAB: SETTINGS
--// ═══════════════════════════════════════════

local TabConfig = Window:AddTab({
    Title = "Settings",
    Section = "Settings",
    Icon = "rbxassetid://11293977610",
})

Window:AddSection({ Name = "Theme", Tab = TabConfig })

local themeNames = {"Dark", "Void", "Amethyst", "Midnight", "Crimson", "Emerald", "Ocean"}
local currentThemeIndex = 1

Window:AddButton({
    Title = "◀ Previous Theme",
    Description = "Switch to previous theme",
    Tab = TabConfig,
    Callback = function()
        currentThemeIndex = currentThemeIndex - 1
        if currentThemeIndex < 1 then currentThemeIndex = #themeNames end
        local name = themeNames[currentThemeIndex]
        CFG.CurrentTheme = name
        Window:SetTheme(Themes[name])
        Window:Notify({ Title = "Theme", Description = name, Duration = 2 })
    end,
})

Window:AddButton({
    Title = "▶ Next Theme",
    Description = "Switch to next theme",
    Tab = TabConfig,
    Callback = function()
        currentThemeIndex = currentThemeIndex + 1
        if currentThemeIndex > #themeNames then currentThemeIndex = 1 end
        local name = themeNames[currentThemeIndex]
        CFG.CurrentTheme = name
        Window:SetTheme(Themes[name])
        Window:Notify({ Title = "Theme", Description = name, Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Show Current Theme",
    Description = "Display active theme name",
    Tab = TabConfig,
    Callback = function()
        Window:Notify({ Title = "Current Theme", Description = CFG.CurrentTheme, Duration = 3 })
    end,
})

Window:AddSection({ Name = "Graphics", Tab = TabConfig })

Window:AddButton({
    Title = "Remove Blur Effects",
    Description = "Delete all blur from Lighting",
    Tab = TabConfig,
    Callback = function()
        local n = 0
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") then
                obj:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "Blur", Description = n .. " blur effects removed", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Remove ALL Post Effects",
    Description = "Strip every post-processing effect",
    Tab = TabConfig,
    Callback = function()
        local n = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Atmosphere") then
                e:Destroy(); n += 1
            end
        end
        Window:Notify({ Title = "Cleanup", Description = n .. " effects removed", Duration = 2 })
    end,
})

Window:AddButton({
    Title = "Low Graphics Mode",
    Description = "Reduce quality for FPS boost",
    Tab = TabConfig,
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        pcall(function()
            Lighting.GlobalShadows = false
            Lighting.Brightness = 1
        end)
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Atmosphere") then
                e.Enabled = false
            end
        end
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") then
                o.Enabled = false
            end
        end
        Window:Notify({ Title = "Graphics", Description = "Low mode enabled", Duration = 2 })
    end,
})

Window:AddSection({ Name = "Window", Tab = TabConfig })

Window:AddButton({
    Title = "Size: Compact",
    Description = "480 × 300",
    Tab = TabConfig,
    Callback = function()
        pcall(function() Window:SetSetting("Size", UDim2.fromOffset(480, 300)) end)
    end,
})

Window:AddButton({
    Title = "Size: Default",
    Description = "560 × 360",
    Tab = TabConfig,
    Callback = function()
        pcall(function() Window:SetSetting("Size", UDim2.fromOffset(560, 360)) end)
    end,
})

Window:AddButton({
    Title = "Size: Large",
    Description = "650 × 420",
    Tab = TabConfig,
    Callback = function()
        pcall(function() Window:SetSetting("Size", UDim2.fromOffset(650, 420)) end)
    end,
})

Window:AddSection({ Name = "Player Info", Tab = TabConfig })

Window:AddParagraph({
    Title = "Player",
    Description = "Name: " .. LocalPlayer.Name .. "\nDisplay: " .. LocalPlayer.DisplayName .. "\nID: " .. LocalPlayer.UserId,
    Tab = TabConfig,
})

Window:AddButton({
    Title = "Copy Player ID",
    Description = "Copy your UserId",
    Tab = TabConfig,
    Callback = function()
        pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end)
        Window:Notify({ Title = "Copied", Description = tostring(LocalPlayer.UserId), Duration = 2 })
    end,
})

Window:AddSection({ Name = "About", Tab = TabConfig })

Window:AddParagraph({
    Title = "Eplisma v2.0",
    Description = "Developer: Frost\nTelegram: @Jokerfros\n\nPress E or tap button to toggle.\n7 themes • No blur • Clean 1080p",
    Tab = TabConfig,
})

Window:AddSection({ Name = "Danger Zone", Tab = TabConfig })

Window:AddButton({
    Title = "Destroy Eplisma",
    Description = "Remove cheat completely",
    Tab = TabConfig,
    Callback = function()
        pcall(function() _G._CleanESP() end)
        pcall(function() _G._FOV:Remove() end)
        pcall(function()
            if HRP:FindFirstChild("_BV") then HRP._BV:Destroy() end
            if HRP:FindFirstChild("_BG") then HRP._BG:Destroy() end
        end)
        CFG.Fly = false; CFG.Noclip = false; CFG.ESP = false; CFG.Aimbot = false
        pcall(function() ToggleGui:Destroy() end)
        pcall(function()
            for _, g in ipairs(CoreGui:GetChildren()) do
                if g:FindFirstChild("Main") then g:Destroy() end
            end
            for _, g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
                if g:FindFirstChild("Main") then g:Destroy() end
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
        HRP.CFrame *= CFrame.Angles(0, math.rad(CFG.SpinSpeed), 0)
    end

    -- Time Lock
    if CFG.CustomTime then
        Lighting.ClockTime = CFG.TimeVal
    end

    -- WalkSpeed lock
    if CFG.Speed ~= 16 and Humanoid then
        pcall(function() Humanoid.WalkSpeed = CFG.Speed end)
    end

    -- JumpPower lock
    if CFG.JumpPower ~= 50 and Humanoid then
        pcall(function() Humanoid.JumpPower = CFG.JumpPower end)
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
    if CFG.BunnyHop and Humanoid then
        pcall(function()
            if Humanoid.FloorMaterial ~= Enum.Material.Air then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
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

-- Hitbox + Chams для нових гравців
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

-- Фінальна чистка блюрів
task.delay(2, function()
    pcall(function()
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") then obj:Destroy() end
        end
    end)
end)

--// ═══════════════════════════════════════════
--//  STARTUP
--// ═══════════════════════════════════════════

Window:Notify({
    Title = "Eplisma v2.0 Loaded",
    Description = "Welcome, " .. LocalPlayer.DisplayName .. "\nTap [E] or press E to toggle\nby Frost | @Jokerfros",
    Duration = 6,
})

print([[
╔══════════════════════════════════════╗
║         E P L I S M A  v2.0         ║
║     Developer: Frost                ║
║     Telegram: @Jokerfros            ║
╠══════════════════════════════════════╣
║  Player: ]] .. LocalPlayer.Name .. [[

║  Place: ]] .. game.PlaceId .. [[

╚══════════════════════════════════════╝
]])
