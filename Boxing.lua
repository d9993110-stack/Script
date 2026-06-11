--// Завантаження бібліотеки UI
local Library = loadstring(game:HttpGet("YOUR_UI_LIBRARY_URL"))()

--// Сервіси
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

--// Гравець
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--// Автооновлення персонажа
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

--// Змінні стану
local States = {
    -- Player
    Speed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    Noclip = false,
    InfiniteJump = false,
    Fly = false,
    FlySpeed = 50,
    GodMode = false,
    Invisible = false,
    
    -- Combat
    Aimbot = false,
    AimbotFOV = 200,
    AimbotSmooth = 5,
    AimbotBone = "Head",
    ShowFOV = false,
    SilentAim = false,
    Hitbox = false,
    HitboxSize = 5,
    KillAura = false,
    KillAuraRange = 15,
    
    -- ESP
    ESPEnabled = false,
    ESPBoxes = false,
    ESPNames = false,
    ESPHealth = false,
    ESPDistance = false,
    ESPTracers = false,
    ESPChams = false,
    ESPTeamCheck = true,
    
    -- World
    Fullbright = false,
    NoFog = false,
    CustomTime = false,
    TimeValue = 12,
    AntiAFK = true,
    
    -- Teleport
    TeleportTarget = "",
    
    -- Misc
    ChatSpam = false,
    ChatSpamMessage = "Hello!",
    ChatSpamDelay = 1,
    ClickTP = false,
    FreeCam = false,
    FreeCamSpeed = 1,
}

--// Створення вікна
local Window = Library:CreateWindow({
    Title = "🎮 Ultra Cheat v2.0",
    Size = UDim2.new(0, 550, 0, 400),
    Transparency = 0,
    MinimizeKeybind = Enum.KeyCode.RightControl,
    Blurring = true,
    Theme = "Dark"
})

-- ══════════════════════════════════════════
-- 🏃 ВКЛАДКА: PLAYER (Гравець)
-- ══════════════════════════════════════════

local PlayerTab = Window:AddTab({
    Title = "🏃 Player",
    Icon = "rbxassetid://7733964719",
})

Window:AddSection({ Name = "Movement", Tab = PlayerTab })

-- Speed Hack
Window:AddSlider({
    Title = "🏃 Walk Speed",
    Description = "Змінити швидкість ходьби",
    MaxValue = 500,
    AllowDecimals = false,
    Tab = PlayerTab,
    Callback = function(Value)
        States.Speed = Value
        if Character and Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

-- Jump Power
Window:AddSlider({
    Title = "⬆️ Jump Power",
    Description = "Змінити силу стрибка",
    MaxValue = 500,
    AllowDecimals = false,
    Tab = PlayerTab,
    Callback = function(Value)
        States.JumpPower = Value
        if Character and Humanoid then
            Humanoid.JumpPower = Value
            Humanoid.UseJumpPower = true
        end
    end
})

-- Gravity
Window:AddSlider({
    Title = "🌍 Gravity",
    Description = "Змінити гравітацію (196 = нормальна)",
    MaxValue = 500,
    AllowDecimals = true,
    DecimalAmount = 1,
    Tab = PlayerTab,
    Callback = function(Value)
        States.Gravity = Value
        Workspace.Gravity = Value
    end
})

-- Infinite Jump
Window:AddToggle({
    Title = "♾️ Infinite Jump",
    Description = "Стрибати безкінечно у повітрі",
    Default = false,
    Tab = PlayerTab,
    Callback = function(Value)
        States.InfiniteJump = Value
    end
})

UserInputService.JumpRequest:Connect(function()
    if States.InfiniteJump and Character and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip
Window:AddToggle({
    Title = "👻 Noclip",
    Description = "Проходити крізь стіни",
    Default = false,
    Tab = PlayerTab,
    Callback = function(Value)
        States.Noclip = Value
    end
})

RunService.Stepped:Connect(function()
    if States.Noclip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
Window:AddToggle({
    Title = "🕊️ Fly",
    Description = "Літати у повітрі",
    Default = false,
    Tab = PlayerTab,
    Callback = function(Value)
        States.Fly = Value
        if Value then
            -- Create BodyVelocity & BodyGyro
            if HumanoidRootPart then
                local BV = Instance.new("BodyVelocity")
                BV.Name = "FlyVelocity"
                BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                BV.Velocity = Vector3.new(0, 0, 0)
                BV.Parent = HumanoidRootPart
                
                local BG = Instance.new("BodyGyro")
                BG.Name = "FlyGyro"
                BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                BG.D = 200
                BG.P = 10000
                BG.Parent = HumanoidRootPart
            end
        else
            if HumanoidRootPart then
                local BV = HumanoidRootPart:FindFirstChild("FlyVelocity")
                local BG = HumanoidRootPart:FindFirstChild("FlyGyro")
                if BV then BV:Destroy() end
                if BG then BG:Destroy() end
            end
        end
    end
})

Window:AddSlider({
    Title = "🕊️ Fly Speed",
    Description = "Швидкість польоту",
    MaxValue = 300,
    AllowDecimals = false,
    Tab = PlayerTab,
    Callback = function(Value)
        States.FlySpeed = Value
    end
})

RunService.RenderStepped:Connect(function()
    if States.Fly and HumanoidRootPart then
        local BV = HumanoidRootPart:FindFirstChild("FlyVelocity")
        local BG = HumanoidRootPart:FindFirstChild("FlyGyro")
        
        if BV and BG then
            BG.CFrame = Camera.CFrame
            local Direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                Direction = Direction + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                Direction = Direction - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                Direction = Direction - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                Direction = Direction + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                Direction = Direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                Direction = Direction - Vector3.new(0, 1, 0)
            end
            
            BV.Velocity = Direction * States.FlySpeed
            Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end
    end
end)

Window:AddSection({ Name = "Character", Tab = PlayerTab })

-- God Mode
Window:AddToggle({
    Title = "❤️ God Mode",
    Description = "Нескінченне здоров'я (клієнтське)",
    Default = false,
    Tab = PlayerTab,
    Callback = function(Value)
        States.GodMode = Value
    end
})

RunService.Heartbeat:Connect(function()
    if States.GodMode and Character and Humanoid then
        Humanoid.Health = Humanoid.MaxHealth
    end
end)

-- Reset Character
Window:AddButton({
    Title = "💀 Reset Character",
    Description = "Перезапустити персонажа",
    Tab = PlayerTab,
    Callback = function()
        if Humanoid then
            Humanoid.Health = 0
        end
    end
})

-- Respawn
Window:AddButton({
    Title = "🔄 Respawn",
    Description = "Респавн персонажа",
    Tab = PlayerTab,
    Callback = function()
        LocalPlayer:LoadCharacter()
    end
})

-- ══════════════════════════════════════════
-- ⚔️ ВКЛАДКА: COMBAT (Бойовий)
-- ══════════════════════════════════════════

local CombatTab = Window:AddTab({
    Title = "⚔️ Combat",
    Icon = "rbxassetid://7733960981",
})

Window:AddSection({ Name = "Aimbot", Tab = CombatTab })

-- Aimbot Toggle
Window:AddToggle({
    Title = "🎯 Aimbot",
    Description = "Автоматичне наведення на гравців",
    Default = false,
    Tab = CombatTab,
    Callback = function(Value)
        States.Aimbot = Value
    end
})

-- Aimbot FOV
Window:AddSlider({
    Title = "🔴 FOV Size",
    Description = "Радіус поля зору аімбота",
    MaxValue = 800,
    AllowDecimals = false,
    Tab = CombatTab,
    Callback = function(Value)
        States.AimbotFOV = Value
    end
})

-- Aimbot Smoothness
Window:AddSlider({
    Title = "🎯 Smoothness",
    Description = "Плавність наведення (1 = миттєво)",
    MaxValue = 50,
    AllowDecimals = true,
    DecimalAmount = 1,
    Tab = CombatTab,
    Callback = function(Value)
        States.AimbotSmooth = Value
    end
})

-- Show FOV Circle
Window:AddToggle({
    Title = "⭕ Show FOV Circle",
    Description = "Показати коло FOV на екрані",
    Default = false,
    Tab = CombatTab,
    Callback = function(Value)
        States.ShowFOV = Value
    end
})

-- Aimbot Bone
Window:AddDropdown({
    Title = "🦴 Target Bone",
    Description = "Частина тіла для наведення",
    Options = {
        ["Head"] = "Head",
        ["HumanoidRootPart"] = "HumanoidRootPart",
        ["UpperTorso"] = "UpperTorso",
        ["LowerTorso"] = "LowerTorso",
    },
    Tab = CombatTab,
    Callback = function(Value)
        States.AimbotBone = Value
    end
})

-- FOV Circle Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = States.AimbotFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 0.8
FOVCircle.Color = Color3.fromRGB(255, 50, 50)

-- Aimbot Functions
local function GetClosestPlayer()
    local ClosestPlayer = nil
    local ShortestDistance = States.AimbotFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local targetPart = char:FindFirstChild(States.AimbotBone) or char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and targetPart then
                if States.ESPTeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < ShortestDistance then
                        ShortestDistance = distance
                        ClosestPlayer = player
                    end
                end
            end
        end
    end
    
    return ClosestPlayer
end

RunService.RenderStepped:Connect(function()
    -- FOV Circle
    FOVCircle.Visible = States.ShowFOV
    FOVCircle.Radius = States.AimbotFOV
    FOVCircle.Position = UserInputService:GetMouseLocation()
    
    -- Aimbot
    if States.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(States.AimbotBone) or target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local targetPos = Camera:WorldToScreenPoint(targetPart.Position)
                local mousePos = UserInputService:GetMouseLocation()
                
                local smoothFactor = 1 / math.max(States.AimbotSmooth, 0.1)
                Camera.CFrame = Camera.CFrame:Lerp(
                    CFrame.new(Camera.CFrame.Position, targetPart.Position),
                    smoothFactor
                )
            end
        end
    end
end)

Window:AddSection({ Name = "Melee & Misc", Tab = CombatTab })

-- Hitbox Expander
Window:AddToggle({
    Title = "📦 Hitbox Expander",
    Description = "Збільшити хітбокси гравців",
    Default = false,
    Tab = CombatTab,
    Callback = function(Value)
        States.Hitbox = Value
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if Value then
                        hrp.Size = Vector3.new(States.HitboxSize, States.HitboxSize, States.HitboxSize)
                        hrp.Transparency = 0.5
                    else
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                    end
                end
            end
        end
    end
})

Window:AddSlider({
    Title = "📦 Hitbox Size",
    Description = "Розмір хітбоксу",
    MaxValue = 50,
    AllowDecimals = false,
    Tab = CombatTab,
    Callback = function(Value)
        States.HitboxSize = Value
    end
})

-- Kill Aura
Window:AddToggle({
    Title = "💫 Kill Aura",
    Description = "Автоматичне вбивство поблизу (якщо підтримується)",
    Default = false,
    Tab = CombatTab,
    Callback = function(Value)
        States.KillAura = Value
    end
})

Window:AddSlider({
    Title = "💫 Kill Aura Range",
    Description = "Дальність Kill Aura",
    MaxValue = 50,
    AllowDecimals = false,
    Tab = CombatTab,
    Callback = function(Value)
        States.KillAuraRange = Value
    end
})

-- Kill Aura Loop
task.spawn(function()
    while task.wait(0.1) do
        if States.KillAura and Character and HumanoidRootPart then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    
                    if hrp and hum and hum.Health > 0 then
                        local distance = (HumanoidRootPart.Position - hrp.Position).Magnitude
                        if distance <= States.KillAuraRange then
                            -- Simulate click on nearby players
                            pcall(function()
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- ══════════════════════════════════════════
-- 👁️ ВКЛАДКА: ESP (Візуалізація)
-- ══════════════════════════════════════════

local ESPTab = Window:AddTab({
    Title = "👁️ ESP",
    Icon = "rbxassetid://7733968307",
})

Window:AddSection({ Name = "Player ESP", Tab = ESPTab })

-- ESP Storage
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Line"),
        HealthBG = Drawing.new("Line"),
        Distance = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
    }
    
    -- Box
    esp.Box.Thickness = 1.5
    esp.Box.Filled = false
    esp.Box.Color = Color3.fromRGB(0, 255, 0)
    esp.Box.Visible = false
    esp.Box.ZIndex = 5
    
    -- Name
    esp.Name.Size = 14
    esp.Name.Center = true
    esp.Name.Outline = true
    esp.Name.Color = Color3.fromRGB(255, 255, 255)
    esp.Name.Visible = false
    esp.Name.ZIndex = 5
    esp.Name.Font = 2
    
    -- Health Bar BG
    esp.HealthBG.Thickness = 3
    esp.HealthBG.Color = Color3.fromRGB(0, 0, 0)
    esp.HealthBG.Visible = false
    esp.HealthBG.ZIndex = 4
    
    -- Health Bar
    esp.Health.Thickness = 1.5
    esp.Health.Color = Color3.fromRGB(0, 255, 0)
    esp.Health.Visible = false
    esp.Health.ZIndex = 5
    
    -- Distance
    esp.Distance.Size = 12
    esp.Distance.Center = true
    esp.Distance.Outline = true
    esp.Distance.Color = Color3.fromRGB(200, 200, 200)
    esp.Distance.Visible = false
    esp.Distance.ZIndex = 5
    esp.Distance.Font = 2
    
    -- Tracer
    esp.Tracer.Thickness = 1.5
    esp.Tracer.Color = Color3.fromRGB(255, 255, 0)
    esp.Tracer.Visible = false
    esp.Tracer.ZIndex = 5
    
    ESPObjects[player] = esp
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, drawing in pairs(ESPObjects[player]) do
            drawing:Remove()
        end
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        
        if char and humanoid and humanoid.Health > 0 and hrp and head then
            if States.ESPTeamCheck and player.Team == LocalPlayer.Team then
                for _, d in pairs(esp) do d.Visible = false end
                continue
            end
            
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local footPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            
            if onScreen and States.ESPEnabled then
                local boxHeight = math.abs(headPos.Y - footPos.Y)
                local boxWidth = boxHeight * 0.6
                
                -- Box ESP
                esp.Box.Visible = States.ESPBoxes
                esp.Box.Size = Vector2.new(boxWidth, boxHeight)
                esp.Box.Position = Vector2.new(pos.X - boxWidth / 2, headPos.Y)
                
                -- Team Color
                local teamColor = Color3.fromRGB(255, 0, 0)
                pcall(function()
                    if player.Team then
                        teamColor = player.TeamColor.Color
                    end
                end)
                esp.Box.Color = teamColor
                
                -- Name ESP
                esp.Name.Visible = States.ESPNames
                esp.Name.Text = player.DisplayName .. " [" .. player.Name .. "]"
                esp.Name.Position = Vector2.new(pos.X, headPos.Y - 18)
                
                -- Health ESP
                local healthPct = humanoid.Health / humanoid.MaxHealth
                esp.HealthBG.Visible = States.ESPHealth
                esp.HealthBG.From = Vector2.new(pos.X - boxWidth / 2 - 5, footPos.Y)
                esp.HealthBG.To = Vector2.new(pos.X - boxWidth / 2 - 5, headPos.Y)
                
                esp.Health.Visible = States.ESPHealth
                esp.Health.From = Vector2.new(pos.X - boxWidth / 2 - 5, footPos.Y)
                esp.Health.To = Vector2.new(pos.X - boxWidth / 2 - 5, footPos.Y - (boxHeight * healthPct))
                esp.Health.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
                
                -- Distance ESP
                local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
                esp.Distance.Visible = States.ESPDistance
                esp.Distance.Text = math.floor(dist) .. " studs"
                esp.Distance.Position = Vector2.new(pos.X, footPos.Y + 2)
                
                -- Tracer ESP
                local viewportSize = Camera.ViewportSize
                esp.Tracer.Visible = States.ESPTracers
                esp.Tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                esp.Tracer.To = Vector2.new(pos.X, footPos.Y)
                esp.Tracer.Color = teamColor
            else
                for _, d in pairs(esp) do d.Visible = false end
            end
        else
            for _, d in pairs(esp) do d.Visible = false end
        end
    end
end

-- Initialize ESP for all players
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end
Players.PlayerAdded:Connect(CreateESP)
Players.PlayerRemoving:Connect(RemoveESP)

RunService.RenderStepped:Connect(UpdateESP)

-- ESP Toggles
Window:AddToggle({
    Title = "👁️ Enable ESP",
    Description = "Увімкнути систему ESP",
    Default = false,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPEnabled = Value
        if not Value then
            for _, esp in pairs(ESPObjects) do
                for _, d in pairs(esp) do d.Visible = false end
            end
        end
    end
})

Window:AddToggle({
    Title = "📦 Box ESP",
    Description = "Показати рамки навколо гравців",
    Default = false,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPBoxes = Value
    end
})

Window:AddToggle({
    Title = "📛 Name ESP",
    Description = "Показати імена гравців",
    Default = false,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPNames = Value
    end
})

Window:AddToggle({
    Title = "❤️ Health ESP",
    Description = "Показати здоров'я гравців",
    Default = false,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPHealth = Value
    end
})

Window:AddToggle({
    Title = "📏 Distance ESP",
    Description = "Показати відстань до гравців",
    Default = false,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPDistance = Value
    end
})

Window:AddToggle({
    Title = "📍 Tracers",
    Description = "Лінії від екрану до гравців",
    Default = false,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPTracers = Value
    end
})

Window:AddToggle({
    Title = "👥 Team Check",
    Description = "Не показувати ESP тіммейтів",
    Default = true,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPTeamCheck = Value
    end
})

Window:AddSection({ Name = "Chams", Tab = ESPTab })

Window:AddToggle({
    Title = "🌈 Chams / Highlight",
    Description = "Підсвітка гравців крізь стіни",
    Default = false,
    Tab = ESPTab,
    Callback = function(Value)
        States.ESPChams = Value
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local existing = player.Character:FindFirstChild("ESPHighlight")
                if Value and not existing then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = player.Character
                elseif not Value and existing then
                    existing:Destroy()
                end
            end
        end
    end
})

-- ══════════════════════════════════════════
-- 🌍 ВКЛАДКА: WORLD (Світ)
-- ══════════════════════════════════════════

local WorldTab = Window:AddTab({
    Title = "🌍 World",
    Icon = "rbxassetid://7733971194",
})

Window:AddSection({ Name = "Lighting", Tab = WorldTab })

-- Fullbright
Window:AddToggle({
    Title = "💡 Fullbright",
    Description = "Прибрати всю темряву",
    Default = false,
    Tab = WorldTab,
    Callback = function(Value)
        States.Fullbright = Value
        
        if Value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end
})

-- No Fog
Window:AddToggle({
    Title = "🌫️ No Fog",
    Description = "Прибрати туман",
    Default = false,
    Tab = WorldTab,
    Callback = function(Value)
        States.NoFog = Value
        if Value then
            Lighting.FogStart = 0
            Lighting.FogEnd = 9999999
        else
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
        end
    end
})

-- Custom Time
Window:AddToggle({
    Title = "🕐 Custom Time",
    Description = "Встановити власний час доби",
    Default = false,
    Tab = WorldTab,
    Callback = function(Value)
        States.CustomTime = Value
    end
})

Window:AddSlider({
    Title = "🕐 Time of Day",
    Description = "Час доби (0-24)",
    MaxValue = 24,
    AllowDecimals = true,
    DecimalAmount = 1,
    Tab = WorldTab,
    Callback = function(Value)
        States.TimeValue = Value
        if States.CustomTime then
            Lighting.ClockTime = Value
        end
    end
})

RunService.RenderStepped:Connect(function()
    if States.CustomTime then
        Lighting.ClockTime = States.TimeValue
    end
end)

Window:AddSection({ Name = "Effects", Tab = WorldTab })

-- Remove Effects
Window:AddButton({
    Title = "🎨 Remove Atmosphere",
    Description = "Видалити ефекти атмосфери",
    Tab = WorldTab,
    Callback = function()
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("Atmosphere") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or
               effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") then
                effect:Destroy()
            end
        end
        Window:Notify({
            Title = "✅ Success",
            Description = "Atmosphere effects removed!",
            Duration = 2
        })
    end
})

-- Remove Decorations
Window:AddButton({
    Title = "🧹 Remove Decorations",
    Description = "Видалити декорації для FPS",
    Tab = WorldTab,
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("ParticleEmitter") or
               obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj:Destroy()
                count = count + 1
            end
        end
        Window:Notify({
            Title = "✅ Cleaned",
            Description = count .. " decorations removed!",
            Duration = 2
        })
    end
})

-- ══════════════════════════════════════════
-- 📍 ВКЛАДКА: TELEPORT (Телепортація)
-- ══════════════════════════════════════════

local TeleportTab = Window:AddTab({
    Title = "📍 Teleport",
    Icon = "rbxassetid://7733972851",
})

Window:AddSection({ Name = "Player Teleport", Tab = TeleportTab })

-- Teleport to Player
Window:AddInput({
    Title = "📍 Teleport to Player",
    Description = "Введіть ім'я гравця для телепортації",
    Tab = TeleportTab,
    Callback = function(Text)
        States.TeleportTarget = Text
    end
})

Window:AddButton({
    Title = "🚀 Teleport!",
    Description = "Телепортуватися до вказаного гравця",
    Tab = TeleportTab,
    Callback = function()
        local targetName = States.TeleportTarget:lower()
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(targetName) or player.DisplayName:lower():find(targetName) then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    Window:Notify({
                        Title = "📍 Teleported",
                        Description = "Teleported to " .. player.DisplayName,
                        Duration = 2
                    })
                    return
                end
            end
        end
        Window:Notify({
            Title = "❌ Error",
            Description = "Player not found!",
            Duration = 2
        })
    end
})

-- Click TP
Window:AddToggle({
    Title = "🖱️ Click Teleport",
    Description = "Натисніть щоб телепортуватись (Ctrl + Click)",
    Default = false,
    Tab = TeleportTab,
    Callback = function(Value)
        States.ClickTP = Value
    end
})

Mouse.Button1Down:Connect(function()
    if States.ClickTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local target = Mouse.Hit
        if target then
            HumanoidRootPart.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
        end
    end
end)

Window:AddSection({ Name = "Quick Teleports", Tab = TeleportTab })

-- Teleport to all players buttons
Window:AddButton({
    Title = "📋 Show All Players",
    Description = "Показати список всіх гравців",
    Tab = TeleportTab,
    Callback = function()
        local list = ""
        for i, player in pairs(Players:GetPlayers()) do
            list = list .. i .. ". " .. player.DisplayName .. " (" .. player.Name .. ")\n"
        end
        Window:Notify({
            Title = "📋 Players Online",
            Description = list,
            Duration = 5
        })
    end
})

-- Teleport to Random Player
Window:AddButton({
    Title = "🎲 Random Teleport",
    Description = "Телепортуватися до випадкового гравця",
    Tab = TeleportTab,
    Callback = function()
        local otherPlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(otherPlayers, player)
            end
        end
        if #otherPlayers > 0 then
            local random = otherPlayers[math.random(1, #otherPlayers)]
            HumanoidRootPart.CFrame = random.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            Window:Notify({
                Title = "🎲 Random TP",
                Description = "Teleported to " .. random.DisplayName,
                Duration = 2
            })
        end
    end
})

-- Save/Load Position
local SavedPosition = nil

Window:AddButton({
    Title = "💾 Save Position",
    Description = "Зберегти поточну позицію",
    Tab = TeleportTab,
    Callback = function()
        SavedPosition = HumanoidRootPart.CFrame
        Window:Notify({
            Title = "💾 Saved",
            Description = "Position saved!",
            Duration = 2
        })
    end
})

Window:AddButton({
    Title = "📂 Load Position",
    Description = "Повернутися до збереженої позиції",
    Tab = TeleportTab,
    Callback = function()
        if SavedPosition then
            HumanoidRootPart.CFrame = SavedPosition
            Window:Notify({
                Title = "📂 Loaded",
                Description = "Teleported to saved position!",
                Duration = 2
            })
        else
            Window:Notify({
                Title = "❌ Error",
                Description = "No position saved!",
                Duration = 2
            })
        end
    end
})

-- ══════════════════════════════════════════
-- 🛠️ ВКЛАДКА: MISC (Додаткове)
-- ══════════════════════════════════════════

local MiscTab = Window:AddTab({
    Title = "🛠️ Misc",
    Icon = "rbxassetid://7733975741",
})

Window:AddSection({ Name = "Anti", Tab = MiscTab })

-- Anti AFK
Window:AddToggle({
    Title = "🚫 Anti-AFK",
    Description = "Запобігти кікам за AFK",
    Default = true,
    Tab = MiscTab,
    Callback = function(Value)
        States.AntiAFK = Value
    end
})

-- Anti-AFK Connection
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if States.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

Window:AddSection({ Name = "Chat", Tab = MiscTab })

-- Chat Spam
Window:AddToggle({
    Title = "💬 Chat Spam",
    Description = "Автоматичний спам у чаті",
    Default = false,
    Tab = MiscTab,
    Callback = function(Value)
        States.ChatSpam = Value
    end
})

Window:AddInput({
    Title = "💬 Spam Message",
    Description = "Повідомлення для спаму",
    Tab = MiscTab,
    Callback = function(Text)
        States.ChatSpamMessage = Text
    end
})

Window:AddSlider({
    Title = "⏱️ Spam Delay",
    Description = "Затримка між повідомленнями (секунди)",
    MaxValue = 10,
    AllowDecimals = true,
    DecimalAmount = 1,
    Tab = MiscTab,
    Callback = function(Value)
        States.ChatSpamDelay = Value
    end
})

task.spawn(function()
    while true do
        if States.ChatSpam then
            pcall(function()
                local args = {
                    States.ChatSpamMessage,
                    "All"
                }
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
            end)
        end
        task.wait(States.ChatSpamDelay)
    end
end)

Window:AddSection({ Name = "Fun", Tab = MiscTab })

-- Spin
local spinning = false
local spinConnection

Window:AddToggle({
    Title = "🌀 Spin",
    Description = "Обертати персонажа",
    Default = false,
    Tab = MiscTab,
    Callback = function(Value)
        spinning = Value
        if Value then
            local spinSpeed = 20
            spinConnection = RunService.RenderStepped:Connect(function()
                if HumanoidRootPart and spinning then
                    HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
                end
            end)
        else
            if spinConnection then
                spinConnection:Disconnect()
            end
        end
    end
})

-- Headless
Window:AddButton({
    Title = "👤 Fake Headless",
    Description = "Зробити персонажа без голови (візуально)",
    Tab = MiscTab,
    Callback = function()
        if Character and Character:FindFirstChild("Head") then
            Character.Head.Transparency = 1
            for _, child in pairs(Character.Head:GetChildren()) do
                if child:IsA("Decal") or child:IsA("SpecialMesh") then
                    child.Transparency = 1
                end
            end
            -- Hide hat accessories
            for _, acc in pairs(Character:GetChildren()) do
                if acc:IsA("Accessory") then
                    local handle = acc:FindFirstChild("Handle")
                    if handle then
                        handle.Transparency = 1
                    end
                end
            end
        end
    end
})

-- Sit
Window:AddButton({
    Title = "🪑 Sit",
    Description = "Сісти",
    Tab = MiscTab,
    Callback = function()
        if Humanoid then
            Humanoid.Sit = true
        end
    end
})

-- Platform
Window:AddButton({
    Title = "🟩 Create Platform",
    Description = "Створити платформу під ногами",
    Tab = MiscTab,
    Callback = function()
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(20, 1, 20)
        platform.Position = HumanoidRootPart.Position - Vector3.new(0, 3, 0)
        platform.Anchored = true
        platform.BrickColor = BrickColor.new("Lime green")
        platform.Material = Enum.Material.Neon
        platform.Transparency = 0.3
        platform.Parent = Workspace
        
        Window:Notify({
            Title = "🟩 Platform",
            Description = "Platform created below you!",
            Duration = 2
        })
    end
})

-- Rejoin
Window:AddButton({
    Title = "🔄 Rejoin Server",
    Description = "Перезайти на сервер",
    Tab = MiscTab,
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

-- Server Hop
Window:AddButton({
    Title = "🔀 Server Hop",
    Description = "Перейти на інший сервер",
    Tab = MiscTab,
    Callback = function()
        pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            ))
            
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    break
                end
            end
        end)
    end
})

-- ══════════════════════════════════════════
-- ⚙️ ВКЛАДКА: SETTINGS (Налаштування)
-- ══════════════════════════════════════════

local SettingsTab = Window:AddTab({
    Title = "⚙️ Settings",
    Icon = "rbxassetid://7733974797",
})

Window:AddSection({ Name = "UI Settings", Tab = SettingsTab })

Window:AddParagraph({
    Title = "🎮 Ultra Cheat v2.0",
    Description = "Universal Roblox cheat script with mobile support.\nMade with ❤️\n\nHotkey: Right Control to toggle menu",
    Tab = SettingsTab,
})

Window:AddButton({
    Title = "🎨 Dark Theme",
    Description = "Встановити темну тему",
    Tab = SettingsTab,
    Callback = function()
        Window:SetSetting("Theme", {
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
        })
    end
})

Window:AddButton({
    Title = "🎨 Blue Theme",
    Description = "Встановити синю тему",
    Tab = SettingsTab,
    Callback = function()
        Window:SetSetting("Theme", {
            Primary = Color3.fromRGB(20, 25, 40),
            Secondary = Color3.fromRGB(25, 30, 50),
            Component = Color3.fromRGB(30, 40, 60),
            Interactables = Color3.fromRGB(40, 50, 75),
            Tab = Color3.fromRGB(150, 180, 255),
            Title = Color3.fromRGB(200, 220, 255),
            Description = Color3.fromRGB(150, 170, 220),
            Shadow = Color3.fromRGB(0, 0, 20),
            Outline = Color3.fromRGB(40, 50, 80),
            Icon = Color3.fromRGB(150, 180, 255),
        })
    end
})

Window:AddButton({
    Title = "🎨 Red Theme",
    Description = "Встановити червону тему",
    Tab = SettingsTab,
    Callback = function()
        Window:SetSetting("Theme", {
            Primary = Color3.fromRGB(35, 20, 20),
            Secondary = Color3.fromRGB(45, 25, 25),
            Component = Color3.fromRGB(55, 30, 30),
            Interactables = Color3.fromRGB(70, 35, 35),
            Tab = Color3.fromRGB(255, 150, 150),
            Title = Color3.fromRGB(255, 200, 200),
            Description = Color3.fromRGB(220, 150, 150),
            Shadow = Color3.fromRGB(20, 0, 0),
            Outline = Color3.fromRGB(80, 40, 40),
            Icon = Color3.fromRGB(255, 150, 150),
        })
    end
})

Window:AddButton({
    Title = "🗑️ Destroy UI",
    Description = "Повністю видалити чит меню",
    Tab = SettingsTab,
    Callback = function()
        -- Clean up ESP
        for _, esp in pairs(ESPObjects) do
            for _, d in pairs(esp) do
                pcall(function() d:Remove() end)
            end
        end
        -- Clean up FOV circle
        pcall(function() FOVCircle:Remove() end)
        -- Clean up fly
        pcall(function()
            local BV = HumanoidRootPart:FindFirstChild("FlyVelocity")
            local BG = HumanoidRootPart:FindFirstChild("FlyGyro")
            if BV then BV:Destroy() end
            if BG then BG:Destroy() end
        end)
        -- Reset states
        States.Fly = false
        States.Noclip = false
        States.GodMode = false
        States.Aimbot = false
        States.ESPEnabled = false
        -- Destroy screen
        pcall(function()
            game.CoreGui:FindFirstChild("UILibrary"):Destroy()
        end)
    end
})

-- ══════════════════════════════════════════
-- 📱 MOBILE SUPPORT
-- ══════════════════════════════════════════

-- Кнопка для мобільних пристроїв для відкриття/закриття меню
if UserInputService.TouchEnabled then
    local MobileButton = Instance.new("ScreenGui")
    MobileButton.Name = "MobileToggle"
    MobileButton.ResetOnSpawn = false
    MobileButton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(153, 155, 255)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "🎮"
    ToggleBtn.TextSize = 24
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Parent = MobileButton
    ToggleBtn.BackgroundTransparency = 0.3
    ToggleBtn.AutoButtonColor = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 25)
    corner.Parent = ToggleBtn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Parent = ToggleBtn
    
    -- Draggable mobile button
    local dragging = false
    local dragStart, startPos
    
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleBtn.Position
        end
    end)
    
    ToggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and dragging then
            local delta = input.Position - dragStart
            ToggleBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    ToggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    ToggleBtn.MouseButton1Click:Connect(function()
        -- Toggle the main UI
        UserInputService.InputBegan:Fire(
            Instance.new("InputObject", {
                KeyCode = Enum.KeyCode.RightControl,
                UserInputType = Enum.UserInputType.Keyboard
            })
        )
    end)
    
    pcall(function()
        MobileButton.Parent = game.CoreGui
    end)
end

-- ══════════════════════════════════════════
-- 🔔 СТАРТОВЕ ПОВІДОМЛЕННЯ
-- ══════════════════════════════════════════

task.delay(1, function()
    Window:Notify({
        Title = "🎮 Ultra Cheat v2.0 Loaded!",
        Description = "Welcome, " .. LocalPlayer.DisplayName .. "!\nPress RightCtrl or tap 🎮 button to toggle.",
        Duration = 5
    })
end)

print("═══════════════════════════════════")
print("  🎮 Ultra Cheat v2.0 - Loaded!")
print("  👤 Player: " .. LocalPlayer.DisplayName)
print("  🎯 Game: " .. game.PlaceId)
print("═══════════════════════════════════")
