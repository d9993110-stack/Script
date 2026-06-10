-- ====================================
-- 🤖 UNTITLED ROBOT BOXING SCRIPT
-- 🎨 NICK'S MODDED KAVO UI
-- 💥 UPD 1.7
-- ====================================

-- Nick's Modded KAVO UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/NICKISBAD/Nick-s-Modded-KAVO-Lib/main/Nick'sModdedKavoLib.lua"))()

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
-- 🎨 СОЗДАНИЕ МЕНЮ
-- ====================================

local Window = Library.CreateLib("🥊 Robot Boxing Hub | UPD 1.7", "Midnight")

-- ⚡ ГЛАВНАЯ ВКЛАДКА
local MainTab = Window:NewTab("⚡ Главное")

local CombatSection = MainTab:NewSection("🥊 Боевые функции")

CombatSection:NewLabel("💡 Включи нужные функции ниже")

CombatSection:NewToggle("♾️ Бесконечная выносливость", "Стамина не заканчивается", function(state)
    Settings.InfiniteStamina = state
    print(state and "✅ Стамина ВКЛ" or "❌ Стамина ВЫКЛ")
end)

CombatSection:NewToggle("💥 Нокаут одним ударом", "Уничтожает врага за 1 удар", function(state)
    Settings.OneHitKO = state
    print(state and "✅ One Hit KO ВКЛ" or "❌ One Hit KO ВЫКЛ")
end)

CombatSection:NewToggle("🛡️ Авто-парирование", "Автоматическое парирование", function(state)
    Settings.AutoParry = state
end)

local ExtraSection = MainTab:NewSection("💨 Передвижение")

ExtraSection:NewToggle("💨 Ускорение (35 speed)", "Быстрая ходьба", function(state)
    Settings.SpeedBoost = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = state and 35 or 16
    end
end)

ExtraSection:NewToggle("🦘 Бесконечный прыжок", "Прыгай сколько хочешь", function(state)
    Settings.InfiniteJump = state
end)

-- 👤 ВКЛАДКА ИГРОКА
local PlayerTab = Window:NewTab("👤 Игрок")

local CharSection = PlayerTab:NewSection("⚙️ Настройки персонажа")

CharSection:NewSlider("🏃 Скорость", "Скорость ходьбы", 200, 16, function(s)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = s
    end
end)

CharSection:NewSlider("🦘 Сила прыжка", "Высота прыжка", 300, 50, function(s)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = s
    end
end)

CharSection:NewButton("🔄 Сбросить персонажа", "Респавн", function()
    LocalPlayer.Character:BreakJoints()
end)

CharSection:NewButton("🪂 Безопасное приземление", "Отменить скорость падения", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end)

-- 🎯 ВКЛАДКА ТЕЛЕПОРТА
local TPTab = Window:NewTab("🎯 Телепорт")

local TPSection = TPTab:NewSection("📍 Телепорт к игрокам")

local playerList = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerList, p.Name)
    end
end

TPSection:NewDropdown("🎯 Выбрать игрока", "Телепорт", playerList, function(currentOption)
    local target = Players:FindFirstChild(currentOption)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
end)

TPSection:NewButton("🔄 Обновить список игроков", "Обновить", function()
    playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerList, p.Name)
        end
    end
    print("✅ Список обновлен! Игроков: " .. #playerList)
end)

-- ⚙️ ВКЛАДКА НАСТРОЕК
local SettingsTab = Window:NewTab("⚙️ Настройки")

local InfoSection = SettingsTab:NewSection("ℹ️ Информация")

InfoSection:NewLabel("🎮 Игра: untitled robot boxing")
InfoSection:NewLabel("📦 Версия: UPD 1.7")
InfoSection:NewLabel("👨‍💻 by: cocoa and games")
InfoSection:NewLabel("🎨 UI: Nick's Modded Kavo")

local ControlSection = SettingsTab:NewSection("🎛️ Управление")

ControlSection:NewKeybind("🎹 Toggle меню", "RightShift", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

ControlSection:NewButton("🗑️ Закрыть UI", "Свернуть меню", function()
    Library:ToggleUI()
end)

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

-- ====================================
-- 🚀 ЗАПУСК
-- ====================================

print("====================================")
print("✅ Robot Boxing Hub загружен!")
print("🎮 untitled robot boxing UPD 1.7")
print("🎨 Nick's Modded Kavo UI")
print("🎹 RightShift - toggle меню")
print("====================================")
