-- LEMONHUB V5 | THE ULTIMATE UPDATE
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
                Title = "LEMONHUB V5",
                Text = text,
                Duration = 4
            })
        end)
    end

    notify("LEMONHUB V5 успешно загружен!")

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
    local combatTarget = ""
    local combatIndex = 1
    local spectating = false
    local noclip = false

    ---------------------------------------------------------
    -- МЕНЮ ЧИТА
    ---------------------------------------------------------
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 560, 0, 420)
    MenuFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    MenuFrame.BackgroundTransparency = 0.1
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
    Header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Header.Parent = MenuFrame
    round(Header, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "MM2 | LEMONHUB V5"
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
    OpenPlacard.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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
        btn.Size = UDim2.new(0, 85, 1, 0)
        btn.Position = UDim2.new(0, (order-1) * 90, 0, 0)
        btn.BackgroundColor3 = order == 1 and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(50, 50, 55)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
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
            for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(50, 50, 55) end
            page.Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        end)
        table.insert(Tabs, btn) table.insert(Pages, page)
        return page
    end

    local CombatPage = createTab("Combat", 1)
    local PlayerPage = createTab("Player", 2)
    local VisualPage = createTab("Visual", 3)
    local TeleportPage = createTab("Teleports", 4)

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
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
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
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
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
        valLabel.Text = text .. ": " .. tostring(default)
        valLabel.TextColor3 = Color3.fromRGB(90, 120, 255)
        valLabel.Parent = frame
        valLabel.BackgroundTransparency = 1 valLabel.Font = Enum.Font.SourceSansBold valLabel.TextSize = 15 valLabel.TextXAlignment = Enum.TextXAlignment.Right

        local slideBar = Instance.new("TextButton")
        slideBar.Size = UDim2.new(1, -20, 0, 6)
        slideBar.Position = UDim2.new(0, 10, 0, 40)
        slideBar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
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
            valLabel.Text = text .. ": " .. tostring(value)
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
        
        -- Функция внешнего обновления текста ползунка
        return function(newValue)
            local pct = math.clamp((newValue - min) / (max - min), 0, 1)
            slideFill.Size = UDim2.new(pct, 0, 1, 0)
            valLabel.Text = text .. ": " .. tostring(newValue)
        end
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
    -- СТРОГИЙ ПОИСК ВЫПАВШЕГО ПИСТОЛЕТА (БЕЗ ШЕРИФА)
    ---------------------------------------------------------
    local function findDroppedGun()
        local drop = workspace:FindFirstChild("GunDrop")
        if drop and drop:IsA("BasePart") then
            return drop
        end
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:IsA("Part") and string.find(obj.Name, "Gun") and not obj:FindFirstChild("Detections") then
                return obj
            end
        end
        return nil
    end

    ---------------------------------------------------------
    -- ВКЛАДКА COMBAT (ПЕРЕРАБОТАННАЯ)
    ---------------------------------------------------------
    createGroup(CombatPage, "Взаимодействие с пестом")
    
    addButton(CombatPage, "Забрать Пистолет (Только с пола)", function()
        local gun = findDroppedGun()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if gun and hrp then
            hrp.CFrame = gun.CFrame + Vector3.new(0, 1, 0)
        else
            notify("Выпавший пистолет на полу не найден!")
        end
    end)

    addToggle(CombatPage, "Авто-подбор пистолета (С пола)", function(v)
        _G.AutoGrab = v
        while _G.AutoGrab do
            task.wait(0.2)
            local gun = findDroppedGun()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if gun and hrp then
                hrp.CFrame = gun.CFrame + Vector3.new(0, 1, 0)
            end
        end
    end)

    createGroup(CombatPage, "Уничтожение Сервера (За Мардера)")
    
    local function stab(target)
        local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if knife and hrp and target and target:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.Humanoid:EquipTool(knife)
            hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.5)
            task.wait(0.05)
            knife:Activate()
        end
    end

    addButton(CombatPage, "Убить Всех", function()
        local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
        if not knife then notify("Вы должны быть Мардером с ножом!") return end
        
        notify("Аннигиляция сервера запущена...")
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                local startTime = tick()
                while p.Character and p.Character.Humanoid.Health > 0 and tick() - startTime < 0.8 do
                    RunService.Heartbeat:Wait()
                    stab(p.Character)
                end
            end
        end
    end)

    local CombatSelectBtn = Instance.new("TextButton")
    CombatSelectBtn.Size = UDim2.new(1, -10, 0, 40)
    CombatSelectBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
    CombatSelectBtn.Text = "Выбрать цель для убийства"
    CombatSelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CombatSelectBtn.Font = Enum.Font.SourceSansBold; CombatSelectBtn.TextSize = 15
    CombatSelectBtn.Parent = CombatPage
    round(CombatSelectBtn, 6)

    CombatSelectBtn.MouseButton1Click:Connect(function()
        local list = Players:GetPlayers()
        if #list <= 1 then return end
        combatIndex = combatIndex + 1 if combatIndex > #list then combatIndex = 1 end
        if list[combatIndex] == LocalPlayer then combatIndex = combatIndex + 1 end
        if combatIndex > #list then combatIndex = 1 end
        local t = list[combatIndex]
        if t then combatTarget = t.Name CombatSelectBtn.Text = "Цель: " .. t.DisplayName end
    end)

    addButton(CombatPage, "Убить Выбранного игрока", function()
        local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
        if not knife then notify("Вы должны быть Мардером!") return end
        local targetPlayer = Players:FindFirstChild(combatTarget)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local startTime = tick()
            while targetPlayer.Character and targetPlayer.Character.Humanoid.Health > 0 and tick() - startTime < 1.5 do
                RunService.Heartbeat:Wait()
                stab(targetPlayer.Character)
            end
        else
            notify("Игрок не найден или мертв!")
        end
    end)

    ---------------------------------------------------------
    -- ПЕРЕМЕЩЕНИЕ И КОЛЕСИКО МЫШИ (WALKSPEED СИСТЕМА)
    ---------------------------------------------------------
    createGroup(PlayerPage, "Кастомизация")
    local updateSpeedSlider = addSlider(PlayerPage, "Скорость", 16, 120, 16, function(v) walkSpeedValue = v end)
    
    -- Считывание прокрутки колесика мыши для изменения скорости
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if input.Position.Z > 0 then
                walkSpeedValue = math.clamp(walkSpeedValue + 4, 16, 120)
            else
                walkSpeedValue = math.clamp(walkSpeedValue - 4, 16, 120)
            end
            updateSpeedSlider(walkSpeedValue) -- Синхронизируем визуальное состояние ползунка
        end
    end)

    RunService.Heartbeat:Connect(function()
        if walkSpeedValue > 16 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if hum.MoveDirection.Magnitude > 0 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * (walkSpeedValue / 135))
            end
        end
    end)

    addToggle(PlayerPage, "No Clip (Свозь стены)", function(v)
        noclip = v
        RunService.Stepped:Connect(function()
            if noclip and LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end)

    ---------------------------------------------------------
    -- СТАБИЛЬНЫЙ АВТОФАРМ МОНЕТ
    ---------------------------------------------------------
    addToggle(PlayerPage, "Автофарм Монет & Ивентов", function(v)
        _G.CoinFarm = v
        while _G.CoinFarm do
            task.wait(0.2)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("TouchInterest") and obj.Parent and (string.find(string.lower(obj.Parent.Name), "coin") or string.find(string.lower(obj.Parent.Name), "candy") or string.find(string.lower(obj.Parent.Name), "token")) then
                        if firetouchinterest then
                            firetouchinterest(hrp, obj.Parent, 0)
                            task.wait(0.01)
                            firetouchinterest(hrp, obj.Parent, 1)
                        end
                    end
                end
            end
        end
    end)

    ---------------------------------------------------------
    -- ВИЗУАЛЫ И СТРОГИЙ ЭКРАННЫЙ ESP ФИКС
    ---------------------------------------------------------
    createGroup(VisualPage, "Подсветка")
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

    addToggle(VisualPage, "ESP Пистолета (На полу)", function(v)
        _G.GunESP = v
        while _G.GunESP do task.wait(0.3)
            local gun = findDroppedGun()
            if gun then
                if not gun:FindFirstChild("StrictGunHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "StrictGunHighlight"
                    hl.FillColor = Color3.fromRGB(0, 255, 255)
                    hl.FillTransparency = 0.2
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.Parent = gun
                end
            else
                -- Очистка старых хейлайтов, если пест подобрали
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "StrictGunHighlight" then obj:Destroy() end
                end
            end
        end
        if not _G.GunESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "StrictGunHighlight" then obj:Destroy() end
            end
        end
    end)

    local function getRoleTarget(roleName)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Humanoid") then
                if roleName == "Murder" and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then return p end
                if roleName == "Sheriff" and (p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")) then return p end
            end
        end
        return nil
    end

    createGroup(VisualPage, "Спектатор камеры")
    addButton(VisualPage, "Наблюдать за Мардером", function()
        spectating = not spectating
        local target = getRoleTarget("Murder")
        if spectating and target and target.Character then
            workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        else
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            spectating = false
        end
    end)

    addButton(VisualPage, "Наблюдать за Шерифом", function()
        spectating = not spectating
        local target = getRoleTarget("Sheriff")
        if spectating and target and target.Character then
            workspace.CurrentCamera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        else
            workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
            spectating = false
        end
    end)

    ---------------------------------------------------------
    -- СТАБИЛЬНЫЕ ТЕЛЕПОРТЫ НАД КАРТОЙ (БЕЗ ПРОВАЛОВ)
    ---------------------------------------------------------
    local function safeTeleport(cframe)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Кратковременный noclip для предотвращения застреваний
            local oldNoclip = noclip
            noclip = true
            hrp.CFrame = cframe + Vector3.new(0, 7, 0) -- Спавним строго выше земли
            task.wait(0.2)
            noclip = oldNoclip
        end
    end

    createGroup(TeleportPage, "Локации")
    addButton(TeleportPage, "Телепорт в Лобби", function()
        safeTeleport(CFrame.new(-108, 138, 11))
    end)

    addButton(TeleportPage, "Телепорт на Карту", function()
        local map = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map")
        if map then
            local targetPart = map:FindFirstChildDescendant("Spawn") or map:FindFirstChildDescendant("CoinContainer") or map:FindFirstChildDescendant("TouchInterest")
            if targetPart then
                safeTeleport(targetPart.Parent:GetPivot())
            else
                safeTeleport(map:GetPivot())
            end
        else
            notify("Активная игровая карта не найдена!")
        end
    end)

    createGroup(TeleportPage, "К игрокам")
    local tpIndex = 1
    local PlayerTpBtn = Instance.new("TextButton")
    PlayerTpBtn.Size = UDim2.new(1, -10, 0, 40)
    PlayerTpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    PlayerTpBtn.Text = "Выбрать игрока для ТП"
    PlayerTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerTpBtn.Font = Enum.Font.SourceSansBold; PlayerTpBtn.TextSize = 15
    PlayerTpBtn.Parent = TeleportPage
    round(PlayerTpBtn, 6)

    PlayerTpBtn.MouseButton1Click:Connect(function()
        local list = Players:GetPlayers()
        if #list <= 1 then return end
        tpIndex = tpIndex + 1 if tpIndex > #list then tpIndex = 1 end
        if list[tpIndex] == LocalPlayer then tpIndex = tpIndex + 1 end
        if tpIndex > #list then tpIndex = 1 end
        local t = list[tpIndex]
        if t then PlayerTpBtn.Text = "ТП к: " .. t.DisplayName end
    end)

    addButton(TeleportPage, "Выполнить Телепорт", function()
        local list = Players:GetPlayers()
        local target = list[tpIndex]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            safeTeleport(target.Character.HumanoidRootPart.CFrame)
        end
    end)

    ---------------------------------------------------------
    -- ОКНО АВТОРИЗАЦИИ
    ---------------------------------------------------------
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 320, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    KeyFrame.Parent = MainGui
    round(KeyFrame, 12)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.Text = "LEMONHUB | Авторизация"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.Font = Enum.Font.SourceSansBold; KeyTitle.TextSize = 16
    KeyTitle.BackgroundTransparency = 1; KeyTitle.Parent = KeyFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 260, 0, 40)
    InputBox.Position = UDim2.new(0.5, -130, 0.4, -20)
    InputBox.PlaceholderText = "Введите ключ здесь..."
    InputBox.Text = ""
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
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
    GetKey.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
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
            notify("Доступ разрешен! LEMONHUB активирован.")
        else
            InputBox.Text = ""
            InputBox.PlaceholderText = "Неверный ключ!"
        end
    end)
end

local success, err = pcall(safeLoad)
if not success then print("Критическая ошибка скрипта: ", err) end
