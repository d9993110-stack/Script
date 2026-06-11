-- Find or Die! Helper
-- Сканирует мир и GUI на отличия

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local SCAN_INTERVAL = 0.3
local CIRCLE_SIZE = 30
local enabled = false

-- ========== GUI КНОПКА (МАЛЕНЬКАЯ) ==========
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "DiffToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.DisplayOrder = 10000
toggleGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 70, 0, 70)
frame.Position = UDim2.new(0, 10, 0, 200)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true
frame.Parent = toggleGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 35)
toggleBtn.Position = UDim2.new(0, 0, 0, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 60, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 38)
statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
statusLabel.BackgroundTransparency = 0.4
statusLabel.Text = "0"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = frame

local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 5)
sCorner.Parent = statusLabel

-- ========== GUI ДЛЯ КРУЖКОВ ==========
local markerGui = Instance.new("ScreenGui")
markerGui.Name = "DiffMarkers"
markerGui.ResetOnSpawn = false
markerGui.IgnoreGuiInset = true
markerGui.DisplayOrder = 9999
markerGui.Parent = playerGui

local activeCircles = {}

local function clearMarkers()
    for _, c in ipairs(activeCircles) do
        if c then c:Destroy() end
    end
    activeCircles = {}
end

local function createCircle(screenPos)
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, CIRCLE_SIZE, 0, CIRCLE_SIZE)
    circle.Position = UDim2.new(0, screenPos.X - CIRCLE_SIZE/2, 0, screenPos.Y - CIRCLE_SIZE/2)
    circle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
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
    table.insert(activeCircles, circle)
    return circle
end

-- ========== ПОИСК ОТЛИЧИЙ ==========

-- 1. Поиск в Workspace (Parts с ClickDetector или специальными именами)
local function findInWorkspace()
    local found = {}
    local keywords = {"diff", "spot", "difference", "answer", "correct", "target", "click", "hit"}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local isDiff = false
        
        -- По ClickDetector
        if obj:IsA("ClickDetector") then
            local parent = obj.Parent
            if parent and parent:IsA("BasePart") then
                isDiff = true
            end
        end
        
        -- По имени
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    isDiff = true
                    break
                end
            end
        end
        
        if isDiff and obj:IsA("BasePart") then
            local screenPos, onScreen = Camera:WorldToScreenPoint(obj.Position)
            if onScreen then
                table.insert(found, Vector2.new(screenPos.X, screenPos.Y))
            end
        elseif isDiff and obj:IsA("ClickDetector") and obj.Parent:IsA("BasePart") then
            local screenPos, onScreen = Camera:WorldToScreenPoint(obj.Parent.Position)
            if onScreen then
                table.insert(found, Vector2.new(screenPos.X, screenPos.Y))
            end
        end
    end
    
    return found
end

-- 2. Поиск в SurfaceGui / BillboardGui
local function findInSurfaceGui()
    local found = {}
    local keywords = {"diff", "spot", "difference", "answer", "correct", "target"}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("GuiButton") or child:IsA("ImageButton") or child:IsA("TextButton") then
                    local name = child.Name:lower()
                    local match = false
                    for _, kw in ipairs(keywords) do
                        if name:find(kw) then match = true break end
                    end
                    
                    if match and obj.Adornee then
                        local part = obj.Adornee
                        if part:IsA("BasePart") then
                            local screenPos, onScreen = Camera:WorldToScreenPoint(part.Position)
                            if onScreen then
                                table.insert(found, Vector2.new(screenPos.X, screenPos.Y))
                            end
                        end
                    end
                end
            end
        end
    end
    
    return found
end

-- 3. Поиск в PlayerGui (если отличия как ImageButton'ы)
local function findInPlayerGui()
    local found = {}
    local keywords = {"diff", "spot", "difference", "answer", "correct", "target", "click"}
    
    for _, obj in ipairs(playerGui:GetDescendants()) do
        if obj:IsA("GuiButton") and obj.Visible and obj.AbsoluteSize.X > 0 then
            local name = obj.Name:lower()
            for _, kw in ipairs(keywords) do
                if name:find(kw) then
                    local absPos = obj.AbsolutePosition
                    local absSize = obj.AbsoluteSize
                    local center = Vector2.new(absPos.X + absSize.X/2, absPos.Y + absSize.Y/2)
                    table.insert(found, center)
                    break
                end
            end
        end
    end
    
    return found
end

-- Удаление дубликатов
local function dedup(positions)
    local unique = {}
    for _, pos in ipairs(positions) do
        local isDup = false
        for _, u in ipairs(unique) do
            if (pos - u).Magnitude < 25 then
                isDup = true
                break
            end
        end
        if not isDup then
            table.insert(unique, pos)
        end
    end
    return unique
end

local function scan()
    clearMarkers()
    
    local all = {}
    
    -- Собираем со всех источников
    for _, p in ipairs(findInWorkspace()) do table.insert(all, p) end
    for _, p in ipairs(findInSurfaceGui()) do table.insert(all, p) end
    for _, p in ipairs(findInPlayerGui()) do table.insert(all, p) end
    
    local unique = dedup(all)
    
    for _, pos in ipairs(unique) do
        createCircle(pos)
    end
    
    statusLabel.Text = tostring(#unique)
end

-- ========== КНОПКА ==========
toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        clearMarkers()
        statusLabel.Text = "0"
    end
end)

-- ========== ГЛАВНЫЙ ЦИКЛ (обновление каждый кадр для движения камеры) ==========
RunService.RenderStepped:Connect(function()
    if enabled then
        pcall(scan)
    end
end)

print("[Find or Die Helper] Загружено! Нажми кнопку слева.")
