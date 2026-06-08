-- // Nakonchay Script
-- // Author: Fovenko
-- // UI Library: Obsidian

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = workspace.CurrentCamera

-- // Settings Table
local Settings = {
    Fly = {
        Enabled = false,
        Speed = 50,
    },
    Movement = {
        WalkSpeed = 16,
        JumpPower = 50,
    },
    ESP = {
        Box = false,
        Skeleton = false,
        Name = false,
        BoxColor = Color3.fromRGB(255, 50, 50),
        SkeletonColor = Color3.fromRGB(50, 255, 50),
        NameColor = Color3.fromRGB(255, 255, 255),
    },
}

local ESPObjects = {}
local FlyConnection = nil
local BodyVelocity = nil
local BodyGyro = nil
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ================================
-- // Load Obsidian UI
-- ================================

local Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/richie0866/Obsidian/master/src/init.lua"))()

local Window = Obsidian.new({
    Title = "Nakonchay",
    Author = "Fovenko",
    Version = "1.0.0",
    Size = Vector2.new(600, 480),
})

-- ================================
-- // Tabs
-- ================================

local TabMain = Window:Tab("Main")
local TabESP  = Window:Tab("ESP")
local TabInfo = Window:Tab("Info")

-- ================================
-- // Fly Logic
-- ================================

local function StopFly()
    Settings.Fly.Enabled = false

    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end

    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end

    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
    end
end

local function StartFly()
    Settings.Fly.Enabled = true

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    hum.PlatformStand = true

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    BodyVelocity.Parent = root

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    BodyGyro.D = 100
    BodyGyro.P = 10000
    BodyGyro.Parent = root

    FlyConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Fly.Enabled then return end

        local c = LocalPlayer.Character
        if not c then StopFly() return end

        local r = c:FindFirstChild("HumanoidRootPart")
        if not r then StopFly() return end

        local Direction = Vector3.zero
        local Speed = Settings.Fly.Speed

        if not isMobile then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                Direction += Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                Direction -= Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                Direction -= Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                Direction += Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Direction += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                Direction -= Vector3.new(0, 1, 0)
            end
        else
            local MoveDir = c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").MoveDirection or Vector3.zero
            if MoveDir.Magnitude > 0 then
                Direction += Vector3.new(MoveDir.X, 0, MoveDir.Z)
            end
        end

        if Direction.Magnitude > 0 then
            BodyVelocity.Velocity = Direction.Unit * Speed
        else
            BodyVelocity.Velocity = Vector3.zero
        end

        BodyGyro.CFrame = Camera.CFrame
    end)
end

-- ================================
-- // Movement Logic
-- ================================

local function ApplyWalkSpeed(speed)
    Settings.Movement.WalkSpeed = speed
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    end
end

local function ApplyJumpPower(power)
    Settings.Movement.JumpPower = power
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = power
        end
    end
end

-- ================================
-- // ESP Logic
-- ================================

local function RemoveESP(player)
    if not ESPObjects[player] then return end
    local data = ESPObjects[player]

    if data.Connection then data.Connection:Disconnect() end
    if data.Billboard and data.Billboard.Parent then data.Billboard:Destroy() end
    if data.BoxHighlight and data.BoxHighlight.Parent then data.BoxHighlight:Destroy() end
    for _, line in pairs(data.Skeleton) do
        if line and line.Parent then line:Destroy() end
    end

    ESPObjects[player] = nil
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESPObjects[player] then return end

    local data = {
        Billboard   = nil,
        NameLabel   = nil,
        BoxHighlight = nil,
        Skeleton    = {},
        Connection  = nil,
    }

    -- Name Billboard
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "ESP_Name"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 120, 0, 40)
    Billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    Billboard.ResetOnSpawn = false

    local NameLabel = Instance.new("TextLabel")
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.Font = Enum.Font.GothamSemibold
    NameLabel.TextSize = 13
    NameLabel.TextStrokeTransparency = 0.4
    NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    NameLabel.TextColor3 = Settings.ESP.NameColor
    NameLabel.Text = player.Name
    NameLabel.Parent = Billboard

    data.Billboard = Billboard
    data.NameLabel = NameLabel

    -- Box
    local BoxHighlight = Instance.new("SelectionBox")
    BoxHighlight.Name = "ESP_Box"
    BoxHighlight.LineThickness = 0.04
    BoxHighlight.Color3 = Settings.ESP.BoxColor
    BoxHighlight.SurfaceTransparency = 0.85
    BoxHighlight.SurfaceColor3 = Settings.ESP.BoxColor

    data.BoxHighlight = BoxHighlight

    -- Bones list
    local Bones = {
        {"Head",         "UpperTorso"},
        {"UpperTorso",   "LowerTorso"},
        {"UpperTorso",   "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso",   "RightUpperArm"},
        {"RightUpperArm","RightLowerArm"},
        {"RightLowerArm","RightHand"},
        {"LowerTorso",   "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso",   "RightUpperLeg"},
        {"RightUpperLeg","RightLowerLeg"},
        {"RightLowerLeg","RightFoot"},
    }

    for i = 1, #Bones do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        line.Color = Settings.ESP.SkeletonColor
        data.Skeleton[i] = {Line = line, Bone = Bones[i]}
    end

    -- Main update loop
    data.Connection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then
            for _, skData in pairs(data.Skeleton) do
                skData.Line.Visible = false
            end
            if Billboard.Parent then Billboard.Parent = nil end
            if BoxHighlight.Parent then BoxHighlight.Parent = nil end
            return
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local localChar = LocalPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

        -- Name ESP
        if Settings.ESP.Name then
            Billboard.Parent = root
            NameLabel.TextColor3 = Settings.ESP.NameColor
            if localRoot then
                local dist = math.floor((localRoot.Position - root.Position).Magnitude)
                NameLabel.Text = player.Name .. "  [" .. dist .. "m]"
            else
                NameLabel.Text = player.Name
            end
        else
            if Billboard.Parent then Billboard.Parent = nil end
        end

        -- Box ESP
        if Settings.ESP.Box then
            BoxHighlight.Parent = workspace
            BoxHighlight.Adornee = char
            BoxHighlight.Color3 = Settings.ESP.BoxColor
            BoxHighlight.SurfaceColor3 = Settings.ESP.BoxColor
        else
            if BoxHighlight.Parent then BoxHighlight.Parent = nil end
        end

        -- Skeleton ESP
        if Settings.ESP.Skeleton then
            for _, skData in pairs(data.Skeleton) do
                local p1 = char:FindFirstChild(skData.Bone[1])
                local p2 = char:FindFirstChild(skData.Bone[2])
                if p1 and p2 then
                    local pos1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                    local pos2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                    if vis1 and vis2 then
                        skData.Line.From = Vector2.new(pos1.X, pos1.Y)
                        skData.Line.To   = Vector2.new(pos2.X, pos2.Y)
                        skData.Line.Color = Settings.ESP.SkeletonColor
                        skData.Line.Visible = true
                    else
                        skData.Line.Visible = false
                    end
                else
                    skData.Line.Visible = false
                end
            end
        else
            for _, skData in pairs(data.Skeleton) do
                skData.Line.Visible = false
            end
        end
    end)

    ESPObjects[player] = data
end

local function RefreshESP()
    for p, _ in pairs(ESPObjects) do
        RemoveESP(p)
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            CreateESP(p)
        end
    end
end

-- ================================
-- // Main Tab - Movement
-- ================================

TabMain:Section("Movement")

TabMain:Slider({
    Title       = "Walk Speed",
    Description = "Set the walk speed of your character",
    Min         = 1,
    Max         = 500,
    Default     = 16,
    Callback    = function(v)
        ApplyWalkSpeed(v)
    end,
})

TabMain:Slider({
    Title       = "Jump Power",
    Description = "Set the jump power of your character",
    Min         = 1,
    Max         = 500,
    Default     = 50,
    Callback    = function(v)
        ApplyJumpPower(v)
    end,
})

TabMain:Button({
    Title       = "Reset Movement",
    Description = "Reset walk speed and jump power to default",
    Callback    = function()
        ApplyWalkSpeed(16)
        ApplyJumpPower(50)
    end,
})

-- ================================
-- // Main Tab - Fly
-- ================================

TabMain:Section("Fly")

TabMain:Toggle({
    Title       = "Fly",
    Description = isMobile and "Mobile: use thumbstick to move" or "PC: WASD + Space / Ctrl",
    Default     = false,
    Callback    = function(v)
        if v then
            StartFly()
        else
            StopFly()
        end
    end,
})

TabMain:Slider({
    Title       = "Fly Speed",
    Description = "Set the speed while flying",
    Min         = 5,
    Max         = 500,
    Default     = 50,
    Callback    = function(v)
        Settings.Fly.Speed = v
    end,
})

-- ================================
-- // ESP Tab
-- ================================

TabESP:Section("Toggles")

TabESP:Toggle({
    Title       = "Box ESP",
    Description = "Draw a selection box around players",
    Default     = false,
    Callback    = function(v)
        Settings.ESP.Box = v
        RefreshESP()
    end,
})

TabESP:Toggle({
    Title       = "Skeleton ESP",
    Description = "Draw skeleton lines on players",
    Default     = false,
    Callback    = function(v)
        Settings.ESP.Skeleton = v
        RefreshESP()
    end,
})

TabESP:Toggle({
    Title       = "Name ESP",
    Description = "Show player name and distance",
    Default     = false,
    Callback    = function(v)
        Settings.ESP.Name = v
        RefreshESP()
    end,
})

TabESP:Section("Colors")

TabESP:ColorPicker({
    Title    = "Box Color",
    Default  = Color3.fromRGB(255, 50, 50),
    Callback = function(v)
        Settings.ESP.BoxColor = v
    end,
})

TabESP:ColorPicker({
    Title    = "Skeleton Color",
    Default  = Color3.fromRGB(50, 255, 50),
    Callback = function(v)
        Settings.ESP.SkeletonColor = v
    end,
})

TabESP:ColorPicker({
    Title    = "Name Color",
    Default  = Color3.fromRGB(255, 255, 255),
    Callback = function(v)
        Settings.ESP.NameColor = v
    end,
})

TabESP:Section("Controls")

TabESP:Button({
    Title       = "Refresh ESP",
    Description = "Rebuild ESP for all current players",
    Callback    = function()
        RefreshESP()
    end,
})

-- ================================
-- // Info Tab
-- ================================

TabInfo:Section("Script Info")

TabInfo:Label({
    Title   = "Script",
    Content = "Nakonchay",
})

TabInfo:Label({
    Title   = "Author",
    Content = "Fovenko",
})

TabInfo:Label({
    Title   = "Version",
    Content = "1.0.0",
})

TabInfo:Label({
    Title   = "UI Library",
    Content = "Obsidian",
})

TabInfo:Section("Keybinds")

TabInfo:Label({
    Title   = "Toggle Menu",
    Content = "Right Control",
})

TabInfo:Label({
    Title   = "Fly Up",
    Content = "Space  (while flying)",
})

TabInfo:Label({
    Title   = "Fly Down",
    Content = "Left Control  (while flying)",
})

-- ================================
-- // Player Events
-- ================================

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if Settings.ESP.Box or Settings.ESP.Skeleton or Settings.ESP.Name then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    task.wait(0.5)

    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")

    Humanoid.WalkSpeed = Settings.Movement.WalkSpeed
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = Settings.Movement.JumpPower

    if Settings.Fly.Enabled then
        task.wait(0.3)
        StartFly()
    end
end)

-- ================================
-- // Init
-- ================================

ApplyWalkSpeed(Settings.Movement.WalkSpeed)
ApplyJumpPower(Settings.Movement.JumpPower)
RefreshESP()

print("[Nakonchay] Loaded | Author: Fovenko")
