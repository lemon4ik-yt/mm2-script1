-- LEMONHUB V3 | GLOBAL FIX & ANTI-PATCH
local function safeLoad()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    
    if not LocalPlayer then return end
    
    local StarterGui = game:GetService("StarterGui")
    local function notify(text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "LEMONHUB V3",
                Text = text,
                Duration = 4
            })
        end)
    end

    notify("Запуск фикса LEMONHUB V3...")

    local Clipboard = setclipboard or toclipboard or function() end
    local pGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 5)
    if pGui:FindFirstChild("LemonHubMM2") then pGui.LemonHubMM2:Destroy() end

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "LemonHubMM2"
    MainGui.Parent = pGui
    MainGui.ResetOnSpawn = false

    local function round(parent, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = parent
    end

    -- Настройки
    local flySpeed = 50
    local flying = false
    local walkSpeedValue = 16
    local flingTarget = ""
    local serverIndex = 1

    ---------------------------------------------------------
    -- МЕНЮ ЧИТА
    ---------------------------------------------------------
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 560, 0, 400)
    MenuFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    MenuFrame.BackgroundTransparency = 0.15
    MenuFrame.Visible = false
    MenuFrame.Parent = MainGui
    round(MenuFrame, 10)

    -- Перетаскивание
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

    -- Хедер
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Header.Parent = MenuFrame
    round(Header, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "MM2 | LEMONHUB V3"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Parent = Header

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

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
    MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -12.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(230, 180, 60)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Parent = Header
    round(MinimizeBtn, 5)

    local OpenPlacard = Instance.new("TextButton")
    OpenPlacard.Size = UDim2.new(0, 140, 0, 30)
    OpenPlacard.Position = UDim2.new(0.5, -70, 0, 10)
    OpenPlacard.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    OpenPlacard.Text = "Открыть меню"
    OpenPlacard.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenPlacard.Font = Enum.Font.SourceSansBold
    OpenPlacard.TextSize = 14
    OpenPlacard.Visible = false
    OpenPlacard.Parent = MainGui
    round(OpenPlacard, 10)

    MinimizeBtn.MouseButton1Click:Connect(function() MenuFrame.Visible = false OpenPlacard.Visible = true end)
    OpenPlacard.MouseButton1Click:Connect(function() MenuFrame.Visible = true OpenPlacard.Visible = false end)

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

    local Tabs, Pages = {}, {}
    local function createTab(name, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 95, 1, 0)
        btn.Position = UDim2.new(0, (order-1) * 100, 0, 0)
        btn.BackgroundColor3 = order == 1 and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(55, 55, 60)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 15
        btn.Parent = TabContainer
        round(btn, 6)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollBarThickness = 4
        page.Visible = order == 1
        page.Parent = ContentFrame
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.Parent = page

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(55, 55, 60) end
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        end)
        table.insert(Tabs, btn) table.insert(Pages, page)
        return page
    end

    local CombatPage = createTab("Combat", 1)
    local PlayerPage = createTab("Player", 2)
    local VisualPage = createTab("Visual", 3)
    local OtherPage = createTab("Other", 4)

    local function createGroup(parent, title)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "—— " .. title .. " ——"
        label.TextColor3 = Color3.fromRGB(150, 150, 160)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14
        label.BackgroundTransparency = 1
        label.Parent = frame
    end

    local function addToggle(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 45)
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
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
        btn.BackgroundColor3 = Color3.fromRGB(75, 75, 80)
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
            TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(0, enabled and 25 or 2, 0.5, -9)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = enabled and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(75, 75, 80)}):Play()
            task.spawn(callback, enabled)
        end)
    end

    local function addSlider(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 60)
        frame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        frame.Parent = parent
        round(frame, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 0, 25)
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Parent = frame
        label.BackgroundTransparency = 1 label.Font = Enum.Font.SourceSans label.TextSize = 16 label.TextXAlignment = Enum.TextXAlignment.Left

        local valLabel = Instance.new("TextLabel")
        valLabel.Size = UDim2.new(0.4, 0, 0, 25)
        valLabel.Position = UDim2.new(1, -100, 0, 5)
        valLabel.Text = tostring(default)
        valLabel.TextColor3 = Color3.fromRGB(90, 120, 255)
        valLabel.Parent = frame
        valLabel.BackgroundTransparency = 1 valLabel.Font = Enum.Font.SourceSansBold valLabel.TextSize = 16 valLabel.TextXAlignment = Enum.TextXAlignment.Right

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

        local sliding = false
        local function updateSlider(input)
            local pct = math.clamp((input.Position.X - slideBar.AbsolutePosition.X) / slideBar.AbsoluteSize.X, 0, 1)
            slideFill.Size = UDim2.new(pct, 0, 1, 0)
            local value = math.floor(min + (max - min) * pct)
            valLabel.Text = tostring(value)
            callback(value)
        end
        slideBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true updateSlider(input) end
        end)
        UIS.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
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

    ---------------------------------------------------------
    -- ПОЧИНЕННЫЙ ФУНКЦИОНАЛ (УСТОЙЧИВЫЙ К ОБНОВЛЕНИЯМ)
    ---------------------------------------------------------
    
    -- Поиск упавшего пистолета на карте по альтернативным путям
    local function findGun()
        local gun = workspace:FindFirstChild("GunDrop")
        if not gun then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Tool") and (string.find(obj.Name, "Gun") or obj:FindFirstChild("Detections")) then gun = obj break end
                if obj:IsA("Part") and string.find(obj.Name, "Gun") then gun = obj break end
            end
        end
        return gun
    end

    createGroup(CombatPage, "Пистолет")
    addButton(CombatPage, "Забрать Пистолет (Вручную)", function()
        local g = findGun()
        if g and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = g.CFrame
        else
            notify("Пистолет на земле не найден!")
        end
    end)

    addToggle(CombatPage, "Авто-подбор пистолета", function(v)
        _G.AutoGrab = v 
        while _G.AutoGrab do 
            task.wait(0.5) 
            local g = findGun()
            if g and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local p = g:IsA("Tool") and g:FindFirstChild("Handle") or g
                if p then LocalPlayer.Character.HumanoidRootPart.CFrame = p.CFrame end
            end 
        end
    end)

    createGroup(CombatPage, "Auto Farm")
    addToggle(CombatPage, "Автофарм Монет & Ивентов", function(v)
        _G.CoinFarm = v
        while _G.CoinFarm do
            task.wait(0.3)
            -- Универсальный поиск контейнеров монет во всех папках
            for _, folder in pairs(workspace:GetChildren()) do
                if folder.Name == "Normal" or folder:FindFirstChild("Map") then
                    for _, obj in pairs(folder:GetDescendants()) do
                        if (string.find(string.lower(obj.Name), "coin") or string.find(string.lower(obj.Name), "candy") or obj.Name == "TouchInterest") and firetouchinterest then
                            local targetPart = obj:IsA("TouchInterest") and obj.Parent or obj
                            if targetPart:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetPart, 0)
                                task.wait(0.02)
                                firetouchinterest(LocalPlayer.Character.HumanoidRootPart, targetPart, 1)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Абсолютный фикс Скорости через CFrame (не сбивается античитом)
    createGroup(PlayerPage, "Движение")
    addSlider(PlayerPage, "WalkSpeed (Скорость)", 16, 120, 16, function(v) walkSpeedValue = v end)
    
    RunService.Heartbeat:Connect(function()
        if walkSpeedValue > 16 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (walkSpeedValue / 120))
            end
        end
    end)

    local noclip = false
    addToggle(PlayerPage, "No Clip (Свозь стены)", function(v)
        noclip = v
        if noclip then
            RunService.Stepped:Connect(function()
                if noclip and LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
        end
    end)

    -- Стабильный неуязвимый FLY
    addToggle(PlayerPage, "Fly (Рабочий Полет)", function(v)
        flying = v
        if flying then
            task.spawn(function()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                
                local bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                bv.Velocity = Vector3.new(0,0,0)
                
                local bg = Instance.new("BodyGyro", hrp)
                bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
                bg.CFrame = hrp.CFrame

                while flying and char and hrp and bv.Parent do
                    RunService.RenderStepped:Wait()
                    local cam = workspace.CurrentCamera.CFrame
                    local md = Vector3.new()
                    
                    if UIS:IsKeyDown(Enum.KeyCode.W) then md = md + cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then md = md - cam.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then md = md - cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then md = md + cam.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0,1,0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then md = md - Vector3.new(0,1,0) end
                    
                    bv.Velocity = md.Unit * flySpeed
                    if md == Vector3.new(0,0,0) then bv.Velocity = Vector3.new(0,0,0) end
                    bg.CFrame = cam
                end
                bv:Destroy() bg:Destroy()
            end)
        end
    end)
    addSlider(PlayerPage, "Fly Speed (Скорость полета)", 20, 200, 50, function(v) flySpeed = v end)

    -- Вкладка VISUAL (ESP Игроков + НОВОЕ: ESP Пестолета)
    createGroup(VisualPage, "Визуалы")
    addToggle(VisualPage, "ESP Роли игроков", function(v)
        _G.ESP = v
        while _G.ESP do task.wait(1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                    local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                    local color = isM and Color3.fromRGB(255,0,0) or (isS and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
                    if not p.Character:FindFirstChild("LemonESP") then
                        local hl = Instance.new("Highlight", p.Character) hl.Name = "LemonESP" hl.FillColor = color hl.FillTransparency = 0.4
                    else p.Character.LemonESP.FillColor = color end
                end
            end
        end
        if not _G.ESP then
            for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("LemonESP") then p.Character.LemonESP:Destroy() end end
        end
    end)

    -- СВЕЖЕЕ: ESP на лежащий пест
    addToggle(VisualPage, "ESP Пистолета (На земле)", function(v)
        _G.GunESP = v
        while _G.GunESP do task.wait(0.5)
            local g = findGun()
            if g then
                local model = g:IsA("Tool") and g or g.Parent
                if model and not model:FindFirstChild("GunHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "GunHighlight"
                    hl.FillColor = Color3.fromRGB(180, 50, 255) -- Фиолетовое свечение ствола
                    hl.FillTransparency = 0.2
                    hl.OutlineColor = Color3.fromRGB(255,255,255)
                    hl.Parent = model
                end
            end
        end
        if not _G.GunESP then
            local g = findGun()
            if g then
                local m = g:IsA("Tool") and g or g.Parent
                if m and m:FindFirstChild("GunHighlight") then m.GunHighlight:Destroy() end
            end
        end
    end)

    -- Вкладка OTHER (Fling)
    createGroup(OtherPage, "Fling Игроков")

    local NameInput = Instance.new("TextBox")
    NameInput.Size = UDim2.new(1, -10, 0, 40)
    NameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    NameInput.PlaceholderText = "Введите ник игрока..."
    NameInput.Text = ""
    NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameInput.Parent = OtherPage
    round(NameInput, 6)
    NameInput.FocusLost:Connect(function() flingTarget = NameInput.Text end)

    local function executeFling(targetChar)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if hrp and targetHrp then
            local oldCFrame = hrp.CFrame
            local vel = Instance.new("BodyAngularVelocity", hrp)
            vel.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            vel.AngularVelocity = Vector3.new(0, 99999, 0)
            
            local startTime = tick()
            while tick() - startTime < 1.0 do
                RunService.Heartbeat:Wait()
                hrp.CFrame = targetHrp.CFrame * CFrame.new(0, -0.5, 0)
            end
            vel:Destroy()
            hrp.CFrame = oldCFrame
        end
    end

    addButton(OtherPage, "Fling по никнейму", function()
        for _, p in pairs(Players:GetPlayers()) do
            if string.find(string.lower(p.Name), string.lower(flingTarget)) or string.find(string.lower(p.DisplayName), string.lower(flingTarget)) then
                if p ~= LocalPlayer and p.Character then executeFling(p.Character) break end
            end
        end
    end)

    local SelectBtn = Instance.new("TextButton")
    SelectBtn.Size = UDim2.new(1, -10, 0, 40)
    SelectBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
    SelectBtn.Text = "Выбрать игрока с сервера"
    SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectBtn.Parent = OtherPage
    round(SelectBtn, 6)

    SelectBtn.MouseButton1Click:Connect(function()
        local list = Players:GetPlayers()
        if #list <= 1 then return end
        serverIndex = serverIndex + 1
        if serverIndex > #list then serverIndex = 1 end
        if list[serverIndex] == LocalPlayer then serverIndex = serverIndex + 1 end
        if serverIndex > #list then serverIndex = 1 end
        local target = list[serverIndex]
        if target then NameInput.Text = target.Name flingTarget = target.Name SelectBtn.Text = "Выбран: " .. target.DisplayName end
    end)

    addButton(OtherPage, "Fling ВЕСЬ СЕРВЕР", function()
        notify("Уничтожение сервера запущено...")
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                executeFling(p.Character) task.wait(0.1)
            end
        end
    end)

    ---------------------------------------------------------
    -- ОКНО АВТОРИЗАЦИИ
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
    InputBox.Parent = KeyFrame
    round(InputBox, 6)

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 120, 0, 38)
    Submit.Position = UDim2.new(0.1, 0, 0.7, 0)
    Submit.Text = "Submit"
    Submit.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
    Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    Submit.Parent = KeyFrame
    round(Submit, 8)

    local GetKey = Instance.new("TextButton")
    GetKey.Size = UDim2.new(0, 120, 0, 38)
    GetKey.Position = UDim2.new(0.53, 0, 0.7, 0)
    GetKey.Text = "Получить ключ"
    GetKey.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
    GetKey.TextColor3 = Color3.fromRGB(220, 220, 220)
    GetKey.Parent = KeyFrame
    round(GetKey, 8)

    GetKey.MouseButton1Click:Connect(function()
        Clipboard("https://discord.com/channels/1524036881057189889/1524036994085425235/1524038305753202810")
        GetKey.Text = "Скопировано!"
        task.wait(2) GetKey.Text = "Получить ключ"
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

local success, err = pcall(safeLoad)
if not success then print("Ошибка загрузки хаба: ", err) end
