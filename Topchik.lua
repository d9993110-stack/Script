--[[
    MM2 MASTER UNIFIED EXPLOIT
    UI Library: LinoriaLib (mstudio45 fork)
    Game: Murder Mystery 2
]]

-- ============================================================================
-- ЗАВАНТАЖЕННЯ БІБЛІОТЕКИ LINORIA
-- ============================================================================
local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ============================================================================
-- СЕРВІСИ ТА ЗМІННІ
-- ============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================================
-- ГЛОБАЛЬНІ СТАНИ (STATE MANAGEMENT)
-- ============================================================================
local States = {
    -- ESP
    PlayerESPEnabled = false,
    ESPType = "Box", -- Box / 3DBox / Skeleton / Tracers / Chams
    RoleESPEnabled = false,
    DistanceESPEnabled = false,
    WeaponESPEnabled = false,
    GunDropESPEnabled = false,
    CoinESPEnabled = false,
    TrapESPEnabled = false,
    FullBrightEnabled = false,
    XRayEnabled = false,
    RadarEnabled = false,
    SpectateEnabled = false,
    SpectateTarget = nil,

    -- Combat
    SilentAimEnabled = false,
    AimBotEnabled = false,
    AimBotKey = Enum.KeyCode.E,
    FOVRadius = 200,
    FOVCircleVisible = false,
    PredictionEnabled = false,
    KillAuraEnabled = false,
    KillAuraMode = "Legit", -- Legit / Rage
    KillAuraRadius = 12,
    TeleportKillAuraEnabled = false,
    ThrowBotEnabled = false,
    InstantKnifeReturnEnabled = false,
    RangeExtenderEnabled = false,
    RangeExtenderValue = 2,
    AutoShootMurdererEnabled = false,
    MassMurderEnabled = false,

    -- Movement
    WalkSpeed = 16,
    WalkSpeedEnabled = false,
    JumpPower = 50,
    JumpPowerEnabled = false,
    InfiniteJumpEnabled = false,
    NoclipEnabled = false,
    FlyEnabled = false,
    FlySpeed = 50,
    ClickTPEnabled = false,

    -- Farming
    AutoFarmCoinsEnabled = false,
    AutoFarmMode = "Tween", -- Tween / Instant
    BagNotifierEnabled = false,
    SmartBagLimitEnabled = false,
    ServerHopperEnabled = false,
    LobbyFarmEnabled = false,
    AutoOpenCratesEnabled = false,
    AutoEvadeEnabled = false,
    AutoEvadeDistance = 25,

    -- Trolling
    LoopBringGunEnabled = false,
    FakeDeathEnabled = false,
    EmotionSpamEnabled = false,
    InvisibilityEnabled = false,

    -- Utilities
    RoleRevealEnabled = false,
    AntiAFKEnabled = false,
    GodModeEnabled = false,
    RemoveBarriersEnabled = false,
    AntiCrashEnabled = false,
    ChatSpamEnabled = false,
    ChatSpamText = "MM2 Master Exploit",
    ChatSpamDelay = 2,
    FakeWeaponEnabled = false,
    AutoLeaveAdminEnabled = false,
    StreamerModeEnabled = false,

    -- Colors
    MurdererColor = Color3.fromRGB(255, 0, 0),
    SheriffColor = Color3.fromRGB(0, 100, 255),
    InnocentColor = Color3.fromRGB(0, 255, 0),
    CoinColor = Color3.fromRGB(255, 255, 0),
    GunDropColor = Color3.fromRGB(255, 165, 0),
    TrapColor = Color3.fromRGB(255, 0, 50),
}

-- ============================================================================
-- ESP КОНТЕЙНЕРИ
-- ============================================================================
local ESPContainer = {
    Players = {},
    Coins = {},
    GunDrop = nil,
    Traps = {},
    Radar = nil,
}

local FlyBody = nil
local FlyGyro = nil
local NoclipConnection = nil
local KillAuraConnection = nil
local AutoFarmConnection = nil
local FOVCircle = nil

-- ============================================================================
-- ДОПОМІЖНІ ФУНКЦІЇ (UTILITIES)
-- ============================================================================

-- Безпечне отримання ролей
local function GetMurderer()
    pcall(function() end)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name == "Knife" then
                        return player
                    end
                end
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name == "Knife" then
                        return player
                    end
                end
            end
        end
    end

    -- Перевірка через MM2 систему
    local success, result = pcall(function()
        local roundFolder = ReplicatedStorage:FindFirstChild("Remotes")
        if roundFolder then
            -- MM2 зберігає ролі в певних Value об'єктах
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == "Murderer" and v:IsA("StringValue") then
                    return Players:FindFirstChild(v.Value)
                end
            end
        end
        return nil
    end)

    if success and result then return result end
    return nil
end

local function GetSheriff()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name == "Gun" then
                        return player
                    end
                end
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name == "Gun" then
                        return player
                    end
                end
            end
        end
    end

    -- Також перевіряємо LocalPlayer
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == "Gun" then
            return LocalPlayer
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.Name == "Gun" then
                return LocalPlayer
            end
        end
    end

    return nil
end

local function GetPlayerRole(player)
    -- Перевірка чи гравець Вбивця
    local backpack = player:FindFirstChild("Backpack")
    local char = player.Character

    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.Name == "Knife" then return "Murderer" end
                if tool.Name == "Gun" then return "Sheriff" end
            end
        end
    end

    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.Name == "Knife" then return "Murderer" end
                if tool.Name == "Gun" then return "Sheriff" end
            end
        end
    end

    return "Innocent"
end

local function GetRoleColor(player)
    local role = GetPlayerRole(player)
    if role == "Murderer" then
        return States.MurdererColor
    elseif role == "Sheriff" then
        return States.SheriffColor
    else
        return States.InnocentColor
    end
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function GetClosestPlayerToMouse(radius, filter)
    local closest = nil
    local closestDist = radius or 999
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")

            if humanoid and humanoid.Health > 0 and head then
                if filter and not filter(player) then continue end

                local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end

    return closest
end

local function GetDroppedGun()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name == "Gun" and obj.Parent == Workspace then
            return obj
        end
        if obj.Name == "GunDrop" or (obj:IsA("Model") and obj:FindFirstChild("Gun")) then
            if obj.Parent == Workspace then
                return obj
            end
        end
    end
    return nil
end

local function GetCoins()
    local coins = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Coin" or obj.Name == "CoinVisual" or
           (obj:IsA("BasePart") and obj.Parent and obj.Parent.Name == "CoinContainer") then
            table.insert(coins, obj)
        end
    end

    -- Альтернативний пошук монет
    local coinContainer = Workspace:FindFirstChild("CoinContainer")
        or Workspace:FindFirstChild("Coins")
        or Workspace:FindFirstChild("CoinVisuals")

    if coinContainer then
        for _, coin in pairs(coinContainer:GetDescendants()) do
            if coin:IsA("BasePart") then
                local found = false
                for _, c in pairs(coins) do
                    if c == coin then found = true; break end
                end
                if not found then
                    table.insert(coins, coin)
                end
            end
        end
    end

    return coins
end

local function GetTraps()
    local traps = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Trap" or obj.Name == "Bear Trap" or obj.Name == "TrapModel" then
            table.insert(traps, obj)
        end
    end
    return traps
end

local function Notify(title, text, duration)
    Library:Notify(title .. ": " .. text, duration or 3)
end

-- ============================================================================
-- ESP СИСТЕМИ
-- ============================================================================

-- Клас для створення ESP елементів
local ESPModule = {}

function ESPModule.CreatePlayerESP(player)
    if player == LocalPlayer then return end
    if ESPContainer.Players[player.Name] then
        ESPModule.RemovePlayerESP(player)
    end

    local espData = {
        BillboardGui = nil,
        Box = nil,
        Tracer = nil,
        Highlight = nil,
        DistLabel = nil,
        WeaponLabel = nil,
        NameLabel = nil,
        Connection = nil,
    }

    -- BillboardGui для інформації
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MM2_ESP_" .. player.Name
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.LightInfluence = 0
    billboard.MaxDistance = 1000

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextScaled = false
    nameLabel.Text = player.DisplayName or player.Name
    nameLabel.Parent = billboard

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Name = "RoleLabel"
    roleLabel.Size = UDim2.new(1, 0, 0.25, 0)
    roleLabel.Position = UDim2.new(0, 0, 0.3, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.TextStrokeTransparency = 0
    roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    roleLabel.Font = Enum.Font.GothamBold
    roleLabel.TextSize = 12
    roleLabel.TextScaled = false
    roleLabel.Text = ""
    roleLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0.2, 0)
    distLabel.Position = UDim2.new(0, 0, 0.55, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 11
    distLabel.TextScaled = false
    distLabel.Text = ""
    distLabel.Parent = billboard

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Name = "WeaponLabel"
    weaponLabel.Size = UDim2.new(1, 0, 0.2, 0)
    weaponLabel.Position = UDim2.new(0, 0, 0.75, 0)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    weaponLabel.TextStrokeTransparency = 0
    weaponLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    weaponLabel.Font = Enum.Font.Gotham
    weaponLabel.TextSize = 11
    weaponLabel.TextScaled = false
    weaponLabel.Text = ""
    weaponLabel.Parent = billboard

    espData.BillboardGui = billboard
    espData.NameLabel = nameLabel
    espData.RoleLabel = roleLabel
    espData.DistLabel = distLabel
    espData.WeaponLabel = weaponLabel

    -- Highlight (Chams)
    local highlight = Instance.new("Highlight")
    highlight.Name = "MM2_Highlight_" .. player.Name
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = false
    espData.Highlight = highlight

    -- Tracer (Drawing API)
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 255, 255)
    tracer.Thickness = 1.5
    tracer.Transparency = 1
    espData.Tracer = tracer

    -- Box (Drawing API)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Thickness = 1.5
    box.Filled = false
    box.Transparency = 1
    espData.Box = box

    -- Skeleton Lines
    espData.SkeletonLines = {}

    -- Update connection
    espData.Connection = RunService.RenderStepped:Connect(function()
        pcall(function()
            local char = player.Character
            if not char or not States.PlayerESPEnabled then
                billboard.Parent = nil
                highlight.Enabled = false
                tracer.Visible = false
                box.Visible = false
                for _, line in pairs(espData.SkeletonLines) do
                    line.Visible = false
                end
                return
            end

            local humanoid = char:FindFirstChild("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local head = char:FindFirstChild("Head")

            if not humanoid or humanoid.Health <= 0 or not rootPart or not head then
                billboard.Parent = nil
                highlight.Enabled = false
                tracer.Visible = false
                box.Visible = false
                for _, line in pairs(espData.SkeletonLines) do
                    line.Visible = false
                end
                return
            end

            -- Оновити Billboard
            billboard.Parent = head
            billboard.Adornee = head

            -- Роль та колір
            local role = GetPlayerRole(player)
            local roleColor = GetRoleColor(player)

            if States.RoleESPEnabled then
                roleLabel.Text = "[" .. role .. "]"
                roleLabel.TextColor3 = roleColor
                nameLabel.TextColor3 = roleColor
            else
                roleLabel.Text = ""
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            -- Відстань
            if States.DistanceESPEnabled then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local dist = math.floor(GetDistance(myRoot.Position, rootPart.Position))
                    distLabel.Text = dist .. "m"
                else
                    distLabel.Text = ""
                end
            else
                distLabel.Text = ""
            end

            -- Зброя
            if States.WeaponESPEnabled then
                local weapon = "None"
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        weapon = tool.Name
                        break
                    end
                end
                if weapon == "None" then
                    for _, tool in pairs(player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") then
                            weapon = "🎒 " .. tool.Name
                            break
                        end
                    end
                else
                    weapon = "🔪 " .. weapon
                end
                weaponLabel.Text = weapon
            else
                weaponLabel.Text = ""
            end

            -- Highlight / Chams
            local espType = States.ESPType
            if espType == "Chams" then
                highlight.Parent = char
                highlight.Adornee = char
                highlight.Enabled = true
                highlight.FillColor = roleColor
                highlight.OutlineColor = roleColor
            else
                highlight.Enabled = false
                highlight.Parent = nil
            end

            -- Screen Position
            local screenPos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
            local headPos, headOnScreen = Camera:WorldToScreenPoint(head.Position + Vector3.new(0, 1, 0))
            local footPos = Camera:WorldToScreenPoint(rootPart.Position - Vector3.new(0, 3, 0))

            -- Box ESP
            if espType == "Box" and onScreen then
                local boxHeight = math.abs(headPos.Y - footPos.Y)
                local boxWidth = boxHeight * 0.6

                box.Size = Vector2.new(boxWidth, boxHeight)
                box.Position = Vector2.new(screenPos.X - boxWidth / 2, headPos.Y)
                box.Color = roleColor
                box.Visible = true
            else
                box.Visible = false
            end

            -- Tracer ESP
            if espType == "Tracers" and onScreen then
                tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                tracer.Color = roleColor
                tracer.Visible = true
            else
                tracer.Visible = false
            end

            -- Skeleton ESP
            if espType == "Skeleton" and onScreen then
                local bones = {
                    {"Head", "UpperTorso"},
                    {"UpperTorso", "LowerTorso"},
                    {"UpperTorso", "LeftUpperArm"},
                    {"LeftUpperArm", "LeftLowerArm"},
                    {"LeftLowerArm", "LeftHand"},
                    {"UpperTorso", "RightUpperArm"},
                    {"RightUpperArm", "RightLowerArm"},
                    {"RightLowerArm", "RightHand"},
                    {"LowerTorso", "LeftUpperLeg"},
                    {"LeftUpperLeg", "LeftLowerLeg"},
                    {"LeftLowerLeg", "LeftFoot"},
                    {"LowerTorso", "RightUpperLeg"},
                    {"RightUpperLeg", "RightLowerLeg"},
                    {"RightLowerLeg", "RightFoot"},
                }

                -- R6 fallback
                local bonesR6 = {
                    {"Head", "Torso"},
                    {"Torso", "Left Arm"},
                    {"Torso", "Right Arm"},
                    {"Torso", "Left Leg"},
                    {"Torso", "Right Leg"},
                }

                local useBones = char:FindFirstChild("UpperTorso") and bones or bonesR6

                -- Створити або оновити лінії
                while #espData.SkeletonLines < #useBones do
                    local line = Drawing.new("Line")
                    line.Visible = false
                    line.Thickness = 1.5
                    line.Color = roleColor
                    table.insert(espData.SkeletonLines, line)
                end

                for i, bonePair in ipairs(useBones) do
                    local partA = char:FindFirstChild(bonePair[1])
                    local partB = char:FindFirstChild(bonePair[2])
                    local line = espData.SkeletonLines[i]

                    if partA and partB and line then
                        local posA, onA = Camera:WorldToScreenPoint(partA.Position)
                        local posB, onB = Camera:WorldToScreenPoint(partB.Position)

                        if onA and onB then
                            line.From = Vector2.new(posA.X, posA.Y)
                            line.To = Vector2.new(posB.X, posB.Y)
                            line.Color = roleColor
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    elseif line then
                        line.Visible = false
                    end
                end
            else
                for _, line in pairs(espData.SkeletonLines) do
                    line.Visible = false
                end
            end
        end)
    end)

    ESPContainer.Players[player.Name] = espData
end

function ESPModule.RemovePlayerESP(player)
    local espData = ESPContainer.Players[player.Name]
    if not espData then return end

    if espData.Connection then espData.Connection:Disconnect() end
    if espData.BillboardGui then espData.BillboardGui:Destroy() end
    if espData.Highlight then espData.Highlight:Destroy() end
    if espData.Tracer then espData.Tracer:Remove() end
    if espData.Box then espData.Box:Remove() end
    for _, line in pairs(espData.SkeletonLines or {}) do
        line:Remove()
    end

    ESPContainer.Players[player.Name] = nil
end

function ESPModule.InitializeAllPlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ESPModule.CreatePlayerESP(player)
        end
    end
end

function ESPModule.RemoveAllPlayerESP()
    for name, _ in pairs(ESPContainer.Players) do
        local player = Players:FindFirstChild(name)
        if player then
            ESPModule.RemovePlayerESP(player)
        else
            local espData = ESPContainer.Players[name]
            if espData then
                if espData.Connection then espData.Connection:Disconnect() end
                if espData.BillboardGui then espData.BillboardGui:Destroy() end
                if espData.Highlight then espData.Highlight:Destroy() end
                if espData.Tracer then espData.Tracer:Remove() end
                if espData.Box then espData.Box:Remove() end
                for _, line in pairs(espData.SkeletonLines or {}) do
                    line:Remove()
                end
            end
        end
    end
    ESPContainer.Players = {}
end

-- Coin ESP
local CoinESPObjects = {}

function ESPModule.UpdateCoinESP()
    -- Видалити старі
    for _, obj in pairs(CoinESPObjects) do
        if obj then obj:Destroy() end
    end
    CoinESPObjects = {}

    if not States.CoinESPEnabled then return end

    local coins = GetCoins()
    for _, coin in pairs(coins) do
        if coin and coin.Parent then
            local bb = Instance.new("BillboardGui")
            bb.Name = "MM2_CoinESP"
            bb.AlwaysOnTop = true
            bb.Size = UDim2.new(0, 100, 0, 40)
            bb.StudsOffset = Vector3.new(0, 2, 0)
            bb.LightInfluence = 0
            bb.MaxDistance = 500

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = States.CoinColor
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
            label.Text = "💰 Coin"
            label.Parent = bb

            if coin:IsA("BasePart") then
                bb.Adornee = coin
                bb.Parent = coin
            elseif coin:IsA("Model") then
                local primary = coin.PrimaryPart or coin:FindFirstChildWhichIsA("BasePart")
                if primary then
                    bb.Adornee = primary
                    bb.Parent = primary
                end
            end

            table.insert(CoinESPObjects, bb)

            -- Highlight
            local hl = Instance.new("Highlight")
            hl.Name = "MM2_CoinHL"
            hl.FillColor = States.CoinColor
            hl.FillTransparency = 0.3
            hl.OutlineColor = States.CoinColor
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = coin:IsA("Model") and coin or coin.Parent
            table.insert(CoinESPObjects, hl)
        end
    end
end

-- Gun Drop ESP
local GunDropESPObjects = {}

function ESPModule.UpdateGunDropESP()
    for _, obj in pairs(GunDropESPObjects) do
        if obj then
            pcall(function() obj:Destroy() end)
            pcall(function() obj:Remove() end)
        end
    end
    GunDropESPObjects = {}

    if not States.GunDropESPEnabled then return end

    local gun = GetDroppedGun()
    if not gun then return end

    local part = nil
    if gun:IsA("BasePart") then
        part = gun
    elseif gun:IsA("Model") then
        part = gun.PrimaryPart or gun:FindFirstChildWhichIsA("BasePart")
    elseif gun:IsA("Tool") then
        part = gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart")
    end

    if not part then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "MM2_GunESP"
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 150, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.LightInfluence = 0
    bb.MaxDistance = 1000
    bb.Adornee = part
    bb.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = States.GunDropColor
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Text = "🔫 DROPPED GUN"
    label.Parent = bb

    local hl = Instance.new("Highlight")
    hl.Name = "MM2_GunHL"
    hl.FillColor = States.GunDropColor
    hl.FillTransparency = 0.2
    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    if gun:IsA("Model") then
        hl.Parent = gun
    else
        hl.Parent = gun.Parent
    end

    table.insert(GunDropESPObjects, bb)
    table.insert(GunDropESPObjects, hl)
end

-- Trap ESP
local TrapESPObjects = {}

function ESPModule.UpdateTrapESP()
    for _, obj in pairs(TrapESPObjects) do
        if obj then obj:Destroy() end
    end
    TrapESPObjects = {}

    if not States.TrapESPEnabled then return end

    local traps = GetTraps()
    for _, trap in pairs(traps) do
        local part = trap:IsA("BasePart") and trap or (trap:IsA("Model") and (trap.PrimaryPart or trap:FindFirstChildWhichIsA("BasePart")))
        if part then
            local bb = Instance.new("BillboardGui")
            bb.Name = "MM2_TrapESP"
            bb.AlwaysOnTop = true
            bb.Size = UDim2.new(0, 120, 0, 40)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.LightInfluence = 0
            bb.MaxDistance = 300
            bb.Adornee = part
            bb.Parent = part

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = States.TrapColor
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.Text = "⚠️ TRAP"
            label.Parent = bb

            local hl = Instance.new("Highlight")
            hl.Name = "MM2_TrapHL"
            hl.FillColor = States.TrapColor
            hl.FillTransparency = 0.3
            hl.OutlineColor = States.TrapColor
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = trap:IsA("Model") and trap or trap.Parent

            table.insert(TrapESPObjects, bb)
            table.insert(TrapESPObjects, hl)
        end
    end
end

-- ============================================================================
-- FOV CIRCLE
-- ============================================================================
local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = States.FOVRadius
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 64
    FOVCircle.Filled = false
    FOVCircle.Visible = States.FOVCircleVisible
    FOVCircle.Transparency = 0.7
end

-- ============================================================================
-- RADAR SYSTEM
-- ============================================================================
local RadarFrame = nil
local RadarDots = {}

local function CreateRadar()
    if RadarFrame then RadarFrame:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MM2_Radar"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(screenGui)
        end
    end)

    screenGui.Parent = game:GetService("CoreGui")

    RadarFrame = Instance.new("Frame")
    RadarFrame.Name = "RadarBG"
    RadarFrame.Size = UDim2.new(0, 180, 0, 180)
    RadarFrame.Position = UDim2.new(0, 10, 0.5, -90)
    RadarFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    RadarFrame.BackgroundTransparency = 0.3
    RadarFrame.BorderSizePixel = 0
    RadarFrame.Visible = States.RadarEnabled
    RadarFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = RadarFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1
    stroke.Parent = RadarFrame

    -- Center dot (you)
    local centerDot = Instance.new("Frame")
    centerDot.Size = UDim2.new(0, 6, 0, 6)
    centerDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    centerDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    centerDot.BorderSizePixel = 0
    centerDot.Parent = RadarFrame

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = centerDot

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 16)
    title.Position = UDim2.new(0, 0, 0, 2)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 10
    title.Text = "RADAR"
    title.Parent = RadarFrame

    return screenGui
end

local RadarConnection = nil

local function UpdateRadar()
    if RadarConnection then RadarConnection:Disconnect() end
    if not States.RadarEnabled then
        if RadarFrame then RadarFrame.Visible = false end
        return
    end

    if not RadarFrame then CreateRadar() end
    RadarFrame.Visible = true

    RadarConnection = RunService.RenderStepped:Connect(function()
        if not States.RadarEnabled then
            RadarConnection:Disconnect()
            RadarFrame.Visible = false
            return
        end

        -- Очистити старі точки
        for _, dot in pairs(RadarDots) do
            if dot then dot:Destroy() end
        end
        RadarDots = {}

        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local radarScale = 2 -- pixels per stud
        local radarSize = 180
        local half = radarSize / 2

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if theirRoot and humanoid and humanoid.Health > 0 then
                    local offset = theirRoot.Position - myRoot.Position
                    local lookVector = myRoot.CFrame.LookVector

                    -- Rotate relative to player's facing direction
                    local angle = math.atan2(lookVector.X, lookVector.Z)
                    local cos = math.cos(angle)
                    local sin = math.sin(angle)

                    local relX = offset.X * cos - offset.Z * sin
                    local relZ = offset.X * sin + offset.Z * cos

                    local dotX = half + relX * radarScale
                    local dotY = half - relZ * radarScale

                    -- Clamp
                    dotX = math.clamp(dotX, 4, radarSize - 4)
                    dotY = math.clamp(dotY, 18, radarSize - 4)

                    local dot = Instance.new("Frame")
                    dot.Size = UDim2.new(0, 5, 0, 5)
                    dot.Position = UDim2.new(0, dotX - 2.5, 0, dotY - 2.5)
                    dot.BackgroundColor3 = GetRoleColor(player)
                    dot.BorderSizePixel = 0
                    dot.Parent = RadarFrame

                    local dc = Instance.new("UICorner")
                    dc.CornerRadius = UDim.new(1, 0)
                    dc.Parent = dot

                    table.insert(RadarDots, dot)
                end
            end
        end
    end)
end

-- ============================================================================
-- FULLBRIGHT
-- ============================================================================
local OriginalLighting = {}

local function ToggleFullBright(enabled)
    if enabled then
        OriginalLighting.Ambient = Lighting.Ambient
        OriginalLighting.Brightness = Lighting.Brightness
        OriginalLighting.ClockTime = Lighting.ClockTime
        OriginalLighting.FogEnd = Lighting.FogEnd
        OriginalLighting.GlobalShadows = Lighting.GlobalShadows
        OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient

        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    else
        if OriginalLighting.Ambient then
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.ClockTime = OriginalLighting.ClockTime
            Lighting.FogEnd = OriginalLighting.FogEnd
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        end
    end
end

-- ============================================================================
-- X-RAY MODE
-- ============================================================================
local XRayParts = {}

local function ToggleXRay(enabled)
    if enabled then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency < 0.5 then
                local isPlayer = false
                local parent = obj.Parent
                while parent do
                    if parent:FindFirstChild("Humanoid") then
                        isPlayer = true
                        break
                    end
                    parent = parent.Parent
                end

                if not isPlayer and not obj.Name:lower():find("coin") then
                    table.insert(XRayParts, {Part = obj, OriginalTransparency = obj.Transparency})
                    obj.Transparency = 0.7
                end
            end
        end
    else
        for _, data in pairs(XRayParts) do
            if data.Part and data.Part.Parent then
                data.Part.Transparency = data.OriginalTransparency
            end
        end
        XRayParts = {}
    end
end

-- ============================================================================
-- SILENT AIM
-- ============================================================================
local OldNamecall
local SilentAimHook = nil

local function ToggleSilentAim(enabled)
    if enabled then
        if SilentAimHook then return end

        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        SilentAimHook = oldNamecall

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if States.SilentAimEnabled and method == "FireServer" then
                if self.Name == "ShootGun" or self.Name == "RemoteFunction"
                   or tostring(self):find("Gun") or tostring(self):find("Shoot") then
                    local murderer = GetMurderer()
                    if murderer and murderer.Character then
                        local head = murderer.Character:FindFirstChild("Head")
                        if head then
                            -- Підміна мети
                            for i, arg in ipairs(args) do
                                if typeof(arg) == "Vector3" then
                                    args[i] = head.Position
                                elseif typeof(arg) == "CFrame" then
                                    args[i] = head.CFrame
                                elseif typeof(arg) == "Instance" and arg:IsA("Player") then
                                    args[i] = murderer
                                end
                            end
                        end
                    end
                end
            end

            return oldNamecall(self, unpack(args))
        end)

        setreadonly(mt, true)
    else
        if SilentAimHook then
            local mt = getrawmetatable(game)
            setreadonly(mt, false)
            mt.__namecall = SilentAimHook
            setreadonly(mt, true)
            SilentAimHook = nil
        end
    end
end

-- ============================================================================
-- AIMBOT
-- ============================================================================
local AimbotConnection = nil

local function ToggleAimbot(enabled)
    if AimbotConnection then AimbotConnection:Disconnect(); AimbotConnection = nil end

    if enabled then
        AimbotConnection = RunService.RenderStepped:Connect(function()
            if not States.AimBotEnabled then return end
            if not UserInputService:IsKeyDown(States.AimBotKey) then return end

            local target = nil
            local murderer = GetMurderer()

            if murderer and murderer.Character then
                target = murderer
            else
                target = GetClosestPlayerToMouse(States.FOVRadius)
            end

            if target and target.Character then
                local head = target.Character:FindFirstChild("Head")
                if head then
                    local targetPos = head.Position
                    if States.PredictionEnabled then
                        local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            local velocity = rootPart.AssemblyLinearVelocity or rootPart.Velocity
                            local ping = game:GetService("Stats"):FindFirstChild("PerformanceStats")
                            local latency = 0.05
                            pcall(function()
                                latency = LocalPlayer:GetNetworkPing()
                            end)
                            targetPos = head.Position + velocity * latency
                        end
                    end
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                end
            end
        end)
    end
end

-- ============================================================================
-- KILL AURA
-- ============================================================================
local KillAuraConn = nil

local function ToggleKillAura(enabled)
    if KillAuraConn then KillAuraConn:Disconnect(); KillAuraConn = nil end

    if enabled then
        KillAuraConn = RunService.Heartbeat:Connect(function()
            if not States.KillAuraEnabled then return end

            local myChar = LocalPlayer.Character
            if not myChar then return end
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            -- Перевірити чи маємо ніж
            local hasKnife = false
            local knife = nil
            for _, tool in pairs(myChar:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == "Knife" then
                    hasKnife = true
                    knife = tool
                    break
                end
            end

            if not hasKnife then return end

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChild("Humanoid")

                    if theirRoot and humanoid and humanoid.Health > 0 then
                        local dist = GetDistance(myRoot.Position, theirRoot.Position)

                        if dist <= States.KillAuraRadius then
                            -- Спроба вбити через Remote
                            pcall(function()
                                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                                if remotes then
                                    for _, remote in pairs(remotes:GetDescendants()) do
                                        if remote:IsA("RemoteEvent") and
                                            (remote.Name:lower():find("kill") or
                                             remote.Name:lower():find("knife") or
                                             remote.Name:lower():find("stab")) then
                                            remote:FireServer(player)
                                        end
                                    end
                                end
                            end)

                            -- Альтернативний метод
                            pcall(function()
                                if knife then
                                    knife:Activate()
                                end
                            end)

                            if States.KillAuraMode == "Legit" then
                                task.wait(0.3)
                                break -- по одному
                            end
                        end
                    end
                end
            end
        end)
    end
end

-- ============================================================================
-- TELEPORT KILL AURA
-- ============================================================================
local TeleportKillConn = nil

local function ToggleTeleportKillAura(enabled)
    if TeleportKillConn then TeleportKillConn:Disconnect(); TeleportKillConn = nil end

    if enabled then
        TeleportKillConn = RunService.Heartbeat:Connect(function()
            if not States.TeleportKillAuraEnabled then return end

            local myChar = LocalPlayer.Character
            if not myChar then return end
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local hasKnife = false
            for _, tool in pairs(myChar:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == "Knife" then
                    hasKnife = true
                    break
                end
            end
            if not hasKnife then return end

            local originalCFrame = myRoot.CFrame

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChild("Humanoid")

                    if theirRoot and humanoid and humanoid.Health > 0 then
                        -- Телепорт за спину
                        myRoot.CFrame = theirRoot.CFrame * CFrame.new(0, 0, -3)
                        task.wait()

                        -- Активація ножа
                        pcall(function()
                            for _, tool in pairs(myChar:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name == "Knife" then
                                    tool:Activate()
                                end
                            end
                        end)

                        task.wait(0.05)
                    end
                end
            end

            -- Повернення
            myRoot.CFrame = originalCFrame
            task.wait(0.5)
        end)
    end
end

-- ============================================================================
-- AUTO-SHOOT MURDERER
-- ============================================================================
local AutoShootConn = nil

local function ToggleAutoShoot(enabled)
    if AutoShootConn then AutoShootConn:Disconnect(); AutoShootConn = nil end

    if enabled then
        AutoShootConn = RunService.Heartbeat:Connect(function()
            if not States.AutoShootMurdererEnabled then return end

            local myChar = LocalPlayer.Character
            if not myChar then return end

            local hasGun = false
            local gun = nil
            for _, tool in pairs(myChar:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == "Gun" then
                    hasGun = true
                    gun = tool
                    break
                end
            end
            if not hasGun then return end

            local murderer = GetMurderer()
            if not murderer or not murderer.Character then return end

            local head = murderer.Character:FindFirstChild("Head")
            if not head then return end

            -- Перевірити чи вбивця на екрані
            local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
            if onScreen then
                -- Навести та вистрілити
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                task.wait()
                pcall(function()
                    gun:Activate()
                end)
            end
        end)
    end
end

-- ============================================================================
-- MASS MURDER
-- ============================================================================
local function ExecuteMassMurder()
    if not States.MassMurderEnabled then return end

    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local hasKnife = false
    for _, tool in pairs(myChar:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == "Knife" then
            hasKnife = true
            break
        end
    end
    if not hasKnife then
        Notify("Mass Murder", "У тебе немає ножа!")
        return
    end

    local originalCFrame = myRoot.CFrame

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")

            if theirRoot and humanoid and humanoid.Health > 0 then
                myRoot.CFrame = theirRoot.CFrame * CFrame.new(0, 0, -2)
                task.wait()
                pcall(function()
                    for _, tool in pairs(myChar:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name == "Knife" then
                            tool:Activate()
                        end
                    end
                end)
                task.wait(0.05)
            end
        end
    end

    myRoot.CFrame = originalCFrame
    Notify("Mass Murder", "Виконано!")
end

-- ============================================================================
-- MOVEMENT SYSTEMS
-- ============================================================================

-- Noclip
local function ToggleNoclip(enabled)
    if NoclipConnection then NoclipConnection:Disconnect(); NoclipConnection = nil end

    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if not States.NoclipEnabled then return end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

-- Fly
local function ToggleFly(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end

    if enabled then
        if FlyBody then FlyBody:Destroy() end
        if FlyGyro then FlyGyro:Destroy() end

        FlyBody = Instance.new("BodyVelocity")
        FlyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyBody.Velocity = Vector3.new(0, 0, 0)
        FlyBody.Parent = rootPart

        FlyGyro = Instance.new("BodyGyro")
        FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        FlyGyro.CFrame = rootPart.CFrame
        FlyGyro.Parent = rootPart

        humanoid.PlatformStand = true

        RunService:BindToRenderStep("MM2_Fly", 1, function()
            if not States.FlyEnabled then return end

            local velocity = Vector3.new(0, 0, 0)
            local speed = States.FlySpeed

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + Camera.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - Camera.CFrame.LookVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - Camera.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + Camera.CFrame.RightVector * speed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, speed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, speed, 0)
            end

            if FlyBody then FlyBody.Velocity = velocity end
            if FlyGyro then FlyGyro.CFrame = Camera.CFrame end
        end)
    else
        RunService:UnbindFromRenderStep("MM2_Fly")
        if FlyBody then FlyBody:Destroy(); FlyBody = nil end
        if FlyGyro then FlyGyro:Destroy(); FlyGyro = nil end
        if humanoid then humanoid.PlatformStand = false end
    end
end

-- Infinite Jump
local InfJumpConn = nil

local function ToggleInfiniteJump(enabled)
    if InfJumpConn then InfJumpConn:Disconnect(); InfJumpConn = nil end

    if enabled then
        InfJumpConn = UserInputService.JumpRequest:Connect(function()
            if States.InfiniteJumpEnabled then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    end
end

-- WalkSpeed
local WalkSpeedConn = nil

local function ToggleWalkSpeed(enabled)
    if WalkSpeedConn then WalkSpeedConn:Disconnect(); WalkSpeedConn = nil end

    if enabled then
        WalkSpeedConn = RunService.Heartbeat:Connect(function()
            if States.WalkSpeedEnabled then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = States.WalkSpeed
                    end
                end
            end
        end)
    end
end

-- JumpPower
local JumpPowerConn = nil

local function ToggleJumpPower(enabled)
    if JumpPowerConn then JumpPowerConn:Disconnect(); JumpPowerConn = nil end

    if enabled then
        JumpPowerConn = RunService.Heartbeat:Connect(function()
            if States.JumpPowerEnabled then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.UseJumpPower = true
                        humanoid.JumpPower = States.JumpPower
                    end
                end
            end
        end)
    end
end

-- Click Teleport
local ClickTPConn = nil

local function ToggleClickTP(enabled)
    if ClickTPConn then ClickTPConn:Disconnect(); ClickTPConn = nil end

    if enabled then
        ClickTPConn = UserInputService.InputBegan:Connect(function(input)
            if not States.ClickTPEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and
               UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then

                local mouse = LocalPlayer:GetMouse()
                if mouse.Hit then
                    local char = LocalPlayer.Character
                    if char then
                        local rootPart = char:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            rootPart.CFrame = mouse.Hit + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end
        end)
    end
end

-- Teleport Functions
local function TeleportToGun()
    local gun = GetDroppedGun()
    if gun then
        local part = nil
        if gun:IsA("BasePart") then
            part = gun
        elseif gun:IsA("Model") then
            part = gun.PrimaryPart or gun:FindFirstChildWhichIsA("BasePart")
        elseif gun:IsA("Tool") then
            part = gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart")
        end

        if part then
            local char = LocalPlayer.Character
            if char then
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                    Notify("Teleport", "Телепортовано до пістолета!")
                end
            end
        end
    else
        Notify("Teleport", "Пістолет не знайдено!")
    end
end

local function TeleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character then
        local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -5)
                Notify("Teleport", "Телепортовано до " .. targetPlayer.Name)
            end
        end
    end
end

local function TeleportToLobby()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- MM2 lobby spawn
        local lobby = Workspace:FindFirstChild("Lobby") or Workspace:FindFirstChild("LobbySpawn")
        if lobby then
            local spawnPart = lobby:IsA("BasePart") and lobby or lobby:FindFirstChildWhichIsA("BasePart")
            if spawnPart then
                char.HumanoidRootPart.CFrame = CFrame.new(spawnPart.Position + Vector3.new(0, 5, 0))
                Notify("Teleport", "Телепортовано в лобі!")
                return
            end
        end
        -- Fallback
        char.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
        Notify("Teleport", "Телепортовано (fallback)")
    end
end

local function TeleportOutOfBounds()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(9999, 500, 9999)
        Notify("Teleport", "Телепортовано за межі карти!")
    end
end

-- ============================================================================
-- AUTO FARM COINS
-- ============================================================================
local function ToggleAutoFarmCoins(enabled)
    if AutoFarmConnection then AutoFarmConnection:Disconnect(); AutoFarmConnection = nil end

    if enabled then
        task.spawn(function()
            while States.AutoFarmCoinsEnabled do
                pcall(function()
                    local coins = GetCoins()
                    local char = LocalPlayer.Character
                    if not char then return end
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return end

                    for _, coin in pairs(coins) do
                        if not States.AutoFarmCoinsEnabled then break end

                        local coinPart = nil
                        if coin:IsA("BasePart") then
                            coinPart = coin
                        elseif coin:IsA("Model") then
                            coinPart = coin.PrimaryPart or coin:FindFirstChildWhichIsA("BasePart")
                        end

                        if coinPart and coinPart.Parent then
                            if States.AutoFarmMode == "Tween" then
                                -- Плавне переміщення
                                local tween = TweenService:Create(rootPart,
                                    TweenInfo.new(
                                        GetDistance(rootPart.Position, coinPart.Position) / 60,
                                        Enum.EasingStyle.Linear
                                    ),
                                    {CFrame = CFrame.new(coinPart.Position)}
                                )
                                tween:Play()
                                tween.Completed:Wait()
                            else
                                -- Instant teleport
                                rootPart.CFrame = CFrame.new(coinPart.Position + Vector3.new(0, 1, 0))
                            end
                            task.wait(0.1)
                        end
                    end
                end)

                task.wait(1)
            end
        end)
    end
end

-- ============================================================================
-- AUTO EVADE MURDERER
-- ============================================================================
local AutoEvadeConn = nil

local function ToggleAutoEvade(enabled)
    if AutoEvadeConn then AutoEvadeConn:Disconnect(); AutoEvadeConn = nil end

    if enabled then
        AutoEvadeConn = RunService.Heartbeat:Connect(function()
            if not States.AutoEvadeEnabled then return end

            local myChar = LocalPlayer.Character
            if not myChar then return end
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            local myHumanoid = myChar:FindFirstChild("Humanoid")
            if not myRoot or not myHumanoid then return end

            local murderer = GetMurderer()
            if not murderer or not murderer.Character then return end
            local murdererRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
            if not murdererRoot then return end

            local dist = GetDistance(myRoot.Position, murdererRoot.Position)

            if dist < States.AutoEvadeDistance then
                -- Тікати в протилежному напрямку
                local direction = (myRoot.Position - murdererRoot.Position).Unit
                myHumanoid:Move(Vector3.new(direction.X, 0, direction.Z))
            end
        end)
    end
end

-- ============================================================================
-- LOOP BRING GUN
-- ============================================================================
local LoopBringGunConn = nil

local function ToggleLoopBringGun(enabled)
    if LoopBringGunConn then LoopBringGunConn:Disconnect(); LoopBringGunConn = nil end

    if enabled then
        LoopBringGunConn = RunService.Heartbeat:Connect(function()
            if not States.LoopBringGunEnabled then return end

            local gun = GetDroppedGun()
            if gun then
                local part = nil
                if gun:IsA("Tool") then
                    part = gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart")
                elseif gun:IsA("BasePart") then
                    part = gun
                elseif gun:IsA("Model") then
                    part = gun.PrimaryPart or gun:FindFirstChildWhichIsA("BasePart")
                end

                if part then
                    local char = LocalPlayer.Character
                    if char then
                        local rootPart = char:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            part.CFrame = rootPart.CFrame * CFrame.new(0, -3, -2)
                        end
                    end
                end
            end
        end)
    end
end

-- ============================================================================
-- INVISIBILITY
-- ============================================================================
local function ToggleInvisibility(enabled)
    local char = LocalPlayer.Character
    if not char then return end

    if enabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
        local face = char:FindFirstChild("Head") and char.Head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 0
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 0
            end
        end
    end
end

-- ============================================================================
-- ROLE REVEAL
-- ============================================================================
local RoleRevealConn = nil
local LastRoundRevealed = false

local function ToggleRoleReveal(enabled)
    if RoleRevealConn then RoleRevealConn:Disconnect(); RoleRevealConn = nil end

    if enabled then
        RoleRevealConn = RunService.Heartbeat:Connect(function()
            if not States.RoleRevealEnabled then return end

            local murderer = GetMurderer()
            local sheriff = GetSheriff()

            if murderer and not LastRoundRevealed then
                LastRoundRevealed = true
                local murdererName = murderer and murderer.Name or "Unknown"
                local sheriffName = sheriff and sheriff.Name or "Unknown"

                Notify("🔪 Role Reveal",
                    "Murderer: " .. murdererName .. " | Sheriff: " .. sheriffName, 8)
            end

            -- Скидання при новому раунді (коли немає ролей)
            if not murderer and not sheriff then
                LastRoundRevealed = false
            end
        end)
    end
end

-- ============================================================================
-- ANTI-AFK
-- ============================================================================
local function ToggleAntiAFK(enabled)
    if enabled then
        -- Видалити стандартний AFK disconnect
        local VirtualUser = game:GetService("VirtualUser")

        pcall(function()
            LocalPlayer.Idled:Connect(function()
                if States.AntiAFKEnabled then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        end)

        -- Також відключити вбудований idle kick
        pcall(function()
            for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
                connection:Disable()
            end
        end)

        Notify("Anti-AFK", "Увімкнено! Тепер тебе не кікнуть за AFK")
    end
end

-- ============================================================================
-- REMOVE MAP BARRIERS
-- ============================================================================
local function RemoveBarriers()
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency >= 0.9 and obj.CanCollide then
            if not obj.Parent:FindFirstChild("Humanoid") then
                obj.CanCollide = false
                obj:Destroy()
                count = count + 1
            end
        end
    end

    -- Також видалити невидимі стіни
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Barrier" or obj.Name == "InvisibleWall" or
           obj.Name == "InvisWall" or obj.Name == "Wall" then
            if obj:IsA("BasePart") then
                obj:Destroy()
                count = count + 1
            end
        end
    end

    Notify("Barriers", "Видалено " .. count .. " бар'єрів!")
end

-- ============================================================================
-- ANTI-CRASH / FPS OPTIMIZER
-- ============================================================================
local function OptimizeFPS()
    local removed = 0

    -- Видалити зайві ефекти
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
           or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj:Destroy()
            removed = removed + 1
        end
    end

    -- Зменшити якість текстур
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0.5
        end
    end

    -- Встановити налаштування графіки
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    pcall(function()
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Technology = Enum.Technology.Compatibility
    end)

    Notify("FPS Optimizer", "Оптимізовано! Видалено " .. removed .. " ефектів")
end

-- ============================================================================
-- CHAT SPAMMER
-- ============================================================================
local ChatSpamConn = nil

local function ToggleChatSpam(enabled)
    if ChatSpamConn then
        pcall(function() ChatSpamConn:Disconnect() end)
        ChatSpamConn = nil
    end

    if enabled then
        task.spawn(function()
            while States.ChatSpamEnabled do
                pcall(function()
                    -- Метод через TextChatService (нова система)
                    local textChatService = game:GetService("TextChatService")
                    local channels = textChatService:FindFirstChild("TextChannels")
                    if channels then
                        local rbxGeneral = channels:FindFirstChild("RBXGeneral")
                        if rbxGeneral then
                            rbxGeneral:SendAsync(States.ChatSpamText)
                        end
                    end
                end)

                pcall(function()
                    -- Метод через старий чат
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                        States.ChatSpamText, "All"
                    )
                end)

                task.wait(States.ChatSpamDelay)
            end
        end)
    end
end

-- ============================================================================
-- AUTO-LEAVE ON ADMIN JOIN
-- ============================================================================
local AdminCheckConn = nil
local KnownAdmins = {
    -- MM2 відомі адміни/модератори (ID приклади)
    -- Nikilis (творець MM2)
}

local function ToggleAutoLeaveAdmin(enabled)
    if AdminCheckConn then AdminCheckConn:Disconnect(); AdminCheckConn = nil end

    if enabled then
        AdminCheckConn = Players.PlayerAdded:Connect(function(player)
            if not States.AutoLeaveAdminEnabled then return end

            -- Перевірка на адмінський значок
            local isAdmin = false

            pcall(function()
                -- Перевірка через значки
                if player:IsInGroup(1200769) then -- Roblox Admin group
                    isAdmin = true
                end
                -- MM2 Moderator group (приклад ID)
                if player:IsInGroup(3878494) then
                    isAdmin = true
                end
            end)

            -- Перевірка чи це Nikilis або інші розробники
            local devIds = {2930208, 57891798} -- Nikilis, інші
            for _, id in pairs(devIds) do
                if player.UserId == id then
                    isAdmin = true
                    break
                end
            end

            if isAdmin then
                Notify("⚠️ ADMIN DETECTED",
                    "Адмін " .. player.Name .. " зайшов! Відключення...", 3)
                task.wait(1)
                LocalPlayer:Kick("Admin detected - Auto leave activated")
            end
        end)
    end
end

-- ============================================================================
-- STREAMER MODE
-- ============================================================================
local function ToggleStreamerMode(enabled)
    if enabled then
        pcall(function()
            -- Сховати нікнейм в leaderboard
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("TextLabel") and gui.Text == LocalPlayer.Name then
                        gui.Text = "LocalPlayer"
                    end
                end
            end
        end)

        -- Змінити DisplayName
        pcall(function()
            LocalPlayer.DisplayName = "LocalPlayer"
        end)

        Notify("Streamer Mode", "Нікнейм приховано!")
    else
        pcall(function()
            -- Відновити DisplayName неможливо клієнтсайд, але можна
        end)
    end
end

-- ============================================================================
-- SPECTATE PLAYER
-- ============================================================================
local SpectateConn = nil

local function SpectatePlayer(player)
    if SpectateConn then SpectateConn:Disconnect(); SpectateConn = nil end

    if not player or not player.Character then
        Camera.CameraSubject = LocalPlayer.Character and
            LocalPlayer.Character:FindFirstChild("Humanoid") or nil
        States.SpectateTarget = nil
        return
    end

    States.SpectateTarget = player

    SpectateConn = RunService.RenderStepped:Connect(function()
        if not States.SpectateEnabled or not States.SpectateTarget then
            Camera.CameraSubject = LocalPlayer.Character and
                LocalPlayer.Character:FindFirstChild("Humanoid") or nil
            if SpectateConn then SpectateConn:Disconnect(); SpectateConn = nil end
            return
        end

        local target = States.SpectateTarget
        if target and target.Character then
            local humanoid = target.Character:FindFirstChild("Humanoid")
            if humanoid then
                Camera.CameraSubject = humanoid
            end
        end
    end)
end

-- ============================================================================
-- EMOTE SPAM
-- ============================================================================
local EmoteSpamConn = nil

local function ToggleEmoteSpam(enabled)
    if EmoteSpamConn then
        pcall(function() task.cancel(EmoteSpamConn) end)
        EmoteSpamConn = nil
    end

    if enabled then
        EmoteSpamConn = task.spawn(function()
            while States.EmotionSpamEnabled do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local humanoid = char:FindFirstChild("Humanoid")
                        if humanoid then
                            local emotes = humanoid:GetPlayingAnimationTracks()
                            -- Play та stop emotes
                            local animId = "rbxassetid://507771019" -- Wave
                            local anim = Instance.new("Animation")
                            anim.AnimationId = animId

                            local track = humanoid:LoadAnimation(anim)
                            track:Play()
                            task.wait(0.1)
                            track:Stop()
                        end
                    end
                end)
                task.wait(0.15)
            end
        end)
    end
end

-- ============================================================================
-- SERVER HOP
-- ============================================================================
local function ServerHop()
    pcall(function()
        local placeId = game.PlaceId
        local servers = HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")
        )

        for _, server in pairs(servers.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(placeId, server.id)
                break
            end
        end
    end)
end

-- ============================================================================
-- REJOIN SERVER
-- ============================================================================
local function RejoinServer()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end)
end

-- ============================================================================
-- GOD MODE (CLIENT SIDE)
-- ============================================================================
local GodModeConn = nil

local function ToggleGodMode(enabled)
    if GodModeConn then GodModeConn:Disconnect(); GodModeConn = nil end

    if enabled then
        GodModeConn = RunService.Heartbeat:Connect(function()
            if not States.GodModeEnabled then return end
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end)
    end
end

-- ============================================================================
-- THROW BOT (AUTO THROW)
-- ============================================================================
local ThrowBotConn = nil

local function ToggleThrowBot(enabled)
    if ThrowBotConn then ThrowBotConn:Disconnect(); ThrowBotConn = nil end

    if enabled then
        ThrowBotConn = RunService.Heartbeat:Connect(function()
            if not States.ThrowBotEnabled then return end

            local myChar = LocalPlayer.Character
            if not myChar then return end

            local hasKnife = false
            for _, tool in pairs(myChar:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == "Knife" then
                    hasKnife = true
                    break
                end
            end
            if not hasKnife then return end

            -- Знайти найближчого ворога
            local closest = nil
            local closestDist = 100
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local theirRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if theirRoot and humanoid and humanoid.Health > 0 then
                        local dist = GetDistance(myRoot.Position, theirRoot.Position)
                        if dist < closestDist then
                            closestDist = dist
                            closest = player
                        end
                    end
                end
            end

            if closest and closest.Character then
                local head = closest.Character:FindFirstChild("Head")
                if head then
                    -- Повернути камеру до цілі та кинути ніж
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)

                    pcall(function()
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        if remotes then
                            for _, remote in pairs(remotes:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and
                                   (remote.Name:lower():find("throw") or
                                    remote.Name:lower():find("knife")) then
                                    remote:FireServer(head.Position)
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
end

-- ============================================================================
-- FAKE DEATH
-- ============================================================================
local function ToggleFakeDeath(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end

    if enabled then
        -- Ragdoll effect
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("Motor6D") then
                    local socket = Instance.new("BallSocketConstraint")
                    local att0 = Instance.new("Attachment")
                    local att1 = Instance.new("Attachment")
                    att0.Parent = part.Part0
                    att1.Parent = part.Part1
                    socket.Attachment0 = att0
                    socket.Attachment1 = att1
                    socket.Parent = part.Part0
                    part.Enabled = false
                end
            end
        end)
    else
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("Motor6D") then
                    part.Enabled = true
                end
                if part:IsA("BallSocketConstraint") then
                    part:Destroy()
                end
            end
        end)
    end
end

-- ============================================================================
-- СТВОРЕННЯ ВІКНА LINORIA UI
-- ============================================================================

local Window = Library:CreateWindow({
    Title = "MM2 Master Exploit",
    Center = true,
    AutoShow = true,
    TabPadding = 2,
    MenuFadeTime = 0.2
})

-- ============================================================================
-- TAB 1: VISUALS & ESP
-- ============================================================================
local VisualsTab = Window:AddTab("👁️ Visuals & ESP")

-- GROUP: Player ESP
local PlayerESPGroup = VisualsTab:AddLeftGroupbox("Player ESP")

PlayerESPGroup:AddToggle("PlayerESPToggle", {
    Text = "Player ESP",
    Default = false,
    Tooltip = "Показує гравців крізь стіни"
}):OnChanged(function()
    States.PlayerESPEnabled = Toggles.PlayerESPToggle.Value
    if States.PlayerESPEnabled then
        ESPModule.InitializeAllPlayerESP()
    else
        ESPModule.RemoveAllPlayerESP()
    end
end)

PlayerESPGroup:AddDropdown("ESPTypeDropdown", {
    Values = {"Box", "3DBox", "Skeleton", "Tracers", "Chams"},
    Default = 1,
    Multi = false,
    Text = "ESP Type"
}):OnChanged(function()
    States.ESPType = Options.ESPTypeDropdown.Value
end)

PlayerESPGroup:AddToggle("RoleESPToggle", {
    Text = "Role ESP (Color Coded)",
    Default = false,
    Tooltip = "Фарбує ESP за ролями"
}):OnChanged(function()
    States.RoleESPEnabled = Toggles.RoleESPToggle.Value
end)

PlayerESPGroup:AddToggle("DistanceESPToggle", {
    Text = "Distance ESP",
    Default = false,
    Tooltip = "Показує відстань до гравців"
}):OnChanged(function()
    States.DistanceESPEnabled = Toggles.DistanceESPToggle.Value
end)

PlayerESPGroup:AddToggle("WeaponESPToggle", {
    Text = "Weapon Equipped ESP",
    Default = false,
    Tooltip = "Показує зброю над головами"
}):OnChanged(function()
    States.WeaponESPEnabled = Toggles.WeaponESPToggle.Value
end)

-- GROUP: Item ESP
local ItemESPGroup = VisualsTab:AddLeftGroupbox("Item ESP")

ItemESPGroup:AddToggle("GunDropESPToggle", {
    Text = "Gun Drop ESP & Tracer",
    Default = false,
    Tooltip = "Показує впавший пістолет"
}):OnChanged(function()
    States.GunDropESPEnabled = Toggles.GunDropESPToggle.Value
end)

ItemESPGroup:AddToggle("CoinESPToggle", {
    Text = "Coin ESP [Value & Type]",
    Default = false,
    Tooltip = "Підсвічує монети на карті"
}):OnChanged(function()
    States.CoinESPEnabled = Toggles.CoinESPToggle.Value
    ESPModule.UpdateCoinESP()
end)

ItemESPGroup:AddToggle("TrapESPToggle", {
    Text = "Trap ESP & Warning",
    Default = false,
    Tooltip = "Підсвічує капкани та пастки"
}):OnChanged(function()
    States.TrapESPEnabled = Toggles.TrapESPToggle.Value
    ESPModule.UpdateTrapESP()
end)

-- GROUP: Visual Effects
local VisualEffectsGroup = VisualsTab:AddRightGroupbox("Visual Effects")

VisualEffectsGroup:AddToggle("FullBrightToggle", {
    Text = "Map Full Bright",
    Default = false,
    Tooltip = "Прибирає темряву"
}):OnChanged(function()
    States.FullBrightEnabled = Toggles.FullBrightToggle.Value
    ToggleFullBright(States.FullBrightEnabled)
end)

VisualEffectsGroup:AddToggle("XRayToggle", {
    Text = "X-Ray Mode",
    Default = false,
    Tooltip = "Стіни стають прозорими"
}):OnChanged(function()
    States.XRayEnabled = Toggles.XRayToggle.Value
    ToggleXRay(States.XRayEnabled)
end)

VisualEffectsGroup:AddToggle("RadarToggle", {
    Text = "Radar Hack",
    Default = false,
    Tooltip = "Міні-карта з позиціями гравців"
}):OnChanged(function()
    States.RadarEnabled = Toggles.RadarToggle.Value
    UpdateRadar()
end)

-- GROUP: Spectate
local SpectateGroup = VisualsTab:AddRightGroupbox("Spectate")

SpectateGroup:AddToggle("SpectateToggle", {
    Text = "Spectate Mode",
    Default = false,
    Tooltip = "Режим спостереження"
}):OnChanged(function()
    States.SpectateEnabled = Toggles.SpectateToggle.Value
    if not States.SpectateEnabled then
        SpectatePlayer(nil)
    end
end)

-- Оновлювана dropdown для spectate
local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerNames, p.Name)
    end
end

SpectateGroup:AddDropdown("SpectateTarget", {
    Values = playerNames,
    Default = 1,
    Multi = false,
    Text = "Target Player"
}):OnChanged(function()
    local targetName = Options.SpectateTarget.Value
    local targetPlayer = Players:FindFirstChild(targetName)
    if targetPlayer and States.SpectateEnabled then
        SpectatePlayer(targetPlayer)
    end
end)

-- GROUP: Role Colors
local ColorGroup = VisualsTab:AddRightGroupbox("Role Colors")

ColorGroup:AddLabel("Murderer Color"):AddColorPicker("MurdererColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Murderer Color"
}):OnChanged(function()
    States.MurdererColor = Options.MurdererColor.Value
end)

ColorGroup:AddLabel("Sheriff Color"):AddColorPicker("SheriffColor", {
    Default = Color3.fromRGB(0, 100, 255),
    Title = "Sheriff Color"
}):OnChanged(function()
    States.SheriffColor = Options.SheriffColor.Value
end)

ColorGroup:AddLabel("Innocent Color"):AddColorPicker("InnocentColor", {
    Default = Color3.fromRGB(0, 255, 0),
    Title = "Innocent Color"
}):OnChanged(function()
    States.InnocentColor = Options.InnocentColor.Value
end)

-- ============================================================================
-- TAB 2: COMBAT & AIMBOT
-- ============================================================================
local CombatTab = Window:AddTab("⚔️ Combat & Aim")

-- GROUP: Aimbot
local AimbotGroup = CombatTab:AddLeftGroupbox("Aimbot")

AimbotGroup:AddToggle("SilentAimToggle", {
    Text = "Silent Aim (Perfect Hit)",
    Default = false,
    Tooltip = "Кулі автоматично летять у вбивцю"
}):OnChanged(function()
    States.SilentAimEnabled = Toggles.SilentAimToggle.Value
    ToggleSilentAim(States.SilentAimEnabled)
end)

AimbotGroup:AddToggle("AimBotToggle", {
    Text = "Gun AimBot / Lock-On",
    Default = false,
    Tooltip = "Приціл приліпає до голови ворога"
}):OnChanged(function()
    States.AimBotEnabled = Toggles.AimBotToggle.Value
    ToggleAimbot(States.AimBotEnabled)
end)

AimbotGroup:AddKeyPicker("AimBotKeyPicker", {
    Default = Enum.KeyCode.E,
    SyncToggleState = false,
    Mode = "Hold",
    Text = "Aimbot Key"
}):OnChanged(function()
    States.AimBotKey = Options.AimBotKeyPicker.Value
end)

AimbotGroup:AddSlider("FOVSlider", {
    Text = "FOV Radius",
    Default = 200,
    Min = 50,
    Max = 600,
    Rounding = 0,
    Compact = false
}):OnChanged(function()
    States.FOVRadius = Options.FOVSlider.Value
    if FOVCircle then FOVCircle.Radius = States.FOVRadius end
end)

AimbotGroup:AddToggle("FOVCircleToggle", {
    Text = "Show FOV Circle",
    Default = false
}):OnChanged(function()
    States.FOVCircleVisible = Toggles.FOVCircleToggle.Value
    if FOVCircle then FOVCircle.Visible = States.FOVCircleVisible end
end)

AimbotGroup:AddToggle("PredictionToggle", {
    Text = "Prediction Aim",
    Default = false,
    Tooltip = "Враховує пінг та швидкість руху ворога"
}):OnChanged(function()
    States.PredictionEnabled = Toggles.PredictionToggle.Value
end)

AimbotGroup:AddToggle("AutoShootToggle", {
    Text = "Auto-Shoot Murderer",
    Default = false,
    Tooltip = "Автоматичний постріл при появі вбивці"
}):OnChanged(function()
    States.AutoShootMurdererEnabled = Toggles.AutoShootToggle.Value
    ToggleAutoShoot(States.AutoShootMurdererEnabled)
end)

-- GROUP: Kill Aura
local KillAuraGroup = CombatTab:AddLeftGroupbox("Kill Aura")

KillAuraGroup:AddToggle("KillAuraToggle", {
    Text = "Kill Aura",
    Default = false,
    Tooltip = "Автоматично вбиває гравців навколо"
}):OnChanged(function()
    States.KillAuraEnabled = Toggles.KillAuraToggle.Value
    ToggleKillAura(States.KillAuraEnabled)
end)

KillAuraGroup:AddDropdown("KillAuraModeDropdown", {
    Values = {"Legit", "Rage"},
    Default = 1,
    Text = "Kill Aura Mode"
}):OnChanged(function()
    States.KillAuraMode = Options.KillAuraModeDropdown.Value
end)

KillAuraGroup:AddSlider("KillAuraRadiusSlider", {
    Text = "Kill Aura Radius",
    Default = 12,
    Min = 5,
    Max = 30,
    Rounding = 0
}):OnChanged(function()
    States.KillAuraRadius = Options.KillAuraRadiusSlider.Value
end)

KillAuraGroup:AddToggle("TeleportKillAuraToggle", {
    Text = "Teleport Kill Aura",
    Default = false,
    Tooltip = "Телепортує за спину та вбиває"
}):OnChanged(function()
    States.TeleportKillAuraEnabled = Toggles.TeleportKillAuraToggle.Value
    ToggleTeleportKillAura(States.TeleportKillAuraEnabled)
end)

-- GROUP: Knife
local KnifeGroup = CombatTab:AddRightGroupbox("Knife Exploits")

KnifeGroup:AddToggle("ThrowBotToggle", {
    Text = "Throw Bot (Auto-Throw)",
    Default = false,
    Tooltip = "Автоматичне метання ножа в ціль"
}):OnChanged(function()
    States.ThrowBotEnabled = Toggles.ThrowBotToggle.Value
    ToggleThrowBot(States.ThrowBotEnabled)
end)

KnifeGroup:AddToggle("InstantKnifeToggle", {
    Text = "Instant Knife Return",
    Default = false,
    Tooltip = "Ніж миттєво повертається"
}):OnChanged(function()
    States.InstantKnifeReturnEnabled = Toggles.InstantKnifeToggle.Value
end)

KnifeGroup:AddToggle("RangeExtenderToggle", {
    Text = "Range Extender",
    Default = false,
    Tooltip = "Збільшення дальності ураження"
}):OnChanged(function()
    States.RangeExtenderEnabled = Toggles.RangeExtenderToggle.Value
end)

KnifeGroup:AddSlider("RangeExtenderSlider", {
    Text = "Range Multiplier",
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 1
}):OnChanged(function()
    States.RangeExtenderValue = Options.RangeExtenderSlider.Value
end)

-- GROUP: Mass Kill
local MassKillGroup = CombatTab:AddRightGroupbox("Mass Kill")

MassKillGroup:AddButton({
    Text = "Execute Mass Murder",
    Func = function()
        States.MassMurderEnabled = true
        ExecuteMassMurder()
        States.MassMurderEnabled = false
    end,
    DoubleClick = true,
    Tooltip = "Подвійний клік для активації"
})

-- ============================================================================
-- TAB 3: MOVEMENT & TELEPORT
-- ============================================================================
local MovementTab = Window:AddTab("🏃 Movement")

-- GROUP: Speed & Jump
local SpeedGroup = MovementTab:AddLeftGroupbox("Speed & Jump")

SpeedGroup:AddToggle("WalkSpeedToggle", {
    Text = "WalkSpeed Changer",
    Default = false
}):OnChanged(function()
    States.WalkSpeedEnabled = Toggles.WalkSpeedToggle.Value
    ToggleWalkSpeed(States.WalkSpeedEnabled)
end)

SpeedGroup:AddSlider("WalkSpeedSlider", {
    Text = "Walk Speed",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Compact = false
}):OnChanged(function()
    States.WalkSpeed = Options.WalkSpeedSlider.Value
end)

SpeedGroup:AddToggle("JumpPowerToggle", {
    Text = "JumpPower Changer",
    Default = false
}):OnChanged(function()
    States.JumpPowerEnabled = Toggles.JumpPowerToggle.Value
    ToggleJumpPower(States.JumpPowerEnabled)
end)

SpeedGroup:AddSlider("JumpPowerSlider", {
    Text = "Jump Power",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Compact = false
}):OnChanged(function()
    States.JumpPower = Options.JumpPowerSlider.Value
end)

SpeedGroup:AddToggle("InfiniteJumpToggle", {
    Text = "Infinite Jump (Air Walk)",
    Default = false,
    Tooltip = "Нескінченні стрибки в повітрі"
}):OnChanged(function()
    States.InfiniteJumpEnabled = Toggles.InfiniteJumpToggle.Value
    ToggleInfiniteJump(States.InfiniteJumpEnabled)
end)

-- GROUP: Flying & Noclip
local FlyGroup = MovementTab:AddLeftGroupbox("Flying & Noclip")

FlyGroup:AddToggle("NoclipToggle", {
    Text = "Noclip (Walk Through Walls)",
    Default = false
}):OnChanged(function()
    States.NoclipEnabled = Toggles.NoclipToggle.Value
    ToggleNoclip(States.NoclipEnabled)
end)

FlyGroup:AddToggle("FlyToggle", {
    Text = "Fly Hack",
    Default = false,
    Tooltip = "WASD для руху, Space/Shift вгору/вниз"
}):OnChanged(function()
    States.FlyEnabled = Toggles.FlyToggle.Value
    ToggleFly(States.FlyEnabled)
end)

FlyGroup:AddSlider("FlySpeedSlider", {
    Text = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Rounding = 0
}):OnChanged(function()
    States.FlySpeed = Options.FlySpeedSlider.Value
end)

FlyGroup:AddToggle("ClickTPToggle", {
    Text = "Click Teleport (Ctrl + Click)",
    Default = false
}):OnChanged(function()
    States.ClickTPEnabled = Toggles.ClickTPToggle.Value
    ToggleClickTP(States.ClickTPEnabled)
end)

-- GROUP: Teleports
local TeleportGroup = MovementTab:AddRightGroupbox("Teleports")

TeleportGroup:AddButton({
    Text = "🔫 Teleport to Gun",
    Func = TeleportToGun,
    Tooltip = "Телепорт до впавшого пістолета"
})

TeleportGroup:AddButton({
    Text = "🔪 Teleport to Murderer",
    Func = function()
        local murderer = GetMurderer()
        if murderer then
            TeleportToPlayer(murderer)
        else
            Notify("Teleport", "Вбивця не знайдений!")
        end
    end
})

TeleportGroup:AddButton({
    Text = "👮 Teleport to Sheriff",
    Func = function()
        local sheriff = GetSheriff()
        if sheriff then
            TeleportToPlayer(sheriff)
        else
            Notify("Teleport", "Шериф не знайдений!")
        end
    end
})

TeleportGroup:AddButton({
    Text = "🏠 Teleport to Lobby",
    Func = TeleportToLobby
})

TeleportGroup:AddButton({
    Text = "🌍 Out-of-Bounds Safe Zone",
    Func = TeleportOutOfBounds
})

-- Teleport to specific player
local TPPlayerGroup = MovementTab:AddRightGroupbox("Teleport to Player")

local playerNamesList = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerNamesList, p.Name)
    end
end

TPPlayerGroup:AddDropdown("TPPlayerDropdown", {
    Values = playerNamesList,
    Default = 1,
    Text = "Select Player"
})

TPPlayerGroup:AddButton({
    Text = "Teleport to Selected Player",
    Func = function()
        local targetName = Options.TPPlayerDropdown.Value
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer then
            TeleportToPlayer(targetPlayer)
        end
    end
})

-- ============================================================================
-- TAB 4: FARMING
-- ============================================================================
local FarmTab = Window:AddTab("💰 Farming")

-- GROUP: Coin Farm
local CoinFarmGroup = FarmTab:AddLeftGroupbox("Auto Farm Coins")

CoinFarmGroup:AddToggle("AutoFarmCoinsToggle", {
    Text = "Auto Farm Coins",
    Default = false,
    Tooltip = "Автоматичний збір монет"
}):OnChanged(function()
    States.AutoFarmCoinsEnabled = Toggles.AutoFarmCoinsToggle.Value
    ToggleAutoFarmCoins(States.AutoFarmCoinsEnabled)
end)

CoinFarmGroup:AddDropdown("FarmModeDropdown", {
    Values = {"Tween", "Instant"},
    Default = 1,
    Text = "Farm Mode"
}):OnChanged(function()
    States.AutoFarmMode = Options.FarmModeDropdown.Value
end)

CoinFarmGroup:AddToggle("BagNotifierToggle", {
    Text = "Bag Full Notifier",
    Default = false
}):OnChanged(function()
    States.BagNotifierEnabled = Toggles.BagNotifierToggle.Value
end)

CoinFarmGroup:AddToggle("SmartBagLimitToggle", {
    Text = "Smart Bag Limit Stop",
    Default = false,
    Tooltip = "Автоматично зупиняє збір при повній сумці"
}):OnChanged(function()
    States.SmartBagLimitEnabled = Toggles.SmartBagLimitToggle.Value
end)

-- GROUP: Evasion
local EvasionGroup = FarmTab:AddLeftGroupbox("Auto Evasion")

EvasionGroup:AddToggle("AutoEvadeToggle", {
    Text = "Auto-Evade Murderer",
    Default = false,
    Tooltip = "Автоматично тікає від вбивці"
}):OnChanged(function()
    States.AutoEvadeEnabled = Toggles.AutoEvadeToggle.Value
    ToggleAutoEvade(States.AutoEvadeEnabled)
end)

EvasionGroup:AddSlider("AutoEvadeDistSlider", {
    Text = "Evade Distance",
    Default = 25,
    Min = 10,
    Max = 60,
    Rounding = 0
}):OnChanged(function()
    States.AutoEvadeDistance = Options.AutoEvadeDistSlider.Value
end)

-- GROUP: Server & Crates
local ServerFarmGroup = FarmTab:AddRightGroupbox("Server & Crates")

ServerFarmGroup:AddButton({
    Text = "🔄 Server Hop (Find New Server)",
    Func = ServerHop,
    Tooltip = "Перемикнутися на інший сервер"
})

ServerFarmGroup:AddToggle("AutoOpenCratesToggle", {
    Text = "Auto Open Crates",
    Default = false,
    Tooltip = "Автоматичне відкриття кейсів"
}):OnChanged(function()
    States.AutoOpenCratesEnabled = Toggles.AutoOpenCratesToggle.Value

    if States.AutoOpenCratesEnabled then
        task.spawn(function()
            while States.AutoOpenCratesEnabled do
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        for _, remote in pairs(remotes:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and
                               (remote.Name:lower():find("crate") or
                                remote.Name:lower():find("unbox") or
                                remote.Name:lower():find("open")) then
                                remote:FireServer()
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

-- ============================================================================
-- TAB 5: TROLLING & FUN
-- ============================================================================
local TrollingTab = Window:AddTab("🤡 Trolling & Fun")

-- GROUP: Trolling
local TrollingGroup = TrollingTab:AddLeftGroupbox("Trolling")

TrollingGroup:AddToggle("LoopBringGunToggle", {
    Text = "Loop Bring Gun",
    Default = false,
    Tooltip = "Постійно притягує пістолет"
}):OnChanged(function()
    States.LoopBringGunEnabled = Toggles.LoopBringGunToggle.Value
    ToggleLoopBringGun(States.LoopBringGunEnabled)
end)

TrollingGroup:AddToggle("FakeDeathToggle", {
    Text = "Fake Death / Ragdoll",
    Default = false,
    Tooltip = "Імітація смерті"
}):OnChanged(function()
    States.FakeDeathEnabled = Toggles.FakeDeathToggle.Value
    ToggleFakeDeath(States.FakeDeathEnabled)
end)

TrollingGroup:AddToggle("EmoteSpamToggle", {
    Text = "Emote Spam / Glitch",
    Default = false,
    Tooltip = "Швидкий спам емоціями"
}):OnChanged(function()
    States.EmotionSpamEnabled = Toggles.EmoteSpamToggle.Value
    ToggleEmoteSpam(States.EmotionSpamEnabled)
end)

TrollingGroup:AddToggle("InvisibilityToggle", {
    Text = "Invisibility Glitch",
    Default = false,
    Tooltip = "Стати невидимим"
}):OnChanged(function()
    States.InvisibilityEnabled = Toggles.InvisibilityToggle.Value
    ToggleInvisibility(States.InvisibilityEnabled)
end)

-- GROUP: Chat
local ChatGroup = TrollingTab:AddRightGroupbox("Chat Spam")

ChatGroup:AddToggle("ChatSpamToggle", {
    Text = "Chat Spammer",
    Default = false
}):OnChanged(function()
    States.ChatSpamEnabled = Toggles.ChatSpamToggle.Value
    ToggleChatSpam(States.ChatSpamEnabled)
end)

ChatGroup:AddInput("ChatSpamInput", {
    Default = "MM2 Master Exploit",
    Numeric = false,
    Finished = false,
    Text = "Spam Text",
    Tooltip = "Текст для спаму",
    Placeholder = "Enter text..."
}):OnChanged(function()
    States.ChatSpamText = Options.ChatSpamInput.Value
end)

ChatGroup:AddSlider("ChatSpamDelaySlider", {
    Text = "Spam Delay (sec)",
    Default = 2,
    Min = 0.5,
    Max = 10,
    Rounding = 1
}):OnChanged(function()
    States.ChatSpamDelay = Options.ChatSpamDelaySlider.Value
end)

-- ============================================================================
-- TAB 6: UTILITIES & SECURITY
-- ============================================================================
local UtilsTab = Window:AddTab("⚙️ Utilities")

-- GROUP: Security
local SecurityGroup = UtilsTab:AddLeftGroupbox("Security & Detection")

SecurityGroup:AddToggle("RoleRevealToggle", {
    Text = "Role Reveal (Auto Notify)",
    Default = false,
    Tooltip = "Автоматичне визначення ролей"
}):OnChanged(function()
    States.RoleRevealEnabled = Toggles.RoleRevealToggle.Value
    ToggleRoleReveal(States.RoleRevealEnabled)
end)

SecurityGroup:AddToggle("AntiAFKToggle", {
    Text = "Anti-AFK (Ultra Anti-Kick)",
    Default = false,
    Tooltip = "Захист від кіку за AFK"
}):OnChanged(function()
    States.AntiAFKEnabled = Toggles.AntiAFKToggle.Value
    ToggleAntiAFK(States.AntiAFKEnabled)
end)

SecurityGroup:AddToggle("GodModeToggle", {
    Text = "God Mode (Client)",
    Default = false,
    Tooltip = "Безсмертя (клієнтсайд)"
}):OnChanged(function()
    States.GodModeEnabled = Toggles.GodModeToggle.Value
    ToggleGodMode(States.GodModeEnabled)
end)

SecurityGroup:AddToggle("AutoLeaveAdminToggle", {
    Text = "Auto-Leave on Admin Join",
    Default = false,
    Tooltip = "Автовихід при заході адміна"
}):OnChanged(function()
    States.AutoLeaveAdminEnabled = Toggles.AutoLeaveAdminToggle.Value
    ToggleAutoLeaveAdmin(States.AutoLeaveAdminEnabled)
end)

SecurityGroup:AddToggle("StreamerModeToggle", {
    Text = "Streamer Mode",
    Default = false,
    Tooltip = "Приховує нікнейм"
}):OnChanged(function()
    States.StreamerModeEnabled = Toggles.StreamerModeToggle.Value
    ToggleStreamerMode(States.StreamerModeEnabled)
end)

-- GROUP: Map
local MapGroup = UtilsTab:AddLeftGroupbox("Map Utilities")

MapGroup:AddButton({
    Text = "🧱 Remove Map Barriers",
    Func = RemoveBarriers,
    Tooltip = "Видалити невидимі стіни"
})

MapGroup:AddButton({
    Text = "⚡ FPS Optimizer / Anti-Crash",
    Func = OptimizeFPS,
    Tooltip = "Оптимізувати FPS"
})

-- GROUP: Quick Actions
local QuickGroup = UtilsTab:AddRightGroupbox("Quick Actions")

QuickGroup:AddButton({
    Text = "🔄 Rejoin Server",
    Func = RejoinServer,
    Tooltip = "Перезайти на цей сервер"
})

QuickGroup:AddButton({
    Text = "🌐 Server Hop",
    Func = ServerHop,
    Tooltip = "Знайти новий сервер"
})

QuickGroup:AddToggle("FakeWeaponToggle", {
    Text = "Fake Gun/Knife Visual",
    Default = false,
    Tooltip = "Візуальна зброя (тільки для тебе)"
}):OnChanged(function()
    States.FakeWeaponEnabled = Toggles.FakeWeaponToggle.Value

    if States.FakeWeaponEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                -- Створити фейкову зброю
                local fakeTool = Instance.new("Tool")
                fakeTool.Name = "Godly Knife"
                fakeTool.CanBeDropped = false

                local handle = Instance.new("Part")
                handle.Name = "Handle"
                handle.Size = Vector3.new(1, 0.2, 3)
                handle.BrickColor = BrickColor.new("Really red")
                handle.Material = Enum.Material.Neon
                handle.Parent = fakeTool

                fakeTool.Parent = char
            end
        end)
    else
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local fake = char:FindFirstChild("Godly Knife")
                if fake then fake:Destroy() end
            end
        end)
    end
end)

-- GROUP: Server Crash (Disclaimer needed)
local DangerGroup = UtilsTab:AddRightGroupbox("⚠️ Danger Zone")

DangerGroup:AddButton({
    Text = "💥 Server Lag Exploit",
    Func = function()
        Notify("⚠️ Warning", "Це може крашнути сервер! Використовуй обережно.", 5)
        task.wait(2)

        task.spawn(function()
            for i = 1, 50 do
                pcall(function()
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            for j = 1, 10 do
                                remote:FireServer(string.rep("A", 10000))
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end,
    DoubleClick = true,
    Tooltip = "Подвійний клік! Може заморозити сервер"
})

-- ============================================================================
-- TAB 7: SETTINGS
-- ============================================================================
local SettingsTab = Window:AddTab("🔧 Settings")

local MenuGroup = SettingsTab:AddLeftGroupbox("Menu Settings")

MenuGroup:AddButton({
    Text = "Unload Script",
    Func = function()
        -- Cleanup
        ESPModule.RemoveAllPlayerESP()

        if FOVCircle then FOVCircle:Remove() end
        if NoclipConnection then NoclipConnection:Disconnect() end
        if KillAuraConn then KillAuraConn:Disconnect() end
        if AutoFarmConnection then AutoFarmConnection:Disconnect() end
        if AimbotConnection then AimbotConnection:Disconnect() end
        if RadarConnection then RadarConnection:Disconnect() end
        if SpectateConn then SpectateConn:Disconnect() end
        if RoleRevealConn then RoleRevealConn:Disconnect() end
        if AutoShootConn then AutoShootConn:Disconnect() end
        if AutoEvadeConn then AutoEvadeConn:Disconnect() end
        if WalkSpeedConn then WalkSpeedConn:Disconnect() end
        if JumpPowerConn then JumpPowerConn:Disconnect() end
        if InfJumpConn then InfJumpConn:Disconnect() end
        if ClickTPConn then ClickTPConn:Disconnect() end
        if LoopBringGunConn then LoopBringGunConn:Disconnect() end
        if TeleportKillConn then TeleportKillConn:Disconnect() end
        if ThrowBotConn then ThrowBotConn:Disconnect() end
        if GodModeConn then GodModeConn:Disconnect() end
        if AdminCheckConn then AdminCheckConn:Disconnect() end

        -- Скидання
        ToggleFullBright(false)
        ToggleXRay(false)
        ToggleFly(false)
        ToggleNoclip(false)
        ToggleSilentAim(false)

        pcall(function()
            RunService:UnbindFromRenderStep("MM2_Fly")
        end)

        -- Cleanup ESP drawings
        for _, data in pairs(ESPContainer.Players) do
            pcall(function()
                if data.Tracer then data.Tracer:Remove() end
                if data.Box then data.Box:Remove() end
                for _, line in pairs(data.SkeletonLines or {}) do
                    line:Remove()
                end
            end)
        end

        for _, obj in pairs(CoinESPObjects) do
            pcall(function() obj:Destroy() end)
        end
        for _, obj in pairs(GunDropESPObjects) do
            pcall(function()
                if obj.Destroy then obj:Destroy() end
                if obj.Remove then obj:Remove() end
            end)
        end
        for _, obj in pairs(TrapESPObjects) do
            pcall(function() obj:Destroy() end)
        end

        -- Cleanup radar
        if RadarFrame then
            pcall(function() RadarFrame.Parent.Parent:Destroy() end)
        end

        Library:Unload()
        Notify("MM2 Master", "Script unloaded!")
    end
})

MenuGroup:AddLabel("Toggle Menu"):AddKeyPicker("MenuKeybind", {
    Default = Enum.KeyCode.End,
    SyncToggleState = false,
    Mode = "Toggle",
    Text = "Menu Toggle Key"
})

Library.ToggleKeybind = Options.MenuKeybind

-- Theme & Save Manager
local ThemeGroup = SettingsTab:AddLeftGroupbox("Theme")
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MM2MasterExploit")
ThemeManager:ApplyToGroupbox(ThemeGroup)

local SaveGroup = SettingsTab:AddRightGroupbox("Config System")
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("MM2MasterExploit/configs")
SaveManager:BuildConfigSection(SaveGroup)

-- ============================================================================
-- ІНІЦІАЛІЗАЦІЯ
-- ============================================================================

-- Створити FOV Circle
CreateFOVCircle()

-- Оновлення FOV Circle позиції
RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

-- Автоматичне оновлення ESP при зміні гравців
Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    if States.PlayerESPEnabled then
        ESPModule.CreatePlayerESP(player)
    end

    -- Оновити dropdowns
    pcall(function()
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        Options.SpectateTarget:SetValues(names)
        Options.TPPlayerDropdown:SetValues(names)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    ESPModule.RemovePlayerESP(player)

    pcall(function()
        local names = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p ~= player then
                table.insert(names, p.Name)
            end
        end
        Options.SpectateTarget:SetValues(names)
        Options.TPPlayerDropdown:SetValues(names)
    end)
end)

-- Оновити Item ESP кожні 5 секунд
task.spawn(function()
    while task.wait(5) do
        if States.CoinESPEnabled then
            ESPModule.UpdateCoinESP()
        end
        if States.GunDropESPEnabled then
            ESPModule.UpdateGunDropESP()
        end
        if States.TrapESPEnabled then
            ESPModule.UpdateTrapESP()
        end
    end
end)

-- Респавн хук
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)

    -- Переініціалізація після респавну
    if States.WalkSpeedEnabled then
        ToggleWalkSpeed(true)
    end
    if States.JumpPowerEnabled then
        ToggleJumpPower(true)
    end
    if States.NoclipEnabled then
        ToggleNoclip(true)
    end
    if States.FlyEnabled then
        task.wait(0.5)
        ToggleFly(true)
    end
    if States.GodModeEnabled then
        ToggleGodMode(true)
    end

    -- Reset role reveal для нового раунду
    LastRoundRevealed = false
end)

-- Завантажити авто-конфіг
SaveManager:LoadAutoloadConfig()

-- Фінальне сповіщення
Notify("🔥 MM2 Master Exploit", "Завантажено успішно! Натисни End для Toggle меню.", 5)

print([[
================================================================================
    MM2 MASTER EXPLOIT - Loaded Successfully!
    Toggle Menu: End key
    All features loaded and ready.
================================================================================
]])
