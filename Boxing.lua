-- ═══════════════════════════════════════════════
-- URB ONE HIT KO v3.1 - FIXED BUTTON
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Удаление старого
pcall(function()
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui.Name == "URB_GUI" then gui:Destroy() end
    end
    if game.CoreGui:FindFirstChild("URB_GUI") then
        game.CoreGui:FindFirstChild("URB_GUI"):Destroy()
    end
end)

task.wait(0.5)

-- ═══════════════════════════════════════════════
-- ГЛАВНЫЙ GUI (в PlayerGui — точно работает)
-- ═══════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "URB_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

-- Пробуем также в CoreGui
pcall(function()
    local sg2 = ScreenGui:Clone()
    sg2.Parent = game.CoreGui
    ScreenGui:Destroy()
    ScreenGui = sg2
end)

-- ═══════════════════════════════════════════════
-- БОЛЬШАЯ ЯРКАЯ КНОПКА URB
-- ═══════════════════════════════════════════════

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 70, 0, 70)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -35)
OpenBtn.AnchorPoint = Vector2.new(0, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
OpenBtn.Text = "URB"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 22
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.BorderSizePixel = 0
OpenBtn.AutoButtonColor = false
OpenBtn.Active = true
OpenBtn.Selectable = true
OpenBtn.Visible = true
OpenBtn.ZIndex = 999
OpenBtn.Parent = ScreenGui

local OC = Instance.new("UICorner")
OC.CornerRadius = UDim.new(1, 0)
OC.Parent = OpenBtn

local OS = Instance.new("UIStroke")
OS.Color = Color3.fromRGB(255, 255, 255)
OS.Thickness = 3
OS.Parent = OpenBtn

-- Свечение
local Glow = Instance.new("UIStroke")
Glow.Color = Color3.fromRGB(255, 100, 100)
Glow.Thickness = 6
Glow.Transparency = 0.5
Glow.Parent = OpenBtn

-- Анимация пульсации
spawn(function()
    while OpenBtn and OpenBtn.Parent do
        TweenService:Create(Glow, TweenInfo.new(0.8), {Thickness = 10, Transparency = 0.8}):Play()
        task.wait(0.8)
        TweenService:Create(Glow, TweenInfo.new(0.8), {Thickness = 6, Transparency = 0.5}):Play()
        task.wait(0.8)
    end
end)

-- ═══════════════════════════════════════════════
-- DRAG (перетаскивание)
-- ═══════════════════════════════════════════════

local dragging = false
local dragStart, startPos
local moved = false

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        moved = false
        dragStart = input.Position
        startPos = OpenBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then moved = true end
        OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ═══════════════════════════════════════════════
-- ОКНО МЕНЮ
-- ═══════════════════════════════════════════════

local Win = Instance.new("Frame")
Win.Name = "MainWindow"
Win.Size = UDim2.new(0, 280, 0, 300)
Win.Position = UDim2.new(0.5, -140, 0.5, -150)
Win.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Win.BorderSizePixel = 0
Win.Visible = false
Win.ZIndex = 500
Win.Parent = ScreenGui

local WC = Instance.new("UICorner"); WC.CornerRadius = UDim.new(0, 6); WC.Parent = Win
local WS = Instance.new("UIStroke"); WS.Color = Color3.fromRGB(255, 30, 30); WS.Thickness = 2; WS.Parent = Win

-- Title
local Title = Instance.new("Frame")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
Title.BorderSizePixel = 0
Title.ZIndex = 501
Title.Parent = Win

local TC = Instance.new("UICorner"); TC.CornerRadius = UDim.new(0, 6); TC.Parent = Title
local TFix = Instance.new("Frame"); TFix.Size = UDim2.new(1, 0, 0, 15); TFix.Position = UDim2.new(0, 0, 1, -15); TFix.BackgroundColor3 = Color3.fromRGB(200, 30, 30); TFix.BorderSizePixel = 0; TFix.ZIndex = 501; TFix.Parent = Title

local TT = Instance.new("TextLabel")
TT.Size = UDim2.new(1, -40, 1, 0)
TT.Position = UDim2.new(0, 10, 0, 0)
TT.BackgroundTransparency = 1
TT.Text = "🤖 URB CHEAT MENU"
TT.TextColor3 = Color3.fromRGB(255, 255, 255)
TT.TextSize = 14
TT.Font = Enum.Font.GothamBold
TT.TextXAlignment = Enum.TextXAlignment.Left
TT.ZIndex = 502
TT.Parent = Title

local CX = Instance.new("TextButton")
CX.Size = UDim2.new(0, 26, 0, 26)
CX.Position = UDim2.new(1, -30, 0, 2)
CX.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
CX.Text = "X"
CX.TextColor3 = Color3.fromRGB(255, 255, 255)
CX.TextSize = 14
CX.Font = Enum.Font.GothamBold
CX.BorderSizePixel = 0
CX.ZIndex = 503
CX.Parent = Title

local CXC = Instance.new("UICorner"); CXC.CornerRadius = UDim.new(0, 4); CXC.Parent = CX

-- Drag окна
local wdrag, wstart, wpos
Title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        wdrag = true; wstart = i.Position; wpos = Win.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if wdrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - wstart
        Win.Position = UDim2.new(wpos.X.Scale, wpos.X.Offset + d.X, wpos.Y.Scale, wpos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        wdrag = false
    end
end)

-- Контент
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -10, 1, -40)
Content.Position = UDim2.new(0, 5, 0, 35)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ZIndex = 501
Content.Parent = Win

local UL = Instance.new("UIListLayout"); UL.Padding = UDim.new(0, 6); UL.SortOrder = Enum.SortOrder.LayoutOrder; UL.Parent = Content
local UP = Instance.new("UIPadding"); UP.PaddingLeft = UDim.new(0, 5); UP.PaddingRight = UDim.new(0, 5); UP.PaddingTop = UDim.new(0, 5); UP.Parent = Content

-- ═══════════════════════════════════════════════
-- ЭЛЕМЕНТЫ
-- ═══════════════════════════════════════════════

local function MakeCheck(name, callback)
    local C = Instance.new("Frame")
    C.Size = UDim2.new(1, -10, 0, 32)
    C.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    C.BorderSizePixel = 0
    C.ZIndex = 502
    C.Parent = Content
    
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 4); cc.Parent = C
    
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 20, 0, 20)
    Box.Position = UDim2.new(0, 8, 0.5, -10)
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Box.BorderSizePixel = 0
    Box.ZIndex = 503
    Box.Parent = C
    
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 3); bc.Parent = Box
    local bs = Instance.new("UIStroke"); bs.Color = Color3.fromRGB(100, 100, 110); bs.Thickness = 1; bs.Parent = Box
    
    local Check = Instance.new("TextLabel")
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = ""
    Check.TextColor3 = Color3.fromRGB(255, 30, 30)
    Check.TextSize = 18
    Check.Font = Enum.Font.GothamBold
    Check.ZIndex = 504
    Check.Parent = Box
    
    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(1, -38, 1, 0)
    Lb.Position = UDim2.new(0, 36, 0, 0)
    Lb.BackgroundTransparency = 1
    Lb.Text = name
    Lb.TextColor3 = Color3.fromRGB(230, 230, 240)
    Lb.TextSize = 13
    Lb.Font = Enum.Font.Gotham
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.ZIndex = 503
    Lb.Parent = C
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.ZIndex = 505
    Btn.Parent = C
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Check.Text = "✓"
            bs.Color = Color3.fromRGB(255, 30, 30)
            Box.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
        else
            Check.Text = ""
            bs.Color = Color3.fromRGB(100, 100, 110)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        end
        callback(state)
    end)
end

local function MakeBtn(name, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -10, 0, 32)
    B.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    B.Text = name
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.TextSize = 13
    B.Font = Enum.Font.GothamBold
    B.BorderSizePixel = 0
    B.AutoButtonColor = false
    B.ZIndex = 502
    B.Parent = Content
    
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = B
    
    B.MouseEnter:Connect(function()
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
    end)
    B.MouseLeave:Connect(function()
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}):Play()
    end)
    B.MouseButton1Click:Connect(callback)
end

local function MakeLbl(text, color)
    local Lb = Instance.new("TextLabel")
    Lb.Size = UDim2.new(1, -10, 0, 20)
    Lb.BackgroundTransparency = 1
    Lb.Text = text
    Lb.TextColor3 = color or Color3.fromRGB(160, 160, 170)
    Lb.TextSize = 12
    Lb.Font = Enum.Font.Gotham
    Lb.TextXAlignment = Enum.TextXAlignment.Left
    Lb.ZIndex = 502
    Lb.Parent = Content
    return Lb
end

-- ═══════════════════════════════════════════════
-- ЛОГИКА
-- ═══════════════════════════════════════════════

local function FindEnemy()
    local myChar = Player.Character
    if not myChar then return nil, 0 end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, 0 end
    
    local closest, dist = nil, math.huge
    
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Humanoid") and model.Parent ~= myChar and model.Health > 0 then
            local isMyPlayer = false
            for _, p in pairs(Players:GetPlayers()) do
                if p == Player and p.Character == model.Parent then
                    isMyPlayer = true
                end
            end
            
            if not isMyPlayer then
                local root = model.Parent:FindFirstChild("HumanoidRootPart") or model.Parent:FindFirstChild("Torso") or model.Parent:FindFirstChild("UpperTorso") or model.Parent:FindFirstChildWhichIsA("BasePart")
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

local Flags = { OneHitKO = false, AutoKO = false }

-- ═══════════════════════════════════════════════
-- МЕНЮ КОНТЕНТ
-- ═══════════════════════════════════════════════

MakeLbl("» ФУНКЦИИ", Color3.fromRGB(255, 60, 60))

MakeCheck("One Hit KO (после удара)", function(s)
    Flags.OneHitKO = s
end)

MakeCheck("Auto KO (без удара)", function(s)
    Flags.AutoKO = s
end)

MakeLbl(" ")
MakeLbl("» КНОПКИ", Color3.fromRGB(255, 60, 60))

MakeBtn("💀 УБИТЬ ВРАГА СЕЙЧАС", function()
    pcall(function()
        local enemy, d = FindEnemy()
        if enemy then
            enemy.Health = 0
            for _, v in pairs(enemy.Parent:GetDescendants()) do
                if v:IsA("NumberValue") or v:IsA("IntValue") then
                    local n = v.Name:lower()
                    if n:find("charge") or n:find("зарядка") or n:find("health") or n:find("hp") then
                        pcall(function() v.Value = 0 end)
                    end
                end
            end
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "✅ KO!",
                    Text = "Враг убит",
                    Duration = 2
                })
            end)
        else
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "❌ Не найден",
                    Text = "Враг не найден",
                    Duration = 2
                })
            end)
        end
    end)
end)

MakeBtn("💀 УБИТЬ ВСЕХ", function()
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
                        count = count + 1
                    end)
                end
            end
        end
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "💀 KO ALL",
                Text = "Убито: " .. count,
                Duration = 2
            })
        end)
    end)
end)

MakeLbl(" ")
local StatusL = MakeLbl("Статус: ⚪ выключен", Color3.fromRGB(180, 180, 180))

-- ═══════════════════════════════════════════════
-- ОТКРЫТИЕ / ЗАКРЫТИЕ
-- ═══════════════════════════════════════════════

local open = false
local function Toggle()
    open = not open
    if open then
        Win.Visible = true
        Win.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(Win, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 280, 0, 300)}):Play()
        OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
    else
        local t = TweenService:Create(Win, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        Win.Visible = false
        OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    end
end

OpenBtn.MouseButton1Click:Connect(function()
    if not moved then Toggle() end
    moved = false
end)
CX.MouseButton1Click:Connect(Toggle)

UserInputService.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.RightShift then Toggle() end
end)

-- ═══════════════════════════════════════════════
-- LOOPS
-- ═══════════════════════════════════════════════

local trackedEnemies = {}

spawn(function()
    while task.wait(0.2) do
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
                            local id = tostring(model)
                            if not trackedEnemies[id] then
                                trackedEnemies[id] = model.Health
                                model.HealthChanged:Connect(function(newHP)
                                    if Flags.OneHitKO and trackedEnemies[id] and newHP < trackedEnemies[id] then
                                        task.wait(0.05)
                                        pcall(function() model.Health = 0 end)
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

spawn(function()
    while task.wait(0.5) do
        if Flags.AutoKO then
            pcall(function()
                local enemy = FindEnemy()
                if enemy then
                    enemy.Health = 0
                end
            end)
        end
    end
end)

spawn(function()
    while ScreenGui.Parent do
        if Flags.OneHitKO and Flags.AutoKO then
            StatusL.Text = "Статус: 🔴 ВСЕ ВКЛ"
            StatusL.TextColor3 = Color3.fromRGB(255, 60, 60)
        elseif Flags.OneHitKO then
            StatusL.Text = "Статус: 🔴 ONE HIT KO"
            StatusL.TextColor3 = Color3.fromRGB(255, 60, 60)
        elseif Flags.AutoKO then
            StatusL.Text = "Статус: 🔴 AUTO KO"
            StatusL.TextColor3 = Color3.fromRGB(255, 60, 60)
        else
            StatusL.Text = "Статус: ⚪ выключен"
            StatusL.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        task.wait(0.5)
    end
end)

-- ═══════════════════════════════════════════════
-- УВЕДОМЛЕНИЕ
-- ═══════════════════════════════════════════════

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🤖 URB LOADED!",
        Text = "Красная кнопка URB слева на экране",
        Duration = 5
    })
end)

print("=========================")
print("URB CHEAT v3.1 LOADED!")
print("Look for RED 'URB' button")
print("On the LEFT side of screen")
print("=========================")
