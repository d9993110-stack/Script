-- ============================================
-- 💣 AUTO BOMB PASS CHEAT
-- Натисни T щоб включити/виключити
-- Автоматично передає бомбу найближчому гравцю
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Налаштування
local enabled = false
local TOGGLE_KEY = Enum.KeyCode.T
local CHECK_INTERVAL = 0.05 -- як часто перевіряти (секунди)

-- ============================================
-- GUI - Кнопка на екрані
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BombPassGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Знищити старий GUI якщо є
if LocalPlayer.PlayerGui:FindFirstChild("BombPassGUI") then
    LocalPlayer.PlayerGui:FindFirstChild("BombPassGUI"):Destroy()
end

ScreenGui.Parent = LocalPlayer.PlayerGui

-- Основний фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 80)
MainFrame.Position = UDim2.new(0, 10, 0.5, -40)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Закруглення
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Обводка
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Іконка бомби + Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "💣 BOMB PASS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Статус
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "❌ ВИМКНЕНО"
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 16
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.Parent = MainFrame

-- Підказка
local HintLabel = Instance.new("TextLabel")
HintLabel.Name = "Hint"
HintLabel.Size = UDim2.new(1, 0, 0, 20)
HintLabel.Position = UDim2.new(0, 0, 0, 55)
HintLabel.BackgroundTransparency = 1
HintLabel.Text = "[T] - Toggle"
HintLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
HintLabel.TextSize = 12
HintLabel.Font = Enum.Font.Gotham
HintLabel.Parent = MainFrame

-- Можна перетягувати GUI
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
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

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ============================================
-- Оновити GUI статус
-- ============================================
local function updateGUI()
    if enabled then
        StatusLabel.Text = "✅ УВІМКНЕНО"
        StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
        UIStroke.Color = Color3.fromRGB(80, 255, 80)
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
    else
        StatusLabel.Text = "❌ ВИМКНЕНО"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        UIStroke.Color = Color3.fromRGB(255, 50, 50)
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end

-- ============================================
-- Знайти найближчого гравця
-- ============================================
local function getClosestPlayer()
    local character = LocalPlayer.Character
    if not character then return nil end
    local myRoot = character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if root and humanoid and humanoid.Health > 0 then
                    local distance = (myRoot.Position - root.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer, closestDistance
end

-- ============================================
-- Перевірити чи є бомба в руках/інвентарі
-- ============================================
local function findBomb()
    local character = LocalPlayer.Character
    if not character then return nil end
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    -- Список можливих назв бомби (додай свої якщо потрібно)
    local bombNames = {
        "bomb", "бомба", "tnt", "explosive", "grenade",
        "граната", "dynamite", "динаміт", "bomba"
    }

    local function isBomb(item)
        if not item then return false end
        local name = string.lower(item.Name)

        -- Перевірка по назві
        for _, bombName in pairs(bombNames) do
            if string.find(name, bombName) then
                return true
            end
        end

        -- Перевірка по тегам/атрибутам
        if item:GetAttribute("IsBomb") or item:GetAttribute("Bomb") then
            return true
        end

        -- Перевірка чи має тег
        if game:GetService("CollectionService"):HasTag(item, "Bomb") then
            return true
        end

        -- Перевірка по класу та властивостям (іноді бомба - це просто Tool)
        if item:IsA("Tool") then
            local handle = item:FindFirstChild("Handle")
            if handle then
                -- Перевірити ефекти вогню/диму як ознака бомби
                if handle:FindFirstChildOfClass("Fire") or handle:FindFirstChildOfClass("Smoke") or handle:FindFirstChildOfClass("ParticleEmitter") then
                    -- Може бути бомба
                end
            end
        end

        return false
    end

    -- Перевірити що в руках (Character)
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") and isBomb(child) then
            return child
        end
    end

    -- Перевірити Backpack
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") and isBomb(child) then
                return child
            end
        end
    end

    -- Якщо нічого не знайдено по назві, перевірити ВСІ тули
    -- (деякі ігри мають нестандартні назви)
    -- Розкоментуй якщо потрібно передавати БУДЬ-ЯКИЙ інструмент:
    --[[
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
    if backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                return child
            end
        end
    end
    ]]

    return nil
end

-- ============================================
-- Передати бомбу гравцю
-- ============================================
local function passBombToPlayer(bomb, targetPlayer)
    if not bomb or not targetPlayer then return false end

    local targetChar = targetPlayer.Character
    if not targetChar then return false end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return false end

    local myChar = LocalPlayer.Character
    if not myChar then return false end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    local humanoid = myChar:FindFirstChildOfClass("Humanoid")
    if not myRoot or not humanoid then return false end

    -- Спочатку екіпувати бомбу якщо вона в Backpack
    if bomb.Parent == LocalPlayer:FindFirstChild("Backpack") then
        humanoid:EquipTool(bomb)
        task.wait(0.1)
    end

    -- === Метод 1: Телепортуватись до гравця і кинути ===
    local originalCFrame = myRoot.CFrame
    local targetPosition = targetRoot.Position + (targetRoot.CFrame.LookVector * -3) -- трохи позаду

    -- Телепорт до цілі
    myRoot.CFrame = CFrame.new(targetPosition) * CFrame.new(0, 0, 0)
    task.wait(0.05)

    -- Кинути/відпустити бомбу
    -- Спроба 1: Активувати тул (клік)
    if bomb:FindFirstChild("RemoteEvent") then
        for _, remote in pairs(bomb:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                pcall(function()
                    remote:FireServer()
                end)
            end
        end
    end

    -- Спроба 2: Через ClickDetector
    if bomb:FindFirstChild("Handle") then
        local handle = bomb:FindFirstChild("Handle")
        local clickDetector = handle:FindFirstChildOfClass("ClickDetector")
        if clickDetector then
            pcall(function()
                fireclickdetector(clickDetector)
            end)
        end
    end

    -- Спроба 3: Активувати тул
    pcall(function()
        bomb:Activate()
    end)

    task.wait(0.05)

    -- Спроба 4: Просто кинути тул (drop)
    pcall(function()
        humanoid:UnequipTools()
    end)

    task.wait(0.1)

    -- Повернутись назад
    if myRoot and originalCFrame then
        myRoot.CFrame = originalCFrame
    end

    -- === Метод 2: Через ProximityPrompt (деякі ігри) ===
    pcall(function()
        if targetChar then
            for _, desc in pairs(targetChar:GetDescendants()) do
                if desc:IsA("ProximityPrompt") then
                    fireproximityprompt(desc)
                end
            end
        end
    end)

    -- === Метод 3: Через RemoteEvent (специфічно для гри) ===
    -- Шукаємо remote events пов'язані з передачею бомби
    pcall(function()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        for _, remote in pairs(replicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = string.lower(remote.Name)
                if string.find(name, "pass") or string.find(name, "give") or
                   string.find(name, "throw") or string.find(name, "transfer") or
                   string.find(name, "bomb") then
                    pcall(function()
                        remote:FireServer(targetPlayer)
                        remote:FireServer(targetPlayer.Character)
                        remote:FireServer(targetPlayer.Name)
                        remote:FireServer(targetPlayer, bomb)
                    end)
                end
            end
        end
    end)

    return true
end

-- ============================================
-- Головний цикл
-- ============================================
local mainLoop = nil

local function startLoop()
    if mainLoop then return end

    mainLoop = RunService.Heartbeat:Connect(function()
        if not enabled then return end

        local bomb = findBomb()
        if bomb then
            local closestPlayer, distance = getClosestPlayer()
            if closestPlayer and distance then
                -- Показати кому передаємо
                HintLabel.Text = "🎯 → " .. closestPlayer.Name .. " (" .. math.floor(distance) .. "m)"

                -- Передати бомбу
                passBombToPlayer(bomb, closestPlayer)

                task.wait(0.2) -- Невелика затримка після передачі
            else
                HintLabel.Text = "⚠️ Немає гравців поруч"
            end
        else
            HintLabel.Text = "[T] - Toggle | Бомби немає"
        end
    end)
end

local function stopLoop()
    if mainLoop then
        mainLoop:Disconnect()
        mainLoop = nil
    end
    HintLabel.Text = "[T] - Toggle"
end

-- ============================================
-- Toggle по натисканню T
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == TOGGLE_KEY then
        enabled = not enabled
        updateGUI()

        if enabled then
            startLoop()

            -- Повідомлення
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "💣 Bomb Pass",
                Text = "✅ УВІМКНЕНО! Автопередача бомби активна.",
                Duration = 3
            })
        else
            stopLoop()

            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "💣 Bomb Pass",
                Text = "❌ ВИМКНЕНО",
                Duration = 2
            })
        end
    end
end)

-- ============================================
-- Додатковий моніторинг - стежити коли бомба
-- з'являється в інвентарі (ChildAdded)
-- ============================================
local function monitorInventory()
    -- Моніторинг Backpack
    local backpack = LocalPlayer:WaitForChild("Backpack")
    backpack.ChildAdded:Connect(function(child)
        if not enabled then return end
        if child:IsA("Tool") then
            task.wait(0.05) -- мінімальна затримка
            local bomb = findBomb()
            if bomb then
                local closestPlayer = getClosestPlayer()
                if closestPlayer then
                    passBombToPlayer(bomb, closestPlayer)
                end
            end
        end
    end)

    -- Моніторинг Character (коли бомба екіпується)
    local function watchCharacter(character)
        if not character then return end
        character.ChildAdded:Connect(function(child)
            if not enabled then return end
            if child:IsA("Tool") then
                task.wait(0.05)
                local bomb = findBomb()
                if bomb then
                    local closestPlayer = getClosestPlayer()
                    if closestPlayer then
                        passBombToPlayer(bomb, closestPlayer)
                    end
                end
            end
        end)
    end

    if LocalPlayer.Character then
        watchCharacter(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(watchCharacter)
end

monitorInventory()

-- Початковий стан GUI
updateGUI()

-- ============================================
-- Повідомлення про завантаження
-- ============================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "💣 Bomb Pass Loaded!",
        Text = "Натисни [T] щоб увімкнути/вимкнути",
        Duration = 5
    })
end)

print("============================================")
print("💣 BOMB PASS SCRIPT LOADED!")
print("Натисни [T] щоб увімкнути/вимкнути")
print("Автоматично передає бомбу найближчому гравцю")
print("============================================")
