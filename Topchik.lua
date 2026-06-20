--// MM2 Professional Hub v4.0
--// LinoriaLib

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Глобальний стан
local ActiveLoops = {}
local FlingRunning = false
local FlingThread = nil

-- ===========================
-- УТИЛІТИ
-- ===========================

local function Notify(text, duration)
    Library:Notify(text, duration or 4)
end

local function GetChar(plr)
    plr = plr or LocalPlayer
    return plr.Character
end

local function GetHRP(plr)
    local c = GetChar(plr)
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum(plr)
    local c = GetChar(plr)
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function GetHead(plr)
    local c = GetChar(plr)
    return c and c:FindFirstChild("Head")
end

local function IsAlive(plr)
    local h = GetHum(plr)
    return h and h.Health > 0
end

local function PlayerHasTool(plr, name)
    local c = GetChar(plr)
    if c then
        for _, v in pairs(c:GetChildren()) do
            if v:IsA("Tool") and v.Name == name then return true, v end
        end
    end
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, v in pairs(bp:GetChildren()) do
            if v.Name == name then return true, v end
        end
    end
    return false, nil
end

local function IsMurderer(plr)
    return PlayerHasTool(plr, "Knife")
end

local function IsSheriff(plr)
    local h1, t1 = PlayerHasTool(plr, "Gun")
    if h1 then return true, t1 end
    return PlayerHasTool(plr, "Revolver")
end

local function GetMyRole()
    if IsMurderer(LocalPlayer) then return "Murderer" end
    if IsSheriff(LocalPlayer) then return "Sheriff" end
    return "Innocent"
end

local function FindMurderer()
    for _, p in pairs(Players:GetPlayers()) do
        if IsMurderer(p) then return p end
    end
    return nil
end

local function FindSheriff()
    for _, p in pairs(Players:GetPlayers()) do
        if IsSheriff(p) then return p end
    end
    return nil
end

local function FindGun()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Tool") and (v.Name == "Gun" or v.Name == "Revolver") then
            if v.Parent and not v.Parent:FindFirstChildOfClass("Humanoid") then
                return v
            end
        end
    end
    return nil
end

local function FindCoins()
    local result = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v.Name == "Coin_Server" or v.Name == "CoinVisual" or v.Name == "Coin") and v:IsA("BasePart") then
            table.insert(result, v)
        end
    end
    local cc = Workspace:FindFirstChild("CoinContainer")
    if cc then
        for _, v in pairs(cc:GetDescendants()) do
            if v:IsA("BasePart") then
                table.insert(result, v)
            end
        end
    end
    return result
end

local function GetPlayerNames()
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t, p.Name)
        end
    end
    if #t == 0 then table.insert(t, "None") end
    return t
end

local function StopLoop(name)
    if ActiveLoops[name] then
        ActiveLoops[name] = false
    end
end

local function ClearESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            for _, v in pairs(p.Character:GetDescendants()) do
                if v.Name == "_ESP" then v:Destroy() end
            end
        end
    end
    for _, v in pairs(Workspace:GetDescendants()) do
        if v.Name == "_ESP" then v:Destroy() end
    end
end

-- ===========================
-- ВІКНО
-- ===========================

local Window = Library:CreateWindow({
    Title = 'MM2 Hub v4.0',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local TabPlayer = Window:AddTab('Player')
local TabESP = Window:AddTab('ESP')
local TabGame = Window:AddTab('Game')
local TabTrolling = Window:AddTab('Trolling')
local TabVisuals = Window:AddTab('Visuals')
local TabTeleport = Window:AddTab('Teleport')
local TabMisc = Window:AddTab('Misc')
local TabSettings = Window:AddTab('Settings')

-- ===========================
-- PLAYER TAB
-- ===========================

local BoxSpeed = TabPlayer:AddLeftGroupbox('Speed')

BoxSpeed:AddToggle('ToggleSpeed', {
    Text = 'Speed Hack',
    Default = false
}):OnChanged(function()
    ActiveLoops.Speed = Toggles.ToggleSpeed.Value
end)

BoxSpeed:AddSlider('SliderSpeed', {
    Text = 'Value',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0
})

BoxSpeed:AddToggle('ToggleJump', {
    Text = 'Jump Power',
    Default = false
}):OnChanged(function()
    ActiveLoops.Jump = Toggles.ToggleJump.Value
end)

BoxSpeed:AddSlider('SliderJump', {
    Text = 'Value',
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0
})

local BoxMovement = TabPlayer:AddLeftGroupbox('Movement')

BoxMovement:AddToggle('ToggleNoclip', {
    Text = 'Noclip',
    Default = false
}):OnChanged(function()
    ActiveLoops.Noclip = Toggles.ToggleNoclip.Value
end)

BoxMovement:AddToggle('ToggleInfJump', {
    Text = 'Infinite Jump',
    Default = false
}):OnChanged(function()
    ActiveLoops.InfJump = Toggles.ToggleInfJump.Value
end)

local BoxFly = TabPlayer:AddRightGroupbox('Fly')

local FlyActive = false
local FlyBV, FlyBG

local function StartFly()
    local hrp = GetHRP()
    local hum = GetHum()
    if not hrp or not hum then return end

    FlyActive = true

    FlyBV = Instance.new("BodyVelocity")
    FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyBV.Velocity = Vector3.zero
    FlyBV.Parent = hrp

    FlyBG = Instance.new("BodyGyro")
    FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyBG.P = 9e4
    FlyBG.Parent = hrp

    hum.PlatformStand = true

    ActiveLoops.Fly = true
end

local function StopFly()
    FlyActive = false
    ActiveLoops.Fly = false
    pcall(function()
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
    end)
    local hum = GetHum()
    if hum then hum.PlatformStand = false end
end

BoxFly:AddToggle('ToggleFly', {
    Text = 'Fly',
    Default = false
}):OnChanged(function()
    if Toggles.ToggleFly.Value then
        StartFly()
        Notify("Fly enabled")
    else
        StopFly()
        Notify("Fly disabled")
    end
end)

BoxFly:AddSlider('SliderFlySpeed', {
    Text = 'Speed',
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 0
})

local BoxPlayerActions = TabPlayer:AddRightGroupbox('Actions')

BoxPlayerActions:AddButton({
    Text = 'Respawn',
    Func = function()
        local c = GetChar()
        if c then c:BreakJoints() end
    end
})

BoxPlayerActions:AddButton({
    Text = 'Reset Velocity',
    Func = function()
        local hrp = GetHRP()
        if hrp then
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
    end
})

-- ===========================
-- ESP TAB
-- ===========================

local BoxESPRoles = TabESP:AddLeftGroupbox('Role ESP')

BoxESPRoles:AddToggle('ToggleMurdererESP', {
    Text = 'Murderer ESP',
    Default = false
}):OnChanged(function()
    ActiveLoops.MurdererESP = Toggles.ToggleMurdererESP.Value
    if not ActiveLoops.MurdererESP then ClearESP() end
end)

BoxESPRoles:AddToggle('ToggleSheriffESP', {
    Text = 'Sheriff ESP',
    Default = false
}):OnChanged(function()
    ActiveLoops.SheriffESP = Toggles.ToggleSheriffESP.Value
    if not ActiveLoops.SheriffESP then ClearESP() end
end)

BoxESPRoles:AddToggle('ToggleAllESP', {
    Text = 'All Players ESP',
    Default = false
}):OnChanged(function()
    ActiveLoops.AllESP = Toggles.ToggleAllESP.Value
    if not ActiveLoops.AllESP then ClearESP() end
end)

BoxESPRoles:AddToggle('ToggleGunESP', {
    Text = 'Dropped Gun ESP',
    Default = false
}):OnChanged(function()
    ActiveLoops.GunESP = Toggles.ToggleGunESP.Value
    if not ActiveLoops.GunESP then ClearESP() end
end)

BoxESPRoles:AddToggle('ToggleCoinESP', {
    Text = 'Coin ESP',
    Default = false
}):OnChanged(function()
    ActiveLoops.CoinESP = Toggles.ToggleCoinESP.Value
    if not ActiveLoops.CoinESP then ClearESP() end
end)

BoxESPRoles:AddButton({
    Text = 'Refresh ESP',
    Func = function()
        ClearESP()
        Notify("ESP refreshed")
    end
})

local BoxESPInfo = TabESP:AddRightGroupbox('Role Info')

local LabelMurderer = BoxESPInfo:AddLabel('Murderer: ...')
local LabelSheriff = BoxESPInfo:AddLabel('Sheriff: ...')
local LabelMyRole = BoxESPInfo:AddLabel('Your Role: ...')
local LabelAlive = BoxESPInfo:AddLabel('Alive: ...')

BoxESPInfo:AddSlider('SliderESPTransparency', {
    Text = 'Highlight Fill Transparency',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0
})

-- ESP Функція
local function ApplyESP(target, color, label)
    if not target then return end
    local char = GetChar(target)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    -- Не дублювати
    for _, v in pairs(char:GetDescendants()) do
        if v.Name == "_ESP" then v:Destroy() end
    end

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Name = "_ESP"
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = (Options.SliderESPTransparency.Value or 50) / 100
    hl.OutlineTransparency = 0
    hl.Parent = char

    -- Billboard
    local bb = Instance.new("BillboardGui")
    bb.Name = "_ESP"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 0.6, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = color
    tl.Text = label
    tl.TextScaled = true
    tl.Font = Enum.Font.GothamBold
    tl.TextStrokeTransparency = 0
    tl.TextStrokeColor3 = Color3.new(0, 0, 0)
    tl.Parent = bb

    local dl = Instance.new("TextLabel")
    dl.Name = "Dist"
    dl.Size = UDim2.new(1, 0, 0.4, 0)
    dl.Position = UDim2.new(0, 0, 0.6, 0)
    dl.BackgroundTransparency = 1
    dl.TextColor3 = Color3.fromRGB(200, 200, 200)
    dl.Text = "0 studs"
    dl.TextScaled = true
    dl.Font = Enum.Font.Gotham
    dl.TextStrokeTransparency = 0
    dl.TextStrokeColor3 = Color3.new(0, 0, 0)
    dl.Parent = bb
end

local function ApplyObjectESP(part, color, label)
    if not part or not part.Parent then return end

    for _, v in pairs(part:GetDescendants()) do
        if v.Name == "_ESP" then v:Destroy() end
    end
    for _, v in pairs(part:GetChildren()) do
        if v.Name == "_ESP" then v:Destroy() end
    end

    local hl = Instance.new("Highlight")
    hl.Name = "_ESP"
    hl.FillColor = color
    hl.FillTransparency = 0.3
    hl.OutlineColor = color
    hl.Parent = part:IsA("BasePart") and part.Parent or part

    local bb = Instance.new("BillboardGui")
    bb.Name = "_ESP"
    bb.Size = UDim2.new(0, 120, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = part
    bb.Parent = part

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = color
    tl.Text = label
    tl.TextScaled = true
    tl.Font = Enum.Font.GothamBold
    tl.TextStrokeTransparency = 0
    tl.Parent = bb
end

-- ===========================
-- GAME TAB
-- ===========================

local BoxGameAuto = TabGame:AddLeftGroupbox('Automation')

BoxGameAuto:AddToggle('ToggleAutoCoin', {
    Text = 'Auto Collect Coins',
    Default = false
}):OnChanged(function()
    ActiveLoops.AutoCoin = Toggles.ToggleAutoCoin.Value
    if ActiveLoops.AutoCoin then Notify("Auto Coin enabled") end
end)

BoxGameAuto:AddToggle('ToggleAutoGun', {
    Text = 'Auto Grab Gun',
    Default = false
}):OnChanged(function()
    ActiveLoops.AutoGun = Toggles.ToggleAutoGun.Value
    if ActiveLoops.AutoGun then Notify("Auto Gun enabled") end
end)

BoxGameAuto:AddToggle('ToggleAntiKnife', {
    Text = 'Anti-Knife (Dodge Murderer)',
    Default = false
}):OnChanged(function()
    ActiveLoops.AntiKnife = Toggles.ToggleAntiKnife.Value
end)

BoxGameAuto:AddSlider('SliderAntiKnifeDist', {
    Text = 'Safe Distance',
    Default = 15,
    Min = 8,
    Max = 50,
    Rounding = 0
})

local BoxGameActions = TabGame:AddRightGroupbox('Quick Actions')

BoxGameActions:AddButton({
    Text = 'Teleport to Gun',
    Func = function()
        local gun = FindGun()
        if gun then
            local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
            local hrp = GetHRP()
            if handle and hrp then
                hrp.CFrame = handle.CFrame * CFrame.new(0, 2, 0)
                Notify("Teleported to gun")
            end
        else
            Notify("No dropped gun found")
        end
    end
})

BoxGameActions:AddButton({
    Text = 'Teleport to Murderer',
    Func = function()
        local m = FindMurderer()
        if m then
            local t = GetHRP(m)
            local hrp = GetHRP()
            if t and hrp then
                hrp.CFrame = t.CFrame * CFrame.new(0, 0, 5)
                Notify("Teleported to murderer: " .. m.Name)
            end
        else
            Notify("Murderer not found")
        end
    end
})

BoxGameActions:AddButton({
    Text = 'Teleport to Sheriff',
    Func = function()
        local s = FindSheriff()
        if s then
            local t = GetHRP(s)
            local hrp = GetHRP()
            if t and hrp then
                hrp.CFrame = t.CFrame * CFrame.new(0, 0, 5)
                Notify("Teleported to sheriff: " .. s.Name)
            end
        else
            Notify("Sheriff not found")
        end
    end
})

BoxGameActions:AddButton({
    Text = 'Equip Gun',
    Func = function()
        local has, gun = IsSheriff(LocalPlayer)
        if has and gun and gun.Parent ~= GetChar() then
            GetHum():EquipTool(gun)
            Notify("Gun equipped")
        end
    end
})

BoxGameActions:AddButton({
    Text = 'Equip Knife',
    Func = function()
        local has, knife = IsMurderer(LocalPlayer)
        if has and knife and knife.Parent ~= GetChar() then
            GetHum():EquipTool(knife)
            Notify("Knife equipped")
        end
    end
})

-- ===========================
-- TROLLING TAB
-- ===========================

local BoxFling = TabTrolling:AddLeftGroupbox('Fling')

BoxFling:AddDropdown('DropdownFlingTarget', {
    Values = GetPlayerNames(),
    Default = 1,
    Multi = false,
    Text = 'Target Player'
})

BoxFling:AddDropdown('DropdownFlingMethod', {
    Values = {"Velocity", "CFrame Spam"},
    Default = 1,
    Multi = false,
    Text = 'Method'
})

BoxFling:AddButton({
    Text = 'Refresh Players',
    Func = function()
        local list = GetPlayerNames()
        Options.DropdownFlingTarget:SetValues(list)
        Options.DropdownTPTarget:SetValues(list)
        Notify("Player list refreshed")
    end
})

BoxFling:AddButton({
    Text = 'START FLING',
    Func = function()
        if FlingRunning then
            Notify("Fling already running, stop it first")
            return
        end

        local targetName = Options.DropdownFlingTarget.Value
        local target = Players:FindFirstChild(targetName)
        if not target then
            Notify("Target not found")
            return
        end

        local hrp = GetHRP()
        if not hrp then return end

        FlingRunning = true
        local method = Options.DropdownFlingMethod.Value
        local origCF = hrp.CFrame
        Notify("Fling started on " .. target.Name .. " [" .. method .. "]")

        FlingThread = task.spawn(function()
            if method == "Velocity" then
                local att = Instance.new("Attachment", hrp)
                local lv = Instance.new("LinearVelocity")
                lv.MaxForce = math.huge
                lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
                lv.Attachment0 = att
                lv.Parent = hrp

                local av = Instance.new("AngularVelocity")
                av.MaxTorque = math.huge
                av.Attachment0 = att
                av.Parent = hrp

                local start = tick()
                while FlingRunning and tick() - start < 15 do
                    local tRoot = GetHRP(target)
                    if not tRoot or not hrp or not hrp.Parent then break end
                    hrp.CFrame = tRoot.CFrame * CFrame.new(0, 0, 0.3)
                    lv.VectorVelocity = (tRoot.Position - hrp.Position).Unit * 9999
                    av.AngularVelocity = Vector3.new(9999, 9999, 9999)
                    task.wait()
                end

                pcall(function()
                    lv:Destroy()
                    av:Destroy()
                    att:Destroy()
                end)

            elseif method == "CFrame Spam" then
                local start = tick()
                while FlingRunning and tick() - start < 15 do
                    local tRoot = GetHRP(target)
                    if not tRoot or not hrp or not hrp.Parent then break end
                    hrp.CFrame = tRoot.CFrame
                    hrp.Velocity = Vector3.new(
                        math.random(-600, 600),
                        math.random(300, 600),
                        math.random(-600, 600)
                    )
                    hrp.RotVelocity = Vector3.new(
                        math.random(-200, 200),
                        math.random(-200, 200),
                        math.random(-200, 200)
                    )
                    task.wait()
                end
            end

            FlingRunning = false
            pcall(function()
                if hrp and hrp.Parent then
                    hrp.CFrame = origCF
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero
                end
            end)
            Notify("Fling finished")
        end)
    end
})

BoxFling:AddButton({
    Text = 'STOP FLING',
    Func = function()
        FlingRunning = false
        local hrp = GetHRP()
        if hrp then
            hrp.Velocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
        end
        Notify("Fling stopped")
    end
})

local BoxFlingExtra = TabTrolling:AddRightGroupbox('Quick Fling')

BoxFlingExtra:AddButton({
    Text = 'Fling Murderer',
    Func = function()
        local m = FindMurderer()
        if m then
            Options.DropdownFlingTarget:SetValue(m.Name)
            Notify("Target set to murderer: " .. m.Name .. " - press START FLING")
        else
            Notify("Murderer not found")
        end
    end
})

BoxFlingExtra:AddButton({
    Text = 'Fling Closest Player',
    Func = function()
        local hrp = GetHRP()
        if not hrp then return end
        local closest, closestDist = nil, math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and IsAlive(p) then
                local t = GetHRP(p)
                if t then
                    local d = (hrp.Position - t.Position).Magnitude
                    if d < closestDist then
                        closest = p
                        closestDist = d
                    end
                end
            end
        end
        if closest then
            Options.DropdownFlingTarget:SetValue(closest.Name)
            Notify("Target set to closest: " .. closest.Name .. " (" .. math.floor(closestDist) .. " studs)")
        else
            Notify("No players nearby")
        end
    end
})

local BoxTrollExtra = TabTrolling:AddRightGroupbox('Other Trolling')

BoxTrollExtra:AddToggle('ToggleSpinBot', {
    Text = 'Spin Bot',
    Default = false
}):OnChanged(function()
    ActiveLoops.SpinBot = Toggles.ToggleSpinBot.Value
end)

BoxTrollExtra:AddSlider('SliderSpinSpeed', {
    Text = 'Spin Speed',
    Default = 15,
    Min = 1,
    Max = 100,
    Rounding = 0
})

BoxTrollExtra:AddButton({
    Text = 'Bring Gun to You',
    Func = function()
        local gun = FindGun()
        if gun then
            local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
            local hrp = GetHRP()
            if handle and hrp then
                -- Телепорт за пістолетом і назад
                local orig = hrp.CFrame
                hrp.CFrame = handle.CFrame
                task.wait(0.3)
                pcall(function()
                    GetHum():EquipTool(gun)
                end)
                task.wait(0.2)
                hrp.CFrame = orig
                Notify("Gun brought to you")
            end
        else
            Notify("No dropped gun")
        end
    end
})

-- ===========================
-- VISUALS TAB
-- ===========================

local BoxLighting = TabVisuals:AddLeftGroupbox('Lighting')

BoxLighting:AddToggle('ToggleFullbright', {
    Text = 'Fullbright',
    Default = false
}):OnChanged(function()
    if Toggles.ToggleFullbright.Value then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or
               v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("Atmosphere") then
                v.Enabled = false
            end
        end
        Notify("Fullbright ON")
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.FogEnd = 1000
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") then
                v.Enabled = true
            end
        end
        Notify("Fullbright OFF")
    end
end)

BoxLighting:AddToggle('ToggleNoFog', {
    Text = 'No Fog',
    Default = false
}):OnChanged(function()
    if Toggles.ToggleNoFog.Value then
        Lighting.FogEnd = 999999
        Lighting.FogStart = 999999
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("Atmosphere") then v.Density = 0 end
        end
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
end)

local BoxCamera = TabVisuals:AddLeftGroupbox('Camera')

BoxCamera:AddToggle('ToggleFOV', {
    Text = 'Custom FOV',
    Default = false
}):OnChanged(function()
    ActiveLoops.FOV = Toggles.ToggleFOV.Value
    if not ActiveLoops.FOV then Camera.FieldOfView = 70 end
end)

BoxCamera:AddSlider('SliderFOV', {
    Text = 'FOV',
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0
})

local BoxCharVisuals = TabVisuals:AddRightGroupbox('Character')

BoxCharVisuals:AddToggle('ToggleBigHead', {
    Text = 'Big Head (Others)',
    Default = false
}):OnChanged(function()
    ActiveLoops.BigHead = Toggles.ToggleBigHead.Value
    if not ActiveLoops.BigHead then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Head")
                if h then h.Size = Vector3.new(1.2, 1.2, 1.2) end
            end
        end
    end
end)

BoxCharVisuals:AddSlider('SliderBigHead', {
    Text = 'Head Size',
    Default = 5,
    Min = 2,
    Max = 15,
    Rounding = 0
})

BoxCharVisuals:AddToggle('ToggleXray', {
    Text = 'X-Ray (See Through Walls)',
    Default = false
}):OnChanged(function()
    if Toggles.ToggleXray.Value then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Transparency < 1 then
                if not Players:GetPlayerFromCharacter(v:FindFirstAncestorOfClass("Model")) then
                    if v.Name ~= "Baseplate" and v.Name ~= "Base" then
                        v.LocalTransparencyModifier = 0.7
                    end
                end
            end
        end
        Notify("X-Ray ON")
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = 0
            end
        end
        Notify("X-Ray OFF")
    end
end)

BoxCharVisuals:AddButton({
    Text = 'Remove Map Decorations',
    Func = function()
        local c = 0
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or
               v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v:Destroy()
                c = c + 1
            end
        end
        Notify(c .. " decorations removed")
    end
})

-- ===========================
-- TELEPORT TAB
-- ===========================

local BoxTPPlayer = TabTeleport:AddLeftGroupbox('Player Teleport')

BoxTPPlayer:AddDropdown('DropdownTPTarget', {
    Values = GetPlayerNames(),
    Default = 1,
    Multi = false,
    Text = 'Target'
})

BoxTPPlayer:AddButton({
    Text = 'Refresh Players',
    Func = function()
        local list = GetPlayerNames()
        Options.DropdownTPTarget:SetValues(list)
        Options.DropdownFlingTarget:SetValues(list)
        Notify("List refreshed")
    end
})

BoxTPPlayer:AddButton({
    Text = 'Teleport to Player',
    Func = function()
        local name = Options.DropdownTPTarget.Value
        local target = Players:FindFirstChild(name)
        if target then
            local t = GetHRP(target)
            local hrp = GetHRP()
            if t and hrp then
                hrp.CFrame = t.CFrame * CFrame.new(0, 0, 3)
                Notify("Teleported to " .. name)
            end
        end
    end
})

BoxTPPlayer:AddButton({
    Text = 'Teleport Behind Player',
    Func = function()
        local name = Options.DropdownTPTarget.Value
        local target = Players:FindFirstChild(name)
        if target then
            local t = GetHRP(target)
            local hrp = GetHRP()
            if t and hrp then
                hrp.CFrame = t.CFrame * CFrame.new(0, 0, -5)
                Notify("Teleported behind " .. name)
            end
        end
    end
})

BoxTPPlayer:AddButton({
    Text = 'Smooth Tween to Player',
    Func = function()
        local name = Options.DropdownTPTarget.Value
        local target = Players:FindFirstChild(name)
        if target then
            local t = GetHRP(target)
            local hrp = GetHRP()
            if t and hrp then
                local dist = (hrp.Position - t.Position).Magnitude
                local tw = TweenService:Create(hrp, TweenInfo.new(dist / 100, Enum.EasingStyle.Linear), {
                    CFrame = t.CFrame * CFrame.new(0, 0, 3)
                })
                tw:Play()
                Notify("Tweening to " .. name)
            end
        end
    end
})

local BoxTPPos = TabTeleport:AddRightGroupbox('Positions')

local SavedPos = nil

BoxTPPos:AddButton({
    Text = 'Save Position',
    Func = function()
        local hrp = GetHRP()
        if hrp then
            SavedPos = hrp.CFrame
            Notify("Position saved")
        end
    end
})

BoxTPPos:AddButton({
    Text = 'Load Position',
    Func = function()
        if SavedPos then
            local hrp = GetHRP()
            if hrp then
                hrp.CFrame = SavedPos
                Notify("Position loaded")
            end
        else
            Notify("No position saved")
        end
    end
})

BoxTPPos:AddButton({
    Text = 'Teleport Up (100 studs)',
    Func = function()
        local hrp = GetHRP()
        if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 100, 0) end
    end
})

BoxTPPos:AddButton({
    Text = 'Teleport Forward (50 studs)',
    Func = function()
        local hrp = GetHRP()
        if hrp then hrp.CFrame = hrp.CFrame + Camera.CFrame.LookVector * 50 end
    end
})

-- ===========================
-- MISC TAB
-- ===========================

local BoxMiscGeneral = TabMisc:AddLeftGroupbox('General')

BoxMiscGeneral:AddToggle('ToggleAntiAFK', {
    Text = 'Anti-AFK',
    Default = true
}):OnChanged(function()
    if Toggles.ToggleAntiAFK.Value then
        pcall(function()
            local vu = game:GetService("VirtualUser")
            LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
            end)
        end)
        Notify("Anti-AFK enabled")
    end
end)

BoxMiscGeneral:AddButton({
    Text = 'Rejoin Server',
    DoubleClick = true,
    Func = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

BoxMiscGeneral:AddButton({
    Text = 'Server Hop',
    DoubleClick = true,
    Func = function()
        pcall(function()
            local data = HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            )
            for _, s in pairs(data.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    return
                end
            end
            Notify("No available servers")
        end)
    end
})

BoxMiscGeneral:AddButton({
    Text = 'Copy Server Link',
    Func = function()
        pcall(function()
            setclipboard("roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. game.JobId)
            Notify("Server link copied")
        end)
    end
})

local BoxMobileBox = TabMisc:AddRightGroupbox('Mobile')

BoxMobileBox:AddButton({
    Text = 'Create Mobile Buttons',
    Func = function()
        local existing = LocalPlayer.PlayerGui:FindFirstChild("_MobileButtons")
        if existing then
            existing:Destroy()
            Notify("Mobile buttons removed")
            return
        end

        local sg = Instance.new("ScreenGui")
        sg.Name = "_MobileButtons"
        sg.ResetOnSpawn = false
        sg.Parent = LocalPlayer.PlayerGui

        local buttons = {
            {t = "FLY", c = Color3.fromRGB(0, 120, 255), f = function() Toggles.ToggleFly:SetValue(not Toggles.ToggleFly.Value) end},
            {t = "NOCLIP", c = Color3.fromRGB(150, 0, 255), f = function() Toggles.ToggleNoclip:SetValue(not Toggles.ToggleNoclip.Value) end},
            {t = "SPEED", c = Color3.fromRGB(255, 140, 0), f = function() Toggles.ToggleSpeed:SetValue(not Toggles.ToggleSpeed.Value) end},
            {t = "TP GUN", c = Color3.fromRGB(0, 170, 255), f = function()
                local gun = FindGun()
                if gun then
                    local h = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
                    local hrp = GetHRP()
                    if h and hrp then hrp.CFrame = h.CFrame * CFrame.new(0, 2, 0) end
                end
            end},
            {t = "ESP", c = Color3.fromRGB(255, 50, 50), f = function()
                Toggles.ToggleMurdererESP:SetValue(not Toggles.ToggleMurdererESP.Value)
                Toggles.ToggleSheriffESP:SetValue(not Toggles.ToggleSheriffESP.Value)
            end},
            {t = "COINS", c = Color3.fromRGB(255, 215, 0), f = function()
                Toggles.ToggleAutoCoin:SetValue(not Toggles.ToggleAutoCoin.Value)
            end},
        }

        for i, data in ipairs(buttons) do
            local col = (i - 1) % 2
            local row = math.floor((i - 1) / 2)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 75, 0, 38)
            btn.Position = UDim2.new(0, 10 + col * 80, 0.6, row * 43)
            btn.Text = data.t
            btn.BackgroundColor3 = data.c
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.BackgroundTransparency = 0.1
            btn.Parent = sg
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            btn.MouseButton1Click:Connect(data.f)
        end

        -- Close
        local x = Instance.new("TextButton")
        x.Size = UDim2.new(0, 25, 0, 25)
        x.Position = UDim2.new(0, 170, 0.6, -30)
        x.Text = "X"
        x.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        x.TextColor3 = Color3.new(1, 1, 1)
        x.Font = Enum.Font.GothamBold
        x.TextSize = 12
        x.Parent = sg
        Instance.new("UICorner", x).CornerRadius = UDim.new(0, 5)
        x.MouseButton1Click:Connect(function() sg:Destroy() end)

        Notify("Mobile buttons created")
    end
})

BoxMobileBox:AddButton({
    Text = 'Quick Show Roles',
    Func = function()
        local m = FindMurderer()
        local s = FindSheriff()
        Notify("Murderer: " .. (m and m.Name or "?") .. " | Sheriff: " .. (s and s.Name or "?"), 6)
    end
})

-- ===========================
-- SETTINGS TAB
-- ===========================

local BoxSettingsMain = TabSettings:AddLeftGroupbox('Menu')

BoxSettingsMain:AddButton({
    Text = 'Unload Script',
    DoubleClick = true,
    Func = function()
        ClearESP()
        StopFly()
        FlingRunning = false
        for k in pairs(ActiveLoops) do ActiveLoops[k] = false end
        pcall(function()
            local mb = LocalPlayer.PlayerGui:FindFirstChild("_MobileButtons")
            if mb then mb:Destroy() end
        end)
        Library:Unload()
    end
})

BoxSettingsMain:AddLabel('Menu Keybind:'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Menu Toggle'
})

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({'MenuKeybind'})
ThemeManager:SetFolder('MM2Hub')
SaveManager:SetFolder('MM2Hub/configs')
SaveManager:BuildConfigSection(TabSettings)
ThemeManager:ApplyToTab(TabSettings)

-- ===========================
-- ГОЛОВНІ ЦИКЛИ
-- ===========================

-- Noclip
RunService.Stepped:Connect(function()
    if ActiveLoops.Noclip then
        local c = GetChar()
        if c then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if ActiveLoops.InfJump then
        local h = GetHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Main heartbeat loop
RunService.Heartbeat:Connect(function()
    local hum = GetHum()
    local hrp = GetHRP()

    -- Speed
    if ActiveLoops.Speed and hum then
        hum.WalkSpeed = Options.SliderSpeed.Value
    end

    -- Jump
    if ActiveLoops.Jump and hum then
        hum.JumpPower = Options.SliderJump.Value
        hum.UseJumpPower = true
    end

    -- FOV
    if ActiveLoops.FOV then
        Camera.FieldOfView = Options.SliderFOV.Value
    end

    -- SpinBot
    if ActiveLoops.SpinBot and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Options.SliderSpinSpeed.Value), 0)
    end

    -- Fly movement
    if FlyActive and FlyBV and FlyBG and hrp then
        local hum2 = GetHum()
        local dir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

        -- Mobile joystick
        if hum2 and hum2.MoveDirection.Magnitude > 0 then
            dir = dir + hum2.MoveDirection
        end

        if dir.Magnitude > 0 then
            FlyBV.Velocity = dir.Unit * Options.SliderFlySpeed.Value
        else
            FlyBV.Velocity = Vector3.zero
        end
        FlyBG.CFrame = Camera.CFrame
    end

    -- Big Head
    if ActiveLoops.BigHead then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = p.Character:FindFirstChild("Head")
                if h then
                    h.Size = Vector3.new(Options.SliderBigHead.Value, Options.SliderBigHead.Value, Options.SliderBigHead.Value)
                    h.CanCollide = false
                end
            end
        end
    end

    -- Anti-Void
    if hrp and hrp.Position.Y < -150 then
        hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
        hrp.Velocity = Vector3.zero
    end
end)

-- ESP + Role Info + Auto functions loop
task.spawn(function()
    while task.wait(0.7) do
        pcall(function()
            local murderer = FindMurderer()
            local sheriff = FindSheriff()
            local myRole = GetMyRole()
            local alive = 0

            for _, p in pairs(Players:GetPlayers()) do
                if IsAlive(p) then alive = alive + 1 end
            end

            -- Labels
            pcall(function()
                LabelMurderer:SetText("Murderer: " .. (murderer and murderer.Name or "Unknown"))
                LabelSheriff:SetText("Sheriff: " .. (sheriff and sheriff.Name or "Unknown"))
                LabelMyRole:SetText("Your Role: " .. myRole)
                LabelAlive:SetText("Alive: " .. alive)
            end)

            -- Murderer ESP
            if ActiveLoops.MurdererESP and murderer then
                ApplyESP(murderer, Color3.fromRGB(255, 0, 0), "MURDERER [" .. murderer.Name .. "]")
            end

            -- Sheriff ESP
            if ActiveLoops.SheriffESP and sheriff then
                ApplyESP(sheriff, Color3.fromRGB(0, 100, 255), "SHERIFF [" .. sheriff.Name .. "]")
            end

            -- All ESP
            if ActiveLoops.AllESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local color = Color3.fromRGB(0, 255, 0)
                        local label = "Innocent"
                        if murderer and p == murderer then
                            color = Color3.fromRGB(255, 0, 0)
                            label = "MURDERER"
                        elseif sheriff and p == sheriff then
                            color = Color3.fromRGB(0, 100, 255)
                            label = "SHERIFF"
                        end
                        ApplyESP(p, color, label .. " [" .. p.Name .. "]")
                    end
                end
            end

            -- Gun ESP
            if ActiveLoops.GunESP then
                local gun = FindGun()
                if gun then
                    local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
                    if handle then
                        ApplyObjectESP(handle, Color3.fromRGB(0, 170, 255), "DROPPED GUN")
                    end
                end
            end

            -- Coin ESP
            if ActiveLoops.CoinESP then
                local coins = FindCoins()
                for _, coin in pairs(coins) do
                    ApplyObjectESP(coin, Color3.fromRGB(255, 215, 0), "Coin")
                end
            end

            -- Distance update
            local hrp = GetHRP()
            if hrp then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local head = p.Character:FindFirstChild("Head")
                        if head then
                            for _, v in pairs(head:GetChildren()) do
                                if v.Name == "_ESP" and v:IsA("BillboardGui") then
                                    local dl = v:FindFirstChild("Dist")
                                    if dl then
                                        local d = math.floor((hrp.Position - head.Position).Magnitude)
                                        dl.Text = d .. " studs"
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Coin loop
task.spawn(function()
    while task.wait(0.3) do
        if ActiveLoops.AutoCoin then
            pcall(function()
                local coins = FindCoins()
                local hrp = GetHRP()
                if hrp and #coins > 0 then
                    local closest, closestDist = nil, math.huge
                    for _, coin in pairs(coins) do
                        local d = (hrp.Position - coin.Position).Magnitude
                        if d < closestDist then
                            closest = coin
                            closestDist = d
                        end
                    end
                    if closest and closestDist > 5 then
                        local orig = hrp.CFrame
                        hrp.CFrame = closest.CFrame
                        task.wait(0.15)
                        hrp.CFrame = orig
                    end
                end
            end)
        end
    end
end)

-- Auto Grab Gun loop
task.spawn(function()
    while task.wait(0.5) do
        if ActiveLoops.AutoGun then
            pcall(function()
                local gun = FindGun()
                if gun then
                    local handle = gun:FindFirstChild("Handle") or gun:FindFirstChildOfClass("BasePart")
                    local hrp = GetHRP()
                    if handle and hrp then
                        hrp.CFrame = handle.CFrame
                        task.wait(0.2)
                        pcall(function() GetHum():EquipTool(gun) end)
                        pcall(function()
                            for _, v in pairs(gun:GetDescendants()) do
                                if v:IsA("ProximityPrompt") then
                                    fireproximityprompt(v)
                                end
                            end
                        end)
                        Notify("Gun grabbed")
                    end
                end
            end)
        end
    end
end)

-- Anti-Knife loop
task.spawn(function()
    while task.wait(0.15) do
        if ActiveLoops.AntiKnife then
            pcall(function()
                local m = FindMurderer()
                local hrp = GetHRP()
                if m and m.Character and hrp then
                    local mHRP = GetHRP(m)
                    if mHRP then
                        local dist = (hrp.Position - mHRP.Position).Magnitude
                        local safe = Options.SliderAntiKnifeDist.Value
                        if dist < safe then
                            local dir = (hrp.Position - mHRP.Position).Unit
                            hrp.CFrame = hrp.CFrame + dir * (safe - dist + 5)
                        end
                    end
                end
            end)
        end
    end
end)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if FlyActive then
        StopFly()
        task.wait(0.3)
        StartFly()
    end
    ClearESP()
end)

-- Player leaving cleanup
Players.PlayerRemoving:Connect(function(p)
    -- ESP auto cleans since its on character
end)

-- Anti-AFK на старті
pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end)
end)

Notify("MM2 Hub v4.0 loaded successfully", 5)
Notify("Press End to toggle menu", 4)
