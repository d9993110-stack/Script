-- ====================================
-- 🤖 UNTITLED ROBOT BOXING SCRIPT
-- 💥 Версия для UPD 1.7
-- ====================================

-- UI Library (Orion)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

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
    SpeedBoost = false
}

-- ====================================
-- 🎨 СОЗДАНИЕ КРАСИВОГО МЕНЮ
-- ====================================

local Window = OrionLib:MakeWindow({
    Name = "🥊 Robot Boxing Hub | UPD 1.7",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "URBHub",
    IntroText = "Untitled Robot Boxing",
    IntroIcon = "rbxassetid://4483345998"
})

-- 🔥 Главная вкладка
local MainTab = Window:MakeTab({
    Name = "⚡ Главное",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSection({
    Name = "🥊 Боевые функции"
})

MainTab:AddToggle({
    Name = "♾️ Бесконечная выносливость",
    Default = false,
    Callback = function(Value)
        Settings.InfiniteStamina = Value
        OrionLib:MakeNotification({
            Name = "Выносливость",
            Content = Value and "✅ Включено!" or "❌ Выключено",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

MainTab:AddToggle({
    Name = "💥 Нокаут одним ударом",
    Default = false,
    Callback = function(Value)
        Settings.OneHitKO = Value
        OrionLib:MakeNotification({
            Name = "One Hit KO",
            Content = Value and "✅ Включено!" or "❌ Выключено",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

MainTab:AddSection({
    Name = "🛡️ Дополнительно"
})

MainTab:AddToggle({
    Name = "🛡️ Авто-парирование",
    Default = false,
    Callback = function(Value)
        Settings.AutoParry = Value
    end
})

MainTab:AddToggle({
    Name = "💨 Ускорение",
    Default = false,
    Callback = function(Value)
        Settings.SpeedBoost = Value
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value and 35 or 16
        end
    end
})

-- 🎮 Вкладка игрока
local PlayerTab = Window:MakeTab({
    Name = "👤 Игрок",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSlider({
    Name = "🏃 Скорость ходьбы",
    Min = 16,
    Max = 100,
    Default = 16,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:AddSlider({
    Name = "🦘 Сила прыжка",
    Min = 50,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 5,
    ValueName = "jump",
    Callback = function(Value)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = Value
        end
    end
})

PlayerTab:AddButton({
    Name = "🔄 Сбросить персонажа",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end
})

-- ⚙️ Вкладка настроек
local SettingsTab = Window:MakeTab({
    Name = "⚙️ Настройки",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddParagraph("ℹ️ Информация", "Скрипт для Untitled Robot Boxing UPD 1.7\nРазработано для лучшего игрового опыта")

SettingsTab:AddButton({
    Name = "🗑️ Уничтожить интерфейс",
    Callback = function()
        OrionLib:Destroy()
    end
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
                
                -- Поиск стамины во всех возможных местах
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
                
                -- Через атрибуты
                if char then
                    for _, attr in pairs(char:GetAttributes()) do
                        local name = tostring(attr):lower()
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
                
                -- Атрибуты урона
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
                -- Поиск ремотов для парирования
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

-- 💨 Поддержка ускорения при респавне
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Settings.SpeedBoost then
        local hum = char:WaitForChild("Humanoid")
        hum.WalkSpeed = 35
    end
end)

-- ====================================
-- 🚀 ИНИЦИАЛИЗАЦИЯ
-- ====================================

OrionLib:MakeNotification({
    Name = "🥊 Robot Boxing Hub",
    Content = "Скрипт успешно загружен! UPD 1.7",
    Image = "rbxassetid://4483345998",
    Time = 5
})

OrionLib:Init()

print("✅ Untitled Robot Boxing Script загружен!")
print("🎮 Игра: [💥🔺 UPD 1.7] untitled robot boxing")
print("👨‍💻 by cocoa and games")
