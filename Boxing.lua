-- ═══════════════════════════════════════════════
-- UNTITLED ROBOT BOXING - ImGui Style Menu
-- Для Delta Executor
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Удаление старого GUI
pcall(function()
    if game.CoreGui:FindFirstChild("URB_ImGui") then
        game.CoreGui:FindFirstChild("URB_ImGui"):Destroy()
    end
end)

-- ═══════════════════════════════════════════════
-- ИНИЦИАЛИЗАЦИЯ GUI
-- ═══════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "URB_ImGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local success = pcall(function()
    ScreenGui.Parent = game.CoreGui
end)
if not success then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════
-- МАЛЕНЬКАЯ КНОПКА (Toggle)
-- ═══════════════════════════════════════════════

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0, 10, 0, 200)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
OpenBtn.Text = "URB"
OpenBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
OpenBtn.TextSize = 14
OpenBtn.Font = Enum.Font.Code
OpenBtn.BorderSizePixel = 0
OpenBtn.AutoButtonColor = false
OpenBtn.ZIndex = 100
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 4)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 60, 60)
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenBtn

-- Перетаскивание кнопки
local btnDragging, btnDragStart, btnStartPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnDragStart = input.Position
        btnStartPos = OpenBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        OpenBtn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = false
    end
end)

-- ═══════════════════════════════════════════════
-- ГЛАВНОЕ ОКНО (ImGui Style)
-- ═══════════════════════════════════════════════

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 280, 0, 320)
MainWindow.Position = UDim2.new(0.5, -140, 0.5, -160)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false
MainWindow.ZIndex = 50
MainWindow.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 3)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1
MainStroke.Parent = MainWindow

-- ═══════════════════════════════════════════════
-- ЗАГОЛОВОК (Title Bar)
-- ═══════════════════════════════════════════════

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 24)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 51
TitleBar.Parent = MainWindow

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 3)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 51
TitleFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "URB CHEAT  |  v1.0"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 12
TitleText.Font = Enum.Font.Code
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 52
TitleText.Parent = TitleBar

-- Кнопка закрытия (X)
local CloseX = Instance.new("TextButton")
CloseX.Size = UDim2.new(0, 20, 0, 20)
CloseX.Position = UDim2.new(1, -22, 0, 2)
CloseX.BackgroundTransparency = 1
CloseX.Text = "×"
CloseX.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseX.TextSize = 18
CloseX.Font = Enum.Font.Code
CloseX.ZIndex = 53
CloseX.Parent = TitleBar

-- Перетаскивание окна
local winDragging, winDragStart, winStartPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDragging = true
        winDragStart = input.Position
        winStartPos = MainWindow.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if winDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - winDragStart
        MainWindow.Position = UDim2.new(winStartPos.X.Scale, winStartPos.X.Offset + delta.X, winStartPos.Y.Scale, winStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDragging = false
    end
end)

-- ═══════════════════════════════════════════════
-- ТАБЫ (Tabs)
-- ═══════════════════════════════════════════════

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -10, 0, 22)
TabBar.Position = UDim2.new(0, 5, 0, 28)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 51
TabBar.Parent = MainWindow

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 2)
TabBarCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 2)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 2)
TabPadding.PaddingTop = UDim.new(0, 2)
TabPadding.Parent = TabBar

-- ═══════════════════════════════════════════════
-- КОНТЕЙНЕР ДЛЯ КОНТЕНТА
-- ═══════════════════════════════════════════════

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -10, 1, -58)
ContentArea.Position = UDim2.new(0, 5, 0, 54)
ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ContentArea.BorderSizePixel = 0
ContentArea.ZIndex = 51
ContentArea.Parent = MainWindow

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 2)
ContentCorner.Parent = ContentArea

-- ═══════════════════════════════════════════════
-- СИСТЕМА ТАБОВ
-- ═══════════════════════════════════════════════

local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 70, 1, -4)
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    TabBtn.TextSize = 11
    TabBtn.Font = Enum.Font.Code
    TabBtn.BorderSizePixel = 0
    TabBtn.AutoButtonColor = false
    TabBtn.ZIndex = 52
    TabBtn.Parent = TabBar
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 2)
    TabBtnCorner.Parent = TabBtn
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -8, 1, -8)
    TabContent.Position = UDim2.new(0, 4, 0, 4)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(180, 30, 30)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Visible = false
    TabContent.ZIndex = 52
    TabContent.Parent = ContentArea
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 4)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = TabContent
    
    local tabData = {Button = TabBtn, Content = TabContent}
    table.insert(Tabs, tabData)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Content.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        TabContent.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = tabData
    end)
    
    -- Активируем первый таб
    if #Tabs == 1 then
        TabContent.Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = tabData
    end
    
    return TabContent
end

-- ═══════════════════════════════════════════════
-- ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ
-- ═══════════════════════════════════════════════

local function CreateCheckbox(parent, name, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -4, 0, 22)
    Container.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    Container.BorderSizePixel = 0
    Container.ZIndex = 53
    Container.Parent = parent
    
    local CCorner = Instance.new("UICorner")
    CCorner.CornerRadius = UDim.new(0, 2)
    CCorner.Parent = Container
    
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 14, 0, 14)
    Box.Position = UDim2.new(0, 6, 0.5, -7)
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Box.BorderSizePixel = 0
    Box.ZIndex = 54
    Box.Parent = Container
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 2)
    BoxCorner.Parent = Box
    
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(80, 80, 90)
    BoxStroke.Thickness = 1
    BoxStroke.Parent = Box
    
    local Check = Instance.new("TextLabel")
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = ""
    Check.TextColor3 = Color3.fromRGB(255, 60, 60)
    Check.TextSize = 14
    Check.Font = Enum.Font.Code
    Check.ZIndex = 55
    Check.Parent = Box
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -28, 1, 0)
    Label.Position = UDim2.new(0, 26, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 11
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 54
    Label.Parent = Container
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.ZIndex = 56
    Btn.Parent = Container
    
    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Check.Text = "✓"
            BoxStroke.Color = Color3.fromRGB(255, 60, 60)
            Box.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
        else
            Check.Text = ""
            BoxStroke.Color = Color3.fromRGB(80, 80, 90)
            Box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        end
        callback(state)
    end)
    
    Btn.MouseEnter:Connect(function()
        Container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end)
    Btn.MouseLeave:Connect(function()
        Container.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    end)
    
    return Container
end

local function CreateButton(parent, name, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -4, 0, 22)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    Btn.TextSize = 11
    Btn.Font = Enum.Font.Code
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.ZIndex = 53
    Btn.Parent = parent
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 2)
    BCorner.Parent = Btn
    
    local BStroke = Instance.new("UIStroke")
    BStroke.Color = Color3.fromRGB(60, 60, 70)
    BStroke.Thickness = 1
    BStroke.Parent = Btn
    
    Btn.MouseEnter:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        BStroke.Color = Color3.fromRGB(255, 60, 60)
    end)
    Btn.MouseLeave:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        BStroke.Color = Color3.fromRGB(60, 60, 70)
    end)
    
    Btn.MouseButton1Click:Connect(callback)
    
    return Btn
end

local function CreateLabel(parent, text, color)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -4, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = color or Color3.fromRGB(150, 150, 160)
    Label.TextSize = 10
    Label.Font = Enum.Font.Code
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 53
    Label.Parent = parent
    return Label
end

local function CreateSeparator(parent)
    local Sep = Instance.new("Frame")
    Sep.Size = UDim2.new(1, -4, 0, 1)
    Sep.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Sep.BorderSizePixel = 0
    Sep.ZIndex = 53
    Sep.Parent = parent
    return Sep
end

-- ═══════════════════════════════════════════════
-- СОЗДАНИЕ ТАБОВ И ФУНКЦИЙ
-- ═══════════════════════════════════════════════

local MainTab = CreateTab("MAIN")
local CombatTab = CreateTab("COMBAT")
local InfoTab = CreateTab("INFO")

-- ═══════════════════════════════════════════════
-- ПЕРЕМЕННЫЕ СОСТОЯНИЯ
-- ═══════════════════════════════════════════════

local Flags = {
    InfiniteStamina = false,
    OneHitKO = false,
    AutoFarm = false,
    NoCooldown = false,
}

-- ═══════════════════════════════════════════════
-- MAIN TAB
-- ═══════════════════════════════════════════════

CreateLabel(MainTab, "» Main Features", Color3.fromRGB(255, 60, 60))
CreateSeparator(MainTab)

-- ✔ Неограниченная выносливость
CreateCheckbox(MainTab, "Infinite Stamina", function(state)
    Flags.InfiniteStamina = state
end)

-- ✔ Нокаут одним ударом
CreateCheckbox(MainTab, "One Hit KO", function(state)
    Flags.OneHitKO = state
end)

CreateCheckbox(MainTab, "No Attack Cooldown", function(state)
    Flags.NoCooldown = state
end)

CreateSeparator(MainTab)
CreateLabel(MainTab, "» Quick Actions", Color3.fromRGB(255, 60, 60))

CreateButton(MainTab, "Reset Character", function()
    pcall(function()
        Player.Character:BreakJoints()
    end)
end)

CreateButton(MainTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end)

-- ═══════════════════════════════════════════════
-- COMBAT TAB
-- ═══════════════════════════════════════════════

CreateLabel(CombatTab, "» Combat Settings", Color3.fromRGB(255, 60, 60))
CreateSeparator(CombatTab)

CreateCheckbox(CombatTab, "Auto Punch (Nearest)", function(state)
    Flags.AutoFarm = state
end)

CreateButton(CombatTab, "Kill All Nearby (15 studs)", function()
    pcall(function()
        local char = Player.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        for _, model in pairs(Workspace:GetDescendants()) do
            if model:IsA("Humanoid") and model.Parent ~= char then
                local root = model.Parent:FindFirstChild("HumanoidRootPart") or model.Parent:FindFirstChild("Torso")
                if root and (root.Position - myRoot.Position).Magnitude < 15 then
                    model.Health = 0
                    -- Поиск HP значений
                    for _, v in pairs(model.Parent:GetDescendants()) do
                        if (v:IsA("NumberValue") or v:IsA("IntValue")) then
                            local n = v.Name:lower()
                            if n:find("health") or n:find("hp") then
                                pcall(function() v.Value = 0 end)
                            end
                        end
                    end
                end
            end
        end
    end)
end)

CreateButton(CombatTab, "Refill Stamina Now", function()
    pcall(function()
        local char = Player.Character
        if not char then return end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                local n = v.Name:lower()
                if n:find("stam") or n:find("energy") or n:find("endur") then
                    v.Value = 999999
                end
            end
        end
        for _, folder in pairs(Player:GetChildren()) do
            if folder:IsA("Folder") or folder:IsA("Configuration") then
                for _, v in pairs(folder:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local n = v.Name:lower()
                        if n:find("stam") or n:find("energy") then
                            v.Value = 999999
                        end
                    end
                end
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════
-- INFO TAB
-- ═══════════════════════════════════════════════

CreateLabel(InfoTab, "» URB Cheat Information", Color3.fromRGB(255, 60, 60))
CreateSeparator(InfoTab)
CreateLabel(InfoTab, "Game: Untitled Robot Boxing")
CreateLabel(InfoTab, "Version: 1.0")
CreateLabel(InfoTab, "Executor: Delta")
CreateLabel(InfoTab, "Status: Active", Color3.fromRGB(60, 255, 60))
CreateSeparator(InfoTab)
CreateLabel(InfoTab, "» Controls", Color3.fromRGB(255, 60, 60))
CreateLabel(InfoTab, "Drag title to move window")
CreateLabel(InfoTab, "Click URB button to toggle")
CreateLabel(InfoTab, "Press RightShift to hide/show")
CreateSeparator(InfoTab)
local PingLabel = CreateLabel(InfoTab, "Ping: 0ms")
local FPSLabel = CreateLabel(InfoTab, "FPS: 0")

-- Обновление пинга и FPS
spawn(function()
    local lastTick = tick()
    local frames = 0
    while ScreenGui.Parent do
        frames = frames + 1
        if tick() - lastTick >= 1 then
            FPSLabel.Text = "FPS: " .. frames
            PingLabel.Text = "Ping: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms"
            frames = 0
            lastTick = tick()
        end
        task.wait()
    end
end)

-- ═══════════════════════════════════════════════
-- ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ
-- ═══════════════════════════════════════════════

local menuOpen = false

local function ToggleMenu()
    menuOpen = not menuOpen
    if menuOpen then
        MainWindow.Visible = true
        MainWindow.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainWindow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 280, 0, 320)
        }):Play()
        OpenBtn.TextColor3 = Color3.fromRGB(60, 255, 60)
        OpenStroke.Color = Color3.fromRGB(60, 255, 60)
    else
        local t = TweenService:Create(MainWindow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        t:Play()
        t.Completed:Wait()
        MainWindow.Visible = false
        OpenBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
        OpenStroke.Color = Color3.fromRGB(255, 60, 60)
    end
end

OpenBtn.MouseButton1Click:Connect(ToggleMenu)
CloseX.MouseButton1Click:Connect(ToggleMenu)

-- Hotkey RightShift
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        ToggleMenu()
    end
end)

-- ═══════════════════════════════════════════════
-- ХУК REMOTE EVENTS (Delta поддерживает)
-- ═══════════════════════════════════════════════

local oldNamecall
local ok = pcall(function()
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if (method == "FireServer" or method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
            local rName = self.Name:lower()
            
            -- Блок траты стамины
            if Flags.InfiniteStamina then
                if rName:find("stam") or rName:find("energy") or rName:find("fatigue") or rName:find("tired") or rName:find("exhaust") then
                    return nil
                end
            end
            
            -- Блок кулдаунов
            if Flags.NoCooldown then
                if rName:find("cooldown") or rName:find("delay") then
                    return nil
                end
            end
            
            -- Усиление урона
            if Flags.OneHitKO then
                if rName:find("damage") or rName:find("hit") or rName:find("punch") or rName:find("attack") or rName:find("strike") or rName:find("dmg") then
                    local newArgs = {}
                    for i, v in pairs(args) do
                        if type(v) == "number" and v > 0 and v < 999999 then
                            newArgs[i] = 999999
                        else
                            newArgs[i] = v
                        end
                    end
                    return oldNamecall(self, table.unpack(newArgs))
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
end)

-- ═══════════════════════════════════════════════
-- ОСНОВНЫЕ ЛУПЫ ФУНКЦИЙ
-- ═══════════════════════════════════════════════

-- Бесконечная стамина (постоянное обновление)
spawn(function()
    while task.wait(0.1) do
        if Flags.InfiniteStamina then
            pcall(function()
                local char = Player.Character
                if not char then return end
                
                -- В персонаже
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local n = v.Name:lower()
                        if n:find("stam") or n:find("energy") or n:find("endur") or n:find("fuel") or n:find("charge") then
                            v.Value = 999999
                        end
                        if n:find("fatigue") or n:find("tired") or n:find("exhaust") then
                            v.Value = 0
                        end
                    end
                    if v:IsA("NumberValue") and (v.Name == "Stamina" or v.Name == "Energy") then
                        v.Value = 100
                    end
                end
                
                -- В Player folder
                for _, folder in pairs(Player:GetChildren()) do
                    if folder:IsA("Folder") or folder:IsA("Configuration") then
                        for _, v in pairs(folder:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local n = v.Name:lower()
                                if n:find("stam") or n:find("energy") or n:find("endur") then
                                    v.Value = 999999
                                end
                            end
                        end
                    end
                end
                
                -- attributes
                for _, attr in pairs({"Stamina", "Energy", "Endurance", "Power"}) do
                    if char:GetAttribute(attr) ~= nil then
                        char:SetAttribute(attr, 999999)
                    end
                end
            end)
        end
    end
end)

-- Нокаут одним ударом (буст урона)
spawn(function()
    while task.wait(0.2) do
        if Flags.OneHitKO then
            pcall(function()
                local char = Player.Character
                if not char then return end
                
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local n = v.Name:lower()
                        if n:find("damage") or n:find("dmg") or n:find("power") or n:find("strength") or n:find("attack") or n:find("punch") or n:find("force") then
                            v.Value = 999999
                        end
                    end
                end
                
                local backpack = Player:FindFirstChild("Backpack")
                if backpack then
                    for _, v in pairs(backpack:GetDescendants()) do
                        if v:IsA("NumberValue") or v:IsA("IntValue") then
                            local n = v.Name:lower()
                            if n:find("damage") or n:find("dmg") or n:find("power") then
                                v.Value = 999999
                            end
                        end
                    end
                end
                
                for _, folder in pairs(Player:GetChildren()) do
                    if folder:IsA("Folder") or folder:IsA("Configuration") then
                        for _, v in pairs(folder:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local n = v.Name:lower()
                                if n:find("damage") or n:find("dmg") or n:find("power") or n:find("strength") then
                                    v.Value = 999999
                                end
                            end
                        end
                    end
                end
                
                -- Атрибуты
                for _, attr in pairs({"Damage", "Power", "Strength", "AttackPower"}) do
                    if char:GetAttribute(attr) ~= nil then
                        char:SetAttribute(attr, 999999)
                    end
                end
            end)
        end
    end
end)

-- Auto Punch
spawn(function()
    while task.wait(0.3) do
        if Flags.AutoFarm then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                
                local nearest, dist = nil, 20
                for _, model in pairs(Workspace:GetDescendants()) do
                    if model:IsA("Humanoid") and model.Parent ~= char and model.Health > 0 then
                        local root = model.Parent:FindFirstChild("HumanoidRootPart") or model.Parent:FindFirstChild("Torso")
                        if root then
                            local d = (root.Position - myRoot.Position).Magnitude
                            if d < dist then
                                dist = d
                                nearest = model
                            end
                        end
                    end
                end
                
                if nearest then
                    nearest.Health = 0
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════
-- УВЕДОМЛЕНИЕ
-- ═══════════════════════════════════════════════

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "URB Cheat Loaded",
        Text = "Click URB button or press RightShift",
        Duration = 5
    })
end)

print("════════════════════════════")
print("  URB CHEAT v1.0 LOADED")
print("  Press URB button to open")
print("  Or press RightShift")
print("════════════════════════════")
