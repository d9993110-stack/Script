-- ═══════════════════════════════════════════════
-- EXCALIBUR CHEAT — ImGui Style Menu
-- Для Delta Executor / Mobile + PC
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = Workspace.CurrentCamera

-- Удаление старого GUI
pcall(function()
    if game.CoreGui:FindFirstChild("Excalibur_ImGui") then
        game.CoreGui:FindFirstChild("Excalibur_ImGui"):Destroy()
    end
end)
pcall(function()
    for _, g in pairs(Player.PlayerGui:GetChildren()) do
        if g.Name == "Excalibur_ImGui" then g:Destroy() end
    end
end)

-- ═══════════════════════════════════════════════
-- ЦВЕТОВАЯ СХЕМА
-- ═══════════════════════════════════════════════

local Colors = {
    WindowBg       = Color3.fromRGB(15, 15, 18),
    TitleBar       = Color3.fromRGB(130, 50, 200),
    TitleBarDark   = Color3.fromRGB(100, 35, 160),
    TabBg          = Color3.fromRGB(25, 25, 30),
    TabActive      = Color3.fromRGB(130, 50, 200),
    TabInactive    = Color3.fromRGB(35, 35, 42),
    ContentBg      = Color3.fromRGB(20, 20, 25),
    ElementBg      = Color3.fromRGB(28, 28, 35),
    ElementHover   = Color3.fromRGB(35, 35, 45),
    ButtonBg       = Color3.fromRGB(40, 40, 50),
    ButtonHover    = Color3.fromRGB(130, 50, 200),
    Accent         = Color3.fromRGB(150, 70, 220),
    AccentDim      = Color3.fromRGB(100, 40, 160),
    AccentBright   = Color3.fromRGB(180, 100, 255),
    CheckOn        = Color3.fromRGB(50, 20, 70),
    StrokeDim      = Color3.fromRGB(60, 60, 70),
    StrokeAccent   = Color3.fromRGB(150, 70, 220),
    Text           = Color3.fromRGB(220, 220, 230),
    TextDim        = Color3.fromRGB(150, 150, 160),
    TextBright     = Color3.fromRGB(255, 255, 255),
    Success        = Color3.fromRGB(60, 255, 60),
    Danger         = Color3.fromRGB(255, 60, 60),
    Warning        = Color3.fromRGB(255, 200, 50),
    Info           = Color3.fromRGB(80, 150, 255),
    SliderFill     = Color3.fromRGB(130, 50, 200),
    SliderBg       = Color3.fromRGB(40, 40, 55),
    ScrollBar      = Color3.fromRGB(130, 50, 200),
    SepLine        = Color3.fromRGB(50, 50, 60),
}

-- ═══════════════════════════════════════════════
-- ИНИЦИАЛИЗАЦИЯ GUI
-- ═══════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Excalibur_ImGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local guiSuccess = pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
    ScreenGui.Parent = game.CoreGui
end)
if not guiSuccess then
    pcall(function()
        if gethui then
            ScreenGui.Parent = gethui()
        else
            ScreenGui.Parent = Player:WaitForChild("PlayerGui")
        end
    end)
end

-- ═══════════════════════════════════════════════
-- СИСТЕМА УВЕДОМЛЕНИЙ (ImGui Toast Style)
-- ═══════════════════════════════════════════════

local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "Notifications"
NotifHolder.Size = UDim2.new(0, 260, 1, 0)
NotifHolder.Position = UDim2.new(1, -265, 0, 0)
NotifHolder.BackgroundTransparency = 1
NotifHolder.ZIndex = 200
NotifHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 4)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Parent = NotifHolder

local NotifPad = Instance.new("UIPadding")
NotifPad.PaddingBottom = UDim.new(0, 8)
NotifPad.PaddingRight = UDim.new(0, 4)
NotifPad.Parent = NotifHolder

local function Notify(title, text, nType, duration)
    duration = duration or 3.5
    nType = nType or "info"

    local typeColors = {
        info    = Colors.Info,
        success = Colors.Success,
        warning = Colors.Warning,
        error   = Colors.Danger,
    }
    local typeIcons = {
        info    = "[i]",
        success = "[+]",
        warning = "[!]",
        error   = "[x]",
    }

    local col = typeColors[nType] or Colors.Info
    local icon = typeIcons[nType] or "[i]"

    local nFrame = Instance.new("Frame")
    nFrame.Size = UDim2.new(1, 0, 0, 52)
    nFrame.BackgroundColor3 = Colors.WindowBg
    nFrame.BorderSizePixel = 0
    nFrame.BackgroundTransparency = 1
    nFrame.ClipsDescendants = true
    nFrame.ZIndex = 201
    nFrame.Parent = NotifHolder

    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 3)
    nCorner.Parent = nFrame

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = col
    nStroke.Thickness = 1
    nStroke.Transparency = 1
    nStroke.Parent = nFrame

    -- Левая полоска акцента
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.BackgroundColor3 = col
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 202
    accentBar.Parent = nFrame

    -- Иконка
    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 24, 0, 16)
    iconLbl.Position = UDim2.new(0, 8, 0, 5)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = col
    iconLbl.TextSize = 11
    iconLbl.Font = Enum.Font.Code
    iconLbl.TextXAlignment = Enum.TextXAlignment.Left
    iconLbl.ZIndex = 203
    iconLbl.Parent = nFrame

    -- Заголовок
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -38, 0, 16)
    titleLbl.Position = UDim2.new(0, 32, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = Colors.TextBright
    titleLbl.TextSize = 11
    titleLbl.Font = Enum.Font.Code
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 203
    titleLbl.Parent = nFrame

    -- Текст
    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -38, 0, 22)
    textLbl.Position = UDim2.new(0, 32, 0, 22)
    textLbl.BackgroundTransparency = 1
    textLbl.Text = text
    textLbl.TextColor3 = Colors.TextDim
    textLbl.TextSize = 10
    textLbl.Font = Enum.Font.Code
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.TextWrapped = true
    textLbl.ZIndex = 203
    textLbl.Parent = nFrame

    -- Прогресс бар внизу
    local progBar = Instance.new("Frame")
    progBar.Size = UDim2.new(1, 0, 0, 2)
    progBar.Position = UDim2.new(0, 0, 1, -2)
    progBar.BackgroundColor3 = col
    progBar.BorderSizePixel = 0
    progBar.ZIndex = 203
    progBar.Parent = nFrame

    -- Анимация появления
    TweenService:Create(nFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05
    }):Play()
    TweenService:Create(nStroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()

    -- Прогресс бар уменьшается
    TweenService:Create(progBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()

    -- Удаление
    task.delay(duration, function()
        TweenService:Create(nFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(nStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        task.wait(0.35)
        pcall(function() nFrame:Destroy() end)
    end)
end

-- ═══════════════════════════════════════════════
-- МАЛЕНЬКАЯ КНОПКА EXCALIBUR (Toggle)
-- ═══════════════════════════════════════════════

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "ExcaliburBtn"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0, 200)
OpenBtn.BackgroundColor3 = Colors.WindowBg
OpenBtn.Text = ""
OpenBtn.BorderSizePixel = 0
OpenBtn.AutoButtonColor = false
OpenBtn.ZIndex = 100
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 4)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Colors.Accent
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

-- Текст "EXC" сверху
local OpenText1 = Instance.new("TextLabel")
OpenText1.Size = UDim2.new(1, 0, 0, 22)
OpenText1.Position = UDim2.new(0, 0, 0, 3)
OpenText1.BackgroundTransparency = 1
OpenText1.Text = "⚔"
OpenText1.TextColor3 = Colors.Accent
OpenText1.TextSize = 18
OpenText1.Font = Enum.Font.Code
OpenText1.ZIndex = 101
OpenText1.Parent = OpenBtn

local OpenText2 = Instance.new("TextLabel")
OpenText2.Size = UDim2.new(1, 0, 0, 16)
OpenText2.Position = UDim2.new(0, 0, 0, 28)
OpenText2.BackgroundTransparency = 1
OpenText2.Text = "EXC"
OpenText2.TextColor3 = Colors.AccentBright
OpenText2.TextSize = 10
OpenText2.Font = Enum.Font.Code
OpenText2.ZIndex = 101
OpenText2.Parent = OpenBtn

-- Перетаскивание кнопки
local btnDragging = false
local btnDragStart, btnStartPos
local btnMoved = false

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = true
        btnMoved = false
        btnDragStart = input.Position
        btnStartPos = OpenBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if btnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - btnDragStart
        if delta.Magnitude > 5 then
            btnMoved = true
        end
        OpenBtn.Position = UDim2.new(
            btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        btnDragging = false
    end
end)

-- Пульсация кнопки
task.spawn(function()
    while ScreenGui.Parent do
        TweenService:Create(OpenStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 2.5
        }):Play()
        task.wait(1.2)
        TweenService:Create(OpenStroke, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 1
        }):Play()
        task.wait(1.2)
    end
end)

-- ═══════════════════════════════════════════════
-- ГЛАВНОЕ ОКНО (ImGui Style)
-- ═══════════════════════════════════════════════

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 310, 0, 380)
MainWindow.Position = UDim2.new(0.5, -155, 0.5, -190)
MainWindow.BackgroundColor3 = Colors.WindowBg
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false
MainWindow.ClipsDescendants = true
MainWindow.ZIndex = 50
MainWindow.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 3)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.StrokeDim
MainStroke.Thickness = 1
MainStroke.Parent = MainWindow

-- ═══════════════════════════════════════════════
-- TITLE BAR
-- ═══════════════════════════════════════════════

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 26)
TitleBar.BackgroundColor3 = Colors.TitleBar
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 51
TitleBar.Parent = MainWindow

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 3)
TitleCorner.Parent = TitleBar

-- Фикс скругления снизу
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 10)
TitleFix.Position = UDim2.new(0, 0, 1, -10)
TitleFix.BackgroundColor3 = Colors.TitleBar
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 51
TitleFix.Parent = TitleBar

-- Градиент на TitleBar
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.TitleBar),
    ColorSequenceKeypoint.new(1, Colors.TitleBarDark),
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚔ EXCALIBUR  |  v2.0"
TitleText.TextColor3 = Colors.TextBright
TitleText.TextSize = 12
TitleText.Font = Enum.Font.Code
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 52
TitleText.Parent = TitleBar

-- Кнопка минимизации (_)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -44, 0, 3)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "_"
MinBtn.TextColor3 = Colors.TextBright
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.Code
MinBtn.ZIndex = 53
MinBtn.Parent = TitleBar

-- Кнопка закрытия (×)
local CloseX = Instance.new("TextButton")
CloseX.Size = UDim2.new(0, 20, 0, 20)
CloseX.Position = UDim2.new(1, -24, 0, 3)
CloseX.BackgroundTransparency = 1
CloseX.Text = "×"
CloseX.TextColor3 = Colors.TextBright
CloseX.TextSize = 16
CloseX.Font = Enum.Font.Code
CloseX.ZIndex = 53
CloseX.Parent = TitleBar

-- Hover эффекты на кнопках
CloseX.MouseEnter:Connect(function()
    CloseX.TextColor3 = Colors.Danger
end)
CloseX.MouseLeave:Connect(function()
    CloseX.TextColor3 = Colors.TextBright
end)
MinBtn.MouseEnter:Connect(function()
    MinBtn.TextColor3 = Colors.Warning
end)
MinBtn.MouseLeave:Connect(function()
    MinBtn.TextColor3 = Colors.TextBright
end)

-- Перетаскивание окна
local winDragging = false
local winDragStart, winStartPos

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
        MainWindow.Position = UDim2.new(
            winStartPos.X.Scale, winStartPos.X.Offset + delta.X,
            winStartPos.Y.Scale, winStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        winDragging = false
    end
end)

-- ═══════════════════════════════════════════════
-- TAB BAR
-- ═══════════════════════════════════════════════

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -10, 0, 22)
TabBar.Position = UDim2.new(0, 5, 0, 30)
TabBar.BackgroundColor3 = Colors.TabBg
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 51
TabBar.ClipsDescendants = true
TabBar.Parent = MainWindow

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 2)
TabBarCorner.Parent = TabBar

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, 0, 1, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 0
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabScroll.ZIndex = 52
TabScroll.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 2)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabScroll

local TabPaddingUI = Instance.new("UIPadding")
TabPaddingUI.PaddingLeft = UDim.new(0, 2)
TabPaddingUI.PaddingTop = UDim.new(0, 2)
TabPaddingUI.Parent = TabScroll

-- ═══════════════════════════════════════════════
-- CONTENT AREA
-- ═══════════════════════════════════════════════

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -10, 1, -60)
ContentArea.Position = UDim2.new(0, 5, 0, 56)
ContentArea.BackgroundColor3 = Colors.ContentBg
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 51
ContentArea.Parent = MainWindow

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 2)
ContentCorner.Parent = ContentArea

-- ═══════════════════════════════════════════════
-- СИСТЕМА ТАБОВ
-- ═══════════════════════════════════════════════

local AllTabs = {}
local CurrentTabData = nil

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 65, 1, -4)
    TabBtn.BackgroundColor3 = Colors.TabInactive
    TabBtn.Text = name
    TabBtn.TextColor3 = Colors.TextDim
    TabBtn.TextSize = 10
    TabBtn.Font = Enum.Font.Code
    TabBtn.BorderSizePixel = 0
    TabBtn.AutoButtonColor = false
    TabBtn.ZIndex = 53
    TabBtn.Parent = TabScroll

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 2)
    BtnCorner.Parent = TabBtn

    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, -8, 1, -8)
    TabContent.Position = UDim2.new(0, 4, 0, 4)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = Colors.ScrollBar
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Visible = false
    TabContent.ZIndex = 52
    TabContent.Parent = ContentArea

    local CLayout = Instance.new("UIListLayout")
    CLayout.Padding = UDim.new(0, 4)
    CLayout.SortOrder = Enum.SortOrder.LayoutOrder
    CLayout.Parent = TabContent

    local tabData = {Button = TabBtn, Content = TabContent, Name = name}
    table.insert(AllTabs, tabData)

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(AllTabs) do
            t.Content.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {
                BackgroundColor3 = Colors.TabInactive,
                TextColor3 = Colors.TextDim
            }):Play()
        end
        TabContent.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = Colors.TabActive,
            TextColor3 = Colors.TextBright
        }):Play()
        CurrentTabData = tabData
    end)

    -- Первый таб активен
    if #AllTabs == 1 then
        TabContent.Visible = true
        TabBtn.BackgroundColor3 = Colors.TabActive
        TabBtn.TextColor3 = Colors.TextBright
        CurrentTabData = tabData
    end

    return TabContent
end

-- ═══════════════════════════════════════════════
-- UI ЭЛЕМЕНТЫ (ImGui Style Components)
-- ═══════════════════════════════════════════════

-- ── Разделитель (Section Header) ──
local function CreateSection(parent, text)
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, -4, 0, 18)
    sep.BackgroundTransparency = 1
    sep.ZIndex = 53
    sep.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "» " .. text
    label.TextColor3 = Colors.Accent
    label.TextSize = 10
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 54
    label.Parent = sep

    return sep
end

-- ── Линия-разделитель ──
local function CreateSeparator(parent)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -4, 0, 1)
    line.BackgroundColor3 = Colors.SepLine
    line.BorderSizePixel = 0
    line.ZIndex = 53
    line.Parent = parent
    return line
end

-- ── Чекбокс (Toggle) ──
local function CreateCheckbox(parent, name, default, callback)
    local state = default or false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -4, 0, 22)
    container.BackgroundColor3 = Colors.ElementBg
    container.BorderSizePixel = 0
    container.ZIndex = 53
    container.Parent = parent

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 2)
    cCorner.Parent = container

    -- Чекбокс
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 14, 0, 14)
    box.Position = UDim2.new(0, 6, 0.5, -7)
    box.BackgroundColor3 = state and Colors.CheckOn or Color3.fromRGB(20, 20, 25)
    box.BorderSizePixel = 0
    box.ZIndex = 54
    box.Parent = container

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 2)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = state and Colors.StrokeAccent or Colors.StrokeDim
    boxStroke.Thickness = 1
    boxStroke.Parent = box

    local checkMark = Instance.new("TextLabel")
    checkMark.Size = UDim2.new(1, 0, 1, 0)
    checkMark.BackgroundTransparency = 1
    checkMark.Text = state and "✓" or ""
    checkMark.TextColor3 = Colors.AccentBright
    checkMark.TextSize = 12
    checkMark.Font = Enum.Font.Code
    checkMark.ZIndex = 55
    checkMark.Parent = box

    -- Название
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 26, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 11
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 54
    label.Parent = container

    -- Статус справа
    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(0, 30, 1, 0)
    statusLbl.Position = UDim2.new(1, -34, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = state and "ON" or ""
    statusLbl.TextColor3 = state and Colors.Success or Colors.TextDim
    statusLbl.TextSize = 9
    statusLbl.Font = Enum.Font.Code
    statusLbl.TextXAlignment = Enum.TextXAlignment.Right
    statusLbl.ZIndex = 54
    statusLbl.Parent = container

    -- Кнопка поверх всего
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 56
    btn.Parent = container

    btn.MouseButton1Click:Connect(function()
        state = not state
        checkMark.Text = state and "✓" or ""
        boxStroke.Color = state and Colors.StrokeAccent or Colors.StrokeDim
        box.BackgroundColor3 = state and Colors.CheckOn or Color3.fromRGB(20, 20, 25)
        statusLbl.Text = state and "ON" or ""
        statusLbl.TextColor3 = state and Colors.Success or Colors.TextDim
        if callback then callback(state) end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ElementHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(container, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ElementBg}):Play()
    end)

    return {
        Frame = container,
        SetState = function(val)
            state = val
            checkMark.Text = state and "✓" or ""
            boxStroke.Color = state and Colors.StrokeAccent or Colors.StrokeDim
            box.BackgroundColor3 = state and Colors.CheckOn or Color3.fromRGB(20, 20, 25)
            statusLbl.Text = state and "ON" or ""
            statusLbl.TextColor3 = state and Colors.Success or Colors.TextDim
        end,
        GetState = function() return state end
    }
end

-- ── Кнопка ──
local function CreateButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 22)
    btn.BackgroundColor3 = Colors.ButtonBg
    btn.Text = name
    btn.TextColor3 = Colors.Text
    btn.TextSize = 11
    btn.Font = Enum.Font.Code
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 53
    btn.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 2)
    bCorner.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Colors.StrokeDim
    bStroke.Thickness = 1
    bStroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ButtonHover}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.1), {Color = Colors.StrokeAccent}):Play()
        btn.TextColor3 = Colors.TextBright
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Colors.ButtonBg}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.1), {Color = Colors.StrokeDim}):Play()
        btn.TextColor3 = Colors.Text
    end)

    btn.MouseButton1Click:Connect(function()
        -- Эффект клика
        TweenService:Create(btn, TweenInfo.new(0.05), {BackgroundColor3 = Colors.AccentBright}):Play()
        task.wait(0.05)
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Colors.ButtonBg}):Play()
        if callback then callback() end
    end)

    return btn
end

-- ── Слайдер ──
local function CreateSlider(parent, name, min, max, default, callback)
    local value = default or min

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -4, 0, 40)
    container.BackgroundColor3 = Colors.ElementBg
    container.BorderSizePixel = 0
    container.ZIndex = 53
    container.Parent = parent

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 2)
    sCorner.Parent = container

    -- Название
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 0, 16)
    label.Position = UDim2.new(0, 8, 0, 3)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 10
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 54
    label.Parent = container

    -- Значение
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 45, 0, 16)
    valLbl.Position = UDim2.new(1, -50, 0, 3)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(math.floor(value))
    valLbl.TextColor3 = Colors.AccentBright
    valLbl.TextSize = 10
    valLbl.Font = Enum.Font.Code
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 54
    valLbl.Parent = container

    -- Трек
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 6)
    track.Position = UDim2.new(0, 8, 0, 25)
    track.BackgroundColor3 = Colors.SliderBg
    track.BorderSizePixel = 0
    track.ZIndex = 54
    track.Parent = container

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    -- Заполнение
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.SliderFill
    fill.BorderSizePixel = 0
    fill.ZIndex = 55
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    -- Ручка
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new((value - min) / (max - min), -6, 0.5, -6)
    knob.BackgroundColor3 = Colors.TextBright
    knob.BorderSizePixel = 0
    knob.ZIndex = 56
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    -- Кнопка для взаимодействия
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 0, 18)
    sliderBtn.Position = UDim2.new(0, 0, 0, 20)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 57
    sliderBtn.Parent = container

    local sliding = false

    local function updateSlider(posX)
        local absX = track.AbsolutePosition.X
        local absW = track.AbsoluteSize.X
        local rel = math.clamp((posX - absX) / absW, 0, 1)
        value = math.floor(min + (max - min) * rel)
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, -6, 0.5, -6)
        if callback then callback(value) end
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateSlider(input.Position.X)
        end
    end)
    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    return {
        Frame = container,
        GetValue = function() return value end,
        SetValue = function(v)
            value = math.clamp(math.floor(v), min, max)
            local rel = (value - min) / (max - min)
            valLbl.Text = tostring(value)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -6, 0.5, -6)
        end
    }
end

-- ── Текст/Инфо ──
local function CreateLabel(parent, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -4, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Colors.TextDim
    lbl.TextSize = 10
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 53
    lbl.Parent = parent
    return lbl
end

-- ═══════════════════════════════════════════════
-- СОЗДАНИЕ ТАБОВ
-- ═══════════════════════════════════════════════

local TabPlayer  = CreateTab("PLAYER")
local TabCombat  = CreateTab("COMBAT")
local TabVisual  = CreateTab("VISUAL")
local TabTP      = CreateTab("TP")
local TabInfo    = CreateTab("INFO")

-- ═══════════════════════════════════════════════
-- СОСТОЯНИЯ ФУНКЦИЙ
-- ═══════════════════════════════════════════════

local Flags = {
    -- Player
    Noclip = false,
    InfiniteJump = false,
    GodMode = false,
    Fly = false,
    FlySpeed = 50,
    Speed = 16,
    JumpPower = 50,
    AntiFling = false,
    AntiAFK = false,

    -- Combat
    InfiniteStamina = false,
    OneHitKO = false,
    NoCooldown = false,
    AutoPunch = false,

    -- Visual
    ESP = false,
    Fullbright = false,
    NoFog = false,
    BigHead = false,

    -- TP
    ClickTP = false,
    SavedPos = nil,
}

-- ═══════════════════════════════════════════════
-- TAB: PLAYER
-- ═══════════════════════════════════════════════

CreateSection(TabPlayer, "Movement")
CreateSeparator(TabPlayer)

CreateSlider(TabPlayer, "WalkSpeed", 16, 500, 16, function(val)
    Flags.Speed = val
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end)
end)

CreateSlider(TabPlayer, "JumpPower", 50, 500, 50, function(val)
    Flags.JumpPower = val
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = val
            char.Humanoid.UseJumpPower = true
        end
    end)
end)

CreateSeparator(TabPlayer)
CreateSection(TabPlayer, "Abilities")
CreateSeparator(TabPlayer)

CreateCheckbox(TabPlayer, "Noclip", false, function(state)
    Flags.Noclip = state
    Notify("Noclip", state and "Enabled — walk through walls" or "Disabled", state and "success" or "info")
end)

CreateCheckbox(TabPlayer, "Infinite Jump", false, function(state)
    Flags.InfiniteJump = state
    Notify("Infinite Jump", state and "Enabled" or "Disabled", state and "success" or "info")
end)

CreateCheckbox(TabPlayer, "God Mode", false, function(state)
    Flags.GodMode = state
    Notify("God Mode", state and "You are immortal!" or "Disabled", state and "success" or "info")
end)

CreateCheckbox(TabPlayer, "Anti-Fling", false, function(state)
    Flags.AntiFling = state
    Notify("Anti-Fling", state and "Protection ON" or "Disabled", state and "success" or "info")
end)

CreateSeparator(TabPlayer)
CreateSection(TabPlayer, "Fly")
CreateSeparator(TabPlayer)

CreateCheckbox(TabPlayer, "Fly", false, function(state)
    Flags.Fly = state
    Notify("Fly", state and "Enabled — use jump" or "Disabled", state and "success" or "info")
end)

CreateSlider(TabPlayer, "Fly Speed", 10, 200, 50, function(val)
    Flags.FlySpeed = val
end)

CreateSeparator(TabPlayer)
CreateSection(TabPlayer, "Actions")
CreateSeparator(TabPlayer)

CreateButton(TabPlayer, "[ Reset Character ]", function()
    pcall(function() Player.Character:BreakJoints() end)
    Notify("Reset", "Character respawned", "info")
end)

CreateCheckbox(TabPlayer, "Anti-AFK", false, function(state)
    Flags.AntiAFK = state
    Notify("Anti-AFK", state and "Won't be kicked" or "Disabled", state and "success" or "info")
end)

-- ═══════════════════════════════════════════════
-- TAB: COMBAT
-- ═══════════════════════════════════════════════

CreateSection(TabCombat, "Combat Cheats")
CreateSeparator(TabCombat)

CreateCheckbox(TabCombat, "Infinite Stamina", false, function(state)
    Flags.InfiniteStamina = state
    Notify("Stamina", state and "Infinite stamina ON" or "Disabled", state and "success" or "info")
end)

CreateCheckbox(TabCombat, "One Hit KO", false, function(state)
    Flags.OneHitKO = state
    Notify("One Hit", state and "Damage boosted!" or "Disabled", state and "success" or "info")
end)

CreateCheckbox(TabCombat, "No Attack Cooldown", false, function(state)
    Flags.NoCooldown = state
    Notify("Cooldown", state and "No cooldowns" or "Disabled", state and "success" or "info")
end)

CreateCheckbox(TabCombat, "Auto Punch (Nearest)", false, function(state)
    Flags.AutoPunch = state
    Notify("Auto Punch", state and "Auto attacking" or "Disabled", state and "success" or "info")
end)

CreateSeparator(TabCombat)
CreateSection(TabCombat, "Quick Actions")
CreateSeparator(TabCombat)

CreateButton(TabCombat, "[ Kill All Nearby (15 studs) ]", function()
    pcall(function()
        local char = Player.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local count = 0
        for _, model in pairs(Workspace:GetDescendants()) do
            if model:IsA("Humanoid") and model.Parent ~= char then
                local root = model.Parent:FindFirstChild("HumanoidRootPart") or model.Parent:FindFirstChild("Torso")
                if root and (root.Position - myRoot.Position).Magnitude < 15 then
                    model.Health = 0
                    count = count + 1
                end
            end
        end
        Notify("Kill All", "Killed " .. count .. " nearby", count > 0 and "success" or "warning")
    end)
end)

CreateButton(TabCombat, "[ Refill Stamina Now ]", function()
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
    end)
    Notify("Stamina", "Refilled!", "success")
end)

-- ═══════════════════════════════════════════════
-- TAB: VISUAL
-- ═══════════════════════════════════════════════

CreateSection(TabVisual, "Lighting")
CreateSeparator(TabVisual)

CreateCheckbox(TabVisual, "Fullbright", false, function(state)
    Flags.Fullbright = state
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
    Notify("Fullbright", state and "World is bright" or "Normal lighting", state and "success" or "info")
end)

CreateCheckbox(TabVisual, "No Fog", false, function(state)
    Flags.NoFog = state
    if state then
        Lighting.FogEnd = 9999999
        Lighting.FogStart = 9999999
    else
        Lighting.FogEnd = 5000
        Lighting.FogStart = 0
    end
    Notify("Fog", state and "Fog removed" or "Fog restored", state and "success" or "info")
end)

CreateSeparator(TabVisual)
CreateSection(TabVisual, "ESP & Players")
CreateSeparator(TabVisual)

CreateCheckbox(TabVisual, "ESP (See Players)", false, function(state)
    Flags.ESP = state
    Notify("ESP", state and "All players visible" or "Disabled", state and "success" or "info")
end)

CreateCheckbox(TabVisual, "Big Head", false, function(state)
    Flags.BigHead = state
    Notify("Big Head", state and "Heads enlarged" or "Normal", state and "success" or "info")
end)

CreateSeparator(TabVisual)
CreateSection(TabVisual, "Time of Day")
CreateSeparator(TabVisual)

CreateSlider(TabVisual, "Time", 0, 24, 14, function(val)
    Lighting.ClockTime = val
end)

CreateButton(TabVisual, "[ Set Day ]", function()
    Lighting.ClockTime = 14
    Notify("Time", "Set to day", "info")
end)

CreateButton(TabVisual, "[ Set Night ]", function()
    Lighting.ClockTime = 0
    Notify("Time", "Set to night", "info")
end)

-- ═══════════════════════════════════════════════
-- TAB: TP (Teleport)
-- ═══════════════════════════════════════════════

CreateSection(TabTP, "Teleport")
CreateSeparator(TabTP)

CreateCheckbox(TabTP, "Click TP", false, function(state)
    Flags.ClickTP = state
    Notify("Click TP", state and "Click anywhere to TP" or "Disabled", state and "success" or "info")
end)

CreateSeparator(TabTP)

CreateButton(TabTP, "[ TP to Random Player ]", function()
    pcall(function()
        local plrs = Players:GetPlayers()
        local target = plrs[math.random(1, #plrs)]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                Notify("Teleport", "TP to " .. target.Name, "success")
            end
        end
    end)
end)

CreateButton(TabTP, "[ TP Up +100 ]", function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
            Notify("Teleport", "Teleported up +100", "info")
        end
    end)
end)

CreateButton(TabTP, "[ Save Position ]", function()
    pcall(function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            Flags.SavedPos = char.HumanoidRootPart.CFrame
            Notify("Waypoint", "Position saved!", "success")
        end
    end)
end)

CreateButton(TabTP, "[ Load Position ]", function()
    if Flags.SavedPos then
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = Flags.SavedPos
                Notify("Waypoint", "Teleported to saved pos", "success")
            end
        end)
    else
        Notify("Waypoint", "No position saved!", "error")
    end
end)

CreateSeparator(TabTP)
CreateSection(TabTP, "TP to Players")
CreateSeparator(TabTP)

CreateButton(TabTP, "[ Refresh Player List ]", function()
    -- Удаляем старые ТП кнопки
    for _, child in pairs(TabTP:GetChildren()) do
        if child:GetAttribute("PlayerTPBtn") then
            child:Destroy()
        end
    end
    -- Создаём новые
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local b = CreateButton(TabTP, "> " .. plr.Name, function()
                pcall(function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local char = Player.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            Notify("TP", "Teleported to " .. plr.Name, "success")
                        end
                    else
                        Notify("TP", plr.Name .. " not found", "error")
                    end
                end)
            end)
            b:SetAttribute("PlayerTPBtn", true)
        end
    end
    Notify("Players", "List refreshed", "info")
end)

-- ═══════════════════════════════════════════════
-- TAB: INFO
-- ═══════════════════════════════════════════════

CreateSection(TabInfo, "Excalibur Info")
CreateSeparator(TabInfo)
CreateLabel(TabInfo, "Cheat: Excalibur v2.0")
CreateLabel(TabInfo, "Style: ImGui / MimGui")
CreateLabel(TabInfo, "Platform: " .. (UserInputService.TouchEnabled and "Mobile" or "PC"))
CreateLabel(TabInfo, "Player: " .. Player.Name)
CreateLabel(TabInfo, "Game: " .. tostring(game.PlaceId))
CreateLabel(TabInfo, "Status: Active", Colors.Success)

CreateSeparator(TabInfo)
CreateSection(TabInfo, "Server Stats")
CreateSeparator(TabInfo)

local fpsLabel = CreateLabel(TabInfo, "FPS: calculating...")
local pingLabel = CreateLabel(TabInfo, "Ping: calculating...")
local playersLabel = CreateLabel(TabInfo, "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
CreateLabel(TabInfo, "Server: " .. tostring(game.JobId):sub(1, 12) .. "...")

CreateSeparator(TabInfo)
CreateSection(TabInfo, "Controls")
CreateSeparator(TabInfo)
CreateLabel(TabInfo, "Drag title bar to move")
CreateLabel(TabInfo, "EXC button to toggle menu")
CreateLabel(TabInfo, "RightShift / Insert hotkey")

CreateSeparator(TabInfo)
CreateSection(TabInfo, "Quick")
CreateSeparator(TabInfo)

CreateButton(TabInfo, "[ Rejoin Server ]", function()
    Notify("Rejoin", "Reconnecting...", "warning", 2)
    task.wait(1)
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end)
end)

CreateButton(TabInfo, "[ Leave Game ]", function()
    Notify("Leave", "Goodbye!", "warning", 1.5)
    task.wait(1)
    Player:Kick("Excalibur — See you!")
end)

CreateButton(TabInfo, "[ Destroy GUI ]", function()
    Notify("Excalibur", "Destroying GUI...", "warning", 1.5)
    task.wait(1.5)
    ScreenGui:Destroy()
end)

CreateSeparator(TabInfo)
CreateSection(TabInfo, "Notifications Test")
CreateSeparator(TabInfo)

CreateButton(TabInfo, "[ Test Success ]", function()
    Notify("Test", "Success notification!", "success")
end)
CreateButton(TabInfo, "[ Test Warning ]", function()
    Notify("Test", "Warning notification!", "warning")
end)
CreateButton(TabInfo, "[ Test Error ]", function()
    Notify("Test", "Error notification!", "error")
end)
CreateButton(TabInfo, "[ Test Info ]", function()
    Notify("Test", "Info notification!", "info")
end)

-- ═══════════════════════════════════════════════
-- ОТКРЫТИЕ / ЗАКРЫТИЕ МЕНЮ
-- ═══════════════════════════════════════════════

local menuOpen = false
local menuAnimating = false

local function ToggleMenu()
    if menuAnimating then return end
    menuAnimating = true
    menuOpen = not menuOpen

    if menuOpen then
        MainWindow.Visible = true
        MainWindow.Size = UDim2.new(0, 310, 0, 0)
        MainWindow.BackgroundTransparency = 0.3

        local t = TweenService:Create(MainWindow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 310, 0, 380),
            BackgroundTransparency = 0
        })
        t:Play()
        t.Completed:Wait()

        -- Кнопка зелёная
        TweenService:Create(OpenStroke, TweenInfo.new(0.2), {Color = Colors.Success}):Play()
        OpenText1.TextColor3 = Colors.Success
        OpenText2.TextColor3 = Colors.Success
    else
        local t = TweenService:Create(MainWindow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 310, 0, 0),
            BackgroundTransparency = 0.3
        })
        t:Play()
        t.Completed:Wait()
        MainWindow.Visible = false

        -- Кнопка фиолетовая
        TweenService:Create(OpenStroke, TweenInfo.new(0.2), {Color = Colors.Accent}):Play()
        OpenText1.TextColor3 = Colors.Accent
        OpenText2.TextColor3 = Colors.AccentBright
    end

    menuAnimating = false
end

OpenBtn.MouseButton1Click:Connect(function()
    if not btnMoved then
        ToggleMenu()
    end
    btnMoved = false
end)

CloseX.MouseButton1Click:Connect(function()
    if menuOpen then ToggleMenu() end
end)

-- Минимизация (скрыть/показать контент)
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainWindow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 310, 0, 26)
        }):Play()
        MinBtn.Text = "□"
    else
        TweenService:Create(MainWindow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 310, 0, 380)
        }):Play()
        MinBtn.Text = "_"
    end
end)

-- Горячие клавиши
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then
        ToggleMenu()
    end
end)

-- ═══════════════════════════════════════════════
-- ФУНКЦИОНАЛЬНОСТЬ (Game Loops)
-- ═══════════════════════════════════════════════

-- Noclip
RunService.Stepped:Connect(function()
    if Flags.Noclip then
        pcall(function()
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Flags.InfiniteJump then
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if Flags.GodMode then
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.MaxHealth = math.huge
                char.Humanoid.Health = math.huge
            end
        end)
    end
end)

-- Anti-Fling
RunService.Heartbeat:Connect(function()
    if Flags.AntiFling then
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                hrp.Velocity = Vector3.new(
                    math.clamp(hrp.Velocity.X, -50, 50),
                    math.clamp(hrp.Velocity.Y, -50, 50),
                    math.clamp(hrp.Velocity.Z, -50, 50)
                )
                hrp.RotVelocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end)

-- Fly
local flyBP, flyBG

local function startFly()
    pcall(function()
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        flyBP = Instance.new("BodyPosition")
        flyBP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBP.D = 100
        flyBP.P = 10000
        flyBP.Position = hrp.Position
        flyBP.Parent = hrp

        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyBG.D = 100
        flyBG.P = 10000
        flyBG.CFrame = hrp.CFrame
        flyBG.Parent = hrp

        char.Humanoid.PlatformStand = true
    end)
end

local function stopFly()
    pcall(function()
        if flyBP then flyBP:Destroy() flyBP = nil end
        if flyBG then flyBG:Destroy() flyBG = nil end
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if Flags.Fly then
        pcall(function()
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            if not flyBP then startFly() end

            local hrp = char.HumanoidRootPart
            local camCF = Camera.CFrame
            local dir = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

            -- Mobile
            if UserInputService.TouchEnabled then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    dir = dir + hum.MoveDirection
                end
            end

            if dir.Magnitude > 0 then
                dir = dir.Unit * Flags.FlySpeed
            end

            flyBP.Position = hrp.Position + dir
            flyBG.CFrame = camCF
        end)
    else
        if flyBP then stopFly() end
    end
end)

-- Click TP
Mouse.Button1Down:Connect(function()
    if Flags.ClickTP then
        pcall(function()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
            end
        end)
    end
end)

-- ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "Excalibur_ESP"
ESPFolder.Parent = Camera

local function SetupESP(plr)
    if plr == Player then return end

    local function onChar(char)
        if not char then return end
        local head = char:WaitForChild("Head", 5)
        if not head then return end

        -- Удаляем старый
        for _, v in pairs(ESPFolder:GetChildren()) do
            if v.Name == plr.Name then v:Destroy() end
        end

        local bb = Instance.new("BillboardGui")
        bb.Name = plr.Name
        bb.Adornee = head
        bb.Size = UDim2.new(0, 180, 0, 40)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true
        bb.Parent = ESPFolder

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, 0, 0, 16)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = plr.Name
        nameLbl.TextSize = 12
        nameLbl.Font = Enum.Font.Code
        nameLbl.TextColor3 = Colors.AccentBright
        nameLbl.TextStrokeTransparency = 0.5
        nameLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLbl.Parent = bb

        local distLbl = Instance.new("TextLabel")
        distLbl.Size = UDim2.new(1, 0, 0, 14)
        distLbl.Position = UDim2.new(0, 0, 0, 16)
        distLbl.BackgroundTransparency = 1
        distLbl.TextSize = 10
        distLbl.Font = Enum.Font.Code
        distLbl.TextStrokeTransparency = 0.5
        distLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        distLbl.Parent = bb

        local hl = Instance.new("Highlight")
        hl.Name = "ESP_HL"
        hl.FillColor = Colors.Accent
        hl.FillTransparency = 0.75
        hl.OutlineColor = Colors.AccentBright
        hl.OutlineTransparency = 0.3
        hl.Parent = char

        task.spawn(function()
            while bb and bb.Parent and char and char.Parent do
                if Flags.ESP then
                    bb.Enabled = true
                    hl.Enabled = true
                    pcall(function()
                        local myChar = Player.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                            local d = (myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                            distLbl.Text = string.format("[%.0f studs]", d)
                        end
                        local hum = char:FindFirstChild("Humanoid")
                        if hum then
                            local ratio = hum.Health / hum.MaxHealth
                            distLbl.TextColor3 = Color3.fromRGB(255 * (1 - ratio), 255 * ratio, 0)
                        end
                    end)
                else
                    bb.Enabled = false
                    hl.Enabled = false
                end
                task.wait(0.25)
            end
        end)
    end

    if plr.Character then onChar(plr.Character) end
    plr.CharacterAdded:Connect(function(c) task.wait(1) onChar(c) end)
end

for _, p in pairs(Players:GetPlayers()) do SetupESP(p) end
Players.PlayerAdded:Connect(SetupESP)

-- Big Head
RunService.Heartbeat:Connect(function()
    if Flags.BigHead then
        pcall(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player and p.Character then
                    local head = p.Character:FindFirstChild("Head")
                    if head then head.Size = Vector3.new(5, 5, 5) end
                end
            end
        end)
    end
end)

-- Infinite Stamina Loop
task.spawn(function()
    while task.wait(0.1) do
        if Flags.InfiniteStamina then
            pcall(function()
                local char = Player.Character
                if not char then return end
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
                end
                for _, attr in pairs({"Stamina", "Energy", "Endurance", "Power"}) do
                    if char:GetAttribute(attr) ~= nil then
                        char:SetAttribute(attr, 999999)
                    end
                end
            end)
        end
    end
end)

-- One Hit KO Loop
task.spawn(function()
    while task.wait(0.2) do
        if Flags.OneHitKO then
            pcall(function()
                local char = Player.Character
                if not char then return end
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local n = v.Name:lower()
                        if n:find("damage") or n:find("dmg") or n:find("power") or n:find("strength") or n:find("attack") or n:find("force") then
                            v.Value = 999999
                        end
                    end
                end
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
task.spawn(function()
    while task.wait(0.3) do
        if Flags.AutoPunch then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                for _, model in pairs(Workspace:GetDescendants()) do
                    if model:IsA("Humanoid") and model.Parent ~= char and model.Health > 0 then
                        local root = model.Parent:FindFirstChild("HumanoidRootPart") or model.Parent:FindFirstChild("Torso")
                        if root and (root.Position - myRoot.Position).Magnitude < 20 then
                            model.Health = 0
                        end
                    end
                end
            end)
        end
    end
end)

-- Anti-AFK
pcall(function()
    local VU = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        if Flags.AntiAFK then
            VU:Button2Down(Vector2.new(0, 0), Camera.CFrame)
            task.wait(1)
            VU:Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end
    end)
end)

-- WalkSpeed on respawn
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    pcall(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.WalkSpeed = Flags.Speed
            hum.JumpPower = Flags.JumpPower
            hum.UseJumpPower = true
        end
    end)
end)

-- Hook Remotes (если поддерживается)
pcall(function()
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if (method == "FireServer" or method == "InvokeServer") and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
            local rName = self.Name:lower()

            if Flags.InfiniteStamina then
                if rName:find("stam") or rName:find("energy") or rName:find("fatigue") or rName:find("tired") then
                    return nil
                end
            end

            if Flags.NoCooldown then
                if rName:find("cooldown") or rName:find("delay") then
                    return nil
                end
            end

            if Flags.OneHitKO then
                if rName:find("damage") or rName:find("hit") or rName:find("punch") or rName:find("attack") or rName:find("dmg") then
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

-- FPS / Ping update
task.spawn(function()
    local lastT = tick()
    local frames = 0
    while ScreenGui.Parent do
        frames = frames + 1
        if tick() - lastT >= 1 then
            pcall(function()
                fpsLabel.Text = "FPS: " .. frames
                pingLabel.Text = "Ping: " .. math.floor(Player:GetNetworkPing() * 1000) .. "ms"
                playersLabel.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
            end)
            frames = 0
            lastT = tick()
        end
        task.wait()
    end
end)

-- ═══════════════════════════════════════════════
-- СТАРТОВЫЕ УВЕДОМЛЕНИЯ
-- ═══════════════════════════════════════════════

task.wait(0.5)
Notify("⚔ EXCALIBUR", "Cheat loaded successfully!", "success", 4)
task.wait(0.8)
Notify("Controls", "Tap EXC button or RightShift", "info", 3.5)
task.wait(0.5)
Notify("Welcome", "Hello, " .. Player.Name .. "!", "info", 3)

-- Стандартное уведомление Roblox
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "⚔ Excalibur Loaded",
        Text = "Tap EXC button or press RightShift",
        Duration = 5
    })
end)

print("═══════════════════════════════")
print("  ⚔ EXCALIBUR v2.0 LOADED")
print("  ImGui Style Menu")
print("  Tap EXC button to open")
print("  Or press RightShift/Insert")
print("═══════════════════════════════")
