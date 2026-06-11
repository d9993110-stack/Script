--[[
    ╔══════════════════════════════════════════╗
    ║           E P L I S M A                  ║
    ║       Professional Cheat Suite           ║
    ║                                          ║
    ║   Developer: Frost                       ║
    ║   Telegram: @Jokerfros                   ║
    ║   Version: 3.1 Mobile                    ║
    ╚══════════════════════════════════════════╝
]]

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

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

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
        character="Character", combat="Combat", teleport="Teleport", esp="ESP",
        environment="Environment", utilities="Utilities", settings="Settings",
        movement="Movement", flight="Flight", camera="Camera", survivability="Survivability",
        aimAssist="Aim Assist", melee="Melee", info="Info", bombPass="Bomb Pass",
        playerTransport="Player Transport", waypoints="Waypoints",
        rendering="Rendering", filters="Filters", lighting="Lighting", cleanup="Cleanup",
        protection="Protection", actions="Actions", chat="Chat", server="Server",
        theme="Theme", graphics="Graphics", window="Window", playerInfo="Player Info",
        about="About", dangerZone="Danger Zone", language="Language",
        walkspeed="WalkSpeed", walkspeedDesc="Movement speed",
        jumppower="JumpPower", jumppowerDesc="Jump height",
        gravity="Gravity", gravityDesc="World gravity (196.2)",
        infJump="Infinite Jump", infJumpDesc="Jump mid-air",
        autoJump="Auto Jump", autoJumpDesc="Jump when walking",
        bunnyHop="Bunny Hop", bunnyHopDesc="Jump on landing",
        noclip="Noclip", noclipDesc="Walk through walls",
        fly="Fly", flyDesc="Free flight (use joystick to move)",
        flySpeed="Fly Speed", flySpeedDesc="Flight velocity",
        fov="Field of View", fovDesc="Camera FOV",
        godMode="God Mode", godModeDesc="Max health always",
        noReset="No Reset", noResetDesc="Disable reset button",
        forceReset="Force Reset", forceResetDesc="Kill character",
        respawn="Respawn", respawnDesc="Force respawn",
        freeze="Freeze", freezeDesc="Stop movement",
        frozen="Frozen", unfrozen="Unfrozen",
        aimbot="Aimbot", aimbotDesc="Auto-aim (hold shoot)",
        fovRadius="FOV Radius", fovRadiusDesc="Detection radius",
        smoothing="Smoothing", smoothingDesc="Aim speed",
        showFov="Show FOV", showFovDesc="Render FOV circle",
        hitbox="Hitbox Expander", hitboxDesc="Enlarge hitboxes",
        hitboxScale="Hitbox Scale", hitboxScaleDesc="Hitbox size",
        killAura="Kill Aura", killAuraDesc="Auto-attack nearby",
        auraRange="Aura Range", auraRangeDesc="Detection distance",
        autoBomb="Auto Bomb Pass", autoBombDesc="Pass bomb to nearest player",
        bombKeywords="Bomb Keywords", bombKeywordsDesc="Tool names (comma separated)",
        nearestPlayer="Nearest Player", nearestPlayerDesc="Show closest player",
        targetName="Target Name", targetNameDesc="Player name",
        tpToTarget="TP to Target", tpToTargetDesc="Move to player",
        randomPlayer="Random Player", randomPlayerDesc="TP to random",
        tpSpawn="TP to Spawn", tpSpawnDesc="Return to spawn",
        tpForward="TP Forward 100", tpForwardDesc="Jump 100 studs",
        savePos="Save Position", savePosDesc="Store coords",
        loadPos="Load Position", loadPosDesc="Return to saved",
        clickTp="Click TP", clickTpDesc="Tap to teleport",
        enableEsp="Enable ESP", enableEspDesc="Master switch",
        boundBox="Box ESP", boundBoxDesc="Rectangles",
        nameTags="Name Tags", nameTagsDesc="Show names",
        healthBars="Health Bars", healthBarsDesc="HP indicators",
        distTags="Distance", distTagsDesc="Distance in studs",
        tracers="Tracers", tracersDesc="Lines to targets",
        chams="Chams", chamsDesc="Highlight through walls",
        teamFilter="Team Filter", teamFilterDesc="Exclude teammates",
        fullbright="Fullbright", fullbrightDesc="Remove shadows",
        noFog="No Fog", noFogDesc="Disable fog",
        timeLock="Time Lock", timeLockDesc="Lock time",
        clockTime="Clock Time", clockTimeDesc="Hour (0-24)",
        removeEffects="Remove Effects", removeEffectsDesc="All post effects",
        removeParticles="Remove Particles", removeParticlesDesc="Fire, smoke, etc",
        removeDecals="Remove Decals", removeDecalsDesc="Decals/textures",
        removeSounds="Remove Sounds", removeSoundsDesc="Kill sounds",
        antiAfk="Anti-AFK", antiAfkDesc="Prevent disconnect",
        antiKick="Anti-Kick", antiKickDesc="Block kicks",
        spin="Spin", spinDesc="Rotation",
        spinSpeed="Spin Speed", spinSpeedDesc="Speed",
        spawnPlatform="Platform", spawnPlatformDesc="Neon platform",
        forceSit="Sit", forceSitDesc="Sit now",
        forceJump="Jump", forceJumpDesc="Jump now",
        copyPos="Copy Position", copyPosDesc="Copy coords",
        copyLink="Copy Link", copyLinkDesc="Game link",
        spamMsg="Spam Message", spamMsgDesc="Text to repeat",
        spamInterval="Interval", spamIntervalDesc="Delay",
        chatSpam="Chat Spam", chatSpamDesc="Repeat in chat",
        rejoin="Rejoin", rejoinDesc="Reconnect",
        serverHop="Server Hop", serverHopDesc="Another server",
        serverInfo="Server Info", serverInfoDesc="Details",
        prevTheme="◀ Prev Theme", nextTheme="▶ Next Theme",
        showTheme="Current Theme",
        antiBlur="Anti-Blur", antiBlurDesc="Auto-remove blur effects",
        removeBlur="Remove Blur Now", removeBlurDesc="Delete all blur",
        removeAllPost="Remove ALL Effects", removeAllPostDesc="Strip everything",
        lowGraphics="Low Graphics", lowGraphicsDesc="FPS boost",
        destroy="Destroy Eplisma", destroyDesc="Remove completely",
        copied="Copied", saved="Saved", loaded="Loaded",
        welcome="Welcome", noPlayers="No players",
    },
    RU = {
        character="Персонаж", combat="Бой", teleport="Телепорт", esp="ESP",
        environment="Окружение", utilities="Утилиты", settings="Настройки",
        movement="Движение", flight="Полёт", camera="Камера", survivability="Выживание",
        aimAssist="Прицел", melee="Ближний бой", info="Инфо", bombPass="Бомба",
        playerTransport="К игрокам", waypoints="Точки",
        rendering="Отрисовка", filters="Фильтры", lighting="Свет", cleanup="Очистка",
        protection="Защита", actions="Действия", chat="Чат", server="Сервер",
        theme="Тема", graphics="Графика", window="Окно", playerInfo="Игрок",
        about="О программе", dangerZone="Опасно", language="Язык",
        walkspeed="Скорость", walkspeedDesc="Скорость ходьбы",
        jumppower="Прыжок", jumppowerDesc="Высота прыжка",
        gravity="Гравитация", gravityDesc="Гравитация мира",
        infJump="Бескон. прыжок", infJumpDesc="Прыжок в воздухе",
        autoJump="Авто-прыжок", autoJumpDesc="Прыгать автоматически",
        bunnyHop="Банни-хоп", bunnyHopDesc="Прыжок при приземлении",
        noclip="Ноклип", noclipDesc="Сквозь стены",
        fly="Полёт", flyDesc="Свободный полёт (джойстик для управления)",
        flySpeed="Скорость полёта", flySpeedDesc="Скорость",
        fov="Угол обзора", fovDesc="FOV камеры",
        godMode="Бессмертие", godModeDesc="Макс. здоровье",
        noReset="Без ресета", noResetDesc="Отключить ресет",
        forceReset="Убить себя", forceResetDesc="Мгновенная смерть",
        respawn="Респавн", respawnDesc="Принудительный респавн",
        freeze="Заморозить", freezeDesc="Остановить",
        frozen="Заморожен", unfrozen="Разморожен",
        aimbot="Аимбот", aimbotDesc="Автоприцел",
        fovRadius="Радиус FOV", fovRadiusDesc="Радиус",
        smoothing="Плавность", smoothingDesc="Скорость",
        showFov="Показать FOV", showFovDesc="Круг FOV",
        hitbox="Хитбокс", hitboxDesc="Увеличить хитбоксы",
        hitboxScale="Размер хитбокса", hitboxScaleDesc="Размер",
        killAura="Аура убийства", killAuraDesc="Авто-атака",
        auraRange="Радиус ауры", auraRangeDesc="Дистанция",
        autoBomb="Авто бомба", autoBombDesc="Передать бомбу ближнему",
        bombKeywords="Ключевые слова", bombKeywordsDesc="Названия (через запятую)",
        nearestPlayer="Ближайший", nearestPlayerDesc="Инфо о ближнем",
        targetName="Имя цели", targetNameDesc="Имя игрока",
        tpToTarget="ТП к цели", tpToTargetDesc="К игроку",
        randomPlayer="Случайный", randomPlayerDesc="ТП к случайному",
        tpSpawn="ТП на спавн", tpSpawnDesc="На спавн",
        tpForward="ТП вперёд 100", tpForwardDesc="100 стадов вперёд",
        savePos="Сохранить", savePosDesc="Запомнить",
        loadPos="Загрузить", loadPosDesc="Вернуться",
        clickTp="ТП по клику", clickTpDesc="Тап для ТП",
        enableEsp="Включить ESP", enableEspDesc="Главный",
        boundBox="Рамки", boundBoxDesc="Прямоугольники",
        nameTags="Имена", nameTagsDesc="Показать имена",
        healthBars="HP бары", healthBarsDesc="Здоровье",
        distTags="Дистанция", distTagsDesc="Расстояние",
        tracers="Линии", tracersDesc="К целям",
        chams="Хамс", chamsDesc="Подсветка",
        teamFilter="Фильтр команды", teamFilterDesc="Без союзников",
        fullbright="Яркий свет", fullbrightDesc="Без теней",
        noFog="Без тумана", noFogDesc="Убрать туман",
        timeLock="Блок времени", timeLockDesc="Зафиксировать",
        clockTime="Время", clockTimeDesc="Час (0-24)",
        removeEffects="Убрать эффекты", removeEffectsDesc="Все эффекты",
        removeParticles="Убрать частицы", removeParticlesDesc="Огонь, дым",
        removeDecals="Убрать декали", removeDecalsDesc="Декали/текстуры",
        removeSounds="Убрать звуки", removeSoundsDesc="Все звуки",
        antiAfk="Анти-АФК", antiAfkDesc="Защита от кика",
        antiKick="Анти-Кик", antiKickDesc="Блокировка кика",
        spin="Вращение", spinDesc="Крутиться",
        spinSpeed="Скорость", spinSpeedDesc="Скорость вращения",
        spawnPlatform="Платформа", spawnPlatformDesc="Неон платформа",
        forceSit="Сесть", forceSitDesc="Сесть сейчас",
        forceJump="Прыгнуть", forceJumpDesc="Прыжок сейчас",
        copyPos="Копировать позицию", copyPosDesc="Координаты",
        copyLink="Копировать ссылку", copyLinkDesc="Ссылка на игру",
        spamMsg="Сообщение", spamMsgDesc="Текст",
        spamInterval="Интервал", spamIntervalDesc="Задержка",
        chatSpam="Спам в чат", chatSpamDesc="Повтор",
        rejoin="Реджойн", rejoinDesc="Переподключиться",
        serverHop="Сменить сервер", serverHopDesc="Другой сервер",
        serverInfo="Инфо сервера", serverInfoDesc="Детали",
        prevTheme="◀ Пред. тема", nextTheme="▶ След. тема",
        showTheme="Текущая тема",
        antiBlur="Анти-Блюр", antiBlurDesc="Авто-удаление блюра",
        removeBlur="Убрать блюр", removeBlurDesc="Удалить весь блюр",
        removeAllPost="Убрать ВСЁ", removeAllPostDesc="Все эффекты",
        lowGraphics="Низкая графика", lowGraphicsDesc="Для FPS",
        destroy="Удалить Eplisma", destroyDesc="Полностью удалить",
        copied="Скопировано", saved="Сохранено", loaded="Загружено",
        welcome="Добро пожаловать", noPlayers="Нет игроков",
    },
}

local function T(key)
    return (L[Lang] and L[Lang][key]) or (L.EN[key]) or key
end

--// ═══════════════════════════════════════════
--//  КАСТОМНА КНОПКА ЗГОРТАННЯ + МІНІБАР
--// ═══════════════════════════════════════════

local OverlayGui = Instance.new("ScreenGui")
OverlayGui.Name = "EplismaOverlay"
OverlayGui.ResetOnSpawn = false
OverlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OverlayGui.DisplayOrder = 999999
pcall(function() OverlayGui.Parent = CoreGui end)
if not OverlayGui.Parent then OverlayGui.Parent = LocalPlayer.PlayerGui end

-- Мінімізований бар
local MiniBar = Instance.new("TextButton")
MiniBar.Name = "MiniBar"
MiniBar.Size = UDim2.fromOffset(130, 32)
MiniBar.Position = UDim2.new(0.5, -65, 0, 8)
MiniBar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MiniBar.BackgroundTransparency = 0.05
MiniBar.BorderSizePixel = 0
MiniBar.Text = "  Eplisma ▼"
MiniBar.TextColor3 = Color3.fromRGB(160, 120, 240)
MiniBar.TextSize = 14
MiniBar.Font = Enum.Font.GothamBold
MiniBar.AutoButtonColor = false
MiniBar.Visible = false
MiniBar.ZIndex = 999999
MiniBar.Parent = OverlayGui

Instance.new("UICorner", MiniBar).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke")
mStroke.Color = Color3.fromRGB(100, 60, 180)
mStroke.Thickness = 1.2
mStroke.Parent = MiniBar

-- Drag мінібар
do
    local dragging, dragStart, startPos, hasMoved = false, nil, nil, false
    MiniBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = MiniBar.Position
        end
    end)
    MiniBar.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            if d.Magnitude > 5 then hasMoved = true end
            MiniBar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

--// ═══════════════════════════════════════════
--//  LIBRARY
--// ═══════════════════════════════════════════

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"
))()

local Window = Library:CreateWindow({
    Title = "Eplisma",
    Theme = "Dark",
    Size = UDim2.fromOffset(560, 360),
    Transparency = 0,
    Blurring = false,
    MinimizeKeybind = Enum.KeyCode.RightControl,
})

-- Прибираємо блюр
task.delay(0.3, function()
    pcall(function() for _, o in ipairs(Lighting:GetChildren()) do if o:IsA("BlurEffect") then o:Destroy() end end end)
end)

local Themes = {
    Dark = {Primary=Color3.fromRGB(18,18,22),Secondary=Color3.fromRGB(22,22,28),Component=Color3.fromRGB(28,28,35),Interactables=Color3.fromRGB(35,35,44),Tab=Color3.fromRGB(180,180,200),Title=Color3.fromRGB(235,235,245),Description=Color3.fromRGB(160,160,180),Shadow=Color3.fromRGB(0,0,0),Outline=Color3.fromRGB(35,35,45),Icon=Color3.fromRGB(200,200,220)},
    Void = {Primary=Color3.fromRGB(8,8,10),Secondary=Color3.fromRGB(12,12,16),Component=Color3.fromRGB(18,18,22),Interactables=Color3.fromRGB(24,24,30),Tab=Color3.fromRGB(170,170,190),Title=Color3.fromRGB(230,230,240),Description=Color3.fromRGB(140,140,160),Shadow=Color3.fromRGB(0,0,0),Outline=Color3.fromRGB(25,25,32),Icon=Color3.fromRGB(180,180,200)},
    Amethyst = {Primary=Color3.fromRGB(16,12,24),Secondary=Color3.fromRGB(22,16,34),Component=Color3.fromRGB(30,22,46),Interactables=Color3.fromRGB(42,32,62),Tab=Color3.fromRGB(170,150,210),Title=Color3.fromRGB(220,200,255),Description=Color3.fromRGB(150,130,190),Shadow=Color3.fromRGB(5,2,12),Outline=Color3.fromRGB(50,38,72),Icon=Color3.fromRGB(170,140,230)},
    Midnight = {Primary=Color3.fromRGB(6,10,22),Secondary=Color3.fromRGB(10,16,32),Component=Color3.fromRGB(16,22,44),Interactables=Color3.fromRGB(22,32,58),Tab=Color3.fromRGB(130,160,220),Title=Color3.fromRGB(175,200,250),Description=Color3.fromRGB(120,145,200),Shadow=Color3.fromRGB(0,2,12),Outline=Color3.fromRGB(30,42,72),Icon=Color3.fromRGB(140,170,240)},
    Crimson = {Primary=Color3.fromRGB(22,10,10),Secondary=Color3.fromRGB(32,14,14),Component=Color3.fromRGB(44,20,20),Interactables=Color3.fromRGB(60,28,28),Tab=Color3.fromRGB(220,150,150),Title=Color3.fromRGB(255,200,200),Description=Color3.fromRGB(200,140,140),Shadow=Color3.fromRGB(12,0,0),Outline=Color3.fromRGB(72,32,32),Icon=Color3.fromRGB(240,150,150)},
    Emerald = {Primary=Color3.fromRGB(10,20,14),Secondary=Color3.fromRGB(14,28,18),Component=Color3.fromRGB(20,38,26),Interactables=Color3.fromRGB(28,52,36),Tab=Color3.fromRGB(140,210,160),Title=Color3.fromRGB(200,255,210),Description=Color3.fromRGB(130,190,145),Shadow=Color3.fromRGB(2,10,4),Outline=Color3.fromRGB(32,62,40),Icon=Color3.fromRGB(140,230,160)},
    Ocean = {Primary=Color3.fromRGB(8,18,24),Secondary=Color3.fromRGB(12,24,34),Component=Color3.fromRGB(18,34,48),Interactables=Color3.fromRGB(24,48,65),Tab=Color3.fromRGB(120,190,220),Title=Color3.fromRGB(180,230,255),Description=Color3.fromRGB(110,170,200),Shadow=Color3.fromRGB(2,8,14),Outline=Color3.fromRGB(28,55,75),Icon=Color3.fromRGB(130,200,240)},
}
Window:SetTheme(Themes.Dark)

--// ═══════════════════════════════════════════
--//  ВСТАВКА КНОПКИ [-] В МЕНЮ БІБЛІОТЕКИ
--// ═══════════════════════════════════════════

local _libMainFrame = nil
local MenuOpen = true

local function FindLibraryMainFrame()
    local screens = {CoreGui, LocalPlayer.PlayerGui}
    for _, parent in ipairs(screens) do
        for _, gui in ipairs(parent:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "EplismaOverlay" then
                -- Шукаємо глибоко
                for _, child in ipairs(gui:GetDescendants()) do
                    if child:IsA("Frame") and child.Name == "Main" then
                        return child, gui
                    end
                end
                -- Або перший великий фрейм
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("Frame") and child.AbsoluteSize.X > 200 and child.AbsoluteSize.Y > 150 then
                        return child, gui
                    end
                end
            end
        end
    end
    return nil, nil
end

local function InsertMinimizeButton()
    local mainFrame, mainGui = FindLibraryMainFrame()
    if not mainFrame then return false end

    _libMainFrame = mainFrame

    -- Перевіряємо чи вже є кнопка
    if mainFrame:FindFirstChild("EplismaMinBtn") then return true end

    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "EplismaMinBtn"
    MinBtn.Size = UDim2.fromOffset(30, 22)
    MinBtn.Position = UDim2.new(1, -38, 0, 5)
    MinBtn.BackgroundColor3 = Color3.fromRGB(45, 38, 60)
    MinBtn.BackgroundTransparency = 0
    MinBtn.BorderSizePixel = 0
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.fromRGB(180, 140, 255)
    MinBtn.TextSize = 18
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.ZIndex = mainFrame.ZIndex + 100
    MinBtn.Parent = mainFrame

    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(110, 75, 190)
    btnStroke.Thickness = 1
    btnStroke.Parent = MinBtn

    -- Hover
    MinBtn.MouseEnter:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 50, 80)}):Play()
    end)
    MinBtn.MouseLeave:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 38, 60)}):Play()
    end)

    -- Згорнути
    MinBtn.MouseButton1Click:Connect(function()
        MenuOpen = false
        mainFrame.Visible = false
        MiniBar.Visible = true
    end)

    -- Розгорнути через мінібар
    MiniBar.MouseButton1Click:Connect(function()
        MenuOpen = true
        MiniBar.Visible = false
        mainFrame.Visible = true
    end)

    return true
end

-- Пробуємо вставити кнопку кілька разів
task.spawn(function()
    for i = 1, 30 do
        if InsertMinimizeButton() then
            break
        end
        task.wait(0.5)
    end
end)

--// ═══════════════════════════════════════════
--//  TAB SECTIONS
--// ═══════════════════════════════════════════

Window:AddTabSection({ Name = "Modules", Order = 1 })
Window:AddTabSection({ Name = "Visuals", Order = 2 })
Window:AddTabSection({ Name = "Settings", Order = 3 })

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
    CurrentTheme = "Dark",
    AntiKick = false, NoReset = false,
    AntiBlur = false,
    AutoBomb = false,
    BombKeywords = "bomb,бомба,tnt,dynamite,explosive,бомб",
}

--// ═══════════════════════════════════════════
--//  TAB: CHARACTER
--// ═══════════════════════════════════════════

local TabChar = Window:AddTab({ Title = T("character"), Section = "Modules", Icon = "rbxassetid://11963373994" })

Window:AddSection({ Name = T("movement"), Tab = TabChar })

Window:AddSlider({ Title = T("walkspeed"), Description = T("walkspeedDesc"), Tab = TabChar, MaxValue = 500, AllowDecimals = false,
    Callback = function(v) CFG.Speed = v; pcall(function() Humanoid.WalkSpeed = v end) end })

Window:AddSlider({ Title = T("jumppower"), Description = T("jumppowerDesc"), Tab = TabChar, MaxValue = 500, AllowDecimals = false,
    Callback = function(v) CFG.JumpPower = v; pcall(function() Humanoid.UseJumpPower=true; Humanoid.JumpPower=v end) end })

Window:AddSlider({ Title = T("gravity"), Description = T("gravityDesc"), Tab = TabChar, MaxValue = 500, AllowDecimals = true, DecimalAmount = 1,
    Callback = function(v) CFG.Gravity = v; Workspace.Gravity = v end })

Window:AddToggle({ Title = T("infJump"), Description = T("infJumpDesc"), Default = false, Tab = TabChar, Callback = function(v) CFG.InfJump = v end })
Window:AddToggle({ Title = T("autoJump"), Description = T("autoJumpDesc"), Default = false, Tab = TabChar, Callback = function(v) CFG.AutoJump = v; pcall(function() Humanoid.AutoJumpEnabled = v end) end })
Window:AddToggle({ Title = T("bunnyHop"), Description = T("bunnyHopDesc"), Default = false, Tab = TabChar, Callback = function(v) CFG.BunnyHop = v end })
Window:AddToggle({ Title = T("noclip"), Description = T("noclipDesc"), Default = false, Tab = TabChar, Callback = function(v) CFG.Noclip = v end })

Window:AddSection({ Name = T("flight"), Tab = TabChar })

Window:AddToggle({ Title = T("fly"), Description = T("flyDesc"), Default = false, Tab = TabChar,
    Callback = function(v)
        CFG.Fly = v
        if not v then
            pcall(function()
                if HRP:FindFirstChild("_FlyBV") then HRP._FlyBV:Destroy() end
                if HRP:FindFirstChild("_FlyBG") then HRP._FlyBG:Destroy() end
            end)
        end
    end })

Window:AddSlider({ Title = T("flySpeed"), Description = T("flySpeedDesc"), Tab = TabChar, MaxValue = 300, AllowDecimals = false,
    Callback = function(v) CFG.FlySpeed = v end })

Window:AddSection({ Name = T("camera"), Tab = TabChar })

Window:AddSlider({ Title = T("fov"), Description = T("fovDesc"), Tab = TabChar, MaxValue = 120, AllowDecimals = false,
    Callback = function(v) CFG.FOV = v; Camera.FieldOfView = v end })

Window:AddSection({ Name = T("survivability"), Tab = TabChar })

Window:AddToggle({ Title = T("godMode"), Description = T("godModeDesc"), Default = false, Tab = TabChar, Callback = function(v) CFG.GodMode = v end })
Window:AddToggle({ Title = T("noReset"), Description = T("noResetDesc"), Default = false, Tab = TabChar,
    Callback = function(v) CFG.NoReset = v; pcall(function() StarterGui:SetCore("ResetButtonCallback", not v) end) end })

Window:AddButton({ Title = T("forceReset"), Description = T("forceResetDesc"), Tab = TabChar, Callback = function() pcall(function() Humanoid.Health = 0 end) end })
Window:AddButton({ Title = T("respawn"), Description = T("respawnDesc"), Tab = TabChar, Callback = function() pcall(function() LocalPlayer:LoadCharacter() end) end })
Window:AddButton({ Title = T("freeze"), Description = T("freezeDesc"), Tab = TabChar,
    Callback = function() pcall(function() HRP.Anchored = not HRP.Anchored; Window:Notify({Title=T("freeze"), Description=HRP.Anchored and T("frozen") or T("unfrozen"), Duration=2}) end) end })

--// ═══════════════════════════════════════════
--//  TAB: COMBAT
--// ═══════════════════════════════════════════

local TabCombat = Window:AddTab({ Title = T("combat"), Section = "Modules", Icon = "rbxassetid://11293977610" })

Window:AddSection({ Name = T("aimAssist"), Tab = TabCombat })

Window:AddToggle({ Title = T("aimbot"), Description = T("aimbotDesc"), Default = false, Tab = TabCombat, Callback = function(v) CFG.Aimbot = v end })
Window:AddSlider({ Title = T("fovRadius"), Description = T("fovRadiusDesc"), Tab = TabCombat, MaxValue = 900, AllowDecimals = false, Callback = function(v) CFG.AimFOV = v end })
Window:AddSlider({ Title = T("smoothing"), Description = T("smoothingDesc"), Tab = TabCombat, MaxValue = 50, AllowDecimals = true, DecimalAmount = 1, Callback = function(v) CFG.AimSmooth = v end })
Window:AddToggle({ Title = T("showFov"), Description = T("showFovDesc"), Default = false, Tab = TabCombat, Callback = function(v) CFG.ShowFOV = v end })

Window:AddSection({ Name = T("melee"), Tab = TabCombat })

Window:AddToggle({ Title = T("hitbox"), Description = T("hitboxDesc"), Default = false, Tab = TabCombat,
    Callback = function(v) CFG.HitboxExp = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("HumanoidRootPart")
                if h then h.Size = v and Vector3.new(CFG.HitboxSize,CFG.HitboxSize,CFG.HitboxSize) or Vector3.new(2,2,1); h.Transparency = v and 0.5 or 1 end
            end
        end
    end })

Window:AddSlider({ Title = T("hitboxScale"), Description = T("hitboxScaleDesc"), Tab = TabCombat, MaxValue = 30, AllowDecimals = false, Callback = function(v) CFG.HitboxSize = v end })
Window:AddToggle({ Title = T("killAura"), Description = T("killAuraDesc"), Default = false, Tab = TabCombat, Callback = function(v) CFG.KillAura = v end })
Window:AddSlider({ Title = T("auraRange"), Description = T("auraRangeDesc"), Tab = TabCombat, MaxValue = 60, AllowDecimals = false, Callback = function(v) CFG.AuraRange = v end })

Window:AddSection({ Name = T("bombPass"), Tab = TabCombat })

Window:AddToggle({ Title = T("autoBomb"), Description = T("autoBombDesc"), Default = false, Tab = TabCombat, Callback = function(v) CFG.AutoBomb = v end })
Window:AddInput({ Title = T("bombKeywords"), Description = T("bombKeywordsDesc"), Tab = TabCombat, Callback = function(t) CFG.BombKeywords = t end })

Window:AddSection({ Name = T("info"), Tab = TabCombat })

Window:AddButton({ Title = T("nearestPlayer"), Description = T("nearestPlayerDesc"), Tab = TabCombat,
    Callback = function()
        local closest, dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; closest = p end
            end
        end
        if closest then Window:Notify({Title=T("nearestPlayer"), Description=closest.DisplayName.." — "..math.floor(dist).."m", Duration=4})
        else Window:Notify({Title="—", Description=T("noPlayers"), Duration=3}) end
    end })

--// ═══════════════════════════════════════════
--//  TAB: TELEPORT
--// ═══════════════════════════════════════════

local TabTP = Window:AddTab({ Title = T("teleport"), Section = "Modules", Icon = "rbxassetid://11963373994" })

Window:AddSection({ Name = T("playerTransport"), Tab = TabTP })

Window:AddInput({ Title = T("targetName"), Description = T("targetNameDesc"), Tab = TabTP, Callback = function(t) CFG.TpTarget = t end })

Window:AddButton({ Title = T("tpToTarget"), Description = T("tpToTargetDesc"), Tab = TabTP,
    Callback = function()
        local q = CFG.TpTarget:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and (p.Name:lower():find(q) or p.DisplayName:lower():find(q)) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                HRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,4)
                Window:Notify({Title=T("teleport"), Description=p.DisplayName, Duration=3}); return
            end
        end
        Window:Notify({Title="—", Description=T("noPlayers"), Duration=3})
    end })

Window:AddButton({ Title = T("randomPlayer"), Description = T("randomPlayerDesc"), Tab = TabTP,
    Callback = function()
        local pool = {}
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(pool, p) end end
        if #pool == 0 then Window:Notify({Title="—", Description=T("noPlayers"), Duration=3}); return end
        local t = pool[math.random(#pool)]; HRP.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,4)
        Window:Notify({Title=T("randomPlayer"), Description=t.DisplayName, Duration=3})
    end })

Window:AddButton({ Title = T("tpSpawn"), Description = T("tpSpawnDesc"), Tab = TabTP,
    Callback = function() pcall(function() local sp = Workspace:FindFirstChildOfClass("SpawnLocation"); if sp then HRP.CFrame = sp.CFrame+Vector3.new(0,5,0) else HRP.CFrame = CFrame.new(0,50,0) end end) end })

Window:AddButton({ Title = T("tpForward"), Description = T("tpForwardDesc"), Tab = TabTP,
    Callback = function() pcall(function() HRP.CFrame = HRP.CFrame + HRP.CFrame.LookVector * 100 end) end })

Window:AddSection({ Name = T("waypoints"), Tab = TabTP })

Window:AddButton({ Title = T("savePos"), Description = T("savePosDesc"), Tab = TabTP,
    Callback = function() CFG.SavedCF = HRP.CFrame; Window:Notify({Title=T("saved"), Description="OK", Duration=2}) end })

Window:AddButton({ Title = T("loadPos"), Description = T("loadPosDesc"), Tab = TabTP,
    Callback = function() if CFG.SavedCF then HRP.CFrame = CFG.SavedCF; Window:Notify({Title=T("loaded"), Description="OK", Duration=2}) end end })

Window:AddToggle({ Title = T("clickTp"), Description = T("clickTpDesc"), Default = false, Tab = TabTP, Callback = function(v) CFG.ClickTP = v end })

--// ═══════════════════════════════════════════
--//  TAB: ESP
--// ═══════════════════════════════════════════

local TabESP = Window:AddTab({ Title = T("esp"), Section = "Visuals", Icon = "rbxassetid://11293977610" })

Window:AddSection({ Name = T("rendering"), Tab = TabESP })

Window:AddToggle({ Title = T("enableEsp"), Description = T("enableEspDesc"), Default = false, Tab = TabESP, Callback = function(v) CFG.ESP = v end })
Window:AddToggle({ Title = T("boundBox"), Description = T("boundBoxDesc"), Default = false, Tab = TabESP, Callback = function(v) CFG.BoxESP = v end })
Window:AddToggle({ Title = T("nameTags"), Description = T("nameTagsDesc"), Default = false, Tab = TabESP, Callback = function(v) CFG.NameESP = v end })
Window:AddToggle({ Title = T("healthBars"), Description = T("healthBarsDesc"), Default = false, Tab = TabESP, Callback = function(v) CFG.HealthESP = v end })
Window:AddToggle({ Title = T("distTags"), Description = T("distTagsDesc"), Default = false, Tab = TabESP, Callback = function(v) CFG.DistESP = v end })
Window:AddToggle({ Title = T("tracers"), Description = T("tracersDesc"), Default = false, Tab = TabESP, Callback = function(v) CFG.TracerESP = v end })

Window:AddToggle({ Title = T("chams"), Description = T("chamsDesc"), Default = false, Tab = TabESP,
    Callback = function(v) CFG.ChamsESP = v
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local ex = p.Character:FindFirstChild("_Highlight")
                if v and not ex then
                    local h = Instance.new("Highlight"); h.Name="_Highlight"; h.FillColor=Color3.fromRGB(130,80,220); h.FillTransparency=0.4; h.OutlineColor=Color3.fromRGB(255,255,255); h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=p.Character
                elseif not v and ex then ex:Destroy() end
            end
        end
    end })

Window:AddSection({ Name = T("filters"), Tab = TabESP })
Window:AddToggle({ Title = T("teamFilter"), Description = T("teamFilterDesc"), Default = false, Tab = TabESP, Callback = function(v) CFG.TeamCheck = v end })

--// ═══════════════════════════════════════════
--//  TAB: ENVIRONMENT
--// ═══════════════════════════════════════════

local TabEnv = Window:AddTab({ Title = T("environment"), Section = "Visuals", Icon = "rbxassetid://11963373994" })

Window:AddSection({ Name = T("lighting"), Tab = TabEnv })

Window:AddToggle({ Title = T("fullbright"), Description = T("fullbrightDesc"), Default = false, Tab = TabEnv,
    Callback = function(v) CFG.Fullbright = v
        if v then Lighting.Brightness=2; Lighting.GlobalShadows=false; Lighting.OutdoorAmbient=Color3.fromRGB(200,200,200); Lighting.Ambient=Color3.fromRGB(200,200,200)
        else Lighting.Brightness=1; Lighting.GlobalShadows=true; Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128); Lighting.Ambient=Color3.fromRGB(0,0,0) end
    end })

Window:AddToggle({ Title = T("noFog"), Description = T("noFogDesc"), Default = false, Tab = TabEnv,
    Callback = function(v) CFG.NoFog = v; Lighting.FogEnd = v and 9999999 or 100000 end })

Window:AddToggle({ Title = T("timeLock"), Description = T("timeLockDesc"), Default = false, Tab = TabEnv, Callback = function(v) CFG.CustomTime = v end })

Window:AddSlider({ Title = T("clockTime"), Description = T("clockTimeDesc"), Tab = TabEnv, MaxValue = 24, AllowDecimals = true, DecimalAmount = 1,
    Callback = function(v) CFG.TimeVal = v; if CFG.CustomTime then Lighting.ClockTime = v end end })

Window:AddSection({ Name = T("cleanup"), Tab = TabEnv })

Window:AddButton({ Title = T("removeEffects"), Description = T("removeEffectsDesc"), Tab = TabEnv,
    Callback = function() local n=0; for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then e:Destroy(); n+=1 end end; Window:Notify({Title=T("cleanup"), Description=n.." removed", Duration=2}) end })

Window:AddButton({ Title = T("removeParticles"), Description = T("removeParticlesDesc"), Tab = TabEnv,
    Callback = function() local n=0; for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then o:Destroy(); n+=1 end end; Window:Notify({Title=T("cleanup"), Description=n.." removed", Duration=2}) end })

Window:AddButton({ Title = T("removeDecals"), Description = T("removeDecalsDesc"), Tab = TabEnv,
    Callback = function() local n=0; for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("Decal") or o:IsA("Texture") then o:Destroy(); n+=1 end end; Window:Notify({Title=T("cleanup"), Description=n.." removed", Duration=2}) end })

Window:AddButton({ Title = T("removeSounds"), Description = T("removeSoundsDesc"), Tab = TabEnv,
    Callback = function() local n=0; for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("Sound") then o:Stop(); o:Destroy(); n+=1 end end; Window:Notify({Title=T("cleanup"), Description=n.." removed", Duration=2}) end })

--// ═══════════════════════════════════════════
--//  TAB: UTILITIES
--// ═══════════════════════════════════════════

local TabUtil = Window:AddTab({ Title = T("utilities"), Section = "Modules", Icon = "rbxassetid://11963373994" })

Window:AddSection({ Name = T("protection"), Tab = TabUtil })
Window:AddToggle({ Title = T("antiAfk"), Description = T("antiAfkDesc"), Default = false, Tab = TabUtil, Callback = function(v) CFG.AntiAFK = v end })
Window:AddToggle({ Title = T("antiKick"), Description = T("antiKickDesc"), Default = false, Tab = TabUtil, Callback = function(v) CFG.AntiKick = v end })

Window:AddSection({ Name = T("actions"), Tab = TabUtil })
Window:AddToggle({ Title = T("spin"), Description = T("spinDesc"), Default = false, Tab = TabUtil, Callback = function(v) CFG.Spin = v end })
Window:AddSlider({ Title = T("spinSpeed"), Description = T("spinSpeedDesc"), Tab = TabUtil, MaxValue = 50, AllowDecimals = false, Callback = function(v) CFG.SpinSpeed = v end })
Window:AddButton({ Title = T("spawnPlatform"), Description = T("spawnPlatformDesc"), Tab = TabUtil,
    Callback = function() local p=Instance.new("Part"); p.Size=Vector3.new(20,1,20); p.CFrame=HRP.CFrame*CFrame.new(0,-4,0); p.Anchored=true; p.BrickColor=BrickColor.new("Bright violet"); p.Material=Enum.Material.Neon; p.Transparency=0.3; p.Parent=Workspace end })

Window:AddButton({ Title = T("forceSit"), Description = T("forceSitDesc"), Tab = TabUtil, Callback = function() pcall(function() Humanoid.Sit=true end) end })
Window:AddButton({ Title = T("forceJump"), Description = T("forceJumpDesc"), Tab = TabUtil, Callback = function() pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end })
Window:AddButton({ Title = T("copyPos"), Description = T("copyPosDesc"), Tab = TabUtil,
    Callback = function() local p=HRP.Position; local t=string.format("%.1f, %.1f, %.1f",p.X,p.Y,p.Z); pcall(function() setclipboard(t) end); Window:Notify({Title=T("copied"),Description=t,Duration=3}) end })

Window:AddSection({ Name = T("chat"), Tab = TabUtil })
Window:AddInput({ Title = T("spamMsg"), Description = T("spamMsgDesc"), Tab = TabUtil, Callback = function(t) CFG.SpamMsg = t end })
Window:AddSlider({ Title = T("spamInterval"), Description = T("spamIntervalDesc"), Tab = TabUtil, MaxValue = 10, AllowDecimals = true, DecimalAmount = 1, Callback = function(v) CFG.SpamDelay = v end })
Window:AddToggle({ Title = T("chatSpam"), Description = T("chatSpamDesc"), Default = false, Tab = TabUtil, Callback = function(v) CFG.ChatSpam = v end })

Window:AddSection({ Name = T("server"), Tab = TabUtil })
Window:AddButton({ Title = T("rejoin"), Description = T("rejoinDesc"), Tab = TabUtil, Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })

Window:AddButton({ Title = T("serverHop"), Description = T("serverHopDesc"), Tab = TabUtil,
    Callback = function() task.spawn(function()
        local ok,data = pcall(function() return HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))) end)
        if ok then for _,sv in ipairs(data.data) do if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer); return end end end
    end) end })

Window:AddButton({ Title = T("serverInfo"), Description = T("serverInfoDesc"), Tab = TabUtil,
    Callback = function() Window:Notify({Title=T("serverInfo"), Description=string.format("Players: %d/%d\nPlace: %d\nPing: ~%dms",#Players:GetPlayers(),Players.MaxPlayers,game.PlaceId,math.floor(LocalPlayer:GetNetworkPing()*1000)), Duration=6}) end })

--// ═══════════════════════════════════════════
--//  TAB: SETTINGS
--// ═══════════════════════════════════════════

local TabConfig = Window:AddTab({ Title = T("settings"), Section = "Settings", Icon = "rbxassetid://11293977610" })

Window:AddSection({ Name = T("language"), Tab = TabConfig })

Window:AddButton({ Title = "🇬🇧 English", Description = "Switch to English", Tab = TabConfig,
    Callback = function() Lang = "EN"; Window:Notify({Title="Language", Description="English. Rejoin for full apply.", Duration=3}) end })

Window:AddButton({ Title = "🇷🇺 Русский", Description = "Переключить на русский", Tab = TabConfig,
    Callback = function() Lang = "RU"; Window:Notify({Title="Язык", Description="Русский. Перезайдите.", Duration=3}) end })

Window:AddSection({ Name = T("theme"), Tab = TabConfig })

local themeNames = {"Dark","Void","Amethyst","Midnight","Crimson","Emerald","Ocean"}
local currentThemeIndex = 1

Window:AddButton({ Title = T("prevTheme"), Description = "", Tab = TabConfig,
    Callback = function() currentThemeIndex = currentThemeIndex-1; if currentThemeIndex<1 then currentThemeIndex=#themeNames end; local n=themeNames[currentThemeIndex]; CFG.CurrentTheme=n; Window:SetTheme(Themes[n]); Window:Notify({Title=T("theme"),Description=n,Duration=2}) end })

Window:AddButton({ Title = T("nextTheme"), Description = "", Tab = TabConfig,
    Callback = function() currentThemeIndex = currentThemeIndex+1; if currentThemeIndex>#themeNames then currentThemeIndex=1 end; local n=themeNames[currentThemeIndex]; CFG.CurrentTheme=n; Window:SetTheme(Themes[n]); Window:Notify({Title=T("theme"),Description=n,Duration=2}) end })

Window:AddButton({ Title = T("showTheme"), Description = "", Tab = TabConfig,
    Callback = function() Window:Notify({Title=T("theme"), Description=CFG.CurrentTheme, Duration=3}) end })

Window:AddSection({ Name = T("graphics"), Tab = TabConfig })

Window:AddToggle({ Title = T("antiBlur"), Description = T("antiBlurDesc"), Default = false, Tab = TabConfig,
    Callback = function(v) CFG.AntiBlur = v
        if v then for _,o in ipairs(Lighting:GetChildren()) do if o:IsA("BlurEffect") then o:Destroy() end end end
        Window:Notify({Title=T("graphics"), Description=v and "Anti-Blur ON" or "Anti-Blur OFF", Duration=2})
    end })

Window:AddButton({ Title = T("removeBlur"), Description = T("removeBlurDesc"), Tab = TabConfig,
    Callback = function() local n=0; for _,o in ipairs(Lighting:GetChildren()) do if o:IsA("BlurEffect") then o:Destroy(); n+=1 end end; Window:Notify({Title=T("removeBlur"), Description=n.." removed", Duration=2}) end })

Window:AddButton({ Title = T("removeAllPost"), Description = T("removeAllPostDesc"), Tab = TabConfig,
    Callback = function() local n=0; for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("PostEffect") or e:IsA("Atmosphere") then e:Destroy(); n+=1 end end; Window:Notify({Title=T("cleanup"), Description=n.." removed", Duration=2}) end })

Window:AddButton({ Title = T("lowGraphics"), Description = T("lowGraphicsDesc"), Tab = TabConfig,
    Callback = function()
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        Lighting.GlobalShadows = false
        for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("PostEffect") or e:IsA("Atmosphere") then e.Enabled=false end end
        for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled=false end end
        Window:Notify({Title=T("graphics"), Description="Low mode ON", Duration=2})
    end })

Window:AddSection({ Name = T("window"), Tab = TabConfig })

Window:AddButton({ Title = "480×300", Description = "Compact", Tab = TabConfig, Callback = function() pcall(function() Window:SetSetting("Size", UDim2.fromOffset(480,300)) end) end })
Window:AddButton({ Title = "560×360", Description = "Default", Tab = TabConfig, Callback = function() pcall(function() Window:SetSetting("Size", UDim2.fromOffset(560,360)) end) end })
Window:AddButton({ Title = "650×420", Description = "Large", Tab = TabConfig, Callback = function() pcall(function() Window:SetSetting("Size", UDim2.fromOffset(650,420)) end) end })

Window:AddSection({ Name = T("playerInfo"), Tab = TabConfig })

Window:AddParagraph({ Title = "Player", Description = "Name: "..LocalPlayer.Name.."\nDisplay: "..LocalPlayer.DisplayName.."\nID: "..LocalPlayer.UserId, Tab = TabConfig })

Window:AddSection({ Name = T("about"), Tab = TabConfig })

Window:AddParagraph({ Title = "Eplisma v3.1 Mobile", Description = "Developer: Frost\nTelegram: @Jokerfros\n\n[-] minimize • tap bar restore\n7 themes • 2 languages\nMobile fly • Auto Bomb Pass", Tab = TabConfig })

Window:AddSection({ Name = T("dangerZone"), Tab = TabConfig })

Window:AddButton({ Title = T("destroy"), Description = T("destroyDesc"), Tab = TabConfig,
    Callback = function()
        pcall(function() _G._CleanESP() end); pcall(function() _G._FOV:Remove() end)
        pcall(function() if HRP:FindFirstChild("_FlyBV") then HRP._FlyBV:Destroy() end; if HRP:FindFirstChild("_FlyBG") then HRP._FlyBG:Destroy() end end)
        CFG.Fly=false; CFG.Noclip=false; CFG.ESP=false; CFG.Aimbot=false; CFG.AutoBomb=false
        pcall(function() OverlayGui:Destroy() end)
        pcall(function() for _,g in ipairs(CoreGui:GetChildren()) do if g:FindFirstChild("Main") or (g:IsA("ScreenGui") and g.Name ~= "EplismaOverlay") then pcall(function() g:Destroy() end) end end end)
    end })

--// ═══════════════════════════════════════════
--//  DRAWING
--// ═══════════════════════════════════════════

local FOV = Drawing.new("Circle")
FOV.Thickness=1.5; FOV.NumSides=64; FOV.Radius=CFG.AimFOV; FOV.Filled=false; FOV.Visible=false; FOV.ZIndex=999; FOV.Transparency=0.75; FOV.Color=Color3.fromRGB(130,80,220)
_G._FOV = FOV

local ESPCache = {}
local function MkDraw(cls, props) local d = Drawing.new(cls); for k,v in pairs(props) do d[k]=v end; return d end

local function AddESP(plr)
    if plr == LocalPlayer or ESPCache[plr] then return end
    ESPCache[plr] = {
        Box=MkDraw("Square",{Thickness=1.5,Filled=false,Color=Color3.fromRGB(130,80,220),Visible=false,ZIndex=5}),
        Name=MkDraw("Text",{Size=13,Center=true,Outline=true,Color=Color3.fromRGB(255,255,255),Visible=false,ZIndex=5,Font=2}),
        HpBG=MkDraw("Line",{Thickness=4,Color=Color3.fromRGB(0,0,0),Visible=false,ZIndex=4}),
        Hp=MkDraw("Line",{Thickness=2,Color=Color3.fromRGB(0,255,0),Visible=false,ZIndex=5}),
        Dist=MkDraw("Text",{Size=11,Center=true,Outline=true,Color=Color3.fromRGB(180,180,200),Visible=false,ZIndex=5,Font=2}),
        Tracer=MkDraw("Line",{Thickness=1.5,Color=Color3.fromRGB(130,80,220),Visible=false,ZIndex=5}),
    }
end

local function DelESP(plr) if ESPCache[plr] then for _,d in pairs(ESPCache[plr]) do pcall(d.Remove,d) end; ESPCache[plr]=nil end end
local function HideAll(esp) for _,d in pairs(esp) do d.Visible=false end end
_G._CleanESP = function() for p in pairs(ESPCache) do DelESP(p) end end

for _,p in ipairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(DelESP)

--// ═══════════════════════════════════════════
--//  HELPERS
--// ═══════════════════════════════════════════

local function IsAlly(plr)
    if not CFG.TeamCheck then return false end
    local ok,r = pcall(function() return plr.Team == LocalPlayer.Team end); return ok and r
end

local function FindTarget()
    local best,bestD = nil, CFG.AimFOV
    local mp = UserInputService:GetMouseLocation()
    for _,p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or IsAlly(p) then continue end
        local c = p.Character; if not c then continue end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local part = c:FindFirstChild(CFG.AimBone) or c:FindFirstChild("HumanoidRootPart")
        if not (hum and hum.Health>0 and part) then continue end
        local sp,vis = Camera:WorldToScreenPoint(part.Position)
        if not vis then continue end
        local d = (Vector2.new(sp.X,sp.Y)-mp).Magnitude
        if d < bestD then bestD=d; best=p end
    end
    return best
end

local function FindNearestPlayer()
    local closest,dist = nil, math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist=d; closest=p end
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
--//  FLY ДЛЯ ТЕЛЕФОНУ — через Humanoid.MoveDirection
--// ═══════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    local mp = UserInputService:GetMouseLocation()
    FOV.Visible = CFG.ShowFOV; FOV.Radius = CFG.AimFOV; FOV.Position = mp

    -- Aimbot
    if CFG.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = FindTarget()
        if t and t.Character then
            local part = t.Character:FindFirstChild(CFG.AimBone) or t.Character:FindFirstChild("HumanoidRootPart")
            if part then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), 1/math.max(CFG.AimSmooth,0.01)) end
        end
    end

    -- ESP
    local vp = Camera.ViewportSize
    for plr,esp in pairs(ESPCache) do
        local c = plr.Character; local hum = c and c:FindFirstChildOfClass("Humanoid")
        local hrp = c and c:FindFirstChild("HumanoidRootPart"); local head = c and c:FindFirstChild("Head")
        if not (c and hum and hum.Health>0 and hrp and head and CFG.ESP) or IsAlly(plr) then HideAll(esp); continue end
        local wp,vis = Camera:WorldToViewportPoint(hrp.Position)
        local hp = Camera:WorldToViewportPoint(head.Position+Vector3.new(0,.5,0))
        local fp = Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
        if not vis then HideAll(esp); continue end
        local bH = math.abs(hp.Y-fp.Y); local bW = bH*0.55; local cx = wp.X
        esp.Box.Visible=CFG.BoxESP; esp.Box.Size=Vector2.new(bW,bH); esp.Box.Position=Vector2.new(cx-bW*.5,hp.Y)
        esp.Name.Visible=CFG.NameESP; esp.Name.Text=plr.DisplayName; esp.Name.Position=Vector2.new(cx,hp.Y-16)
        local pct = hum.Health/hum.MaxHealth
        esp.HpBG.Visible=CFG.HealthESP; esp.HpBG.From=Vector2.new(cx-bW*.5-5,fp.Y); esp.HpBG.To=Vector2.new(cx-bW*.5-5,hp.Y)
        esp.Hp.Visible=CFG.HealthESP; esp.Hp.From=Vector2.new(cx-bW*.5-5,fp.Y); esp.Hp.To=Vector2.new(cx-bW*.5-5,fp.Y-bH*pct); esp.Hp.Color=Color3.new(1-pct,pct,0)
        local dist = (HRP.Position-hrp.Position).Magnitude
        esp.Dist.Visible=CFG.DistESP; esp.Dist.Text=math.floor(dist).."m"; esp.Dist.Position=Vector2.new(cx,fp.Y+3)
        esp.Tracer.Visible=CFG.TracerESP; esp.Tracer.From=Vector2.new(vp.X*.5,vp.Y); esp.Tracer.To=Vector2.new(cx,fp.Y)
    end

    -- FLY — МОБІЛЬНА ВЕРСІЯ
    -- Використовує Humanoid.MoveDirection (від джойстика)
    -- + кнопка Jump для підйому
    if CFG.Fly and HRP then
        local bv = HRP:FindFirstChild("_FlyBV")
        local bg = HRP:FindFirstChild("_FlyBG")

        if not bv then
            bv = Instance.new("BodyVelocity"); bv.Name = "_FlyBV"
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.zero
            bv.Parent = HRP
        end
        if not bg then
            bg = Instance.new("BodyGyro"); bg.Name = "_FlyBG"
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.D = 200; bg.P = 10000
            bg.Parent = HRP
        end

        bg.CFrame = Camera.CFrame

        -- Напрямок від джойстика (MoveDirection) — працює на телефоні
        local moveDir = Humanoid.MoveDirection
        local camCF = Camera.CFrame
        local dir = Vector3.zero

        if moveDir.Magnitude > 0.1 then
            -- Конвертуємо MoveDirection у напрямок камери
            local flatLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
            local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit

            -- MoveDirection вже у world space від джойстика
            dir = moveDir.Unit * CFG.FlySpeed
            -- Додаємо вертикаль через Y компоненту камери
            dir = Vector3.new(dir.X, 0, dir.Z)
        end

        -- ПК клавіші теж працюють
        local u = UserInputService
        if u:IsKeyDown(Enum.KeyCode.W) then dir += camCF.LookVector * CFG.FlySpeed end
        if u:IsKeyDown(Enum.KeyCode.S) then dir -= camCF.LookVector * CFG.FlySpeed end
        if u:IsKeyDown(Enum.KeyCode.A) then dir -= camCF.RightVector * CFG.FlySpeed end
        if u:IsKeyDown(Enum.KeyCode.D) then dir += camCF.RightVector * CFG.FlySpeed end

        -- Підйом: Jump кнопка (на телефоні теж працює)
        if u:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, CFG.FlySpeed, 0) end
        if u:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, CFG.FlySpeed, 0) end

        -- На мобільному: якщо Humanoid jumping — летимо вгору
        if Humanoid.Jump then
            dir += Vector3.new(0, CFG.FlySpeed * 0.7, 0)
        end

        -- Якщо MoveDirection є але немає клавіш — летимо в напрямку погляду камери
        if moveDir.Magnitude > 0.1 and dir.Magnitude < 1 then
            dir = camCF.LookVector * CFG.FlySpeed
        end

        bv.Velocity = dir
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
    if CFG.GodMode and Humanoid then pcall(function() Humanoid.Health = Humanoid.MaxHealth end) end
    if CFG.Noclip and Character then for _,p in ipairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    if CFG.BunnyHop and Humanoid then pcall(function() if Humanoid.FloorMaterial ~= Enum.Material.Air then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
    if CFG.AntiBlur then for _,o in ipairs(Lighting:GetChildren()) do if o:IsA("BlurEffect") then o:Destroy() end end end
end)

--// ═══════════════════════════════════════════
--//  INPUT
--// ═══════════════════════════════════════════

UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump and Humanoid then pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
end)

Mouse.Button1Down:Connect(function()
    if CFG.ClickTP and Mouse.Hit then pcall(function() HRP.CFrame = CFrame.new(Mouse.Hit.Position+Vector3.new(0,3,0)) end) end
end)

--// ═══════════════════════════════════════════
--//  BACKGROUND
--// ═══════════════════════════════════════════

LocalPlayer.Idled:Connect(function()
    if CFG.AntiAFK then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end
end)

task.spawn(function()
    while true do
        if CFG.ChatSpam and CFG.SpamMsg ~= "" then pcall(function() ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents",true):FindFirstChild("SayMessageRequest"):FireServer(CFG.SpamMsg,"All") end) end
        task.wait(math.max(CFG.SpamDelay, 0.5))
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if not CFG.KillAura or not HRP then continue end
        for _,p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or IsAlly(p) then continue end
            local c = p.Character; local h2 = c and c:FindFirstChild("HumanoidRootPart"); local hm = c and c:FindFirstChildOfClass("Humanoid")
            if h2 and hm and hm.Health>0 and (HRP.Position-h2.Position).Magnitude <= CFG.AuraRange then
                pcall(function() local t = Character:FindFirstChildOfClass("Tool"); if t then local h = t:FindFirstChild("Handle"); if h then firetouchinterest(h,h2,0); task.wait(); firetouchinterest(h,h2,1) end end end)
            end
        end
    end
end)

-- AUTO BOMB PASS
task.spawn(function()
    while task.wait(0.1) do
        if not CFG.AutoBomb or not Character then continue end
        for _, tool in ipairs(Character:GetChildren()) do
            if IsBombTool(tool) then
                local nearest = FindNearestPlayer()
                if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
                    local tHRP = nearest.Character.HumanoidRootPart
                    -- ТП до гравця
                    pcall(function() HRP.CFrame = tHRP.CFrame * CFrame.new(0,0,2) end)
                    task.wait(0.05)
                    -- Touch
                    pcall(function()
                        local handle = tool:FindFirstChild("Handle")
                        if handle then
                            firetouchinterest(handle, tHRP, 0); task.wait(0.05); firetouchinterest(handle, tHRP, 1)
                        end
                    end)
                    task.wait(0.1)
                    -- Повторний тач якщо ще в руках
                    if tool.Parent == Character then
                        pcall(function()
                            local handle = tool:FindFirstChild("Handle")
                            if handle then firetouchinterest(handle, tHRP, 0); task.wait(0.1); firetouchinterest(handle, tHRP, 1) end
                        end)
                    end
                end
                break
            end
        end
    end
end)

-- Chams/hitbox для нових
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if CFG.HitboxExp then task.wait(1); local h=char:FindFirstChild("HumanoidRootPart"); if h then h.Size=Vector3.new(CFG.HitboxSize,CFG.HitboxSize,CFG.HitboxSize); h.Transparency=0.5 end end
        if CFG.ChamsESP then task.wait(1); if not char:FindFirstChild("_Highlight") then local hl=Instance.new("Highlight"); hl.Name="_Highlight"; hl.FillColor=Color3.fromRGB(130,80,220); hl.FillTransparency=0.4; hl.OutlineColor=Color3.fromRGB(255,255,255); hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char end end
    end)
end)

task.delay(2, function() pcall(function() for _,o in ipairs(Lighting:GetChildren()) do if o:IsA("BlurEffect") then o:Destroy() end end end) end)

--// ═══════════════════════════════════════════
--//  STARTUP
--// ═══════════════════════════════════════════

Window:Notify({
    Title = "Eplisma v3.1",
    Description = T("welcome")..", "..LocalPlayer.DisplayName.."\n[-] minimize • tap bar restore\nby Frost | @Jokerfros",
    Duration = 6,
})

print([[
╔══════════════════════════════════════╗
║       E P L I S M A  v3.1 Mobile    ║
║     Developer: Frost                ║
║     Telegram: @Jokerfros            ║
╚══════════════════════════════════════╝
]])
