-- LEMONHUB REBOOT (С ЗАЩИТОЙ ОТ СБОЕВ)
local function safeLoad()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Проверим, загрузился ли игрок полностью
    if not LocalPlayer then return end
    
    local StarterGui = game:GetService("StarterGui")
    local function notify(text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "LEMONHUB Debug",
                Text = text,
                Duration = 5
            })
        end)
    end

    notify("Скрипт активирован! Создаю интерфейс...")

    local Clipboard = setclipboard or toclipboard or function() end
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    -- Пробуем найти PlayerGui. Если его нет, ждем 2 секунды
    local pGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    if not pGui then 
        notify("Ошибка: Не найден PlayerGui!")
        return 
    end

    -- Удаляем старую копию, если она была запущенна ранее
    if pGui:FindFirstChild("LemonHubMM2") then
        pGui.LemonHubMM2:Destroy()
    end

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "LemonHubMM2"
    MainGui.Parent = pGui
    MainGui.ResetOnSpawn = false

    local function round(parent, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = parent
    end

    local flySpeed = 16
    local flying = false
    local walkSpeedValue = 16

    ---------------------------------------------------------
    -- МЕНЮ ЧИТА (Изначально скрыто)
    ---------------------------------------------------------
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 550, 0, 380)
    MenuFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 43)
    MenuFrame.BackgroundTransparency = 0.15
    MenuFrame.Visible = false
    MenuFrame.Parent = MainGui
    round(MenuFrame, 10)

    -- Перетаскивание меню
    local dragging, dragInput, dragStart, startPos
    MenuFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = MenuFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MenuFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MenuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Шапка меню
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Header.Parent = MenuFrame
    round(Header, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "MM2 | LEMONHUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = Header

    -- Закрыть [X]
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 25)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -12.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 70, 70)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.Parent = Header
    round(CloseBtn, 5)
    CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

    -- Свернуть [-]
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
    MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -12.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(230, 180, 60)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Parent = Header
    round(MinimizeBtn, 5)

    -- Скругленная плашка сверху
    local OpenPlacard = Instance.new("TextButton")
    OpenPlacard.Size = UDim2.new(0, 140, 0, 30)
    OpenPlacard.Position = UDim2.new(0.5, -70, 0, 10)
    OpenPlacard.BackgroundColor3 = Color3.fromRGB(40, 40, 43)
    OpenPlacard.Text = "Открыть меню"
    OpenPlacard.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenPlacard.Font = Enum.Font.SourceSansBold
    OpenPlacard.TextSize = 14
    OpenPlacard.Visible = false
    OpenPlacard.Parent = MainGui
    round(OpenPlacard, 10)

    MinimizeBtn.MouseButton1Click:Connect(function()
        MenuFrame.Visible = false
        OpenPlacard.Visible = true
    end)
    OpenPlacard.MouseButton1Click:Connect(function()
        MenuFrame.Visible = true
        OpenPlacard.Visible = false
    end)

    -- Вкладки
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MenuFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    ContentFrame.Position = UDim2.new(0, 10, 0, 100)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MenuFrame

    local Tabs = {}
    local Pages = {}

    local function createTab(name, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.Position = UDim2.new(0, (order-1) * 105, 0, 0)
        btn.BackgroundColor3 = order == 1 and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(60, 60, 65)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 15
        btn.Parent = TabContainer
        round(btn, 6)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.CanvasSize = UDim2.new(0, 0, 2, 0)
        page.ScrollBarThickness = 4
        page.Visible = order == 1
        page.Parent = ContentFrame
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = page

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(60, 60, 65) end
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        end)

        table.insert(Tabs, btn)
        table.insert(Pages, page)
        return page
    end

    local CombatPage = createTab("Combat", 1)
    local PlayerPage = createTab("Player", 2)
    local VisualPage = createTab("Visual", 3)

    -- Кастомные функции элементов
    local function addToggle(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 45)
        frame.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        frame.Parent = parent
        round(frame, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 45, 0, 22)
        btn.Position = UDim2.new(1, -55, 0.5, -11)
        btn.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
        btn.Text = ""
        btn.Parent = frame
        round(btn, 11)

        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = UDim2.new(0, 2, 0.5, -9)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.Parent = btn
        round(circle, 9)

        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            local targetX = enabled and 25 or 2
            local targetColor = enabled and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(80, 80, 85)
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, targetX, 0.5, -9)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            callback(enabled)
        end)
    end

    local function addSlider(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 60)
        frame.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        frame.Parent = parent
        round(frame, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 0, 25)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.4, 0, 0, 25)
        valLabel.Position = UDim2.new(1, -100, 0, 5)
        valLabel.Text = tostring(default)
        valLabel.TextColor3 = Color3.fromRGB(90, 120, 255)
        valLabel.Font = Enum.Font.SourceSansBold
        valLabel.TextSize = 16
        valLabel.TextXAlignment = Enum.TextXAlignment.Right
        valLabel.BackgroundTransparency = 1
        valLabel.Parent = frame

        local slideBar = Instance.new("TextButton")
        slideBar.Size = UDim2.new(1, -20, 0, 6)
        slideBar.Position = UDim2.new(0, 10, 0, 40)
        slideBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        slideBar.Text = ""
        slideBar.Parent = frame
        round(slideBar, 3)

        local slideFill = Instance.new("Frame")
        slideFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        slideFill.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        slideFill.Parent = slideBar
        round(slideFill, 3)

        local function updateSlider(input)
            local absPos = slideBar.AbsolutePosition.X
            local absSize = slideBar.AbsoluteSize.X
            local mousePos = input.Position.X
            local pct = math.clamp((mousePos - absPos) / absSize, 0, 1)
            slideFill.Size = UDim2.new(pct, 0, 1, 0)
            local value = math.floor(min + (max - min) * pct)
            valLabel.Text = tostring(value)
            callback(value)
        end

        local sliding = false
        slideBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true updateSlider(input)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
        end)
    end

    local function addButton(parent, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 16
        btn.Parent = parent
        round(btn, 6)
        btn.MouseButton1Click:Connect(callback)
    end

    -- Настройка Чита (Скорость, флай, есп)
    addSlider(PlayerPage, "WalkSpeed (Скорость)", 16, 150, 16, function(v)
        walkSpeedValue = v
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = v end)
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    if LocalPlayer.Character.Humanoid.WalkSpeed ~= walkSpeedValue then
                        LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedValue
                    end
                end
            end)
        end
    end)

    local noclip = false
    addToggle(PlayerPage, "No Clip (Свозь стены)", function(v)
        noclip = v
        if noclip then
            game:GetService("RunService").Stepped:Connect(function()
                if noclip then
                    pcall(function()
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end)
                end
            end)
        end
    end)

    addToggle(PlayerPage, "Fly (Полет)", function(v)
        flying = v
        if flying then
            task.spawn(function()
                local torso = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                local bv = Instance.new("BodyVelocity", torso)
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                while flying do
                    task.wait()
                    local cam = workspace.CurrentCamera.CFrame
                    local moveDir = Vector3.new()
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
                    bv.Velocity = moveDir.Unit * flySpeed
                    if moveDir == Vector3.new() then bv.Velocity = Vector3.new(0,0,0) end
                end
                bv:Destroy()
            end)
        end
    end)

    addSlider(PlayerPage, "Fly Speed (Скорость полета)", 16, 150, 16, function(v) flySpeed = v end)

    addToggle(VisualPage, "ESP Роли", function(v)
        _G.ESP = v
        while _G.ESP do
            task.wait(1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local isMurder = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                    local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                    local color = isMurder and Color3.fromRGB(255,0,0) or (isSheriff and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
                    
                    if not p.Character:FindFirstChild("LemonESP") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "LemonESP"
                        hl.FillColor = color
                        hl.FillTransparency = 0.4
                        hl.Parent = p.Character
                    else
                        p.Character.LemonESP.FillColor = color
                    end
                end
            end
        end
        if not _G.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("LemonESP") then p.Character.LemonESP:Destroy() end
            end
        end
    end)

    local function grabGun()
        local gun = workspace:FindFirstChild("GunDrop")
        if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame
        end
    end

    addButton(CombatPage, "Забрать Пистолет (Вручную)", grabGun)

    addToggle(CombatPage, "Авто-подбор пистолета", function(v)
        _G.AutoGrab = v
        while _G.AutoGrab do
            task.wait(0.5)
            grabGun()
        end
    end)

    addToggle(CombatPage, "Автофарм Монет & Ивентов", function(v)
        _G.CoinFarm = v
        while _G.CoinFarm do
            task.wait(0.3)
            local map = workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("Map")
            if map then
                for _, obj in pairs(map:GetDescendants()) do
                    if obj.Name == "CoinContainer" or obj.Name == "CandyContainer" or obj:FindFirstChild("TouchInterest") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and firetouchinterest then
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                            task.wait(0.02)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                        end
                    end
                end
            end
        end
    end)

    ---------------------------------------------------------
    -- ОКНО АВТОРИЗАЦИИ (КЛЮЧ)
    ---------------------------------------------------------
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 320, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    KeyFrame.Parent = MainGui
    round(KeyFrame, 12)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.Text = "LEMONHUB | Авторизация"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.Font = Enum.Font.SourceSansBold
    KeyTitle.TextSize = 16
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Parent = KeyFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 260, 0, 40)
    InputBox.Position = UDim2.new(0.5, -130, 0.4, -20)
    InputBox.PlaceholderText = "Введите ключ здесь..."
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    InputBox.Font = Enum.Font.SourceSans
    InputBox.TextSize = 15
    InputBox.Parent = KeyFrame
    round(InputBox, 6)

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 120, 0, 38)
    Submit.Position = UDim2.new(0.1, 0, 0.7, 0)
    Submit.Text = "Submit"
    Submit.Font = Enum.Font.SourceSansBold
    Submit.TextSize = 15
    Submit.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
    Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Submit.Parent = KeyFrame
    round(Submit, 8)

    local GetKey = Instance.new("TextButton")
    GetKey.Size = UDim2.new(0, 120, 0, 38)
    GetKey.Position = UDim2.new(0.53, 0, 0.7, 0)
    GetKey.Text = "Получить ключ"
    GetKey.Font = Enum.Font.SourceSansBold
    GetKey.TextSize = 15
    GetKey.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
    GetKey.TextColor3 = Color3.fromRGB(220, 220, 220)
    GetKey.Parent = KeyFrame
    round(GetKey, 8)

    GetKey.MouseButton1Click:Connect(function()
        Clipboard("https://discord.com/channels/1524036881057189889/1524036994085425235/1524038305753202810")
        GetKey.Text = "Скопировано!"
        task.wait(2)
        GetKey.Text = "Получить ключ"
    end)

    Submit.MouseButton1Click:Connect(function()
        if InputBox.Text == "ilovepigs" then
            KeyFrame:Destroy()
            MenuFrame.Visible = true
            notify("Ключ принят! Меню открыто.")
        else
            InputBox.Text = ""
            InputBox.PlaceholderText = "Неверный ключ!"
        end
    end)
end

-- Безопасный запуск с отслеживанием ошибок
local success, err = pcall(safeLoad)
if not success then
    print("КРИТИЧЕСКАЯ ОШИБКА СКРИПТА: ", err)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Скрипт упал!",
            Text = tostring(err),
            Duration = 10
        })
    end)
end
