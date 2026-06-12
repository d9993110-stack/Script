--[[
    ╔══════════════════════════════════════════╗
    ║           E P L I S M A                  ║
    ║       Professional Cheat Suite           ║
    ║                                          ║
    ║   Developer: Frost                       ║
    ║   Telegram: @Jokerfros                   ║
    ║   Version: 3.0 (Obsidian UI)             ║
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

--// Detect mobile
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--// ═══════════════════════════════════════════
--//  МОВИ
--// ═══════════════════════════════════════════

local Lang = "EN"
local L = {
    EN = {
        character="Character", combat="Combat", teleport="Teleport",
        esp="ESP", environment="Environment", utilities="Utilities",
        settings="UI Settings", fun="Fun",
        walkspeed="WalkSpeed", jumppower="JumpPower", gravity="Gravity",
        infJump="Infinite Jump", autoJump="Auto Jump", bunnyHop="Bunny Hop",
        noclip="Noclip", fly="Fly", flySpeed="Fly Speed",
        fov="Field of View", godMode="God Mode", noReset="No Reset",
        forceReset="Force Reset", respawn="Respawn",
        freeze="Freeze Character", frozen="Frozen", unfrozen="Unfrozen",
        aimbot="Aimbot", fovRadius="FOV Radius", smoothing="Smoothing",
        showFov="Show FOV Circle", hitbox="Hitbox Expander",
        hitboxScale="Hitbox Scale", killAura="Kill Aura",
        auraRange="Aura Range", nearestPlayer="Nearest Player",
        noPlayersNear="No players nearby", targetName="Target Name",
        tpToTarget="TP to Target", randomPlayer="Random Player",
        tpSpawn="TP to Spawn", tpForward="TP Forward 100",
        savePos="Save Position", loadPos="Load Position", clickTp="Click TP",
        saved="Saved", loaded="Loaded", posStored="Position stored",
        posRestored="Position restored", nothingSaved="Nothing saved",
        notFound="Player not found", noPlayers="No players", movedTo="Moved to",
        enableEsp="Enable ESP", boundBox="Bounding Box", nameTags="Name Tags",
        healthBars="Health Bars", distTags="Distance Tags", tracers="Tracers",
        chams="Chams", teamFilter="Team Filter", fullbright="Fullbright",
        noFog="No Fog", timeLock="Time Lock", clockTime="Clock Time",
        removeEffects="Remove Effects", removeParticles="Remove Particles",
        removeDecals="Remove Decals", removeSounds="Remove Sounds",
        effectsRemoved="effects removed", particlesRemoved="particles removed",
        antiAfk="Anti-AFK", antiKick="Anti-Kick",
        spin="Character Spin", spinSpeed="Spin Speed",
        spawnPlatform="Spawn Platform", forceSit="Force Sit",
        forceJump="Force Jump", copyPos="Copy Position",
        copyLink="Copy Game Link", spamMsg="Spam Message",
        spamInterval="Spam Interval", chatSpam="Chat Spam",
        rejoin="Rejoin", serverHop="Server Hop", serverInfo="Server Info",
        copied="Copied", autoBomb="Auto Bomb Pass",
        bombKeywords="Bomb Keywords", bombExclude="Excluded Players",
        removeBlur="Remove Blur", blurEnabled="Blur Protection",
        removeAllPost="Remove ALL Effects", lowGraphics="Low Graphics",
        copyId="Copy Player ID", destroy="Destroy Eplisma", welcome="Welcome",
        autoAim="Auto Aim (Mobile)", aimbotTarget="Aim Target Bone",
        auraDelay="Aura Delay", invisible="Invisibility",
        emotes="Emotes", music="Music", flyUp="Fly Up", flyDown="Fly Down",
        flyMobile="Mobile Fly Controls",
    },
    RU = {
        character="Персонаж", combat="Бой", teleport="Телепорт",
        esp="ESP", environment="Окружение", utilities="Утилиты",
        settings="Настройки UI", fun="Фан",
        walkspeed="Скорость", jumppower="Прыжок", gravity="Гравитация",
        infJump="Бесконечный прыжок", autoJump="Авто-прыжок",
        bunnyHop="Банни-хоп", noclip="Ноклип", fly="Полёт",
        flySpeed="Скорость полёта", fov="Угол обзора",
        godMode="Бессмертие", noReset="Без ресета",
        forceReset="Убить себя", respawn="Респавн",
        freeze="Заморозить", frozen="Заморожен", unfrozen="Разморожен",
        aimbot="Аимбот", fovRadius="Радиус FOV", smoothing="Плавность",
        showFov="Показать FOV", hitbox="Хитбокс",
        hitboxScale="Размер хитбокса", killAura="Аура убийства",
        auraRange="Радиус ауры", nearestPlayer="Ближайший игрок",
        noPlayersNear="Нет игроков рядом", targetName="Имя цели",
        tpToTarget="ТП к цели", randomPlayer="Случайный",
        tpSpawn="ТП на спавн", tpForward="ТП вперёд 100",
        savePos="Сохранить позицию", loadPos="Загрузить позицию",
        clickTp="ТП по клику", saved="Сохранено", loaded="Загружено",
        posStored="Позиция сохранена", posRestored="Позиция восстановлена",
        nothingSaved="Ничего не сохранено", notFound="Не найден",
        noPlayers="Нет игроков", movedTo="Перемещён к",
        enableEsp="Включить ESP", boundBox="Рамки", nameTags="Имена",
        healthBars="Полоски HP", distTags="Дистанция", tracers="Линии",
        chams="Хамс", teamFilter="Фильтр команды", fullbright="Яркий свет",
        noFog="Без тумана", timeLock="Блокировка времени",
        clockTime="Время суток", removeEffects="Убрать эффекты",
        removeParticles="Убрать частицы", removeDecals="Убрать декали",
        removeSounds="Убрать звуки", effectsRemoved="эффектов удалено",
        particlesRemoved="частиц удалено", antiAfk="Анти-АФК",
        antiKick="Анти-Кик", spin="Вращение", spinSpeed="Скорость вращения",
        spawnPlatform="Платформа", forceSit="Сесть", forceJump="Прыгнуть",
        copyPos="Копировать позицию", copyLink="Копировать ссылку",
        spamMsg="Сообщение спама", spamInterval="Интервал",
        chatSpam="Спам в чат", rejoin="Реджойн",
        serverHop="Сменить сервер", serverInfo="Инфо сервера",
        copied="Скопировано", autoBomb="Авто-бомба",
        bombKeywords="Ключевые слова бомбы",
        bombExclude="Исключённые игроки",
        removeBlur="Убрать блюр", blurEnabled="Защита от блюра",
        removeAllPost="Убрать ВСЕ эффекты", lowGraphics="Низкая графика",
        copyId="Копировать ID", destroy="Удалить Eplisma",
        welcome="Добро пожаловать",
        autoAim="Авто прицел (Мобильный)", aimbotTarget="Цель прицела",
        auraDelay="Задержка ауры", invisible="Невидимость",
        emotes="Эмоции", music="Музыка", flyUp="Лететь вверх",
        flyDown="Лететь вниз", flyMobile="Мобильное управление полётом",
    },
}
local function T(key) return (L[Lang] and L[Lang][key]) or (L.EN[key]) or key end

--// ═══════════════════════════════════════════
--//  OBSIDIAN UI LIBRARY
--// ═══════════════════════════════════════════

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Eplisma v3.0",
    Footer = "by Frost | @Jokerfros",
    NotifySide = "Right",
    ShowCustomCursor = not IsMobile,
    AutoShow = true,
    MobileButtonsSide = "Right",
})

--// ═══════════════════════════════════════════
--//  STATE
--// ═══════════════════════════════════════════

local CFG = {
    Speed=16, JumpPower=50, Gravity=196.2,
    InfJump=false, Noclip=false,
    Fly=false, FlySpeed=60, FlyUp=false, FlyDown=false,
    GodMode=false, FOV=70, AutoJump=false, BunnyHop=false,
    Aimbot=false, AimFOV=250, AimSmooth=5,
    AimBone="Head", ShowFOV=false, AutoAim=false,
    HitboxExp=false, HitboxSize=5,
    KillAura=false, AuraRange=15, AuraDelay=0.15,
    ESP=false, BoxESP=false, NameESP=false,
    HealthESP=false, DistESP=false,
    TracerESP=false, ChamsESP=false, TeamCheck=false,
    Fullbright=false, NoFog=false,
    AntiAFK=false, CustomTime=false, TimeVal=14,
    ClickTP=false, Spin=false, SpinSpeed=10,
    ChatSpam=false, SpamMsg="", SpamDelay=2,
    SavedCF=nil, TpTarget="",
    AntiKick=false, NoReset=false, AntiBlur=false,
    AutoBomb=false,
    BombKeywords="bomb,бомба,tnt,dynamite,explosive",
    BombExcluded={},
    Invisible=false, MusicPlaying=nil,
}

--// ═══════════════════════════════════════════
--//  HELPERS
--// ═══════════════════════════════════════════

local function GetPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end

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
        local c = p.Character; if not c then continue end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local part = c:FindFirstChild(CFG.AimBone) or c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
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

local function FindNearestPlayerForBomb()
    local closest, dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local excluded = CFG.BombExcluded and type(CFG.BombExcluded) == "table" and CFG.BombExcluded[p.Name]
            if not excluded then
                local d = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; closest = p end
            end
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
--//  TOOL GRABBER HELPERS
--// ═══════════════════════════════════════════

local function GetAllTools()
    local tools = {}
    local seen = {}

    local function scanObj(obj, source)
        pcall(function()
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("Tool") and not seen[child.Name] then
                    seen[child.Name] = true
                    table.insert(tools, {tool = child, source = source, name = child.Name})
                end
            end
        end)
    end

    -- Main locations
    scanObj(ReplicatedStorage, "ReplicatedStorage")
    scanObj(Workspace, "Workspace")
    scanObj(Lighting, "Lighting")

    -- StarterPack
    pcall(function() scanObj(game:GetService("StarterPack"), "StarterPack") end)

    -- All players backpacks and characters
    for _, p in ipairs(Players:GetPlayers()) do
        pcall(function()
            if p.Backpack then scanObj(p.Backpack, p.Name .. ".Backpack") end
            if p.Character then scanObj(p.Character, p.Name .. ".Character") end
        end)
    end

    -- Nil instances
    pcall(function()
        if getnilinstances then
            for _, obj in ipairs(getnilinstances()) do
                if obj:IsA("Tool") and not seen[obj.Name] then
                    seen[obj.Name] = true
                    table.insert(tools, {tool = obj, source = "nil", name = obj.Name})
                end
            end
        end
    end)

    return tools
end

local function GetAllToolNames()
    local names = {}
    local tools = GetAllTools()
    for _, t in ipairs(tools) do table.insert(names, t.name) end
    if #names == 0 then table.insert(names, "No tools found") end
    table.sort(names)
    return names
end

-- Method 1: Direct clone to backpack
local function GiveMethod1(tool)
    local cloned = tool:Clone()
    cloned.Parent = LocalPlayer.Backpack
    return true
end

-- Method 2: Move to backpack (same instance)
local function GiveMethod2(tool)
    tool.Parent = LocalPlayer.Backpack
    return true
end

-- Method 3: Re-parent via StarterGear simulation
local function GiveMethod3(tool)
    local cloned = tool:Clone()
    cloned.Parent = LocalPlayer.Character
    task.wait(0.1)
    if cloned.Parent == LocalPlayer.Character then
        cloned.Parent = LocalPlayer.Backpack
    end
    return true
end

-- Method 4: Fire remote events that give tools (game specific)
local function GiveMethod4(toolName)
    local remotes = {}
    local function scanRemotes(obj)
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                local n = child.Name:lower()
                if n:find("give") or n:find("tool") or n:find("weapon") or n:find("equip") or n:find("item") or n:find("pickup") then
                    table.insert(remotes, child)
                end
            end
        end
    end
    scanRemotes(ReplicatedStorage)
    scanRemotes(Workspace)

    for _, remote in ipairs(remotes) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(toolName)
                remote:FireServer(toolName, LocalPlayer)
                remote:FireServer({name = toolName})
                remote:FireServer({tool = toolName})
                remote:FireServer({item = toolName})
                remote:FireServer({weapon = toolName})
                remote:FireServer({Name = toolName})
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(toolName)
                remote:InvokeServer(toolName, LocalPlayer)
            end
        end)
    end
    return #remotes > 0
end

-- Method 5: BindableEvent trigger
local function GiveMethod5(toolName)
    local found = false
    local function scanBindables(obj)
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("BindableEvent") or child:IsA("BindableFunction") then
                local n = child.Name:lower()
                if n:find("give") or n:find("tool") or n:find("weapon") or n:find("item") then
                    pcall(function()
                        if child:IsA("BindableEvent") then child:Fire(toolName) end
                        if child:IsA("BindableFunction") then child:Invoke(toolName) end
                        found = true
                    end)
                end
            end
        end
    end
    scanBindables(ReplicatedStorage)
    scanBindables(Workspace)
    return found
end

-- Method 6: Humanoid EquipTool
local function GiveMethod6(tool)
    local cloned = tool:Clone()
    cloned.Parent = LocalPlayer.Backpack
    task.wait(0.05)
    pcall(function() Humanoid:EquipTool(cloned) end)
    return true
end

-- Method 7: simulatetouch
local function GiveMethod7(tool)
    local cloned = tool:Clone()
    cloned.Parent = Workspace
    pcall(function()
        local handle = cloned:FindFirstChild("Handle")
        if handle and HRP then
            cloned:SetPrimaryPartCFrame(HRP.CFrame)
            handle.CFrame = HRP.CFrame
            if firetouchinterest then
                firetouchinterest(handle, HRP, 0)
                task.wait(0.05)
                firetouchinterest(handle, HRP, 1)
            end
        end
    end)
    task.wait(0.2)
    if cloned.Parent ~= LocalPlayer.Backpack and cloned.Parent ~= Character then
        cloned.Parent = LocalPlayer.Backpack
    end
    return true
end

-- Give with ALL methods
local function GiveToolAllMethods(toolName)
    local allTools = GetAllTools()
    local foundTool = nil
    local query = toolName:lower()

    for _, t in ipairs(allTools) do
        if t.name:lower():find(query) then
            foundTool = t
            break
        end
    end

    local results = {}

    if foundTool then
        -- Method 1: Clone
        local ok1 = pcall(function() GiveMethod1(foundTool.tool) end)
        table.insert(results, "Clone: " .. (ok1 and "✅" or "❌"))

        -- Method 3: Parent to char
        local ok3 = pcall(function() GiveMethod3(foundTool.tool) end)
        table.insert(results, "CharParent: " .. (ok3 and "✅" or "❌"))

        -- Method 6: EquipTool
        local ok6 = pcall(function() GiveMethod6(foundTool.tool) end)
        table.insert(results, "Equip: " .. (ok6 and "✅" or "❌"))

        -- Method 7: Touch simulate
        local ok7 = pcall(function() GiveMethod7(foundTool.tool) end)
        table.insert(results, "Touch: " .. (ok7 and "✅" or "❌"))
    end

    -- Method 4: Remote events
    local ok4 = pcall(function() GiveMethod4(toolName) end)
    table.insert(results, "Remote: " .. (ok4 and "✅" or "❌"))

    -- Method 5: Bindables
    local ok5 = pcall(function() GiveMethod5(toolName) end)
    table.insert(results, "Bindable: " .. (ok5 and "✅" or "❌"))

    return foundTool ~= nil, results, foundTool and foundTool.name or toolName
end

--// ═══════════════════════════════════════════
--//  EMOTE LIST
--// ═══════════════════════════════════════════

local EmoteList = {
    ["Wave"]   = "rbxassetid://507770239",
    ["Point"]  = "rbxassetid://507770453",
    ["Dance 1"]= "rbxassetid://507771019",
    ["Dance 2"]= "rbxassetid://507776043",
    ["Dance 3"]= "rbxassetid://507777268",
    ["Laugh"]  = "rbxassetid://507770818",
    ["Cheer"]  = "rbxassetid://507770677",
}
local EmoteNames = {}
for name in pairs(EmoteList) do table.insert(EmoteNames, name) end
table.sort(EmoteNames)

--// ═══════════════════════════════════════════
--//  MUSIC LIST
--// ═══════════════════════════════════════════

local MusicList = {
    ["None (Stop)"]              = 0,
    ["Phonk - Murder in my mind"]= 103272309705374,
    ["Doom - BFG Division"]      = 126271266950979,
    ["Megalovania"]              = 83298925967923,
    ["Rick Astley - Never Gonna"]= 107128147864287,
    ["Astronomia (Coffin Dance)"]= 5150369852,
    ["Tokyo Drift"]              = 5763733942,
    ["Nyan Cat"]                 = 316278076,
    ["Believer - Imagine Dragons"]= 1056713406,
    ["Old Town Road"]            = 2862170886,
    ["Crab Rave"]                = 2630812668,
    ["Giorno Theme"]             = 3623981455,
    ["Attack on Titan"]          = 5889289038,
    ["Demon Slayer OP"]          = 5480545077,
    ["Jujutsu Kaisen OP"]        = 6230681604,
    ["Phonk - Close Eyes"]       = 8481487794,
    ["Minecraft Theme"]          = 1845554017,
}
local MusicNames = {}
for name in pairs(MusicList) do table.insert(MusicNames, name) end
table.sort(MusicNames)

--// ═══════════════════════════════════════════
--//  TABS
--// ═══════════════════════════════════════════

local Tabs = {
    Character   = Window:AddTab(T("character"),   "user"),
    Combat      = Window:AddTab(T("combat"),      "swords"),
    Teleport    = Window:AddTab(T("teleport"),    "map-pin"),
    ESP         = Window:AddTab(T("esp"),         "eye"),
    Fun         = Window:AddTab(T("fun"),         "music"),
    Environment = Window:AddTab(T("environment"), "sun"),
    Utilities   = Window:AddTab(T("utilities"),   "wrench"),
    Settings    = Window:AddTab(T("settings"),    "settings"),
}

--// ═══════════════════════════════════════════
--//  TAB: CHARACTER
--// ═══════════════════════════════════════════

do
    local MovementBox = Tabs.Character:AddLeftGroupbox("Movement")
    MovementBox:AddSlider("WalkSpeed",{Text=T("walkspeed"),Default=16,Min=0,Max=500,Rounding=0,Callback=function(v) CFG.Speed=v; pcall(function() Humanoid.WalkSpeed=v end) end})
    MovementBox:AddSlider("JumpPower",{Text=T("jumppower"),Default=50,Min=0,Max=500,Rounding=0,Callback=function(v) CFG.JumpPower=v; pcall(function() Humanoid.UseJumpPower=true; Humanoid.JumpPower=v end) end})
    MovementBox:AddSlider("Gravity",{Text=T("gravity"),Default=196,Min=0,Max=500,Rounding=0,Callback=function(v) CFG.Gravity=v; Workspace.Gravity=v end})
    MovementBox:AddDivider()
    MovementBox:AddToggle("InfJump",{Text=T("infJump"),Default=false,Callback=function(v) CFG.InfJump=v end})
    MovementBox:AddToggle("AutoJump",{Text=T("autoJump"),Default=false,Callback=function(v) CFG.AutoJump=v; pcall(function() Humanoid.AutoJumpEnabled=v end) end})
    MovementBox:AddToggle("BunnyHop",{Text=T("bunnyHop"),Default=false,Callback=function(v) CFG.BunnyHop=v end})
    MovementBox:AddToggle("Noclip",{Text=T("noclip"),Default=false,Callback=function(v) CFG.Noclip=v end})

    local FlightBox = Tabs.Character:AddRightGroupbox("Flight")
    FlightBox:AddToggle("Fly",{Text=T("fly"),Default=false,Callback=function(v)
        CFG.Fly=v
        if not v then
            CFG.FlyUp=false; CFG.FlyDown=false
            pcall(function() if HRP:FindFirstChild("_FlyBV") then HRP._FlyBV:Destroy() end; if HRP:FindFirstChild("_FlyBG") then HRP._FlyBG:Destroy() end end)
        end
    end})
    FlightBox:AddSlider("FlySpeed",{Text=T("flySpeed"),Default=60,Min=0,Max=300,Rounding=0,Callback=function(v) CFG.FlySpeed=v end})
    FlightBox:AddDivider()
    FlightBox:AddLabel("📱 " .. T("flyMobile"))
    FlightBox:AddToggle("FlyUp",{Text="⬆️ "..T("flyUp"),Default=false,Tooltip="Tap to fly up (mobile)",Callback=function(v) CFG.FlyUp=v end})
    FlightBox:AddToggle("FlyDown",{Text="⬇️ "..T("flyDown"),Default=false,Tooltip="Tap to fly down (mobile)",Callback=function(v) CFG.FlyDown=v end})

    local CameraBox = Tabs.Character:AddRightGroupbox("Camera")
    CameraBox:AddSlider("FOV",{Text=T("fov"),Default=70,Min=10,Max=120,Rounding=0,Callback=function(v) CFG.FOV=v; Camera.FieldOfView=v end})

    local SurvivalBox = Tabs.Character:AddRightGroupbox("Survivability")
    SurvivalBox:AddToggle("GodMode",{Text=T("godMode"),Default=false,Callback=function(v) CFG.GodMode=v end})
    SurvivalBox:AddToggle("NoReset",{Text=T("noReset"),Default=false,Callback=function(v) CFG.NoReset=v; pcall(function() StarterGui:SetCore("ResetButtonCallback",not v) end) end})
    SurvivalBox:AddToggle("Invisible",{
        Text=T("invisible"),Default=false,
        Callback=function(v)
            CFG.Invisible=v
            pcall(function()
                if v then
                    for _, part in ipairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.Transparency=1
                        elseif part:IsA("Decal") or part:IsA("Texture") then part.Transparency=1
                        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then part.Enabled=false end
                    end
                    for _, acc in ipairs(Character:GetChildren()) do
                        if acc:IsA("Accessory") then local h=acc:FindFirstChild("Handle"); if h then h.Transparency=1 end end
                    end
                else
                    for _, part in ipairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then part.Transparency=0
                        elseif part:IsA("Decal") or part:IsA("Texture") then part.Transparency=0
                        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then part.Enabled=true end
                    end
                    for _, acc in ipairs(Character:GetChildren()) do
                        if acc:IsA("Accessory") then local h=acc:FindFirstChild("Handle"); if h then h.Transparency=0 end end
                    end
                    HRP.Transparency=1
                end
            end)
        end,
    })
    SurvivalBox:AddDivider()
    SurvivalBox:AddButton({Text=T("forceReset"),Func=function() pcall(function() Humanoid.Health=0 end) end})
    SurvivalBox:AddButton({Text=T("respawn"),Func=function() pcall(function() LocalPlayer:LoadCharacter() end) end})
    SurvivalBox:AddButton({Text=T("freeze"),Func=function()
        pcall(function() HRP.Anchored=not HRP.Anchored; Library:Notify({Title=T("freeze"),Description=HRP.Anchored and T("frozen") or T("unfrozen"),Time=2}) end)
    end})
end

--// ═══════════════════════════════════════════
--//  TAB: COMBAT
--// ═══════════════════════════════════════════

do
    local AimBox = Tabs.Combat:AddLeftGroupbox("Aim Assist")
    AimBox:AddToggle("Aimbot",{Text=T("aimbot"),Default=false,Callback=function(v) CFG.Aimbot=v end})
    AimBox:AddToggle("AutoAim",{Text=T("autoAim"),Default=false,Tooltip="Mobile: no RMB needed",Callback=function(v) CFG.AutoAim=v end})
    AimBox:AddSlider("AimFOV",{Text=T("fovRadius"),Default=250,Min=10,Max=900,Rounding=0,Callback=function(v) CFG.AimFOV=v end})
    AimBox:AddSlider("AimSmooth",{Text=T("smoothing"),Default=5,Min=1,Max=50,Rounding=1,Callback=function(v) CFG.AimSmooth=v end})
    AimBox:AddDropdown("AimBone",{Values={"Head","HumanoidRootPart","UpperTorso","LowerTorso"},Default="Head",Text=T("aimbotTarget"),Callback=function(v) CFG.AimBone=v end})
    AimBox:AddToggle("ShowFOV",{Text=T("showFov"),Default=false,Callback=function(v) CFG.ShowFOV=v end})

    local MeleeBox = Tabs.Combat:AddLeftGroupbox("Kill Aura")
    MeleeBox:AddToggle("KillAura",{Text=T("killAura"),Default=false,Risky=true,Callback=function(v) CFG.KillAura=v end})
    MeleeBox:AddSlider("AuraRange",{Text=T("auraRange"),Default=15,Min=1,Max=60,Rounding=0,Callback=function(v) CFG.AuraRange=v end})
    MeleeBox:AddSlider("AuraDelay",{Text=T("auraDelay"),Default=0.15,Min=0.05,Max=1,Rounding=2,Suffix="s",Callback=function(v) CFG.AuraDelay=v end})
    MeleeBox:AddDivider()
    MeleeBox:AddToggle("HitboxExp",{Text=T("hitbox"),Default=false,Callback=function(v)
        CFG.HitboxExp=v
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then local h=p.Character:FindFirstChild("HumanoidRootPart"); if h then h.Size=v and Vector3.new(CFG.HitboxSize,CFG.HitboxSize,CFG.HitboxSize) or Vector3.new(2,2,1); h.Transparency=v and 0.5 or 1 end end end
    end})
    MeleeBox:AddSlider("HitboxSize",{Text=T("hitboxScale"),Default=5,Min=1,Max=30,Rounding=0,Callback=function(v) CFG.HitboxSize=v end})

    local BombBox = Tabs.Combat:AddRightGroupbox("Bomb Pass")
    BombBox:AddToggle("AutoBomb",{Text=T("autoBomb"),Default=false,Risky=true,Callback=function(v) CFG.AutoBomb=v end})
    BombBox:AddInput("BombKeywords",{Default="bomb,бомба,tnt,dynamite,explosive",Text=T("bombKeywords"),Finished=false,Callback=function(v) CFG.BombKeywords=v end})
    BombBox:AddDivider()
    BombBox:AddDropdown("BombExclude",{Values=GetPlayerNames(),Default=nil,Multi=true,Text=T("bombExclude"),Tooltip="Will NOT receive bomb",Callback=function(v) CFG.BombExcluded=v end})
    BombBox:AddButton({Text="🔄 Refresh Players",Func=function() Options.BombExclude:SetValues(GetPlayerNames()); Library:Notify({Title="Bomb",Description="Refreshed!",Time=2}) end})
    Players.PlayerAdded:Connect(function() task.wait(1); pcall(function() Options.BombExclude:SetValues(GetPlayerNames()) end) end)
    Players.PlayerRemoving:Connect(function() task.wait(1); pcall(function() Options.BombExclude:SetValues(GetPlayerNames()) end) end)

    local InfoBox = Tabs.Combat:AddRightGroupbox("Info")
    InfoBox:AddButton({Text=T("nearestPlayer"),Func=function()
        local closest,dist=nil,math.huge
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then local d=(HRP.Position-p.Character.HumanoidRootPart.Position).Magnitude; if d<dist then dist=d; closest=p end end end
        if closest then Library:Notify({Title=T("nearestPlayer"),Description=closest.DisplayName.." — "..math.floor(dist).." studs",Time=4})
        else Library:Notify({Title="Error",Description=T("noPlayersNear"),Time=3}) end
    end})
end

--// ═══════════════════════════════════════════
--//  TAB: TELEPORT
--// ═══════════════════════════════════════════

do
    local PlayerTPBox = Tabs.Teleport:AddLeftGroupbox("Player Transport")
    PlayerTPBox:AddInput("TpTarget",{Default="",Text=T("targetName"),Placeholder="Player name...",Finished=false,Callback=function(v) CFG.TpTarget=v end})
    PlayerTPBox:AddButton({Text=T("tpToTarget"),Func=function()
        local query=CFG.TpTarget:lower()
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LocalPlayer and (p.Name:lower():find(query) or p.DisplayName:lower():find(query)) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                HRP.CFrame=p.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,4); Library:Notify({Title=T("teleport"),Description=T("movedTo").." "..p.DisplayName,Time=3}); return
            end
        end
        Library:Notify({Title="Error",Description=T("notFound"),Time=3})
    end})
    PlayerTPBox:AddButton({Text=T("randomPlayer"),Func=function()
        local pool={}; for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(pool,p) end end
        if #pool==0 then Library:Notify({Title="Error",Description=T("noPlayers"),Time=3}); return end
        local t=pool[math.random(#pool)]; HRP.CFrame=t.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,4); Library:Notify({Title=T("randomPlayer"),Description=T("movedTo").." "..t.DisplayName,Time=3})
    end})
    PlayerTPBox:AddButton({Text=T("tpSpawn"),Func=function() pcall(function() local sp=Workspace:FindFirstChildOfClass("SpawnLocation"); if sp then HRP.CFrame=sp.CFrame+Vector3.new(0,5,0) else HRP.CFrame=CFrame.new(0,50,0) end end) end})
    PlayerTPBox:AddButton({Text=T("tpForward"),Func=function() pcall(function() HRP.CFrame=HRP.CFrame+HRP.CFrame.LookVector*100 end) end})

    local WaypointBox = Tabs.Teleport:AddRightGroupbox("Waypoints")
    WaypointBox:AddButton({Text=T("savePos"),Func=function() CFG.SavedCF=HRP.CFrame; Library:Notify({Title=T("saved"),Description=T("posStored"),Time=2}) end})
    WaypointBox:AddButton({Text=T("loadPos"),Func=function() if CFG.SavedCF then HRP.CFrame=CFG.SavedCF; Library:Notify({Title=T("loaded"),Description=T("posRestored"),Time=2}) else Library:Notify({Title="Error",Description=T("nothingSaved"),Time=2}) end end})
    WaypointBox:AddToggle("ClickTP",{Text=T("clickTp"),Default=false,Callback=function(v) CFG.ClickTP=v end})
end

--// ═══════════════════════════════════════════
--//  TAB: ESP
--// ═══════════════════════════════════════════

do
    local RenderBox = Tabs.ESP:AddLeftGroupbox("Rendering")
    RenderBox:AddToggle("ESP",{Text=T("enableEsp"),Default=false,Callback=function(v) CFG.ESP=v end})
    RenderBox:AddToggle("BoxESP",{Text=T("boundBox"),Default=false,Callback=function(v) CFG.BoxESP=v end})
    RenderBox:AddToggle("NameESP",{Text=T("nameTags"),Default=false,Callback=function(v) CFG.NameESP=v end})
    RenderBox:AddToggle("HealthESP",{Text=T("healthBars"),Default=false,Callback=function(v) CFG.HealthESP=v end})
    RenderBox:AddToggle("DistESP",{Text=T("distTags"),Default=false,Callback=function(v) CFG.DistESP=v end})
    RenderBox:AddToggle("TracerESP",{Text=T("tracers"),Default=false,Callback=function(v) CFG.TracerESP=v end})
    RenderBox:AddToggle("ChamsESP",{Text=T("chams"),Default=false,Callback=function(v)
        CFG.ChamsESP=v
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer and p.Character then
            local ex=p.Character:FindFirstChild("_Highlight")
            if v and not ex then local h=Instance.new("Highlight"); h.Name="_Highlight"; h.FillColor=Color3.fromRGB(130,80,220); h.FillTransparency=0.4; h.OutlineColor=Color3.fromRGB(255,255,255); h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Parent=p.Character
            elseif not v and ex then ex:Destroy() end
        end end
    end})
    local FilterBox = Tabs.ESP:AddRightGroupbox("Filters")
    FilterBox:AddToggle("TeamCheck",{Text=T("teamFilter"),Default=false,Callback=function(v) CFG.TeamCheck=v end})
end

--// ═══════════════════════════════════════════
--//  TAB: FUN
--// ═══════════════════════════════════════════

do
    -- EMOTES
    local EmoteBox = Tabs.Fun:AddLeftGroupbox("🎭 Emotes")
    EmoteBox:AddDropdown("EmoteSelect",{Values=EmoteNames,Default="Wave",Text="Select Emote",Callback=function(v) end})
    EmoteBox:AddButton({Text="▶️ Play Emote",Func=function()
        pcall(function()
            local selected=Options.EmoteSelect.Value; local animId=EmoteList[selected]; if not animId then return end
            for _,track in ipairs(Humanoid:GetPlayingAnimationTracks()) do track:Stop() end
            local anim=Instance.new("Animation"); anim.AnimationId=animId
            local track=Humanoid:LoadAnimation(anim); track:Play(); track.Priority=Enum.AnimationPriority.Action
            _G._EplismaEmote=track; Library:Notify({Title=T("emotes"),Description="Playing: "..selected,Time=3})
        end)
    end})
    EmoteBox:AddButton({Text="⏹️ Stop Emote",Func=function()
        pcall(function() if _G._EplismaEmote then _G._EplismaEmote:Stop(); _G._EplismaEmote=nil end
            for _,track in ipairs(Humanoid:GetPlayingAnimationTracks()) do track:Stop() end end)
    end})
    EmoteBox:AddDivider()
    for _,emoteName in ipairs({"Wave","Dance 1","Dance 2","Dance 3","Laugh","Cheer","Point"}) do
        EmoteBox:AddButton({Text="🎭 "..emoteName,Func=function()
            pcall(function()
                for _,track in ipairs(Humanoid:GetPlayingAnimationTracks()) do track:Stop() end
                local anim=Instance.new("Animation"); anim.AnimationId=EmoteList[emoteName]
                local track=Humanoid:LoadAnimation(anim); track:Play(); track.Priority=Enum.AnimationPriority.Action; _G._EplismaEmote=track
            end)
        end})
    end

    -- MUSIC
    local MusicBox = Tabs.Fun:AddRightGroupbox("🎵 Music")
    MusicBox:AddDropdown("MusicSelect",{Values=MusicNames,Default="None (Stop)",Text="Select Song",Searchable=true,Callback=function(v) end})
    MusicBox:AddSlider("MusicVolume",{Text="Volume",Default=50,Min=0,Max=100,Rounding=0,Suffix="%",Callback=function(v) if CFG.MusicPlaying then CFG.MusicPlaying.Volume=v/100 end end})
    MusicBox:AddSlider("MusicPitch",{Text="Pitch/Speed",Default=100,Min=10,Max=300,Rounding=0,Suffix="%",Callback=function(v) if CFG.MusicPlaying then CFG.MusicPlaying.PlaybackSpeed=v/100 end end})
    MusicBox:AddButton({Text="▶️ Play Song",Func=function()
        pcall(function()
            if CFG.MusicPlaying then CFG.MusicPlaying:Stop(); CFG.MusicPlaying:Destroy(); CFG.MusicPlaying=nil end
            local selected=Options.MusicSelect.Value; local soundId=MusicList[selected]
            if not soundId or soundId==0 then Library:Notify({Title=T("music"),Description="Music stopped",Time=2}); return end
            local sound=Instance.new("Sound"); sound.SoundId="rbxassetid://"..soundId
            sound.Volume=(Options.MusicVolume and Options.MusicVolume.Value or 50)/100
            sound.PlaybackSpeed=(Options.MusicPitch and Options.MusicPitch.Value or 100)/100
            sound.Looped=true; sound.Name="_EplismaMusic"; sound.Parent=HRP; sound:Play(); CFG.MusicPlaying=sound
            Library:Notify({Title=T("music"),Description="Now playing: "..selected,Time=3})
        end)
    end})
    MusicBox:AddButton({Text="⏹️ Stop Music",Func=function()
        if CFG.MusicPlaying then CFG.MusicPlaying:Stop(); CFG.MusicPlaying:Destroy(); CFG.MusicPlaying=nil end
        pcall(function() for _,s in ipairs(HRP:GetChildren()) do if s:IsA("Sound") and s.Name=="_EplismaMusic" then s:Stop(); s:Destroy() end end end)
        Library:Notify({Title=T("music"),Description="Music stopped",Time=2})
    end})
    MusicBox:AddDivider()
    MusicBox:AddInput("CustomMusicID",{Default="",Text="Custom Sound ID",Placeholder="Roblox Sound ID...",Numeric=true,Finished=true,Callback=function(v)
        pcall(function()
            if CFG.MusicPlaying then CFG.MusicPlaying:Stop(); CFG.MusicPlaying:Destroy() end
            local id=tonumber(v); if not id or id==0 then return end
            local sound=Instance.new("Sound"); sound.SoundId="rbxassetid://"..id
            sound.Volume=(Options.MusicVolume and Options.MusicVolume.Value or 50)/100
            sound.Looped=true; sound.Name="_EplismaMusic"; sound.Parent=HRP; sound:Play(); CFG.MusicPlaying=sound
            Library:Notify({Title=T("music"),Description="Playing: "..id,Time=3})
        end)
    end})
end

--// ═══════════════════════════════════════════
--//  TAB: ENVIRONMENT
--// ═══════════════════════════════════════════

do
    local LightBox = Tabs.Environment:AddLeftGroupbox("Lighting")
    LightBox:AddToggle("Fullbright",{Text=T("fullbright"),Default=false,Callback=function(v) CFG.Fullbright=v; if v then Lighting.Brightness=2; Lighting.GlobalShadows=false; Lighting.OutdoorAmbient=Color3.fromRGB(200,200,200); Lighting.Ambient=Color3.fromRGB(200,200,200) else Lighting.Brightness=1; Lighting.GlobalShadows=true; Lighting.OutdoorAmbient=Color3.fromRGB(128,128,128); Lighting.Ambient=Color3.fromRGB(0,0,0) end end})
    LightBox:AddToggle("NoFog",{Text=T("noFog"),Default=false,Callback=function(v) CFG.NoFog=v; Lighting.FogEnd=v and 9999999 or 100000 end})
    LightBox:AddToggle("TimeLock",{Text=T("timeLock"),Default=false,Callback=function(v) CFG.CustomTime=v end})
    LightBox:AddSlider("ClockTime",{Text=T("clockTime"),Default=14,Min=0,Max=24,Rounding=1,Callback=function(v) CFG.TimeVal=v; if CFG.CustomTime then Lighting.ClockTime=v end end})

    local CleanBox = Tabs.Environment:AddRightGroupbox("Cleanup")
    CleanBox:AddButton({Text=T("removeEffects"),Func=function()
        local n=0; for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("Atmosphere") or e:IsA("BloomEffect") or e:IsA("BlurEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("SunRaysEffect") then e:Destroy(); n+=1 end end
        Library:Notify({Title="Cleanup",Description=n.." "..T("effectsRemoved"),Time=2})
    end})
    CleanBox:AddButton({Text=T("removeParticles"),Func=function()
        local n=0; for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("ParticleEmitter") or o:IsA("Fire") or o:IsA("Smoke") or o:IsA("Sparkles") then o:Destroy(); n+=1 end end
        Library:Notify({Title="Cleanup",Description=n.." removed",Time=2})
    end})
    CleanBox:AddButton({Text=T("removeDecals"),Func=function()
        local n=0; for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("Decal") or o:IsA("Texture") then o:Destroy(); n+=1 end end
        Library:Notify({Title="Cleanup",Description=n.." removed",Time=2})
    end})
    CleanBox:AddButton({Text=T("removeSounds"),Func=function()
        local n=0; for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("Sound") and o.Name~="_EplismaMusic" then o:Stop(); o:Destroy(); n+=1 end end
        Library:Notify({Title="Cleanup",Description=n.." removed",Time=2})
    end})
    CleanBox:AddButton({Text=T("removeBlur"),Func=function()
        local n=0; for _,obj in ipairs(Lighting:GetChildren()) do if obj:IsA("BlurEffect") then obj:Destroy(); n+=1 end end
        Library:Notify({Title="Blur",Description=n.." removed",Time=2})
    end})
end

--// ═══════════════════════════════════════════
--//  TAB: UTILITIES (with Tool Grabber)
--// ═══════════════════════════════════════════

do
    local ProtectBox = Tabs.Utilities:AddLeftGroupbox("Protection")
    ProtectBox:AddToggle("AntiAFK",{Text=T("antiAfk"),Default=false,Callback=function(v) CFG.AntiAFK=v end})
    ProtectBox:AddToggle("AntiKick",{Text=T("antiKick"),Default=false,Callback=function(v) CFG.AntiKick=v end})
    ProtectBox:AddToggle("AntiBlur",{Text=T("blurEnabled"),Default=false,Callback=function(v) CFG.AntiBlur=v; if v then for _,obj in ipairs(Lighting:GetChildren()) do if obj:IsA("BlurEffect") then obj:Destroy() end end end end})

    local ActionBox = Tabs.Utilities:AddLeftGroupbox("Actions")
    ActionBox:AddToggle("Spin",{Text=T("spin"),Default=false,Callback=function(v) CFG.Spin=v end})
    ActionBox:AddSlider("SpinSpeed",{Text=T("spinSpeed"),Default=10,Min=1,Max=50,Rounding=0,Callback=function(v) CFG.SpinSpeed=v end})
    ActionBox:AddDivider()
    ActionBox:AddButton({Text=T("spawnPlatform"),Func=function()
        local p=Instance.new("Part"); p.Size=Vector3.new(20,1,20); p.CFrame=HRP.CFrame*CFrame.new(0,-4,0); p.Anchored=true; p.BrickColor=BrickColor.new("Bright violet"); p.Material=Enum.Material.Neon; p.Transparency=0.3; p.Parent=Workspace
    end})
    ActionBox:AddButton({Text=T("forceSit"),Func=function() pcall(function() Humanoid.Sit=true end) end})
    ActionBox:AddButton({Text=T("forceJump"),Func=function() pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end})
    ActionBox:AddButton({Text=T("copyPos"),Func=function()
        local pos=HRP.Position; local txt=string.format("%.1f, %.1f, %.1f",pos.X,pos.Y,pos.Z)
        pcall(function() setclipboard(txt) end); Library:Notify({Title=T("copied"),Description=txt,Time=3})
    end})
    ActionBox:AddButton({Text=T("copyLink"),Func=function()
        local link="https://www.roblox.com/games/"..game.PlaceId
        pcall(function() setclipboard(link) end); Library:Notify({Title=T("copied"),Description=link,Time=3})
    end})

    -- ═══════════════════════════════════════
    --  TOOL GRABBER
    -- ═══════════════════════════════════════

    local ToolBox = Tabs.Utilities:AddLeftGroupbox("🔫 Tool Grabber")

    ToolBox:AddInput("ToolName",{Default="",Text="Tool Name",Placeholder="Enter tool name...",Finished=false,Callback=function(v) end})

    -- Main give button (all methods)
    ToolBox:AddButton({
        Text = "⚡ Give Tool (All Methods)",
        Tooltip = "Tries 7 different methods to give you the tool",
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then
                Library:Notify({Title="Error",Description="Enter a tool name!",Time=3})
                return
            end

            local found, results, foundName = GiveToolAllMethods(toolName)

            local desc = "Tool: " .. foundName .. "\n"
            for _, r in ipairs(results) do desc = desc .. r .. "\n" end

            Library:Notify({
                Title = found and "🔫 Tool Grabbed!" or "⚠️ Not Found Locally",
                Description = desc,
                Time = 6,
            })
        end,
    })

    ToolBox:AddDivider()

    -- Individual method buttons
    ToolBox:AddButton({
        Text = "📋 Method 1: Clone",
        Tooltip = "Simple clone to backpack",
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then Library:Notify({Title="Error",Description="Enter name!",Time=2}); return end
            local allTools = GetAllTools()
            local found = false
            for _, t in ipairs(allTools) do
                if t.name:lower():find(toolName:lower()) then
                    local ok = pcall(function() GiveMethod1(t.tool) end)
                    Library:Notify({Title="Clone Method",Description=(ok and "✅ Given: " or "❌ Failed: ")..t.name,Time=3})
                    found = true; break
                end
            end
            if not found then Library:Notify({Title="❌",Description="Tool not found in game!",Time=3}) end
        end,
    })

    ToolBox:AddButton({
        Text = "🔄 Method 2: Parent Move",
        Tooltip = "Moves tool instance directly to your backpack",
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then Library:Notify({Title="Error",Description="Enter name!",Time=2}); return end
            local allTools = GetAllTools()
            local found = false
            for _, t in ipairs(allTools) do
                if t.name:lower():find(toolName:lower()) then
                    local ok = pcall(function() GiveMethod2(t.tool) end)
                    Library:Notify({Title="Parent Move",Description=(ok and "✅ Moved: " or "❌ Failed: ")..t.name,Time=3})
                    found = true; break
                end
            end
            if not found then Library:Notify({Title="❌",Description="Tool not found!",Time=3}) end
        end,
    })

    ToolBox:AddButton({
        Text = "🎮 Method 3: Equip Direct",
        Tooltip = "Clones and equips using Humanoid:EquipTool",
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then Library:Notify({Title="Error",Description="Enter name!",Time=2}); return end
            local allTools = GetAllTools()
            local found = false
            for _, t in ipairs(allTools) do
                if t.name:lower():find(toolName:lower()) then
                    local ok = pcall(function() GiveMethod6(t.tool) end)
                    Library:Notify({Title="Equip Method",Description=(ok and "✅ Equipped: " or "❌ Failed: ")..t.name,Time=3})
                    found = true; break
                end
            end
            if not found then Library:Notify({Title="❌",Description="Tool not found!",Time=3}) end
        end,
    })

    ToolBox:AddButton({
        Text = "👆 Method 4: Touch Simulate",
        Tooltip = "Places tool near you and simulates touch pickup",
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then Library:Notify({Title="Error",Description="Enter name!",Time=2}); return end
            local allTools = GetAllTools()
            local found = false
            for _, t in ipairs(allTools) do
                if t.name:lower():find(toolName:lower()) then
                    local ok = pcall(function() GiveMethod7(t.tool) end)
                    Library:Notify({Title="Touch Method",Description=(ok and "✅ Touched: " or "❌ Failed: ")..t.name,Time=3})
                    found = true; break
                end
            end
            if not found then Library:Notify({Title="❌",Description="Tool not found!",Time=3}) end
        end,
    })

    ToolBox:AddButton({
        Text = "📡 Method 5: Fire Remotes",
        Tooltip = "Fires game remote events that give tools (game specific)",
        Risky = true,
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then Library:Notify({Title="Error",Description="Enter name!",Time=2}); return end
            local ok = pcall(function() GiveMethod4(toolName) end)
            Library:Notify({Title="Remote Method",Description=ok and "✅ Remotes fired for: "..toolName or "❌ Failed",Time=3})
        end,
    })

    ToolBox:AddButton({
        Text = "🔗 Method 6: Bindable Events",
        Tooltip = "Triggers BindableEvents related to giving tools",
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then Library:Notify({Title="Error",Description="Enter name!",Time=2}); return end
            local ok = pcall(function() GiveMethod5(toolName) end)
            Library:Notify({Title="Bindable Method",Description=ok and "✅ Bindables fired: "..toolName or "❌ Failed",Time=3})
        end,
    })

    ToolBox:AddButton({
        Text = "🌐 Method 7: Steal from Player",
        Tooltip = "Steals tool from another player's character",
        Func = function()
            local toolName = Options.ToolName.Value
            if toolName == "" then Library:Notify({Title="Error",Description="Enter name!",Time=2}); return end
            local found = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    pcall(function()
                        -- Check equipped
                        if p.Character then
                            for _, obj in ipairs(p.Character:GetChildren()) do
                                if obj:IsA("Tool") and obj.Name:lower():find(toolName:lower()) then
                                    local cloned = obj:Clone()
                                    cloned.Parent = LocalPlayer.Backpack
                                    Library:Notify({Title="✅ Stolen!",Description=obj.Name.." from "..p.Name,Time=4})
                                    found = true
                                end
                            end
                        end
                        -- Check backpack
                        if not found and p.Backpack then
                            for _, obj in ipairs(p.Backpack:GetChildren()) do
                                if obj:IsA("Tool") and obj.Name:lower():find(toolName:lower()) then
                                    local cloned = obj:Clone()
                                    cloned.Parent = LocalPlayer.Backpack
                                    Library:Notify({Title="✅ Stolen!",Description=obj.Name.." from "..p.Name.."'s bag",Time=4})
                                    found = true
                                end
                            end
                        end
                    end)
                    if found then break end
                end
            end
            if not found then Library:Notify({Title="❌",Description="Not found on any player",Time=3}) end
        end,
    })

    ToolBox:AddDivider()

    -- Dropdown quick select
    ToolBox:AddDropdown("ToolDropdown",{Values=GetAllToolNames(),Default=nil,Text="Quick Select",Searchable=true,Tooltip="Select found tool",Callback=function(v) end})
    ToolBox:AddButton({Text="✅ Give Selected",Func=function()
        local selected = Options.ToolDropdown and Options.ToolDropdown.Value
        if not selected or selected == "No tools found" then Library:Notify({Title="Error",Description="Select a tool!",Time=3}); return end
        local _, results, name = GiveToolAllMethods(selected)
        Library:Notify({Title="Given: "..name,Description=table.concat(results,"\n"),Time=5})
    end})
    ToolBox:AddButton({Text="🔄 Refresh List",Func=function()
        pcall(function() Options.ToolDropdown:SetValues(GetAllToolNames()) end)
        Library:Notify({Title="Tools",Description="List refreshed!",Time=2})
    end})
    ToolBox:AddDivider()
    ToolBox:AddButton({Text="📋 Show All Tools",Func=function()
        local tools = GetAllTools(); local display = ""
        for i=1, math.min(#tools,15) do display = display..tools[i].name.." ["..tools[i].source.."]\n" end
        if #tools>15 then display=display.."... and "..(#tools-15).." more" end
        if #tools==0 then display="No tools found anywhere!" end
        Library:Notify({Title="📋 "..#tools.." tools found",Description=display,Time=10})
    end})
    ToolBox:AddButton({Text="⚡ Give ALL Tools",DoubleClick=true,Risky=true,Func=function()
        local count=0; local tools=GetAllTools()
        for _,t in ipairs(tools) do pcall(function() local c=t.tool:Clone(); c.Parent=LocalPlayer.Backpack; count+=1 end) end
        Library:Notify({Title="⚡ Give ALL",Description=count.." tools given!",Time=4})
    end})
    ToolBox:AddButton({Text="🗑️ Clear My Tools",Func=function()
        local count=0
        pcall(function() for _,tool in ipairs(LocalPlayer.Backpack:GetChildren()) do if tool:IsA("Tool") then tool:Destroy(); count+=1 end end end)
        pcall(function() for _,tool in ipairs(Character:GetChildren()) do if tool:IsA("Tool") then tool:Destroy(); count+=1 end end end)
        Library:Notify({Title="Cleared",Description=count.." tools removed",Time=2})
    end})

    -- Chat + Server
    local ChatBox = Tabs.Utilities:AddRightGroupbox("Chat")
    ChatBox:AddInput("SpamMsg",{Default="",Text=T("spamMsg"),Placeholder="Message...",Finished=false,Callback=function(v) CFG.SpamMsg=v end})
    ChatBox:AddSlider("SpamDelay",{Text=T("spamInterval"),Default=2,Min=1,Max=10,Rounding=1,Suffix="s",Callback=function(v) CFG.SpamDelay=v end})
    ChatBox:AddToggle("ChatSpam",{Text=T("chatSpam"),Default=false,Risky=true,Callback=function(v) CFG.ChatSpam=v end})

    local ServerBox = Tabs.Utilities:AddRightGroupbox("Server")
    ServerBox:AddButton({Text=T("rejoin"),Func=function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LocalPlayer) end})
    ServerBox:AddButton({Text=T("serverHop"),Func=function()
        task.spawn(function()
            local ok,data=pcall(function() return HttpService:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))) end)
            if not ok then Library:Notify({Title="Error",Description="Failed",Time=3}); return end
            for _,sv in ipairs(data.data) do if sv.id~=game.JobId and sv.playing<sv.maxPlayers then TeleportService:TeleportToPlaceInstance(game.PlaceId,sv.id,LocalPlayer); return end end
            Library:Notify({Title="Error",Description="No servers",Time=3})
        end)
    end})
    ServerBox:AddButton({Text=T("serverInfo"),Func=function()
        Library:Notify({Title=T("serverInfo"),Description=string.format("Players: %d/%d\nPlace: %d\nPing: ~%dms",#Players:GetPlayers(),Players.MaxPlayers,game.PlaceId,math.floor(LocalPlayer:GetNetworkPing()*1000)),Time=6})
    end})
    ServerBox:AddButton({Text=T("copyId").." ("..LocalPlayer.UserId..")",Func=function()
        pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end); Library:Notify({Title=T("copied"),Description=tostring(LocalPlayer.UserId),Time=2})
    end})

    local GfxBox = Tabs.Utilities:AddRightGroupbox("Graphics")
    GfxBox:AddButton({Text=T("removeAllPost"),Func=function()
        local n=0; for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("PostEffect") or e:IsA("Atmosphere") then e:Destroy(); n+=1 end end
        Library:Notify({Title="Cleanup",Description=n.." removed",Time=2})
    end})
    GfxBox:AddButton({Text=T("lowGraphics"),Func=function()
        pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end); Lighting.GlobalShadows=false
        for _,e in ipairs(Lighting:GetChildren()) do if e:IsA("PostEffect") or e:IsA("Atmosphere") then e.Enabled=false end end
        for _,o in ipairs(Workspace:GetDescendants()) do if o:IsA("ParticleEmitter") or o:IsA("Trail") then o.Enabled=false end end
        Library:Notify({Title="Graphics",Description="Low mode ON",Time=2})
    end})
end

--// ═══════════════════════════════════════════
--//  TAB: SETTINGS
--// ═══════════════════════════════════════════

do
    local MenuBox = Tabs.Settings:AddLeftGroupbox("Menu")
    MenuBox:AddToggle("KeybindMenuOpen",{Default=false,Text="Open Keybind Menu",Callback=function(v) Library.KeybindFrame.Visible=v end})
    MenuBox:AddToggle("ShowCustomCursor",{Text="Custom Cursor",Default=not IsMobile,Callback=function(v) Library.ShowCustomCursor=v end})
    MenuBox:AddDivider()
    MenuBox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind",{Default="RightControl",NoUI=true,Text="Menu keybind"})

    local LangBox = Tabs.Settings:AddLeftGroupbox("Language")
    LangBox:AddButton({Text="🇬🇧 English",Func=function() Lang="EN"; Library:Notify({Title="Language",Description="English. Rejoin to apply.",Time=4}) end})
    LangBox:AddButton({Text="🇷🇺 Русский",Func=function() Lang="RU"; Library:Notify({Title="Язык",Description="Русский. Перезайдите.",Time=4}) end})

    local InfoBox = Tabs.Settings:AddLeftGroupbox("Player Info")
    InfoBox:AddLabel("Name: "..LocalPlayer.Name)
    InfoBox:AddLabel("Display: "..LocalPlayer.DisplayName)
    InfoBox:AddLabel("ID: "..LocalPlayer.UserId)
    InfoBox:AddLabel("Mobile: "..tostring(IsMobile))

    local AboutBox = Tabs.Settings:AddLeftGroupbox("About")
    AboutBox:AddLabel("Eplisma v3.0")
    AboutBox:AddLabel("Developer: Frost")
    AboutBox:AddLabel("Telegram: @Jokerfros")

    local DangerBox = Tabs.Settings:AddLeftGroupbox("Danger Zone")
    DangerBox:AddButton({Text=T("destroy"),DoubleClick=true,Func=function()
        pcall(function() _G._CleanESP() end); pcall(function() _G._FOV:Remove() end)
        pcall(function() if HRP:FindFirstChild("_FlyBV") then HRP._FlyBV:Destroy() end; if HRP:FindFirstChild("_FlyBG") then HRP._FlyBG:Destroy() end end)
        if CFG.MusicPlaying then pcall(function() CFG.MusicPlaying:Stop(); CFG.MusicPlaying:Destroy() end) end
        CFG.Fly=false; CFG.Noclip=false; CFG.ESP=false; CFG.Aimbot=false; CFG.AutoBomb=false; CFG.KillAura=false
        Library:Unload()
    end})

    Library.ToggleKeybind=Options.MenuKeybind
    ThemeManager:SetLibrary(Library); SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings(); SaveManager:SetIgnoreIndexes({"MenuKeybind"})
    ThemeManager:SetFolder("Eplisma"); SaveManager:SetFolder("Eplisma/config")
    SaveManager:BuildConfigSection(Tabs.Settings); ThemeManager:ApplyToTab(Tabs.Settings)
    SaveManager:LoadAutoloadConfig()
end

--// ═══════════════════════════════════════════
--//  DRAWING
--// ═══════════════════════════════════════════

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness=1.5; FOVCircle.NumSides=64; FOVCircle.Radius=CFG.AimFOV
FOVCircle.Filled=false; FOVCircle.Visible=false; FOVCircle.ZIndex=999
FOVCircle.Transparency=0.75; FOVCircle.Color=Color3.fromRGB(130,80,220)
_G._FOV=FOVCircle

local ESPCache={}
local function MkDraw(cls,props) local d=Drawing.new(cls); for k,v in pairs(props) do d[k]=v end; return d end

local function AddESP(plr)
    if plr==LocalPlayer or ESPCache[plr] then return end
    ESPCache[plr]={
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
_G._CleanESP=function() for p in pairs(ESPCache) do DelESP(p) end end

for _,p in ipairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP); Players.PlayerRemoving:Connect(DelESP)

--// ═══════════════════════════════════════════
--//  RENDER LOOP
--// ═══════════════════════════════════════════

RunService.RenderStepped:Connect(function()
    local mp=UserInputService:GetMouseLocation()
    FOVCircle.Visible=CFG.ShowFOV; FOVCircle.Radius=CFG.AimFOV; FOVCircle.Position=mp

    -- Aimbot
    if CFG.Aimbot then
        local shouldAim=CFG.AutoAim or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if shouldAim then
            local t=FindTarget()
            if t and t.Character then
                local part=t.Character:FindFirstChild(CFG.AimBone) or t.Character:FindFirstChild("Head") or t.Character:FindFirstChild("HumanoidRootPart")
                if part then Camera.CFrame=Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position,part.Position),1/math.max(CFG.AimSmooth,0.1)) end
            end
        end
    end

    -- ESP
    local vp=Camera.ViewportSize
    for plr,esp in pairs(ESPCache) do
        local c=plr.Character; local hum=c and c:FindFirstChildOfClass("Humanoid")
        local hrp=c and c:FindFirstChild("HumanoidRootPart"); local head=c and c:FindFirstChild("Head")
        if not(c and hum and hum.Health>0 and hrp and head and CFG.ESP) or IsAlly(plr) then HideAll(esp); continue end
        local wp,vis=Camera:WorldToViewportPoint(hrp.Position)
        local hp=Camera:WorldToViewportPoint(head.Position+Vector3.new(0,.5,0))
        local fp=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
        if not vis then HideAll(esp); continue end
        local bH=math.abs(hp.Y-fp.Y); local bW=bH*0.55; local cx=wp.X
        esp.Box.Visible=CFG.BoxESP; esp.Box.Size=Vector2.new(bW,bH); esp.Box.Position=Vector2.new(cx-bW*.5,hp.Y)
        esp.Name.Visible=CFG.NameESP; esp.Name.Text=plr.DisplayName; esp.Name.Position=Vector2.new(cx,hp.Y-16)
        local pct=hum.Health/hum.MaxHealth
        esp.HpBG.Visible=CFG.HealthESP; esp.HpBG.From=Vector2.new(cx-bW*.5-5,fp.Y); esp.HpBG.To=Vector2.new(cx-bW*.5-5,hp.Y)
        esp.Hp.Visible=CFG.HealthESP; esp.Hp.From=Vector2.new(cx-bW*.5-5,fp.Y); esp.Hp.To=Vector2.new(cx-bW*.5-5,fp.Y-bH*pct); esp.Hp.Color=Color3.new(1-pct,pct,0)
        local dist=(HRP.Position-hrp.Position).Magnitude
        esp.Dist.Visible=CFG.DistESP; esp.Dist.Text=math.floor(dist).."m"; esp.Dist.Position=Vector2.new(cx,fp.Y+3)
        esp.Tracer.Visible=CFG.TracerESP; esp.Tracer.From=Vector2.new(vp.X*.5,vp.Y); esp.Tracer.To=Vector2.new(cx,fp.Y)
    end

    -- FLY (MOBILE FIXED)
    if CFG.Fly and HRP then
        local bv=HRP:FindFirstChild("_FlyBV"); local bg=HRP:FindFirstChild("_FlyBG")
        if not bv then bv=Instance.new("BodyVelocity"); bv.Name="_FlyBV"; bv.MaxForce=Vector3.new(9e9,9e9,9e9); bv.Parent=HRP end
        if not bg then bg=Instance.new("BodyGyro"); bg.Name="_FlyBG"; bg.MaxTorque=Vector3.new(9e9,9e9,9e9); bg.D=200; bg.P=10000; bg.Parent=HRP end
        bg.CFrame=Camera.CFrame
        local dir=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir-=Vector3.yAxis end
        -- Mobile: use joystick direction
        local moveDir=Humanoid.MoveDirection
        if moveDir.Magnitude>0.01 and dir.Magnitude<0.01 then
            dir=Vector3.new(moveDir.X,0,moveDir.Z)
        end
        -- Mobile up/down toggles
        if CFG.FlyUp then dir+=Vector3.yAxis end
        if CFG.FlyDown then dir-=Vector3.yAxis end
        bv.Velocity=dir*CFG.FlySpeed
        pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Flying) end)
    else
        if HRP then
            if HRP:FindFirstChild("_FlyBV") then HRP._FlyBV:Destroy() end
            if HRP:FindFirstChild("_FlyBG") then HRP._FlyBG:Destroy() end
        end
    end

    if CFG.Spin and HRP then HRP.CFrame*=CFrame.Angles(0,math.rad(CFG.SpinSpeed),0) end
    if CFG.CustomTime then Lighting.ClockTime=CFG.TimeVal end
    if CFG.Speed~=16 and Humanoid then pcall(function() Humanoid.WalkSpeed=CFG.Speed end) end
    if CFG.JumpPower~=50 and Humanoid then pcall(function() Humanoid.JumpPower=CFG.JumpPower end) end
end)

--// ═══════════════════════════════════════════
--//  HEARTBEAT
--// ═══════════════════════════════════════════

RunService.Heartbeat:Connect(function()
    if CFG.GodMode and Humanoid then pcall(function() Humanoid.Health=Humanoid.MaxHealth end) end
    if CFG.Noclip and Character then for _,p in ipairs(Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
    if CFG.BunnyHop and Humanoid then pcall(function() if Humanoid.FloorMaterial~=Enum.Material.Air then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
    if CFG.AntiBlur then for _,obj in ipairs(Lighting:GetChildren()) do if obj:IsA("BlurEffect") then obj:Destroy() end end end
end)

--// INPUT
UserInputService.JumpRequest:Connect(function()
    if CFG.InfJump and Humanoid then pcall(function() Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end
end)
Mouse.Button1Down:Connect(function()
    if CFG.ClickTP and Mouse.Hit then pcall(function() HRP.CFrame=CFrame.new(Mouse.Hit.Position+Vector3.new(0,3,0)) end) end
end)

--// BACKGROUND
LocalPlayer.Idled:Connect(function()
    if CFG.AntiAFK then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end
end)

task.spawn(function()
    while true do
        if CFG.ChatSpam and CFG.SpamMsg~="" then pcall(function() ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents",true):FindFirstChild("SayMessageRequest"):FireServer(CFG.SpamMsg,"All") end) end
        task.wait(math.max(CFG.SpamDelay,0.5))
    end
end)

task.spawn(function()
    while true do
        task.wait(CFG.AuraDelay or 0.15)
        if not CFG.KillAura or not Character or not HRP then continue end
        local tool=Character:FindFirstChildOfClass("Tool"); if not tool then continue end
        local handle=tool:FindFirstChild("Handle"); if not handle then continue end
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LocalPlayer or IsAlly(p) then continue end
            local c=p.Character; if not c then continue end
            local hrp2=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum2 and hum2.Health>0 and (HRP.Position-hrp2.Position).Magnitude<=CFG.AuraRange then
                pcall(function() firetouchinterest(handle,hrp2,0); task.wait(); firetouchinterest(handle,hrp2,1) end)
                pcall(function() tool:Activate() end)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if not CFG.AutoBomb or not Character then continue end
        for _,tool in ipairs(Character:GetChildren()) do
            if IsBombTool(tool) then
                local nearest=FindNearestPlayerForBomb()
                if nearest and nearest.Character and nearest.Character:FindFirstChild("HumanoidRootPart") then
                    local tHRP=nearest.Character.HumanoidRootPart
                    pcall(function() HRP.CFrame=tHRP.CFrame*CFrame.new(0,0,2) end); task.wait(0.05)
                    pcall(function() local h=tool:FindFirstChild("Handle"); if h then firetouchinterest(h,tHRP,0); task.wait(0.05); firetouchinterest(h,tHRP,1) end end)
                    pcall(function() tool:Activate() end); task.wait(0.1)
                    if tool.Parent==Character then pcall(function() local h=tool:FindFirstChild("Handle"); if h then firetouchinterest(h,tHRP,0); task.wait(0.1); firetouchinterest(h,tHRP,1) end end) end
                end; break
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if CFG.HitboxExp then task.wait(1); local h=char:FindFirstChild("HumanoidRootPart"); if h then h.Size=Vector3.new(CFG.HitboxSize,CFG.HitboxSize,CFG.HitboxSize); h.Transparency=0.5 end end
        if CFG.ChamsESP then task.wait(1); if not char:FindFirstChild("_Highlight") then
            local hl=Instance.new("Highlight"); hl.Name="_Highlight"; hl.FillColor=Color3.fromRGB(130,80,220); hl.FillTransparency=0.4; hl.OutlineColor=Color3.fromRGB(255,255,255); hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent=char
        end end
    end)
end)

task.delay(2,function() pcall(function() for _,obj in ipairs(Lighting:GetChildren()) do if obj:IsA("BlurEffect") then obj:Destroy() end end end) end)

Library:OnUnload(function()
    pcall(function() _G._CleanESP() end); pcall(function() _G._FOV:Remove() end)
    pcall(function() if HRP:FindFirstChild("_FlyBV") then HRP._FlyBV:Destroy() end; if HRP:FindFirstChild("_FlyBG") then HRP._FlyBG:Destroy() end end)
    if CFG.MusicPlaying then pcall(function() CFG.MusicPlaying:Stop(); CFG.MusicPlaying:Destroy() end) end
    CFG.Fly=false; CFG.Noclip=false; CFG.ESP=false; CFG.Aimbot=false; CFG.AutoBomb=false; CFG.KillAura=false
    print("Eplisma unloaded!")
end)

Library:Notify({Title="Eplisma v3.0",Description=T("welcome")..", "..LocalPlayer.DisplayName.."!\nby Frost | @Jokerfros\n"..(IsMobile and "📱 Mobile" or "🖥️ PC"),Time=6})
print("Eplisma v3.0 loaded | "..LocalPlayer.Name.." | Mobile: "..tostring(IsMobile))
