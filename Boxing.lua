-- ====================================
-- 🤖 UNTITLED ROBOT BOXING SCRIPT
-- 🎨 RAYFIELD UI LIBRARY
-- 💥 UPD 1.7
-- ====================================

-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Настройки
local Settings = {
    InfiniteStamina = false,
    OneHitKO = false,
    AutoParry = false,
    SpeedBoost = false,
    InfiniteJump = false
}

-- ====================================
-- 🎨 СОЗДАНИЕ КРАСИВОГО МЕНЮ
-- ====================================

local Window = Rayfield:CreateWindow({
    Name = "🥊 Robot Boxing Hub | UPD 1.7",
    LoadingTitle = "Robot Boxing Script",
    LoadingSubtitle = "by cocoa and games",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RobotBoxingHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- ⚡ ГЛАВНАЯ ВКЛАДКА
local MainTab = Window:CreateTab("⚡ Главное", 4483345998)

local CombatSection = MainTab:CreateSection("🥊 Боевые функции")

MainTab:CreateToggle({
    Name = "♾️ Бесконечная выносливость",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(Value)
        Settings.InfiniteStamina = Value
        Rayfield:Notify({
            Title = "Выносливость",
            Content = Value and "✅ Включено!" or "❌ Выключено",
            Duration = 2,
            Image = 4483345998
        })
    end,
})

MainTab:CreateToggle({
    Name = "💥 Нокаут одним ударом",
    CurrentValue = false,
    Flag = "OneHitKO",
    Callback = function(Value)
        Settings.OneHitKO = Value
        Rayfield:Notify({
            Title = "One Hit KO",
            Content = Value and "✅ Включено!" or "❌ Выключено",
            Duration = 2,
            Image = 4483345998
        })
    end,
})

MainTab:CreateToggle({
    Name = "🛡️ Авто-парирование",
    CurrentValue = false,
    Flag = "AutoParry",
    Callback = function(Value)
        Settings.AutoParry = Value
    end,
})

local ExtraSection = MainTab:CreateSection("💨 Передвижение")

MainTab:CreateToggle({
    Name = "💨 Ускорение",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(Value)
        Settings.SpeedBoost = Value
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value and 35 or 16
        end
    end,
})

MainTab:CreateToggle({
    Name = "🦘 Бесконечный прыжок",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        Settings.InfiniteJump = Value
    end,
})

-- 👤 ВКЛАДКА ИГРОКА
local PlayerTab = Window:CreateTab("👤 Игрок", 4483345998)

local CharSection = PlayerTab:CreateSection("⚙️ Настройки персонажа")

PlayerTab:CreateSlider({
    Name = "🏃 Скорость ходьбы",
    Range = {16, 200},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "🦘 Сила прыжка",
    Range = {50, 300},
    Increment = 5,
    Suffix = "power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end,
})

PlayerTab:CreateButton({
    Name = "🔄 Сбросить персонажа",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end,
})

PlayerTab:CreateButton({
    Name = "🪂 Безопасное приземление",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end,
})

-- 🎯 ВКЛАДКА ТЕЛЕПОРТА
local TPTab = Window:CreateTab("🎯 Телепорт", 4483345998)

local TPSection = TPTab:CreateSection("📍 Телепорт к игрокам")

local function getPlayerList()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local PlayerDropdown = TPTab:CreateDropdown({
    Name = "🎯 Выбрать игрока",
    Options = getPlayerList(),
    CurrentOption = "",
    Flag = "PlayerSelect",
    Callback = function(Option)
        local target = Players:FindFirstChild(Option)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                Rayfield:Notify({
                    Title = "Телепорт",
                    Content = "✅ Перемещён к " .. Option,
                    Duration = 2,
                })
            end
        end
    end,
})

TPTab:CreateButton({
    Name = "🔄 Обновить список игроков",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerList())
        Rayfield:Notify({
            Title = "Обновлено",
            Content = "✅ Список игроков обновлён",
            Duration = 2,
        })
    end,
})

-- ⚙️ ВКЛАДКА НАСТРОЕК
local SettingsTab = Window:CreateTab("⚙️ Настройки", 4483345998)

local InfoSection = SettingsTab:CreateSection("ℹ️ Информация")

SettingsTab:CreateParagraph({
    Title = "🎮 О скрипте",
    Content = "Игра: untitled robot boxing\nВерсия: UPD 1.7\nРазработчик: cocoa and games\nUI: Rayfield Library"
})

local ControlSection = SettingsTab:CreateSection("🎛️ Управление")

SettingsTab:CreateKeybind({
    Name = "🎹 Открыть/Закрыть меню",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Flag = "MenuKey",
    Callback = function()
        -- Rayfield использует K по умолчанию
    end,
})

SettingsTab:CreateButton({
    Name = "🗑️ Уничтожить интерфейс",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- ====================================
-- 🔧 ОСНОВНЫЕ ФУНКЦИИ
-- ====================================

-- ♾️ Бесконечная выносливость
spawn(function()
    while task.wait(0.1) do
        if Settings.InfiniteStamina then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local locations = {
                    char, LocalPlayer,
                    LocalPlayer:FindFirstChild("PlayerGui"),
                    LocalPlayer:FindFirstChild("Data"),
                    LocalPlayer:FindFirstChild("Stats"),
                    LocalPlayer:FindFirstChild("leaderstats")
                }
                
                for _, location in pairs(locations) do
                    if location then
                        for _, v in pairs(location:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local name = v.Name:lower()
                                if name:find("stamina") or name:find("energy") or 
                                   name:find("endurance") or name:find("stam") then
                                    pcall(function() v.Value = 999999 end)
                                end
                            end
                        end
                    end
                end
                
                for attr, _ in pairs(char:GetAttributes()) do
                    local name = attr:lower()
                    if name:find("stamina") or name:find("energy") then
                        pcall(function() char:SetAttribute(attr, 999999) end)
                    end
                end
            end)
        end
    end
end)

-- 💥 Нокаут одним ударом
spawn(function()
    while task.wait(0.1) do
        if Settings.OneHitKO then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                local locations = {
                    char, LocalPlayer,
                    LocalPlayer:FindFirstChild("Data"),
                    LocalPlayer:FindFirstChild("Stats"),
                    LocalPlayer:FindFirstChild("PlayerData")
                }
                
                for _, location in pairs(locations) do
                    if location then
                        for _, v in pairs(location:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local name = v.Name:lower()
                                if name:find("damage") or name:find("power") or 
                                   name:find("strength") or name:find("attack") or
                                   name:find("punch") or name:find("hit") then
                                    pcall(function() v.Value = 999999 end)
                                end
                            end
                        end
                    end
                end
                
                for attr, _ in pairs(char:GetAttributes()) do
                    local name = attr:lower()
                    if name:find("damage") or name:find("power") or name:find("punch") then
                        pcall(function() char:SetAttribute(attr, 999999) end)
                    end
                end
            end)
        end
    end
end)

-- 🛡️ Авто-парирование
spawn(function()
    while task.wait(0.05) do
        if Settings.AutoParry then
            pcall(function()
                for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                        local name = v.Name:lower()
                        if name:find("parry") or name:find("block") or name:find("dodge") then
                            pcall(function() v:FireServer() end)
                        end
                    end
                end
            end)
        end
    end
end)

-- 🦘 Бесконечный прыжок
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 💨 Сохранение настроек при респавне
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Settings.SpeedBoost then
        local hum = char:WaitForChild("Humanoid")
        hum.WalkSpeed = 35
    end
end)

-- Автообновление списка игроков
Players.PlayerAdded:Connect(function()
    task.wait(1)
    pcall(function()
        PlayerDropdown:Refresh(getPlayerList())
    end)
end)

Players.PlayerRemoving:Connect(function()
    task.wait(1)
    pcall(function()
        PlayerDropdown:Refresh(getPlayerList())
    end)
end)

-- ====================================
-- 🚀 ЗАПУСК
-- ====================================

Rayfield:Notify({
    Title = "🥊 Robot Boxing Hub",
    Content = "Скрипт успешно загружен! Удачи в боях!",
    Duration = 5,
    Image = 4483345998,
})

Rayfield:LoadConfiguration()

print("====================================")
print("✅ Robot Boxing Hub загружен!")
print("🎮 untitled robot boxing UPD 1.7")
print("🎨 Rayfield UI Library")
print("🎹 K - открыть/закрыть меню")
print("====================================")
