--// MM2 Professional Hub | LinoriaLib
--// Завантаження бібліотеки

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

--// Сервіси
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local PathfindingService = game:GetService("PathfindingService")
local SoundService = game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--// Стан скрипта
local State = {
    ESP = {
        Enabled = false,
        Murderer = false,
        Sheriff = false,
        Gun = false,
        Coins = false,
        AllPlayers = false,
        Tracers = false,
        Boxes = false,
        HealthBar = false,
        Distance = true,
        Names = true,
        Roles = true,
        Objects = {},
        CoinObjects = {},
        DrawingObjects = {},
        Colors = {
            Murderer = Color3.fromRGB(255, 0, 0),
            Sheriff = Color3.fromRGB(0, 100, 255),
            Innocent = Color3.fromRGB(0, 255, 0),
            Gun = Color3.fromRGB(0, 170, 255),
            Coin = Color3.fromRGB(255, 215, 0),
            Default = Color3.fromRGB(255, 255, 255)
        },
        FillTransparency = 0.5,
        OutlineTransparency = 0
    },
    Movement = {
        Speed = false,
        SpeedValue = 16,
        Jump = false,
        JumpValue = 50,
        Noclip = false,
        InfiniteJump = false,
        Fly = false,
        FlySpeed = 50,
        FlyObject = {Velocity = nil, Gyro = nil},
        SpinBot = false,
        SpinSpeed = 10,
        LongJump = false,
        BunnyHop = false
    },
    Combat = {
        Fling = false,
        FlingTarget = nil,
        FlingMethod = "Velocity",
        KillerAura = false,
        KillerAuraRange = 30,
        AntiKnife = false,
        AntiKnifeDistance = 15,
        AutoShoot = false,
        SilentAim = false,
        AimTarget = "Head",
        Hitbox = false,
        HitboxSize = 5
    },
    Game = {
        AutoCoin = false,
        AutoCoinMethod = "Teleport",
        AutoGrabGun = false,
        AutoEquip = false,
        Xray = false,
        GodMode = false,
        AntiVoid = false,
        AntiVoidHeight = -100,
        AutoPlay = false,
        NotifyRoles = true,
        AnnounceRoles = false
    },
    Visuals = {
        Fullbright = false,
        NoFog = false,
        NoShadows = false,
        CustomFOV = false,
        FOVValue = 70,
        ThirdPerson = false,
        ThirdPersonDistance = 10,
        Ambient = false,
        AmbientColor = Color3.fromRGB(178, 178, 178),
        RemoveEffects = false,
        ChamsMaterial = "ForceField",
        BigHead = false,
        BigHeadSize = 5,
        SmallCharacter = false,
        NoArms = false,
        TransparentCharacter = false,
        TransparencyValue = 0.5
    },
    Teleport = {
        SavedPositions = {},
        WaypointIndex = 1
    },
    Misc = {
        AntiAFK = true,
        Notifications = true,
        FPSUnlock = false,
        ChatSpam = false,
        ChatSpamMessage = "",
        ChatSpamDelay = 2,
        CopyChat = false,
        AntiScreenshot = false,
        StreamerMode = false
    },
    Mobile = {
        ButtonsCreated = false,
        ButtonSize = 70
    },
    Connections = {},
    Cache = {
        Murderer = nil,
        Sheriff = nil,
        MyRole = "Innocent",
        LastGunPos = nil
    }
}

--// Утиліти
local Utils = {}

function Utils.Notify(title, text, duration)
    if State.Misc.Notifications then
        Library:Notify(tostring(title) .. ": " .. tostring(text), duration or 3)
    end
end

function Utils.GetCharacter(player)
    player = player or LocalPlayer
    return player.Character or player.CharacterAdded:Wait()
end

function Utils.GetHumanoid(player)
    local char = Utils.GetCharacter(player)
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Utils.GetRootPart(player)
    local char = Utils.GetCharacter(player)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

function Utils.GetHead(player)
    local char = Utils.GetCharacter(player)
    return char and char:FindFirstChild("Head")
end

function Utils.IsAlive(player)
    player = player or LocalPlayer
    local hum = Utils.GetHumanoid(player)
    return hum and hum.Health > 0
end

function Utils.DistanceTo(position)
    local hrp = Utils.GetRootPart()
    if not hrp then return math.huge end
    return (hrp.Position - position).Magnitude
end

function Utils.HasTool(player, toolName)
    player = player or LocalPlayer
    local char = player.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") and v.Name == toolName then
                return true, v
            end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, v in pairs(backpack:GetChildren()) do
            if v.Name == toolName then
                return true, v
            end
        end
    end
    return false, nil
end

function Utils.HasKnife(player)
    return Utils.HasTool(player, "Knife")
end

function Utils.HasGun(player)
    local has, tool = Utils.HasTool(player, "Gun")
    if not has then
        has, tool = Utils.HasTool(player, "Revolver")
    end
    return has, tool
end

function Utils.GetRole(player)
    player = player or LocalPlayer
    if Utils.HasKnife(player) then return "Murderer" end
    if Utils.HasGun(player) then return "Sheriff" end
    return "Innocent"
end

function Utils.FindMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if Utils.HasKnife(player) then
            return player
        end
    end
    return nil
end

function Utils.FindSheriff()
    for _, player in pairs(Players:GetPlayers()) do
        if Utils.HasGun(player) then
            return player
        end
    end
    return nil
end

function Utils.FindDroppedGun()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and (v.Name == "Gun" or v.Name == "Revolver") then
            if not v.Parent:FindFirstChildOfClass("Humanoid") then
                return v
            end
        end
    end
    return nil
end

function Utils.FindCoins()
    local coins = {}
    
    local coinContainer = Workspace:FindFirstChild("CoinContainer")
    if coinContainer then
        for _, v in pairs(coinContainer:GetDescendants()) do
            if v:IsA("BasePart") then
                table.insert(coins, v)
            end
        end
    end
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "Coin_Server" or v.Name == "CoinVisual" or v.Name == "Coin" then
            if v:IsA("BasePart") then
                table.insert(coins, v)
            elseif v:IsA("Model") then
                local part = v:FindFirstChildOfClass("BasePart")
                if part then table.insert(coins, part) end
            end
        end
    end
    
    return coins
end

function Utils.GetPlayerList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    return list
end

function Utils.GetClosestPlayer(maxDist, ignoreMurderer)
    maxDist = maxDist or math.huge
    local closest = nil
    local closestDist = maxDist
    local hrp = Utils.GetRootPart()
    if not hrp then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and Utils.IsAlive(player) then
            if ignoreMurderer and player == State.Cache.Murderer then continue end
            local targetHRP = Utils.GetRootPart(player)
            if targetHRP then
                local dist = (hrp.Position - targetHRP.Position).Magnitude
                if dist < closestDist then
                    closest = player
                    closestDist = dist
                end
            end
        end
    end
    
    return closest, closestDist
end

function Utils.Disconnect(name)
    if State.Connections[name] then
        pcall(function() State.Connections[name]:Disconnect() end)
        State.Connections[name] = nil
    end
end

function Utils.Connect(name, connection)
    Utils.Disconnect(name)
    State.Connections[name] = connection
end

function Utils.GetMap()
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name ~= "Lobby" then
            local isMap = false
            for _, child in pairs(v:GetDescendants()) do
                if child:IsA("SpawnLocation") or child.Name == "Spawns" then
                    isMap = true
                    break
                end
            end
            if isMap then return v end
        end
    end
    return nil
end

function Utils.IsInRound()
    local roundTimer = nil
    for _, v in pairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
        if v.Name == "TimerLabel" or v.Name == "Timer" then
            if v:IsA("TextLabel") then
                roundTimer = v
                break
            end
        end
    end
    return roundTimer ~= nil
end

--// ESP модуль
local ESP = {}

function ESP.ClearPlayer(playerName)
    if State.ESP.Objects[playerName] then
        for _, obj in pairs(State.ESP.Objects[playerName]) do
            pcall(function()
                if typeof(obj) == "Instance" then
                    obj:Destroy()
                elseif type(obj) == "table" and obj.Remove then
                    obj:Remove()
                end
            end)
        end
        State.ESP.Objects[playerName] = nil
    end
end

function ESP.ClearAll()
    for name, _ in pairs(State.ESP.Objects) do
        ESP.ClearPlayer(name)
    end
    State.ESP.Objects = {}
end

function ESP.ClearCoins()
    for _, obj in pairs(State.ESP.CoinObjects) do
        pcall(function()
            if obj and obj.Parent then obj:Destroy() end
        end)
    end
    State.ESP.CoinObjects = {}
end

function ESP.ClearDrawings()
    for _, obj in pairs(State.ESP.DrawingObjects) do
        pcall(function()
            if obj and obj.Remove then obj:Remove() end
        end)
    end
    State.ESP.DrawingObjects = {}
end

function ESP.CreateHighlight(character, color, name)
    if not character then return nil end
    
    local existing = character:FindFirstChild("ESP_Highlight_" .. name)
    if existing then existing:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight_" .. name
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = State.ESP.FillTransparency
    highlight.OutlineTransparency = State.ESP.OutlineTransparency
    highlight.Parent = character
    
    return highlight
end

function ESP.CreateBillboard(adornee, text, color, offset)
    if not adornee then return nil, nil, nil end
    offset = offset or Vector3.new(0, 3, 0)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 200, 0, 80)
    billboard.StudsOffset = offset
    billboard.AlwaysOnTop = true
    billboard.Parent = adornee
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = color
    nameLabel.Text = text
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0.25, 0)
    distLabel.Position = UDim2.new(0, 0, 0.35, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.Text = "0 studs"
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distLabel.Parent = billboard
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0.2, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.6, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.Text = "100 HP"
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.TextStrokeTransparency = 0
    healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    healthLabel.Parent = billboard
    
    -- Здоровя бар
    if State.ESP.HealthBar then
        local barBG = Instance.new("Frame")
        barBG.Name = "HealthBarBG"
        barBG.Size = UDim2.new(0.8, 0, 0.1, 0)
        barBG.Position = UDim2.new(0.1, 0, 0.85, 0)
        barBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        barBG.BorderSizePixel = 0
        barBG.Parent = billboard
        
        local barFill = Instance.new("Frame")
        barFill.Name = "HealthBarFill"
        barFill.Size = UDim2.new(1, 0, 1, 0)
        barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        barFill.BorderSizePixel = 0
        barFill.Parent = barBG
        
        local corner1 = Instance.new("UICorner", barBG)
        corner1.CornerRadius = UDim.new(0, 3)
        local corner2 = Instance.new("UICorner", barFill)
        corner2.CornerRadius = UDim.new(0, 3)
    end
    
    return billboard, nameLabel, distLabel
end

function ESP.CreatePlayerESP(player, color, roleText)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    ESP.ClearPlayer(player.Name)
    State.ESP.Objects[player.Name] = {}
    
    local displayText = roleText
    if State.ESP.Names then
        displayText = displayText .. " [" .. player.Name .. "]"
    end
    
    local billboard = ESP.CreateBillboard(head, displayText, color)
    if billboard then
        table.insert(State.ESP.Objects[player.Name], billboard)
    end
    
    local highlight = ESP.CreateHighlight(char, color, player.Name)
    if highlight then
        table.insert(State.ESP.Objects[player.Name], highlight)
    end
    
    -- Box ESP через Drawing API
    if State.ESP.Boxes then
        pcall(function()
            local box = Drawing.new("Square")
            box.Visible = false
            box.Color = color
            box.Thickness = 1
            box.Filled = false
            box.Transparency = 1
            table.insert(State.ESP.Objects[player.Name], box)
            table.insert(State.ESP.DrawingObjects, box)
        end)
    end
    
    -- Tracer
    if State.ESP.Tracers then
        pcall(function()
            local tracer = Drawing.new("Line")
            tracer.Visible = true
            tracer.Color = color
            tracer.Thickness = 1
            tracer.Transparency = 1
            table.insert(State.ESP.Objects[player.Name], tracer)
            table.insert(State.ESP.DrawingObjects, tracer)
        end)
    end
end

function ESP.CreateGunESP()
    ESP.ClearPlayer("DroppedGun")
    
    local gun = Utils.FindDroppedGun()
    if not gun then return end
    
    local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
    if not handle then return end
    
    State.ESP.Objects["DroppedGun"] = {}
    
    local billboard = ESP.CreateBillboard(handle, "[DROPPED GUN]", State.ESP.Colors.Gun, Vector3.new(0, 3, 0))
    if billboard then
        table.insert(State.ESP.Objects["DroppedGun"], billboard)
    end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = State.ESP.Colors.Gun
    highlight.OutlineColor = State.ESP.Colors.Gun
    highlight.FillTransparency = 0.3
    highlight.Parent = gun
    table.insert(State.ESP.Objects["DroppedGun"], highlight)
end

function ESP.CreateCoinESP()
    ESP.ClearCoins()
    if not State.ESP.Coins then return end
    
    local coins = Utils.FindCoins()
    for _, coin in pairs(coins) do
        if coin:IsA("BasePart") then
            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0, 80, 0, 25)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Adornee = coin
            billboard.Parent = coin
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = State.ESP.Colors.Coin
            label.Text = "Coin"
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.TextStrokeTransparency = 0
            label.Parent = billboard
            
            local highlight = Instance.new("Highlight")
            highlight.FillColor = State.ESP.Colors.Coin
            highlight.FillTransparency = 0.4
            highlight.Parent = coin
            
            table.insert(State.ESP.CoinObjects, billboard)
            table.insert(State.ESP.CoinObjects, highlight)
        end
    end
end

function ESP.UpdateDistance()
    local hrp = Utils.GetRootPart()
    if not hrp then return end
    
    for name, objects in pairs(State.ESP.Objects) do
        for _, obj in pairs(objects) do
            if typeof(obj) == "Instance" and obj:IsA("BillboardGui") and obj.Adornee then
                pcall(function()
                    local dist = math.floor((hrp.Position - obj.Adornee.Position).Magnitude)
                    local distLabel = obj:FindFirstChild("DistLabel")
                    if distLabel and State.ESP.Distance then
                        distLabel.Text = dist .. " studs"
                        distLabel.Visible = true
                    elseif distLabel then
                        distLabel.Visible = false
                    end
                    
                    -- Оновити здоровя
                    local healthLabel = obj:FindFirstChild("HealthLabel")
                    if healthLabel then
                        local player = Players:FindFirstChild(name)
                        if player then
                            local hum = Utils.GetHumanoid(player)
                            if hum then
                                healthLabel.Text = math.floor(hum.Health) .. " HP"
                                local ratio = hum.Health / hum.MaxHealth
                                healthLabel.TextColor3 = Color3.fromRGB(255 * (1 - ratio), 255 * ratio, 0)
                            end
                        end
                    end
                    
                    -- Здоровя бар
                    local barBG = obj:FindFirstChild("HealthBarBG")
                    if barBG then
                        local barFill = barBG:FindFirstChild("HealthBarFill")
                        if barFill then
                            local player = Players:FindFirstChild(name)
                            if player then
                                local hum = Utils.GetHumanoid(player)
                                if hum then
                                    local ratio = hum.Health / hum.MaxHealth
                                    barFill.Size = UDim2.new(ratio, 0, 1, 0)
                                    barFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - ratio), 255 * ratio, 0)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
    
    -- Tracers оновлення
    if State.ESP.Tracers then
        pcall(function()
            for _, obj in pairs(State.ESP.DrawingObjects) do
                if obj and obj.__OBJECT_EXISTS then
                    -- Drawing objects update handled separately
                end
            end
        end)
    end
end

--// Fly модуль
local Fly = {}

function Fly.Start()
    local char = Utils.GetCharacter()
    local hrp = Utils.GetRootPart()
    local hum = Utils.GetHumanoid()
    if not hrp or not hum then return end
    
    State.Movement.Fly = true
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 9e4
    bg.Parent = hrp
    
    State.Movement.FlyObject.Velocity = bv
    State.Movement.FlyObject.Gyro = bg
    
    hum.PlatformStand = true
    
    Utils.Connect("FlyLoop", RunService.Heartbeat:Connect(function()
        if not State.Movement.Fly then return end
        if not hrp or not hrp.Parent then
            Fly.Stop()
            return
        end
        
        local dir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            dir = dir + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            dir = dir - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            dir = dir - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            dir = dir + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            dir = dir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            dir = dir - Vector3.new(0, 1, 0)
        end
        
        -- Мобільна підтримка
        if hum.MoveDirection.Magnitude > 0 then
            local moveDir = hum.MoveDirection
            dir = dir + Vector3.new(moveDir.X, 0, moveDir.Z)
            
            -- Підйом через стрибок на мобільному
            if hum.Jump then
                dir = dir + Vector3.new(0, 1, 0)
            end
        end
        
        if dir.Magnitude > 0 then
            bv.Velocity = dir.Unit * State.Movement.FlySpeed
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        
        bg.CFrame = Camera.CFrame
    end))
end

function Fly.Stop()
    State.Movement.Fly = false
    Utils.Disconnect("FlyLoop")
    
    local hum = Utils.GetHumanoid()
    if hum then hum.PlatformStand = false end
    
    if State.Movement.FlyObject.Velocity then
        pcall(function() State.Movement.FlyObject.Velocity:Destroy() end)
        State.Movement.FlyObject.Velocity = nil
    end
    if State.Movement.FlyObject.Gyro then
        pcall(function() State.Movement.FlyObject.Gyro:Destroy() end)
        State.Movement.FlyObject.Gyro = nil
    end
end

--// Fling модуль
local Fling = {}

function Fling.Execute(targetPlayer)
    if not targetPlayer then
        Utils.Notify("Fling", "Target not found")
        return
    end
    
    local char = Utils.GetCharacter()
    local hrp = Utils.GetRootPart()
    if not hrp then return end
    
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    Utils.Notify("Fling", "Targeting " .. targetPlayer.Name)
    
    local originalPos = hrp.CFrame
    local startTime = tick()
    
    if State.Combat.FlingMethod == "Velocity" then
        local att = Instance.new("Attachment", hrp)
        
        local lv = Instance.new("LinearVelocity")
        lv.MaxForce = math.huge
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.Attachment0 = att
        lv.Parent = hrp
        
        local av = Instance.new("AngularVelocity")
        av.MaxTorque = math.huge
        av.Attachment0 = att
        av.Parent = hrp
        
        Utils.Connect("FlingLoop", RunService.Heartbeat:Connect(function()
            if not State.Combat.Fling or tick() - startTime > 8 then
                Utils.Disconnect("FlingLoop")
                pcall(function()
                    lv:Destroy()
                    av:Destroy()
                    att:Destroy()
                end)
                if hrp and hrp.Parent then
                    hrp.CFrame = originalPos
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                end
                return
            end
            
            local tRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if tRoot and hrp and hrp.Parent then
                hrp.CFrame = tRoot.CFrame * CFrame.new(0, 0, 0.5)
                lv.VectorVelocity = (tRoot.Position - hrp.Position).Unit * 9999
                av.AngularVelocity = Vector3.new(9999, 9999, 9999)
            else
                Utils.Disconnect("FlingLoop")
                pcall(function()
                    lv:Destroy()
                    av:Destroy()
                    att:Destroy()
                end)
            end
        end))
        
    elseif State.Combat.FlingMethod == "CFrame" then
        Utils.Connect("FlingLoop", RunService.Heartbeat:Connect(function()
            if not State.Combat.Fling or tick() - startTime > 8 then
                Utils.Disconnect("FlingLoop")
                if hrp and hrp.Parent then
                    hrp.CFrame = originalPos
                end
                return
            end
            
            local tRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if tRoot and hrp and hrp.Parent then
                hrp.CFrame = tRoot.CFrame
                hrp.Velocity = Vector3.new(math.random(-500, 500), math.random(200, 500), math.random(-500, 500))
                hrp.RotVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
            end
        end))
    end
end

function Fling.Stop()
    State.Combat.Fling = false
    Utils.Disconnect("FlingLoop")
    
    local hrp = Utils.GetRootPart()
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end
end

--// Xray модуль
local Xray = {}

function Xray.Enable()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency < 1 then
            if not v:FindFirstAncestorOfClass("Model") or 
               not Players:GetPlayerFromCharacter(v:FindFirstAncestorOfClass("Model")) then
                if v.Name ~= "Baseplate" and v.Name ~= "Base" then
                    v.LocalTransparencyModifier = 0.7
                end
            end
        end
    end
end

function Xray.Disable()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.LocalTransparencyModifier = 0
        end
    end
end

--// Створення інтерфейсу
local Window = Library:CreateWindow({
    Title = 'MM2 Professional Hub v3.0',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--// Табы
local Tabs = {
    Player = Window:AddTab('Player'),
    ESP = Window:AddTab('ESP'),
    Combat = Window:AddTab('Combat'),
    Game = Window:AddTab('Game'),
    Visuals = Window:AddTab('Visuals'),
    Teleport = Window:AddTab('Teleport'),
    Misc = Window:AddTab('Misc'),
    Mobile = Window:AddTab('Mobile'),
    Settings = Window:AddTab('Settings')
}

-- =====================================================
-- PLAYER TAB
-- =====================================================

local PlayerMovement = Tabs.Player:AddLeftGroupbox('Movement')

PlayerMovement:AddToggle('SpeedHack', {
    Text = 'Speed Hack',
    Default = false,
    Tooltip = 'Modifies walk speed'
}):OnChanged(function()
    State.Movement.Speed = Toggles.SpeedHack.Value
end)

PlayerMovement:AddSlider('SpeedValue', {
    Text = 'Walk Speed',
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 0
}):OnChanged(function()
    State.Movement.SpeedValue = Options.SpeedValue.Value
end)

PlayerMovement:AddDivider()

PlayerMovement:AddToggle('JumpHack', {
    Text = 'Jump Power',
    Default = false,
    Tooltip = 'Modifies jump height'
}):OnChanged(function()
    State.Movement.Jump = Toggles.JumpHack.Value
end)

PlayerMovement:AddSlider('JumpValue', {
    Text = 'Jump Power Value',
    Default = 50,
    Min = 50,
    Max = 350,
    Rounding = 0
}):OnChanged(function()
    State.Movement.JumpValue = Options.JumpValue.Value
end)

PlayerMovement:AddDivider()

PlayerMovement:AddToggle('NoclipToggle', {
    Text = 'Noclip',
    Default = false,
    Tooltip = 'Walk through walls'
}):OnChanged(function()
    State.Movement.Noclip = Toggles.NoclipToggle.Value
end)

PlayerMovement:AddToggle('InfiniteJumpToggle', {
    Text = 'Infinite Jump',
    Default = false,
    Tooltip = 'Jump in mid-air'
}):OnChanged(function()
    State.Movement.InfiniteJump = Toggles.InfiniteJumpToggle.Value
end)

PlayerMovement:AddToggle('BunnyHopToggle', {
    Text = 'Bunny Hop',
    Default = false,
    Tooltip = 'Auto jump when moving'
}):OnChanged(function()
    State.Movement.BunnyHop = Toggles.BunnyHopToggle.Value
end)

PlayerMovement:AddToggle('SpinBotToggle', {
    Text = 'Spin Bot',
    Default = false,
    Tooltip = 'Spin character continuously'
}):OnChanged(function()
    State.Movement.SpinBot = Toggles.SpinBotToggle.Value
end)

PlayerMovement:AddSlider('SpinSpeedSlider', {
    Text = 'Spin Speed',
    Default = 10,
    Min = 1,
    Max = 100,
    Rounding = 0
}):OnChanged(function()
    State.Movement.SpinSpeed = Options.SpinSpeedSlider.Value
end)

-- Fly секція
local PlayerFly = Tabs.Player:AddRightGroupbox('Fly')

PlayerFly:AddToggle('FlyToggle', {
    Text = 'Fly',
    Default = false,
    Tooltip = 'Fly around the map'
}):OnChanged(function()
    if Toggles.FlyToggle.Value then
        Fly.Start()
        Utils.Notify("Fly", "Enabled")
    else
        Fly.Stop()
        Utils.Notify("Fly", "Disabled")
    end
end)

PlayerFly:AddSlider('FlySpeedSlider', {
    Text = 'Fly Speed',
    Default = 50,
    Min = 10,
    Max = 400,
    Rounding = 0
}):OnChanged(function()
    State.Movement.FlySpeed = Options.FlySpeedSlider.Value
end)

PlayerFly:AddDivider()

PlayerFly:AddToggle('GodModeToggle', {
    Text = 'God Mode (Anti-Fall)',
    Default = false
}):OnChanged(function()
    State.Game.GodMode = Toggles.GodModeToggle.Value
end)

PlayerFly:AddToggle('AntiVoidToggle', {
    Text = 'Anti-Void',
    Default = false,
    Tooltip = 'Prevents falling into void'
}):OnChanged(function()
    State.Game.AntiVoid = Toggles.AntiVoidToggle.Value
end)

PlayerFly:AddSlider('AntiVoidHeight', {
    Text = 'Void Threshold',
    Default = -100,
    Min = -500,
    Max = -10,
    Rounding = 0
}):OnChanged(function()
    State.Game.AntiVoidHeight = Options.AntiVoidHeight.Value
end)

PlayerFly:AddDivider()

PlayerFly:AddButton({
    Text = 'Respawn Character',
    Func = function()
        pcall(function()
            Utils.GetCharacter():BreakJoints()
        end)
        Utils.Notify("Player", "Respawned")
    end
})

PlayerFly:AddButton({
    Text = 'Reset Velocity',
    Func = function()
        local hrp = Utils.GetRootPart()
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
        Utils.Notify("Player", "Velocity reset")
    end
})

PlayerFly:AddButton({
    Text = 'Freeze Character',
    Func = function()
        local hrp = Utils.GetRootPart()
        if hrp then
            if hrp.Anchored then
                hrp.Anchored = false
                Utils.Notify("Player", "Unfrozen")
            else
                hrp.Anchored = true
                Utils.Notify("Player", "Frozen")
            end
        end
    end
})

-- =====================================================
-- ESP TAB
-- =====================================================

local ESPRoles = Tabs.ESP:AddLeftGroupbox('Role ESP')

ESPRoles:AddToggle('MurdererESP', {
    Text = 'Murderer ESP',
    Default = false,
    Tooltip = 'Highlights the murderer'
}):OnChanged(function()
    State.ESP.Murderer = Toggles.MurdererESP.Value
    if not State.ESP.Murderer then
        if State.Cache.Murderer then
            ESP.ClearPlayer(State.Cache.Murderer.Name)
        end
    end
end)

ESPRoles:AddToggle('SheriffESP', {
    Text = 'Sheriff ESP',
    Default = false,
    Tooltip = 'Highlights the sheriff'
}):OnChanged(function()
    State.ESP.Sheriff = Toggles.SheriffESP.Value
    if not State.ESP.Sheriff then
        if State.Cache.Sheriff then
            ESP.ClearPlayer(State.Cache.Sheriff.Name)
        end
    end
end)

ESPRoles:AddToggle('GunESP', {
    Text = 'Dropped Gun ESP',
    Default = false,
    Tooltip = 'Shows dropped gun location'
}):OnChanged(function()
    State.ESP.Gun = Toggles.GunESP.Value
    if not State.ESP.Gun then
        ESP.ClearPlayer("DroppedGun")
    end
end)

ESPRoles:AddToggle('CoinESP', {
    Text = 'Coin ESP',
    Default = false,
    Tooltip = 'Shows coin locations'
}):OnChanged(function()
    State.ESP.Coins = Toggles.CoinESP.Value
    if State.ESP.Coins then
        ESP.CreateCoinESP()
    else
        ESP.ClearCoins()
    end
end)

ESPRoles:AddToggle('AllPlayerESP', {
    Text = 'All Players ESP',
    Default = false,
    Tooltip = 'ESP on all players with role colors'
}):OnChanged(function()
    State.ESP.AllPlayers = Toggles.AllPlayerESP.Value
    if not State.ESP.AllPlayers then
        ESP.ClearAll()
    end
end)

local ESPSettings = Tabs.ESP:AddRightGroupbox('ESP Settings')

ESPSettings:AddToggle('ESPTracers', {
    Text = 'Tracers',
    Default = false
}):OnChanged(function()
    State.ESP.Tracers = Toggles.ESPTracers.Value
end)

ESPSettings:AddToggle('ESPBoxes', {
    Text = '2D Boxes',
    Default = false
}):OnChanged(function()
    State.ESP.Boxes = Toggles.ESPBoxes.Value
end)

ESPSettings:AddToggle('ESPHealthBar', {
    Text = 'Health Bars',
    Default = false
}):OnChanged(function()
    State.ESP.HealthBar = Toggles.ESPHealthBar.Value
end)

ESPSettings:AddToggle('ESPDistance', {
    Text = 'Show Distance',
    Default = true
}):OnChanged(function()
    State.ESP.Distance = Toggles.ESPDistance.Value
end)

ESPSettings:AddToggle('ESPNames', {
    Text = 'Show Names',
    Default = true
}):OnChanged(function()
    State.ESP.Names = Toggles.ESPNames.Value
end)

ESPSettings:AddSlider('ESPFillTransparency', {
    Text = 'Fill Transparency',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0
}):OnChanged(function()
    State.ESP.FillTransparency = Options.ESPFillTransparency.Value / 100
end)

ESPSettings:AddDivider()

local RoleInfoBox = Tabs.ESP:AddRightGroupbox('Role Information')

local MurdererInfoLabel = RoleInfoBox:AddLabel('Murderer: Scanning...')
local SheriffInfoLabel = RoleInfoBox:AddLabel('Sheriff: Scanning...')
local MyRoleInfoLabel = RoleInfoBox:AddLabel('Your Role: Scanning...')
local PlayersAliveLabel = RoleInfoBox:AddLabel('Players Alive: 0')

RoleInfoBox:AddButton({
    Text = 'Force Refresh ESP',
    Func = function()
        ESP.ClearAll()
        ESP.ClearCoins()
        ESP.ClearDrawings()
        if State.ESP.Coins then ESP.CreateCoinESP() end
        Utils.Notify("ESP", "Force refreshed all ESP")
    end
})

-- =====================================================
-- COMBAT TAB
-- =====================================================

local FlingBox = Tabs.Combat:AddLeftGroupbox('Fling')

FlingBox:AddDropdown('FlingTargetDropdown', {
    Values = Utils.GetPlayerList(),
    Default = 1,
    Multi = false,
    Text = 'Fling Target'
}):OnChanged(function()
    local selected = Options.FlingTargetDropdown.Value
    State.Combat.FlingTarget = Players:FindFirstChild(selected)
end)

FlingBox:AddDropdown('FlingMethodDropdown', {
    Values = {"Velocity", "CFrame"},
    Default = 1,
    Multi = false,
    Text = 'Fling Method'
}):OnChanged(function()
    State.Combat.FlingMethod = Options.FlingMethodDropdown.Value
end)

FlingBox:AddButton({
    Text = 'Refresh Player List',
    Func = function()
        Options.FlingTargetDropdown:SetValues(Utils.GetPlayerList())
        Options.TPTargetDropdown:SetValues(Utils.GetPlayerList())
        Utils.Notify("Combat", "Player list refreshed")
    end
})

FlingBox:AddButton({
    Text = 'Fling Selected Player',
    Func = function()
        if State.Combat.FlingTarget then
            State.Combat.Fling = true
            Fling.Execute(State.Combat.FlingTarget)
        else
            Utils.Notify("Fling", "No target selected")
        end
    end,
    DoubleClick = true,
    Tooltip = 'Double click to confirm'
})

FlingBox:AddButton({
    Text = 'Fling Murderer',
    Func = function()
        local murderer = Utils.FindMurderer()
        if murderer then
            State.Combat.Fling = true
            Fling.Execute(murderer)
        else
            Utils.Notify("Fling", "Murderer not found")
        end
    end,
    DoubleClick = true
})

FlingBox:AddButton({
    Text = 'Fling Closest Player',
    Func = function()
        local closest = Utils.GetClosestPlayer(100)
        if closest then
            State.Combat.Fling = true
            Fling.Execute(closest)
        else
            Utils.Notify("Fling", "No players nearby")
        end
    end,
    DoubleClick = true
})

FlingBox:AddButton({
    Text = 'Stop Fling',
    Func = function()
        Fling.Stop()
        Utils.Notify("Fling", "Stopped")
    end
})

-- Combat автоматизація
local CombatAutoBox = Tabs.Combat:AddRightGroupbox('Combat Automation')

CombatAutoBox:AddToggle('AntiKnifeToggle', {
    Text = 'Anti-Knife',
    Default = false,
    Tooltip = 'Auto dodge when murderer approaches'
}):OnChanged(function()
    State.Combat.AntiKnife = Toggles.AntiKnifeToggle.Value
end)

CombatAutoBox:AddSlider('AntiKnifeDistance', {
    Text = 'Safe Distance',
    Default = 15,
    Min = 5,
    Max = 50,
    Rounding = 0
}):OnChanged(function()
    State.Combat.AntiKnifeDistance = Options.AntiKnifeDistance.Value
end)

CombatAutoBox:AddDivider()

CombatAutoBox:AddToggle('KillerAuraToggle', {
    Text = 'Killer Aura (Sheriff Only)',
    Default = false,
    Tooltip = 'Auto shoot murderer when in range'
}):OnChanged(function()
    State.Combat.KillerAura = Toggles.KillerAuraToggle.Value
end)

CombatAutoBox:AddSlider('KillerAuraRange', {
    Text = 'Aura Range',
    Default = 30,
    Min = 5,
    Max = 100,
    Rounding = 0
}):OnChanged(function()
    State.Combat.KillerAuraRange = Options.KillerAuraRange.Value
end)

CombatAutoBox:AddDivider()

CombatAutoBox:AddToggle('HitboxExpander', {
    Text = 'Hitbox Expander',
    Default = false,
    Tooltip = 'Expand other player hitboxes'
}):OnChanged(function()
    State.Combat.Hitbox = Toggles.HitboxExpander.Value
end)

CombatAutoBox:AddSlider('HitboxSize', {
    Text = 'Hitbox Size',
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 0
}):OnChanged(function()
    State.Combat.HitboxSize = Options.HitboxSize.Value
end)

CombatAutoBox:AddDivider()

CombatAutoBox:AddDropdown('AimTargetDropdown', {
    Values = {"Head", "HumanoidRootPart", "Torso"},
    Default = 1,
    Multi = false,
    Text = 'Aim Target Part'
}):OnChanged(function()
    State.Combat.AimTarget = Options.AimTargetDropdown.Value
end)

-- Weapon controls
local WeaponBox = Tabs.Combat:AddRightGroupbox('Weapon Controls')

WeaponBox:AddButton({
    Text = 'Equip Gun',
    Func = function()
        local has, gun = Utils.HasGun()
        if has and gun then
            local hum = Utils.GetHumanoid()
            if hum then hum:EquipTool(gun) end
            Utils.Notify("Weapon", "Gun equipped")
        else
            Utils.Notify("Weapon", "No gun found")
        end
    end
})

WeaponBox:AddButton({
    Text = 'Equip Knife',
    Func = function()
        local has, knife = Utils.HasKnife()
        if has and knife then
            local hum = Utils.GetHumanoid()
            if hum then hum:EquipTool(knife) end
            Utils.Notify("Weapon", "Knife equipped")
        else
            Utils.Notify("Weapon", "No knife found")
        end
    end
})

WeaponBox:AddButton({
    Text = 'Unequip All',
    Func = function()
        local hum = Utils.GetHumanoid()
        if hum then hum:UnequipTools() end
        Utils.Notify("Weapon", "Tools unequipped")
    end
})

-- =====================================================
-- GAME TAB
-- =====================================================

local GameAutoBox = Tabs.Game:AddLeftGroupbox('Auto Functions')

GameAutoBox:AddToggle('AutoCoinToggle', {
    Text = 'Auto Collect Coins',
    Default = false,
    Tooltip = 'Automatically collect coins'
}):OnChanged(function()
    State.Game.AutoCoin = Toggles.AutoCoinToggle.Value
    if State.Game.AutoCoin then
        Utils.Notify("Auto Coin", "Enabled")
    end
end)

GameAutoBox:AddDropdown('AutoCoinMethod', {
    Values = {"Teleport", "Tween", "Pathfind"},
    Default = 1,
    Multi = false,
    Text = 'Collection Method'
}):OnChanged(function()
    State.Game.AutoCoinMethod = Options.AutoCoinMethod.Value
end)

GameAutoBox:AddDivider()

GameAutoBox:AddToggle('AutoGrabGunToggle', {
    Text = 'Auto Grab Dropped Gun',
    Default = false,
    Tooltip = 'Automatically pick up dropped gun'
}):OnChanged(function()
    State.Game.AutoGrabGun = Toggles.AutoGrabGunToggle.Value
end)

GameAutoBox:AddToggle('AutoEquipToggle', {
    Text = 'Auto Equip Tools',
    Default = false,
    Tooltip = 'Auto equip gun or knife when obtained'
}):OnChanged(function()
    State.Game.AutoEquip = Toggles.AutoEquipToggle.Value
end)

GameAutoBox:AddDivider()

GameAutoBox:AddToggle('XrayToggle', {
    Text = 'X-Ray Vision',
    Default = false,
    Tooltip = 'See through walls'
}):OnChanged(function()
    State.Game.Xray = Toggles.XrayToggle.Value
    if State.Game.Xray then
        Xray.Enable()
        Utils.Notify("X-Ray", "Enabled")
    else
        Xray.Disable()
        Utils.Notify("X-Ray", "Disabled")
    end
end)

-- Game кнопки
local GameButtonsBox = Tabs.Game:AddRightGroupbox('Quick Actions')

GameButtonsBox:AddButton({
    Text = 'Teleport to Dropped Gun',
    Func = function()
        local gun = Utils.FindDroppedGun()
        if gun then
            local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
            local hrp = Utils.GetRootPart()
            if handle and hrp then
                hrp.CFrame = handle.CFrame * CFrame.new(0, 2, 0)
                Utils.Notify("TP", "Teleported to gun")
            end
        else
            Utils.Notify("TP", "No dropped gun found")
        end
    end
})

GameButtonsBox:AddButton({
    Text = 'Teleport to Murderer',
    Func = function()
        local murderer = Utils.FindMurderer()
        if murderer and murderer.Character then
            local tHRP = Utils.GetRootPart(murderer)
            local hrp = Utils.GetRootPart()
            if tHRP and hrp then
                hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, 5)
                Utils.Notify("TP", "Teleported to murderer")
            end
        else
            Utils.Notify("TP", "Murderer not found")
        end
    end
})

GameButtonsBox:AddButton({
    Text = 'Teleport to Sheriff',
    Func = function()
        local sheriff = Utils.FindSheriff()
        if sheriff and sheriff.Character then
            local tHRP = Utils.GetRootPart(sheriff)
            local hrp = Utils.GetRootPart()
            if tHRP and hrp then
                hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, 5)
                Utils.Notify("TP", "Teleported to sheriff")
            end
        else
            Utils.Notify("TP", "Sheriff not found")
        end
    end
})

GameButtonsBox:AddDivider()

GameButtonsBox:AddToggle('NotifyRolesToggle', {
    Text = 'Notify Roles on Round Start',
    Default = true,
    Tooltip = 'Get notification when roles are assigned'
}):OnChanged(function()
    State.Game.NotifyRoles = Toggles.NotifyRolesToggle.Value
end)

GameButtonsBox:AddButton({
    Text = 'Announce Murderer in Chat',
    Func = function()
        local murderer = Utils.FindMurderer()
        if murderer then
            pcall(function()
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                    "Murderer is: " .. murderer.Name, "All"
                )
            end)
            Utils.Notify("Announce", "Murderer: " .. murderer.Name)
        else
            Utils.Notify("Announce", "Murderer not identified")
        end
    end,
    DoubleClick = true,
    Tooltip = 'Double click to confirm'
})

GameButtonsBox:AddButton({
    Text = 'Announce Sheriff in Chat',
    Func = function()
        local sheriff = Utils.FindSheriff()
        if sheriff then
            pcall(function()
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                    "Sheriff is: " .. sheriff.Name, "All"
                )
            end)
            Utils.Notify("Announce", "Sheriff: " .. sheriff.Name)
        else
            Utils.Notify("Announce", "Sheriff not identified")
        end
    end,
    DoubleClick = true
})

-- =====================================================
-- VISUALS TAB
-- =====================================================

local VisualLightingBox = Tabs.Visuals:AddLeftGroupbox('Lighting')

VisualLightingBox:AddToggle('FullbrightToggle', {
    Text = 'Fullbright',
    Default = false,
    Tooltip = 'Maximum brightness'
}):OnChanged(function()
    State.Visuals.Fullbright = Toggles.FullbrightToggle.Value
    if State.Visuals.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or 
               v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
                v.Enabled = false
            end
        end
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") then
                v.Enabled = true
            end
        end
    end
end)

VisualLightingBox:AddToggle('NoFogToggle', {
    Text = 'Remove Fog',
    Default = false
}):OnChanged(function()
    State.Visuals.NoFog = Toggles.NoFogToggle.Value
    if State.Visuals.NoFog then
        Lighting.FogEnd = 999999
        Lighting.FogStart = 999999
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("Atmosphere") then
                v.Density = 0
                v.Offset = 0
            end
        end
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
end)

VisualLightingBox:AddToggle('NoShadowsToggle', {
    Text = 'No Shadows',
    Default = false
}):OnChanged(function()
    Lighting.GlobalShadows = not Toggles.NoShadowsToggle.Value
end)

VisualLightingBox:AddToggle('RemoveEffectsToggle', {
    Text = 'Remove Post Effects',
    Default = false,
    Tooltip = 'Remove blur, bloom, color correction'
}):OnChanged(function()
    State.Visuals.RemoveEffects = Toggles.RemoveEffectsToggle.Value
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") then
            v.Enabled = not State.Visuals.RemoveEffects
        end
    end
end)

-- Camera
local VisualCameraBox = Tabs.Visuals:AddLeftGroupbox('Camera')

VisualCameraBox:AddToggle('CustomFOVToggle', {
    Text = 'Custom FOV',
    Default = false
}):OnChanged(function()
    State.Visuals.CustomFOV = Toggles.CustomFOVToggle.Value
    if not State.Visuals.CustomFOV then
        Camera.FieldOfView = 70
    end
end)

VisualCameraBox:AddSlider('FOVSlider', {
    Text = 'Field of View',
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0
}):OnChanged(function()
    State.Visuals.FOVValue = Options.FOVSlider.Value
    if State.Visuals.CustomFOV then
        Camera.FieldOfView = State.Visuals.FOVValue
    end
end)

VisualCameraBox:AddToggle('ThirdPersonToggle', {
    Text = 'Force Third Person',
    Default = false
}):OnChanged(function()
    State.Visuals.ThirdPerson = Toggles.ThirdPersonToggle.Value
end)

VisualCameraBox:AddSlider('ThirdPersonDist', {
    Text = 'Camera Distance',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0
}):OnChanged(function()
    State.Visuals.ThirdPersonDistance = Options.ThirdPersonDist.Value
end)

-- Character Visuals
local VisualCharBox = Tabs.Visuals:AddRightGroupbox('Character Modifications')

VisualCharBox:AddToggle('BigHeadToggle', {
    Text = 'Big Head (Others)',
    Default = false,
    Tooltip = 'Enlarge other player heads'
}):OnChanged(function()
    State.Visuals.BigHead = Toggles.BigHeadToggle.Value
end)

VisualCharBox:AddSlider('BigHeadSizeSlider', {
    Text = 'Head Size',
    Default = 5,
    Min = 2,
    Max = 15,
    Rounding = 0
}):OnChanged(function()
    State.Visuals.BigHeadSize = Options.BigHeadSizeSlider.Value
end)

VisualCharBox:AddToggle('TransparentToggle', {
    Text = 'Transparent Character',
    Default = false,
    Tooltip = 'Make your character see-through'
}):OnChanged(function()
    State.Visuals.TransparentCharacter = Toggles.TransparentToggle.Value
    local char = Utils.GetCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                if State.Visuals.TransparentCharacter then
                    part.LocalTransparencyModifier = State.Visuals.TransparencyValue
                else
                    part.LocalTransparencyModifier = 0
                end
            end
        end
    end
end)

VisualCharBox:AddSlider('TransparencySlider', {
    Text = 'Transparency',
    Default = 50,
    Min = 10,
    Max = 90,
    Rounding = 0
}):OnChanged(function()
    State.Visuals.TransparencyValue = Options.TransparencySlider.Value / 100
end)

VisualCharBox:AddToggle('NoArmsToggle', {
    Text = 'Remove Arms (First Person)',
    Default = false
}):OnChanged(function()
    State.Visuals.NoArms = Toggles.NoArmsToggle.Value
    local char = Utils.GetCharacter()
    if char then
        for _, name in pairs({"Left Arm", "Right Arm", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand"}) do
            local part = char:FindFirstChild(name)
            if part then
                if State.Visuals.NoArms then
                    part.LocalTransparencyModifier = 1
                else
                    part.LocalTransparencyModifier = 0
                end
            end
        end
    end
end)

VisualCharBox:AddButton({
    Text = 'Invisible Character (Local)',
    Func = function()
        local char = Utils.GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 1
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = 1
                end
            end
            Utils.Notify("Visuals", "Character invisible locally")
        end
    end
})

VisualCharBox:AddButton({
    Text = 'Restore Character Visuals',
    Func = function()
        local char = Utils.GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 0
                end
            end
            Utils.Notify("Visuals", "Character restored")
        end
    end
})

-- =====================================================
-- TELEPORT TAB
-- =====================================================

local TPPlayerBox = Tabs.Teleport:AddLeftGroupbox('Player Teleport')

TPPlayerBox:AddDropdown('TPTargetDropdown', {
    Values = Utils.GetPlayerList(),
    Default = 1,
    Multi = false,
    Text = 'Target Player'
})

TPPlayerBox:AddButton({
    Text = 'Refresh Player List',
    Func = function()
        local list = Utils.GetPlayerList()
        Options.TPTargetDropdown:SetValues(list)
        Options.FlingTargetDropdown:SetValues(list)
        Utils.Notify("Teleport", "Player list refreshed")
    end
})

TPPlayerBox:AddButton({
    Text = 'Teleport to Player',
    Func = function()
        local selected = Options.TPTargetDropdown.Value
        local target = Players:FindFirstChild(selected)
        if target and target.Character then
            local tHRP = Utils.GetRootPart(target)
            local hrp = Utils.GetRootPart()
            if tHRP and hrp then
                hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)
                Utils.Notify("TP", "Teleported to " .. selected)
            end
        else
            Utils.Notify("TP", "Player not found")
        end
    end
})

TPPlayerBox:AddButton({
    Text = 'Teleport Behind Player',
    Func = function()
        local selected = Options.TPTargetDropdown.Value
        local target = Players:FindFirstChild(selected)
        if target and target.Character then
            local tHRP = Utils.GetRootPart(target)
            local hrp = Utils.GetRootPart()
            if tHRP and hrp then
                hrp.CFrame = tHRP.CFrame * CFrame.new(0, 0, -5)
                Utils.Notify("TP", "Teleported behind " .. selected)
            end
        end
    end
})

TPPlayerBox:AddButton({
    Text = 'Teleport Above Player',
    Func = function()
        local selected = Options.TPTargetDropdown.Value
        local target = Players:FindFirstChild(selected)
        if target and target.Character then
            local tHRP = Utils.GetRootPart(target)
            local hrp = Utils.GetRootPart()
            if tHRP and hrp then
                hrp.CFrame = tHRP.CFrame * CFrame.new(0, 30, 0)
                Utils.Notify("TP", "Teleported above " .. selected)
            end
        end
    end
})

TPPlayerBox:AddButton({
    Text = 'Tween to Player (Smooth)',
    Func = function()
        local selected = Options.TPTargetDropdown.Value
        local target = Players:FindFirstChild(selected)
        if target and target.Character then
            local tHRP = Utils.GetRootPart(target)
            local hrp = Utils.GetRootPart()
            if tHRP and hrp then
                local tweenInfo = TweenInfo.new(
                    (hrp.Position - tHRP.Position).Magnitude / 100,
                    Enum.EasingStyle.Linear
                )
                local tween = TweenService:Create(hrp, tweenInfo, {CFrame = tHRP.CFrame * CFrame.new(0, 0, 3)})
                tween:Play()
                Utils.Notify("TP", "Tweening to " .. selected)
            end
        end
    end
})

-- Location Teleport
local TPLocationBox = Tabs.Teleport:AddRightGroupbox('Positions')

TPLocationBox:AddButton({
    Text = 'Save Current Position',
    Func = function()
        local hrp = Utils.GetRootPart()
        if hrp then
            local name = "Pos_" .. #State.Teleport.SavedPositions + 1
            table.insert(State.Teleport.SavedPositions, {
                name = name,
                cframe = hrp.CFrame
            })
            Utils.Notify("TP", "Position saved as " .. name)
        end
    end
})

TPLocationBox:AddButton({
    Text = 'Load Last Saved Position',
    Func = function()
        if #State.Teleport.SavedPositions > 0 then
            local last = State.Teleport.SavedPositions[#State.Teleport.SavedPositions]
            local hrp = Utils.GetRootPart()
            if hrp then
                hrp.CFrame = last.cframe
                Utils.Notify("TP", "Loaded position: " .. last.name)
            end
        else
            Utils.Notify("TP", "No saved positions")
        end
    end
})

TPLocationBox:AddButton({
    Text = 'Clear All Saved Positions',
    Func = function()
        State.Teleport.SavedPositions = {}
        Utils.Notify("TP", "All positions cleared")
    end
})

TPLocationBox:AddDivider()

TPLocationBox:AddButton({
    Text = 'Teleport Up (100 studs)',
    Func = function()
        local hrp = Utils.GetRootPart()
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0)
        end
    end
})

TPLocationBox:AddButton({
    Text = 'Teleport Forward (50 studs)',
    Func = function()
        local hrp = Utils.GetRootPart()
        if hrp then
            hrp.CFrame = hrp.CFrame + Camera.CFrame.LookVector * 50
        end
    end
})

TPLocationBox:AddButton({
    Text = 'Teleport to Map Center',
    Func = function()
        local map = Utils.GetMap()
        if map then
            local hrp = Utils.GetRootPart()
            if hrp then
                local center = map:GetBoundingBox()
                hrp.CFrame = center + Vector3.new(0, 10, 0)
                Utils.Notify("TP", "Teleported to map center")
            end
        else
            local hrp = Utils.GetRootPart()
            if hrp then
                hrp.CFrame = CFrame.new(0, 50, 0)
            end
        end
    end
})

TPLocationBox:AddButton({
    Text = 'Random Teleport',
    Func = function()
        local hrp = Utils.GetRootPart()
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(
                math.random(-150, 150), 
                math.random(5, 50), 
                math.random(-150, 150)
            )
            Utils.Notify("TP", "Random teleport executed")
        end
    end
})

-- =====================================================
-- MISC TAB
-- =====================================================

local MiscGeneralBox = Tabs.Misc:AddLeftGroupbox('General')

MiscGeneralBox:AddToggle('AntiAFKToggle', {
    Text = 'Anti-AFK',
    Default = true,
    Tooltip = 'Prevents AFK kick'
}):OnChanged(function()
    State.Misc.AntiAFK = Toggles.AntiAFKToggle.Value
    if State.Misc.AntiAFK then
        pcall(function()
            local vu = game:GetService('VirtualUser')
            LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
            end)
        end)
        Utils.Notify("Anti-AFK", "Enabled")
    end
end)

MiscGeneralBox:AddToggle('NotificationsToggle', {
    Text = 'Show Notifications',
    Default = true
}):OnChanged(function()
    State.Misc.Notifications = Toggles.NotificationsToggle.Value
end)

MiscGeneralBox:AddToggle('StreamerModeToggle', {
    Text = 'Streamer Mode',
    Default = false,
    Tooltip = 'Hides player names in ESP'
}):OnChanged(function()
    State.Misc.StreamerMode = Toggles.StreamerModeToggle.Value
end)

MiscGeneralBox:AddDivider()

MiscGeneralBox:AddButton({
    Text = 'Copy Server ID',
    Func = function()
        pcall(function()
            setclipboard(game.JobId)
            Utils.Notify("Clipboard", "Server ID copied")
        end)
    end
})

MiscGeneralBox:AddButton({
    Text = 'Copy Server Link',
    Func = function()
        pcall(function()
            setclipboard("roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId)
            Utils.Notify("Clipboard", "Server link copied")
        end)
    end
})

MiscGeneralBox:AddButton({
    Text = 'Rejoin Server',
    Func = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
    DoubleClick = true,
    Tooltip = 'Double click to confirm'
})

MiscGeneralBox:AddButton({
    Text = 'Server Hop',
    Func = function()
        pcall(function()
            local servers = HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            )
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    break
                end
            end
        end)
    end,
    DoubleClick = true
})

MiscGeneralBox:AddButton({
    Text = 'Smallest Server Hop',
    Func = function()
        pcall(function()
            local servers = HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            )
            local smallest = nil
            local smallestCount = math.huge
            for _, server in pairs(servers.data) do
                if server.playing < smallestCount and server.id ~= game.JobId and server.playing > 0 then
                    smallest = server
                    smallestCount = server.playing
                end
            end
            if smallest then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, smallest.id, LocalPlayer)
            end
        end)
    end,
    DoubleClick = true
})

-- Misc правий блок
local MiscExtraBox = Tabs.Misc:AddRightGroupbox('Extra')

MiscExtraBox:AddButton({
    Text = 'Print All Player Roles',
    Func = function()
        print("=== MM2 Roles ===")
        for _, player in pairs(Players:GetPlayers()) do
            local role = Utils.GetRole(player)
            print(player.Name .. " - " .. role)
        end
        print("=================")
        Utils.Notify("Debug", "Roles printed to console")
    end
})

MiscExtraBox:AddButton({
    Text = 'Print Game Info',
    Func = function()
        print("=== Game Info ===")
        print("Place ID: " .. game.PlaceId)
        print("Server ID: " .. game.JobId)
        print("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
        print("FPS: " .. math.floor(1 / RunService.Heartbeat:Wait()))
        print("Ping: " .. math.floor(LocalPlayer:GetNetworkPing() * 1000) .. "ms")
        print("=================")
        Utils.Notify("Debug", "Info printed to console")
    end
})

MiscExtraBox:AddButton({
    Text = 'Screenshot Mode (Hide All UI)',
    Func = function()
        for _, gui in pairs(CoreGui:GetChildren()) do
            pcall(function()
                if gui:IsA("ScreenGui") then
                    gui.Enabled = not gui.Enabled
                end
            end)
        end
    end,
    DoubleClick = true
})

MiscExtraBox:AddDivider()

MiscExtraBox:AddButton({
    Text = 'Destroy Map Doors',
    Func = function()
        local count = 0
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("door") or v.Name:lower():find("gate")) then
                v:Destroy()
                count = count + 1
            end
        end
        Utils.Notify("Map", count .. " doors destroyed")
    end
})

MiscExtraBox:AddButton({
    Text = 'Remove Map Decorations',
    Func = function()
        local count = 0
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or 
               v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v:Destroy()
                count = count + 1
            end
        end
        Utils.Notify("Map", count .. " decorations removed")
    end
})

MiscExtraBox:AddButton({
    Text = 'Remove Sounds',
    Func = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Sound") then
                v:Stop()
                v.Volume = 0
            end
        end
        SoundService.AmbientReverb = Enum.ReverbType.NoReverb
        Utils.Notify("Audio", "All sounds muted")
    end
})

-- =====================================================
-- MOBILE TAB
-- =====================================================

local MobileMainBox = Tabs.Mobile:AddLeftGroupbox('Mobile Controls')

MobileMainBox:AddLabel('Touch-friendly controls panel')
MobileMainBox:AddLabel('Press button below to create')
MobileMainBox:AddLabel('floating buttons on screen')

MobileMainBox:AddSlider('MobileButtonSize', {
    Text = 'Button Size',
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 0
}):OnChanged(function()
    State.Mobile.ButtonSize = Options.MobileButtonSize.Value
end)

MobileMainBox:AddButton({
    Text = 'Create Mobile Controls',
    Func = function()
        -- Видалити попередні
        local existing = LocalPlayer.PlayerGui:FindFirstChild("MM2MobileControls")
        if existing then
            existing:Destroy()
            State.Mobile.ButtonsCreated = false
            Utils.Notify("Mobile", "Controls removed")
            return
        end
        
        local size = State.Mobile.ButtonSize
        
        local sg = Instance.new("ScreenGui")
        sg.Name = "MM2MobileControls"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = LocalPlayer.PlayerGui
        
        local buttons = {
            {text = "FLY", color = Color3.fromRGB(0, 120, 255), y = 0, func = function()
                Toggles.FlyToggle:SetValue(not Toggles.FlyToggle.Value)
            end},
            {text = "NOCLIP", color = Color3.fromRGB(150, 0, 255), y = 1, func = function()
                Toggles.NoclipToggle:SetValue(not Toggles.NoclipToggle.Value)
            end},
            {text = "SPEED", color = Color3.fromRGB(255, 140, 0), y = 2, func = function()
                Toggles.SpeedHack:SetValue(not Toggles.SpeedHack.Value)
            end},
            {text = "INF JMP", color = Color3.fromRGB(0, 200, 100), y = 3, func = function()
                Toggles.InfiniteJumpToggle:SetValue(not Toggles.InfiniteJumpToggle.Value)
            end},
            {text = "TP GUN", color = Color3.fromRGB(0, 170, 255), y = 0, x = 1, func = function()
                local gun = Utils.FindDroppedGun()
                if gun then
                    local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
                    local hrp = Utils.GetRootPart()
                    if handle and hrp then
                        hrp.CFrame = handle.CFrame * CFrame.new(0, 2, 0)
                    end
                end
            end},
            {text = "ESP", color = Color3.fromRGB(255, 50, 50), y = 1, x = 1, func = function()
                Toggles.MurdererESP:SetValue(not Toggles.MurdererESP.Value)
                Toggles.SheriffESP:SetValue(not Toggles.SheriffESP.Value)
                Toggles.GunESP:SetValue(not Toggles.GunESP.Value)
            end},
            {text = "COINS", color = Color3.fromRGB(255, 215, 0), y = 2, x = 1, func = function()
                Toggles.AutoCoinToggle:SetValue(not Toggles.AutoCoinToggle.Value)
            end},
            {text = "FULLBRT", color = Color3.fromRGB(255, 255, 100), y = 3, x = 1, func = function()
                Toggles.FullbrightToggle:SetValue(not Toggles.FullbrightToggle.Value)
            end},
        }
        
        for _, data in pairs(buttons) do
            local xPos = (data.x or 0) * (size + 5) + 10
            local yPos = data.y * (size * 0.6 + 5)
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, size, 0, size * 0.55)
            btn.Position = UDim2.new(0, xPos, 0.55, yPos)
            btn.Text = data.text
            btn.BackgroundColor3 = data.color
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = math.floor(size * 0.18)
            btn.BackgroundTransparency = 0.15
            btn.Parent = sg
            
            local corner = Instance.new("UICorner", btn)
            corner.CornerRadius = UDim.new(0, 8)
            
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.new(1, 1, 1)
            stroke.Transparency = 0.5
            stroke.Thickness = 1
            
            btn.MouseButton1Click:Connect(data.func)
        end
        
        -- Кнопка закриття
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 30, 0, 30)
        closeBtn.Position = UDim2.new(0, size * 2 + 25, 0.55, -35)
        closeBtn.Text = "X"
        closeBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14
        closeBtn.Parent = sg
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
        
        closeBtn.MouseButton1Click:Connect(function()
            sg:Destroy()
            State.Mobile.ButtonsCreated = false
        end)
        
        State.Mobile.ButtonsCreated = true
        Utils.Notify("Mobile", "Controls created - 8 buttons")
    end
})

local MobileInfoBox = Tabs.Mobile:AddRightGroupbox('Mobile Information')

MobileInfoBox:AddLabel('Supported Features:')
MobileInfoBox:AddLabel('- All movement hacks')
MobileInfoBox:AddLabel('- Fly with joystick')
MobileInfoBox:AddLabel('- Touch ESP toggle')
MobileInfoBox:AddLabel('- Auto coin collection')
MobileInfoBox:AddLabel('- Quick gun teleport')
MobileInfoBox:AddLabel('')
MobileInfoBox:AddLabel('Fly Controls (Mobile):')
MobileInfoBox:AddLabel('- Use joystick to move')
MobileInfoBox:AddLabel('- Jump button = ascend')
MobileInfoBox:AddLabel('')
MobileInfoBox:AddLabel('Menu Toggle: Press RightControl')
MobileInfoBox:AddLabel('or use the keybind in settings')

MobileInfoBox:AddButton({
    Text = 'Quick TP to Gun',
    Func = function()
        local gun = Utils.FindDroppedGun()
        if gun then
            local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
            local hrp = Utils.GetRootPart()
            if handle and hrp then
                hrp.CFrame = handle.CFrame * CFrame.new(0, 2, 0)
                Utils.Notify("Mobile", "Teleported to gun")
            end
        else
            Utils.Notify("Mobile", "No gun found")
        end
    end
})

MobileInfoBox:AddButton({
    Text = 'Quick Show Roles',
    Func = function()
        local m = Utils.FindMurderer()
        local s = Utils.FindSheriff()
        local msg = "Murderer: " .. (m and m.Name or "Unknown") .. 
                    " | Sheriff: " .. (s and s.Name or "Unknown")
        Utils.Notify("Roles", msg)
    end
})

-- =====================================================
-- SETTINGS TAB
-- =====================================================

local SettingsMainBox = Tabs.Settings:AddLeftGroupbox('Menu Settings')

SettingsMainBox:AddButton({
    Text = 'Unload Script',
    Func = function()
        -- Cleanup
        ESP.ClearAll()
        ESP.ClearCoins()
        ESP.ClearDrawings()
        Fly.Stop()
        Fling.Stop()
        
        for name, _ in pairs(State.Connections) do
            Utils.Disconnect(name)
        end
        
        -- Remove mobile controls
        local mc = LocalPlayer.PlayerGui:FindFirstChild("MM2MobileControls")
        if mc then mc:Destroy() end
        
        -- Restore visuals
        if State.Visuals.Fullbright then
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
        
        if State.Game.Xray then
            Xray.Disable()
        end
        
        Library:Unload()
    end,
    DoubleClick = true,
    Tooltip = 'Double click to unload'
})

SettingsMainBox:AddLabel('Menu Toggle Keybind:'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Menu Toggle'
})

Library.ToggleKeybind = Options.MenuKeybind

local SettingsInfoBox = Tabs.Settings:AddRightGroupbox('Information')

SettingsInfoBox:AddLabel('MM2 Professional Hub')
SettingsInfoBox:AddLabel('Version: 3.0')
SettingsInfoBox:AddLabel('UI: LinoriaLib')
SettingsInfoBox:AddLabel('Tabs: 9')
SettingsInfoBox:AddLabel('')
SettingsInfoBox:AddLabel('Features:')
SettingsInfoBox:AddLabel('Movement: 7 modules')
SettingsInfoBox:AddLabel('ESP: 12 options')
SettingsInfoBox:AddLabel('Combat: 8 modules')
SettingsInfoBox:AddLabel('Game: 6 auto functions')
SettingsInfoBox:AddLabel('Visuals: 14 options')
SettingsInfoBox:AddLabel('Teleport: 10 functions')
SettingsInfoBox:AddLabel('Mobile: Full support')

-- Theme та Save менеджери
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('MM2ProfessionalHub')
SaveManager:SetFolder('MM2ProfessionalHub/configs')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

-- =====================================================
-- ГОЛОВНІ ЦИКЛИ
-- =====================================================

-- Noclip
Utils.Connect("NoclipLoop", RunService.Stepped:Connect(function()
    if State.Movement.Noclip then
        local char = Utils.GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end))

-- Speed, Jump, BunnyHop, SpinBot, Third Person, FOV, GodMode, AntiVoid, Hitbox
Utils.Connect("MainLoop", RunService.Heartbeat:Connect(function()
    local hum = Utils.GetHumanoid()
    local hrp = Utils.GetRootPart()
    
    if hum then
        -- Speed
        if State.Movement.Speed then
            hum.WalkSpeed = State.Movement.SpeedValue
        end
        
        -- Jump
        if State.Movement.Jump then
            hum.JumpPower = State.Movement.JumpValue
            hum.UseJumpPower = true
        end
        
        -- BunnyHop
        if State.Movement.BunnyHop and hum.MoveDirection.Magnitude > 0 then
            if hum:GetState() == Enum.HumanoidStateType.Running or 
               hum:GetState() == Enum.HumanoidStateType.RunningNoPhysics then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
    
    -- SpinBot
    if State.Movement.SpinBot and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(State.Movement.SpinSpeed), 0)
    end
    
    -- Third Person
    if State.Visuals.ThirdPerson then
        LocalPlayer.CameraMinZoomDistance = State.Visuals.ThirdPersonDistance
        LocalPlayer.CameraMaxZoomDistance = State.Visuals.ThirdPersonDistance
    end
    
    -- FOV
    if State.Visuals.CustomFOV then
        Camera.FieldOfView = State.Visuals.FOVValue
    end
    
    -- God Mode
    if State.Game.GodMode and hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end
    
    -- Anti-Void
    if State.Game.AntiVoid and hrp then
        if hrp.Position.Y < State.Game.AntiVoidHeight then
            hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    -- Hitbox Expander
    if State.Combat.Hitbox then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(
                        State.Combat.HitboxSize, 
                        State.Combat.HitboxSize, 
                        State.Combat.HitboxSize
                    )
                    head.Transparency = 0.7
                    head.CanCollide = false
                end
            end
        end
    end
    
    -- Big Head
    if State.Visuals.BigHead then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(
                        State.Visuals.BigHeadSize,
                        State.Visuals.BigHeadSize,
                        State.Visuals.BigHeadSize
                    )
                    local mesh = head:FindFirstChildOfClass("SpecialMesh")
                    if mesh then
                        mesh.Scale = Vector3.new(1.25, 1.25, 1.25) * (State.Visuals.BigHeadSize / 5)
                    end
                end
            end
        end
    end
    
    -- Transparent character continuous
    if State.Visuals.TransparentCharacter then
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.LocalTransparencyModifier = State.Visuals.TransparencyValue
                end
            end
        end
    end
end))

-- Infinite Jump
Utils.Connect("InfiniteJump", UserInputService.JumpRequest:Connect(function()
    if State.Movement.InfiniteJump then
        local hum = Utils.GetHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

-- ESP оновлення
spawn(function()
    while task.wait(0.8) do
        pcall(function()
            -- Кешування ролей
            State.Cache.Murderer = Utils.FindMurderer()
            State.Cache.Sheriff = Utils.FindSheriff()
            State.Cache.MyRole = Utils.GetRole()
            
            -- Підрахунок живих
            local alive = 0
            for _, player in pairs(Players:GetPlayers()) do
                if Utils.IsAlive(player) then
                    alive = alive + 1
                end
            end
            
            -- Оновлення лейблів
            pcall(function()
                local mName = State.Cache.Murderer and State.Cache.Murderer.Name or "Scanning..."
                local sName = State.Cache.Sheriff and State.Cache.Sheriff.Name or "Scanning..."
                
                if State.Misc.StreamerMode then
                    mName = State.Cache.Murderer and "Player_" .. string.sub(State.Cache.Murderer.UserId, 1, 4) or "Scanning..."
                    sName = State.Cache.Sheriff and "Player_" .. string.sub(State.Cache.Sheriff.UserId, 1, 4) or "Scanning..."
                end
                
                MurdererInfoLabel:SetText("Murderer: " .. mName)
                SheriffInfoLabel:SetText("Sheriff: " .. sName)
                MyRoleInfoLabel:SetText("Your Role: " .. State.Cache.MyRole)
                PlayersAliveLabel:SetText("Players Alive: " .. alive)
            end)
            
            -- Murderer ESP
            if State.ESP.Murderer and State.Cache.Murderer then
                local displayName = State.Misc.StreamerMode and "HIDDEN" or State.Cache.Murderer.Name
                ESP.CreatePlayerESP(State.Cache.Murderer, State.ESP.Colors.Murderer, "MURDERER [" .. displayName .. "]")
            end
            
            -- Sheriff ESP
            if State.ESP.Sheriff and State.Cache.Sheriff then
                local displayName = State.Misc.StreamerMode and "HIDDEN" or State.Cache.Sheriff.Name
                ESP.CreatePlayerESP(State.Cache.Sheriff, State.ESP.Colors.Sheriff, "SHERIFF [" .. displayName .. "]")
            end
            
            -- All Players ESP
            if State.ESP.AllPlayers then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local color = State.ESP.Colors.Innocent
                        local text = "Innocent"
                        
                        if State.Cache.Murderer and player == State.Cache.Murderer then
                            color = State.ESP.Colors.Murderer
                            text = "MURDERER"
                        elseif State.Cache.Sheriff and player == State.Cache.Sheriff then
                            color = State.ESP.Colors.Sheriff
                            text = "SHERIFF"
                        end
                        
                        local displayName = State.Misc.StreamerMode and "HIDDEN" or player.Name
                        ESP.CreatePlayerESP(player, color, text .. " [" .. displayName .. "]")
                    end
                end
            end
            
            -- Gun ESP
            if State.ESP.Gun then
                ESP.CreateGunESP()
            end
            
            -- Coin ESP refresh
            if State.ESP.Coins then
                ESP.CreateCoinESP()
            end
            
            -- Distance update
            ESP.UpdateDistance()
        end)
    end
end)

-- Auto Coin
spawn(function()
    while task.wait(0.25) do
        if State.Game.AutoCoin then
            pcall(function()
                local coins = Utils.FindCoins()
                local hrp = Utils.GetRootPart()
                if hrp and #coins > 0 then
                    -- Найближча монета
                    local closest = nil
                    local closestDist = math.huge
                    
                    for _, coin in pairs(coins) do
                        if coin:IsA("BasePart") then
                            local dist = (hrp.Position - coin.Position).Magnitude
                            if dist < closestDist then
                                closest = coin
                                closestDist = dist
                            end
                        end
                    end
                    
                    if closest then
                        if State.Game.AutoCoinMethod == "Teleport" then
                            if closestDist > 5 then
                                local orig = hrp.CFrame
                                hrp.CFrame = closest.CFrame
                                task.wait(0.12)
                                hrp.CFrame = orig
                            end
                        elseif State.Game.AutoCoinMethod == "Tween" then
                            if closestDist > 5 then
                                local ti = TweenInfo.new(closestDist / 150, Enum.EasingStyle.Linear)
                                local tween = TweenService:Create(hrp, ti, {CFrame = closest.CFrame})
                                tween:Play()
                                tween.Completed:Wait()
                            end
                        elseif State.Game.AutoCoinMethod == "Pathfind" then
                            pcall(function()
                                local path = PathfindingService:CreatePath()
                                path:ComputeAsync(hrp.Position, closest.Position)
                                local waypoints = path:GetWaypoints()
                                local hum = Utils.GetHumanoid()
                                if hum then
                                    for _, wp in pairs(waypoints) do
                                        hum:MoveTo(wp.Position)
                                        hum.MoveToFinished:Wait()
                                    end
                                end
                            end)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Grab Gun
spawn(function()
    while task.wait(0.4) do
        if State.Game.AutoGrabGun then
            pcall(function()
                local gun = Utils.FindDroppedGun()
                if gun then
                    local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
                    local hrp = Utils.GetRootPart()
                    if handle and hrp then
                        hrp.CFrame = handle.CFrame
                        task.wait(0.15)
                        
                        pcall(function()
                            local hum = Utils.GetHumanoid()
                            if hum then hum:EquipTool(gun) end
                        end)
                        
                        pcall(function()
                            for _, v in pairs(gun:GetDescendants()) do
                                if v:IsA("ProximityPrompt") then
                                    fireproximityprompt(v)
                                end
                            end
                        end)
                        
                        Utils.Notify("Auto Gun", "Gun picked up")
                    end
                end
            end)
        end
    end
end)

-- Auto Equip
spawn(function()
    while task.wait(0.5) do
        if State.Game.AutoEquip then
            pcall(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    local hum = Utils.GetHumanoid()
                    if hum then
                        local gun = backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver")
                        local knife = backpack:FindFirstChild("Knife")
                        if gun then
                            hum:EquipTool(gun)
                        elseif knife then
                            hum:EquipTool(knife)
                        end
                    end
                end
            end)
        end
    end
end)

-- Anti-Knife
spawn(function()
    while task.wait(0.15) do
        if State.Combat.AntiKnife then
            pcall(function()
                local murderer = State.Cache.Murderer
                local hrp = Utils.GetRootPart()
                
                if murderer and murderer.Character and hrp then
                    local mHRP = Utils.GetRootPart(murderer)
                    if mHRP then
                        local dist = (hrp.Position - mHRP.Position).Magnitude
                        
                        if dist < State.Combat.AntiKnifeDistance then
                            local direction = (hrp.Position - mHRP.Position).Unit
                            local dodgeDist = State.Combat.AntiKnifeDistance - dist + 10
                            hrp.CFrame = hrp.CFrame + direction * dodgeDist
                            
                            if dist < 8 then
                                Utils.Notify("WARNING", "Murderer " .. math.floor(dist) .. " studs away")
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Killer Aura
spawn(function()
    while task.wait(0.3) do
        if State.Combat.KillerAura and State.Cache.MyRole == "Sheriff" then
            pcall(function()
                local murderer = State.Cache.Murderer
                if murderer and murderer.Character then
                    local hrp = Utils.GetRootPart()
                    local tHRP = Utils.GetRootPart(murderer)
                    
                    if hrp and tHRP then
                        local dist = (hrp.Position - tHRP.Position).Magnitude
                        
                        if dist < State.Combat.KillerAuraRange then
                            local char = Utils.GetCharacter()
                            local gun = char and (char:FindFirstChild("Gun") or char:FindFirstChild("Revolver"))
                            
                            if not gun then
                                local backpack = LocalPlayer:FindFirstChild("Backpack")
                                if backpack then
                                    gun = backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver")
                                    if gun then
                                        Utils.GetHumanoid():EquipTool(gun)
                                        task.wait(0.1)
                                    end
                                end
                            end
                            
                            if gun then
                                local targetPart = murderer.Character:FindFirstChild(State.Combat.AimTarget) or
                                                   murderer.Character:FindFirstChild("Head")
                                if targetPart then
                                    for _, v in pairs(gun:GetDescendants()) do
                                        if v:IsA("RemoteEvent") then
                                            v:FireServer(targetPart.Position)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Role notification
spawn(function()
    local lastMurderer = nil
    local lastSheriff = nil
    
    while task.wait(1.5) do
        if State.Game.NotifyRoles then
            local m = State.Cache.Murderer
            local s = State.Cache.Sheriff
            
            if m and m ~= lastMurderer then
                Utils.Notify("Role Detected", "Murderer: " .. m.Name)
                lastMurderer = m
            end
            
            if s and s ~= lastSheriff then
                Utils.Notify("Role Detected", "Sheriff: " .. s.Name)
                lastSheriff = s
            end
        end
    end
end)

-- X-Ray refresh
spawn(function()
    while task.wait(3) do
        if State.Game.Xray then
            Xray.Enable()
        end
    end
end)

-- Cleanup on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    
    if State.Movement.Fly then
        Fly.Stop()
        task.wait(0.5)
        Fly.Start()
    end
    
    ESP.ClearAll()
    
    -- Restore hitbox sizes if disabled
    if not State.Combat.Hitbox then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(1.2, 1.2, 1.2)
                    head.Transparency = 0
                end
                end
        end
    end
end)

-- Cleanup when players leave
Players.PlayerRemoving:Connect(function(player)
    ESP.ClearPlayer(player.Name)
end)

-- Anti-AFK initial
pcall(function()
    local vu = game:GetService('VirtualUser')
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end)

-- =====================================================
-- ЗАВЕРШЕННЯ
-- =====================================================

Utils.Notify("MM2 Hub", "Script loaded successfully")
Utils.Notify("Controls", "Press End to toggle menu")
Utils.Notify("Version", "3.0 Professional Edition | 9 tabs | 60+ features")
