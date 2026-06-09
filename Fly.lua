-- Fly Toggle Script для мобильных устройств
-- Кнопка F на экране: нажал = Fly (скорость 1), нажал ещё раз = Walk (speed 50)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- === НАСТРОЙКИ ===
local FLY_SPEED = 1        -- скорость полёта
local WALK_SPEED = 50      -- скорость ходьбы после выключения
local BUTTON_SIZE = 50     -- размер кнопки в пикселях

-- === ПЕРЕМЕННЫЕ ===
local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil

-- === СОЗДАНИЕ КНОПКИ ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyToggleGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Name = "FlyButton"
Button.Size = UDim2.new(0, BUTTON_SIZE, 0, BUTTON_SIZE)
Button.Position = UDim2.new(0, 20, 0.5, -BUTTON_SIZE / 2) -- слева по центру экрана
Button.AnchorPoint = Vector2.new(0, 0)
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.BackgroundTransparency = 0.3
Button.Text = "F"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 22
Button.Font = Enum.Font.GothamBold
Button.Active = true
Button.Draggable = false  -- нельзя двигать
Button.Parent = ScreenGui

-- Скругление
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Button

-- Обводка
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 2
Stroke.Parent = Button

-- === ФУНКЦИЯ ВКЛЮЧЕНИЯ ПОЛЁТА ===
local function startFly()
    Character = Player.Character
    if not Character then return end
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not HumanoidRootPart then return end

    flying = true
    Humanoid.PlatformStand = true
    Humanoid.WalkSpeed = 0

    -- BodyVelocity для движения
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = HumanoidRootPart

    -- BodyGyro для стабилизации
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.D = 200
    bodyGyro.P = 10000
    bodyGyro.Parent = HumanoidRootPart

    -- Обновление полёта каждый кадр
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        if not Character or not Character.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        local moveDirection = Humanoid.MoveDirection

        -- Направление полёта = направление камеры + движение
        local camCF = camera.CFrame
        local forward = camCF.LookVector
        local right = camCF.RightVector
        local up = Vector3.new(0, 0, 0)

        -- Движение от джойстика/клавиш
        local direction = Vector3.new(0, 0, 0)

        if moveDirection.Magnitude > 0 then
            direction = (forward * moveDirection.Z * -1) + (right * moveDirection.X)
            -- На мобильном moveDirection уже правильный, пересчитаем через камеру
            direction = camCF.LookVector * -moveDirection.Z + camCF.RightVector * moveDirection.X
        end

        -- Простой мобильный полёт: летим куда смотрит камера при движении вперёд
        local finalVelocity = Vector3.new(0, 0, 0)
        if moveDirection.Magnitude > 0.1 then
            -- Берём направление движения гуманоида и добавляем вертикаль от камеры
            local flatMove = moveDirection.Unit
            local camLook = camCF.LookVector
            local verticalComponent = camLook.Y

            finalVelocity = (flatMove + Vector3.new(0, verticalComponent, 0)).Unit * FLY_SPEED * 50
        end

        bodyVelocity.Velocity = finalVelocity
        bodyGyro.CFrame = camCF
    end)

    -- Обновление кнопки
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Button.Text = "F✈"
end

-- === ФУНКЦИЯ ВЫКЛЮЧЕНИЯ ПОЛЁТА ===
local function stopFly()
    flying = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end

    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end

    Character = Player.Character
    if Character then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.WalkSpeed = WALK_SPEED
        end
    end

    -- Обновление кнопки
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = "F"
end

-- === НАЖАТИЕ НА КНОПКУ ===
Button.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

-- === ПЕРЕЗАГРУЗКА ПРИ РЕСПАВНЕ ===
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")

    if flying then
        stopFly()
    end
end)

-- === КЛАВИША F ДЛЯ ПК (бонус) ===
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFly()
        else
            startFly()
        end
    end
end)
