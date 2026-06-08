-- Nakonchay Script
-- Автор: Fovenko
-- Для Delta Executor (Mobile/PC)

-- Загрузка Obsidian UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local Window = Library.new("Nakonchay", 5013109572)

-- Переменные
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Настройки
local settings = {
    flySpeed = 50,
    walkSpeed = 16,
    jumpPower = 50,
    flying = false,
    espEnabled = false,
    espBox = false,
    espSkeleton = false,
    espName = false
}

-- Fly функция
local flyConnection
local function toggleFly(state)
    settings.flying = state
    
    if state then
        local BV = Instance.new("BodyVelocity")
        local BG = Instance.new("BodyGyro")
        
        BV.Name = "FlyVelocity"
        BV.Parent = hrp
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        
        BG.Name = "FlyGyro"
        BG.Parent = hrp
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = hrp.CFrame
        
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not settings.flying then return end
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Управление для ПК и мобильных
            if game:GetService("UserInputService").TouchEnabled then
                -- Мобильное управление
                local moveVector = humanoid.MoveVector
                if moveVector.Magnitude > 0 then
                    moveDirection = (camera.CFrame.LookVector * moveVector.Z + camera.CFrame.RightVector * moveVector.X)
                end
            else
                -- ПК управление
                local keys = game:GetService("UserInputService")
                if keys:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
                if keys:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
                if keys:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
                if keys:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
                if keys:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                if keys:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
            end
            
            BV.Velocity = moveDirection * settings.flySpeed
            BG.CFrame = camera.CFrame
        end)
    else
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
    end
end

-- ESP функции
local espObjects = {}

local function createESP(plr)
    if plr == player then return end
    
    local char = plr.Character
    if not char then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. plr.Name
    espFolder.Parent = char
    
    espObjects[plr.Name] = espFolder
    
    -- Box ESP
    if settings.espBox then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "BoxESP"
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(4, 0, 5, 0)
        BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
        BillboardGui.Parent = espFolder
        BillboardGui.Adornee = char:WaitForChild("HumanoidRootPart")
        
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 1, 0)
        Frame.BackgroundTransparency = 0.7
        Frame.BorderSizePixel = 2
        Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Frame.Parent = BillboardGui
    end
    
    -- Name ESP
    if settings.espName then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "NameESP"
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
        BillboardGui.Parent = espFolder
        BillboardGui.Adornee = char:WaitForChild("HumanoidRootPart")
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = plr.Name
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextStrokeTransparency = 0.5
        TextLabel.Font = Enum.Font.SourceSansBold
        TextLabel.TextSize = 16
        TextLabel.Parent = BillboardGui
    end
    
    -- Skeleton ESP
    if settings.espSkeleton then
        local function drawLine(part1, part2)
            local attach1 = Instance.new("Attachment", part1)
            local attach2 = Instance.new("Attachment", part2)
            local beam = Instance.new("Beam")
            beam.Attachment0 = attach1
            beam.Attachment1 = attach2
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
            beam.Width0 = 0.1
            beam.Width1 = 0.1
            beam.Parent = espFolder
        end
        
        pcall(function()
            drawLine(char.Head, char.UpperTorso)
            drawLine(char.UpperTorso, char.LowerTorso)
            drawLine(char.UpperTorso, char.LeftUpperArm)
            drawLine(char.LeftUpperArm, char.LeftLowerArm)
            drawLine(char.LeftLowerArm, char.LeftHand)
            drawLine(char.UpperTorso, char.RightUpperArm)
            drawLine(char.RightUpperArm, char.RightLowerArm)
            drawLine(char.RightLowerArm, char.RightHand)
            drawLine(char.LowerTorso, char.LeftUpperLeg)
            drawLine(char.LeftUpperLeg, char.LeftLowerLeg)
            drawLine(char.LeftLowerLeg, char.LeftFoot)
            drawLine(char.LowerTorso, char.RightUpperLeg)
            drawLine(char.RightUpperLeg, char.RightLowerLeg)
            drawLine(char.RightLowerLeg, char.RightFoot)
        end)
    end
end

local function updateESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Character and espObjects[plr.Name] then
            espObjects[plr.Name]:Destroy()
        end
        if settings.espEnabled then
            createESP(plr)
        end
    end
end

-- UI
local MainTab = Window:addPage("Main", 5012544693)
local MainSection = MainTab:addSection("Движение")

-- Fly
MainSection:addToggle("Fly", settings.flying, function(state)
    toggleFly(state)
end)

MainSection:addSlider("Скорость Fly", 16, settings.flySpeed, 300, function(value)
    settings.flySpeed = value
end)

-- WalkSpeed
MainSection:addSlider("Скорость ходьбы", 16, settings.walkSpeed, 200, function(value)
    settings.walkSpeed = value
    humanoid.WalkSpeed = value
end)

-- JumpPower
MainSection:addSlider("Сила прыжка", 50, settings.jumpPower, 300, function(value)
    settings.jumpPower = value
    humanoid.JumpPower = value
end)

-- ESP Tab
local ESPTab = Window:addPage("ESP", 5012544693)
local ESPSection = ESPTab:addSection("Визуалы")

ESPSection:addToggle("Включить ESP", settings.espEnabled, function(state)
    settings.espEnabled = state
    updateESP()
end)

ESPSection:addToggle("Box ESP", settings.espBox, function(state)
    settings.espBox = state
    updateESP()
end)

ESPSection:addToggle("Skeleton ESP", settings.espSkeleton, function(state)
    settings.espSkeleton = state
    updateESP()
end)

ESPSection:addToggle("Name ESP", settings.espName, function(state)
    settings.espName = state
    updateESP()
end)

-- Обновление при заходе новых игроков
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        if settings.espEnabled then
            createESP(plr)
        end
    end)
end)

-- Обновление при респавне
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
    
    humanoid.WalkSpeed = settings.walkSpeed
    humanoid.JumpPower = settings.jumpPower
    
    if settings.flying then
        wait(1)
        toggleFly(true)
    end
end)

Library:SelectPage(Window.pages[1], true)

print("Nakonchay Script загружен!")
print("Автор: Fovenko")
