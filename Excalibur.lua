--[[
    ╔═══════════════════════════════════════╗
    ║         EXCALIBUR v2.0                ║
    ║    Mobile IMGUI-Style Menu            ║
    ║    Для Роблокс (Телефон/ПК)           ║
    ╚═══════════════════════════════════════╝
]]

-- === СЕРВИСЫ ===
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- === НАСТРОЙКИ ===
local Config = {
    -- Визуал
    MainColor = Color3.fromRGB(15, 15, 25),
    AccentColor = Color3.fromRGB(130, 80, 255),
    AccentColor2 = Color3.fromRGB(180, 100, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    DimText = Color3.fromRGB(180, 180, 200),
    ButtonColor = Color3.fromRGB(25, 25, 40),
    ButtonHover = Color3.fromRGB(35, 35, 55),
    ToggleOn = Color3.fromRGB(100, 255, 100),
    ToggleOff = Color3.fromRGB(255, 80, 80),
    DangerColor = Color3.fromRGB(255, 50, 50),
    SuccessColor = Color3.fromRGB(50, 255, 100),
    WarningColor = Color3.fromRGB(255, 200, 50),
    InfoColor = Color3.fromRGB(80, 150, 255),

    -- Функции (состояния)
    Speed = 16,
    JumpPower = 50,
    WalkSpeed = 16,
    Noclip = false,
    ESP = false,
    Fullbright = false,
    InfiniteJump = false,
    GodMode = false,
    Fly = false,
    FlySpeed = 50,
    NoFog = false,
    BigHead = false,
    AntiFling = false,
    Freecam = false,
    ClickTP = false,
    AntiAFK = false,
}

-- === УВЕДОМЛЕНИЯ ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExcaliburGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Пробуем защитить GUI
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    elseif gethui then
        ScreenGui.Parent = gethui()
        return
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Контейнер уведомлений
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "Notifications"
NotifContainer.Size = UDim2.new(0, 300, 1, 0)
NotifContainer.Position = UDim2.new(1, -310, 0, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 5)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Parent = NotifContainer

local NotifPadding = Instance.new("UIPadding")
NotifPadding.PaddingBottom = UDim.new(0, 10)
NotifPadding.PaddingRight = UDim.new(0, 5)
NotifPadding.Parent = NotifContainer

-- Функция уведомлений
local function Notify(title, text, notifType, duration)
    duration = duration or 4
    notifType = notifType or "info"

    local colors = {
        info = Config.InfoColor,
        success = Config.SuccessColor,
        warning = Config.WarningColor,
        error = Config.DangerColor,
    }

    local icons = {
        info = "ℹ️",
        success = "✅",
        warning = "⚠️",
        error = "❌",
    }

    local accentCol = colors[notifType] or Config.InfoColor
    local icon = icons[notifType] or "ℹ️"

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 70)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ClipsDescendants = true
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.Parent = NotifContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = accentCol
    NotifStroke.Thickness = 1.5
    NotifStroke.Transparency = 1
    NotifStroke.Parent = NotifFrame

    -- Accent line сбоку
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(0, 4, 1, 0)
    AccentLine.Position = UDim2.new(0, 0, 0, 0)
    AccentLine.BackgroundColor3 = accentCol
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = NotifFrame

    local AccentLineCorner = Instance.new("UICorner")
    AccentLineCorner.CornerRadius = UDim.new(0, 4)
    AccentLineCorner.Parent = AccentLine

    -- Иконка
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 12, 0, 8)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextSize = 20
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextColor3 = accentCol
    IconLabel.Parent = NotifFrame

    -- Заголовок
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -55, 0, 22)
    TitleLabel.Position = UDim2.new(0, 45, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Config.TextColor
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = NotifFrame

    -- Текст
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -55, 0, 30)
    TextLabel.Position = UDim2.new(0, 45, 0, 30)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextColor3 = Config.DimText
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.Parent = NotifFrame

    -- Прогресс бар
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.BackgroundColor3 = accentCol
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = NotifFrame

    -- Анимация появления
    TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.05
    }):Play()
    TweenService:Create(NotifStroke, TweenInfo.new(0.4), {Transparency = 0.5}):Play()

    -- Анимация прогресс бара
    TweenService:Create(ProgressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()

    -- Удаление
    task.delay(duration, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(NotifStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        task.wait(0.6)
        NotifFrame:Destroy()
    end)
end

-- ============================================================
-- === ГЛАВНОЕ МЕНЮ ===
-- ============================================================

local MenuOpen = false
local CurrentTab = "Player"

-- === КНОПКА EXCALIBUR (Открытие меню) ===
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ExcaliburToggle"
ToggleButton.Size = UDim2.new(0, 160, 0, 45)
ToggleButton.Position = UDim2.new(0.5, -80, 1, -55)
ToggleButton.BackgroundColor3 = Config.MainColor
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = ""
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = ScreenGui
ToggleButton.ZIndex = 100

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 12)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Config.AccentColor
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

-- Градиент для кнопки
local ToggleGradient = Instance.new("UIGradient")
ToggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Config.AccentColor),
    ColorSequenceKeypoint.new(1, Config.AccentColor2),
})
ToggleGradient.Rotation = 45
ToggleGradient.Parent = ToggleStroke

-- Текст Excalibur
local ExcaliburText = Instance.new("TextLabel")
ExcaliburText.Size = UDim2.new(1, 0, 0, 30)
ExcaliburText.Position = UDim2.new(0, 0, 0, 2)
ExcaliburText.BackgroundTransparency = 1
ExcaliburText.Text = "⚔ EXCALIBUR"
ExcaliburText.TextSize = 18
ExcaliburText.Font = Enum.Font.GothamBlack
ExcaliburText.TextColor3 = Config.AccentColor
ExcaliburText.Parent = ToggleButton
ExcaliburText.ZIndex = 101

-- Стрелка вверх
local ArrowText = Instance.new("TextLabel")
ArrowText.Size = UDim2.new(1, 0, 0, 15)
ArrowText.Position = UDim2.new(0, 0, 0, 28)
ArrowText.BackgroundTransparency = 1
ArrowText.Text = "▲ Нажми ▲"
ArrowText.TextSize = 10
ArrowText.Font = Enum.Font.Gotham
ArrowText.TextColor3 = Config.DimText
ArrowText.Parent = ToggleButton
ArrowText.ZIndex = 101

-- Анимация пульсации кнопки
task.spawn(function()
    while true do
        TweenService:Create(ToggleStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 3
        }):Play()
        task.wait(1.5)
        TweenService:Create(ToggleStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Thickness = 1.5
        }):Play()
        task.wait(1.5)
    end
end)

-- Анимация вращения градиента
task.spawn(function()
    while true do
        for i = 0, 360, 2 do
            ToggleGradient.Rotation = i
            task.wait(0.03)
        end
    end
end)

-- === ГЛАВНЫЙ ФРЕЙМ МЕНЮ ===
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenu"
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Config.MainColor
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainFrame.ZIndex = 50

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Config.AccentColor
MainStroke.Thickness = 2
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- Делаем меню перетаскиваемым
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

-- === ЗАГОЛОВОК ===
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Header.ZIndex = 51

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Скругление только сверху
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 15)
HeaderFix.Position = UDim2.new(0, 0, 1, -15)
HeaderFix.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header
HeaderFix.ZIndex = 51

-- Drag для Header
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Заголовок текст
local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -50, 1, 0)
HeaderTitle.Position = UDim2.new(0, 15, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "⚔ EXCALIBUR v2.0"
HeaderTitle.TextSize = 20
HeaderTitle.Font = Enum.Font.GothamBlack
HeaderTitle.TextColor3 = Config.AccentColor
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header
HeaderTitle.ZIndex = 52

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -42, 0, 7)
CloseBtn.BackgroundColor3 = Config.DangerColor
CloseBtn.Text = "✕"
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Config.TextColor
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
CloseBtn.ZIndex = 52

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- === ТАБЫ ===
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
TabBar.ZIndex = 51

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, -10, 1, 0)
TabScroll.Position = UDim2.new(0, 5, 0, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.ScrollBarThickness = 0
TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabScroll.Parent = TabBar
TabScroll.ZIndex = 52

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabScroll

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 5)
TabPadding.PaddingTop = UDim.new(0, 5)
TabPadding.Parent = TabScroll

-- === КОНТЕЙНЕР КОНТЕНТА ===
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 95)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Config.AccentColor
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.Parent = MainFrame
ContentFrame.ZIndex = 51

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.Parent = ContentFrame

-- ============================================================
-- === UI КОМПОНЕНТЫ (ImGui стиль) ===
-- ============================================================

local Tabs = {}
local TabButtons = {}
local TabContents = {}

-- Создание вкладки
local function CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 75, 0, 30)
    tabBtn.BackgroundColor3 = Config.ButtonColor
    tabBtn.Text = (icon or "") .. " " .. name
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextColor3 = Config.DimText
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabScroll
    tabBtn.ZIndex = 53

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn

    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 0, 0)
    tabContent.AutomaticSize = Enum.AutomaticSize.Y
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = ContentFrame
    tabContent.ZIndex = 52

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = tabContent

    TabButtons[name] = tabBtn
    TabContents[name] = tabContent

    tabBtn.MouseButton1Click:Connect(function()
        -- Переключение табов
        for n, btn in pairs(TabButtons) do
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Config.ButtonColor,
                TextColor3 = Config.DimText
            }):Play()
            if TabContents[n] then
                TabContents[n].Visible = false
            end
        end
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Config.AccentColor,
            TextColor3 = Config.TextColor
        }):Play()
        tabContent.Visible = true
        CurrentTab = name
    end)

    return tabContent
end

-- Разделитель / Заголовок секции
local function CreateSection(parent, text)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 30)
    section.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    section.BorderSizePixel = 0
    section.Parent = parent
    section.ZIndex = 53

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 6)
    sCorner.Parent = section

    local sLabel = Instance.new("TextLabel")
    sLabel.Size = UDim2.new(1, -10, 1, 0)
    sLabel.Position = UDim2.new(0, 10, 0, 0)
    sLabel.BackgroundTransparency = 1
    sLabel.Text = "━━ " .. text .. " ━━"
    sLabel.TextSize = 12
    sLabel.Font = Enum.Font.GothamBold
    sLabel.TextColor3 = Config.AccentColor
    sLabel.TextXAlignment = Enum.TextXAlignment.Left
    sLabel.Parent = section
    sLabel.ZIndex = 54

    return section
end

-- Toggle (переключатель)
local function CreateToggle(parent, text, default, callback)
    local toggled = default or false

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 38)
    toggleFrame.BackgroundColor3 = Config.ButtonColor
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    toggleFrame.ZIndex = 53

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 8)
    tCorner.Parent = toggleFrame

    local tLabel = Instance.new("TextLabel")
    tLabel.Size = UDim2.new(1, -65, 1, 0)
    tLabel.Position = UDim2.new(0, 12, 0, 0)
    tLabel.BackgroundTransparency = 1
    tLabel.Text = text
    tLabel.TextSize = 13
    tLabel.Font = Enum.Font.GothamSemibold
    tLabel.TextColor3 = Config.TextColor
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.Parent = toggleFrame
    tLabel.ZIndex = 54

    -- Toggle switch
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 45, 0, 22)
    switchBg.Position = UDim2.new(1, -55, 0.5, -11)
    switchBg.BackgroundColor3 = toggled and Config.ToggleOn or Config.ToggleOff
    switchBg.BorderSizePixel = 0
    switchBg.Parent = toggleFrame
    switchBg.ZIndex = 54

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg

    local switchCircle = Instance.new("Frame")
    switchCircle.Size = UDim2.new(0, 18, 0, 18)
    switchCircle.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchCircle.BorderSizePixel = 0
    switchCircle.Parent = switchBg
    switchCircle.ZIndex = 55

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = switchCircle

    -- Статус текст
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 30, 0, 12)
    statusLabel.Position = UDim2.new(1, -55, 0, 1)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = toggled and "ON" or "OFF"
    statusLabel.TextSize = 9
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextColor3 = toggled and Config.ToggleOn or Config.ToggleOff
    statusLabel.Parent = toggleFrame
    statusLabel.ZIndex = 54

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = toggleFrame
    btn.ZIndex = 56

    btn.MouseButton1Click:Connect(function()
        toggled = not toggled

        TweenService:Create(switchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            BackgroundColor3 = toggled and Config.ToggleOn or Config.ToggleOff
        }):Play()

        TweenService:Create(switchCircle, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()

        statusLabel.Text = toggled and "ON" or "OFF"
        statusLabel.TextColor3 = toggled and Config.ToggleOn or Config.ToggleOff

        if callback then
            callback(toggled)
        end
    end)

    return {
        Frame = toggleFrame,
        SetValue = function(val)
            toggled = val
            TweenService:Create(switchBg, TweenInfo.new(0.25), {
                BackgroundColor3 = toggled and Config.ToggleOn or Config.ToggleOff
            }):Play()
            TweenService:Create(switchCircle, TweenInfo.new(0.25), {
                Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            }):Play()
            statusLabel.Text = toggled and "ON" or "OFF"
            statusLabel.TextColor3 = toggled and Config.ToggleOn or Config.ToggleOff
        end
    }
end

-- Кнопка
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Config.ButtonColor
    btn.Text = text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Config.TextColor
    btn.AutoButtonColor = false
    btn.Parent = parent
    btn.ZIndex = 53

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 8)
    bCorner.Parent = btn

    -- Hover эффект
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.ButtonHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.ButtonColor}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        -- Эффект клика
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Config.AccentColor}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Config.ButtonColor}):Play()
        if callback then
            callback()
        end
    end)

    return btn
end

-- Слайдер
local function CreateSlider(parent, text, min, max, default, callback)
    local value = default or min

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 55)
    sliderFrame.BackgroundColor3 = Config.ButtonColor
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    sliderFrame.ZIndex = 53

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 8)
    sCorner.Parent = sliderFrame

    local sLabel = Instance.new("TextLabel")
    sLabel.Size = UDim2.new(1, -80, 0, 20)
    sLabel.Position = UDim2.new(0, 12, 0, 5)
    sLabel.BackgroundTransparency = 1
    sLabel.Text = text
    sLabel.TextSize = 12
    sLabel.Font = Enum.Font.GothamSemibold
    sLabel.TextColor3 = Config.TextColor
    sLabel.TextXAlignment = Enum.TextXAlignment.Left
    sLabel.Parent = sliderFrame
    sLabel.ZIndex = 54

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(math.floor(value))
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextColor3 = Config.AccentColor
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    valueLabel.ZIndex = 54

    -- Slider track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 8)
    track.Position = UDim2.new(0, 12, 0, 35)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    track.ZIndex = 54

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Config.AccentColor
    fill.BorderSizePixel = 0
    fill.Parent = track
    fill.ZIndex = 55

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    -- Knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8)
    knob.BackgroundColor3 = Config.TextColor
    knob.BorderSizePixel = 0
    knob.Parent = track
    knob.ZIndex = 56

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    -- Interaction
    local sliding = false

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 0, 25)
    sliderBtn.Position = UDim2.new(0, 0, 0, 28)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderFrame
    sliderBtn.ZIndex = 57

    local function updateSlider(inputPos)
        local trackAbsPos = track.AbsolutePosition.X
        local trackAbsSize = track.AbsoluteSize.X
        local relativeX = math.clamp((inputPos - trackAbsPos) / trackAbsSize, 0, 1)
        value = math.floor(min + (max - min) * relativeX)
        valueLabel.Text = tostring(value)
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        knob.Position = UDim2.new(relativeX, -8, 0.5, -8)
        if callback then
            callback(value)
        end
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
        Frame = sliderFrame,
        GetValue = function() return value end,
        SetValue = function(v)
            value = math.clamp(v, min, max)
            local rel = (value - min) / (max - min)
            valueLabel.Text = tostring(math.floor(value))
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -8, 0.5, -8)
        end
    }
end

-- Инфо-панель
local function CreateInfoPanel(parent, text)
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 30)
    infoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = parent
    infoFrame.ZIndex = 53

    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(0, 6)
    iCorner.Parent = infoFrame

    local iLabel = Instance.new("TextLabel")
    iLabel.Size = UDim2.new(1, -10, 1, 0)
    iLabel.Position = UDim2.new(0, 10, 0, 0)
    iLabel.BackgroundTransparency = 1
    iLabel.Text = text
    iLabel.TextSize = 11
    iLabel.Font = Enum.Font.Gotham
    iLabel.TextColor3 = Config.DimText
    iLabel.TextXAlignment = Enum.TextXAlignment.Left
    iLabel.Parent = infoFrame
    iLabel.ZIndex = 54

    return iLabel
end

-- ============================================================
-- === СОЗДАНИЕ ВКЛАДОК И ФУНКЦИЙ ===
-- ============================================================

-- === TAB: PLAYER ===
local PlayerTab = CreateTab("Player", "👤")

CreateSection(PlayerTab, "Скорость и прыжки")

CreateSlider(PlayerTab, "🏃 WalkSpeed", 16, 500, 16, function(val)
    Config.Speed = val
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = val
    end
end)

CreateSlider(PlayerTab, "🦘 JumpPower", 50, 500, 50, function(val)
    Config.JumpPower = val
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = val
        char.Humanoid.UseJumpPower = true
    end
end)

CreateSection(PlayerTab, "Способности")

CreateToggle(PlayerTab, "🔮 Noclip (Сквозь стены)", false, function(val)
    Config.Noclip = val
    Notify("Noclip", val and "Включен" or "Выключен", val and "success" or "info")
end)

CreateToggle(PlayerTab, "⬆️ Infinite Jump", false, function(val)
    Config.InfiniteJump = val
    Notify("Infinite Jump", val and "Включен" or "Выключен", val and "success" or "info")
end)

CreateToggle(PlayerTab, "🛡️ God Mode", false, function(val)
    Config.GodMode = val
    Notify("God Mode", val and "Включен — вы бессмертны!" or "Выключен", val and "success" or "info")
end)

CreateSection(PlayerTab, "Передвижение")

CreateToggle(PlayerTab, "🕊️ Fly (Полёт)", false, function(val)
    Config.Fly = val
    Notify("Fly", val and "Включен — используй прыжок" or "Выключен", val and "success" or "info")
end)

CreateSlider(PlayerTab, "✈️ Fly Speed", 10, 200, 50, function(val)
    Config.FlySpeed = val
end)

CreateToggle(PlayerTab, "🛡️ Anti-Fling", false, function(val)
    Config.AntiFling = val
    Notify("Anti-Fling", val and "Защита от флинга включена" or "Выключена", val and "success" or "info")
end)

CreateSection(PlayerTab, "Действия")

CreateButton(PlayerTab, "🔄 Respawn (Возрождение)", function()
    local char = LocalPlayer.Character
    if char then
        char:BreakJoints()
        Notify("Respawn", "Персонаж перезагружен", "info")
    end
end)

CreateButton(PlayerTab, "💀 Kill (Убить себя)", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
        Notify("Kill", "Вы себя убили", "warning")
    end
end)

-- === TAB: ВИЗУАЛ ===
local VisualTab = CreateTab("Visual", "👁️")

CreateSection(VisualTab, "Освещение")

CreateToggle(VisualTab, "☀️ Fullbright", false, function(val)
    Config.Fullbright = val
    if val then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
    Notify("Fullbright", val and "Мир стал ярче!" or "Обычное освещение", val and "success" or "info")
end)

CreateToggle(VisualTab, "🌫️ No Fog (Без тумана)", false, function(val)
    Config.NoFog = val
    if val then
        Lighting.FogEnd = 9999999
        Lighting.FogStart = 9999999
    else
        Lighting.FogEnd = 5000
        Lighting.FogStart = 0
    end
    Notify("No Fog", val and "Туман убран" or "Туман восстановлен", val and "success" or "info")
end)

CreateSection(VisualTab, "ESP")

CreateToggle(VisualTab, "📍 ESP (Видеть игроков)", false, function(val)
    Config.ESP = val
    Notify("ESP", val and "Включен — видны все игроки" or "Выключен", val and "success" or "info")
end)

CreateToggle(VisualTab, "🤯 Big Head (Большая голова)", false, function(val)
    Config.BigHead = val
    Notify("Big Head", val and "Головы увеличены" or "Нормальные головы", val and "success" or "info")
end)

CreateSection(VisualTab, "Время суток")

CreateSlider(VisualTab, "🕐 Время", 0, 24, 14, function(val)
    Lighting.ClockTime = val
end)

CreateButton(VisualTab, "🌅 День", function()
    Lighting.ClockTime = 14
    Notify("Время", "Установлен день", "info")
end)

CreateButton(VisualTab, "🌙 Ночь", function()
    Lighting.ClockTime = 0
    Notify("Время", "Установлена ночь", "info")
end)

-- === TAB: TELEPORT ===
local TeleportTab = CreateTab("TP", "🌀")

CreateSection(TeleportTab, "Телепортация")

CreateToggle(TeleportTab, "👆 Click TP (Нажми = ТП)", false, function(val)
    Config.ClickTP = val
    Notify("Click TP", val and "Нажмите в любое место для ТП" or "Выключен", val and "success" or "info")
end)

CreateButton(TeleportTab, "📍 ТП к случайному игроку", function()
    local players = Players:GetPlayers()
    local target = players[math.random(1, #players)]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            Notify("Teleport", "Телепортирован к " .. target.Name, "success")
        end
    end
end)

CreateButton(TeleportTab, "🔝 ТП вверх (+100)", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
        Notify("Teleport", "Телепортирован вверх на 100", "info")
    end
end)

CreateButton(TeleportTab, "📌 Сохранить позицию", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        Config.SavedPosition = char.HumanoidRootPart.CFrame
        Notify("Waypoint", "Позиция сохранена!", "success")
    end
end)

CreateButton(TeleportTab, "🔙 Вернуться к позиции", function()
    if Config.SavedPosition then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = Config.SavedPosition
            Notify("Waypoint", "Телепортирован к сохранённой позиции", "success")
        end
    else
        Notify("Waypoint", "Позиция не сохранена!", "error")
    end
end)

CreateSection(TeleportTab, "ТП к игрокам")

-- Динамическое создание кнопок ТП к игрокам
local function RefreshPlayerList()
    -- Удаляем старые кнопки ТП
    for _, child in pairs(TeleportTab:GetChildren()) do
        if child:GetAttribute("PlayerTPButton") then
            child:Destroy()
        end
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = CreateButton(TeleportTab, "➡️ " .. player.Name, function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        Notify("Teleport", "ТП к " .. player.Name, "success")
                    end
                else
                    Notify("Teleport", player.Name .. " не найден", "error")
                end
            end)
            btn:SetAttribute("PlayerTPButton", true)
        end
    end
end

CreateButton(TeleportTab, "🔄 Обновить список игроков", function()
    RefreshPlayerList()
    Notify("Список", "Список игроков обновлён", "info")
end)

-- === TAB: SERVER ===
local ServerTab = CreateTab("Server", "🌐")

CreateSection(ServerTab, "Информация")

local serverInfoFPS = CreateInfoPanel(ServerTab, "FPS: Загрузка...")
local serverInfoPing = CreateInfoPanel(ServerTab, "Ping: Загрузка...")
local serverInfoPlayers = CreateInfoPanel(ServerTab, "Игроки: Загрузка...")
local serverInfoServer = CreateInfoPanel(ServerTab, "Server ID: " .. tostring(game.JobId):sub(1, 8) .. "...")

CreateSection(ServerTab, "Anti-AFK")

CreateToggle(ServerTab, "🔒 Anti-AFK", false, function(val)
    Config.AntiAFK = val
    Notify("Anti-AFK", val and "Вас не кикнет за AFK" or "Выключен", val and "success" or "info")
end)

CreateSection(ServerTab, "Серверные действия")

CreateButton(ServerTab, "🔗 Rejoin (Перезайти)", function()
    Notify("Rejoin", "Переподключение...", "warning", 2)
    task.wait(1)
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end)

CreateButton(ServerTab, "🚪 Leave (Выйти)", function()
    Notify("Leave", "Выход из игры...", "warning", 2)
    task.wait(1)
    LocalPlayer:Kick("Excalibur — До встречи!")
end)

-- === TAB: SETTINGS ===
local SettingsTab = CreateTab("Settings", "⚙️")

CreateSection(SettingsTab, "Настройки GUI")

CreateButton(SettingsTab, "🗑️ Закрыть и удалить Excalibur", function()
    Notify("Excalibur", "GUI удаляется...", "warning", 2)
    task.wait(2)
    ScreenGui:Destroy()
end)

CreateSection(SettingsTab, "Информация")
CreateInfoPanel(SettingsTab, "⚔ Excalibur v2.0")
CreateInfoPanel(SettingsTab, "📱 Поддержка: ПК + Телефон")
CreateInfoPanel(SettingsTab, "🎮 Платформа: " .. tostring(UserInputService.TouchEnabled and "Mobile" or "PC"))
CreateInfoPanel(SettingsTab, "👤 Игрок: " .. LocalPlayer.Name)

CreateSection(SettingsTab, "Тесты")

CreateButton(SettingsTab, "✅ Тест уведомления (Success)", function()
    Notify("Тест", "Это успешное уведомление!", "success")
end)

CreateButton(SettingsTab, "⚠️ Тест уведомления (Warning)", function()
    Notify("Тест", "Это предупреждение!", "warning")
end)

CreateButton(SettingsTab, "❌ Тест уведомления (Error)", function()
    Notify("Тест", "Это ошибка!", "error")
end)

CreateButton(SettingsTab, "ℹ️ Тест уведомления (Info)", function()
    Notify("Тест", "Это информация!", "info")
end)

-- ============================================================
-- === ФУНКЦИОНАЛЬНОСТЬ ===
-- ============================================================

-- Noclip
RunService.Stepped:Connect(function()
    if Config.Noclip then
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

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- God Mode
RunService.Heartbeat:Connect(function()
    if Config.GodMode then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.MaxHealth = math.huge
            char.Humanoid.Health = math.huge
        end
    end
end)

-- ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ExcaliburESP"
ESPFolder.Parent = Camera

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end

    local function setupESP(char)
        if not char then return end
        local head = char:WaitForChild("Head", 5)
        if not head then return end

        -- Удаляем старый ESP
        for _, v in pairs(ESPFolder:GetChildren()) do
            if v.Name == player.Name then v:Destroy() end
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = player.Name
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = ESPFolder

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextColor3 = Config.AccentColor
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.Parent = billboard

        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0, 15)
        distLabel.Position = UDim2.new(0, 0, 0, 20)
        distLabel.BackgroundTransparency = 1
        distLabel.TextSize = 11
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextColor3 = Config.TextColor
        distLabel.TextStrokeTransparency = 0.5
        distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        distLabel.Parent = billboard

        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, 0, 0, 15)
        healthLabel.Position = UDim2.new(0, 0, 0, 35)
        healthLabel.BackgroundTransparency = 1
        healthLabel.TextSize = 11
        healthLabel.Font = Enum.Font.Gotham
        healthLabel.TextStrokeTransparency = 0.5
        healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        healthLabel.Parent = billboard

        -- Highlight
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. player.Name
        highlight.FillColor = Config.AccentColor
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = Config.AccentColor
        highlight.OutlineTransparency = 0.3
        highlight.Parent = char

        -- Обновление
        task.spawn(function()
            while billboard and billboard.Parent and char and char.Parent do
                if Config.ESP then
                    billboard.Enabled = true
                    highlight.Enabled = true

                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                        local dist = (myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                        distLabel.Text = string.format("📏 %.0f studs", dist)
                    end

                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        local hp = math.floor(hum.Health)
                        local maxHp = math.floor(hum.MaxHealth)
                        healthLabel.Text = string.format("❤️ %d/%d", hp, maxHp)
                        local ratio = hum.Health / hum.MaxHealth
                        healthLabel.TextColor3 = Color3.fromRGB(255 * (1 - ratio), 255 * ratio, 0)
                    end
                else
                    billboard.Enabled = false
                    highlight.Enabled = false
                end
                task.wait(0.2)
            end
        end)
    end

    if player.Character then
        setupESP(player.Character)
    end
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        setupESP(char)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    CreateESPForPlayer(player)
end
Players.PlayerAdded:Connect(CreateESPForPlayer)

-- Big Head
RunService.Heartbeat:Connect(function()
    if Config.BigHead then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    head.Size = Vector3.new(5, 5, 5)
                end
            end
        end
    end
end)

-- Anti-Fling
RunService.Heartbeat:Connect(function()
    if Config.AntiFling then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            hrp.Velocity = Vector3.new(
                math.clamp(hrp.Velocity.X, -50, 50),
                math.clamp(hrp.Velocity.Y, -50, 50),
                math.clamp(hrp.Velocity.Z, -50, 50)
            )
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Fly
local flyBP, flyBG
local function startFly()
    local char = LocalPlayer.Character
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
end

local function stopFly()
    if flyBP then flyBP:Destroy() flyBP = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

RunService.RenderStepped:Connect(function()
    if Config.Fly then
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        if not flyBP then startFly() end

        local hrp = char.HumanoidRootPart
        local dir = Vector3.new(0, 0, 0)
        local camCF = Camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        -- Поддержка мобильного (тачскрин движение)
        if UserInputService.TouchEnabled then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                dir = dir + humanoid.MoveDirection
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) or UserInputService.JumpRequest then
                dir = dir + Vector3.new(0, 1, 0)
            end
        end

        if dir.Magnitude > 0 then
            dir = dir.Unit * Config.FlySpeed
        end

        flyBP.Position = hrp.Position + dir
        flyBG.CFrame = camCF
    else
        if flyBP then stopFly() end
    end
end)

-- Click TP
local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if Config.ClickTP then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hit = Mouse.Hit
            char.HumanoidRootPart.CFrame = hit + Vector3.new(0, 3, 0)
        end
    end
end)

-- Anti-AFK
if Config.AntiAFK then
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if Config.AntiAFK then
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
    end)
end

-- WalkSpeed постоянное обновление
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum.WalkSpeed = Config.Speed
        hum.JumpPower = Config.JumpPower
        hum.UseJumpPower = true
    end
end)

-- Обновление информации сервера
task.spawn(function()
    while true do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            serverInfoFPS.Text = "📊 FPS: " .. tostring(fps)
            serverInfoPlayers.Text = "👥 Игроки: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers

            local stats = game:GetService("Stats")
            local ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            serverInfoPing.Text = "📡 Ping: " .. tostring(ping) .. "ms"
        end)
        task.wait(1)
    end
end)

-- ============================================================
-- === ОТКРЫТИЕ / ЗАКРЫТИЕ МЕНЮ ===
-- ============================================================

local function ToggleMenu()
    MenuOpen = not MenuOpen

    if MenuOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 380, 0, 0)
        MainFrame.BackgroundTransparency = 1

        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 380, 0, 520),
            BackgroundTransparency = 0
        }):Play()

        TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -80, 1, -15)
        }):Play()

        ArrowText.Text = "▼ Закрыть ▼"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 380, 0, 0),
            BackgroundTransparency = 1
        }):Play()

        TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -80, 1, -55)
        }):Play()

        ArrowText.Text = "▲ Нажми ▲"

        task.delay(0.4, function()
            if not MenuOpen then
                MainFrame.Visible = false
            end
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(ToggleMenu)

CloseBtn.MouseButton1Click:Connect(function()
    if MenuOpen then
        ToggleMenu()
    end
end)

-- Открытие по кнопке (ПК)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then
        ToggleMenu()
    end
end)

-- === АКТИВАЦИЯ ПЕРВОГО ТАБА ===
task.wait(0.1)
if TabButtons["Player"] then
    TabButtons["Player"].MouseButton1Click:Fire()
    -- Вручную активируем
    for n, btn in pairs(TabButtons) do
        if n == "Player" then
            btn.BackgroundColor3 = Config.AccentColor
            btn.TextColor3 = Config.TextColor
            if TabContents[n] then
                TabContents[n].Visible = true
            end
        end
    end
end

-- === СТАРТОВОЕ УВЕДОМЛЕНИЕ ===
task.wait(0.5)
Notify("⚔ EXCALIBUR", "Меню загружено! Нажми кнопку внизу", "success", 5)
task.wait(1)
Notify("📱 Управление", "ПК: RightShift / Insert для открытия", "info", 4)
task.wait(0.5)
Notify("🎮 Привет!", "Добро пожаловать, " .. LocalPlayer.Name .. "!", "info", 3)

print("[EXCALIBUR] ⚔ Меню успешно загружено!")
print("[EXCALIBUR] Версия: 2.0 | Mobile + PC")
