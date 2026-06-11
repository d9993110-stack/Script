--[[
    ╔══════════════════════════════════════════╗
    ║           E P L I S M A                  ║
    ║       Professional Cheat Suite           ║
    ║                                          ║
    ║   Developer: Frost                       ║
    ║   Telegram: @Jokerfros                   ║
    ║   Version: 3.0 (Void UI)                 ║
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
        walkspeed = "WalkSpeed", jumppower = "JumpPower",
        gravity = "Gravity", infJump = "Infinite Jump",
        autoJump = "Auto Jump", bunnyHop = "Bunny Hop",
        noclip = "Noclip", fly = "Fly", flySpeed = "Fly Speed",
        fov = "Field of View", godMode = "God Mode",
        noReset = "No Reset", forceReset = "Force Reset",
        respawn = "Respawn", freeze = "Freeze Character",
        frozen = "Frozen", unfrozen = "Unfrozen",
        aimbot = "Aimbot", fovRadius = "FOV Radius",
        smoothing = "Smoothing", showFov = "Show FOV Circle",
        hitbox = "Hitbox Expander", hitboxScale = "Hitbox Scale",
        killAura = "Kill Aura", auraRange = "Aura Range",
        nearestPlayer = "Nearest Player", noPlayersNear = "No players nearby",
        targetName = "Target Name", tpToTarget = "TP to Target",
        randomPlayer = "Random Player", tpSpawn = "TP to Spawn",
        tpForward = "TP Forward 100", savePos = "Save Position",
        loadPos = "Load Position", clickTp = "Click TP",
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
        removeEffects = "Remove Effects", removeParticles = "Remove Particles",
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
        autoBomb = "Auto Bomb Pass", bombKeywords = "Bomb Keywords",
        removeBlur = "Remove Blur", blurEnabled = "Blur Protection",
        removeAllPost = "Remove ALL Effects", lowGraphics = "Low Graphics",
        copyId = "Copy Player ID", destroy = "Destroy Eplisma",
        welcome = "Welcome",
    },
    RU = {
        character = "Персонаж", combat = "Бой", teleport = "Телепорт",
        esp = "ESP", environment = "Окружение", utilities = "Утилиты",
        settings = "Настройки",
        walkspeed = "Скорость", jumppower = "Прыжок",
        gravity = "Гравитация", infJump = "Бесконечный прыжок",
        autoJump = "Авто-прыжок", bunnyHop = "Банни-хоп",
        noclip = "Ноклип", fly = "Полёт", flySpeed = "Скорость полёта",
        fov = "Угол обзора", godMode = "Бессмертие",
        noReset = "Без ресета", forceReset = "Убить себя",
        respawn = "Респавн", freeze = "Заморозить",
        frozen = "Заморожен", unfrozen = "Разморожен",
        aimbot = "Аимбот", fovRadius = "Радиус FOV",
        smoothing = "Плавность", showFov = "Показать FOV",
        hitbox = "Хитбокс", hitboxScale = "Размер хитбокса",
        killAura = "Аура убийства", auraRange = "Радиус ауры",
        nearestPlayer = "Ближайший игрок", noPlayersNear = "Нет игроков рядом",
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
        removeEffects = "Убрать эффекты", removeParticles = "Убрать частицы",
        removeDecals = "Убрать декали", removeSounds = "Убрать звуки",
        effectsRemoved = "эффектов удалено", particlesRemoved = "частиц удалено",
        antiAfk = "Анти-АФК", antiKick = "Анти-Кик",
        spin = "Вращение", spinSpeed = "Скорость вращения",
        spawnPlatform = "Платформа", forceSit = "Сесть",
        forceJump = "Прыгнуть", copyPos = "Копировать позицию",
        copyLink = "Копировать ссылку", spamMsg = "Сообщение спама",
        spamInterval = "Интервал", chatSpam = "Спам в чат",
        rejoin = "Реджойн", serverHop = "Сменить сервер", serverInfo = "Инфо сервера",
        copied = "Скопировано",
        autoBomb = "Авто-бомба", bombKeywords = "Ключевые слова бомбы",
        removeBlur = "Убрать блюр", blurEnabled = "Защита от блюра",
        removeAllPost = "Убрать ВСЕ эффекты", lowGraphics = "Низкая графика",
        copyId = "Копировать ID", destroy = "Удалить Eplisma",
        welcome = "Добро пожаловать",
    },
}

local function T(key)
    return (L[Lang] and L[Lang][key]) or (L.EN[key]) or key
end

--// ═══════════════════════════════════════════
--//  VOID UI LIBRARY
--// ═══════════════════════════════════════════

local VoidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/raphaelmaboi/ui-libraries/refs/heads/main/VoidUi/source.lua"))()

local Window = VoidUI:CreateWindow({
    Title = "Eplisma v3.0",
    SubTitle = "by Frost | @Jokerfros",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 400),
    Theme = "Dark",
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

local TabChar = Window:AddTab(T("character"))

local SectMovement = TabChar:AddSection(T("character") .. " - Movement")

SectMovement:AddSlider(T("walkspeed"), 0, 500, 16, function(v)
    CFG.Speed = v
    pcall(function() Humanoid.WalkSpeed = v end)
end)

SectMovement:AddSlider(T("jumppower"), 0, 500, 50, function(v)
    CFG.JumpPower = v
    pcall(function()
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = v
    end)
end)

SectMovement:AddSlider(T("gravity"), 0, 500, 196, function(v)
    CFG.Gravity = v
    Workspace.Gravity = v
end)

SectMovement:AddToggle(T("infJump"), false, function(v)
    CFG.InfJump = v
end)

SectMovement:AddToggle(T("autoJump"), false, function(v)
    CFG.AutoJump = v
    pcall(function() Humanoid.AutoJumpEnabled = v end)
end)

SectMovement:AddToggle(T("bunnyHop"), false, function(v)
    CFG.BunnyHop = v
end)

SectMovement:AddToggle(T("noclip"), false, function(v)
    CFG.Noclip = v
end)

local SectFlight = TabChar:AddSection("Flight")

SectFlight:AddToggle(T("fly"), false, function(v)
    CFG.Fly = v
    if not v then
        pcall(function()
            if HRP:FindFirstChild("_BV") then HRP._BV:Destroy() end
            if HRP:FindFirstChild("_BG") then HRP._BG:Destroy() end
        end)
    end
end)

SectFlight:AddSlider(T("flySpeed"), 0, 300, 60, function(v)
    CFG.FlySpeed = v
end)

local SectCamera = TabChar:AddSection("Camera")

SectCamera:AddSlider(T("fov"), 10, 120, 70, function(v)
    CFG.FOV = v
    Camera.FieldOfView = v
end)

local SectSurvival = TabChar:AddSection("Survivability")

SectSurvival:AddToggle(T("godMode"), false, function(v)
    CFG.GodMode = v
end)

SectSurvival:AddToggle(T("noReset"), false, function(v)
    CFG.NoReset = v
    pcall(function() StarterGui:SetCore("ResetButtonCallback", not v) end)
end)

SectSurvival:AddButton(T("forceReset"), function()
    pcall(function() Humanoid.Health = 0 end)
end)

SectSurvival:AddButton(T("respawn"), function()
    pcall(function() LocalPlayer:LoadCharacter() end)
end)

SectSurvival:AddButton(T("freeze"), function()
    pcall(function()
        HRP.Anchored = not HRP.Anchored
    end)
end)

--// ═══════════════════════════════════════════
--//  TAB: COMBAT
--// ═══════════════════════════════════════════

local TabCombat = Window:AddTab(T("combat"))

local SectAim = TabCombat:AddSection("Aim Assist")

SectAim:AddToggle(T("aimbot"), false, function(v)
    CFG.Aimbot = v
end)

SectAim:AddSlider(T("fovRadius"), 10, 900, 250, function(v)
    CFG.AimFOV = v
end)

SectAim:AddSlider(T("smoothing"), 1, 50, 5, function(v)
    CFG.AimSmooth = v
end)

SectAim:AddToggle(T("showFov"), false, function(v)
    CFG.ShowFOV = v
end)

local SectMelee = TabCombat:AddSection("Melee")

SectMelee:AddToggle(T("hitbox"), false, function(v)
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
end)

SectMelee:AddSlider(T("hitboxScale"), 1, 30, 5, function(v)
    CFG.HitboxSize = v
end)

SectMelee:AddToggle(T("killAura"), false, function(v)
    CFG.KillAura = v
end)

SectMelee:AddSlider(T("auraRange"), 1, 60, 15, function(v)
    CFG.AuraRange = v
end)

local SectBomb = TabCombat:AddSection("Bomb Pass")

SectBomb:AddToggle(T("autoBomb"), false, function(v)
    CFG.AutoBomb = v
end)

SectBomb:AddTextbox(T("bombKeywords"), "bomb,бомба,tnt,dynamite,explosive", function(v)
    CFG.BombKeywords = v
end)

local SectInfo = TabCombat:AddSection("Info")

SectInfo:AddButton(T("nearestPlayer"), function()
    local closest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist = d; closest = p end
        end
    end
    if closest then
        VoidUI:Notification(T("nearestPlayer"), closest.DisplayName .. " — " .. math.floor(dist) .. " studs", 4)
    else
        VoidUI:Notification("Error", T("noPlayersNear"), 3)
    end
end)

--// ═══════════════════════════════════════════
--//  TAB: TELEPORT
--// ═══════════════════════════════════════════

local TabTP = Window:AddTab(T("teleport"))

local SectPlayerTP = TabTP:AddSection("Player Transport")

SectPlayerTP:AddTextbox(T("targetName"), "", function(v)
    CFG.TpTarget = v
end)

SectPlayerTP:AddButton(T("tpToTarget"), function()
    local query = CFG.TpTarget:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():find(query) or p.DisplayName:lower():find(query)) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            HRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
            VoidUI:Notification(T("teleport"), T("movedTo") .. " " .. p.DisplayName, 3)
            return
        end
    end
    VoidUI:Notification("Error", T("notFound"), 3)
end)

SectPlayerTP:AddButton(T("randomPlayer"), function()
    local pool = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(pool, p)
        end
    end
    if #pool == 0 then
        VoidUI:Notification("Error", T("noPlayers"), 3)
        return
    end
    local t = pool[math.random(#pool)]
    HRP.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
    VoidUI:Notification(T("randomPlayer"), T("movedTo") .. " " .. t.DisplayName, 3)
end)

SectPlayerTP:AddButton(T("tpSpawn"), function()
    pcall(function()
        local sp = Workspace:FindFirstChildOfClass("SpawnLocation")
        if sp then
            HRP.CFrame = sp.CFrame + Vector3.new(0, 5, 0)
        else
            HRP.CFrame = CFrame.new(0, 50, 0)
        end
    end)
end)

SectPlayerTP:AddButton(T("tpForward"), function()
    pcall(function() HRP.CFrame = HRP.CFrame + HRP.CFrame.LookVector * 100 end)
end)

local SectWaypoints = TabTP:AddSection("Waypoints")

SectWaypoints:AddButton(T("savePos"), function()
    CFG.SavedCF = HRP.CFrame
    VoidUI:Notification(T("saved"), T("posStored"), 2)
end)

SectWaypoints:AddButton(T("loadPos"), function()
    if CFG.SavedCF then
        HRP.CFrame = CFG.SavedCF
        VoidUI:Notification(T("loaded"), T("posRestored"), 2)
    else
        VoidUI:Notification("Error", T("nothingSaved"), 2)
    end
end)

SectWaypoints:AddToggle(T("clickTp"), false, function(v)
    CFG.ClickTP = v
end)

--// ═══════════════════════════════════════════
--//  TAB: ESP
--// ═══════════════════════════════════════════

local TabESP = Window:AddTab(T("esp"))

local SectRendering = TabESP:AddSection("Rendering")

SectRendering:AddToggle(T("enableEsp"), false, function(v)
    CFG.ESP = v
end)

SectRendering:AddToggle(T("boundBox"), false, function(v)
    CFG.BoxESP = v
end)

SectRendering:AddToggle(T("nameTags"), false, function(v)
    CFG.NameESP = v
end)

SectRendering:AddToggle(T("healthBars"), false, function(v)
    CFG.HealthESP = v
end)

SectRendering:AddToggle(T("distTags"), false, function(v)
    CFG.DistESP = v
end)

SectRendering:AddToggle(T("tracers"), false, function(v)
    CFG.TracerESP = v
end)

SectRendering:AddToggle(T("chams"), false, function(v)
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
end)

local SectFilters = TabESP:AddSection("Filters")

SectFilters:AddToggle(T("teamFilter"), false, function(v)
    CFG.TeamCheck = v
end)

--// ═══════════════════════════════════════════
--//  TAB: ENVIRONMENT
--// ═══════════════════════════════════════════

local TabEnv = Window:AddTab(T("environment"))

local SectLighting = TabEnv:AddSection("Lighting")

SectLighting:AddToggle(T("fullbright"), false, function(v)
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
end)

SectLighting:AddToggle(T("noFog"), false, function(v)
    CFG.NoFog = v
    Lighting.FogEnd = v and 9999999 or 100000
end)

SectLighting:AddToggle(T("timeLock"), false, function(v)
    CFG.CustomTime = v
end)

SectLighting:AddSlider(T("clockTime"), 0, 24, 14, function(v)
    CFG.TimeVal = v
    if CFG.CustomTime then Lighting.ClockTime = v end
end)

local SectCleanup = TabEnv:AddSection("Cleanup")

SectCleanup:AddButton(T("removeEffects"), function()
    local n = 0
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then
            e:Destroy(); n += 1
        end
    end
    VoidUI:Notification("Cleanup", n .. " " .. T("effectsRemoved"), 2)
end)

SectCleanup:AddButton(T("removeParticles"), function()
    local n = 0
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then
            o:Destroy(); n += 1
        end
    end
    VoidUI:Notification("Cleanup", n .. " " .. T("particlesRemoved"), 2)
end)

SectCleanup:AddButton(T("removeDecals"), function()
    local n = 0
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("Decal") or o:IsA("Texture") then o:Destroy(); n += 1 end
    end
    VoidUI:Notification("Cleanup", n .. " removed", 2)
end)

SectCleanup:AddButton(T("removeSounds"), function()
    local n = 0
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("Sound") then o:Stop(); o:Destroy(); n += 1 end
    end
    VoidUI:Notification("Cleanup", n .. " removed", 2)
end)

--// ═══════════════════════════════════════════
--//  TAB: UTILITIES
--// ═══════════════════════════════════════════

local TabUtil = Window:AddTab(T("utilities"))

local SectProtect = TabUtil:AddSection("Protection")

SectProtect:AddToggle(T("antiAfk"), false, function(v)
    CFG.AntiAFK = v
end)

SectProtect:AddToggle(T("antiKick"), false, function(v)
    CFG.AntiKick = v
end)

local SectActions = TabUtil:AddSection("Actions")

SectActions:AddToggle(T("spin"), false, function(v)
    CFG.Spin = v
end)

SectActions:AddSlider(T("spinSpeed"), 1, 50, 10, function(v)
    CFG.SpinSpeed = v
end)

SectActions:AddButton(T("spawnPlatform"), function()
    local p = Instance.new("Part")
    p.Size = Vector3.new(20, 1, 20)
    p.CFrame = HRP.CFrame * CFrame.new(0, -4, 0)
    p.Anchored = true
    p.BrickColor = BrickColor.new("Bright violet")
    p.Material = Enum.Material.Neon
    p.Transparency = 0.3
    p.Parent = Workspace
end)

SectActions:AddButton(T("forceSit"), function()
    pcall(function() Humanoid.Sit = true end)
end)

SectActions:AddButton(T("forceJump"), function()
    pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
end)

SectActions:AddButton(T("copyPos"), function()
    local pos = HRP.Position
    local txt = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    pcall(function() setclipboard(txt) end)
    VoidUI:Notification(T("copied"), txt, 3)
end)

SectActions:AddButton(T("copyLink"), function()
    local link = "https://www.roblox.com/games/" .. game.PlaceId
    pcall(function() setclipboard(link) end)
    VoidUI:Notification(T("copied"), link, 3)
end)

local SectChat = TabUtil:AddSection("Chat")

SectChat:AddTextbox(T("spamMsg"), "", function(v)
    CFG.SpamMsg = v
end)

SectChat:AddSlider(T("spamInterval"), 1, 10, 2, function(v)
    CFG.SpamDelay = v
end)

SectChat:AddToggle(T("chatSpam"), false, function(v)
    CFG.ChatSpam = v
end)

local SectServer = TabUtil:AddSection("Server")

SectServer:AddButton(T("rejoin"), function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

SectServer:AddButton(T("serverHop"), function()
    task.spawn(function()
        local ok, data = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
        end)
        if not ok then
            VoidUI:Notification("Error", "Failed", 3)
            return
        end
        for _, sv in ipairs(data.data) do
            if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer)
                return
            end
        end
        VoidUI:Notification("Error", "No servers", 3)
    end)
end)

SectServer:AddButton(T("serverInfo"), function()
    VoidUI:Notification(T("serverInfo"), string.format("Players: %d/%d | Place: %d | Ping: ~%dms",
        #Players:GetPlayers(), Players.MaxPlayers, game.PlaceId,
        math.floor(LocalPlayer:GetNetworkPing() * 1000)), 6)
end)

--// ═══════════════════════════════════════════
--//  TAB: SETTINGS
--// ═══════════════════════════════════════════

local TabSettings = Window:AddTab(T("settings"))

local SectLang = TabSettings:AddSection("Language")

SectLang:AddButton("🇬🇧 English", function()
    Lang = "EN"
    VoidUI:Notification("Language", "English selected. Rejoin to apply.", 4)
end)

SectLang:AddButton("🇷🇺 Русский", function()
    Lang = "RU"
    VoidUI:Notification("Язык", "Русский выбран. Перезайдите.", 4)
end)

local SectGfx = TabSettings:AddSection("Graphics")

SectGfx:AddToggle(T("blurEnabled"), false, function(v)
    CFG.AntiBlur = v
    if v then
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") then obj:Destroy() end
        end
    end
end)

SectGfx:AddButton(T("removeBlur"), function()
    local n = 0
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("BlurEffect") then obj:Destroy(); n += 1 end
    end
    VoidUI:Notification("Blur", n .. " removed", 2)
end)

SectGfx:AddButton(T("removeAllPost"), function()
    local n = 0
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("PostEffect") or e:IsA("Atmosphere") then e:Destroy(); n += 1 end
    end
    VoidUI:Notification("Cleanup", n .. " removed", 2)
end)

SectGfx:AddButton(T("lowGraphics"), function()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.GlobalShadows = false
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("PostEffect") or e:IsA("Atmosphere") then e.Enabled = false end
    end
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled = false end
    end
    VoidUI:Notification("Graphics", "Low mode ON", 2)
end)

local SectPlayerInfo = TabSettings:AddSection("Player Info")

SectPlayerInfo:AddButton(T("copyId") .. " (" .. LocalPlayer.UserId .. ")", function()
    pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end)
    VoidUI:Notification(T("copied"), tostring(LocalPlayer.UserId), 2)
end)

local SectAbout = TabSettings:AddSection("About")

SectAbout:AddButton("Eplisma v3.0 | Frost | @Jokerfros", function()
    VoidUI:Notification("Eplisma v3.0", "Developer: Frost\nTelegram: @Jokerfros\nVoid UI Edition", 5)
end)

local SectDanger = TabSettings:AddSection("Danger Zone")

SectDanger:AddButton(T("destroy"), function()
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
    pcall(function() VoidUI:Destroy() end)
end)

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

task.delay(2, function()
    pcall(function()
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("BlurEffect") then obj:Destroy() end
        end
    end)
end)

--// ═══════════════════════════════════════════
--//  STARTUP
--// ═══════════════════════════════════════════

VoidUI:Notification("Eplisma v3.0", T("welcome") .. ", " .. LocalPlayer.DisplayName .. "!\nby Frost | @Jokerfros", 6)

print([[
╔══════════════════════════════════════╗
║         E P L I S M A  v3.0         ║
║     Developer: Frost                ║
║     Telegram: @Jokerfros            ║
║     UI: Void UI Library             ║
╠══════════════════════════════════════╣
║  Player: ]] .. LocalPlayer.Name .. [[

║  Place: ]] .. game.PlaceId .. [[

╚══════════════════════════════════════╝
]])
