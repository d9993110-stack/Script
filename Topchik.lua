--// MM2 Ultimate Script by Assistant
--// LinoriaLib UI

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'MM2 Ultimate Hub',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// Variables
local ESPEnabled = false
local ESPObjects = {}
local MurdererESP = false
local SheriffESP = false
local GunESP = false
local CoinESP = false
local TrapESP = false
local PlayerESPEnabled = false
local SpeedEnabled = false
local SpeedValue = 16
local JumpEnabled = false
local JumpValue = 50
local NoclipEnabled = false
local InfiniteJumpEnabled = false
local FullbrightEnabled = false
local AntiKnifeEnabled = false
local GrabGunEnabled = false
local AutoPickupGun = false
local FlingActive = false
local FlingTarget = nil
local SpinbotEnabled = false
local SpinbotSpeed = 10
local GodModeEnabled = false
local AutoFarmCoins = false
local XrayEnabled = false
local AimbotEnabled = false
local SilentAimEnabled = false
local ShowRoles = false
local AntiAFK = true
local FlyEnabled = false
local FlySpeed = 50
local TPGunEnabled = false
local HitboxExpanderEnabled = false
local HitboxSize = 10
local ChamEnabled = false
local TracerEnabled = false
local NameESPEnabled = false
local HealthESPEnabled = false

--// Utility Functions
local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3
    })
end

local function GetCharacter(player)
    return player and player.Character
end

local function GetHumanoid(player)
    local char = GetCharacter(player)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart(player)
    local char = GetCharacter(player)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
end

local function GetMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        local char = GetCharacter(player)
        if char then
            local backpack = player:FindFirstChild("Backpack")
            if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
                return player
            end
        end
    end
    return nil
end

local function GetSheriff()
    for _, player in pairs(Players:GetPlayers()) do
        local char = GetCharacter(player)
        if char then
            local backpack = player:FindFirstChild("Backpack")
            if char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
                return player
            end
        end
    end
    return nil
end

local function GetGunDrop()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end

local function GetRole(player)
    local char = GetCharacter(player)
    if not char then return "Innocent" end
    local backpack = player:FindFirstChild("Backpack")
    if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
        return "Murderer"
    elseif char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

local function GetCoins()
    local coins = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Coin_Server" or (obj:IsA("BasePart") and obj.Name == "CoinVisual") then
            table.insert(coins, obj)
        end
    end
    -- Also check CoinContainer
    local coinContainer = Workspace:FindFirstChild("CoinContainer")
    if coinContainer then
        for _, coin in pairs(coinContainer:GetChildren()) do
            table.insert(coins, coin)
        end
    end
    return coins
end

local function GetTraps()
    local traps = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "Trap" or obj.Name == "TrapDoor" or (obj:IsA("BasePart") and obj.Name:find("Trap")) then
            table.insert(traps, obj)
        end
    end
    return traps
end

local function GetPlayerList()
    local list = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(list, player.Name)
        end
    end
    return list
end

--// ==================== TABS ====================

local Tabs = {
    Main = Window:AddTab('🏠 Main'),
    Player = Window:AddTab('🏃 Player'),
    Visuals = Window:AddTab('👁 Visuals'),
    Combat = Window:AddTab('⚔ Combat'),
    Trolling = Window:AddTab('🤡 Trolling'),
    Teleport = Window:AddTab('📍 Teleport'),
    Misc = Window:AddTab('⚙ Misc'),
    ['UI Settings'] = Window:AddTab('🎨 UI Settings'),
}

--// ==================== MAIN TAB ====================
local MainGroup = Tabs.Main:AddLeftGroupbox('Role Detection')

MainGroup:AddToggle('ShowRoles', {
    Text = 'Show Roles',
    Default = false,
    Tooltip = 'Shows who is Murderer/Sheriff'
})

Toggles.ShowRoles:OnChanged(function()
    ShowRoles = Toggles.ShowRoles.Value
    if ShowRoles then
        spawn(function()
            while ShowRoles do
                local murderer = GetMurderer()
                local sheriff = GetSheriff()
                local murdName = murderer and murderer.Name or "Unknown"
                local sheriffName = sheriff and sheriff.Name or "Unknown"
                Notify("Roles", "🔪 Murderer: " .. murdName .. "\n🔫 Sheriff: " .. sheriffName, 2)
                wait(5)
            end
        end)
    end
end)

MainGroup:AddButton({
    Text = 'Detect Roles Now',
    Func = function()
        local murderer = GetMurderer()
        local sheriff = GetSheriff()
        local murdName = murderer and murderer.Name or "Unknown"
        local sheriffName = sheriff and sheriff.Name or "Unknown"
        Notify("Role Detection", "🔪 Murderer: " .. murdName .. "\n🔫 Sheriff: " .. sheriffName, 5)
    end,
    DoubleClick = false,
    Tooltip = 'Detect murderer and sheriff'
})

local MainGroup2 = Tabs.Main:AddLeftGroupbox('Gun Features')

MainGroup2:AddToggle('AutoPickupGun', {
    Text = 'Auto Pickup Gun',
    Default = false,
    Tooltip = 'Automatically picks up dropped gun'
})

Toggles.AutoPickupGun:OnChanged(function()
    AutoPickupGun = Toggles.AutoPickupGun.Value
    if AutoPickupGun then
        spawn(function()
            while AutoPickupGun do
                local gunDrop = GetGunDrop()
                local root = GetRootPart(LocalPlayer)
                if gunDrop and root then
                    -- Teleport to gun
                    root.CFrame = gunDrop.CFrame + Vector3.new(0, 3, 0)
                    wait(0.2)
                    -- Try to touch it
                    firetouchinterest(root, gunDrop, 0)
                    wait(0.1)
                    firetouchinterest(root, gunDrop, 1)
                end
                wait(0.5)
            end
        end)
    end
end)

MainGroup2:AddToggle('GrabGun', {
    Text = 'Grab Gun (Murderer)',
    Default = false,
    Tooltip = 'As murderer grab the gun to prevent sheriff'
})

Toggles.GrabGun:OnChanged(function()
    GrabGunEnabled = Toggles.GrabGun.Value
    if GrabGunEnabled then
        spawn(function()
            while GrabGunEnabled do
                local role = GetRole(LocalPlayer)
                if role == "Murderer" then
                    local gunDrop = GetGunDrop()
                    local root = GetRootPart(LocalPlayer)
                    if gunDrop and root then
                        root.CFrame = gunDrop.CFrame
                        wait(0.1)
                        firetouchinterest(root, gunDrop, 0)
                        wait(0.1)
                        firetouchinterest(root, gunDrop, 1)
                    end
                end
                wait(0.3)
            end
        end)
    end
end)

MainGroup2:AddButton({
    Text = 'Teleport to Gun',
    Func = function()
        local gunDrop = GetGunDrop()
        local root = GetRootPart(LocalPlayer)
        if gunDrop and root then
            root.CFrame = gunDrop.CFrame + Vector3.new(0, 3, 0)
            Notify("Teleport", "Teleported to gun!", 2)
        else
            Notify("Teleport", "No gun found!", 2)
        end
    end,
    DoubleClick = false,
})

local MainGroup3 = Tabs.Main:AddRightGroupbox('Anti Features')

MainGroup3:AddToggle('AntiKnife', {
    Text = 'Anti Knife (Dodge Murderer)',
    Default = false,
    Tooltip = 'Teleports away from murderer when close'
})

Toggles.AntiKnife:OnChanged(function()
    AntiKnifeEnabled = Toggles.AntiKnife.Value
    if AntiKnifeEnabled then
        spawn(function()
            while AntiKnifeEnabled do
                local murderer = GetMurderer()
                local myRoot = GetRootPart(LocalPlayer)
                if murderer and myRoot then
                    local murdRoot = GetRootPart(murderer)
                    if murdRoot then
                        local dist = (myRoot.Position - murdRoot.Position).Magnitude
                        if dist < 15 then
                            -- Teleport away
                            local direction = (myRoot.Position - murdRoot.Position).Unit
                            myRoot.CFrame = myRoot.CFrame + direction * 30
                            Notify("Anti-Knife", "Dodged murderer!", 1)
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end
end)

MainGroup3:AddToggle('GodMode', {
    Text = 'God Mode (Client)',
    Default = false,
    Tooltip = 'Client-side god mode'
})

Toggles.GodMode:OnChanged(function()
    GodModeEnabled = Toggles.GodMode.Value
    local char = GetCharacter(LocalPlayer)
    if char then
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid and GodModeEnabled then
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if GodModeEnabled then
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end
    end
end)

local MainGroup4 = Tabs.Main:AddRightGroupbox('Coin Farm')

MainGroup4:AddToggle('AutoFarmCoins', {
    Text = 'Auto Farm Coins',
    Default = false,
    Tooltip = 'Automatically collects coins'
})

Toggles.AutoFarmCoins:OnChanged(function()
    AutoFarmCoins = Toggles.AutoFarmCoins.Value
    if AutoFarmCoins then
        spawn(function()
            while AutoFarmCoins do
                local root = GetRootPart(LocalPlayer)
                if root then
                    local coins = GetCoins()
                    for _, coin in pairs(coins) do
                        if not AutoFarmCoins then break end
                        if coin:IsA("BasePart") then
                            root.CFrame = coin.CFrame
                            wait(0.15)
                            firetouchinterest(root, coin, 0)
                            wait(0.05)
                            firetouchinterest(root, coin, 1)
                        elseif coin:IsA("Model") then
                            local primary = coin:FindFirstChildWhichIsA("BasePart")
                            if primary then
                                root.CFrame = primary.CFrame
                                wait(0.15)
                                firetouchinterest(root, primary, 0)
                                wait(0.05)
                                firetouchinterest(root, primary, 1)
                            end
                        end
                        wait(0.1)
                    end
                end
                wait(1)
            end
        end)
    end
end)

--// ==================== PLAYER TAB ====================
local PlayerGroup = Tabs.Player:AddLeftGroupbox('Movement')

PlayerGroup:AddToggle('SpeedHack', {
    Text = 'Speed Hack',
    Default = false,
})

PlayerGroup:AddSlider('SpeedValue', {
    Text = 'Speed',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
})

Toggles.SpeedHack:OnChanged(function()
    SpeedEnabled = Toggles.SpeedHack.Value
    if SpeedEnabled then
        spawn(function()
            while SpeedEnabled do
                local humanoid = GetHumanoid(LocalPlayer)
                if humanoid then
                    humanoid.WalkSpeed = Options.SpeedValue.Value
                end
                wait(0.1)
            end
        end)
    else
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end)

Options.SpeedValue:OnChanged(function()
    SpeedValue = Options.SpeedValue.Value
end)

PlayerGroup:AddToggle('JumpHack', {
    Text = 'Jump Power Hack',
    Default = false,
})

PlayerGroup:AddSlider('JumpValue', {
    Text = 'Jump Power',
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 0,
})

Toggles.JumpHack:OnChanged(function()
    JumpEnabled = Toggles.JumpHack.Value
    if JumpEnabled then
        spawn(function()
            while JumpEnabled do
                local humanoid = GetHumanoid(LocalPlayer)
                if humanoid then
                    humanoid.JumpPower = Options.JumpValue.Value
                    humanoid.UseJumpPower = true
                end
                wait(0.1)
            end
        end)
    else
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid then
            humanoid.JumpPower = 50
        end
    end
end)

PlayerGroup:AddToggle('InfiniteJump', {
    Text = 'Infinite Jump',
    Default = false,
})

Toggles.InfiniteJump:OnChanged(function()
    InfiniteJumpEnabled = Toggles.InfiniteJump.Value
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerGroup:AddToggle('Noclip', {
    Text = 'Noclip',
    Default = false,
    Tooltip = 'Walk through walls'
})

Toggles.Noclip:OnChanged(function()
    NoclipEnabled = Toggles.Noclip.Value
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local char = GetCharacter(LocalPlayer)
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local PlayerGroup2 = Tabs.Player:AddLeftGroupbox('Fly')

PlayerGroup2:AddToggle('Fly', {
    Text = 'Fly',
    Default = false,
})

PlayerGroup2:AddSlider('FlySpeed', {
    Text = 'Fly Speed',
    Default = 50,
    Min = 10,
    Max = 300,
    Rounding = 0,
})

local flyBody = nil
local flyGyro = nil

Toggles.Fly:OnChanged(function()
    FlyEnabled = Toggles.Fly.Value
    local root = GetRootPart(LocalPlayer)
    local humanoid = GetHumanoid(LocalPlayer)
    
    if FlyEnabled and root then
        if flyBody then flyBody:Destroy() end
        if flyGyro then flyGyro:Destroy() end
        
        flyBody = Instance.new("BodyVelocity")
        flyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBody.Velocity = Vector3.new(0, 0, 0)
        flyBody.Parent = root
        
        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.P = 9e4
        flyGyro.Parent = root
        
        if humanoid then
            humanoid.PlatformStand = true
        end
        
        spawn(function()
            while FlyEnabled do
                if flyBody and flyGyro then
                    local speed = Options.FlySpeed.Value
                    local moveDir = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - Camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - Camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + Camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        moveDir = moveDir - Vector3.new(0, 1, 0)
                    end
                    
                    -- Mobile support - check thumbstick
                    local moveVector = humanoid and humanoid.MoveDirection or Vector3.new(0,0,0)
                    if moveVector.Magnitude > 0.1 then
                        moveDir = moveDir + Camera.CFrame:VectorToWorldSpace(Vector3.new(moveVector.X, 0, -moveVector.Z))
                    end
                    
                    flyBody.Velocity = moveDir * speed
                    flyGyro.CFrame = Camera.CFrame
                end
                RunService.Heartbeat:Wait()
            end
        end)
    else
        if flyBody then flyBody:Destroy() flyBody = nil end
        if flyGyro then flyGyro:Destroy() flyGyro = nil end
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end)

local PlayerGroup3 = Tabs.Player:AddRightGroupbox('Teleports')

PlayerGroup3:AddButton({
    Text = 'Teleport to Lobby',
    Func = function()
        local root = GetRootPart(LocalPlayer)
        if root then
            root.CFrame = CFrame.new(0, 50, 0)
            Notify("Teleport", "Teleported to lobby area", 2)
        end
    end,
})

PlayerGroup3:AddButton({
    Text = 'Teleport to Sheriff',
    Func = function()
        local sheriff = GetSheriff()
        local root = GetRootPart(LocalPlayer)
        if sheriff and root then
            local sRoot = GetRootPart(sheriff)
            if sRoot then
                root.CFrame = sRoot.CFrame + Vector3.new(3, 0, 0)
                Notify("Teleport", "Teleported to Sheriff: " .. sheriff.Name, 2)
            end
        else
            Notify("Teleport", "Sheriff not found!", 2)
        end
    end,
})

PlayerGroup3:AddButton({
    Text = 'Teleport to Murderer',
    Func = function()
        local murderer = GetMurderer()
        local root = GetRootPart(LocalPlayer)
        if murderer and root then
            local mRoot = GetRootPart(murderer)
            if mRoot then
                root.CFrame = mRoot.CFrame + Vector3.new(3, 0, 0)
                Notify("Teleport", "Teleported to Murderer: " .. murderer.Name, 2)
            end
        else
            Notify("Teleport", "Murderer not found!", 2)
        end
    end,
})

PlayerGroup3:AddButton({
    Text = 'Reset Character',
    Func = function()
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid then
            humanoid.Health = 0
        end
    end,
})

local PlayerGroup4 = Tabs.Player:AddRightGroupbox('Character')

PlayerGroup4:AddSlider('Transparency', {
    Text = 'Character Transparency',
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%'
})

Options.Transparency:OnChanged(function()
    local char = GetCharacter(LocalPlayer)
    if char then
        local trans = Options.Transparency.Value / 100
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = trans
            end
        end
    end
end)

PlayerGroup4:AddToggle('Spinbot', {
    Text = 'Spinbot',
    Default = false,
})

PlayerGroup4:AddSlider('SpinSpeed', {
    Text = 'Spin Speed',
    Default = 10,
    Min = 1,
    Max = 100,
    Rounding = 0,
})

Toggles.Spinbot:OnChanged(function()
    SpinbotEnabled = Toggles.Spinbot.Value
    if SpinbotEnabled then
        spawn(function()
            while SpinbotEnabled do
                local root = GetRootPart(LocalPlayer)
                if root then
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Options.SpinSpeed.Value), 0)
                end
                RunService.RenderStepped:Wait()
            end
        end)
    end
end)

--// ==================== VISUALS TAB ====================
local VisualsGroup = Tabs.Visuals:AddLeftGroupbox('ESP')

-- ESP Drawing functions
local function CreateESP(player, color, roleName)
    if ESPObjects[player.Name] then
        for _, obj in pairs(ESPObjects[player.Name]) do
            if obj and obj.Remove then obj:Remove() end
        end
    end
    
    ESPObjects[player.Name] = {}
    
    -- Name ESP
    local nameTag = Drawing.new("Text")
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = color
    nameTag.Visible = false
    nameTag.Font = Drawing.Fonts.Plex
    table.insert(ESPObjects[player.Name], nameTag)
    
    -- Box ESP
    local boxOutline = Drawing.new("Square")
    boxOutline.Thickness = 3
    boxOutline.Color = Color3.new(0, 0, 0)
    boxOutline.Filled = false
    boxOutline.Visible = false
    table.insert(ESPObjects[player.Name], boxOutline)
    
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = color
    box.Filled = false
    box.Visible = false
    table.insert(ESPObjects[player.Name], box)
    
    -- Tracer
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = color
    tracer.Visible = false
    table.insert(ESPObjects[player.Name], tracer)
    
    -- Health bar
    local healthBar = Drawing.new("Line")
    healthBar.Thickness = 2
    healthBar.Color = Color3.new(0, 1, 0)
    healthBar.Visible = false
    table.insert(ESPObjects[player.Name], healthBar)
    
    -- Distance text
    local distText = Drawing.new("Text")
    distText.Size = 14
    distText.Center = true
    distText.Outline = true
    distText.Color = Color3.new(1, 1, 1)
    distText.Visible = false
    distText.Font = Drawing.Fonts.Plex
    table.insert(ESPObjects[player.Name], distText)
    
    return {nameTag = nameTag, box = box, boxOutline = boxOutline, tracer = tracer, healthBar = healthBar, distText = distText, color = color, roleName = roleName}
end

local function UpdateESP(player, espData)
    if not espData then return end
    
    local char = GetCharacter(player)
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local head = char and char:FindFirstChild("Head")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local myRoot = GetRootPart(LocalPlayer)
    
    if not root or not head or not humanoid or humanoid.Health <= 0 or not myRoot then
        espData.nameTag.Visible = false
        espData.box.Visible = false
        espData.boxOutline.Visible = false
        espData.tracer.Visible = false
        espData.healthBar.Visible = false
        espData.distText.Visible = false
        return
    end
    
    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
    local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
    
    if onScreen then
        local height = math.abs(headPos.Y - legPos.Y)
        local width = height / 2
        local distance = math.floor((myRoot.Position - root.Position).Magnitude)
        
        -- Role name display
        local displayName = player.Name
        if espData.roleName then
            displayName = "[" .. espData.roleName .. "] " .. player.Name
        end
        
        -- Name
        if NameESPEnabled or PlayerESPEnabled then
            espData.nameTag.Text = displayName
            espData.nameTag.Position = Vector2.new(pos.X, headPos.Y - 20)
            espData.nameTag.Color = espData.color
            espData.nameTag.Visible = true
        else
            espData.nameTag.Visible = false
        end
        
        -- Box
        if PlayerESPEnabled then
            espData.box.Size = Vector2.new(width, height)
            espData.box.Position = Vector2.new(pos.X - width / 2, headPos.Y)
            espData.box.Color = espData.color
            espData.box.Visible = true
            
            espData.boxOutline.Size = Vector2.new(width + 2, height + 2)
            espData.boxOutline.Position = Vector2.new(pos.X - width / 2 - 1, headPos.Y - 1)
            espData.boxOutline.Visible = true
        else
            espData.box.Visible = false
            espData.boxOutline.Visible = false
        end
        
        -- Tracer
        if TracerEnabled then
            espData.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            espData.tracer.To = Vector2.new(pos.X, pos.Y)
            espData.tracer.Color = espData.color
            espData.tracer.Visible = true
        else
            espData.tracer.Visible = false
        end
        
        -- Health bar
        if HealthESPEnabled then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            espData.healthBar.From = Vector2.new(pos.X - width / 2 - 5, legPos.Y)
            espData.healthBar.To = Vector2.new(pos.X - width / 2 - 5, legPos.Y - (height * healthPercent))
            espData.healthBar.Color = Color3.new(1 - healthPercent, healthPercent, 0)
            espData.healthBar.Visible = true
        else
            espData.healthBar.Visible = false
        end
        
        -- Distance
        espData.distText.Text = tostring(distance) .. " studs"
        espData.distText.Position = Vector2.new(pos.X, legPos.Y + 5)
        espData.distText.Visible = true
    else
        espData.nameTag.Visible = false
        espData.box.Visible = false
        espData.boxOutline.Visible = false
        espData.tracer.Visible = false
        espData.healthBar.Visible = false
        espData.distText.Visible = false
    end
end

local activeESP = {}

VisualsGroup:AddToggle('PlayerESP', {
    Text = 'Player ESP (Box)',
    Default = false,
})

VisualsGroup:AddToggle('NameESP', {
    Text = 'Name ESP',
    Default = false,
})

VisualsGroup:AddToggle('TracerESP', {
    Text = 'Tracer ESP',
    Default = false,
})

VisualsGroup:AddToggle('HealthESP', {
    Text = 'Health ESP',
    Default = false,
})

VisualsGroup:AddToggle('MurdererESPToggle', {
    Text = 'Murderer ESP (Red)',
    Default = false,
})

VisualsGroup:AddToggle('SheriffESPToggle', {
    Text = 'Sheriff ESP (Blue)',
    Default = false,
})

Toggles.PlayerESP:OnChanged(function()
    PlayerESPEnabled = Toggles.PlayerESP.Value
end)

Toggles.NameESP:OnChanged(function()
    NameESPEnabled = Toggles.NameESP.Value
end)

Toggles.TracerESP:OnChanged(function()
    TracerEnabled = Toggles.TracerESP.Value
end)

Toggles.HealthESP:OnChanged(function()
    HealthESPEnabled = Toggles.HealthESP.Value
end)

Toggles.MurdererESPToggle:OnChanged(function()
    MurdererESP = Toggles.MurdererESPToggle.Value
end)

Toggles.SheriffESPToggle:OnChanged(function()
    SheriffESP = Toggles.SheriffESPToggle.Value
end)

-- ESP Update Loop
spawn(function()
    while true do
        -- Clean up old ESP
        for name, data in pairs(activeESP) do
            local player = Players:FindFirstChild(name)
            if not player or player == LocalPlayer then
                if ESPObjects[name] then
                    for _, obj in pairs(ESPObjects[name]) do
                        if obj and obj.Remove then obj:Remove() end
                    end
                    ESPObjects[name] = nil
                end
                activeESP[name] = nil
            end
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local role = GetRole(player)
                local shouldShow = PlayerESPEnabled or NameESPEnabled or TracerEnabled or HealthESPEnabled
                
                -- Color by role
                local color = Color3.new(1, 1, 1) -- White (Innocent)
                local roleName = nil
                
                if role == "Murderer" then
                    color = Color3.new(1, 0, 0) -- Red
                    roleName = "Murderer"
                    if MurdererESP then shouldShow = true end
                elseif role == "Sheriff" then
                    color = Color3.new(0, 0.5, 1) -- Blue
                    roleName = "Sheriff"
                    if SheriffESP then shouldShow = true end
                else
                    color = Color3.new(0, 1, 0) -- Green
                    roleName = "Innocent"
                end
                
                if shouldShow then
                    if not activeESP[player.Name] then
                        activeESP[player.Name] = CreateESP(player, color, roleName)
                    else
                        activeESP[player.Name].color = color
                        activeESP[player.Name].roleName = roleName
                    end
                    UpdateESP(player, activeESP[player.Name])
                else
                    if activeESP[player.Name] then
                        if ESPObjects[player.Name] then
                            for _, obj in pairs(ESPObjects[player.Name]) do
                                if obj then obj.Visible = false end
                            end
                        end
                    end
                end
            end
        end
        
        RunService.RenderStepped:Wait()
    end
end)

local VisualsGroup2 = Tabs.Visuals:AddLeftGroupbox('World ESP')

VisualsGroup2:AddToggle('GunESPToggle', {
    Text = 'Gun Drop ESP',
    Default = false,
})

VisualsGroup2:AddToggle('CoinESPToggle', {
    Text = 'Coin ESP',
    Default = false,
})

VisualsGroup2:AddToggle('TrapESPToggle', {
    Text = 'Trap ESP',
    Default = false,
})

-- World ESP highlight system
local worldHighlights = {}

local function ClearWorldHighlights()
    for _, h in pairs(worldHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    worldHighlights = {}
end

Toggles.GunESPToggle:OnChanged(function()
    GunESP = Toggles.GunESPToggle.Value
end)

Toggles.CoinESPToggle:OnChanged(function()
    CoinESP = Toggles.CoinESPToggle.Value
end)

Toggles.TrapESPToggle:OnChanged(function()
    TrapESP = Toggles.TrapESPToggle.Value
end)

spawn(function()
    while true do
        -- Gun ESP
        if GunESP then
            local gunDrop = GetGunDrop()
            if gunDrop then
                if not gunDrop:FindFirstChild("GunHighlight") then
                    local h = Instance.new("Highlight")
                    h.Name = "GunHighlight"
                    h.FillColor = Color3.new(1, 1, 0)
                    h.OutlineColor = Color3.new(1, 0.8, 0)
                    h.FillTransparency = 0.3
                    h.Adornee = gunDrop.Parent:IsA("Model") and gunDrop.Parent or gunDrop
                    h.Parent = gunDrop
                    table.insert(worldHighlights, h)
                    
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "GunBB"
                    bb.Size = UDim2.new(0, 100, 0, 30)
                    bb.StudsOffset = Vector3.new(0, 3, 0)
                    bb.AlwaysOnTop = true
                    bb.Adornee = gunDrop
                    bb.Parent = gunDrop
                    
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = "🔫 GUN"
                    tl.TextColor3 = Color3.new(1, 1, 0)
                    tl.TextStrokeTransparency = 0
                    tl.TextScaled = true
                    tl.Font = Enum.Font.GothamBold
                    tl.Parent = bb
                    table.insert(worldHighlights, bb)
                end
            end
        end
        
        -- Coin ESP
        if CoinESP then
            local coins = GetCoins()
            for _, coin in pairs(coins) do
                local part = coin:IsA("BasePart") and coin or coin:FindFirstChildWhichIsA("BasePart")
                if part and not part:FindFirstChild("CoinHighlight") then
                    local h = Instance.new("Highlight")
                    h.Name = "CoinHighlight"
                    h.FillColor = Color3.new(0, 1, 0)
                    h.OutlineColor = Color3.new(0, 0.8, 0)
                    h.FillTransparency = 0.5
                    h.Adornee = coin:IsA("Model") and coin or part
                    h.Parent = part
                    table.insert(worldHighlights, h)
                end
            end
        end
        
        -- Trap ESP
        if TrapESP then
            local traps = GetTraps()
            for _, trap in pairs(traps) do
                local part = trap:IsA("BasePart") and trap or trap:FindFirstChildWhichIsA("BasePart")
                if part and not part:FindFirstChild("TrapHighlight") then
                    local h = Instance.new("Highlight")
                    h.Name = "TrapHighlight"
                    h.FillColor = Color3.new(1, 0, 0)
                    h.OutlineColor = Color3.new(1, 0.3, 0)
                    h.FillTransparency = 0.3
                    h.Adornee = trap:IsA("Model") and trap or part
                    h.Parent = part
                    table.insert(worldHighlights, h)
                    
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "TrapBB"
                    bb.Size = UDim2.new(0, 80, 0, 25)
                    bb.StudsOffset = Vector3.new(0, 2, 0)
                    bb.AlwaysOnTop = true
                    bb.Adornee = part
                    bb.Parent = part
                    
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.Text = "⚠ TRAP"
                    tl.TextColor3 = Color3.new(1, 0, 0)
                    tl.TextStrokeTransparency = 0
                    tl.TextScaled = true
                    tl.Font = Enum.Font.GothamBold
                    tl.Parent = bb
                    table.insert(worldHighlights, bb)
                end
            end
        end
        
        wait(1)
    end
end)

local VisualsGroup3 = Tabs.Visuals:AddRightGroupbox('World Effects')

VisualsGroup3:AddToggle('Fullbright', {
    Text = 'Fullbright',
    Default = false,
})

local savedLighting = {}

Toggles.Fullbright:OnChanged(function()
    FullbrightEnabled = Toggles.Fullbright.Value
    local lighting = game:GetService("Lighting")
    
    if FullbrightEnabled then
        savedLighting.Ambient = lighting.Ambient
        savedLighting.Brightness = lighting.Brightness
        savedLighting.FogEnd = lighting.FogEnd
        savedLighting.FogStart = lighting.FogStart
        savedLighting.GlobalShadows = lighting.GlobalShadows
        savedLighting.OutdoorAmbient = lighting.OutdoorAmbient
        
        lighting.Ambient = Color3.new(1, 1, 1)
        lighting.Brightness = 2
        lighting.FogEnd = 100000
        lighting.FogStart = 0
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        
        -- Remove blur/color correction
        for _, effect in pairs(lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("AtmosphereEffect") then
                effect.Enabled = false
            end
        end
    else
        if savedLighting.Ambient then
            lighting.Ambient = savedLighting.Ambient
            lighting.Brightness = savedLighting.Brightness
            lighting.FogEnd = savedLighting.FogEnd
            lighting.FogStart = savedLighting.FogStart
            lighting.GlobalShadows = savedLighting.GlobalShadows
            lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
        end
        
        for _, effect in pairs(lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("AtmosphereEffect") then
                effect.Enabled = true
            end
        end
    end
end)

VisualsGroup3:AddToggle('Xray', {
    Text = 'X-Ray (See through walls)',
    Default = false,
})

Toggles.Xray:OnChanged(function()
    XrayEnabled = Toggles.Xray.Value
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(GetCharacter(LocalPlayer) or Instance.new("Folder")) then
            if obj.Name ~= "Baseplate" and obj.Name ~= "Terrain" then
                if XrayEnabled then
                    obj.Transparency = math.max(obj.Transparency, 0.7)
                    obj.LocalTransparencyModifier = 0.7
                end
            end
        end
    end
    if not XrayEnabled then
        Notify("X-Ray", "Rejoin to fully restore walls", 3)
    end
end)

VisualsGroup3:AddToggle('PlayerChams', {
    Text = 'Player Chams (Highlight)',
    Default = false,
})

Toggles.PlayerChams:OnChanged(function()
    ChamEnabled = Toggles.PlayerChams.Value
    
    if ChamEnabled then
        spawn(function()
            while ChamEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local char = GetCharacter(player)
                        if char and not char:FindFirstChild("PlayerCham") then
                            local h = Instance.new("Highlight")
                            h.Name = "PlayerCham"
                            
                            local role = GetRole(player)
                            if role == "Murderer" then
                                h.FillColor = Color3.new(1, 0, 0)
                                h.OutlineColor = Color3.new(1, 0.2, 0.2)
                            elseif role == "Sheriff" then
                                h.FillColor = Color3.new(0, 0.4, 1)
                                h.OutlineColor = Color3.new(0.3, 0.5, 1)
                            else
                                h.FillColor = Color3.new(0, 1, 0)
                                h.OutlineColor = Color3.new(0.3, 1, 0.3)
                            end
                            
                            h.FillTransparency = 0.5
                            h.OutlineTransparency = 0
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Parent = char
                        elseif char and char:FindFirstChild("PlayerCham") then
                            local h = char.PlayerCham
                            local role = GetRole(player)
                            if role == "Murderer" then
                                h.FillColor = Color3.new(1, 0, 0)
                            elseif role == "Sheriff" then
                                h.FillColor = Color3.new(0, 0.4, 1)
                            else
                                h.FillColor = Color3.new(0, 1, 0)
                            end
                        end
                    end
                end
                wait(1)
            end
            
            -- Clean up chams
            for _, player in pairs(Players:GetPlayers()) do
                local char = GetCharacter(player)
                if char then
                    local h = char:FindFirstChild("PlayerCham")
                    if h then h:Destroy() end
                end
            end
        end)
    end
end)

VisualsGroup3:AddSlider('FOVCircle', {
    Text = 'FOV Circle Size',
    Default = 0,
    Min = 0,
    Max = 500,
    Rounding = 0,
})

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Color = Color3.new(1, 1, 1)
fovCircle.Filled = false
fovCircle.Visible = false

Options.FOVCircle:OnChanged(function()
    if Options.FOVCircle.Value > 0 then
        fovCircle.Visible = true
        fovCircle.Radius = Options.FOVCircle.Value
    else
        fovCircle.Visible = false
    end
end)

RunService.RenderStepped:Connect(function()
    if fovCircle.Visible then
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

--// ==================== COMBAT TAB ====================
local CombatGroup = Tabs.Combat:AddLeftGroupbox('Aimbot')

CombatGroup:AddToggle('Aimbot', {
    Text = 'Aimbot (Gun)',
    Default = false,
    Tooltip = 'Aims at nearest player when holding gun'
})

CombatGroup:AddDropdown('AimbotTarget', {
    Values = {'Nearest', 'Murderer Only'},
    Default = 1,
    Multi = false,
    Text = 'Target Mode'
})

CombatGroup:AddSlider('AimbotFOV', {
    Text = 'Aimbot FOV',
    Default = 200,
    Min = 50,
    Max = 800,
    Rounding = 0,
})

CombatGroup:AddSlider('AimbotSmooth', {
    Text = 'Smoothness',
    Default = 5,
    Min = 1,
    Max = 20,
    Rounding = 1,
})

Toggles.Aimbot:OnChanged(function()
    AimbotEnabled = Toggles.Aimbot.Value
end)

local function GetClosestPlayerToMouse()
    local closest = nil
    local closestDist = Options.AimbotFOV.Value
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = GetCharacter(player)
            local head = char and char:FindFirstChild("Head")
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local targetMode = Options.AimbotTarget.Value
                
                if targetMode == "Murderer Only" then
                    if GetRole(player) ~= "Murderer" then
                        continue
                    end
                end
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetClosestPlayerToMouse()
        if target then
            local char = GetCharacter(target)
            local head = char and char:FindFirstChild("Head")
            if head then
                local smooth = Options.AimbotSmooth.Value
                local targetCFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / smooth)
            end
        end
    end
end)

local CombatGroup2 = Tabs.Combat:AddLeftGroupbox('Silent Aim')

CombatGroup2:AddToggle('SilentAim', {
    Text = 'Silent Aim',
    Default = false,
    Tooltip = 'Bullets hit closest player'
})

Toggles.SilentAim:OnChanged(function()
    SilentAimEnabled = Toggles.SilentAim.Value
end)

-- Silent aim hook
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if SilentAimEnabled and method == "FireServer" then
        if self.Name == "ShootGun" or self.Name == "RemoteFunction" or tostring(self):find("Shoot") then
            local target = GetClosestPlayerToMouse()
            if target then
                local char = GetCharacter(target)
                local head = char and char:FindFirstChild("Head")
                if head then
                    -- Modify args to aim at target
                    for i, arg in pairs(args) do
                        if typeof(arg) == "Vector3" then
                            args[i] = head.Position
                        elseif typeof(arg) == "CFrame" then
                            args[i] = CFrame.new(Camera.CFrame.Position, head.Position)
                        end
                    end
                end
            end
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

local CombatGroup3 = Tabs.Combat:AddRightGroupbox('Hitbox')

CombatGroup3:AddToggle('HitboxExpander', {
    Text = 'Hitbox Expander',
    Default = false,
})

CombatGroup3:AddSlider('HitboxSize', {
    Text = 'Hitbox Size',
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
})

CombatGroup3:AddDropdown('HitboxTarget', {
    Values = {'All Players', 'Murderer Only', 'Sheriff Only'},
    Default = 1,
    Multi = false,
    Text = 'Target'
})

Toggles.HitboxExpander:OnChanged(function()
    HitboxExpanderEnabled = Toggles.HitboxExpander.Value
    if HitboxExpanderEnabled then
        spawn(function()
            while HitboxExpanderEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local char = GetCharacter(player)
                        local root = char and char:FindFirstChild("HumanoidRootPart")
                        if root then
                            local target = Options.HitboxTarget.Value
                            local shouldExpand = false
                            
                            if target == "All Players" then
                                shouldExpand = true
                            elseif target == "Murderer Only" and GetRole(player) == "Murderer" then
                                shouldExpand = true
                            elseif target == "Sheriff Only" and GetRole(player) == "Sheriff" then
                                shouldExpand = true
                            end
                            
                            if shouldExpand then
                                root.Size = Vector3.new(Options.HitboxSize.Value, Options.HitboxSize.Value, Options.HitboxSize.Value)
                                root.Transparency = 0.7
                                root.Color = Color3.new(1, 0, 0)
                                root.CanCollide = false
                                root.Material = Enum.Material.ForceField
                            end
                        end
                    end
                end
                wait(0.5)
            end
            
            -- Reset hitboxes
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local char = GetCharacter(player)
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(2, 2, 1)
                        root.Transparency = 1
                        root.CanCollide = false
                    end
                end
            end
        end)
    end
end)

local CombatGroup4 = Tabs.Combat:AddRightGroupbox('TP Gun')

CombatGroup4:AddToggle('TPGun', {
    Text = 'TP Gun (Click to TP behind)',
    Default = false,
    Tooltip = 'Click a player to teleport behind them'
})

Toggles.TPGun:OnChanged(function()
    TPGunEnabled = Toggles.TPGun.Value
end)

local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if TPGunEnabled then
        local target = mouse.Target
        if target then
            local char = target:FindFirstAncestorOfClass("Model")
            if char then
                local player = Players:GetPlayerFromCharacter(char)
                if player and player ~= LocalPlayer then
                    local root = GetRootPart(player)
                    local myRoot = GetRootPart(LocalPlayer)
                    if root and myRoot then
                        myRoot.CFrame = root.CFrame * CFrame.new(0, 0, 3)
                        Notify("TP Gun", "Teleported behind " .. player.Name, 2)
                    end
                end
            end
        end
    end
end)

--// ==================== TROLLING TAB ====================
local TrollGroup = Tabs.Trolling:AddLeftGroupbox('Fling')

TrollGroup:AddDropdown('FlingPlayer', {
    Values = GetPlayerList(),
    Default = 1,
    Multi = false,
    Text = 'Select Player'
})

TrollGroup:AddButton({
    Text = '🔄 Refresh Player List',
    Func = function()
        Options.FlingPlayer:SetValues(GetPlayerList())
        Notify("Refreshed", "Player list updated!", 2)
    end,
})

TrollGroup:AddButton({
    Text = '💥 FLING PLAYER',
    Func = function()
        local targetName = Options.FlingPlayer.Value
        local target = Players:FindFirstChild(targetName)
        if not target then
            Notify("Fling", "Player not found!", 2)
            return
        end
        
        local targetRoot = GetRootPart(target)
        local myRoot = GetRootPart(LocalPlayer)
        local myHumanoid = GetHumanoid(LocalPlayer)
        
        if not targetRoot or not myRoot or not myHumanoid then
            Notify("Fling", "Cannot fling right now!", 2)
            return
        end
        
        Notify("Fling", "Flinging " .. targetName .. "...", 3)
        
        FlingActive = true
        FlingTarget = target
        
        -- Save original values
        local originalSpeed = myHumanoid.WalkSpeed
        local originalJump = myHumanoid.JumpPower
        
        spawn(function()
            local startTime = tick()
            local bodyVel = Instance.new("BodyAngularVelocity")
            bodyVel.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyVel.AngularVelocity = Vector3.new(0, 9999, 0)
            bodyVel.Parent = myRoot
            
            while FlingActive and tick() - startTime < 10 do
                local tRoot = GetRootPart(target)
                if tRoot and myRoot then
                    myRoot.CFrame = tRoot.CFrame
                    myRoot.Velocity = Vector3.new(9999, 9999, 9999)
                    myRoot.RotVelocity = Vector3.new(9999, 9999, 9999)
                    
                    for _, part in pairs(GetCharacter(LocalPlayer):GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.Velocity = Vector3.new(math.random(-100,100), math.random(50,200), math.random(-100,100))
                        end
                    end
                else
                    break
                end
                RunService.Heartbeat:Wait()
            end
            
            if bodyVel then bodyVel:Destroy() end
            FlingActive = false
            
            -- Reset
            myRoot.Velocity = Vector3.new(0, 0, 0)
            myRoot.RotVelocity = Vector3.new(0, 0, 0)
            myHumanoid.WalkSpeed = originalSpeed
            myHumanoid.JumpPower = originalJump
            
            Notify("Fling", "Fling completed!", 2)
        end)
    end,
    DoubleClick = true,
    Tooltip = 'Double click to fling selected player'
})

TrollGroup:AddButton({
    Text = '⛔ Stop Fling',
    Func = function()
        FlingActive = false
        Notify("Fling", "Fling stopped!", 2)
    end,
})

local TrollGroup2 = Tabs.Trolling:AddLeftGroupbox('Annoy')

TrollGroup2:AddDropdown('AnnoyPlayer', {
    Values = GetPlayerList(),
    Default = 1,
    Multi = false,
    Text = 'Select Player'
})

TrollGroup2:AddButton({
    Text = '🔄 Refresh Players',
    Func = function()
        Options.AnnoyPlayer:SetValues(GetPlayerList())
    end,
})

local AnnoyActive = false

TrollGroup2:AddToggle('AnnoyToggle', {
    Text = '😈 Annoy Player (Follow)',
    Default = false,
})

Toggles.AnnoyToggle:OnChanged(function()
    AnnoyActive = Toggles.AnnoyToggle.Value
    if AnnoyActive then
        spawn(function()
            while AnnoyActive do
                local targetName = Options.AnnoyPlayer.Value
                local target = Players:FindFirstChild(targetName)
                if target then
                    local tRoot = GetRootPart(target)
                    local myRoot = GetRootPart(LocalPlayer)
                    if tRoot and myRoot then
                        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, -2)
                    end
                end
                wait(0.05)
            end
        end)
    end
end)

TrollGroup2:AddToggle('OrbitToggle', {
    Text = '🌀 Orbit Player',
    Default = false,
})

TrollGroup2:AddSlider('OrbitRadius', {
    Text = 'Orbit Radius',
    Default = 10,
    Min = 3,
    Max = 30,
    Rounding = 0,
})

TrollGroup2:AddSlider('OrbitSpeed', {
    Text = 'Orbit Speed',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
})

local OrbitActive = false

Toggles.OrbitToggle:OnChanged(function()
    OrbitActive = Toggles.OrbitToggle.Value
    if OrbitActive then
        spawn(function()
            local angle = 0
            while OrbitActive do
                local targetName = Options.AnnoyPlayer.Value
                local target = Players:FindFirstChild(targetName)
                if target then
                    local tRoot = GetRootPart(target)
                    local myRoot = GetRootPart(LocalPlayer)
                    if tRoot and myRoot then
                        local radius = Options.OrbitRadius.Value
                        local speed = Options.OrbitSpeed.Value
                        angle = angle + speed * 0.05
                        
                        local x = math.cos(angle) * radius
                        local z = math.sin(angle) * radius
                        
                        myRoot.CFrame = CFrame.new(
                            tRoot.Position.X + x,
                            tRoot.Position.Y,
                            tRoot.Position.Z + z
                        )
                    end
                end
                RunService.RenderStepped:Wait()
            end
        end)
    end
end)

local TrollGroup3 = Tabs.Trolling:AddRightGroupbox('Chat & Effects')

TrollGroup3:AddButton({
    Text = '💬 Spam Chat "EZ"',
    Func = function()
        spawn(function()
            for i = 1, 10 do
                local args = {
                    "EZ EZ EZ GET REKT",
                    "All"
                }
                local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chatRemote then
                    local sayMsg = chatRemote:FindFirstChild("SayMessageRequest")
                    if sayMsg then
                        sayMsg:FireServer(args[1], args[2])
                    end
                end
                wait(1)
            end
        end)
    end,
})

TrollGroup3:AddButton({
    Text = '🔊 Play Animation (Dance)',
    Func = function()
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://5917459365" -- Dance animation
            local animTrack = humanoid:LoadAnimation(anim)
            animTrack:Play()
            Notify("Animation", "Playing dance!", 2)
        end
    end,
})

TrollGroup3:AddButton({
    Text = '🤸 Play Animation (Headless)',
    Func = function()
        local humanoid = GetHumanoid(LocalPlayer)
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://5915693819"
            local animTrack = humanoid:LoadAnimation(anim)
            animTrack:Play()
        end
    end,
})

local TrollGroup4 = Tabs.Trolling:AddRightGroupbox('Fling All')

TrollGroup4:AddButton({
    Text = '💥 FLING ALL PLAYERS',
    Func = function()
        Notify("Fling All", "Flinging all players... This may lag!", 3)
        spawn(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local targetRoot = GetRootPart(player)
                    local myRoot = GetRootPart(LocalPlayer)
                    if targetRoot and myRoot then
                        for i = 1, 50 do
                            myRoot.CFrame = targetRoot.CFrame
                            myRoot.Velocity = Vector3.new(9999, 9999, 9999)
                            RunService.Heartbeat:Wait()
                        end
                    end
                end
            end
            Notify("Fling All", "Done!", 2)
        end)
    end,
    DoubleClick = true,
    Tooltip = 'Double click - Flings everyone'
})

TrollGroup4:AddButton({
    Text = '🔪 Bring All to Murderer',
    Func = function()
        local murderer = GetMurderer()
        if not murderer then
            Notify("Error", "No murderer found!", 2)
            return
        end
        local mRoot = GetRootPart(murderer)
        if not mRoot then return end
        
        Notify("Trolling", "Bringing all to murderer...", 3)
        -- This is client-side only and won't work on other players in most cases
        -- Keeping for UI completeness
    end,
    DoubleClick = true,
})

--// ==================== TELEPORT TAB ====================
local TPGroup = Tabs.Teleport:AddLeftGroupbox('Player Teleport')

TPGroup:AddDropdown('TPPlayer', {
    Values = GetPlayerList(),
    Default = 1,
    Multi = false,
    Text = 'Select Player'
})

TPGroup:AddButton({
    Text = '🔄 Refresh Players',
    Func = function()
        Options.TPPlayer:SetValues(GetPlayerList())
        Notify("Refreshed", "Player list updated!", 2)
    end,
})

TPGroup:AddButton({
    Text = '📍 Teleport to Player',
    Func = function()
        local targetName = Options.TPPlayer.Value
        local target = Players:FindFirstChild(targetName)
        if target then
            local tRoot = GetRootPart(target)
            local myRoot = GetRootPart(LocalPlayer)
            if tRoot and myRoot then
                myRoot.CFrame = tRoot.CFrame + Vector3.new(3, 0, 0)
                Notify("Teleport", "Teleported to " .. targetName, 2)
            end
        else
            Notify("Teleport", "Player not found!", 2)
        end
    end,
})

TPGroup:AddButton({
    Text = '📍 Teleport Behind Player',
    Func = function()
        local targetName = Options.TPPlayer.Value
        local target = Players:FindFirstChild(targetName)
        if target then
            local tRoot = GetRootPart(target)
            local myRoot = GetRootPart(LocalPlayer)
            if tRoot and myRoot then
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 5)
                Notify("Teleport", "Teleported behind " .. targetName, 2)
            end
        end
    end,
})

local TPGroup2 = Tabs.Teleport:AddLeftGroupbox('Map Locations')

TPGroup2:AddButton({
    Text = '📍 TP to Spawn',
    Func = function()
        local root = GetRootPart(LocalPlayer)
        if root then
            local spawn = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChild("Lobby")
            if spawn then
                root.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            else
                root.CFrame = CFrame.new(0, 50, 0)
            end
            Notify("Teleport", "Teleported to spawn!", 2)
        end
    end,
})

TPGroup2:AddButton({
    Text = '📍 TP to Random Location',
    Func = function()
        local root = GetRootPart(LocalPlayer)
        if root then
            root.CFrame = CFrame.new(math.random(-200, 200), 50, math.random(-200, 200))
            Notify("Teleport", "Teleported to random location!", 2)
        end
    end,
})

TPGroup2:AddButton({
    Text = '📍 TP to Highest Point',
    Func = function()
        local root = GetRootPart(LocalPlayer)
        if root then
            root.CFrame = CFrame.new(root.Position.X, 500, root.Position.Z)
            Notify("Teleport", "Teleported up!", 2)
        end
    end,
})

local TPGroup3 = Tabs.Teleport:AddRightGroupbox('Saved Positions')

local savedPositions = {}

TPGroup3:AddButton({
    Text = '💾 Save Current Position',
    Func = function()
        local root = GetRootPart(LocalPlayer)
        if root then
            table.insert(savedPositions, root.CFrame)
            Notify("Save", "Position #" .. #savedPositions .. " saved!", 2)
        end
    end,
})

TPGroup3:AddButton({
    Text = '📍 TP to Last Saved Position',
    Func = function()
        local root = GetRootPart(LocalPlayer)
        if root and #savedPositions > 0 then
            root.CFrame = savedPositions[#savedPositions]
            Notify("Teleport", "Teleported to saved position!", 2)
        else
            Notify("Error", "No saved positions!", 2)
        end
    end,
})

TPGroup3:AddButton({
    Text = '🗑 Clear Saved Positions',
    Func = function()
        savedPositions = {}
        Notify("Cleared", "All positions cleared!", 2)
    end,
})

local TPGroup4 = Tabs.Teleport:AddRightGroupbox('Quick Teleports')

TPGroup4:AddButton({
    Text = '📍 TP All Players to You',
    Func = function()
        Notify("Info", "Client-side only - other players won't move", 3)
    end,
})

TPGroup4:AddButton({
    Text = '📍 TP to Closest Player',
    Func = function()
        local root = GetRootPart(LocalPlayer)
        if not root then return end
        
        local closest = nil
        local closestDist = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local pRoot = GetRootPart(player)
                if pRoot then
                    local dist = (root.Position - pRoot.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
        
        if closest then
            local pRoot = GetRootPart(closest)
            if pRoot then
                root.CFrame = pRoot.CFrame + Vector3.new(3, 0, 0)
                Notify("Teleport", "Teleported to " .. closest.Name .. " (" .. math.floor(closestDist) .. " studs)", 2)
            end
        end
    end,
})

--// ==================== MISC TAB ====================
local MiscGroup = Tabs.Misc:AddLeftGroupbox('Anti Features')

MiscGroup:AddToggle('AntiAFK', {
    Text = 'Anti AFK',
    Default = true,
})

Toggles.AntiAFK:OnChanged(function()
    AntiAFK = Toggles.AntiAFK.Value
end)

-- Anti AFK
local antiAFKConnection
antiAFKConnection = LocalPlayer.Idled:Connect(function()
    if AntiAFK then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)

MiscGroup:AddToggle('AntiVoid', {
    Text = 'Anti Void (No Fall Death)',
    Default = false,
})

local AntiVoidEnabled = false

Toggles.AntiVoid:OnChanged(function()
    AntiVoidEnabled = Toggles.AntiVoid.Value
    if AntiVoidEnabled then
        spawn(function()
            while AntiVoidEnabled do
                local root = GetRootPart(LocalPlayer)
                if root and root.Position.Y < -50 then
                    root.CFrame = CFrame.new(root.Position.X, 100, root.Position.Z)
                    Notify("Anti Void", "Saved from void!", 1)
                end
                wait(0.1)
            end
        end)
    end
end)

local MiscGroup2 = Tabs.Misc:AddLeftGroupbox('Server Info')

MiscGroup2:AddButton({
    Text = '📊 Show Server Info',
    Func = function()
        local playerCount = #Players:GetPlayers()
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        
        Notify("Server Info", 
            "Players: " .. playerCount .. "/12\n" ..
            "Ping: " .. ping .. "ms\n" ..
            "FPS: " .. fps, 5)
    end,
})

MiscGroup2:AddButton({
    Text = '📋 Copy Server ID',
    Func = function()
        if setclipboard then
            setclipboard(game.JobId)
            Notify("Copied", "Server ID copied to clipboard!", 2)
        end
    end,
})

MiscGroup2:AddButton({
    Text = '🔄 Rejoin Server',
    Func = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
    DoubleClick = true,
})

MiscGroup2:AddButton({
    Text = '🌐 Server Hop',
    Func = function()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        local data = game:GetService("HttpService"):JSONDecode(req)
        
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        end
        
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
            Notify("Server Hop", "Joining new server...", 3)
        else
            Notify("Server Hop", "No available servers found!", 2)
        end
    end,
    DoubleClick = true,
})

local MiscGroup3 = Tabs.Misc:AddRightGroupbox('Mobile Support')

MiscGroup3:AddButton({
    Text = '📱 Enable Mobile Fly Button',
    Func = function()
        -- Create mobile fly button
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MobileFlyBtn"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 80)
        btn.Position = UDim2.new(0.85, 0, 0.5, 0)
        btn.Text = "FLY"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.new(0.2, 0.5, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn
        
        -- Make draggable
        local dragging = false
        local dragStart, startPos
        
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = btn.Position
            end
        end)
        
        btn.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            Toggles.Fly:SetValue(not Toggles.Fly.Value)
            btn.BackgroundColor3 = Toggles.Fly.Value and Color3.new(0, 1, 0) or Color3.new(0.2, 0.5, 1)
            btn.Text = Toggles.Fly.Value and "LAND" or "FLY"
        end)
        
        Notify("Mobile", "Fly button created! Drag to move.", 3)
    end,
})

MiscGroup3:AddButton({
    Text = '📱 Mobile Jump Button (Up)',
    Func = function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MobileJumpUp"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 60)
        btn.Position = UDim2.new(0.85, 0, 0.35, 0)
        btn.Text = "⬆"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.new(0.5, 0.2, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 24
        btn.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn
        
        btn.MouseButton1Down:Connect(function()
            if FlyEnabled then
                -- Go up while flying
                local root = GetRootPart(LocalPlayer)
                if root and flyBody then
                    spawn(function()
                        while btn.Active do
                            flyBody.Velocity = flyBody.Velocity + Vector3.new(0, Options.FlySpeed.Value, 0)
                            wait(0.1)
                        end
                    end)
                end
            else
                local humanoid = GetHumanoid(LocalPlayer)
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        
        Notify("Mobile", "Up button created!", 2)
    end,
})

MiscGroup3:AddButton({
    Text = '📱 Create Mobile Controls',
    Func = function()
        -- Create comprehensive mobile controls
        local gui = Instance.new("ScreenGui")
        gui.Name = "MobileControls"
        gui.ResetOnSpawn = false
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local buttonData = {
            {text = "NOCLIP", pos = UDim2.new(0, 10, 0.3, 0), func = function(b) 
                Toggles.Noclip:SetValue(not Toggles.Noclip.Value)
                b.BackgroundColor3 = Toggles.Noclip.Value and Color3.new(0,1,0) or Color3.new(1,0.3,0.3)
            end},
            {text = "SPEED", pos = UDim2.new(0, 10, 0.38, 0), func = function(b)
                Toggles.SpeedHack:SetValue(not Toggles.SpeedHack.Value)
                b.BackgroundColor3 = Toggles.SpeedHack.Value and Color3.new(0,1,0) or Color3.new(1,0.3,0.3)
            end},
            {text = "ESP", pos = UDim2.new(0, 10, 0.46, 0), func = function(b)
                Toggles.PlayerChams:SetValue(not Toggles.PlayerChams.Value)
                b.BackgroundColor3 = Toggles.PlayerChams.Value and Color3.new(0,1,0) or Color3.new(1,0.3,0.3)
            end},
            {text = "COINS", pos = UDim2.new(0, 10, 0.54, 0), func = function(b)
                Toggles.AutoFarmCoins:SetValue(not Toggles.AutoFarmCoins.Value)
                b.BackgroundColor3 = Toggles.AutoFarmCoins.Value and Color3.new(0,1,0) or Color3.new(1,0.3,0.3)
            end},
            {text = "INF J", pos = UDim2.new(0, 10, 0.62, 0), func = function(b)
                Toggles.InfiniteJump:SetValue(not Toggles.InfiniteJump.Value)
                b.BackgroundColor3 = Toggles.InfiniteJump.Value and Color3.new(0,1,0) or Color3.new(1,0.3,0.3)
            end},
        }
        
        for _, data in pairs(buttonData) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 35)
            btn.Position = data.pos
            btn.Text = data.text
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.new(1, 0.3, 0.3)
            btn.BackgroundTransparency = 0.3
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.Parent = gui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                data.func(btn)
            end)
        end
        
        Notify("Mobile", "Mobile controls created!", 3)
    end,
})

local MiscGroup4 = Tabs.Misc:AddRightGroupbox('Extra Features')

MiscGroup4:AddButton({
    Text = '🎵 Play Sound',
    Func = function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://5765551990"
        sound.Volume = 1
        sound.Parent = Workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 5)
    end,
})

MiscGroup4:AddButton({
    Text = '📸 Screenshot Info',
    Func = function()
        local murderer = GetMurderer()
        local sheriff = GetSheriff()
        local info = "MM2 Hub Active\n"
        info = info .. "Murderer: " .. (murderer and murderer.Name or "N/A") .. "\n"
        info = info .. "Sheriff: " .. (sheriff and sheriff.Name or "N/A") .. "\n"
        info = info .. "Players: " .. #Players:GetPlayers()
        Notify("📸 Info", info, 10)
    end,
})

MiscGroup4:AddToggle('AutoRespawn', {
    Text = 'Auto Respawn',
    Default = false,
})

local AutoRespawnEnabled = false

Toggles.AutoRespawn:OnChanged(function()
    AutoRespawnEnabled = Toggles.AutoRespawn.Value
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if AutoRespawnEnabled then
        local humanoid = char:WaitForChild("Humanoid")
        humanoid.Died:Connect(function()
            wait(1)
            -- Try to force respawn
            pcall(function()
                LocalPlayer:LoadCharacter()
            end)
        end)
    end
end)

MiscGroup4:AddButton({
    Text = '🧹 Clean ESP/Highlights',
    Func = function()
        -- Clean all ESP
        for name, data in pairs(ESPObjects) do
            for _, obj in pairs(data) do
                if obj and obj.Remove then obj:Remove() end
            end
        end
        ESPObjects = {}
        activeESP = {}
        
        -- Clean highlights
        ClearWorldHighlights()
        
        for _, player in pairs(Players:GetPlayers()) do
            local char = GetCharacter(player)
            if char then
                for _, h in pairs(char:GetChildren()) do
                    if h:IsA("Highlight") then h:Destroy() end
                end
            end
        end
        
        Notify("Clean", "All ESP cleaned!", 2)
    end,
})

MiscGroup4:AddButton({
    Text = '❌ Destroy Script',
    Func = function()
        -- Clean everything
        for name, data in pairs(ESPObjects) do
            for _, obj in pairs(data) do
                if obj and obj.Remove then obj:Remove() end
            end
        end
        
        if fovCircle then fovCircle:Remove() end
        ClearWorldHighlights()
        
        Library:Unload()
        Notify("Script", "Script destroyed!", 2)
    end,
    DoubleClick = true,
})

--// ==================== UI SETTINGS TAB ====================
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload Script',
    Func = function()
        Library:Unload()
    end,
    DoubleClick = true,
})

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu Toggle'
})

Library.ToggleKeybind = Options.MenuKeybind

local ThemeGroup = Tabs['UI Settings']:AddLeftGroupbox('Themes')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:SetFolder('MM2UltimateHub')
SaveManager:SetFolder('MM2UltimateHub/configs')
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:BuildConfigSection(Tabs['UI Settings'])

--// ==================== KEYBINDS ====================
local KeybindGroup = Tabs['UI Settings']:AddRightGroupbox('Keybinds Info')

KeybindGroup:AddLabel('End - Toggle Menu')
KeybindGroup:AddLabel('All features work on Mobile!')
KeybindGroup:AddLabel('Use Mobile Controls button')
KeybindGroup:AddLabel('in Misc tab for touch buttons')

--// ==================== AUTO REFRESH PLAYER LISTS ====================
Players.PlayerAdded:Connect(function(player)
    wait(1)
    pcall(function()
        Options.FlingPlayer:SetValues(GetPlayerList())
        Options.AnnoyPlayer:SetValues(GetPlayerList())
        Options.TPPlayer:SetValues(GetPlayerList())
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    wait(0.5)
    pcall(function()
        Options.FlingPlayer:SetValues(GetPlayerList())
        Options.AnnoyPlayer:SetValues(GetPlayerList())
        Options.TPPlayer:SetValues(GetPlayerList())
    end)
    
    -- Clean ESP
    if ESPObjects[player.Name] then
        for _, obj in pairs(ESPObjects[player.Name]) do
            if obj and obj.Remove then obj:Remove() end
        end
        ESPObjects[player.Name] = nil
        activeESP[player.Name] = nil
    end
end)

--// ==================== CHARACTER RESPAWN HANDLER ====================
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    
    -- Reapply speed
    if SpeedEnabled then
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.WalkSpeed = Options.SpeedValue.Value
        end
    end
    
    -- Reapply jump
    if JumpEnabled then
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.JumpPower = Options.JumpValue.Value
            humanoid.UseJumpPower = true
        end
    end
    
    -- Stop fly on respawn
    if FlyEnabled then
        Toggles.Fly:SetValue(false)
    end
    
    -- Stop fling on respawn
    FlingActive = false
end)

--// Final notification
Notify("MM2 Ultimate Hub", "Script loaded successfully! 🎮\nPress End to toggle menu", 5)
print("MM2 Ultimate Hub loaded successfully!")
print("Features: ESP, Aimbot, Fling, Fly, Speed, Noclip, Coins, Anti-Knife, and more!")
