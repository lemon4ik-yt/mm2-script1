-- LEMONHUB | GUN SYSTEM ONLY (V9.1)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Создание компактного GUI
local GunGui = Instance.new("ScreenGui")
GunGui.Name = "LemonGunHub"
GunGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
GunGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Position = UDim2.new(0.8, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Можно двигать по экрану
MainFrame.Parent = GunGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "LEMONHUB | Пест-Контроль"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Функция поиска упавшего пистолета на карте
local function getDroppedGun()
    -- Ищем объект GunDrop в Workspace или в папке Setup (зависит от режима карты MM2)
    local gun = Workspace:FindFirstChild("GunDrop")
    if not gun and Workspace:FindFirstChild("Setup") then
        gun = Workspace.Setup:FindFirstChild("GunDrop")
    end
    -- Проверяем, что это именно брошенный парт, а не инструмент в руках
    if gun and (gun:IsA("BasePart") or gun:FindFirstChild("ClassName") == "MeshPart" or gun:FindFirstChild("Handle")) then
        return gun
    end
    return nil
end

-- 1. ЛОГИКА ТЕЛЕПОРТА (ПОДБОР И ВОЗВРАТ)
local function grabGunAndReturn()
    local gun = getDroppedGun()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if gun and hrp then
        local originalPosition = hrp.CFrame -- Запоминаем где стояли
        
        -- Выключаем коллизию на время прыжка, чтобы не застрять в текстурах
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        
        -- Перемещаемся ровно на пистолет
        hrp.CFrame = gun.CFrame
        
        -- Короткая задержка в микросекундах для детекта подбора игрой
        task.wait(0.12) 
        
        -- Возвращаемся обратно
        hrp.CFrame = originalPosition
    end
end

-- 2. ПОДСВЕТКА (ESP)
task.spawn(function()
    while true do
        task.wait(0.5) -- Оптимальная частота проверки
        local gun = getDroppedGun()
        
        if gun then
            local highlight = gun:FindFirstChild("GunHighlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "GunHighlight"
                highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Яркий бирюзовый неон
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.2
                highlight.OutlineTransparency = 0
                highlight.Parent = gun
            end
        end
    end
end)

-- КНОПКИ ДЛЯ GUI
local GrabBtn = Instance.new("TextButton")
GrabBtn.Size = UDim2.new(0, 190, 0, 35)
GrabBtn.Position = UDim2.new(0, 15, 0, 40)
GrabBtn.BackgroundColor3 = Color3.fromRGB(80, 110, 240)
GrabBtn.Text = "Подобрать и Вернуться"
GrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GrabBtn.Font = Enum.Font.SourceSansBold
GrabBtn.TextSize = 14
GrabBtn.Parent = MainFrame
Instance.new("UICorner", GrabBtn).CornerRadius = UDim.new(0, 6)

local AutoToggle = Instance.new("TextButton")
AutoToggle.Size = UDim2.new(0, 190, 0, 35)
AutoToggle.Position = UDim2.new(0, 15, 0, 85)
AutoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
AutoToggle.Text = "Авто-подбор: ВЫКЛ"
AutoToggle.TextColor3 = Color3.fromRGB(240, 240, 240)
AutoToggle.Font = Enum.Font.SourceSansBold
AutoToggle.TextSize = 14
AutoToggle.Parent = MainFrame
Instance.new("UICorner", AutoToggle).CornerRadius = UDim.new(0, 6)

-- Бинды кнопок
GrabBtn.MouseButton1Click:Connect(grabGunAndReturn)

local autoGrabEnabled = false
AutoToggle.MouseButton1Click:Connect(function()
    autoGrabEnabled = not autoGrabEnabled
    if autoGrabEnabled then
        AutoToggle.BackgroundColor3 = Color3.fromRGB(40, 180, 100)
        AutoToggle.Text = "Авто-подбор: ВКЛ"
    else
        AutoToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        AutoToggle.Text = "Авто-подбор: ВЫКЛ"
    end
end)

-- Цикл авто-подбора
task.spawn(function()
    while true do
        task.wait(0.2)
        if autoGrabEnabled then
            local gun = getDroppedGun()
            if gun then
                grabGunAndReturn()
            end
        end
    end
end)
