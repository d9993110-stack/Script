-- ═══════════════════════════════════════════════
-- URB - ONE HIT KO v3.0 (SIMPLE & WORKING)
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

pcall(function()
    if game.CoreGui:FindFirstChild("URB_v3") then
        game.CoreGui:FindFirstChild("URB_v3"):Destroy()
    end
end)

-- ═══════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "URB_v3"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- Кнопка URB
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

local OC = Instance.new("UICorner"); OC.CornerRadius = UDim.new(0, 4); OC.Parent = OpenBtn
local OS = Instance.new("UIStroke"); OS.Color = Color3.fromRGB(255, 60, 60); OS.Thickness = 1; OS.Parent = OpenBtn

-- Drag
local bd, bs, bp
OpenBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        bd = true; bs = i.Position; bp = OpenBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if bd and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - bs
        OpenBtn.Position = UDim2.new(bp.X.Scale, bp.X.Offset + d.X, bp.Y.Scale, bp.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        bd = false
    end
end)

-- Окно
local Win = Instance.new("Frame")
Win.Size = UDim2.new(0, 260, 0, 280)
Win.Position = UDim2.new(0.5, -130, 0.5, -140)
Win.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Win.BorderSizePixel = 0
Win.Visible = false
Win.ZIndex = 50
Win.Parent = ScreenGui

local WC = Instance.new("UICorner"); WC.CornerRadius = UDim.new(0, 3); WC.Parent = Win
local WS = Instance.new("UIStroke"); WS.Color = Color3.fromRGB(60, 60, 70); WS.Thickness = 1; WS.Parent = Win

-- Title
local Title = Instance.new("Frame")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
Title.BorderSizePixel = 0
Title.ZIndex = 51
Title.Parent = Win

local TC = Instance.new("UICorner"); TC.CornerRadius = UDim.new(0, 3); TC.Parent = Title
local TF = Instance.new("Frame"); TF.Size = UDim2.new(1, 0, 0, 12); TF.Position = UDim2.new(0, 0, 1, -12); TF.BackgroundColor3 = Color3.fromRGB(180, 30, 30); TF.BorderSizePixel = 0; TF.ZIndex = 51; TF.Parent = Title

local TT = Instance.new("TextLabel")
TT.Size = UDim2.new(1, -30, 1, 0)
TT.Position = UDim2.new(0, 8, 0, 0)
TT.BackgroundTransparency = 1
TT.Text = "URB ONE-HIT KO  |  v3.0"
TT.TextColor3 = Color3.fromRGB(255, 255, 255)
TT.TextSize = 12
TT.Font = Enum.Font.Code
TT.TextXAlignment = Enum.TextXAlignment.Left
TT.ZIndex = 52
TT.Parent = Title

local CX = Instance.new("TextButton")
CX.Size = UDim2.new(0, 20, 0, 20)
CX.Position = UDim2.new(1, -22, 0, 2)
CX.BackgroundTransparency = 1
CX.Text = "×"
CX.TextColor3 = Color3.fromRGB(255, 255, 255)
CX.TextSize = 18
CX.Font = Enum.Font.Code
CX.ZIndex = 53
CX.Parent = Title

local wd, ws, wp
Title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        wd = true; ws = i.Position; wp = Win.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if wd and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - ws
        Win.Position = UDim2.new(wp.X.Scale, wp.X.Offset + d.X, wp.Y.Scale, wp.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        wd = false
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

local CC = Instance.new("UICorner"); CC.CornerRadius = UDim.new(0, 2); CC.Parent = Content

local L = Instance.new("UIListLayout"); L.Padding = UDim.new(0, 5); L.SortOrder = Enum.SortOrder.LayoutOrder; L.Parent = Content
local P = Instance.new("UIPadding"); P.PaddingLeft = UDim.new(0, 5); P.PaddingTop = UDim.new(0, 5); P.PaddingRight = UDim.new(0, 5); P.Parent = Content

-- ═══════════════════════════════════════════════
-- ЭЛЕМЕНТЫ
-- ═══════════════════════════════════════════════

local function MakeCheck(name, callback)
    local C = Instance.new("Frame")
    C.Size = UDim2.new(1, -10, 0, 26)
    C.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    C.BorderSizePixel = 0
    C.ZIndex = 53
    C.Parent = Content
    
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 2); cc.Parent = C
    
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 16, 0, 16)
    Box.Position = UDim2.new(0, 6, 0.5, -8)
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
    Check.TextSize = 16
    Check.Font = Enum.Font.Code
    Check.ZIndex = 55
    Check.Parent = Box
    
    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(1, -30, 1, 0)
    Lb.Position = UDim2.new(0, 28, 0, 0)
    Lb.BackgroundTransparency = 1
    Lb.Text = name
    Lb.TextColor3 = Color3.fromRGB(220, 220, 230)
    Lb.TextSize = 12
    Lb.Font = Enum.Font.Code
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.ZIndex = 54
    Lb.Parent = C
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.ZIndex = 56
    Btn.Parent = C
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Check.Text = "✓"
            bs.Color = Color3.fromRGB(255, 60, 60)
            Box.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
        else
            Check.Text = ""
            bs.Color = Color3.fromRGB(80, 80, 90)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        end
        callback(state)
    end)
end

local function MakeBtn(name, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -10, 0, 28)
    B.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    B.Text = name
    B.TextColor3 = Color3.fromRGB(220, 220, 230)
    B.TextSize = 12
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

local function MakeLbl(text, color)
    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(1, -10, 0, 18)
    Lb.BackgroundTransparency = 1
    Lb.Text = text
    Lb.TextColor3 = color or Color3.fromRGB(150, 150, 160)
    Lb.TextSize = 11
    Lb.Font = Enum.Font.Code
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.ZIndex = 53
    Lb.Parent = Content
    return Lb
end

-- ═══════════════════════════════════════════════
-- ЛОГИКА ПОИСКА ВРАГА
-- ═══════════════════════════════════════════════

-- Найти ВРАГА (НЕ твой персонаж)
local function FindEnemy()
    local myChar = Player.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    local closest, dist = nil, math.huge
    
    -- Ищем по всему Workspace
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Humanoid") and model.Parent ~= myChar and model.Health > 0 then
            local parent = model.Parent
            -- Проверка что это не другой игрок (твой союзник или ты сам)
            local isMyPlayer = false
            for _, p in pairs(Players:GetPlayers()) do
                if p == Player and p.Character == parent then
                    isMyPlayer = true
                    break
                end
            end
            
            if not isMyPlayer then
                local root = parent:FindFirstChild("HumanoidRootPart") or parent:FindFirstChild("Torso") or parent:FindFirstChild("UpperTorso") or parent:FindFirstChildWhichIsA("BasePart")
                if root then
                    local d = (root.Position - myRoot.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = model
                    end
                end
            end
        end
    end
    
    return closest, dist
end

-- ═══════════════════════════════════════════════
-- ФЛАГИ
-- ═══════════════════════════════════════════════

local Flags = {
    OneHitKO = false,
    AutoKO = false,
}

-- ═══════════════════════════════════════════════
-- МЕНЮ
-- ═══════════════════════════════════════════════

MakeLbl("» NOKAUT FEATURES", Color3.fromRGB(255, 60, 60))

MakeCheck("One Hit KO (Auto)", function(s)
    Flags.OneHitKO = s
    if s then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ONE HIT KO ON",
            Text = "Враг падает автоматически",
            Duration = 3
        })
    end
end)

MakeCheck("Auto KO (без удара)", function(s)
    Flags.AutoKO = s
end)

MakeLbl(" ")
MakeLbl("» MANUAL ACTIONS", Color3.fromRGB(255, 60, 60))

MakeBtn("💀 KO Enemy NOW", function()
    pcall(function()
        local enemy, d = FindEnemy()
        if enemy then
            enemy.Health = 0
            -- Также пробуем убить через Charge/HP values
            for _, v in pairs(enemy.Parent:GetDescendants()) do
                if v:IsA("NumberValue") or v:IsA("IntValue") then
                    local n = v.Name:lower()
                    if n:find("charge") or n:find("зарядка") or n:find("health") or n:find("hp") then
                        pcall(function() v.Value = 0 end)
                    end
                end
            end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "✅ KO!",
                Text = "Враг повержен (" .. math.floor(d) .. " studs)",
                Duration = 2
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "❌ Враг не найден",
                Text = "Подойди ближе к врагу",
                Duration = 2
            })
        end
    end)
end)

MakeBtn("💀💀 KO ALL Enemies", function()
    pcall(function()
        local myChar = Player.Character
        local count = 0
        for _, model in pairs(Workspace:GetDescendants()) do
            if model:IsA("Humanoid") and model.Parent ~= myChar and model.Health > 0 then
                local isMyPlayer = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p == Player and p.Character == model.Parent then
                        isMyPlayer = true
                    end
                end
                if not isMyPlayer then
                    pcall(function()
                        model.Health = 0
                        for _, v in pairs(model.Parent:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local n = v.Name:lower()
                                if n:find("charge") or n:find("зарядка") or n:find("health") or n:find("hp") then
                                    pcall(function() v.Value = 0 end)
                                end
                            end
                        end
                        count = count + 1
                    end)
                end
            end
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "💀 KO ALL",
            Text = "Убито: " .. count,
            Duration = 3
        })
    end)
end)

MakeBtn("🔄 Reset (если завис)", function()
    pcall(function() Player.Character:BreakJoints() end)
end)

MakeLbl(" ")
MakeLbl("» INFO", Color3.fromRGB(255, 60, 60))
local StatusL = MakeLbl("Статус: ⚪ выключен")
MakeLbl("Жми RightShift чтобы открыть")

-- ═══════════════════════════════════════════════
-- ОТКРЫТИЕ / ЗАКРЫТИЕ
-- ═══════════════════════════════════════════════

local open = false
local function Toggle()
    open = not open
    if open then
        Win.Visible = true
        Win.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Win, TweenInfo.new(0.2), {Size = UDim2.new(0, 260, 0, 280)}):Play()
        OpenBtn.TextColor3 = Color3.fromRGB(60, 255, 60)
        OS.Color = Color3.fromRGB(60, 255, 60)
    else
        local t = TweenService:Create(Win, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        Win.Visible = false
        OpenBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
        OS.Color = Color3.fromRGB(255, 60, 60)
    end
end

OpenBtn.MouseButton1Click:Connect(Toggle)
CX.MouseButton1Click:Connect(Toggle)

UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then Toggle() end
end)

-- ═══════════════════════════════════════════════
-- ОТСЛЕЖИВАНИЕ HP ВРАГА - КОГДА ТЫ БЬЁШЬ → УБИВАЕМ
-- ═══════════════════════════════════════════════

local trackedEnemies = {}

-- Отслеживаем урон врагу
spawn(function()
    while task.wait(0.1) do
        if Flags.OneHitKO then
            pcall(function()
                local myChar = Player.Character
                if not myChar then return end
                
                for _, model in pairs(Workspace:GetDescendants()) do
                    if model:IsA("Humanoid") and model.Parent ~= myChar and model.Health > 0 then
                        local isMyPlayer = false
                        for _, p in pairs(Players:GetPlayers()) do
                            if p == Player and p.Character == model.Parent then
                                isMyPlayer = true
                            end
                        end
                        
                        if not isMyPlayer then
                            -- Сохраняем последний HP
                            local id = tostring(model)
                            if not trackedEnemies[id] then
                                trackedEnemies[id] = model.Health
                                -- Подключаем слежение
                                model.HealthChanged:Connect(function(newHP)
                                    if Flags.OneHitKO and trackedEnemies[id] and newHP < trackedEnemies[id] then
                                        -- Враг получил урон → добиваем
                                        task.wait(0.05)
                                        pcall(function()
                                            model.Health = 0
                                            -- Также Charge
                                            for _, v in pairs(model.Parent:GetDescendants()) do
                                                if v:IsA("NumberValue") or v:IsA("IntValue") then
                                                    local n = v.Name:lower()
                                                    if n:find("charge") or n:find("зарядка") then
                                                        pcall(function() v.Value = 0 end)
                                                    end
                                                end
                                            end
                                        end)
                                    end
                                    trackedEnemies[id] = newHP
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO KO - убивает без удара постоянно
spawn(function()
    while task.wait(0.5) do
        if Flags.AutoKO then
            pcall(function()
                local enemy = FindEnemy()
                if enemy then
                    enemy.Health = 0
                    for _, v in pairs(enemy.Parent:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("IntValue") then
                            local n = v.Name:lower()
                            if n:find("charge") or n:find("зарядка") then
                                pcall(function() v.Value = 0 end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Статус
spawn(function()
    while ScreenGui.Parent do
        if Flags.OneHitKO and Flags.AutoKO then
            StatusL.Text = "Статус: 🔴 ONE HIT + AUTO"
            StatusL.TextColor3 = Color3.fromRGB(255, 60, 60)
        elseif Flags.OneHitKO then
            StatusL.Text = "Статус: 🔴 ONE HIT KO"
            StatusL.TextColor3 = Color3.fromRGB(255, 60, 60)
        elseif Flags.AutoKO then
            StatusL.Text = "Статус: 🔴 AUTO KO"
            StatusL.TextColor3 = Color3.fromRGB(255, 60, 60)
        else
            StatusL.Text = "Статус: ⚪ выключен"
            StatusL.TextColor3 = Color3.fromRGB(150, 150, 160)
        end
        task.wait(0.3)
    end
end)

-- ═══════════════════════════════════════════════
-- УВЕДОМЛЕНИЕ
-- ═══════════════════════════════════════════════

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🤖 URB v3.0 LOADED",
        Text = "Жми URB кнопку. Включи 'One Hit KO'",
        Duration = 5
    })
end)

print("════════════════════════════")
print("  URB v3.0 - ONE HIT KO")
print("  ✅ Loaded successfully")
print("════════════════════════════")
