--[[
    ╔══════════════════════════════════════════╗
    ║         EXCALIBUR HUB v2.0              ║
    ║    Universal Script | Mobile Ready      ║
    ║         ImGui Style Menu                ║
    ╚══════════════════════════════════════════╝
]]

-- Защита от повторного запуска
if getgenv and getgenv().ExcaliburLoaded then return end
if getgenv then getgenv().ExcaliburLoaded = true end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════
-- КОНФИГУРАЦИЯ
-- ═══════════════════════════════════════════
local Config = {
    -- Цвета темы
    AccentColor = Color3.fromRGB(88, 101, 242),    -- Основной акцент
    AccentColor2 = Color3.fromRGB(130, 140, 255),   -- Второй акцент
    BackgroundColor = Color3.fromRGB(18, 18, 24),    -- Фон
    SidebarColor = Color3.fromRGB(22, 22, 30),       -- Боковая панель
    CardColor = Color3.fromRGB(28, 28, 38),          -- Карточки
    CardHover = Color3.fromRGB(35, 35, 48),          -- Hover карточки
    TextColor = Color3.fromRGB(255, 255, 255),       -- Текст
    TextDim = Color3.fromRGB(150, 150, 170),         -- Приглушённый текст
    ToggleOn = Color3.fromRGB(88, 101, 242),         -- Вкл
    ToggleOff = Color3.fromRGB(60, 60, 80),          -- Выкл
    SliderFill = Color3.fromRGB(88, 101, 242),       -- Слайдер
    DangerColor = Color3.fromRGB(255, 70, 70),       -- Опасность
    SuccessColor = Color3.fromRGB(70, 255, 100),     -- Успех
    WarningColor = Color3.fromRGB(255, 200, 50),     -- Предупреждение
    FrostColor = Color3.fromRGB(100, 200, 255),      -- Frost тема

    -- Настройки
    AnimSpeed = 0.3,
    CornerRadius = UDim.new(0, 8),
    Font = Enum.Font.GothamBold,
    FontRegular = Enum.Font.Gotham,
    FontMono = Enum.Font.Code,
}

-- ═══════════════════════════════════════════
-- СОСТОЯНИЕ
-- ═══════════════════════════════════════════
local State = {
    MenuOpen = false,
    CurrentTab = "Excalibur",
    Toggles = {},
    Sliders = {},
    Connections = {},
    Notifications = {},
}

-- ═══════════════════════════════════════════
-- УТИЛИТЫ
-- ═══════════════════════════════════════════
local function Tween(obj, props, duration, style, direction)
    local tw = TweenService:Create(obj,
        TweenInfo.new(duration or Config.AnimSpeed, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or Config.CornerRadius
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(50, 50, 70)
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function CreatePadding(parent, t, b, l, r)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, t or 8)
    padding.PaddingBottom = UDim.new(0, b or 8)
    padding.PaddingLeft = UDim.new(0, l or 8)
    padding.PaddingRight = UDim.new(0, r or 8)
    padding.Parent = parent
    return padding
end

local function CreateShadow(parent, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function RippleEffect(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 5
    ripple.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple

    local pos = Vector2.new(x - button.AbsolutePosition.X, y - button.AbsolutePosition.Y)
    ripple.Position = UDim2.new(0, pos.X, 0, pos.Y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)

    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5)

    task.delay(0.5, function()
        if ripple then ripple:Destroy() end
    end)
end

-- ═══════════════════════════════════════════
-- СОЗДАНИЕ GUI
-- ═══════════════════════════════════════════

-- Основной ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExcaliburHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Совместимость
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
end)

ScreenGui.Parent = (game:GetService("CoreGui") ~= nil and game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════
-- СИСТЕМА УВЕДОМЛЕНИЙ
-- ═══════════════════════════════════════════
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "Notifications"
NotifContainer.BackgroundTransparency = 1
NotifContainer.Size = UDim2.new(0, 320, 1, 0)
NotifContainer.Position = UDim2.new(1, -330, 0, 0)
NotifContainer.ZIndex = 100
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifLayout.Parent = NotifContainer

local NotifPadding = Instance.new("UIPadding")
NotifPadding.PaddingBottom = UDim.new(0, 40)
NotifPadding.PaddingRight = UDim.new(0, 10)
NotifPadding.Parent = NotifContainer

local function Notify(title, text, duration, notifType)
    duration = duration or 4
    notifType = notifType or "info"

    local colors = {
        info = Config.AccentColor,
        success = Config.SuccessColor,
        warning = Config.WarningColor,
        error = Config.DangerColor,
        frost = Config.FrostColor,
    }

    local icons = {
        info = "ℹ️",
        success = "✅",
        warning = "⚠️",
        error = "❌",
        frost = "❄️",
    }

    local accentColor = colors[notifType] or colors.info
    local icon = icons[notifType] or icons.info

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.BackgroundColor3 = Config.CardColor
    NotifFrame.Size = UDim2.new(1, 0, 0, 75)
    NotifFrame.Position = UDim2.new(1, 50, 0, 0)
    NotifFrame.ClipsDescendants = true
    NotifFrame.ZIndex = 101
    NotifFrame.Parent = NotifContainer
    CreateCorner(NotifFrame, UDim.new(0, 10))
    CreateStroke(NotifFrame, accentColor, 1.5)
    CreateShadow(NotifFrame, 20)

    -- Акцентная полоска слева
    local AccentBar = Instance.new("Frame")
    AccentBar.Name = "AccentBar"
    AccentBar.BackgroundColor3 = accentColor
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.Position = UDim2.new(0, 0, 0, 0)
    AccentBar.BorderSizePixel = 0
    AccentBar.ZIndex = 102
    AccentBar.Parent = NotifFrame

    -- Иконка
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 14, 0, 10)
    IconLabel.Text = icon
    IconLabel.TextSize = 18
    IconLabel.Font = Config.Font
    IconLabel.TextColor3 = accentColor
    IconLabel.ZIndex = 102
    IconLabel.Parent = NotifFrame

    -- Заголовок
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -60, 0, 22)
    TitleLabel.Position = UDim2.new(0, 48, 0, 10)
    TitleLabel.Text = title or "Excalibur"
    TitleLabel.TextSize = 14
    TitleLabel.Font = Config.Font
    TitleLabel.TextColor3 = Config.TextColor
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 102
    TitleLabel.Parent = NotifFrame

    -- Текст
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Text"
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, -60, 0, 20)
    TextLabel.Position = UDim2.new(0, 48, 0, 32)
    TextLabel.Text = text or ""
    TextLabel.TextSize = 12
    TextLabel.Font = Config.FontRegular
    TextLabel.TextColor3 = Config.TextDim
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.ZIndex = 102
    TextLabel.Parent = NotifFrame

    -- Прогресс бар
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "Progress"
    ProgressBar.BackgroundColor3 = accentColor
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.ZIndex = 103
    ProgressBar.Parent = NotifFrame

    -- Анимация входа
    Tween(NotifFrame, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)

    -- Анимация прогресса
    Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)

    -- Удаление
    task.delay(duration, function()
        local tw = Tween(NotifFrame, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 0.5}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        tw.Completed:Wait()
        if NotifFrame then NotifFrame:Destroy() end
    end)

    return NotifFrame
end

-- ═══════════════════════════════════════════
-- КНОПКА ОТКРЫТИЯ (МОБИЛЬНАЯ + ПК)
-- ═══════════════════════════════════════════
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.BackgroundColor3 = Config.AccentColor
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 15, 0.5, -25)
ToggleButton.Text = "⚔️"
ToggleButton.TextSize = 24
ToggleButton.Font = Config.Font
ToggleButton.TextColor3 = Config.TextColor
ToggleButton.ZIndex = 50
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ScreenGui
CreateCorner(ToggleButton, UDim.new(1, 0))
CreateShadow(ToggleButton, 15)

-- Анимация пульсации кнопки
local pulseUp = true
task.spawn(function()
    while ToggleButton and ToggleButton.Parent do
        if not State.MenuOpen then
            if pulseUp then
                Tween(ToggleButton, {Size = UDim2.new(0, 55, 0, 55), Position = UDim2.new(0, 12.5, 0.5, -27.5)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            else
                Tween(ToggleButton, {Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 15, 0.5, -25)}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            end
            pulseUp = not pulseUp
        end
        task.wait(1)
    end
end)

-- Перетаскивание кнопки (для мобильных)
local draggingToggle = false
local dragStartToggle, startPosToggle

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = ToggleButton.Position
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if draggingToggle and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStartToggle
        if delta.Magnitude > 10 then
            ToggleButton.Position = UDim2.new(
                startPosToggle.X.Scale, startPosToggle.X.Offset + delta.X,
                startPosToggle.Y.Scale, startPosToggle.Y.Offset + delta.Y
            )
        end
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local delta = input.Position - dragStartToggle
        if delta.Magnitude <= 10 then
            -- Это клик, не перетаскивание
            State.MenuOpen = not State.MenuOpen
            if State.MenuOpen then
                Tween(ToggleButton, {Rotation = 90}, 0.3)
            else
                Tween(ToggleButton, {Rotation = 0}, 0.3)
            end
        end
        draggingToggle = false
    end
end)

-- ═══════════════════════════════════════════
-- ГЛАВНОЕ ОКНО
-- ═══════════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Config.BackgroundColor
MainFrame.Size = UDim2.new(0, 580, 0, 420)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui
CreateCorner(MainFrame, UDim.new(0, 12))
CreateShadow(MainFrame, 40)

-- Обводка главного окна с градиентом
local MainStroke = CreateStroke(MainFrame, Config.AccentColor, 1.5)

-- Перетаскивание главного окна
local draggingMain = false
local dragStartMain, startPosMain

-- ═══════════════════════════════════════════
-- ВЕРХНЯЯ ПАНЕЛЬ (Title Bar)
-- ═══════════════════════════════════════════
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Config.SidebarColor
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = MainFrame

-- Перетаскивание через TitleBar
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingMain and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStartMain
        MainFrame.Position = UDim2.new(
            startPosMain.X.Scale, startPosMain.X.Offset + delta.X,
            startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = false
    end
end)

-- Лого и название
local TitleIcon = Instance.new("TextLabel")
TitleIcon.Name = "Icon"
TitleIcon.BackgroundTransparency = 1
TitleIcon.Size = UDim2.new(0, 30, 0, 30)
TitleIcon.Position = UDim2.new(0, 10, 0.5, -15)
TitleIcon.Text = "⚔️"
TitleIcon.TextSize = 18
TitleIcon.Font = Config.Font
TitleIcon.TextColor3 = Config.AccentColor
TitleIcon.ZIndex = 12
TitleIcon.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Name = "Title"
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 42, 0, 0)
TitleText.Text = "EXCALIBUR HUB"
TitleText.TextSize = 16
TitleText.Font = Config.Font
TitleText.TextColor3 = Config.TextColor
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 12
TitleText.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "Version"
VersionLabel.BackgroundTransparency = 1
VersionLabel.Size = UDim2.new(0, 40, 1, 0)
VersionLabel.Position = UDim2.new(0, 195, 0, 0)
VersionLabel.Text = "v2.0"
VersionLabel.TextSize = 10
VersionLabel.Font = Config.FontRegular
VersionLabel.TextColor3 = Config.TextDim
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.ZIndex = 12
VersionLabel.Parent = TitleBar

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.BackgroundColor3 = Config.DangerColor
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 14
CloseBtn.Font = Config.Font
CloseBtn.TextColor3 = Config.DangerColor
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 12
CloseBtn.Parent = TitleBar
CreateCorner(CloseBtn, UDim.new(1, 0))

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, {BackgroundTransparency = 0.3}, 0.2)
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, {BackgroundTransparency = 0.8}, 0.2)
end)
CloseBtn.MouseButton1Click:Connect(function()
    State.MenuOpen = false
end)

-- Кнопка сворачивания
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "Minimize"
MinBtn.BackgroundColor3 = Config.WarningColor
MinBtn.BackgroundTransparency = 0.8
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -68, 0.5, -14)
MinBtn.Text = "─"
MinBtn.TextSize = 14
MinBtn.Font = Config.Font
MinBtn.TextColor3 = Config.WarningColor
MinBtn.AutoButtonColor = false
MinBtn.ZIndex = 12
MinBtn.Parent = TitleBar
CreateCorner(MinBtn, UDim.new(1, 0))

MinBtn.MouseEnter:Connect(function()
    Tween(MinBtn, {BackgroundTransparency = 0.3}, 0.2)
end)
MinBtn.MouseLeave:Connect(function()
    Tween(MinBtn, {BackgroundTransparency = 0.8}, 0.2)
end)
MinBtn.MouseButton1Click:Connect(function()
    State.MenuOpen = false
end)

-- ═══════════════════════════════════════════
-- БОКОВАЯ ПАНЕЛЬ (Sidebar)
-- ═══════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = Config.SidebarColor
Sidebar.Size = UDim2.new(0, 150, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 11
Sidebar.Parent = MainFrame

-- Разделитель
local SidebarDivider = Instance.new("Frame")
SidebarDivider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, 0, 0, 0)
SidebarDivider.BorderSizePixel = 0
SidebarDivider.ZIndex = 12
SidebarDivider.Parent = Sidebar

local SidebarScroll = Instance.new("ScrollingFrame")
SidebarScroll.Name = "Scroll"
SidebarScroll.BackgroundTransparency = 1
SidebarScroll.Size = UDim2.new(1, 0, 1, -10)
SidebarScroll.Position = UDim2.new(0, 0, 0, 5)
SidebarScroll.ScrollBarThickness = 0
SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SidebarScroll.ZIndex = 12
SidebarScroll.Parent = Sidebar

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.Parent = SidebarScroll

CreatePadding(SidebarScroll, 5, 5, 8, 8)

-- ═══════════════════════════════════════════
-- КОНТЕНТ ОБЛАСТЬ
-- ═══════════════════════════════════════════
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.BackgroundTransparency = 1
ContentArea.Size = UDim2.new(1, -150, 1, -40)
ContentArea.Position = UDim2.new(0, 150, 0, 40)
ContentArea.ZIndex = 11
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainFrame

-- ═══════════════════════════════════════════
-- СОЗДАНИЕ ТАБОВ И КОНТЕНТА
-- ═══════════════════════════════════════════

local Tabs = {}
local TabButtons = {}
local TabContents = {}

local TabData = {
    {Name = "Excalibur", Icon = "⚔️", Order = 1},
    {Name = "Frost", Icon = "❄️", Order = 2},
    {Name = "Player", Icon = "🏃", Order = 3},
    {Name = "Combat", Icon = "💥", Order = 4},
    {Name = "Visuals", Icon = "👁️", Order = 5},
    {Name = "World", Icon = "🌍", Order = 6},
    {Name = "Teleport", Icon = "🌀", Order = 7},
    {Name = "Misc", Icon = "⚙️", Order = 8},
    {Name = "Settings", Icon = "🔧", Order = 9},
}

-- Функция создания кнопки таба
local function CreateTabButton(tabData)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabData.Name
    TabBtn.BackgroundColor3 = Config.CardColor
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, 0, 0, 36)
    TabBtn.Text = ""
    TabBtn.AutoButtonColor = false
    TabBtn.ZIndex = 13
    TabBtn.LayoutOrder = tabData.Order
    TabBtn.Parent = SidebarScroll
    CreateCorner(TabBtn, UDim.new(0, 6))

    local TabIcon = Instance.new("TextLabel")
    TabIcon.BackgroundTransparency = 1
    TabIcon.Size = UDim2.new(0, 24, 1, 0)
    TabIcon.Position = UDim2.new(0, 8, 0, 0)
    TabIcon.Text = tabData.Icon
    TabIcon.TextSize = 14
    TabIcon.Font = Config.Font
    TabIcon.TextColor3 = Config.TextDim
    TabIcon.ZIndex = 14
    TabIcon.Parent = TabBtn

    local TabLabel = Instance.new("TextLabel")
    TabLabel.BackgroundTransparency = 1
    TabLabel.Size = UDim2.new(1, -40, 1, 0)
    TabLabel.Position = UDim2.new(0, 36, 0, 0)
    TabLabel.Text = tabData.Name
    TabLabel.TextSize = 12
    TabLabel.Font = Config.FontRegular
    TabLabel.TextColor3 = Config.TextDim
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.ZIndex = 14
    TabLabel.Parent = TabBtn

    -- Индикатор активного таба
    local ActiveIndicator = Instance.new("Frame")
    ActiveIndicator.Name = "Indicator"
    ActiveIndicator.BackgroundColor3 = Config.AccentColor
    ActiveIndicator.Size = UDim2.new(0, 3, 0.6, 0)
    ActiveIndicator.Position = UDim2.new(0, 0, 0.2, 0)
    ActiveIndicator.Visible = false
    ActiveIndicator.ZIndex = 15
    ActiveIndicator.Parent = TabBtn
    CreateCorner(ActiveIndicator, UDim.new(0, 2))

    TabBtn.MouseEnter:Connect(function()
        if State.CurrentTab ~= tabData.Name then
            Tween(TabBtn, {BackgroundTransparency = 0.5}, 0.2)
            Tween(TabLabel, {TextColor3 = Config.TextColor}, 0.2)
        end
    end)

    TabBtn.MouseLeave:Connect(function()
        if State.CurrentTab ~= tabData.Name then
            Tween(TabBtn, {BackgroundTransparency = 1}, 0.2)
            Tween(TabLabel, {TextColor3 = Config.TextDim}, 0.2)
        end
    end)

    TabButtons[tabData.Name] = {Button = TabBtn, Label = TabLabel, Icon = TabIcon, Indicator = ActiveIndicator}
    return TabBtn
end

-- Функция переключения таба
local function SwitchTab(name)
    if State.CurrentTab == name then return end
    local oldTab = State.CurrentTab
    State.CurrentTab = name

    -- Обновляем кнопки
    for tabName, btn in pairs(TabButtons) do
        if tabName == name then
            Tween(btn.Button, {BackgroundTransparency = 0.3}, 0.2)
            Tween(btn.Label, {TextColor3 = Config.TextColor}, 0.2)
            btn.Indicator.Visible = true
            Tween(btn.Indicator, {BackgroundTransparency = 0}, 0.2)
        else
            Tween(btn.Button, {BackgroundTransparency = 1}, 0.2)
            Tween(btn.Label, {TextColor3 = Config.TextDim}, 0.2)
            btn.Indicator.Visible = false
        end
    end

    -- Переключаем контент с анимацией
    for tabName, content in pairs(TabContents) do
        if tabName == name then
            content.Visible = true
            content.Position = UDim2.new(0.05, 0, 0, 0)
            content.GroupTransparency = 1
            Tween(content, {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}, 0.3)
        else
            if content.Visible and tabName == oldTab then
                local tw = Tween(content, {Position = UDim2.new(-0.05, 0, 0, 0), GroupTransparency = 1}, 0.2)
                local c = content
                tw.Completed:Connect(function()
                    c.Visible = false
                end)
            else
                content.Visible = false
            end
        end
    end
end

-- Создание контент страницы
local function CreateTabContent(name)
    local ContentPage = Instance.new("CanvasGroup")
    ContentPage.Name = name .. "Page"
    ContentPage.BackgroundTransparency = 1
    ContentPage.Size = UDim2.new(1, 0, 1, 0)
    ContentPage.Position = UDim2.new(0, 0, 0, 0)
    ContentPage.Visible = false
    ContentPage.ZIndex = 12
    ContentPage.Parent = ContentArea

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = "Scroll"
    Scroll.BackgroundTransparency = 1
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = Config.AccentColor
    Scroll.ZIndex = 13
    Scroll.Parent = ContentPage

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Scroll

    CreatePadding(Scroll, 12, 12, 15, 15)

    TabContents[name] = ContentPage
    return Scroll
end

-- ═══════════════════════════════════════════
-- ЭЛЕМЕНТЫ UI (Компоненты)
-- ═══════════════════════════════════════════

-- Заголовок секции
local function CreateSection(parent, text, order)
    local Section = Instance.new("Frame")
    Section.Name = "Section_" .. text
    Section.BackgroundTransparency = 1
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.ZIndex = 14
    Section.LayoutOrder = order or 0
    Section.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Text = "  " .. string.upper(text)
    Label.TextSize = 11
    Label.Font = Config.Font
    Label.TextColor3 = Config.AccentColor
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 15
    Label.Parent = Section

    -- Линия
    local Line = Instance.new("Frame")
    Line.BackgroundColor3 = Config.AccentColor
    Line.BackgroundTransparency = 0.7
    Line.Size = UDim2.new(1, -10, 0, 1)
    Line.Position = UDim2.new(0, 5, 1, -2)
    Line.BorderSizePixel = 0
    Line.ZIndex = 15
    Line.Parent = Section

    return Section
end

-- Toggle (Переключатель)
local function CreateToggle(parent, text, default, callback, order)
    default = default or false
    callback = callback or function() end
    local toggled = default
    State.Toggles[text] = toggled

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle_" .. text
    ToggleFrame.BackgroundColor3 = Config.CardColor
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.ZIndex = 14
    ToggleFrame.LayoutOrder = order or 0
    ToggleFrame.Parent = parent
    CreateCorner(ToggleFrame, UDim.new(0, 8))

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.Text = text
    Label.TextSize = 13
    Label.Font = Config.FontRegular
    Label.TextColor3 = Config.TextColor
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 15
    Label.Parent = ToggleFrame

    -- Toggle background
    local ToggleBG = Instance.new("Frame")
    ToggleBG.Name = "ToggleBG"
    ToggleBG.BackgroundColor3 = toggled and Config.ToggleOn or Config.ToggleOff
    ToggleBG.Size = UDim2.new(0, 44, 0, 24)
    ToggleBG.Position = UDim2.new(1, -56, 0.5, -12)
    ToggleBG.ZIndex = 15
    ToggleBG.Parent = ToggleFrame
    CreateCorner(ToggleBG, UDim.new(1, 0))

    -- Toggle circle
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    ToggleCircle.ZIndex = 16
    ToggleCircle.Parent = ToggleBG
    CreateCorner(ToggleCircle, UDim.new(1, 0))

    -- Кнопка
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "Btn"
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 17
    ToggleBtn.Parent = ToggleFrame

    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = Config.CardHover}, 0.2)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = Config.CardColor}, 0.2)
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        State.Toggles[text] = toggled

        if toggled then
            Tween(ToggleBG, {BackgroundColor3 = Config.ToggleOn}, 0.2)
            Tween(ToggleCircle, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
        else
            Tween(ToggleBG, {BackgroundColor3 = Config.ToggleOff}, 0.2)
            Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
        end

        callback(toggled)
    end)

    return {
        Frame = ToggleFrame,
        SetValue = function(val)
            toggled = val
            State.Toggles[text] = val
            if toggled then
                Tween(ToggleBG, {BackgroundColor3 = Config.ToggleOn}, 0.2)
                Tween(ToggleCircle, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2)
            else
                Tween(ToggleBG, {BackgroundColor3 = Config.ToggleOff}, 0.2)
                Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2)
            end
            callback(val)
        end,
        GetValue = function() return toggled end
    }
end

-- Slider
local function CreateSlider(parent, text, min, max, default, callback, order)
    min = min or 0
    max = max or 100
    default = default or min
    callback = callback or function() end
    local value = default
    State.Sliders[text] = value

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider_" .. text
    SliderFrame.BackgroundColor3 = Config.CardColor
    SliderFrame.Size = UDim2.new(1, 0, 0, 55)
    SliderFrame.ZIndex = 14
    SliderFrame.LayoutOrder = order or 0
    SliderFrame.Parent = parent
    CreateCorner(SliderFrame, UDim.new(0, 8))

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -70, 0, 22)
    Label.Position = UDim2.new(0, 14, 0, 5)
    Label.Text = text
    Label.TextSize = 13
    Label.Font = Config.FontRegular
    Label.TextColor3 = Config.TextColor
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 15
    Label.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Size = UDim2.new(0, 60, 0, 22)
    ValueLabel.Position = UDim2.new(1, -70, 0, 5)
    ValueLabel.Text = tostring(math.floor(value))
    ValueLabel.TextSize = 13
    ValueLabel.Font = Config.Font
    ValueLabel.TextColor3 = Config.AccentColor
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ZIndex = 15
    ValueLabel.Parent = SliderFrame

    -- Slider bar background
    local SliderBG = Instance.new("Frame")
    SliderBG.Name = "SliderBG"
    SliderBG.BackgroundColor3 = Config.ToggleOff
    SliderBG.Size = UDim2.new(1, -28, 0, 8)
    SliderBG.Position = UDim2.new(0, 14, 0, 35)
    SliderBG.ZIndex = 15
    SliderBG.Parent = SliderFrame
    CreateCorner(SliderBG, UDim.new(1, 0))

    -- Slider fill
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.BackgroundColor3 = Config.SliderFill
    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    SliderFill.ZIndex = 16
    SliderFill.Parent = SliderBG
    CreateCorner(SliderFill, UDim.new(1, 0))

    -- Slider knob
    local SliderKnob = Instance.new("Frame")
    SliderKnob.Name = "Knob"
    SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    SliderKnob.Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8)
    SliderKnob.ZIndex = 17
    SliderKnob.Parent = SliderBG
    CreateCorner(SliderKnob, UDim.new(1, 0))
    CreateShadow(SliderKnob, 8)

    -- Input handling
    local sliding = false
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Size = UDim2.new(1, 0, 1, 10)
    sliderBtn.Position = UDim2.new(0, 0, 0, -5)
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 18
    sliderBtn.Parent = SliderBG

    local function UpdateSlider(inputPos)
        local relX = math.clamp((inputPos.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relX)
        State.Sliders[text] = value
        ValueLabel.Text = tostring(value)
        Tween(SliderFill, {Size = UDim2.new(relX, 0, 1, 0)}, 0.05, Enum.EasingStyle.Linear)
        Tween(SliderKnob, {Position = UDim2.new(relX, -8, 0.5, -8)}, 0.05, Enum.EasingStyle.Linear)
        callback(value)
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateSlider(input.Position)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input.Position)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)

    return {Frame = SliderFrame, GetValue = function() return value end}
end

-- Кнопка
local function CreateButton(parent, text, callback, order, color)
    callback = callback or function() end
    color = color or Config.AccentColor

    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = "Button_" .. text
    ButtonFrame.BackgroundColor3 = color
    ButtonFrame.BackgroundTransparency = 0.3
    ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
    ButtonFrame.Text = text
    ButtonFrame.TextSize = 13
    ButtonFrame.Font = Config.Font
    ButtonFrame.TextColor3 = Config.TextColor
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.ZIndex = 14
    ButtonFrame.LayoutOrder = order or 0
    ButtonFrame.ClipsDescendants = true
    ButtonFrame.Parent = parent
    CreateCorner(ButtonFrame, UDim.new(0, 8))

    ButtonFrame.MouseEnter:Connect(function()
        Tween(ButtonFrame, {BackgroundTransparency = 0.1}, 0.2)
    end)
    ButtonFrame.MouseLeave:Connect(function()
        Tween(ButtonFrame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    ButtonFrame.MouseButton1Click:Connect(function()
        RippleEffect(ButtonFrame, Mouse.X, Mouse.Y)
        Tween(ButtonFrame, {BackgroundTransparency = 0}, 0.1)
        task.delay(0.1, function()
            Tween(ButtonFrame, {BackgroundTransparency = 0.3}, 0.2)
        end)
        callback()
    end)

    return ButtonFrame
end

-- Выпадающий список (Dropdown / Collapsible)
local function CreateDropdown(parent, text, icon, order)
    local expanded = false
    local DropFrame = Instance.new("Frame")
    DropFrame.Name = "Dropdown_" .. text
    DropFrame.BackgroundColor3 = Config.CardColor
    DropFrame.Size = UDim2.new(1, 0, 0, 42)
    DropFrame.ZIndex = 14
    DropFrame.LayoutOrder = order or 0
    DropFrame.ClipsDescendants = true
    DropFrame.Parent = parent
    CreateCorner(DropFrame, UDim.new(0, 8))
    CreateStroke(DropFrame, Color3.fromRGB(50, 50, 70), 1)

    local Header = Instance.new("TextButton")
    Header.Name = "Header"
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 42)
    Header.Text = ""
    Header.ZIndex = 16
    Header.Parent = DropFrame

    local IconLabel = Instance.new("TextLabel")
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(0, 24, 0, 42)
    IconLabel.Position = UDim2.new(0, 12, 0, 0)
    IconLabel.Text = icon or "📂"
    IconLabel.TextSize = 16
    IconLabel.Font = Config.Font
    IconLabel.TextColor3 = Config.AccentColor
    IconLabel.ZIndex = 17
    IconLabel.Parent = DropFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -80, 0, 42)
    TitleLabel.Position = UDim2.new(0, 42, 0, 0)
    TitleLabel.Text = text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Config.Font
    TitleLabel.TextColor3 = Config.TextColor
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 17
    TitleLabel.Parent = DropFrame

    local Arrow = Instance.new("TextLabel")
    Arrow.Name = "Arrow"
    Arrow.BackgroundTransparency = 1
    Arrow.Size = UDim2.new(0, 24, 0, 42)
    Arrow.Position = UDim2.new(1, -36, 0, 0)
    Arrow.Text = "▼"
    Arrow.TextSize = 12
    Arrow.Font = Config.Font
    Arrow.TextColor3 = Config.TextDim
    Arrow.ZIndex = 17
    Arrow.Parent = DropFrame

    -- Контейнер для содержимого
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.new(1, -16, 0, 0)
    Content.Position = UDim2.new(0, 8, 0, 46)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.ZIndex = 15
    Content.Parent = DropFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 6)
    ContentLayout.Parent = Content

    Header.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            Tween(Arrow, {Rotation = 180}, 0.3)
            -- Подождём пока Auto-size определится
            task.wait(0.05)
            local targetHeight = 46 + Content.AbsoluteSize.Y + 12
            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.3, Enum.EasingStyle.Quint)
        else
            Tween(Arrow, {Rotation = 0}, 0.3)
            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.3, Enum.EasingStyle.Quint)
        end
    end)

    return Content, DropFrame, function()
        if expanded then
            task.wait(0.05)
            local targetHeight = 46 + Content.AbsoluteSize.Y + 12
            Tween(DropFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.3)
        end
    end
end

-- Разделитель
local function CreateSeparator(parent, order)
    local Sep = Instance.new("Frame")
    Sep.BackgroundTransparency = 1
    Sep.Size = UDim2.new(1, 0, 0, 8)
    Sep.LayoutOrder = order or 0
    Sep.ZIndex = 14
    Sep.Parent = parent

    local Line = Instance.new("Frame")
    Line.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Line.BackgroundTransparency = 0.5
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0.5, 0)
    Line.BorderSizePixel = 0
    Line.ZIndex = 15
    Line.Parent = Sep

    return Sep
end

-- Текстовое поле
local function CreateLabel(parent, text, order, color)
    local LabelFrame = Instance.new("Frame")
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Size = UDim2.new(1, 0, 0, 25)
    LabelFrame.ZIndex = 14
    LabelFrame.LayoutOrder = order or 0
    LabelFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Text = text
    Label.TextSize = 12
    Label.Font = Config.FontRegular
    Label.TextColor3 = color or Config.TextDim
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.ZIndex = 15
    Label.Parent = LabelFrame

    return Label
end

-- ═══════════════════════════════════════════
-- ЗАПОЛНЕНИЕ ТАБОВ
-- ═══════════════════════════════════════════

-- Создаём все кнопки табов
for _, tabData in ipairs(TabData) do
    local btn = CreateTabButton(tabData)
    btn.MouseButton1Click:Connect(function()
        SwitchTab(tabData.Name)
    end)
end

-- ═══════════════════════════════════════════
-- TAB: EXCALIBUR (Главная)
-- ═══════════════════════════════════════════
local ExcaliburScroll = CreateTabContent("Excalibur")

CreateSection(ExcaliburScroll, "Welcome to Excalibur Hub", 1)

CreateLabel(ExcaliburScroll, "⚔️  Excalibur Hub v2.0 — Universal Script Hub", 2, Config.AccentColor)
CreateLabel(ExcaliburScroll, "📱  Supports Mobile & PC | ImGui Style", 3)
CreateLabel(ExcaliburScroll, "👤  User: " .. LocalPlayer.Name, 4)
CreateLabel(ExcaliburScroll, "🎮  Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, 5)

CreateSeparator(ExcaliburScroll, 6)

-- Выпадающий блок "Excalibur" (кнопка вниз → раскрывает функции)
local excContent, excFrame, excRefresh = CreateDropdown(ExcaliburScroll, "Excalibur Features", "⚔️", 7)

CreateToggle(excContent, "Auto Farm", false, function(val)
    Notify("Excalibur", val and "Auto Farm включён" or "Auto Farm выключен", 3, val and "success" or "info")
end, 1)

CreateToggle(excContent, "Auto Collect", false, function(val)
    Notify("Excalibur", val and "Auto Collect включён" or "Auto Collect выключен", 3, val and "success" or "info")
end, 2)

CreateToggle(excContent, "Auto Quest", false, function(val)
    Notify("Excalibur", val and "Auto Quest включён" or "Auto Quest выключен", 3, val and "success" or "info")
end, 3)

CreateButton(excContent, "🔄 Respawn", function()
    local char = LocalPlayer.Character
    if char then
        char:BreakJoints()
        Notify("Excalibur", "Респавн выполнен", 3, "success")
    end
end, 4)

CreateButton(excContent, "🔃 Rejoin Server", function()
    Notify("Excalibur", "Перезайдём через 2 сек...", 2, "warning")
    task.delay(2, function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end, 5, Config.WarningColor)

task.defer(excRefresh)

CreateSeparator(ExcaliburScroll, 8)

CreateSection(ExcaliburScroll, "Quick Actions", 9)

CreateButton(ExcaliburScroll, "📋 Copy Server Link", function()
    if setclipboard then
        setclipboard("roblox://placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId)
        Notify("Excalibur", "Ссылка скопирована!", 3, "success")
    else
        Notify("Excalibur", "Функция не поддерживается", 3, "error")
    end
end, 10)

-- ═══════════════════════════════════════════
-- TAB: FROST ❄️
-- ═══════════════════════════════════════════
local FrostScroll = CreateTabContent("Frost")

CreateSection(FrostScroll, "❄️ Frost Effects", 1)

-- Frost выпадающий список
local frostContent, frostFrame, frostRefresh = CreateDropdown(FrostScroll, "Frost Powers", "❄️", 2)

local frostAuraConn = nil
CreateToggle(frostContent, "Frost Aura", false, function(val)
    if val then
        -- Эффект частиц (ауры)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local particles = Instance.new("ParticleEmitter")
            particles.Name = "FrostAura"
            particles.Color = ColorSequence.new(Config.FrostColor)
            particles.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 0)
            })
            particles.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(1, 1)
            })
            particles.Lifetime = NumberRange.new(1, 2)
            particles.Rate = 30
            particles.Speed = NumberRange.new(2, 5)
            particles.SpreadAngle = Vector2.new(360, 360)
            particles.Parent = char.HumanoidRootPart
        end
        Notify("Frost", "Frost Aura активирована ❄️", 3, "frost")
    else
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local p = char.HumanoidRootPart:FindFirstChild("FrostAura")
            if p then p:Destroy() end
        end
        Notify("Frost", "Frost Aura деактивирована", 3, "info")
    end
end, 1)

CreateToggle(frostContent, "Frost Trail", false, function(val)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if val then
        local trail = Instance.new("Trail")
        trail.Name = "FrostTrail"
        trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Config.FrostColor),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 230, 255))
        })
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        })
        trail.Lifetime = 1.5
        trail.MinLength = 0.1
        trail.FaceCamera = true

        local att0 = Instance.new("Attachment")
        att0.Name = "FrostAtt0"
        att0.Position = Vector3.new(0, 1, 0)
        att0.Parent = hrp

        local att1 = Instance.new("Attachment")
        att1.Name = "FrostAtt1"
        att1.Position = Vector3.new(0, -1, 0)
        att1.Parent = hrp

        trail.Attachment0 = att0
        trail.Attachment1 = att1
        trail.Parent = hrp

        Notify("Frost", "Frost Trail включён ❄️", 3, "frost")
    else
        for _, obj in pairs(hrp:GetChildren()) do
            if obj.Name:find("Frost") then obj:Destroy() end
        end
        Notify("Frost", "Frost Trail выключен", 3, "info")
    end
end, 2)

CreateToggle(frostContent, "Frost Theme", false, function(val)
    if val then
        -- Меняем атмосферу
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
        atmosphere.Name = "FrostAtmosphere"
        atmosphere.Density = 0.3
        atmosphere.Color = Color3.fromRGB(200, 220, 255)
        atmosphere.Decay = Color3.fromRGB(180, 200, 240)
        atmosphere.Glare = 0.1
        atmosphere.Haze = 2
        atmosphere.Parent = Lighting

        Lighting.Ambient = Color3.fromRGB(150, 180, 220)
        Lighting.FogColor = Color3.fromRGB(200, 220, 255)
        Lighting.FogEnd = 1000

        -- Меняем акцент UI
        Config.AccentColor = Config.FrostColor
        Config.AccentColor2 = Color3.fromRGB(150, 220, 255)
        Config.SliderFill = Config.FrostColor
        Config.ToggleOn = Config.FrostColor
        MainStroke.Color = Config.FrostColor

        Notify("Frost", "Frost Theme активирована! ❄️🌨️", 4, "frost")
    else
        local atm = Lighting:FindFirstChild("FrostAtmosphere")
        if atm then atm:Destroy() end
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.FogEnd = 100000

        Config.AccentColor = Color3.fromRGB(88, 101, 242)
        Config.AccentColor2 = Color3.fromRGB(130, 140, 255)
        Config.SliderFill = Color3.fromRGB(88, 101, 242)
        Config.ToggleOn = Color3.fromRGB(88, 101, 242)
        MainStroke.Color = Config.AccentColor

        Notify("Frost", "Frost Theme деактивирована", 3, "info")
    end
end, 3)

task.defer(frostRefresh)

CreateSeparator(FrostScroll, 3)

CreateSection(FrostScroll, "Frost Visual Settings", 4)

CreateSlider(FrostScroll, "Frost Intensity", 0, 100, 50, function(val)
    -- Интенсивность
end, 5)

CreateSlider(FrostScroll, "Snow Density", 0, 100, 30, function(val)
    -- Плотность снега
end, 6)

CreateButton(FrostScroll, "❄️ Freeze All NPCs (Client)", function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Parent ~= LocalPlayer.Character then
            v.WalkSpeed = 0
            v.JumpPower = 0
        end
    end
    Notify("Frost", "Все NPC заморожены! (Клиент)", 3, "frost")
end, 7, Config.FrostColor)

-- ═══════════════════════════════════════════
-- TAB: PLAYER
-- ═══════════════════════════════════════════
local PlayerScroll = CreateTabContent("Player")

CreateSection(PlayerScroll, "Movement", 1)

CreateSlider(PlayerScroll, "Walk Speed", 16, 500, 16, function(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = val
    end
end, 2)

CreateSlider(PlayerScroll, "Jump Power", 50, 500, 50, function(val)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = val
        char.Humanoid.UseJumpPower = true
    end
end, 3)

CreateSlider(PlayerScroll, "Gravity", 0, 500, 196, function(val)
    Workspace.Gravity = val
end, 4)

CreateSeparator(PlayerScroll, 5)

CreateSection(PlayerScroll, "Movement Features", 6)

local noclipEnabled = false
local noclipConn = nil
CreateToggle(PlayerScroll, "Noclip", false, function(val)
    noclipEnabled = val
    if val then
        noclipConn = RunService.Stepped:Connect(function()
            if noclipEnabled then
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
        Notify("Player", "Noclip включён", 3, "success")
    else
        if noclipConn then noclipConn:Disconnect() end
        Notify("Player", "Noclip выключен", 3, "info")
    end
end, 7)

local flyEnabled = false
local flyConn = nil
local flySpeed = 50
CreateToggle(PlayerScroll, "Fly", false, function(val)
    flyEnabled = val
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if val then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.D = 200
        bg.Parent = hrp

        flyConn = RunService.RenderStepped:Connect(function()
            if flyEnabled and hrp:FindFirstChild("FlyVelocity") then
                local dir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

                hrp.FlyVelocity.Velocity = dir * flySpeed
                hrp.FlyGyro.CFrame = Camera.CFrame
            end
        end)

        Notify("Player", "Fly включён! WASD + Space/Ctrl", 4, "success")
    else
        if flyConn then flyConn:Disconnect() end
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        Notify("Player", "Fly выключен", 3, "info")
    end
end, 8)

CreateSlider(PlayerScroll, "Fly Speed", 10, 300, 50, function(val)
    flySpeed = val
end, 9)

CreateToggle(PlayerScroll, "Infinite Jump", false, function(val)
    if val then
        State.Connections["InfJump"] = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        Notify("Player", "Infinite Jump включён", 3, "success")
    else
        if State.Connections["InfJump"] then
            State.Connections["InfJump"]:Disconnect()
        end
        Notify("Player", "Infinite Jump выключен", 3, "info")
    end
end, 10)

-- ═══════════════════════════════════════════
-- TAB: COMBAT
-- ═══════════════════════════════════════════
local CombatScroll = CreateTabContent("Combat")

CreateSection(CombatScroll, "Combat Features", 1)

CreateToggle(CombatScroll, "Kill Aura (Visual)", false, function(val)
    Notify("Combat", val and "Kill Aura включён" or "Kill Aura выключен", 3, val and "success" or "info")
end, 2)

CreateToggle(CombatScroll, "Auto Parry", false, function(val)
    Notify("Combat", val and "Auto Parry включён" or "Auto Parry выключен", 3, val and "success" or "info")
end, 3)

CreateToggle(CombatScroll, "Hit Particles", false, function(val)
    Notify("Combat", val and "Hit Particles включены" or "Hit Particles выключены", 3, val and "success" or "info")
end, 4)

CreateSlider(CombatScroll, "Attack Range", 5, 50, 10, function(val)
end, 5)

CreateSlider(CombatScroll, "Attack Speed", 1, 20, 1, function(val)
end, 6)

CreateSeparator(CombatScroll, 7)

CreateSection(CombatScroll, "Target", 8)

CreateButton(CombatScroll, "🎯 Target Nearest Player", function()
    local closest = nil
    local closestDist = math.huge
    local myPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position

    if not myPos then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
    end

    if closest then
        Notify("Combat", "Цель: " .. closest.Name .. " (" .. math.floor(closestDist) .. " studs)", 4, "warning")
    else
        Notify("Combat", "Игроки не найдены", 3, "error")
    end
end, 9)

-- ═══════════════════════════════════════════
-- TAB: VISUALS
-- ═══════════════════════════════════════════
local VisualsScroll = CreateTabContent("Visuals")

CreateSection(VisualsScroll, "ESP", 1)

local espEnabled = false
local espConn = nil

CreateToggle(VisualsScroll, "Player ESP", false, function(val)
    espEnabled = val
    if val then
        local function addESP(player)
            if player == LocalPlayer then return end
            local function onChar(char)
                if not espEnabled then return end
                local head = char:WaitForChild("Head", 5)
                if not head then return end

                -- Billboard
                local bill = Instance.new("BillboardGui")
                bill.Name = "ExcaliburESP"
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.StudsOffset = Vector3.new(0, 3, 0)
                bill.AlwaysOnTop = true
                bill.Parent = head

                local nameLabel = Instance.new("TextLabel")
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Config.AccentColor
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.TextSize = 14
                nameLabel.Font = Config.Font
                nameLabel.Parent = bill

                local distLabel = Instance.new("TextLabel")
                distLabel.BackgroundTransparency = 1
                distLabel.Size = UDim2.new(1, 0, 0.5, 0)
                distLabel.Position = UDim2.new(0, 0, 0.5, 0)
                distLabel.TextColor3 = Config.TextDim
                distLabel.TextStrokeTransparency = 0.5
                distLabel.TextSize = 11
                distLabel.Font = Config.FontRegular
                distLabel.Parent = bill

                -- Highlight
                local highlight = Instance.new("Highlight")
                highlight.Name = "ExcaliburHL"
                highlight.FillColor = Config.AccentColor
                highlight.FillTransparency = 0.7
                highlight.OutlineColor = Config.AccentColor
                highlight.OutlineTransparency = 0.3
                highlight.Parent = char

                -- Обновление расстояния
                task.spawn(function()
                    while espEnabled and bill and bill.Parent and char and char.Parent do
                        local myChar = LocalPlayer.Character
                        if myChar and myChar:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                            local dist = (char.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude
                            distLabel.Text = math.floor(dist) .. " studs"

                            local health = char:FindFirstChild("Humanoid") and char.Humanoid.Health or 0
                            local maxHealth = char:FindFirstChild("Humanoid") and char.Humanoid.MaxHealth or 100
                            nameLabel.Text = player.Name .. " [" .. math.floor(health) .. "/" .. math.floor(maxHealth) .. "]"
                        end
                        task.wait(0.2)
                    end
                end)
            end

            if player.Character then onChar(player.Character) end
            player.CharacterAdded:Connect(onChar)
        end

        for _, p in pairs(Players:GetPlayers()) do addESP(p) end
        Players.PlayerAdded:Connect(addESP)

        Notify("Visuals", "Player ESP включён 👁️", 3, "success")
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, obj in pairs(p.Character:GetDescendants()) do
                    if obj.Name == "ExcaliburESP" or obj.Name == "ExcaliburHL" then
                        obj:Destroy()
                    end
                end
            end
        end
        Notify("Visuals", "Player ESP выключен", 3, "info")
    end
end, 2)

CreateToggle(VisualsScroll, "Fullbright", false, function(val)
    if val then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Notify("Visuals", "Fullbright включён 💡", 3, "success")
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Notify("Visuals", "Fullbright выключен", 3, "info")
    end
end, 3)

CreateSeparator(VisualsScroll, 4)

CreateSection(VisualsScroll, "Camera", 5)

CreateSlider(VisualsScroll, "FOV", 30, 120, 70, function(val)
    Camera.FieldOfView = val
end, 6)

CreateToggle(VisualsScroll, "No Fog", false, function(val)
    if val then
        Lighting.FogEnd = 999999
        Notify("Visuals", "Fog удалён", 3, "success")
    else
        Lighting.FogEnd = 100000
        Notify("Visuals", "Fog восстановлен", 3, "info")
    end
end, 7)

-- ═══════════════════════════════════════════
-- TAB: WORLD
-- ═══════════════════════════════════════════
local WorldScroll = CreateTabContent("World")

CreateSection(WorldScroll, "World Settings", 1)

CreateSlider(WorldScroll, "Time of Day", 0, 24, 14, function(val)
    Lighting.ClockTime = val
end, 2)

CreateToggle(WorldScroll, "Anti-AFK", false, function(val)
    if val then
        local VirtualUser = game:GetService("VirtualUser")
        State.Connections["AntiAFK"] = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            Notify("World", "Anti-AFK сработал", 3, "warning")
        end)
        Notify("World", "Anti-AFK включён", 3, "success")
    else
        if State.Connections["AntiAFK"] then
            State.Connections["AntiAFK"]:Disconnect()
        end
        Notify("World", "Anti-AFK выключен", 3, "info")
    end
end, 3)

CreateSeparator(WorldScroll, 4)

CreateSection(WorldScroll, "Server Info", 5)

CreateLabel(WorldScroll, "🌐 Server ID: " .. game.JobId:sub(1, 20) .. "...", 6)
CreateLabel(WorldScroll, "👥 Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers, 7)
CreateLabel(WorldScroll, "📍 Place ID: " .. game.PlaceId, 8)

-- ═══════════════════════════════════════════
-- TAB: TELEPORT
-- ═══════════════════════════════════════════
local TeleportScroll = CreateTabContent("Teleport")

CreateSection(TeleportScroll, "Player Teleport", 1)

-- Создание списка игроков
local function RefreshPlayerList()
    for _, child in pairs(TeleportScroll:GetChildren()) do
        if child.Name:find("PlayerTP_") then
            child:Destroy()
        end
    end

    local order = 3
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateButton(TeleportScroll, "📍 " .. player.Name, function()
                local myChar = LocalPlayer.Character
                local theirChar = player.Character
                if myChar and theirChar and myChar:FindFirstChild("HumanoidRootPart") and theirChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = theirChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    Notify("Teleport", "Телепортация к " .. player.Name, 3, "success")
                end
            end, order).Name = "PlayerTP_" .. player.Name
            order = order + 1
        end
    end
end

CreateButton(TeleportScroll, "🔄 Refresh Player List", function()
    RefreshPlayerList()
    Notify("Teleport", "Список игроков обновлён", 2, "info")
end, 2)

RefreshPlayerList()

-- ═══════════════════════════════════════════
-- TAB: MISC
-- ═══════════════════════════════════════════
local MiscScroll = CreateTabContent("Misc")

CreateSection(MiscScroll, "Miscellaneous", 1)

CreateToggle(MiscScroll, "Click TP (Ctrl+Click)", false, function(val)
    if val then
        State.Connections["ClickTP"] = Mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
                    Notify("Misc", "Телепортация!", 2, "success")
                end
            end
        end)
        Notify("Misc", "Click TP включён (Ctrl+Click)", 3, "success")
    else
        if State.Connections["ClickTP"] then
            State.Connections["ClickTP"]:Disconnect()
        end
        Notify("Misc", "Click TP выключен", 3, "info")
    end
end, 2)

CreateToggle(MiscScroll, "No Fall Damage", false, function(val)
    if val then
        State.Connections["NoFall"] = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end)
        Notify("Misc", "No Fall Damage включён", 3, "success")
    else
        if State.Connections["NoFall"] then
            State.Connections["NoFall"]:Disconnect()
        end
        Notify("Misc", "No Fall Damage выключен", 3, "info")
    end
end, 3)

CreateButton(MiscScroll, "🗑️ Remove All Tools", function()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
    Notify("Misc", "Все инструменты удалены", 3, "success")
end, 4)

CreateSeparator(MiscScroll, 5)

CreateSection(MiscScroll, "Chat Spam", 6)

local spamEnabled = false
CreateToggle(MiscScroll, "Chat Spam", false, function(val)
    spamEnabled = val
    if val then
        task.spawn(function()
            while spamEnabled do
                pcall(function()
                    game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                        :FindFirstChild("SayMessageRequest"):FireServer("Excalibur Hub ⚔️❄️", "All")
                end)
                task.wait(3)
            end
        end)
        Notify("Misc", "Chat Spam включён", 3, "warning")
    else
        Notify("Misc", "Chat Spam выключен", 3, "info")
    end
end, 7)

-- ═══════════════════════════════════════════
-- TAB: SETTINGS
-- ═══════════════════════════════════════════
local SettingsScroll = CreateTabContent("Settings")

CreateSection(SettingsScroll, "UI Settings", 1)

CreateSlider(SettingsScroll, "UI Scale", 50, 150, 100, function(val)
    local scale = val / 100
    MainFrame.Size = UDim2.new(0, 580 * scale, 0, 420 * scale)
end, 2)

CreateSlider(SettingsScroll, "UI Opacity", 0, 100, 100, function(val)
    MainFrame.BackgroundTransparency = 1 - (val / 100)
end, 3)

CreateSeparator(SettingsScroll, 4)

CreateSection(SettingsScroll, "Keybinds", 5)

CreateLabel(SettingsScroll, "⌨️  Right Shift — Toggle Menu", 6)
CreateLabel(SettingsScroll, "📱  Tap ⚔️ Button — Toggle Menu (Mobile)", 7)

CreateSeparator(SettingsScroll, 8)

CreateSection(SettingsScroll, "Notifications Test", 9)

CreateButton(SettingsScroll, "ℹ️ Info Notification", function()
    Notify("Test", "Это информационное уведомление", 4, "info")
end, 10)

CreateButton(SettingsScroll, "✅ Success Notification", function()
    Notify("Test", "Это успешное уведомление", 4, "success")
end, 11, Config.SuccessColor)

CreateButton(SettingsScroll, "⚠️ Warning Notification", function()
    Notify("Test", "Это предупреждающее уведомление", 4, "warning")
end, 12, Config.WarningColor)

CreateButton(SettingsScroll, "❌ Error Notification", function()
    Notify("Test", "Это уведомление об ошибке", 4, "error")
end, 13, Config.DangerColor)

CreateButton(SettingsScroll, "❄️ Frost Notification", function()
    Notify("Frost", "Это Frost уведомление ❄️", 4, "frost")
end, 14, Config.FrostColor)

CreateSeparator(SettingsScroll, 15)

CreateSection(SettingsScroll, "Danger Zone", 16)

CreateButton(SettingsScroll, "🗑️ Destroy UI", function()
    Notify("Settings", "UI будет удалён через 3 секунды...", 3, "error")
    task.delay(3, function()
        -- Очищаем все соединения
        for _, conn in pairs(State.Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        if noclipConn then noclipConn:Disconnect() end
        if flyConn then flyConn:Disconnect() end
        if getgenv then getgenv().ExcaliburLoaded = false end
        ScreenGui:Destroy()
    end)
end, 17, Config.DangerColor)

-- ═══════════════════════════════════════════
-- ЛОГИКА ОТКРЫТИЯ/ЗАКРЫТИЯ МЕНЮ
-- ═══════════════════════════════════════════

-- Инициализация: устанавливаем первый таб
SwitchTab("Excalibur")

-- Анимация открытия/закрытия
local function ToggleMenu(open)
    if open then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.BackgroundTransparency = 1

        Tween(MainFrame, {
            Size = UDim2.new(0, 580, 0, 420),
            Position = UDim2.new(0.5, -290, 0.5, -210),
            BackgroundTransparency = 0
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        local tw = Tween(MainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        tw.Completed:Connect(function()
            MainFrame.Visible = false
        end)
    end
end

-- Следим за состоянием меню
local lastMenuState = false
RunService.RenderStepped:Connect(function()
    if State.MenuOpen ~= lastMenuState then
        lastMenuState = State.MenuOpen
        ToggleMenu(State.MenuOpen)
    end
end)

-- Клавиша открытия (ПК)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then
        State.MenuOpen = not State.MenuOpen
        if State.MenuOpen then
            Tween(ToggleButton, {Rotation = 90}, 0.3)
        else
            Tween(ToggleButton, {Rotation = 0}, 0.3)
        end
    end
end)

-- ═══════════════════════════════════════════
-- СТАРТОВЫЕ УВЕДОМЛЕНИЯ
-- ═══════════════════════════════════════════
task.delay(1, function()
    Notify("⚔️ Excalibur Hub", "Successfully loaded! v2.0", 5, "success")
end)

task.delay(2.5, function()
    Notify("❄️ Frost Module", "Frost features ready!", 4, "frost")
end)

task.delay(4, function()
    Notify("📱 Controls", "RightShift / ⚔️ Button to toggle", 5, "info")
end)

print([[
╔══════════════════════════════════════════╗
║         EXCALIBUR HUB v2.0 ⚔️❄️         ║
║        Successfully Loaded!              ║
║   Press RightShift to toggle menu        ║
╚══════════════════════════════════════════╝
]])
