-- Find Differences Helper с кнопкой ON/OFF
-- Запускать через executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Настройки
local SCAN_INTERVAL = 0.5
local CIRCLE_SIZE = 35
local CIRCLE_COLOR = Color3.fromRGB(0, 255, 0)
local enabled = false

-- ============ GUI КНОПКИ ============
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "DiffToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.DisplayOrder = 10000
toggleGui.Parent = playerGui

-- Главная кнопка
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 140, 0, 50)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.ZIndex = 100
toggleBtn.Parent = toggleGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 12)
btnCorner.Parent = toggleBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(255, 255, 255)
btnStroke.Thickness = 2
btnStroke.Parent = toggleBtn

-- Статус-текст
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 140, 0, 20)
statusLabel.Position = UDim2.new(0, 20, 0.5, 25)
statusLabel.BackgroundTransparency = 0.3
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.Text = "Diffs: 0"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.ZIndex = 100
statusLabel.Parent = toggleGui

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel

-- ============ GUI МАРКЕРОВ ============
local markerGui = Instance.new("ScreenGui")
markerGui.Name = "DiffMarkers"
markerGui.ResetOnSpawn = false
markerGui.IgnoreGuiInset = true
markerGui.DisplayOrder = 9999
markerGui.Parent = playerGui

local function clearMarkers()
    for _, c in ipairs(markerGui:GetChildren()) do
        c:Destroy()
    end
end

local function createCircle(position)
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, CIRCLE_SIZE, 0, CIRCLE_SIZE)
    circle.Position = UDim2.new(0, position.X - CIRCLE_SIZE/2, 0, position.Y - CIRCLE_SIZE/2)
    circle.BackgroundColor3 = CIRCLE_COLOR
    circle.BackgroundTransparency = 0.5
    circle.BorderSizePixel = 0
    circle.ZIndex = 100
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 0)
    stroke.Thickness = 4
    stroke.Parent = circle
    
    circle.Parent = markerGui
end

-- ============ ПОИСК ОТЛИЧИЙ ============
local function findDifferencesByName()
    local diffs = {}
    local keywords = {"diff", "spot", "difference", "answer", "correct", "target", "click"}
    
    for _, obj in ipairs(playerGui:GetDescendants()) do
        if obj:IsA("GuiObject") and obj.Visible and obj.AbsoluteSize.X > 0 then
            local name = obj.Name:lower()
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    local absPos = obj.AbsolutePosition
                    local absSize = obj.AbsoluteSize
                    local center = Vector2.new(absPos.X + absSize.X/2, absPos.Y + absSize.Y/2)
                    table.insert(diffs, center)
                    break
                end
            end
        end
    end
    return diffs
end

local function findClickableButtons()
    local diffs = {}
    -- Ищем большие картинки (панели игры)
    local panels = {}
    for _, gui in ipairs(playerGui:GetDescendants()) do
        if gui:IsA("ImageLabel") and gui.Visible 
           and gui.AbsoluteSize.X > 200 and gui.AbsoluteSize.Y > 200 then
            table.insert(panels, gui)
        end
    end
    
    -- Внутри панелей ищем кнопки
    for _, panel in ipairs(panels) do
        for _, obj in ipairs(panel:GetDescendants()) do
            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible then
                local absPos = obj.AbsolutePosition
                local absSize = obj.AbsoluteSize
                if absSize.X > 5 and absSize.X < 200 then
                    local center = Vector2.new(absPos.X + absSize.X/2, absPos.Y + absSize.Y/2)
                    table.insert(diffs, center)
                end
            end
        end
    end
    return diffs
end

local function scan()
    clearMarkers()
    
    local diffs = findDifferencesByName()
    if #diffs == 0 then
        diffs = findClickableButtons()
    end
    
    -- Убираем дубликаты (близкие точки)
    local unique = {}
    for _, pos in ipairs(diffs) do
        local isDup = false
        for _, u in ipairs(unique) do
            if (pos - u).Magnitude < 20 then
                isDup = true
                break
            end
        end
        if not isDup then
            table.insert(unique, pos)
            createCircle(pos)
        end
    end
    
    statusLabel.Text = "Diffs: " .. #unique
end

-- ============ КНОПКА ON/OFF ============
toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        clearMarkers()
        statusLabel.Text = "Diffs: 0"
    end
end)

-- ============ ГЛАВНЫЙ ЦИКЛ ============
spawn(function()
    while task.wait(SCAN_INTERVAL) do
        if enabled then
            pcall(scan)
        end
    end
end)

print("[Diff Finder] Скрипт загружен! Нажми кнопку OFF чтобы включить.")
