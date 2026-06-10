-- ═══════════════════════════════════════════════
-- UNTITLED ROBOT BOXING - FIXED v2.0
-- Специально под UPD 1.7
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- Удаление старого
pcall(function()
    if game.CoreGui:FindFirstChild("URB_v2") then
        game.CoreGui:FindFirstChild("URB_v2"):Destroy()
    end
end)

-- ═══════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "URB_v2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- Кнопка открытия
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0, 350)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
OpenBtn.Text = "URB"
OpenBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
OpenBtn.TextSize = 14
OpenBtn.Font = Enum.Font.Code
OpenBtn.BorderSizePixel = 0
OpenBtn.ZIndex = 100
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 4)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 60, 60)
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenBtn

-- Drag кнопки
local btnDrag, btnStart, btnPos
OpenBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        btnDrag = true; btnStart = i.Position; btnPos = OpenBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if btnDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - btnStart
        OpenBtn.Position = UDim2.new(btnPos.X.Scale, btnPos.X.Offset + d.X, btnPos.Y.Scale, btnPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        btnDrag = false
    end
end)

-- Главное окно
local Win = Instance.new("Frame")
Win.Size = UDim2.new(0, 280, 0, 340)
Win.Position = UDim2.new(0.5, -140, 0.5, -170)
Win.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Win.BorderSizePixel = 0
Win.Visible = false
Win.ZIndex = 50
Win.Parent = ScreenGui

local WinC = Instance.new("UICorner")
WinC.CornerRadius = UDim.new(0, 3)
WinC.Parent = Win

local WinS = Instance.new("UIStroke")
WinS.Color = Color3.fromRGB(60, 60, 70)
WinS.Thickness = 1
WinS.Parent = Win

-- Title
local Title = Instance.new("Frame")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
Title.BorderSizePixel = 0
Title.ZIndex = 51
Title.Parent = Win

local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(0, 3)
TC.Parent = Title

local TF = Instance.new("Frame")
TF.Size = UDim2.new(1, 0, 0, 12)
TF.Position = UDim2.new(0, 0, 1, -12)
TF.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
TF.BorderSizePixel = 0
TF.ZIndex = 51
TF.Parent = Title

local TT = Instance.new("TextLabel")
TT.Size = UDim2.new(1, -30, 1, 0)
TT.Position = UDim2.new(0, 8, 0, 0)
TT.BackgroundTransparency = 1
TT.Text = "URB CHEAT v2.0  |  UPD 1.7"
TT.TextColor3 = Color3.fromRGB(255, 255, 255)
TT.TextSize = 12
TT.Font = Enum.Font.Code
TT.TextXAlignment = Enum.TextXAlignment.Left
TT.ZIndex = 52
TT.Parent = Title

local CloseX = Instance.new("TextButton")
CloseX.Size = UDim2.new(0, 20, 0, 20)
CloseX.Position = UDim2.new(1, -22, 0, 2)
CloseX.BackgroundTransparency = 1
CloseX.Text = "×"
CloseX.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseX.TextSize = 18
CloseX.Font = Enum.Font.Code
CloseX.ZIndex = 53
CloseX.Parent = Title

-- Drag окна
local wDrag, wStart, wPos
Title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        wDrag = true; wStart = i.Position; wPos = Win.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if wDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - wStart
        Win.Position = UDim2.new(wPos.X.Scale, wPos.X.Offset + d.X, wPos.Y.Scale, wPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        wDrag = false
    end
end)

-- Контент
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -10, 1, -34)
Content.Position = UDim2.new(0, 5, 0, 28)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Color3.fromRGB(180, 30, 30)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ZIndex = 51
Content.Parent = Win

local CC = Instance.new("UICorner")
CC.CornerRadius = UDim.new(0, 2)
CC.Parent = Content

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 4)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

local Pad = Instance.new("UIPadding")
Pad.PaddingLeft = UDim.new(0, 4)
Pad.PaddingTop = UDim.new(0, 4)
Pad.PaddingRight = UDim.new(0, 4)
Pad.Parent = Content

-- ═══════════════════════════════════════════════
-- ЭЛЕМЕНТЫ
-- ═══════════════════════════════════════════════

local function Checkbox(name, callback)
    local C = Instance.new("Frame")
    C.Size = UDim2.new(1, -8, 0, 22)
    C.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    C.BorderSizePixel = 0
    C.ZIndex = 53
    C.Parent = Content
    
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 2); cc.Parent = C
    
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 14, 0, 14)
    Box.Position = UDim2.new(0, 6, 0.5, -7)
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Box.BorderSizePixel = 0
    Box.ZIndex = 54
    Box.Parent = C
    
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 2); bc.Parent = Box
    local bs = Instance.new("UIStroke"); bs.Color = Color3.fromRGB(80, 80, 90); bs.Thickness = 1; bs.Parent = Box
    
    local Check = Instance.new("TextLabel")
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = ""
    Check.TextColor3 = Color3.fromRGB(255, 60, 60)
    Check.TextSize = 14
    Check.Font = Enum.Font.Code
    Check.ZIndex = 55
    Check.Parent = Box
    
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -28, 1, 0)
    L.Position = UDim2.new(0, 26, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(220, 220, 230)
    L.TextSize = 11
    L.Font = Enum.Font.Code
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = 54
    L.Parent = C
    
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 1, 0)
    B.BackgroundTransparency = 1
    B.Text = ""
    B.ZIndex = 56
    B.Parent = C
    
    local s = false
    B.MouseButton1Click:Connect(function()
        s = not s
        if s then
            Check.Text = "✓"
            bs.Color = Color3.fromRGB(255, 60, 60)
            Box.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
        else
            Check.Text = ""
            bs.Color = Color3.fromRGB(80, 80, 90)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        end
        callback(s)
    end)
end

local function Button(name, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -8, 0, 24)
    B.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    B.Text = name
    B.TextColor3 = Color3.fromRGB(220, 220, 230)
    B.TextSize = 11
    B.Font = Enum.Font.Code
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    B.ZIndex = 53
    B.Parent = Content
    
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 2); c.Parent = B
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(60, 60, 70); s.Thickness = 1; s.Parent = B
    
    B.MouseEnter:Connect(function()
        B.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        s.Color = Color3.fromRGB(255, 60, 60)
    end)
    B.MouseLeave:Connect(function()
        B.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        s.Color = Color3.fromRGB(60, 60, 70)
    end)
    B.MouseButton1Click:Connect(callback)
end

local function Label(text, color)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -8, 0, 18)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = color or Color3.fromRGB(150, 150, 160)
    L.TextSize = 10
    L.Font = Enum.Font.Code
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.ZIndex = 53
    L.Parent = Content
    return L
end

local function Sep()
    local S = Instance.new("Frame")
    S.Size = UDim2.new(1, -8, 0, 1)
    S.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    S.BorderSizePixel = 0
    S.ZIndex = 53
    S.Parent = Content
end

-- ═══════════════════════════════════════════════
-- ЛОГИКА - АНАЛИЗ ИГРЫ URB
-- ═══════════════════════════════════════════════

-- Найти робота игрока (НЕ персонажа humanoid а робота)
local function FindMyRobot()
    -- Поиск робота через различные методы
    local char = Player.Character
    if not char then return nil end
    
    -- Метод 1: По имени игрока в Workspace
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Model") then
            -- Проверка имени или владельца
            if obj.Name == Player.Name .. "_Robot" or obj.Name == Player.Name .. "Robot" then
                return obj
            end
            -- Проверка через атрибут владельца
            if obj:GetAttribute("Owner") == Player.Name or obj:GetAttribute("Player") == Player.Name then
                return obj
            end
        end
    end
    
    -- Метод 2: Через папку Robots
    local robotsFolder = Workspace:FindFirstChild("Robots") or Workspace:FindFirstChild("Bots") or Workspace:FindFirstChild("Fighters")
    if robotsFolder then
        for _, r in pairs(robotsFolder:GetChildren()) do
            if r:GetAttribute("Owner") == Player.Name or r:GetAttribute("Player") == Player.Name or r.Name:find(Player.Name) then
                return r
            end
        end
    end
    
    return nil
end

-- Найти робота врага
local function FindEnemyRobot()
    local myRobot = FindMyRobot()
    
    -- Поиск всех роботов кроме своего
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= myRobot then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                -- Это робот если у него есть характеристики бойца
                local isRobot = false
                for _, v in pairs(obj:GetDescendants()) do
                    if v.Name:lower():find("charge") or v.Name:lower():find("зарядка") or v.Name:lower():find("battery") then
                        isRobot = true
                        break
                    end
                end
                if isRobot or obj.Name:lower():find("robot") or obj.Name:lower():find("bot") then
                    -- Проверка что это НЕ твой
                    local owner = obj:GetAttribute("Owner") or obj:GetAttribute("Player")
                    if owner ~= Player.Name then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

-- Найти ВСЕ Charge/Stamina value в робота
local function FindRobotValues(robot, keywords)
    local found = {}
    if not robot then return found end
    
    for _, v in pairs(robot:GetDescendants()) do
        if v:IsA("NumberValue") or v:IsA("IntValue") then
            local n = v.Name:lower()
            for _, kw in pairs(keywords) do
                if n:find(kw) then
                    table.insert(found, v)
                    break
                end
            end
        end
    end
    return found
end

-- Флаги
local Flags = {
    InfStamina = false,
    InfCharge = false,
    NoCooldown = false,
    AutoCharge = false,
}

-- ═══════════════════════════════════════════════
-- СОДЕРЖИМОЕ МЕНЮ
-- ═══════════════════════════════════════════════

Label("» URB FEATURES", Color3.fromRGB(255, 60, 60))
Sep()

Checkbox("Infinite Charge (ЗАРЯДКА)", function(s)
    Flags.InfCharge = s
end)

Checkbox("Infinite Stamina", function(s)
    Flags.InfStamina = s
end)

Checkbox("No Cooldown (Удары без задержки)", function(s)
    Flags.NoCooldown = s
end)

Checkbox("Auto Charge Refill", function(s)
    Flags.AutoCharge = s
end)

Sep()
Label("» ACTIONS", Color3.fromRGB(255, 60, 60))

Button("Refill My Charge NOW", function()
    pcall(function()
        local robot = FindMyRobot()
        if robot then
            local vals = FindRobotValues(robot, {"charge", "зарядка", "stamina", "energy", "battery", "fuel"})
            for _, v in pairs(vals) do
                pcall(function() v.Value = 800 end)
            end
        end
        -- Также в Player
        for _, folder in pairs(Player:GetChildren()) do
            if folder:IsA("Folder") or folder:IsA("Configuration") then
                for _, v in pairs(folder:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local n = v.Name:lower()
                        if n:find("charge") or n:find("stam") or n:find("energy") then
                            pcall(function() v.Value = 800 end)
                        end
                    end
                end
            end
        end
    end)
end)

Button("Damage Enemy (-100 HP)", function()
    pcall(function()
        local enemy = FindEnemyRobot()
        if enemy then
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = hum.Health - 100
            end
        end
    end)
end)

Button("Print Robot Info (Console)", function()
    local robot = FindMyRobot()
    print("=== MY ROBOT ===")
    if robot then
        print("Robot found:", robot.Name)
        for _, v in pairs(robot:GetDescendants()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                print("  Value:", v.Name, "=", v.Value)
            end
        end
    else
        print("Robot NOT found!")
    end
    print("=== ENEMY ===")
    local enemy = FindEnemyRobot()
    if enemy then
        print("Enemy found:", enemy.Name)
    end
    print("=== REMOTES ===")
    for _, r in pairs(ReplicatedStorage:GetDescendants()) do
        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
            print("  Remote:", r:GetFullName())
        end
    end
end)

Button("Reset Character", function()
    pcall(function() Player.Character:BreakJoints() end)
end)

Sep()
Label("» INFO", Color3.fromRGB(255, 60, 60))
Label("Game: Untitled Robot Boxing")
Label("Charge = ЗАРЯДКА = твоё HP")
Label("Press RightShift to toggle")
local FPSL = Label("FPS: 0", Color3.fromRGB(100, 255, 100))

-- ═══════════════════════════════════════════════
-- ОТКРЫТИЕ
-- ═══════════════════════════════════════════════

local open = false
local function Toggle()
    open = not open
    if open then
        Win.Visible = true
        Win.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Win, TweenInfo.new(0.2), {Size = UDim2.new(0, 280, 0, 340)}):Play()
        OpenBtn.TextColor3 = Color3.fromRGB(60, 255, 60)
        OpenStroke.Color = Color3.fromRGB(60, 255, 60)
    else
        local t = TweenService:Create(Win, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        Win.Visible = false
        OpenBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
        OpenStroke.Color = Color3.fromRGB(255, 60, 60)
    end
end

OpenBtn.MouseButton1Click:Connect(Toggle)
CloseX.MouseButton1Click:Connect(Toggle)

UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then Toggle() end
end)

-- ═══════════════════════════════════════════════
-- ЛУПЫ ФУНКЦИЙ (БЕЗОПАСНЫЕ - не ломают игру)
-- ═══════════════════════════════════════════════

-- Бесконечная ЗАРЯДКА (только для своего робота)
spawn(function()
    while task.wait(0.3) do
        if Flags.InfCharge or Flags.AutoCharge then
            pcall(function()
                local robot = FindMyRobot()
                if robot then
                    local vals = FindRobotValues(robot, {"charge", "зарядка", "battery"})
                    for _, v in pairs(vals) do
                        -- Восстанавливаем только если значение упало
                        if v.Value < 800 then
                            pcall(function() v.Value = 800 end)
                        end
                    end
                end
                
                -- Player folders
                for _, folder in pairs(Player:GetChildren()) do
                    if folder:IsA("Folder") or folder:IsA("Configuration") then
                        for _, v in pairs(folder:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local n = v.Name:lower()
                                if n:find("charge") and v.Value < 800 then
                                    pcall(function() v.Value = 800 end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Бесконечная стамина
spawn(function()
    while task.wait(0.3) do
        if Flags.InfStamina then
            pcall(function()
                local robot = FindMyRobot()
                if robot then
                    local vals = FindRobotValues(robot, {"stamina", "energy", "endur", "fuel"})
                    for _, v in pairs(vals) do
                        if v.Value < 100 then
                            pcall(function() v.Value = 100 end)
                        end
                    end
                end
                
                for _, folder in pairs(Player:GetChildren()) do
                    if folder:IsA("Folder") or folder:IsA("Configuration") then
                        for _, v in pairs(folder:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local n = v.Name:lower()
                                if (n:find("stam") or n:find("energy")) and v.Value < 100 then
                                    pcall(function() v.Value = 100 end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- No Cooldown - только блокируем cooldown ремоты
spawn(function()
    while task.wait(0.1) do
        if Flags.NoCooldown then
            pcall(function()
                local char = Player.Character
                if not char then return end
                
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local n = v.Name:lower()
                        if n:find("cooldown") or n:find("delay") or n:find("recharge") then
                            pcall(function() v.Value = 0 end)
                        end
                    end
                end
                
                for _, folder in pairs(Player:GetChildren()) do
                    if folder:IsA("Folder") or folder:IsA("Configuration") then
                        for _, v in pairs(folder:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local n = v.Name:lower()
                                if n:find("cooldown") or n:find("delay") then
                                    pcall(function() v.Value = 0 end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- FPS
spawn(function()
    local f, lt = 0, tick()
    while ScreenGui.Parent do
        f = f + 1
        if tick() - lt >= 1 then
            FPSL.Text = "FPS: " .. f .. "  |  Ping: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms"
            f = 0; lt = tick()
        end
        task.wait()
    end
end)

-- ═══════════════════════════════════════════════
-- УВЕДОМЛЕНИЕ
-- ═══════════════════════════════════════════════

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "URB v2.0 LOADED",
        Text = "Жми URB или RightShift. Сначала жми 'Print Robot Info'",
        Duration = 7
    })
end)

print("════════════════════════════")
print("  URB CHEAT v2.0 LOADED")
print("  Press URB button or RightShift")
print("  IMPORTANT: Press 'Print Robot Info'")
print("  to send game info to developer")
print("════════════════════════════")
