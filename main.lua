-- ОБЪЕДИНЕННЫЙ СКРИПТ MM2 С КНОПКОЙ СВЕРНУТЬ/РАЗВЕРНУТЬ
local Clipboard = setclipboard or toclipboard or function() end
local TweenService = game:GetService("TweenService")

-- ФУНКЦИЯ ОСНОВНОГО МЕНЮ (Сработает после ввода ключа)
function startMainMenu()
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
    
    -- Создаем окно по центру экрана (Orion по умолчанию центрирует интерфейс)
    local Window = OrionLib:MakeWindow({
        Name = "MM2 Кастомный Скрипт", 
        HidePremium = false, 
        SaveConfig = true, 
        ConfigFolder = "MM2Config"
    })

    -- Ищем сам фрейм Ориона в CoreGui, чтобы потом его прятать
    local OrionGui = game:GetService("CoreGui"):FindFirstChild("Orion")
    local MainOrionFrame = OrionGui and OrionGui:FindFirstChild("Main")

    -- СОЗДАНИЕ КНОПКИ СВЕРНУТЬ/РАЗВЕРНУТЬ
    local ToggleGui = Instance.new("ScreenGui")
    local ToggleBtn = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")

    ToggleGui.Name = "MM2ToggleGui"
    ToggleGui.Parent = game:GetService("CoreGui")
    ToggleGui.DisplayOrder = 999 -- Чтобы кнопка всегда была поверх всего

    -- Настройки закругленной кнопки сверху по центру
    ToggleBtn.Size = UDim2.new(0, 140, 0, 30)
    ToggleBtn.Position = UDim2.new(0.5, -70, 0, -35) -- Начальная позиция чуть выше экрана для анимации появления
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "Прикрыть меню"
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = ToggleGui

    -- Делаем кнопку круглой
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = ToggleBtn

    -- Анимация появления кнопки сверху вниз
    TweenService:Create(ToggleBtn, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -70, 0, 10) -- Опускается на 10 пикселей сверху экрана
    }):Play()

    -- Логика кнопки Свернуть / Развернуть
    local menuVisible = true
    ToggleBtn.MouseButton1Click:Connect(function()
        if MainOrionFrame then
            menuVisible = not menuVisible
            MainOrionFrame.Visible = menuVisible
            
            -- Меняем текст и дизайн в зависимости от состояния
            if menuVisible then
                ToggleBtn.Text = "Прикрыть меню"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            else
                ToggleBtn.Text = "Открыть меню"
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Становится зеленой, когда меню скрыто
            end
        end
    end)

    -- ДАЛЕЕ ИДЕТ ТВОЙ СТАНДАРТНЫЙ ФУНКЦИОНАЛ MM2
    local MainTab = Window:MakeTab({Name = "Главная", Icon = "rbxassetid://4483345998", PremiumOnly = false})
    local PlayerTab = Window:MakeTab({Name = "Игрок", Icon = "rbxassetid://4483345998", PremiumOnly = false})

    local Plr = game.Players.LocalPlayer
    
    PlayerTab:AddSlider({
        Name = "Скорость", Min = 16, Max = 150, Default = 16, Color = Color3.fromRGB(255,255,255), Increment = 1,
        Callback = function(Value) pcall(function() Plr.Character.Humanoid.WalkSpeed = Value end) end    
    })

    PlayerTab:AddSlider({
        Name = "Прыжок", Min = 50, Max = 300, Default = 50, Color = Color3.fromRGB(255,255,255), Increment = 1,
        Callback = function(Value) pcall(function() Plr.Character.Humanoid.JumpPower = Value end) end    
    })

    local NoclipLoop
    PlayerTab:AddToggle({
        Name = "Noclip (Свозь стены)", Default = false,
        Callback = function(Value)
            if Value then
                NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
                    pcall(function()
                        for _, v in pairs(Plr.Character:GetDescendants()) do
                            if v:IsA("BasePart") then v.CanCollide = false end
                        end
                    end)
                end)
            else
                if NoclipLoop then NoclipLoop:Disconnect() end
            end
        end
    })

    MainTab:AddToggle({
        Name = "ESP (Роли)", Default = false,
        Callback = function(Value)
            _G.ESP = Value
            while _G.ESP do
                task.wait(1)
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= Plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local isMurder = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                        local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                        
                        local color = Color3.fromRGB(0, 255, 0)
                        if isMurder then color = Color3.fromRGB(255, 0, 0) end
                        if isSheriff then color = Color3.fromRGB(0, 0, 255) end
                        
                        if not p.Character:FindFirstChild("ESP_Highlight") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ESP_Highlight"
                            hl.FillColor = color
                            hl.FillTransparency = 0.5
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.Parent = p.Character
                        else
                            p.Character.ESP_Highlight.FillColor = color
                        end
                    end
                end
                if not _G.ESP then
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p.Character and p.Character:FindFirstChild("ESP_Highlight") then
                            p.Character.ESP_Highlight:Destroy()
                        end
                    end
                end
            end
        end
    })

    local function grabGun()
        local gun = game.Workspace:FindFirstChild("GunDrop")
        if gun and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
            Plr.Character.HumanoidRootPart.CFrame = gun.CFrame
        end
    end

    MainTab:AddButton({
        Name = "Забрать пистолет (Один раз)",
        Callback = function() grabGun() end
    })

    MainTab:AddToggle({
        Name = "Авто-подбор пистолета", Default = false,
        Callback = function(Value)
            _G.AutoGrabGun = Value
            while _G.AutoGrabGun do
                task.wait(0.5)
                grabGun()
            end
        end
    })

    MainTab:AddToggle({
        Name = "Автофарм монет и ивентов", Default = false,
        Callback = function(Value)
            _G.CoinFarm = Value
            while _G.CoinFarm do
                task.wait(0.3)
                local map = game.Workspace:FindFirstChild("Normal") and game.Workspace.Normal:FindFirstChild("Map")
                if map then
                    for _, obj in pairs(map:GetDescendants()) do
                        if obj.Name == "CoinContainer" or obj.Name == "CandyContainer" or obj:FindFirstChild("TouchInterest") then
                            if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") and firetouchinterest then
                                firetouchinterest(Plr.Character.HumanoidRootPart, obj, 0)
                                task.wait(0.05)
                                firetouchinterest(Plr.Character.HumanoidRootPart, obj, 1)
                            end
                        end
                    end
                end
            end
        end
    })

    OrionLib:Init()
end

-- СОЗДАНИЕ ИНТЕРФЕЙСА АВТОРИЗАЦИИ (КЛЮЧА) — СТРОГО ПО ЦЕНТРУ
local KeyAuth = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local SubmitBtn = Instance.new("TextButton")
local SubmitCorner = Instance.new("UICorner")
local GetKeyBtn = Instance.new("TextButton")
local GetKeyCorner = Instance.new("UICorner")

KeyAuth.Name = "KeySystem"
KeyAuth.Parent = game:GetService("CoreGui")

-- Центрирование через AnchorPoint и Position 0.5
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Идеальный центр экрана
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Parent = KeyAuth

FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

-- Поле ввода
TextBox.Size = UDim2.new(0, 260, 0, 40)
TextBox.Position = UDim2.new(0.5, -130, 0.35, -20)
TextBox.PlaceholderText = "Введите ключ здесь..."
TextBox.Text = ""
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 16
TextBox.Parent = MainFrame

local TextCorner = Instance.new("UICorner")
TextCorner.CornerRadius = UDim.new(0, 6)
TextCorner.Parent = TextBox

-- Кнопка Submit
SubmitBtn.Size = UDim2.new(0, 120, 0, 40)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
SubmitBtn.Text = "Submit"
SubmitBtn.Font = Enum.Font.SourceSansBold
SubmitBtn.TextSize = 16
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Parent = MainFrame

SubmitCorner.CornerRadius = UDim.new(0, 8)
SubmitCorner.Parent = SubmitBtn

-- Кнопка Get Key
GetKeyBtn.Size = UDim2.new(0, 120, 0, 40)
GetKeyBtn.Position = UDim2.new(0.53, 0, 0.7, 0)
GetKeyBtn.Text = "Получить ключ"
GetKeyBtn.Font = Enum.Font.SourceSansBold
GetKeyBtn.TextSize = 16
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Parent = MainFrame

GetKeyCorner.CornerRadius = UDim.new(0, 8)
GetKeyCorner.Parent = GetKeyBtn

-- Логика
GetKeyBtn.MouseButton1Click:Connect(function()
    Clipboard("https://discord.com/channels/1524036881057189889/1524036994085425235/1524038305753202810")
    GetKeyBtn.Text = "Скопировано!"
    task.wait(2)
    GetKeyBtn.Text = "Получить ключ"
end)

SubmitBtn.MouseButton1Click:Connect(function()
    if TextBox.Text == "ilovepigs" then
        KeyAuth:Destroy()
        startMainMenu()
    else
        TextBox.Text = ""
        TextBox.PlaceholderText = "Неверный ключ!"
    end
end)
