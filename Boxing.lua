-- ====================================
-- 🤖 UNTITLED ROBOT BOXING SCRIPT
-- 🎨 KAVO UI LIBRARY
-- 💥 UPD 1.7
-- ====================================

-- Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Сервисы
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

local Window = Library.CreateLib("🥊 Robot Boxing Hub | UPD 1.7", "Ocean")

-- 🔥 Главная вкладка
local Main = Window:NewTab("⚡ Главное")
local MainSection = Main:NewSection("🥊 Боевые функции")

MainSection:NewToggle("♾️ Бесконечная выносливость", "Стамина не заканчивается", function(state)
    Settings.InfiniteStamina = state
    if state then
        print("✅ Бесконечная выносливость ВКЛ")
    else
        print("❌ Бесконечная выносливость ВЫКЛ")
    end
end)

MainSection:NewToggle("💥 Нокаут одним ударом", "Уничтожает врага за 1 удар", function(state)
    Settings.OneHitKO = state
    if state then
        print("✅ One Hit KO ВКЛ")
    else
        print("❌ One Hit KO ВЫКЛ")
    end
end)

local ExtraSection = Main:NewSection("🛡️ Дополнительно")

ExtraSection:NewToggle("🛡️ Авто-парирование", "Автоматическое парирование ударов", function(state)
    Settings.AutoParry = state
end)

ExtraSection:NewToggle("💨 Ускорение", "Быстрое передвижение", function(state)
    Settings.SpeedBoost = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = state and 35 or 16
    end
end)

ExtraSection:NewToggle("🦘 Бесконечный прыжок", "Прыгать сколько угодно", function(state)
    Settings.InfiniteJump = state
end)

-- 👤 Вкладка игрока
local Player = Window:NewTab("👤 Игрок")
local PlayerSection = Player:NewSection("⚙️ Настройки персонажа")

PlayerSection:NewSlider("🏃 Скорость ходьбы", "Скорость персонажа", 200, 16, function(s)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = s
    end
end)

PlayerSection:NewSlider("🦘 Сила прыжка", "Высота прыжка", 300, 50, function(s)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = s
    end
end)

PlayerSection:NewButton("🔄 Сбросить персонажа", "Респавн", function()
    LocalPlayer.Character:BreakJoints()
end)

PlayerSection:NewButton("🪂 Безопасное приземление", "Отменить урон от падения", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end)

-- 🎯 Вкладка телепортов
local Teleport = Window:NewTab("🎯 Телепорт")
local TPSection = Teleport:NewSection("📍 Игроки")

TPSection:NewButton("👥 Список игроков (в консоль)", "Показать всех игроков", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            print("👤 " .. p.Name)
        end
    end
end)

local PlayerDropdown
local playerList = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerList, p.Name)
    end
end

TPSection:NewDropdown("🎯 Выбрать игрока", "Телепорт к игроку", playerList, function(currentOption)
    local target = Players:FindFirstChild(currentOption)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
end)

TPSection:NewButton("🔄 Обновить список", "Обновить игроков", function()
    Window:Destroy()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    print("🔄 Перезагрузи скрипт для обновления")
end)

-- ⚙️ Вкладка настроек
local SettingsTab = Window:NewTab("⚙️ Настройки")
local InfoSection = SettingsTab:NewSection("ℹ️ Информация")

InfoSection:NewLabel("🎮 Игра: untitled robot boxing")
InfoSection:NewLabel("📦 Версия: UPD 1.7")
InfoSection:NewLabel("👨‍💻 Создатель: cocoa and games")
InfoSection:NewLabel("🎨 UI: Kavo Library")

local ControlSection = SettingsTab:NewSection("🎛️ Управление")

ControlSection:NewButton("🗑️ Закрыть меню", "Уничтожить интерфейс", function()
    Window:ToggleUI()
end)

ControlSection:NewKeybind("🎹 Открыть/Закрыть меню", "Горячая клавиша", Enum.KeyCode.RightShift, function()
    Window:ToggleUI()
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
                    char,
                    LocalPlayer,
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
                                    pcall(function()
                                        v.Value = 999999
                                    end)
                                end
                            end
                        end
                    end
                end
                
                if char then
                    for attr, _ in pairs(char:GetAttributes()) do
                        local name = attr:lower()
                        if name:find("stamina") or name:find("energy") then
                            pcall(function()
                                char:SetAttribute(attr, 999999)
                            end)
                        end
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
                    char,
                    LocalPlayer,
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
                                    pcall(function()
                                        v.Value = 999999
                                    end)
                                end
                            end
                        end
                    end
                end
                
                if char then
                    for attr, _ in pairs(char:GetAttributes()) do
                        local name = attr:lower()
                        if name:find("damage") or name:find("power") or name:find("punch") then
                            pcall(function()
                                char:SetAttribute(attr, 999999)
                            end)
                        end
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
                            pcall(function()
                                v:FireServer()
                            end)
                        end
                    end
                end
            end)
        end
    end
end)

-- 🦘 Бесконечный прыжок
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 💨 Поддержка ускорения при респавне
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
print("🎮 Игра: untitled robot boxing UPD 1.7")
print("🎨 UI: Kavo Library")
print("🎹 RightShift - открыть/закрыть меню")
print("====================================")
