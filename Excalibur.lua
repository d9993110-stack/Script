-- // Right Ctrl Mobile Button (B) by Grok
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RightCtrlButton"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Button = Instance.new("TextButton")
Button.Name = "B_Button"
Button.Size = UDim2.new(0, 55, 0, 55)
Button.Position = UDim2.new(0.88, 0, 0.6, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Button.Text = "B"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.TextScaled = true
Button.Font = Enum.Font.GothamBold
Button.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = Button

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Color = Color3.new(1, 1, 1)
Stroke.Parent = Button

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Position = UDim2.new(0, 0, 1, 5)
Title.BackgroundTransparency = 1
Title.Text = "Right Ctrl"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.Gotham
Title.Parent = Button

-- Draggable
local dragging, dragInput, dragStart, startPos

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Емуляція Right Ctrl
Button.MouseButton1Down:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
end)

Button.MouseButton1Up:Connect(function()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
end)

print("✅ Кнопка B (Right Ctrl) успішно завантажена!")
