-- United Robot Boxing GUI Script
-- Создаём ScreenGui

local player = game.Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui")

-- Удаляем старый GUI если есть
if playerGui:FindFirstChild("RobotBoxingHub") then
    playerGui:FindFirstChild("RobotBoxingHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobotBoxingHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- ═══════════════════════════════════════
-- МАЛЕНЬКАЯ КНОПКА (Открыть/Закрыть)
-- ═══════════════════════════════════════

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 15, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Text = "🤖"
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 0
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 100, 100)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

-- Анимация пульсации кнопки
spawn(function()
    while wait(1.5) do
        if ToggleButton and ToggleButton.Parent then
            local tweenService = game:GetService("TweenService")
            local glow = tweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(255, 100, 100)
            })
            glow:Play()
            wait(0.5)
            local dim = tweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {
                BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            })
            dim:Play()
        end
    end
end)

-- ═══════════════════════════════════════
-- ГЛАВНОЕ МЕНЮ
-- ═══════════════════════════════════════

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 50, 50)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Gradient фон
local GradientFrame = Instance.new("Frame")
GradientFrame.Size = UDim2.new(1, 0, 1, 0)
GradientFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
GradientFrame.BorderSizePixel = 0
GradientFrame.Parent = MainFrame

local GradCorner = Instance.new("UICorner")
GradCorner.CornerRadius = UDim.new(0, 12)
GradCorner.Parent = GradientFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 10, 10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 30))
}
Gradient.Rotation = 135
Gradient.Parent = GradientFrame

-- ═══════════════════════════════════════
-- ЗАГОЛОВОК
-- ═══════════════════════════════════════

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 55)
TitleBar.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Закрываем нижние углы заголовка
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 15)
TitleFix.Position = UDim2.new(0, 0, 1, -15)
TitleFix.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
TitleFix.BorderSizePixel = 0
TitleFix.ZIndex = 2
TitleFix.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 20, 20))
}
TitleGradient.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🤖 ROBOT BOXING HUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 3
TitleText.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 60, 0, 20)
VersionLabel.Position = UDim2.new(1, -70, 0.5, -10)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v1.0"
VersionLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
VersionLabel.TextSize = 12
VersionLabel.Font = Enum.Font.GothamMedium
VersionLabel.ZIndex = 3
VersionLabel.Parent = TitleBar

-- ═══════════════════════════════════════
-- КОНТЕНТ
-- ═══════════════════════════════════════

local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ContentFrame.ZIndex = 2
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentFrame

-- ═══════════════════════════════════════
-- ПЕРЕМЕННЫЕ СОСТОЯНИЯ
-- ═══════════════════════════════════════

local Settings = {
    DamageMultiplier = 1,
    InfiniteStamina = false,
    OneHitKO = false
}

-- ═══════════════════════════════════════
-- ФУНКЦИИ СОЗДАНИЯ ЭЛЕМЕНТОВ
-- ═══════════════════════════════════════

local TweenService = game:GetService("TweenService")

-- Разделитель-заголовок секции
local function CreateSection(parent, text, order)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundTransparency = 1
    Section.LayoutOrder = order
    Section.ZIndex = 2
    Section.Parent = parent

    local Line1 = Instance.new("Frame")
    Line1.Size = UDim2.new(0.15, 0, 0, 1)
    Line1.Position = UDim2.new(0, 0, 0.5, 0)
    Line1.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Line1.BorderSizePixel = 0
    Line1.ZIndex = 2
    Line1.Parent = Section

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(0.7, 0, 1, 0)
    SectionLabel.Position = UDim2.new(0.15, 0, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = text
    SectionLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
    SectionLabel.TextSize = 13
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.ZIndex = 2
    SectionLabel.Parent = Section

    local Line2 = Instance.new("Frame")
    Line2.Size = UDim2.new(0.15, 0, 0, 1)
    Line2.Position = UDim2.new(0.85, 0, 0.5, 0)
    Line2.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Line2.BorderSizePixel = 0
    Line2.ZIndex = 2
    Line2.Parent = Section

    return Section
end

-- Переключатель (Toggle)
local function CreateToggle(parent, text, icon, order, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.LayoutOrder = order
    ToggleFrame.ZIndex = 2
    ToggleFrame.Parent = parent

    local TogFrameCorner = Instance.new("UICorner")
    TogFrameCorner.CornerRadius = UDim.new(0, 8)
    TogFrameCorner.Parent = ToggleFrame

    local TogFrameStroke = Instance.new("UIStroke")
    TogFrameStroke.Color = Color3.fromRGB(50, 50, 70)
    TogFrameStroke.Thickness = 1
    TogFrameStroke.Parent = ToggleFrame

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 30)
    IconLabel.Position = UDim2.new(0, 10, 0.5, -15)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextSize = 20
    IconLabel.ZIndex = 3
    IconLabel.Parent = ToggleFrame

    local TogLabel = Instance.new("TextLabel")
    TogLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TogLabel.Position = UDim2.new(0, 45, 0, 0)
    TogLabel.BackgroundTransparency = 1
    TogLabel.Text = text
    TogLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TogLabel.TextSize = 14
    TogLabel.Font = Enum.Font.GothamSemibold
    TogLabel.TextXAlignment = Enum.TextXAlignment.Left
    TogLabel.ZIndex = 3
    TogLabel.Parent = ToggleFrame

    -- Toggle кнопка
    local ToggleBG = Instance.new("Frame")
    ToggleBG.Size = UDim2.new(0, 50, 0, 26)
    ToggleBG.Position = UDim2.new(1, -65, 0.5, -13)
    ToggleBG.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ToggleBG.BorderSizePixel = 0
    ToggleBG.ZIndex = 3
    ToggleBG.Parent = ToggleFrame

    local ToggleBGCorner = Instance.new("UICorner")
    ToggleBGCorner.CornerRadius = UDim.new(1, 0)
    ToggleBGCorner.Parent = ToggleBG

    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.ZIndex = 4
    ToggleCircle.Parent = ToggleBG

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle

    local toggled = false
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Text = ""
    ToggleButton.ZIndex = 5
    ToggleButton.Parent = ToggleFrame

    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled

        if toggled then
            TweenService:Create(ToggleBG, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Position = UDim2.new(1, -23, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(TogFrameStroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(255, 80, 80)
            }):Play()
        else
            TweenService:Create(ToggleBG, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            }):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            }):Play()
            TweenService:Create(TogFrameStroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(50, 50, 70)
            }):Play()
        end

        if callback then
            callback(toggled)
        end
    end)

    -- Hover эффект
    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        }):Play()
    end)
    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        }):Play()
    end)

    return ToggleFrame
end

-- Слайдер
local function CreateSlider(parent, text, icon, order, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 75)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.LayoutOrder = order
    SliderFrame.ZIndex = 2
    SliderFrame.Parent = parent

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.Color = Color3.fromRGB(50, 50, 70)
    SliderStroke.Thickness = 1
    SliderStroke.Parent = SliderFrame

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 30, 0, 20)
    IconLabel.Position = UDim2.new(0, 10, 0, 8)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextSize = 18
    IconLabel.ZIndex = 3
    IconLabel.Parent = SliderFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.5, 0, 0, 25)
    SliderLabel.Position = UDim2.new(0, 42, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.GothamSemibold
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.ZIndex = 3
    SliderLabel.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
    ValueLabel.Position = UDim2.new(1, -70, 0, 5)
    ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ValueLabel.Text = tostring(default) .. "x"
    ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.ZIndex = 3
    ValueLabel.Parent = SliderFrame

    local ValCorner = Instance.new("UICorner")
    ValCorner.CornerRadius = UDim.new(0, 6)
    ValCorner.Parent = ValueLabel

    -- Слайдер бар
    local SliderBG = Instance.new("Frame")
    SliderBG.Size = UDim2.new(1, -24, 0, 8)
    SliderBG.Position = UDim2.new(0, 12, 0, 45)
    SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    SliderBG.BorderSizePixel = 0
    SliderBG.ZIndex = 3
    SliderBG.Parent = SliderFrame

    local BGCorner = Instance.new("UICorner")
    BGCorner.CornerRadius = UDim.new(1, 0)
    BGCorner.Parent = SliderBG

    local SliderFill = Instance.new("Frame")
    local initPercent = (default - min) / (max - min)
    SliderFill.Size = UDim2.new(initPercent, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 4
    SliderFill.Parent = SliderBG

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill

    local FillGradient = Instance.new("UIGradient")
    FillGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 30, 30))
    }
    FillGradient.Parent = SliderFill

    -- Круглый указатель
    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 18, 0, 18)
    SliderKnob.Position = UDim2.new(initPercent, -9, 0.5, -9)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderKnob.BorderSizePixel = 0
    SliderKnob.ZIndex = 5
    SliderKnob.Parent = SliderBG

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = SliderKnob

    local KnobShadow = Instance.new("UIStroke")
    KnobShadow.Color = Color3.fromRGB(255, 50, 50)
    KnobShadow.Thickness = 2
    KnobShadow.Parent = SliderKnob

    -- Логика слайдера
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 0, 30)
    SliderButton.Position = UDim2.new(0, 0, 0, 35)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.ZIndex = 6
    SliderButton.Parent = SliderFrame

    local dragging = false
    local UIS = game:GetService("UserInputService")

    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local absPos = SliderBG.AbsolutePosition.X
            local absSize = SliderBG.AbsoluteSize.X
            local mouseX = input.Position.X
            local percent = math.clamp((mouseX - absPos) / absSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)

            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderKnob.Position = UDim2.new(percent, -9, 0.5, -9)
            ValueLabel.Text = tostring(value) .. "x"

            if callback then
                callback(value)
            end
        end
    end)

    return SliderFrame
end

-- Кнопка (Button)
local function CreateButton(parent, text, icon, order, callback)
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Size = UDim2.new(1, 0, 0, 45)
    BtnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    BtnFrame.BorderSizePixel = 0
    BtnFrame.LayoutOrder = order
    BtnFrame.ZIndex = 2
    BtnFrame.Parent = parent

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = BtnFrame

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(50, 50, 70)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = BtnFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = icon .. "  " .. text
    Btn.TextColor3 = Color3.fromRGB(255, 200, 200)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.ZIndex = 3
    Btn.Parent = BtnFrame

    Btn.MouseButton1Click:Connect(function()
        -- Эффект нажатия
        TweenService:Create(BtnFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
        wait(0.15)
        TweenService:Create(BtnFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        }):Play()

        if callback then
            callback()
        end
    end)

    Btn.MouseEnter:Connect(function()
        TweenService:Create(BtnFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 35, 40)
        }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(255, 80, 80)
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(BtnFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        }):Play()
        TweenService:Create(BtnStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(50, 50, 70)
        }):Play()
    end)

    return BtnFrame
end

-- Статус-бар
local function CreateStatus(parent, order)
    local StatusFrame = Instance.new("Frame")
    StatusFrame.Size = UDim2.new(1, 0, 0, 35)
    StatusFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
    StatusFrame.BorderSizePixel = 0
    StatusFrame.LayoutOrder = order
    StatusFrame.ZIndex = 2
    StatusFrame.Parent = parent

    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = StatusFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusText"
    StatusLabel.Size = UDim2.new(1, -10, 1, 0)
    StatusLabel.Position = UDim2.new(0, 5, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "✅ Скрипт активен | Ожидание..."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.ZIndex = 3
    StatusLabel.Parent = StatusFrame

    return StatusFrame, StatusLabel
end

-- ═══════════════════════════════════════
-- СОЗДАНИЕ ЭЛЕМЕНТОВ ИНТЕРФЕЙСА
-- ═══════════════════════════════════════

-- Секция: Урон
CreateSection(ContentFrame, "⚔️  УРОН", 1)

CreateSlider(ContentFrame, "Множитель урона", "💥", 2, 1, 100, 1, function(value)
    Settings.DamageMultiplier = value
    print("[RBH] Урон установлен: " .. value .. "x")
end)

-- Секция: Выносливость
CreateSection(ContentFrame, "⚡  ВЫНОСЛИВОСТЬ", 3)

CreateToggle(ContentFrame, "Бесконечная выносливость", "⚡", 4, function(state)
    Settings.InfiniteStamina = state
    print("[RBH] Бесконечная выносливость: " .. tostring(state))
end)

-- Секция: Нокаут
CreateSection(ContentFrame, "👊  НОКАУТ", 5)

CreateToggle(ContentFrame, "Нокаут одним ударом", "💀", 6, function(state)
    Settings.OneHitKO = state
    if state then
        Settings.DamageMultiplier = 9999
    end
    print("[RBH] One Hit KO: " .. tostring(state))
end)

-- Секция: Доп. функции
CreateSection(ContentFrame, "🛠️  ДОПОЛНИТЕЛЬНО", 7)

CreateButton(ContentFrame, "Полное HP", "❤️", 8, function()
    print("[RBH] Восстановление HP!")
    -- Попытка хила
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
        end
    end)
end)

CreateButton(ContentFrame, "Респавн", "🔄", 9, function()
    print("[RBH] Респавн!")
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)
end)

-- Статус бар
local _, StatusLabel = CreateStatus(ContentFrame, 10)

-- ═══════════════════════════════════════
-- АНИМАЦИЯ ОТКРЫТИЯ/ЗАКРЫТИЯ
-- ═══════════════════════════════════════

local menuOpen = false

ToggleButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen

    if menuOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 320, 0, 420),
            Position = UDim2.new(0.5, -160, 0.5, -210)
        }):Play()

        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(50, 180, 50),
            Rotation = 90
        }):Play()
    else
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            MainFrame.Visible = false
        end)

        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50),
            Rotation = 0
        }):Play()
    end
end)

-- ═══════════════════════════════════════
-- ПЕРЕТАСКИВАНИЕ ОКНА
-- ═══════════════════════════════════════

local draggingUI = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingUI = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingUI = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if draggingUI and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══════════════════════════════════════
-- ГЛАВНЫЙ ЦИКЛ (ПРИМЕНЕНИЕ НАСТРОЕК)
-- ═══════════════════════════════════════

spawn(function()
    while wait(0.1) do
        pcall(function()
            local char = player.Character
            if not char then return end

            -- Бесконечная выносливость
            if Settings.InfiniteStamina then
                -- Ищем значения стамины в персонаже
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local name = v.Name:lower()
                        if name:find("stamin") or name:find("energy") or name:find("endur") or name:find("fatigue") then
                            if name:find("fatigue") or name:find("tired") then
                                v.Value = 0
                            else
                                v.Value = 100
                            end
                        end
                    end
                end

                -- Проверяем PlayerGui на стамину
                for _, v in pairs(player:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local name = v.Name:lower()
                        if name:find("stamin") or name:find("energy") then
                            v.Value = v.Value < 0 and 100 or math.max(v.Value, 100)
                        end
                    end
                end
            end

            -- Множитель урона — через Remote Events
            if Settings.DamageMultiplier > 1 or Settings.OneHitKO then
                -- Хук через метатаблицу namecall (для эксплойтов с hookmetamethod)
                -- Это применяется один раз ниже
            end
        end)
    end
end)

-- ═══════════════════════════════════════
-- ХУК УРОНА (для эксплойтов поддерживающих hookmetamethod)
-- ═══════════════════════════════════════

pcall(function()
    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}

            if method == "FireServer" or method == "InvokeServer" then
                local remoteName = self.Name:lower()
                
                -- Перехват ремоутов связанных с уроном
                if remoteName:find("damage") or remoteName:find("hit") or remoteName:find("attack") or remoteName:find("punch") or remoteName:find("strike") then
                    if Settings.OneHitKO then
                        -- Подменяем урон на огромное значение
                        for i, v in pairs(args) do
                            if type(v) == "number" and v > 0 and v < 10000 then
                                args[i] = 999999
                            end
                        end
                        return oldNamecall(self, unpack(args))
                    elseif Settings.DamageMultiplier > 1 then
                        for i, v in pairs(args) do
                            if type(v) == "number" and v > 0 and v < 10000 then
                                args[i] = v * Settings.DamageMultiplier
                            end
                        end
                        return oldNamecall(self, unpack(args))
                    end
                end
            end

            return oldNamecall(self, ...)
        end)
        print("[RBH] ✅ Hook установлен!")
    end
end)

-- ═══════════════════════════════════════
-- ОБНОВЛЕНИЕ СТАТУСА
-- ═══════════════════════════════════════

spawn(function()
    while wait(1) do
        pcall(function()
            local status = "✅ Активен | "
            local features = {}

            if Settings.OneHitKO then
                table.insert(features, "💀 OHK")
            elseif Settings.DamageMultiplier > 1 then
                table.insert(features, "💥 DMG:" .. Settings.DamageMultiplier .. "x")
            end

            if Settings.InfiniteStamina then
                table.insert(features, "⚡ ∞ Стамина")
            end

            if #features > 0 then
                status = status .. table.concat(features, " | ")
            else
                status = status .. "Ожидание..."
            end

            if StatusLabel and StatusLabel.Parent then
                StatusLabel.Text = status
            end
        end)
    end
end)

-- Уведомление о запуске
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🤖 Robot Boxing Hub",
        Text = "Скрипт успешно загружен!",
        Duration = 3
    })
end)

print("══════════════════════════════")
print("  🤖 ROBOT BOXING HUB v1.0")
print("  ✅ Загружен успешно!")
print("  📌 Нажми кнопку 🤖 слева")
print("══════════════════════════════")
