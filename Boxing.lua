--[[
    ╔══════════════════════════════════════════╗
    ║           E P L I S M A                  ║
    ║       Professional Cheat Suite           ║
    ║                                          ║
    ║   Developer: Frost                       ║
    ║   Telegram: @Jokerfros                   ║
    ║   Version: 3.0 (Orion UI)                ║
    ╚══════════════════════════════════════════╝
]]

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

--// Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

--// Character
local Character, Humanoid, HRP

local function RefreshCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end

RefreshCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
LocalPlayer.CharacterAdded:Connect(RefreshCharacter)

--// ═══════════════════════════════════════════
--//  МОВИ
--// ═══════════════════════════════════════════

local Lang = "EN"

local L = {
    EN = {
        character = "Character", combat = "Combat", teleport = "Teleport",
        esp = "ESP", environment = "Environment", utilities = "Utilities",
        settings = "Settings",
        walkspeed = "WalkSpeed", walkspeedDesc = "Movement speed",
        jumppower = "JumpPower", jumppowerDesc = "Jump height",
        gravity = "Gravity", gravityDesc = "World gravity (196.2 default)",
        infJump = "Infinite Jump", infJumpDesc = "Jump mid-air",
        autoJump = "Auto Jump", autoJumpDesc = "Jump automatically",
        bunnyHop = "Bunny Hop", bunnyHopDesc = "Jump on landing",
        noclip = "Noclip", noclipDesc = "Walk through walls",
        fly = "Fly", flyDesc = "Free flight mode",
        flySpeed = "Fly Speed", flySpeedDesc = "Flight velocity",
        fov = "Field of View", fovDesc = "Camera FOV",
        godMode = "God Mode", godModeDesc = "Max health always",
        noReset = "No Reset", noResetDesc = "Disable reset button",
        forceReset = "Force Reset", respawn = "Respawn",
        freeze = "Freeze Character", frozen = "Frozen", unfrozen = "Unfrozen",
        aimbot = "Aimbot", aimbotDesc = "Lock-on aim (hold RMB)",
        fovRadius = "FOV Radius", smoothing = "Smoothing",
        showFov = "Show FOV Circle", hitbox = "Hitbox Expander",
        hitboxScale = "Hitbox Scale", killAura = "Kill Aura",
        auraRange = "Aura Range", nearestPlayer = "Show Nearest Player",
        noPlayersNear = "No players nearby",
        targetName = "Target Name", tpToTarget = "Teleport to Target",
        randomPlayer = "Random Player", tpSpawn = "TP to Spawn",
        tpForward = "TP Forward 100", savePos = "Save Position",
        loadPos = "Load Position", clickTp = "Click Teleport",
        saved = "Saved", loaded = "Loaded", posStored = "Position stored",
        posRestored = "Position restored", nothingSaved = "Nothing saved",
        notFound = "Player not found", noPlayers = "No players",
        movedTo = "Moved to",
        enableEsp = "Enable ESP", boundBox = "Bounding Box",
        nameTags = "Name Tags", healthBars = "Health Bars",
        distTags = "Distance Tags", tracers = "Tracers",
        chams = "Chams", teamFilter = "Team Filter",
        fullbright = "Fullbright", noFog = "No Fog",
        timeLock = "Time Lock", clockTime = "Clock Time",
        removeEffects = "Remove All Effects", removeParticles = "Remove Particles",
        removeDecals = "Remove Decals", removeSounds = "Remove Sounds",
        effectsRemoved = "effects removed", particlesRemoved = "particles removed",
        antiAfk = "Anti-AFK", antiKick = "Anti-Kick",
        spin = "Character Spin", spinSpeed = "Spin Speed",
        spawnPlatform = "Spawn Platform", forceSit = "Force Sit",
        forceJump = "Force Jump", copyPos = "Copy Position",
        copyLink = "Copy Game Link", spamMsg = "Spam Message",
        spamInterval = "Spam Interval", chatSpam = "Chat Spam",
        rejoin = "Rejoin", serverHop = "Server Hop", serverInfo = "Server Info",
        copied = "Copied",
        autoBomb = "Auto Bomb Pass", autoBombDesc = "Auto-pass bomb to nearest",
        bombKeywords = "Bomb Keywords",
        removeBlur = "Remove Blur", blurEnabled = "Blur Protection",
        removeAllPost = "Remove ALL Post Effects",
        lowGraphics = "Low Graphics Mode",
        copyId = "Copy Player ID", destroy = "Destroy Eplisma",
        welcome = "Welcome", pressE = "RightControl to toggle menu",
    },
    RU = {
        character = "Персонаж", combat = "Бой", teleport = "Телепорт",
        esp = "ESP", environment = "Окружение", utilities = "Утилиты",
        settings = "Настройки",
        walkspeed = "Скорость", walkspeedDesc = "Скорость передвижения",
        jumppower = "Прыжок", jumppowerDesc = "Высота прыжка",
        gravity = "Гравитация", gravityDesc = "Гравитация мира (196.2)",
        infJump = "Бесконечный прыжок", infJumpDesc = "Прыжок в воздухе",
        autoJump = "Авто-прыжок", autoJumpDesc = "Прыгать автоматически",
        bunnyHop = "Банни-хоп", bunnyHopDesc = "Прыжок при приземлении",
        noclip = "Ноклип", noclipDesc = "Проходить сквозь стены",
        fly = "Полёт", flyDesc = "Свободный полёт",
        flySpeed = "Скорость полёта", flySpeedDesc = "Скорость в полёте",
        fov = "Угол обзора", fovDesc = "FOV камеры",
        godMode = "Бессмертие", godModeDesc = "Максимальное здоровье",
        noReset = "Без ресета", noResetDesc = "Отключить ресет",
        forceReset = "Убить себя", respawn = "Респавн",
        freeze = "Заморозить", frozen = "Заморожен", unfrozen = "Разморожен",
        aimbot = "Аимбот", aimbotDesc = "Автоприцел (ПКМ)",
        fovRadius = "Радиус FOV", smoothing = "Плавность",
        showFov = "Показать FOV", hitbox = "Расширение хитбокса",
        hitboxScale = "Размер хитбокса", killAura = "Аура убийства",
        auraRange = "Радиус ауры", nearestPlayer = "Ближайший игрок",
        noPlayersNear = "Нет игроков рядом",
        targetName = "Имя цели", tpToTarget = "ТП к цели",
        randomPlayer = "Случайный игрок", tpSpawn = "ТП на спавн",
        tpForward = "ТП вперёд 100", savePos = "Сохранить позицию",
        loadPos = "Загрузить позицию", clickTp = "ТП по клику",
        saved = "Сохранено", loaded = "Загружено", posStored = "Позиция сохранена",
        posRestored = "Позиция восстановлена", nothingSaved = "Ничего не сохранено",
        notFound = "Игрок не найден", noPlayers = "Нет игроков",
        movedTo = "Перемещён к",
        enableEsp = "Включить ESP", boundBox = "Рамки",
        nameTags = "Имена", healthBars = "Полоски HP",
        distTags = "Дистанция", tracers = "Линии",
        chams = "Хамс", teamFilter = "Фильтр команды",
        fullbright = "Яркий свет", noFog = "Без тумана",
        timeLock = "Блокировка времени", clockTime = "Время суток",
        removeEffects = "Убрать все эффекты", removeParticles = "Убрать частицы",
        removeDecals = "Убрать декали", removeSounds = "Убрать звуки",
        effectsRemoved = "эффектов удалено", particlesRemoved = "частиц удалено",
        antiAfk = "Анти-АФК", antiKick = "Анти-Кик",
        spin = "Вращение", spinSpeed = "Скорость вращения",
        spawnPlatform = "Создать платформу", forceSit = "Сесть",
        forceJump = "Прыгнуть", copyPos = "Копировать позицию",
        copyLink = "Копировать ссылку", spamMsg = "Сообщение спама",
        spamInterval = "Интервал", chatSpam = "Спам в чат",
        rejoin = "Реджойн", serverHop = "Сменить сервер", serverInfo = "Инфо сервера",
        copied = "Скопировано",
        autoBomb = "Авто-передача бомбы", autoBombDesc = "Передать бомбу ближайшему",
        bombKeywords = "Ключевые слова бомбы",
        removeBlur = "Убрать блюр", blurEnabled = "Защита от блюра",
        removeAllPost = "Убрать ВСЕ эффекты",
        lowGraphics = "Низкая графика",
        copyId = "Копировать ID", destroy = "Удалить Eplisma",
        welcome = "Добро пожаловать", pressE = "RightControl для меню",
    },
}

local function T(key)
    return (L[Lang] and L[Lang][key]) or (L.EN[key]) or key
end

--// ═══════════════════════════════════════════
--//  ORION UI LIBRARY
--// ═══════════════════════════════════════════

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Eplisma v3.0 | by Frost",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "Eplisma",
    IntroText = "Eplisma v3.0",
    IntroIcon = "rbxassetid://4483345998",
})

--// ═══════════════════════════════════════════
--//  STATE
--// ═══════════════════════════════════════════

local CFG = {
    Speed = 16, JumpPower = 50, Gravity = 196.2,
    InfJump = false, Noclip = false,
    Fly = false, FlySpeed = 60,
    GodMode = false, FOV = 70,
    AutoJump = false, BunnyHop = false,

    Aimbot = false, AimFOV = 250, AimSmooth = 5,
    AimBone = "Head", ShowFOV = false,
    HitboxExp = false, HitboxSize = 5,
    KillAura = false, AuraRange = 15,

    ESP = false, BoxESP = false, NameESP = false,
    HealthESP = false, DistESP = false,
    TracerESP = false, ChamsESP = false, TeamCheck = false,

    Fullbright = false, NoFog = false,
    AntiAFK = false, CustomTime = false, TimeVal = 14,
    ClickTP = false, Spin = false, SpinSpeed = 10,
    ChatSpam = false, SpamMsg = "", SpamDelay = 2,
    SavedCF = nil, TpTarget = "",
    AntiKick = false, NoReset = false,
    AntiBlur = false,

    AutoBomb = false,
    BombKeywords = "bomb,бомба,tnt,dynamite,explosive",
}

--// ═══════════════════════════════════════════
--//  TAB: CHARACTER
--// ═══════════════════════════════════════════

local TabChar = Window:MakeTab({
    Name = T("character"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabChar:AddLabel("🏃 Movement")

TabChar:AddSlider({
    Name = T("walkspeed"),
    Min = 0,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "speed",
    Callback = function(v)
        CFG.Speed = v
        pcall(function() Humanoid.WalkSpeed = v end)
    end
})

TabChar:AddSlider({
    Name = T("jumppower"),
    Min = 0,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "power",
    Callback = function(v)
        CFG.JumpPower = v
        pcall(function()
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = v
        end)
    end
})

TabChar:AddSlider({
    Name = T("gravity"),
    Min = 0,
    Max = 500,
    Default = 196,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "gravity",
    Callback = function(v)
        CFG.Gravity = v
        Workspace.Gravity = v
    end
})

TabChar:AddToggle({
    Name = T("infJump"),
    Default = false,
    Callback = function(v) CFG.InfJump = v end
})

TabChar:AddToggle({
    Name = T("autoJump"),
    Default = false,
    Callback = function(v)
        CFG.AutoJump = v
        pcall(function() Humanoid.AutoJumpEnabled = v end)
    end
})

TabChar:AddToggle({
    Name = T("bunnyHop"),
    Default = false,
    Callback = function(v) CFG.BunnyHop = v end
})

TabChar:AddToggle({
    Name = T("noclip"),
    Default = false,
    Callback = function(v) CFG.Noclip = v end
})

TabChar:AddLabel("✈️ Flight")

TabChar:AddToggle({
    Name = T("fly"),
    Default = false,
    Callback = function(v)
        CFG.Fly = v
        if not v then
            pcall(function()
                if HRP:FindFirstChild("_BV") then HRP._BV:Destroy() end
                if HRP:FindFirstChild("_BG") then HRP._BG:Destroy() end
            end)
        end
    end
})

TabChar:AddSlider({
    Name = T("flySpeed"),
    Min = 0,
    Max = 300,
    Default = 60,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "speed",
    Callback = function(v) CFG.FlySpeed = v end
})

TabChar:AddLabel("📷 Camera")

TabChar:AddSlider({
    Name = T("fov"),
    Min = 10,
    Max = 120,
    Default = 70,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "fov",
    Callback = function(v)
        CFG.FOV = v
        Camera.FieldOfView = v
    end
})

TabChar:AddLabel("🛡️ Survivability")

TabChar:AddToggle({
    Name = T("godMode"),
    Default = false,
    Callback = function(v) CFG.GodMode = v end
})

TabChar:AddToggle({
    Name = T("noReset"),
    Default = false,
    Callback = function(v)
        CFG.NoReset = v
        pcall(function() StarterGui:SetCore("ResetButtonCallback", not v) end)
    end
})

TabChar:AddButton({
    Name = T("forceReset"),
    Callback = function()
        pcall(function() Humanoid.Health = 0 end)
    end
})

TabChar:AddButton({
    Name = T("respawn"),
    Callback = function()
        pcall(function() LocalPlayer:LoadCharacter() end)
    end
})

TabChar:AddButton({
    Name = T("freeze"),
    Callback = function()
        pcall(function()
            HRP.Anchored = not HRP.Anchored
            OrionLib:MakeNotification({
                Name = T("freeze"),
                Content = HRP.Anchored and T("frozen") or T("unfrozen"),
                Time = 2
            })
        end)
    end
})

--// ═══════════════════════════════════════════
--//  TAB: COMBAT
--// ═══════════════════════════════════════════

local TabCombat = Window:MakeTab({
    Name = T("combat"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabCombat:AddLabel("🎯 Aim Assist")

TabCombat:AddToggle({
    Name = T("aimbot"),
    Default = false,
    Callback = function(v) CFG.Aimbot = v end
})

TabCombat:AddSlider({
    Name = T("fovRadius"),
    Min = 10,
    Max = 900,
    Default = 250,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 5,
    ValueName = "px",
    Callback = function(v) CFG.AimFOV = v end
})

TabCombat:AddSlider({
    Name = T("smoothing"),
    Min = 1,
    Max = 50,
    Default = 5,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "smooth",
    Callback = function(v) CFG.AimSmooth = v end
})

TabCombat:AddToggle({
    Name = T("showFov"),
    Default = false,
    Callback = function(v) CFG.ShowFOV = v end
})

TabCombat:AddLabel("⚔️ Melee")

TabCombat:AddToggle({
    Name = T("hitbox"),
    Default = false,
    Callback = function(v)
        CFG.HitboxExp = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("HumanoidRootPart")
                if h then
                    h.Size = v and Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize) or Vector3.new(2, 2, 1)
                    h.Transparency = v and 0.5 or 1
                end
            end
        end
    end
})

TabCombat:AddSlider({
    Name = T("hitboxScale"),
    Min = 1,
    Max = 30,
    Default = 5,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "size",
    Callback = function(v) CFG.HitboxSize = v end
})

TabCombat:AddToggle({
    Name = T("killAura"),
    Default = false,
    Callback = function(v) CFG.KillAura = v end
})

TabCombat:AddSlider({
    Name = T("auraRange"),
    Min = 1,
    Max = 60,
    Default = 15,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "studs",
    Callback = function(v) CFG.AuraRange = v end
})

TabCombat:AddLabel("💣 Bomb Pass")

TabCombat:AddToggle({
    Name = T("autoBomb"),
    Default = false,
    Callback = function(v) CFG.AutoBomb = v end
})

TabCombat:AddTextbox({
    Name = T("bombKeywords"),
    Default = "bomb,бомба,tnt,dynamite,explosive",
    TextDisappear = false,
    Callback = function(v) CFG.BombKeywords = v end
})

TabCombat:AddLabel("ℹ️ Info")

TabCombat:AddButton({
    Name = T("nearestPlayer"),
    Callback = function()
        local closest, dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; closest = p end
            end
        end
        if closest then
            OrionLib:MakeNotification({
                Name = T("nearestPlayer"),
                Content = closest.DisplayName .. " — " .. math.floor(dist) .. " studs",
                Time = 4
            })
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = T("noPlayersNear"),
                Time = 3
            })
        end
    end
})

--// ═══════════════════════════════════════════
--//  TAB: TELEPORT
--// ═══════════════════════════════════════════

local TabTP = Window:MakeTab({
    Name = T("teleport"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabTP:AddLabel("🚀 Player Transport")

TabTP:AddTextbox({
    Name = T("targetName"),
    Default = "",
    TextDisappear = false,
    Callback = function(v) CFG.TpTarget = v end
})

TabTP:AddButton({
    Name = T("tpToTarget"),
    Callback = function()
        local query = CFG.TpTarget:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and (p.Name:lower():find(query) or p.DisplayName:lower():find(query)) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                HRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                OrionLib:MakeNotification({
                    Name = T("teleport"),
                    Content = T("movedTo") .. " " .. p.DisplayName,
                    Time = 3
                })
                return
            end
        end
        OrionLib:MakeNotification({
            Name = "Error",
            Content = T("notFound"),
            Time = 3
        })
    end
})

TabTP:AddButton({
    Name = T("randomPlayer"),
    Callback = function()
        local pool = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(pool, p)
            end
        end
        if #pool == 0 then
            OrionLib:MakeNotification({ Name = "Error", Content = T("noPlayers"), Time = 3 })
            return
        end
        local t = pool[math.random(#pool)]
        HRP.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
        OrionLib:MakeNotification({
            Name = T("randomPlayer"),
            Content = T("movedTo") .. " " .. t.DisplayName,
            Time = 3
        })
    end
})

TabTP:AddButton({
    Name = T("tpSpawn"),
    Callback = function()
        pcall(function()
            local sp = Workspace:FindFirstChildOfClass("SpawnLocation")
            if sp then
                HRP.CFrame = sp.CFrame + Vector3.new(0, 5, 0)
            else
                HRP.CFrame = CFrame.new(0, 50, 0)
            end
        end)
    end
})

TabTP:AddButton({
    Name = T("tpForward"),
    Callback = function()
        pcall(function() HRP.CFrame = HRP.CFrame + HRP.CFrame.LookVector * 100 end)
    end
})

TabTP:AddLabel("📍 Waypoints")

TabTP:AddButton({
    Name = T("savePos"),
    Callback = function()
        CFG.SavedCF = HRP.CFrame
        OrionLib:MakeNotification({ Name = T("saved"), Content = T("posStored"), Time = 2 })
    end
})

TabTP:AddButton({
    Name = T("loadPos"),
    Callback = function()
        if CFG.SavedCF then
            HRP.CFrame = CFG.SavedCF
            OrionLib:MakeNotification({ Name = T("loaded"), Content = T("posRestored"), Time = 2 })
        else
            OrionLib:MakeNotification({ Name = "Error", Content = T("nothingSaved"), Time = 2 })
        end
    end
})

TabTP:AddToggle({
    Name = T("clickTp"),
    Default = false,
    Callback = function(v) CFG.ClickTP = v end
})

--// ═══════════════════════════════════════════
--//  TAB: ESP
--// ═══════════════════════════════════════════

local TabESP = Window:MakeTab({
    Name = T("esp"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabESP:AddLabel("👁️ Rendering")

TabESP:AddToggle({
    Name = T("enableEsp"),
    Default = false,
    Callback = function(v) CFG.ESP = v end
})

TabESP:AddToggle({
    Name = T("boundBox"),
    Default = false,
    Callback = function(v) CFG.BoxESP = v end
})

TabESP:AddToggle({
    Name = T("nameTags"),
    Default = false,
    Callback = function(v) CFG.NameESP = v end
})

TabESP:AddToggle({
    Name = T("healthBars"),
    Default = false,
    Callback = function(v) CFG.HealthESP = v end
})

TabESP:AddToggle({
    Name = T("distTags"),
    Default = false,
    Callback = function(v) CFG.DistESP = v end
})

TabESP:AddToggle({
    Name = T("tracers"),
    Default = false,
    Callback = function(v) CFG.TracerESP = v end
})

TabESP:AddToggle({
    Name = T("chams"),
    Default = false,
    Callback = function(v)
        CFG.ChamsESP = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local ex = p.Character:FindFirstChild("_Highlight")
                if v and not ex then
                    local h = Instance.new("Highlight")
                    h.Name = "_Highlight"
                    h.FillColor = Color3.fromRGB(130, 80, 220)
                    h.FillTransparency = 0.4
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = p.Character
                elseif not v and ex then
                    ex:Destroy()
                end
            end
        end
    end
})

TabESP:AddLabel("🔍 Filters")

TabESP:AddToggle({
    Name = T("teamFilter"),
    Default = false,
    Callback = function(v) CFG.TeamCheck = v end
})

--// ═══════════════════════════════════════════
--//  TAB: ENVIRONMENT
--// ═══════════════════════════════════════════

local TabEnv = Window:MakeTab({
    Name = T("environment"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabEnv:AddLabel("💡 Lighting")

TabEnv:AddToggle({
    Name = T("fullbright"),
    Default = false,
    Callback = function(v)
        CFG.Fullbright = v
        if v then
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end
})

TabEnv:AddToggle({
    Name = T("noFog"),
    Default = false,
    Callback = function(v)
        CFG.NoFog = v
        Lighting.FogEnd = v and 9999999 or 100000
    end
})

TabEnv:AddToggle({
    Name = T("timeLock"),
    Default = false,
    Callback = function(v) CFG.CustomTime = v end
})

TabEnv:AddSlider({
    Name = T("clockTime"),
    Min = 0,
    Max = 24,
    Default = 14,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "hour",
    Callback = function(v)
        CFG.TimeVal = v
        if CFG.CustomTime then Lighting.ClockTime = v end
    end
})

TabEnv:AddLabel("🧹 Cleanup")

TabEnv:AddButton({
    Name = T("removeEffects"),
    Callback = function()
        local n = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then
                e:Destroy()
                n += 1
            end
        end
        OrionLib:MakeNotification({ Name = "Cleanup", Content = n .. " " .. T("effectsRemoved"), Time = 2 })
    end
})

TabEnv:AddButton({
    Name = T("removeParticles"),
    Callback = function()
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
                o:Destroy()
                n += 1
            end
        end
        OrionLib:MakeNotification({ Name = "Cleanup", Content = n .. " " .. T("particlesRemoved"), Time = 2 })
    end
})

TabEnv:AddButton({
    Name = T("removeDecals"),
    Callback = function()
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("Decal") or o:IsA("Texture") then o:Destroy(); n += 1 end
        end
        OrionLib:MakeNotification({ Name = "Cleanup", Content = n .. " removed", Time = 2 })
    end
})

TabEnv:AddButton({
    Name = T("removeSounds"),
    Callback = function()
        local n = 0
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("Sound") then o:Stop(); o:Destroy(); n += 1 end
        end
        OrionLib:MakeNotification({ Name = "Cleanup", Content = n .. " removed", Time = 2 })
    end
})

--// ═══════════════════════════════════════════
--//  TAB: UTILITIES
--// ═══════════════════════════════════════════

local TabUtil = Window:MakeTab({
    Name = T("utilities"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabUtil:AddLabel("🔒 Protection")

TabUtil:AddToggle({
    Name = T("antiAfk"),
    Default = false,
    Callback = function(v) CFG.AntiAFK = v end
})

TabUtil:AddToggle({
    Name = T("antiKick"),
    Default = false,
    Callback = function(v) CFG.AntiKick = v end
})

TabUtil:AddLabel("⚡ Actions")

TabUtil:AddToggle({
    Name = T("spin"),
    Default = false,
    Callback = function(v) CFG.Spin = v end
})

TabUtil:AddSlider({
    Name = T("spinSpeed"),
    Min = 1,
    Max = 50,
    Default = 10,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "speed",
    Callback = function(v) CFG.SpinSpeed = v end
})

TabUtil:AddButton({
    Name = T("spawnPlatform"),
    Callback = function()
        local p = Instance.new("Part")
        p.Size = Vector3.new(20, 1, 20)
        p.CFrame = HRP.CFrame * CFrame.new(0, -4, 0)
        p.Anchored = true
        p.BrickColor = BrickColor.new("Bright violet")
        p.Material = Enum.Material.Neon
        p.Transparency = 0.3
        p.Parent = Workspace
    end
})

TabUtil:AddButton({
    Name = T("forceSit"),
    Callback = function()
        pcall(function() Humanoid.Sit = true end)
    end
})

TabUtil:AddButton({
    Name = T("forceJump"),
    Callback = function()
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
})

TabUtil:AddButton({
    Name = T("copyPos"),
    Callback = function()
        local pos = HRP.Position
        local txt = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        pcall(function() setclipboard(txt) end)
        OrionLib:MakeNotification({ Name = T("copied"), Content = txt, Time = 3 })
    end
})

TabUtil:AddButton({
    Name = T("copyLink"),
    Callback = function()
        local link = "https://www.roblox.com/games/" .. game.PlaceId
        pcall(function() setclipboard(link) end)
        OrionLib:MakeNotification({ Name = T("copied"), Content = link, Time = 3 })
    end
})

TabUtil:AddLabel("💬 Chat")

TabUtil:AddTextbox({
    Name = T("spamMsg"),
    Default = "",
    TextDisappear = false,
    Callback = function(v) CFG.SpamMsg = v end
})

TabUtil:AddSlider({
    Name = T("spamInterval"),
    Min = 1,
    Max = 10,
    Default = 2,
    Color = Color3.fromRGB(130, 80, 220),
    Increment = 1,
    ValueName = "sec",
    Callback = function(v) CFG.SpamDelay = v end
})

TabUtil:AddToggle({
    Name = T("chatSpam"),
    Default = false,
    Callback = function(v) CFG.ChatSpam = v end
})

TabUtil:AddLabel("🌐 Server")

TabUtil:AddButton({
    Name = T("rejoin"),
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

TabUtil:AddButton({
    Name = T("serverHop"),
    Callback = function()
        task.spawn(function()
            local ok, data = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
            end)
            if not ok then
                OrionLib:MakeNotification({ Name = "Error", Content = "Failed", Time = 3 })
                return
            end
            for _, sv in ipairs(data.data) do
                if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
                    return
                end
            end
            OrionLib:MakeNotification({ Name = "Error", Content = "No servers", Time = 3 })
        end)
    end
})

TabUtil:AddButton({
    Name = T("serverInfo"),
    Callback = function()
        OrionLib:MakeNotification({
            Name = T("serverInfo"),
            Content = string.format("Players: %d/%d | Place: %d | Ping: ~%dms",
                #Players:GetPlayers(), Players.MaxPlayers, game.PlaceId,
                math.floor(LocalPlayer:GetNetworkPing() * 1000)),
            Time = 6
        })
    end
})

--// ═══════════════════════════════════════════
--//  TAB: SETTINGS
--// ═══════════════════════════════════════════

local TabSettings = Window:MakeTab({
    Name = T("settings"),
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TabSettings:AddLabel("🌍 Language")

TabSettings:AddButton({
    Name = "🇬🇧 English",
    Callback = function()
        Lang = "EN"
        OrionLib:MakeNotification({
            Name = "Language",
            Content = "English selected. Rejoin to apply.",
            Time = 4
        })
    end
})

TabSettings:AddButton({
    Name = "🇷🇺 Русский",
    Callback = function()
        Lang = "RU"
        OrionLib:MakeNotification({
            Name = "Язык",
            Content = "Русский выбран. Перезайдите.",
            Time = 4
        })
    end
})

TabSettings:AddLabel("🖥️ Graphics")

TabSettings:AddToggle({
    Name = T("blurEnabled"),
    Default = false,
    Callback = function(v)
        CFG.AntiBlur = v
        if v then
            for _, obj in ipairs(Lighting:GetChildren()) do
                if obj:IsA("BlurEffect") then obj:Destroy() end
            end
        end
    end
})

TabSettings:AddButton({
    Name = T("removeBlur"),
    Callback = function()
        local n = 0
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") then obj:Destroy(); n += 1 end
        end
        OrionLib:MakeNotification({ Name = "Blur", Content = n .. " removed", Time = 2 })
    end
})

TabSettings:AddButton({
    Name = T("removeAllPost"),
    Callback = function()
        local n = 0
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Atmosphere") then e:Destroy(); n += 1 end
        end
        OrionLib:MakeNotification({ Name = "Cleanup", Content = n .. " removed", Time = 2 })
    end
})

TabSettings:AddButton({
    Name = T("lowGraphics"),
    Callback = function()
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        Lighting.GlobalShadows = false
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Atmosphere") then e.Enabled = false end
        end
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled = false end
        end
        OrionLib:MakeNotification({ Name = "Graphics", Content = "Low mode ON", Time = 2 })
    end
})

TabSettings:AddLabel("👤 Player Info")

TabSettings:AddParagraph("Player Info", "Name: " .. LocalPlayer.Name .. "\nDisplay: " .. LocalPlayer.DisplayName .. "\nID: " .. LocalPlayer.UserId)

TabSettings:AddButton({
    Name = T("copyId"),
    Callback = function()
        pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end)
        OrionLib:MakeNotification({ Name = T("copied"), Content = tostring(LocalPlayer.UserId), Time = 2 })
    end
})

TabSettings:AddLabel("ℹ️ About")

TabSettings:AddParagraph("Eplisma v3.0", "Developer: Frost\nTelegram: @Jokerfros\n\nOrion UI • 2 languages\nAuto Bomb Pass included")

TabSettings:AddLabel("⚠️ Danger Zone")

TabSettings:AddButton({
    Name = T("destroy"),
    Callback = function()
        pcall(function() _G._CleanESP() end)
        pcall(function() _G._FOV:Remove() end)
        pcall(function()
            if HRP:FindFirstChild("_BV") then HRP._BV:Destroy() end
            if HRP:FindFirstChild("_BG") then HRP._BG:Destroy() end
        end)
        CFG.Fly = false
        CFG.Noclip = false
        CFG.ESP = false
        CFG.Aimbot = false
        CFG.AutoBomb = false
        OrionLib:Destroy()
    end
})

--// ═══════════════════════════════════════════
--//  DRAWING: FOV CIRCLE
--// ═══════════════════════════════════════════

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = CFG.AimFOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.ZIndex = 999
FOVCircle.Transparency = 0.75
FOVCircle.Color = Color3.fromRGB(130, 80, 220)
_G._FOV = FOVCircle

--// ═══════════════════════════════════════════
--//  DRAWING: ESP
--// ═══════════════════════════════════════════

local ESPCache = {}

local function MkDraw(cls, props)
    local d = Drawing.new(cls)
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function AddESP(plr)
    if plr == LocalPlayer or ESPCache[plr] then return end
    ESPCache[plr] = {
        Box = MkDraw("Square", { Thickness = 1.5, Filled = false, Color = Color3.fromRGB(130, 80, 220), Visible = false, ZIndex = 5 }),
        Name = MkDraw("Text", { Size = 13, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255), Visible = false, ZIndex = 5, Font = 2 }),
        HpBG = MkDraw("Line", { Thickness = 4, Color = Color3.fromRGB(0, 0, 0), Visible = false, ZIndex = 4 }),
        Hp = MkDraw("Line", { Thickness = 2, Color = Color3.fromRGB(0, 255, 0), Visible = false, ZIndex = 5 }),
        Dist = MkDraw("Text", { Size = 11, Center = true, Outline = true, Color = Color3.fromRGB(180, 180, 200), Visible = false, ZIndex = 5, Font = 2 }),
        Tracer = MkDraw("Line", { Thickness = 1.5, Color = Color3.fromRGB(130, 80, 220), Visible = false, ZIndex = 5 }),
    }
end

local function DelESP(plr)
    if ESPCache[plr] then
        for _, d in pairs(ESPCache[plr]) do pcall(d.Remove, d) end
        ESPCache[plr] = nil
    end
end

local function HideAll(esp)
    for _, d in pairs(esp) do d.Visible = false end
end

_G._CleanESP = function()
    for p in pairs(ESPCache) do DelESP(p) end
end

for _, p in ipairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(DelESP)

--// ═══════════════════════════════════════════
--//  HELPERS
--// ═══════════════════════════════════════════

local function IsAlly(plr)
    if not CFG.TeamCheck then return false end
    local ok, res = pcall(function() return plr.Team == LocalPlayer.Team end)
    return ok and res
end

local function FindTarget()
    local best, bestD = nil, CFG.AimFOV
    local mp = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or IsAlly(p) then continue end
        local c = p.Character
        if not c then continue end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local part = c:FindFirstChild(CFG.AimBone) or c:FindFirstChild("HumanoidRootPart")
        if not (hum and hum.Health > 0 and part) then continue end
        local sp, vis = Camera:WorldToScreenPoint(part.Position)
        if not vis then continue end
        local d = (Vector2.new(sp.X, sp.Y) - mp).Magnitude
        if d < bestD then bestD = d; best = p end
    end
    return best
end

local function FindNearestPlayer()
    local closest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; closest = p end
        end
    end
    return closest
end

local function IsBombTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tool.Name:lower()
    for word in CFG.BombKeywords:lower():gmatch("[^,]+") do
        word = word:match("^%s*(.-)%s*$")
        if word ~= "" and name:find(word) then return true end
    end
    return false
end

--// ═══════════════════════════════════════════
--//  RENDER LOOP
--// ═══════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    local mp = UserInputService:GetMouseLocation()

    FOVCircle.Visible = CFG.ShowFOV
    FOVCircle.Radius = CFG.AimFOV
    FOVCircle.Position = mp

    -- Aimbot
    if CFG.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = FindTarget()
        if t and t.Character then
            local part = t.Character:FindFirstChild(CFG.AimBone) or t.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local s = 1 / math.max(CFG.AimSmooth, 0.01)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), s)
            end
        end
    end

    -- ESP
    local vp = Camera.ViewportSize
    for plr, esp in pairs(ESPCache) do
        local c = plr.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local head = c and c:FindFirstChild("Head")
        if not (c and hum and hum.Health > 0 and hrp and head and CFG.ESP) or IsAlly(plr) then
            HideAll(esp)
            continue
        end
        local wp, vis = Camera:WorldToViewportPoint(hrp.Position)
        local hp = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, .5, 0))
        local fp = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        if not vis then HideAll(esp); continue end
        local bH = math.abs(hp.Y - fp.Y)
        local bW = bH * 0.55
        local cx = wp.X

        esp.Box.Visible = CFG.BoxESP
        esp.Box.Size = Vector2.new(bW, bH)
        esp.Box.Position = Vector2.new(cx - bW * .5, hp.Y)

        esp.Name.Visible = CFG.NameESP
        esp.Name.Text = plr.DisplayName
        esp.Name.Position = Vector2.new(cx, hp.Y - 16)

        local pct = hum.Health / hum.MaxHealth
        esp.HpBG.Visible = CFG.HealthESP
        esp.HpBG.From = Vector2.new(cx - bW * .5 - 5, fp.Y)
        esp.HpBG.To = Vector2.new(cx - bW * .5 - 5, hp.Y)
        esp.Hp.Visible = CFG.HealthESP
        esp.Hp.From = Vector2.new(cx - bW * .5 - 5, fp.Y)
        esp.Hp.To = Vector2.new(cx - bW * .5 - 5, fp.Y - bH * pct)
        esp.Hp.Color = Color3.new(1 - pct, pct, 0)

        local dist = (HRP.Position - hrp.Position).Magnitude
        esp.Dist.Visible = CFG.DistESP
        esp.Dist.Text = math.floor(dist) .. "m"
        esp.Dist.Position = Vector2.new(cx, fp.Y + 3)

        esp.Tracer.Visible = CFG.TracerESP
        esp.Tracer.From = Vector2.new(vp.X * .5, vp.Y)
        esp.Tracer.To = Vector2.new(cx, fp.Y)
    end

    -- Fly
    if CFG.Fly and HRP then
        local bv = HRP:FindFirstChild("_BV")
        local bg = HRP:FindFirstChild("_BG")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name = "_BV"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Parent = HRP
        end
        if not bg then
            bg = Instance.new("BodyGyro")
            bg.Name = "_BG"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.D = 200
            bg.P = 10000
            bg.Parent = HRP
        end
        bg.CFrame = Camera.CFrame
        local dir = Vector3.zero
        local u = UserInputService
        if u:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
        if u:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
        if u:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
        if u:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
        if u:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if u:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.yAxis end
        bv.Velocity = dir * CFG.FlySpeed
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Flying) end)
    end

    if CFG.Spin and HRP then HRP.CFrame *= CFrame.Angles(0, math.rad(CFG.SpinSpeed), 0) end
    if CFG.CustomTime then Lighting.ClockTime = CFG.TimeVal end
    if CFG.Speed ~= 16 and Humanoid then pcall(function() Humanoid.WalkSpeed = CFG.Speed end) end
    if CFG.JumpPower ~= 50 and Humanoid then pcall(function() Humanoid.JumpPower = CFG.JumpPower end) end
end)

--// ═══════════════════════════════════════════
--//  HEARTBEAT
--// ═══════════════════════════════════════════

RunService.Heartbeat:Connect(function()
    if CFG.GodMode and Humanoid then
        pcall(function() Humanoid.Health = Humanoid.MaxHealth end)
    end
    if CFG.Noclip and Character then
        for _, p in ipairs(Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if CFG.BunnyHop and Humanoid then
        pcall(function()
            if Humanoid.FloorMaterial ~= Enum.Material.Air then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    if CFG.AntiBlur then
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") then obj:Destroy() end
        end
    end
end)

--// ═══════════════════════════════════════════
--//  INPUT
--// ═══════════════════════════════════════════

UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump and Humanoid then
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end
end)

Mouse.Button1Down:Connect(function()
    if CFG.ClickTP and Mouse.Hit then
        pcall(function() HRP.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end)
    end
end)

--// ═══════════════════════════════════════════
--//  BACKGROUND
--// ═══════════════════════════════════════════

LocalPlayer.Idled:Connect(function()
    if CFG.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Chat Spam
task.spawn(function()
    while true do
        if CFG.ChatSpam and CFG.SpamMsg ~= "" then
            pcall(function()
                ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents", true):FindFirstChild("SayMessageRequest"):FireServer(CFG.SpamMsg, "All")
            end)
        end
        task.wait(math.max(CFG.SpamDelay, 0.5))
    end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(0.15) do
        if not CFG.KillAura or not HRP then continue end
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or IsAlly(p) then continue end
            local c = p.Character
            local hrp2 = c and c:FindFirstChild("HumanoidRootPart")
            local hum2 = c and c:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum2 and hum2.Health > 0 and (HRP.Position - hrp2.Position).Magnitude <= CFG.AuraRange then
                pcall(function()
                    local tool = Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local h = tool:FindFirstChild("Handle")
                        if h then
                            firetouchinterest(h, hrp2, 0)
                            task.wait()
                            firetouchinterest(h, hrp2, 1)
                        end
                    end
                end)
            end
        end
    end
end)

--// ═══════════════════════════════════════════
--//  AUTO BOMB PASS
--// ═══════════════════════════════════════════

task.spawn(function()
    while task.wait(0.1) do
        if not CFG.AutoBomb or not Character then continue end

        for _, tool in ipairs(Character:GetChildren()) do
            if IsBombTool(tool) then
                local nearest = FindNearestPlayer()
                if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = nearest.Character.HumanoidRootPart

                    pcall(function()
                        HRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
                    end)

                    task.wait(0.05)

                    pcall(function()
                        local handle = tool:FindFirstChild("Handle")
                        if handle then
                            firetouchinterest(handle, targetHRP, 0)
                            task.wait(0.05)
                            firetouchinterest(handle, targetHRP, 1)
                        end
                    end)

                    task.wait(0.1)

                    if tool.Parent == Character then
                        pcall(function()
                            local handle = tool:FindFirstChild("Handle")
                            if handle then
                                firetouchinterest(handle, targetHRP, 0)
                                task.wait(0.1)
                                firetouchinterest(handle, targetHRP, 1)
                            end
                        end)
                    end
                end
                break
            end
        end
    end
end)

-- Hitbox + Chams for new players
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if CFG.HitboxExp then
            task.wait(1)
            local h = char:FindFirstChild("HumanoidRootPart")
            if h then
                h.Size = Vector3.new(CFG.HitboxSize, CFG.HitboxSize, CFG.HitboxSize)
                h.Transparency = 0.5
            end
        end
        if CFG.ChamsESP then
            task.wait(1)
            if not char:FindFirstChild("_Highlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "_Highlight"
                hl.FillColor = Color3.fromRGB(130, 80, 220)
                hl.FillTransparency = 0.4
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = char
            end
        end
    end)
end)

-- Final blur cleanup
task.delay(2, function()
    pcall(function()
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") then obj:Destroy() end
        end
    end)
end)

--// ═══════════════════════════════════════════
--//  INIT
--// ═══════════════════════════════════════════

OrionLib:Init()

OrionLib:MakeNotification({
    Name = "Eplisma v3.0",
    Content = T("welcome") .. ", " .. LocalPlayer.DisplayName .. "! " .. T("pressE"),
    Image = "rbxassetid://4483345998",
    Time = 6
})

print([[
╔══════════════════════════════════════╗
║         E P L I S M A  v3.0         ║
║     Developer: Frost                ║
║     Telegram: @Jokerfros            ║
║     UI: Orion Library               ║
╠══════════════════════════════════════╣
║  Player: ]] .. LocalPlayer.Name .. [[

║  Place: ]] .. game.PlaceId .. [[

╚══════════════════════════════════════╝
]])
