--[[
    ╔══════════════════════════════════════════╗
    ║           E P L I S M A                  ║
    ║       Professional Cheat Suite           ║
    ║                                          ║
    ║   Developer: Frost                       ║
    ║   Telegram: @Jokerfros                   ║
    ║   Version: 3.0 (Fluent UI)               ║
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
        settings = "Settings", movement = "Movement", flight = "Flight",
        camera = "Camera", survivability = "Survivability", aimAssist = "Aim Assist",
        melee = "Melee", info = "Info", playerTransport = "Player Transport",
        waypoints = "Waypoints", rendering = "Rendering", filters = "Filters",
        lighting = "Lighting", cleanup = "Cleanup", protection = "Protection",
        actions = "Actions", chat = "Chat", server = "Server", theme = "Theme",
        graphics = "Graphics", window = "Window", playerInfo = "Player Info",
        about = "About", dangerZone = "Danger Zone", language = "Language",
        bombPass = "Bomb Pass",
        walkspeed = "WalkSpeed", walkspeedDesc = "Movement speed",
        jumppower = "JumpPower", jumppowerDesc = "Jump height",
        gravity = "Gravity", gravityDesc = "World gravity (196.2 default)",
        infJump = "Infinite Jump", infJumpDesc = "Jump mid-air",
        autoJump = "Auto Jump", autoJumpDesc = "Jump automatically when walking",
        bunnyHop = "Bunny Hop", bunnyHopDesc = "Jump on landing",
        noclip = "Noclip", noclipDesc = "Walk through walls",
        fly = "Fly", flyDesc = "Free flight mode",
        flySpeed = "Fly Speed", flySpeedDesc = "Flight velocity",
        fov = "Field of View", fovDesc = "Camera FOV (70 default)",
        godMode = "God Mode", godModeDesc = "Max health always",
        noReset = "No Reset", noResetDesc = "Disable reset button",
        forceReset = "Force Reset", forceResetDesc = "Kill character",
        respawn = "Respawn", respawnDesc = "Force respawn",
        freeze = "Freeze Character", freezeDesc = "Stop all movement",
        frozen = "Frozen", unfrozen = "Unfrozen",
        aimbot = "Aimbot", aimbotDesc = "Lock-on aim (hold RMB)",
        fovRadius = "FOV Radius", fovRadiusDesc = "Detection radius",
        smoothing = "Smoothing", smoothingDesc = "Aim speed (1=instant)",
        showFov = "Show FOV Circle", showFovDesc = "Render FOV boundary",
        hitbox = "Hitbox Expander", hitboxDesc = "Enlarge enemy hitboxes",
        hitboxScale = "Hitbox Scale", hitboxScaleDesc = "Hitbox size",
        killAura = "Kill Aura", killAuraDesc = "Auto-attack nearby",
        auraRange = "Aura Range", auraRangeDesc = "Detection distance",
        nearestPlayer = "Show Nearest Player", nearestPlayerDesc = "Closest player info",
        noPlayersNear = "No players nearby",
        targetName = "Target Name", targetNameDesc = "Partial or full name",
        tpToTarget = "Teleport to Target", tpToTargetDesc = "Move to player",
        randomPlayer = "Random Player", randomPlayerDesc = "Teleport to random",
        tpSpawn = "Teleport to Spawn", tpSpawnDesc = "Return to spawn",
        tpForward = "Teleport Forward 100", tpForwardDesc = "Jump 100 studs forward",
        savePos = "Save Position", savePosDesc = "Store coordinates",
        loadPos = "Load Position", loadPosDesc = "Return to saved spot",
        clickTp = "Click Teleport", clickTpDesc = "Click to teleport",
        saved = "Saved", loaded = "Loaded",
        posStored = "Position stored", posRestored = "Position restored",
        nothingSaved = "Nothing saved", notFound = "Player not found",
        noPlayers = "No players available", movedTo = "Moved to",
        enableEsp = "Enable ESP", enableEspDesc = "Master ESP switch",
        boundBox = "Bounding Box", boundBoxDesc = "Rectangles around players",
        nameTags = "Name Tags", nameTagsDesc = "Show player names",
        healthBars = "Health Bars", healthBarsDesc = "Health indicators",
        distTags = "Distance Tags", distTagsDesc = "Distance in studs",
        tracers = "Tracers", tracersDesc = "Lines to targets",
        chams = "Chams", chamsDesc = "Highlight through walls",
        teamFilter = "Team Filter", teamFilterDesc = "Exclude teammates",
        fullbright = "Fullbright", fullbrightDesc = "Remove shadows",
        noFog = "No Fog", noFogDesc = "Disable fog",
        timeLock = "Time Lock", timeLockDesc = "Lock time of day",
        clockTime = "Clock Time", clockTimeDesc = "Hour (0-24)",
        removeEffects = "Remove All Effects", removeEffectsDesc = "Bloom, blur, DOF, etc",
        removeParticles = "Remove Particles", removeParticlesDesc = "Fire, smoke, sparkles",
        removeDecals = "Remove Decals", removeDecalsDesc = "Strip decals/textures",
        removeSounds = "Remove Sounds", removeSoundsDesc = "Kill all sounds",
        effectsRemoved = "effects removed", particlesRemoved = "particles removed",
        antiAfk = "Anti-AFK", antiAfkDesc = "Prevent idle disconnect",
        antiKick = "Anti-Kick", antiKickDesc = "Block kick attempts",
        spin = "Character Spin", spinDesc = "Continuous rotation",
        spinSpeed = "Spin Speed", spinSpeedDesc = "Rotation speed",
        spawnPlatform = "Spawn Platform", spawnPlatformDesc = "Neon platform below you",
        forceSit = "Force Sit", forceSitDesc = "Sit immediately",
        forceJump = "Force Jump", forceJumpDesc = "Jump right now",
        copyPos = "Copy Position", copyPosDesc = "Copy coordinates",
        copyLink = "Copy Game Link", copyLinkDesc = "Copy place link",
        spamMsg = "Spam Message", spamMsgDesc = "Text to repeat",
        spamInterval = "Spam Interval", spamIntervalDesc = "Delay (seconds)",
        chatSpam = "Chat Spam", chatSpamDesc = "Repeat in chat",
        rejoin = "Rejoin", rejoinDesc = "Reconnect to server",
        serverHop = "Server Hop", serverHopDesc = "Jump to another server",
        serverInfo = "Server Info", serverInfoDesc = "Show server details",
        copied = "Copied",
        autoBomb = "Auto Bomb Pass", autoBombDesc = "Auto-pass bomb to nearest player",
        bombKeywords = "Bomb Keywords", bombKeywordsDesc = "Tool names to detect (comma separated)",
        removeBlur = "Disable Blur", removeBlurDesc = "Remove all blur effects",
        blurEnabled = "Blur Protection", blurEnabledDesc = "Auto-delete blur effects",
        removeAllPost = "Remove ALL Post Effects", removeAllPostDesc = "Strip every effect",
        lowGraphics = "Low Graphics Mode", lowGraphicsDesc = "Reduce quality for FPS",
        copyId = "Copy Player ID", copyIdDesc = "Copy your UserId",
        destroy = "Destroy Eplisma", destroyDesc = "Remove cheat completely",
        loaded_msg = "Loaded", welcome = "Welcome",
        pressE = "Press RightControl to toggle menu",
    },
    RU = {
        character = "Персонаж", combat = "Бой", teleport = "Телепорт",
        esp = "ESP", environment = "Окружение", utilities = "Утилиты",
        settings = "Настройки", movement = "Движение", flight = "Полёт",
        camera = "Камера", survivability = "Выживание", aimAssist = "Прицеливание",
        melee = "Ближний бой", info = "Инфо", playerTransport = "Телепорт к игрокам",
        waypoints = "Точки", rendering = "Отрисовка", filters = "Фильтры",
        lighting = "Освещение", cleanup = "Очистка", protection = "Защита",
        actions = "Действия", chat = "Чат", server = "Сервер", theme = "Тема",
        graphics = "Графика", window = "Окно", playerInfo = "Об игроке",
        about = "О программе", dangerZone = "Опасная зона", language = "Язык",
        bombPass = "Бомба",
        walkspeed = "Скорость", walkspeedDesc = "Скорость передвижения",
        jumppower = "Прыжок", jumppowerDesc = "Высота прыжка",
        gravity = "Гравитация", gravityDesc = "Гравитация мира (196.2)",
        infJump = "Бесконечный прыжок", infJumpDesc = "Прыжок в воздухе",
        autoJump = "Авто-прыжок", autoJumpDesc = "Прыгать автоматически",
        bunnyHop = "Банни-хоп", bunnyHopDesc = "Прыжок при приземлении",
        noclip = "Ноклип", noclipDesc = "Проходить сквозь стены",
        fly = "Полёт", flyDesc = "Свободный полёт",
        flySpeed = "Скорость полёта", flySpeedDesc = "Скорость в полёте",
        fov = "Угол обзора", fovDesc = "FOV камеры (70 стандарт)",
        godMode = "Бессмертие", godModeDesc = "Максимальное здоровье",
        noReset = "Без ресета", noResetDesc = "Отключить кнопку ресета",
        forceReset = "Убить себя", forceResetDesc = "Мгновенная смерть",
        respawn = "Респавн", respawnDesc = "Принудительный респавн",
        freeze = "Заморозить", freezeDesc = "Остановить движение",
        frozen = "Заморожен", unfrozen = "Разморожен",
        aimbot = "Аимбот", aimbotDesc = "Автоприцел (ПКМ)",
        fovRadius = "Радиус FOV", fovRadiusDesc = "Радиус обнаружения",
        smoothing = "Плавность", smoothingDesc = "Скорость наведения",
        showFov = "Показать FOV", showFovDesc = "Отрисовка круга FOV",
        hitbox = "Расширение хитбокса", hitboxDesc = "Увеличить хитбоксы врагов",
        hitboxScale = "Размер хитбокса", hitboxScaleDesc = "Множитель размера",
        killAura = "Аура убийства", killAuraDesc = "Авто-атака рядом",
        auraRange = "Радиус ауры", auraRangeDesc = "Дистанция обнаружения",
        nearestPlayer = "Ближайший игрок", nearestPlayerDesc = "Инфо о ближайшем",
        noPlayersNear = "Нет игроков рядом",
        targetName = "Имя цели", targetNameDesc = "Часть или полное имя",
        tpToTarget = "ТП к цели", tpToTargetDesc = "Переместиться к игроку",
        randomPlayer = "Случайный игрок", randomPlayerDesc = "ТП к случайному",
        tpSpawn = "ТП на спавн", tpSpawnDesc = "Вернуться на спавн",
        tpForward = "ТП вперёд 100", tpForwardDesc = "Прыжок на 100 стадов",
        savePos = "Сохранить позицию", savePosDesc = "Запомнить координаты",
        loadPos = "Загрузить позицию", loadPosDesc = "Вернуться к сохранённой",
        clickTp = "ТП по клику", clickTpDesc = "Кликни чтобы телепортнуться",
        saved = "Сохранено", loaded = "Загружено",
        posStored = "Позиция сохранена", posRestored = "Позиция восстановлена",
        nothingSaved = "Ничего не сохранено", notFound = "Игрок не найден",
        noPlayers = "Нет игроков", movedTo = "Перемещён к",
        enableEsp = "Включить ESP", enableEspDesc = "Главный переключатель",
        boundBox = "Рамки", boundBoxDesc = "Прямоугольники вокруг игроков",
        nameTags = "Имена", nameTagsDesc = "Показать имена",
        healthBars = "Полоски HP", healthBarsDesc = "Индикатор здоровья",
        distTags = "Дистанция", distTagsDesc = "Расстояние в стадах",
        tracers = "Линии", tracersDesc = "Линии к целям",
        chams = "Хамс", chamsDesc = "Подсветка сквозь стены",
        teamFilter = "Фильтр команды", teamFilterDesc = "Исключить союзников",
        fullbright = "Яркий свет", fullbrightDesc = "Убрать тени",
        noFog = "Без тумана", noFogDesc = "Отключить туман",
        timeLock = "Блокировка времени", timeLockDesc = "Зафиксировать время",
        clockTime = "Время суток", clockTimeDesc = "Час (0-24)",
        removeEffects = "Убрать все эффекты", removeEffectsDesc = "Блум, блюр, DOF и т.д.",
        removeParticles = "Убрать частицы", removeParticlesDesc = "Огонь, дым, искры",
        removeDecals = "Убрать декали", removeDecalsDesc = "Убрать декали/текстуры",
        removeSounds = "Убрать звуки", removeSoundsDesc = "Убить все звуки",
        effectsRemoved = "эффектов удалено", particlesRemoved = "частиц удалено",
        antiAfk = "Анти-АФК", antiAfkDesc = "Защита от кика за АФК",
        antiKick = "Анти-Кик", antiKickDesc = "Блокировка кика",
        spin = "Вращение", spinDesc = "Постоянное вращение",
        spinSpeed = "Скорость вращения", spinSpeedDesc = "Скорость поворота",
        spawnPlatform = "Создать платформу", spawnPlatformDesc = "Неоновая платформа",
        forceSit = "Сесть", forceSitDesc = "Сесть немедленно",
        forceJump = "Прыгнуть", forceJumpDesc = "Прыжок сейчас",
        copyPos = "Копировать позицию", copyPosDesc = "Скопировать координаты",
        copyLink = "Копировать ссылку", copyLinkDesc = "Ссылка на игру",
        spamMsg = "Сообщение спама", spamMsgDesc = "Текст для повтора",
        spamInterval = "Интервал", spamIntervalDesc = "Задержка (секунды)",
        chatSpam = "Спам в чат", chatSpamDesc = "Повтор в чате",
        rejoin = "Реджойн", rejoinDesc = "Переподключиться",
        serverHop = "Сменить сервер", serverHopDesc = "Перейти на другой",
        serverInfo = "Инфо сервера", serverInfoDesc = "Показать детали",
        copied = "Скопировано",
        autoBomb = "Авто-передача бомбы", autoBombDesc = "Автоматически передать бомбу ближайшему",
        bombKeywords = "Ключевые слова бомбы", bombKeywordsDesc = "Названия инструментов (через запятую)",
        removeBlur = "Убрать блюр", removeBlurDesc = "Удалить все блюр-эффекты",
        blurEnabled = "Защита от блюра", blurEnabledDesc = "Авто-удаление блюра",
        removeAllPost = "Убрать ВСЕ эффекты", removeAllPostDesc = "Удалить всё",
        lowGraphics = "Низкая графика", lowGraphicsDesc = "Снизить качество для FPS",
        copyId = "Копировать ID", copyIdDesc = "Скопировать UserId",
        destroy = "Удалить Eplisma", destroyDesc = "Полностью удалить чит",
        loaded_msg = "Загружен", welcome = "Добро пожаловать",
        pressE = "Нажми RightControl чтобы переключить меню",
    },
}

local function T(key)
    return (L[Lang] and L[Lang][key]) or (L.EN[key]) or key
end

--// ═══════════════════════════════════════════
--//  FLUENT UI LIBRARY
--// ═══════════════════════════════════════════

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Eplisma v3.0",
    SubTitle = "by Frost | @Jokerfros",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
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
--//  TABS
--// ═══════════════════════════════════════════

local Tabs = {
    Character = Window:AddTab({ Title = T("character"), Icon = "user" }),
    Combat = Window:AddTab({ Title = T("combat"), Icon = "swords" }),
    Teleport = Window:AddTab({ Title = T("teleport"), Icon = "map-pin" }),
    ESP = Window:AddTab({ Title = T("esp"), Icon = "eye" }),
    Environment = Window:AddTab({ Title = T("environment"), Icon = "sun" }),
    Utilities = Window:AddTab({ Title = T("utilities"), Icon = "wrench" }),
    Settings = Window:AddTab({ Title = T("settings"), Icon = "settings" }),
}

--// ═══════════════════════════════════════════
--//  TAB: CHARACTER
--// ═══════════════════════════════════════════

do
    local Tab = Tabs.Character

    -- Movement Section
    Tab:AddParagraph({
        Title = "🏃 " .. T("movement"),
        Content = ""
    })

    Tab:AddSlider("WalkSpeed", {
        Title = T("walkspeed"),
        Description = T("walkspeedDesc"),
        Default = 16,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            CFG.Speed = v
            pcall(function() Humanoid.WalkSpeed = v end)
        end
    })

    Tab:AddSlider("JumpPower", {
        Title = T("jumppower"),
        Description = T("jumppowerDesc"),
        Default = 50,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(v)
            CFG.JumpPower = v
            pcall(function()
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = v
            end)
        end
    })

    Tab:AddSlider("Gravity", {
        Title = T("gravity"),
        Description = T("gravityDesc"),
        Default = 196.2,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Callback = function(v)
            CFG.Gravity = v
            Workspace.Gravity = v
        end
    })

    Tab:AddToggle("InfJump", {
        Title = T("infJump"),
        Description = T("infJumpDesc"),
        Default = false,
        Callback = function(v) CFG.InfJump = v end
    })

    Tab:AddToggle("AutoJump", {
        Title = T("autoJump"),
        Description = T("autoJumpDesc"),
        Default = false,
        Callback = function(v)
            CFG.AutoJump = v
            pcall(function() Humanoid.AutoJumpEnabled = v end)
        end
    })

    Tab:AddToggle("BunnyHop", {
        Title = T("bunnyHop"),
        Description = T("bunnyHopDesc"),
        Default = false,
        Callback = function(v) CFG.BunnyHop = v end
    })

    Tab:AddToggle("Noclip", {
        Title = T("noclip"),
        Description = T("noclipDesc"),
        Default = false,
        Callback = function(v) CFG.Noclip = v end
    })

    -- Flight Section
    Tab:AddParagraph({
        Title = "✈️ " .. T("flight"),
        Content = ""
    })

    Tab:AddToggle("Fly", {
        Title = T("fly"),
        Description = T("flyDesc"),
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

    Tab:AddSlider("FlySpeed", {
        Title = T("flySpeed"),
        Description = T("flySpeedDesc"),
        Default = 60,
        Min = 0,
        Max = 300,
        Rounding = 0,
        Callback = function(v) CFG.FlySpeed = v end
    })

    -- Camera Section
    Tab:AddParagraph({
        Title = "📷 " .. T("camera"),
        Content = ""
    })

    Tab:AddSlider("FOV", {
        Title = T("fov"),
        Description = T("fovDesc"),
        Default = 70,
        Min = 10,
        Max = 120,
        Rounding = 0,
        Callback = function(v)
            CFG.FOV = v
            Camera.FieldOfView = v
        end
    })

    -- Survivability Section
    Tab:AddParagraph({
        Title = "🛡️ " .. T("survivability"),
        Content = ""
    })

    Tab:AddToggle("GodMode", {
        Title = T("godMode"),
        Description = T("godModeDesc"),
        Default = false,
        Callback = function(v) CFG.GodMode = v end
    })

    Tab:AddToggle("NoReset", {
        Title = T("noReset"),
        Description = T("noResetDesc"),
        Default = false,
        Callback = function(v)
            CFG.NoReset = v
            pcall(function() StarterGui:SetCore("ResetButtonCallback", not v) end)
        end
    })

    Tab:AddButton({
        Title = T("forceReset"),
        Description = T("forceResetDesc"),
        Callback = function()
            pcall(function() Humanoid.Health = 0 end)
        end
    })

    Tab:AddButton({
        Title = T("respawn"),
        Description = T("respawnDesc"),
        Callback = function()
            pcall(function() LocalPlayer:LoadCharacter() end)
        end
    })

    Tab:AddButton({
        Title = T("freeze"),
        Description = T("freezeDesc"),
        Callback = function()
            pcall(function()
                HRP.Anchored = not HRP.Anchored
                Fluent:Notify({
                    Title = T("freeze"),
                    Content = HRP.Anchored and T("frozen") or T("unfrozen"),
                    Duration = 2
                })
            end)
        end
    })
end

--// ═══════════════════════════════════════════
--//  TAB: COMBAT
--// ═══════════════════════════════════════════

do
    local Tab = Tabs.Combat

    -- Aim Assist Section
    Tab:AddParagraph({
        Title = "🎯 " .. T("aimAssist"),
        Content = ""
    })

    Tab:AddToggle("Aimbot", {
        Title = T("aimbot"),
        Description = T("aimbotDesc"),
        Default = false,
        Callback = function(v) CFG.Aimbot = v end
    })

    Tab:AddSlider("AimFOV", {
        Title = T("fovRadius"),
        Description = T("fovRadiusDesc"),
        Default = 250,
        Min = 10,
        Max = 900,
        Rounding = 0,
        Callback = function(v) CFG.AimFOV = v end
    })

    Tab:AddSlider("AimSmooth", {
        Title = T("smoothing"),
        Description = T("smoothingDesc"),
        Default = 5,
        Min = 1,
        Max = 50,
        Rounding = 1,
        Callback = function(v) CFG.AimSmooth = v end
    })

    Tab:AddToggle("ShowFOV", {
        Title = T("showFov"),
        Description = T("showFovDesc"),
        Default = false,
        Callback = function(v) CFG.ShowFOV = v end
    })

    -- Melee Section
    Tab:AddParagraph({
        Title = "⚔️ " .. T("melee"),
        Content = ""
    })

    Tab:AddToggle("HitboxExp", {
        Title = T("hitbox"),
        Description = T("hitboxDesc"),
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

    Tab:AddSlider("HitboxSize", {
        Title = T("hitboxScale"),
        Description = T("hitboxScaleDesc"),
        Default = 5,
        Min = 1,
        Max = 30,
        Rounding = 0,
        Callback = function(v) CFG.HitboxSize = v end
    })

    Tab:AddToggle("KillAura", {
        Title = T("killAura"),
        Description = T("killAuraDesc"),
        Default = false,
        Callback = function(v) CFG.KillAura = v end
    })

    Tab:AddSlider("AuraRange", {
        Title = T("auraRange"),
        Description = T("auraRangeDesc"),
        Default = 15,
        Min = 1,
        Max = 60,
        Rounding = 0,
        Callback = function(v) CFG.AuraRange = v end
    })

    -- Bomb Pass Section
    Tab:AddParagraph({
        Title = "💣 " .. T("bombPass"),
        Content = ""
    })

    Tab:AddToggle("AutoBomb", {
        Title = T("autoBomb"),
        Description = T("autoBombDesc"),
        Default = false,
        Callback = function(v) CFG.AutoBomb = v end
    })

    Tab:AddInput("BombKeywords", {
        Title = T("bombKeywords"),
        Description = T("bombKeywordsDesc"),
        Default = "bomb,бомба,tnt,dynamite,explosive",
        Placeholder = "bomb,tnt...",
        Numeric = false,
        Finished = false,
        Callback = function(v) CFG.BombKeywords = v end
    })

    -- Info Section
    Tab:AddParagraph({
        Title = "ℹ️ " .. T("info"),
        Content = ""
    })

    Tab:AddButton({
        Title = T("nearestPlayer"),
        Description = T("nearestPlayerDesc"),
        Callback = function()
            local closest, dist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then dist = d; closest = p end
                end
            end
            if closest then
                Fluent:Notify({
                    Title = T("nearestPlayer"),
                    Content = closest.DisplayName .. " — " .. math.floor(dist) .. " studs",
                    Duration = 4
                })
            else
                Fluent:Notify({
                    Title = "Error",
                    Content = T("noPlayersNear"),
                    Duration = 3
                })
            end
        end
    })
end

--// ═══════════════════════════════════════════
--//  TAB: TELEPORT
--// ═══════════════════════════════════════════

do
    local Tab = Tabs.Teleport

    -- Player Transport Section
    Tab:AddParagraph({
        Title = "🚀 " .. T("playerTransport"),
        Content = ""
    })

    Tab:AddInput("TpTarget", {
        Title = T("targetName"),
        Description = T("targetNameDesc"),
        Default = "",
        Placeholder = "Player name...",
        Numeric = false,
        Finished = false,
        Callback = function(v) CFG.TpTarget = v end
    })

    Tab:AddButton({
        Title = T("tpToTarget"),
        Description = T("tpToTargetDesc"),
        Callback = function()
            local query = CFG.TpTarget:lower()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and (p.Name:lower():find(query) or p.DisplayName:lower():find(query)) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    HRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                    Fluent:Notify({
                        Title = T("teleport"),
                        Content = T("movedTo") .. " " .. p.DisplayName,
                        Duration = 3
                    })
                    return
                end
            end
            Fluent:Notify({
                Title = "Error",
                Content = T("notFound"),
                Duration = 3
            })
        end
    })

    Tab:AddButton({
        Title = T("randomPlayer"),
        Description = T("randomPlayerDesc"),
        Callback = function()
            local pool = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(pool, p)
                end
            end
            if #pool == 0 then
                Fluent:Notify({ Title = "Error", Content = T("noPlayers"), Duration = 3 })
                return
            end
            local t = pool[math.random(#pool)]
            HRP.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
            Fluent:Notify({
                Title = T("randomPlayer"),
                Content = T("movedTo") .. " " .. t.DisplayName,
                Duration = 3
            })
        end
    })

    Tab:AddButton({
        Title = T("tpSpawn"),
        Description = T("tpSpawnDesc"),
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

    Tab:AddButton({
        Title = T("tpForward"),
        Description = T("tpForwardDesc"),
        Callback = function()
            pcall(function() HRP.CFrame = HRP.CFrame + HRP.CFrame.LookVector * 100 end)
        end
    })

    -- Waypoints Section
    Tab:AddParagraph({
        Title = "📍 " .. T("waypoints"),
        Content = ""
    })

    Tab:AddButton({
        Title = T("savePos"),
        Description = T("savePosDesc"),
        Callback = function()
            CFG.SavedCF = HRP.CFrame
            Fluent:Notify({ Title = T("saved"), Content = T("posStored"), Duration = 2 })
        end
    })

    Tab:AddButton({
        Title = T("loadPos"),
        Description = T("loadPosDesc"),
        Callback = function()
            if CFG.SavedCF then
                HRP.CFrame = CFG.SavedCF
                Fluent:Notify({ Title = T("loaded"), Content = T("posRestored"), Duration = 2 })
            else
                Fluent:Notify({ Title = "Error", Content = T("nothingSaved"), Duration = 2 })
            end
        end
    })

    Tab:AddToggle("ClickTP", {
        Title = T("clickTp"),
        Description = T("clickTpDesc"),
        Default = false,
        Callback = function(v) CFG.ClickTP = v end
    })
end

--// ═══════════════════════════════════════════
--//  TAB: ESP
--// ═══════════════════════════════════════════

do
    local Tab = Tabs.ESP

    -- Rendering Section
    Tab:AddParagraph({
        Title = "👁️ " .. T("rendering"),
        Content = ""
    })

    Tab:AddToggle("ESP", {
        Title = T("enableEsp"),
        Description = T("enableEspDesc"),
        Default = false,
        Callback = function(v) CFG.ESP = v end
    })

    Tab:AddToggle("BoxESP", {
        Title = T("boundBox"),
        Description = T("boundBoxDesc"),
        Default = false,
        Callback = function(v) CFG.BoxESP = v end
    })

    Tab:AddToggle("NameESP", {
        Title = T("nameTags"),
        Description = T("nameTagsDesc"),
        Default = false,
        Callback = function(v) CFG.NameESP = v end
    })

    Tab:AddToggle("HealthESP", {
        Title = T("healthBars"),
        Description = T("healthBarsDesc"),
        Default = false,
        Callback = function(v) CFG.HealthESP = v end
    })

    Tab:AddToggle("DistESP", {
        Title = T("distTags"),
        Description = T("distTagsDesc"),
        Default = false,
        Callback = function(v) CFG.DistESP = v end
    })

    Tab:AddToggle("TracerESP", {
        Title = T("tracers"),
        Description = T("tracersDesc"),
        Default = false,
        Callback = function(v) CFG.TracerESP = v end
    })

    Tab:AddToggle("ChamsESP", {
        Title = T("chams"),
        Description = T("chamsDesc"),
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

    -- Filters Section
    Tab:AddParagraph({
        Title = "🔍 " .. T("filters"),
        Content = ""
    })

    Tab:AddToggle("TeamCheck", {
        Title = T("teamFilter"),
        Description = T("teamFilterDesc"),
        Default = false,
        Callback = function(v) CFG.TeamCheck = v end
    })
end

--// ═══════════════════════════════════════════
--//  TAB: ENVIRONMENT
--// ═══════════════════════════════════════════

do
    local Tab = Tabs.Environment

    -- Lighting Section
    Tab:AddParagraph({
        Title = "💡 " .. T("lighting"),
        Content = ""
    })

    Tab:AddToggle("Fullbright", {
        Title = T("fullbright"),
        Description = T("fullbrightDesc"),
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

    Tab:AddToggle("NoFog", {
        Title = T("noFog"),
        Description = T("noFogDesc"),
        Default = false,
        Callback = function(v)
            CFG.NoFog = v
            Lighting.FogEnd = v and 9999999 or 100000
        end
    })

    Tab:AddToggle("TimeLock", {
        Title = T("timeLock"),
        Description = T("timeLockDesc"),
        Default = false,
        Callback = function(v) CFG.CustomTime = v end
    })

    Tab:AddSlider("ClockTime", {
        Title = T("clockTime"),
        Description = T("clockTimeDesc"),
        Default = 14,
        Min = 0,
        Max = 24,
        Rounding = 1,
        Callback = function(v)
            CFG.TimeVal = v
            if CFG.CustomTime then Lighting.ClockTime = v end
        end
    })

    -- Cleanup Section
    Tab:AddParagraph({
        Title = "🧹 " .. T("cleanup"),
        Content = ""
    })

    Tab:AddButton({
        Title = T("removeEffects"),
        Description = T("removeEffectsDesc"),
        Callback = function()
            local n = 0
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then
                    e:Destroy()
                    n += 1
                end
            end
            Fluent:Notify({ Title = T("cleanup"), Content = n .. " " .. T("effectsRemoved"), Duration = 2 })
        end
    })

    Tab:AddButton({
        Title = T("removeParticles"),
        Description = T("removeParticlesDesc"),
        Callback = function()
            local n = 0
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
                    o:Destroy()
                    n += 1
                end
            end
            Fluent:Notify({ Title = T("cleanup"), Content = n .. " " .. T("particlesRemoved"), Duration = 2 })
        end
    })

    Tab:AddButton({
        Title = T("removeDecals"),
        Description = T("removeDecalsDesc"),
        Callback = function()
            local n = 0
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("Decal") or o:IsA("Texture") then
                    o:Destroy()
                    n += 1
                end
            end
            Fluent:Notify({ Title = T("cleanup"), Content = n .. " removed", Duration = 2 })
        end
    })

    Tab:AddButton({
        Title = T("removeSounds"),
        Description = T("removeSoundsDesc"),
        Callback = function()
            local n = 0
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("Sound") then
                    o:Stop()
                    o:Destroy()
                    n += 1
                end
            end
            Fluent:Notify({ Title = T("cleanup"), Content = n .. " removed", Duration = 2 })
        end
    })
end

--// ═══════════════════════════════════════════
--//  TAB: UTILITIES
--// ═══════════════════════════════════════════

do
    local Tab = Tabs.Utilities

    -- Protection Section
    Tab:AddParagraph({
        Title = "🔒 " .. T("protection"),
        Content = ""
    })

    Tab:AddToggle("AntiAFK", {
        Title = T("antiAfk"),
        Description = T("antiAfkDesc"),
        Default = false,
        Callback = function(v) CFG.AntiAFK = v end
    })

    Tab:AddToggle("AntiKick", {
        Title = T("antiKick"),
        Description = T("antiKickDesc"),
        Default = false,
        Callback = function(v) CFG.AntiKick = v end
    })

    -- Actions Section
    Tab:AddParagraph({
        Title = "⚡ " .. T("actions"),
        Content = ""
    })

    Tab:AddToggle("Spin", {
        Title = T("spin"),
        Description = T("spinDesc"),
        Default = false,
        Callback = function(v) CFG.Spin = v end
    })

    Tab:AddSlider("SpinSpeed", {
        Title = T("spinSpeed"),
        Description = T("spinSpeedDesc"),
        Default = 10,
        Min = 1,
        Max = 50,
        Rounding = 0,
        Callback = function(v) CFG.SpinSpeed = v end
    })

    Tab:AddButton({
        Title = T("spawnPlatform"),
        Description = T("spawnPlatformDesc"),
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

    Tab:AddButton({
        Title = T("forceSit"),
        Description = T("forceSitDesc"),
        Callback = function()
            pcall(function() Humanoid.Sit = true end)
        end
    })

    Tab:AddButton({
        Title = T("forceJump"),
        Description = T("forceJumpDesc"),
        Callback = function()
            pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
    })

    Tab:AddButton({
        Title = T("copyPos"),
        Description = T("copyPosDesc"),
        Callback = function()
            local pos = HRP.Position
            local txt = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            pcall(function() setclipboard(txt) end)
            Fluent:Notify({ Title = T("copied"), Content = txt, Duration = 3 })
        end
    })

    Tab:AddButton({
        Title = T("copyLink"),
        Description = T("copyLinkDesc"),
        Callback = function()
            local link = "https://www.roblox.com/games/" .. game.PlaceId
            pcall(function() setclipboard(link) end)
            Fluent:Notify({ Title = T("copied"), Content = link, Duration = 3 })
        end
    })

    -- Chat Section
    Tab:AddParagraph({
        Title = "💬 " .. T("chat"),
        Content = ""
    })

    Tab:AddInput("SpamMsg", {
        Title = T("spamMsg"),
        Description = T("spamMsgDesc"),
        Default = "",
        Placeholder = "Message...",
        Numeric = false,
        Finished = false,
        Callback = function(v) CFG.SpamMsg = v end
    })

    Tab:AddSlider("SpamDelay", {
        Title = T("spamInterval"),
        Description = T("spamIntervalDesc"),
        Default = 2,
        Min = 0.5,
        Max = 10,
        Rounding = 1,
        Callback = function(v) CFG.SpamDelay = v end
    })

    Tab:AddToggle("ChatSpam", {
        Title = T("chatSpam"),
        Description = T("chatSpamDesc"),
        Default = false,
        Callback = function(v) CFG.ChatSpam = v end
    })

    -- Server Section
    Tab:AddParagraph({
        Title = "🌐 " .. T("server"),
        Content = ""
    })

    Tab:AddButton({
        Title = T("rejoin"),
        Description = T("rejoinDesc"),
        Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    })

    Tab:AddButton({
        Title = T("serverHop"),
        Description = T("serverHopDesc"),
        Callback = function()
            task.spawn(function()
                local ok, data = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
                end)
                if not ok then
                    Fluent:Notify({ Title = "Error", Content = "Failed", Duration = 3 })
                    return
                end
                for _, sv in ipairs(data.data) do
                    if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
                        return
                    end
                end
                Fluent:Notify({ Title = "Error", Content = "No servers", Duration = 3 })
            end)
        end
    })

    Tab:AddButton({
        Title = T("serverInfo"),
        Description = T("serverInfoDesc"),
        Callback = function()
            Fluent:Notify({
                Title = T("serverInfo"),
                Content = string.format("Players: %d/%d\nPlace: %d\nPing: ~%dms",
                    #Players:GetPlayers(), Players.MaxPlayers, game.PlaceId,
                    math.floor(LocalPlayer:GetNetworkPing() * 1000)),
                Duration = 6
            })
        end
    })
end

--// ═══════════════════════════════════════════
--//  TAB: SETTINGS
--// ═══════════════════════════════════════════

do
    local Tab = Tabs.Settings

    -- Language Section
    Tab:AddParagraph({
        Title = "🌍 " .. T("language"),
        Content = ""
    })

    Tab:AddButton({
        Title = "🇬🇧 English",
        Description = "Switch to English (restart required)",
        Callback = function()
            Lang = "EN"
            Fluent:Notify({
                Title = "Language",
                Content = "English selected. Rejoin to apply fully.",
                Duration = 4
            })
        end
    })

    Tab:AddButton({
        Title = "🇷🇺 Русский",
        Description = "Переключить на русский (нужен рестарт)",
        Callback = function()
            Lang = "RU"
            Fluent:Notify({
                Title = "Язык",
                Content = "Русский выбран. Перезайдите для полного применения.",
                Duration = 4
            })
        end
    })

    -- Graphics Section
    Tab:AddParagraph({
        Title = "🖥️ " .. T("graphics"),
        Content = ""
    })

    Tab:AddToggle("AntiBlur", {
        Title = T("blurEnabled"),
        Description = T("blurEnabledDesc"),
        Default = false,
        Callback = function(v)
            CFG.AntiBlur = v
            if v then
                for _, obj in ipairs(Lighting:GetChildren()) do
                    if obj:IsA("BlurEffect") then obj:Destroy() end
                end
            end
            Fluent:Notify({
                Title = T("graphics"),
                Content = v and "Blur protection ON" or "Blur protection OFF",
                Duration = 2
            })
        end
    })

    Tab:AddButton({
        Title = T("removeBlur"),
        Description = T("removeBlurDesc"),
        Callback = function()
            local n = 0
            for _, obj in ipairs(Lighting:GetChildren()) do
                if obj:IsA("BlurEffect") then obj:Destroy(); n += 1 end
            end
            Fluent:Notify({ Title = T("removeBlur"), Content = n .. " blur removed", Duration = 2 })
        end
    })

    Tab:AddButton({
        Title = T("removeAllPost"),
        Description = T("removeAllPostDesc"),
        Callback = function()
            local n = 0
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("PostEffect") or e:IsA("Atmosphere") then e:Destroy(); n += 1 end
            end
            Fluent:Notify({ Title = T("cleanup"), Content = n .. " removed", Duration = 2 })
        end
    })

    Tab:AddButton({
        Title = T("lowGraphics"),
        Description = T("lowGraphicsDesc"),
        Callback = function()
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            Lighting.GlobalShadows = false
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("PostEffect") or e:IsA("Atmosphere") then e.Enabled = false end
            end
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled = false end
            end
            Fluent:Notify({ Title = T("graphics"), Content = "Low mode ON", Duration = 2 })
        end
    })

    -- Player Info Section
    Tab:AddParagraph({
        Title = "👤 " .. T("playerInfo"),
        Content = "Name: " .. LocalPlayer.Name .. "\nDisplay: " .. LocalPlayer.DisplayName .. "\nID: " .. LocalPlayer.UserId
    })

    Tab:AddButton({
        Title = T("copyId"),
        Description = T("copyIdDesc"),
        Callback = function()
            pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end)
            Fluent:Notify({ Title = T("copied"), Content = tostring(LocalPlayer.UserId), Duration = 2 })
        end
    })

    -- About Section
    Tab:AddParagraph({
        Title = "ℹ️ Eplisma v3.0",
        Content = "Developer: Frost\nTelegram: @Jokerfros\n\nRightControl to toggle menu\nFluent UI • 2 languages\nAuto Bomb Pass included"
    })

    -- Danger Zone Section
    Tab:AddParagraph({
        Title = "⚠️ " .. T("dangerZone"),
        Content = ""
    })

    Tab:AddButton({
        Title = T("destroy"),
        Description = T("destroyDesc"),
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
            Fluent:Destroy()
        end
    })

    -- Fluent Addons
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder("Eplisma")
    InterfaceManager:SetFolder("Eplisma")
    InterfaceManager:BuildInterfaceSection(Tab)
    SaveManager:BuildConfigSection(Tab)
end

--// ═══════════════════════════════════════════
--//  DRAWING: FOV CIRCLE
--// ═══════════════════════════════════════════

local FOV = Drawing.new("Circle")
FOV.Thickness = 1.5
FOV.NumSides = 64
FOV.Radius = CFG.AimFOV
FOV.Filled = false
FOV.Visible = false
FOV.ZIndex = 999
FOV.Transparency = 0.75
FOV.Color = Color3.fromRGB(130, 80, 220)
_G._FOV = FOV

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

    FOV.Visible = CFG.ShowFOV
    FOV.Radius = CFG.AimFOV
    FOV.Position = mp

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

    -- Anti-Blur protection
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
--//  SELECT DEFAULT TAB
--// ═══════════════════════════════════════════

Window:SelectTab(1)

--// ═══════════════════════════════════════════
--//  STARTUP NOTIFICATION
--// ═══════════════════════════════════════════

Fluent:Notify({
    Title = "Eplisma v3.0",
    Content = T("welcome") .. ", " .. LocalPlayer.DisplayName .. "\n" .. T("pressE") .. "\nby Frost | @Jokerfros",
    SubContent = "Fluent UI Edition",
    Duration = 6
})

print([[
╔══════════════════════════════════════╗
║         E P L I S M A  v3.0         ║
║     Developer: Frost                ║
║     Telegram: @Jokerfros            ║
║     UI: Fluent Library              ║
╠══════════════════════════════════════╣
║  Player: ]] .. LocalPlayer.Name .. [[

║  Place: ]] .. game.PlaceId .. [[

╚══════════════════════════════════════╝
]])
