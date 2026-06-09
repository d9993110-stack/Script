-- Music Player GUI Script (Адаптований під Delta Executor)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Захист: для читів краще використовувати CoreGui, щоб UI не видалявся після смерті
local parentGui
local success, err = pcall(function()
    parentGui = game:GetService("CoreGui")
end)
if not success then
    parentGui = player:WaitForChild("PlayerGui")
end

-- Створення GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMusicPlayer_BySasha"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

-- Маленька кнопка (можна перетягувати)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleBtn"
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
ToggleButton.Text = "🎵"
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- Головне вікно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0, 60, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Title.Text = "🎵 Music Player"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Поле для ID
local IDBox = Instance.new("TextBox")
IDBox.Name = "IDBox"
IDBox.Size = UDim2.new(0, 190, 0, 30)
IDBox.Position = UDim2.new(0, 15, 0, 45)
IDBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
IDBox.Text = ""
IDBox.PlaceholderText = "Введи Music ID..."
IDBox.TextColor3 = Color3.new(1, 1, 1)
IDBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
IDBox.TextSize = 12
IDBox.Font = Enum.Font.Gotham
IDBox.ClearTextOnFocus = false
IDBox.Parent = MainFrame

local IDCorner = Instance.new("UICorner")
IDCorner.CornerRadius = UDim.new(0, 8)
IDCorner.Parent = IDBox

-- Кнопка Play
local PlayBtn = Instance.new("TextButton")
PlayBtn.Name = "PlayBtn"
PlayBtn.Size = UDim2.new(0, 90, 0, 32)
PlayBtn.Position = UDim2.new(0, 15, 0, 85)
PlayBtn.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
PlayBtn.Text = "▶ Play"
PlayBtn.TextColor3 = Color3.new(1, 1, 1)
PlayBtn.TextSize = 13
PlayBtn.Font = Enum.Font.GothamBold
PlayBtn.Parent = MainFrame

local PlayCorner = Instance.new("UICorner")
PlayCorner.CornerRadius = UDim.new(0, 8)
PlayCorner.Parent = PlayBtn

-- Кнопка Stop
local StopBtn = Instance.new("TextButton")
StopBtn.Name = "StopBtn"
StopBtn.Size = UDim2.new(0, 90, 0, 32)
StopBtn.Position = UDim2.new(0, 115, 0, 85)
StopBtn.BackgroundColor3 = Color3.fromRGB(240, 71, 71)
StopBtn.Text = "⏹ Stop"
StopBtn.TextColor3 = Color3.new(1, 1, 1)
StopBtn.TextSize = 13
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Parent = MainFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 8)
StopCorner.Parent = StopBtn

-- Статус
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 20)
Status.Position = UDim2.new(0, 15, 0, 125)
Status.BackgroundTransparency = 1
Status.Text = "Готово до роботи"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

-- Sound об'єкт
local Sound = Instance.new("Sound")
Sound.Name = "MusicSound"
Sound.Volume = 2 -- Збільшив гучність, бо 0.5 на телефонах буває тихо через динаміки
Sound.Looped = true
Sound.Parent = SoundService

-- Перетягування кнопки (Виправлено для плавності на мобільних в Delta)
local dragging = false
local dragStart, startPos

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        
        -- Використовуємо плавну зміну позиції
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        ToggleButton.Position = newPos
        
        -- Розрахунок позиції вікна відносно кнопки
        MainFrame.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset + 50, newPos.Y.Scale, newPos.Y.Offset - 60)
    end
end)

-- Обнулення прапорця dragging при завершенні тачу/кліку
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Відкрити/Закрити меню
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Play музику (Очищення ID від зайвих пробілів чи букв)
PlayBtn.MouseButton1Click:Connect(function()
    local cleanId = IDBox.Text:gsub("%D", "") -- Залишає тільки цифри, якщо скопіювали лінк
    if cleanId ~= "" then
        Sound:Stop()
        Sound.SoundId = "rbxassetid://" .. cleanId
        Sound:Play()
        Status.Text = "🎶 Граю: " .. cleanId
        Status.TextColor3 = Color3.fromRGB(67, 181, 129)
    else
        Status.Text = "❌ Введи правильний ID!"
        Status.TextColor3 = Color3.fromRGB(240, 71, 71)
    end
end)

-- Stop музику
StopBtn.MouseButton1Click:Connect(function()
    Sound:Stop()
    Status.Text = "⏹ Зупинено"
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

print("🎵 Music Player завантажено успішно!")
