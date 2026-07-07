-- LEMONHUB V9.2 | FULL MENU (FIXED GUN SYSTEM)
local function safeLoad()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Workspace = game:GetService("Workspace")
    
    if not LocalPlayer then return end
    
    local StarterGui = game:GetService("StarterGui")
    local function notify(text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "LEMONHUB V9.2",
                Text = text,
                Duration = 3
            })
        end)
    end

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

    -- Состояния
    local noclip = false
    local autoKillActive = false
    local autoShootActive = false
    local savedLocation = nil
    local flingTarget = ""
    local flingIndex = 1
    local walkSpeedValue = 16

    -- Главное меню
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 560, 0, 400)
    MenuFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    MenuFrame.Visible = true
    MenuFrame.Parent = MainGui
    round(MenuFrame, 12)

    -- Перетаскивание (Drag)
    local dragging, dragInput, dragStart, startPos
    MenuFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = MenuFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MenuFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MenuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
    Header.Parent = MenuFrame
    round(Header, 12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "LEMONHUB MM2 | Premium Edition"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1; Title.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 25)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -12.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 70, 70)
    CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.Parent = Header
    round(CloseBtn, 6)
    CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

    local OpenPlacard = Instance.new("TextButton")
    OpenPlacard.Size = UDim2.new(0, 150, 0, 40)
    OpenPlacard.Position = UDim2.new(0.5, -75, 0, 20)
    OpenPlacard.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
    OpenPlacard.Text = "Открыть LEMONHUB"; OpenPlacard.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenPlacard.Font = Enum.Font.SourceSansBold; OpenPlacard.TextSize = 14; OpenPlacard.Visible = false; OpenPlacard.Parent = MainGui
    round(OpenPlacard, 8)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
    MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -12.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(230, 180, 60)
    MinimizeBtn.Text = "-"; MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinimizeBtn.Parent = Header
    round(MinimizeBtn, 6)

    MinimizeBtn.MouseButton1Click:Connect(function() MenuFrame.Visible = false OpenPlacard.Visible = true end)
    OpenPlacard.MouseButton1Click:Connect(function() MenuFrame.Visible = true OpenPlacard.Visible = false end)

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundTransparency = 1; TabContainer.Parent = MenuFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    ContentFrame.Position = UDim2.new(0, 10, 0, 100)
    ContentFrame.BackgroundTransparency = 1; ContentFrame.Parent = MenuFrame

    local Tabs, Pages = {}, {}
    local function createTab(name, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.Position = UDim2.new(0, (order-1) * 105, 0, 0)
        btn.BackgroundColor3 = order == 1 and Color3.fromRGB(80, 110, 240) or Color3.fromRGB(45, 45, 50)
        btn.Text = name; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 15; btn.Parent = TabContainer
        round(btn, 6)

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1; page.ScrollBarThickness = 4
        page.CanvasSize = UDim2.new(0, 0, 0, 0); page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = order == 1; page.Parent = ContentFrame
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8); layout.Parent = page

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages) do p.Visible = false end
            for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
            page.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(80, 110, 240)
        end)
        table.insert(Tabs, btn) table.insert(Pages, page)
        return page
    end

    local CombatPage = createTab("Бой", 1)
    local PlayerPage = createTab("Игрок", 2)
    local VisualPage = createTab("Визуалы", 3)
    local TeleportPage = createTab("Телепорты", 4)
    local TrollPage = createTab("Troll", 5)

    local function createGroup(parent, title)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 25); frame.BackgroundTransparency = 1; frame.Parent = parent
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0); label.Text = "—— " .. title .. " ——"
        label.TextColor3 = Color3.fromRGB(140, 140, 145); label.Font = Enum.Font.SourceSansBold
        label.TextSize = 13; label.BackgroundTransparency = 1; label.Parent = frame
    end

    local function addButton(parent, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(80, 110, 240)
        btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 15; btn.Parent = parent
        round(btn, 6)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function addToggle(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 42); frame.BackgroundColor3 = Color3.fromRGB(42, 42, 46); frame.Parent = parent
        round(frame, 6)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = text; label.TextColor3 = Color3.fromRGB(225, 225, 225)
        label.Font = Enum.Font.SourceSans; label.TextSize = 15; label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1; label.Parent = frame
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 42, 0, 20); btn.Position = UDim2.new(1, -52, 0.5, -10)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 75); btn.Text = ""; btn.Parent = frame
        round(btn, 10)
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16); circle.Position = UDim2.new(0, 2, 0.5, -8)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); circle.Parent = btn
        round(circle, 8)
        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.12), {Position = UDim2.new(0, enabled and 24 or 2, 0.5, -8)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = enabled and Color3.fromRGB(80, 110, 240) or Color3.fromRGB(70, 70, 75)}):Play()
            task.spawn(callback, enabled)
        end)
    end

    -- Умная логика поиска именно лежащего песта
    local function getDroppedGun()
        local gun = Workspace:FindFirstChild("GunDrop")
        if not gun and Workspace:FindFirstChild("Setup") then
            gun = Workspace.Setup:FindFirstChild("GunDrop")
        end
        if gun and (gun:IsA("BasePart") or gun:FindFirstChild("ClassName") == "MeshPart" or gun:FindFirstChild("Handle")) then
            return gun
        end
        return nil
    end

    local function getMurderer()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then return p end
        end
        return nil
    end

    local function getSheriff()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and (p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")) then return p end
        end
        return nil
    end

    local function grabGunWithReturn()
        local gun = getDroppedGun()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if gun and hrp then
            savedLocation = hrp.CFrame
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            hrp.CFrame = gun.CFrame
            task.wait(0.12)
            if savedLocation then hrp.CFrame = savedLocation end
        end
    end

    ---------------------------------------------------------
    -- ВКЛАДКА: БОЙ
    ---------------------------------------------------------
    createGroup(CombatPage, "Пистолет Функции")
    
    addButton(CombatPage, "Подобрать Пистолет", grabGunWithReturn)
    
    addToggle(CombatPage, "Авто-подбор пистолета", function(v)
        _G.AutoGrab = v
        while _G.AutoGrab do
            task.wait(0.2)
            if getDroppedGun() then grabGunWithReturn() end
        end
    end)

    createGroup(CombatPage, "Авто-Стрельба")

    local function fireAtMurderer()
        local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
        local m = getMurderer()
        if gun and m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.Humanoid:EquipTool(gun)
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, m.Character.HumanoidRootPart.Position)
            task.wait(0.02)
            gun:Activate()
        end
    end

    addToggle(CombatPage, "Авто-выстрел по Мардеру (Полный Автомат)", function(v)
        autoShootActive = v
        while autoShootActive do
            task.wait(0.1)
            local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
            if gun then fireAtMurderer() end
        end
    end)

    -- Кнопка для мобилок с крестиком закрытия
    local MobileContainer = Instance.new("Frame")
    MobileContainer.Size = UDim2.new(0, 85, 0, 85)
    MobileContainer.Position = UDim2.new(0.75, 0, 0.4, 0)
    MobileContainer.BackgroundTransparency = 1; MobileContainer.Parent = MainGui

    local MobileShootBtn = Instance.new("TextButton")
    MobileShootBtn.Size = UDim2.new(0, 70, 0, 70)
    MobileShootBtn.Position = UDim2.new(0, 0, 0, 15)
    MobileShootBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    MobileShootBtn.Text = "ВЫСТРЕЛ"; MobileShootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileShootBtn.Font = Enum.Font.SourceSansBold; MobileShootBtn.TextSize = 14; MobileShootBtn.Parent = MobileContainer
    round(MobileShootBtn, 35)

    local HideMobileBtn = Instance.new("TextButton")
    HideMobileBtn.Size = UDim2.new(0, 20, 0, 20)
    HideMobileBtn.Position = UDim2.new(0, 55, 0, 0)
    HideMobileBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    HideMobileBtn.Text = "X"; HideMobileBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    HideMobileBtn.Font = Enum.Font.SourceSansBold; HideMobileBtn.TextSize = 11; HideMobileBtn.Parent = MobileContainer
    round(HideMobileBtn, 10)
    HideMobileBtn.MouseButton1Click:Connect(function() MobileContainer.Visible = false end)

    local mDrag, mStart, mBarStart
    MobileShootBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then mDrag = true mStart = i.Position mBarStart = MobileContainer.Position end end)
    MobileShootBtn.InputChanged:Connect(function(i) if mDrag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then local d = i.Position - mStart MobileContainer.Position = UDim2.new(mBarStart.X.Scale, mBarStart.X.Offset + d.X, mBarStart.Y.Scale, mBarStart.Y.Offset + d.Y) end end)
    MobileShootBtn.InputEnded:Connect(function() mDrag = false end)
    MobileShootBtn.MouseButton1Click:Connect(fireAtMurderer)

    createGroup(CombatPage, "Мясорубка")
    addToggle(CombatPage, "Авто-Убийство ВСЕХ", function(v)
        autoKillActive = v
        while autoKillActive do
            task.wait(0.1)
            local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if knife and myHrp then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        if not autoKillActive then break end
                        LocalPlayer.Character.Humanoid:EquipTool(knife)
                        myHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                        task.wait(0.04)
                        knife:Activate()
                    end
                end
            end
        end
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА: ИГРОК
    ---------------------------------------------------------
    createGroup(PlayerPage, "Характеристики")
    addToggle(PlayerPage, "Изменять Скорость Бега", function(v)
        _G.SpeedLoop = v
        while _G.SpeedLoop do RunService.RenderStepped:Wait()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedValue
            end
        end
    end)

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 40); SliderFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 46); SliderFrame.Parent = PlayerPage
    round(SliderFrame, 6)
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.4, 0, 1, 0); SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.Text = "Значение: 16"; SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left; SliderLabel.BackgroundTransparency = 1; SliderLabel.Parent = SliderFrame
    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(0, 180, 0, 8); SliderBtn.Position = UDim2.new(1, -200, 0.5, -4)
    SliderBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 80); SliderBtn.Text = ""; SliderBtn.Parent = SliderFrame
    round(SliderBtn, 4)
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0, 0, 1, 0); SliderBar.BackgroundColor3 = Color3.fromRGB(80, 110, 240); SliderBar.Parent = SliderBtn
    round(SliderBar, 4)

    local function updateSlider(input)
        local percentage = math.clamp((input.Position.X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1)
        SliderBar.Size = UDim2.new(percentage, 0, 1, 0)
        walkSpeedValue = math.floor(16 + (percentage * 100))
        SliderLabel.Text = "Значение: " .. tostring(walkSpeedValue)
    end
    local sDrag = false
    SliderBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sDrag = true updateSlider(i) end end)
    UIS.InputChanged:Connect(function(i) if sDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i) end end)
    UIS.InputEnded:Connect(function() sDrag = false end)

    addToggle(PlayerPage, "Проход Сквозь Стены (NoClip)", function(v)
        noclip = v
        RunService.Stepped:Connect(function()
            if noclip and LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
            end
        end)
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА: ВИЗУАЛЫ
    ---------------------------------------------------------
    createGroup(VisualPage, "Подсветка Игроков")
    addToggle(VisualPage, "ESP Ролей (Мардер/Шериф)", function(v)
        _G.HighlightESP = v
        while _G.HighlightESP do task.wait(0.8)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                    local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                    local color = isM and Color3.fromRGB(255, 40, 40) or (isS and Color3.fromRGB(40, 100, 255) or Color3.fromRGB(40, 220, 40))
                    
                    local hl = p.Character:FindFirstChild("LemonHighlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "LemonHighlight"
                        hl.Parent = p.Character
                    end
                    hl.FillColor = color; hl.OutlineColor = color
                    hl.FillTransparency = 0.4
                end
            end
        end
        if not _G.HighlightESP then
            for _, p in pairs(Players:GetPlayers()) do 
                if p.Character and p.Character:FindFirstChild("LemonHighlight") then p.Character.LemonHighlight:Destroy() end 
            end
        end
    end)

    addToggle(VisualPage, "Подсветка Упавшего Пистолета", function(v)
        _G.GunESP = v
        while _G.GunESP do task.wait(0.5)
            local gun = getDroppedGun()
            if gun then
                local hl = gun:FindFirstChild("LemonGunHl")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "LemonGunHl"
                    hl.Parent = gun
                end
                hl.FillColor = Color3.fromRGB(0, 255, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.1
            end
        end
        if not _G.GunESP then
            local gun = getDroppedGun()
            if gun and gun:FindFirstChild("LemonGunHl") then gun.LemonGunHl:Destroy() end
        end
    end)

    createGroup(VisualPage, "Камера Наблюдения")
    addButton(VisualPage, "Следить за Мардером", function()
        local m = getMurderer()
        if m and m.Character and m.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = m.Character.Humanoid
        else
            notify("Мардер ещё не раскрыт!")
        end
    end)

    addButton(VisualPage, "Следить за Шерифом", function()
        local s = getSheriff()
        if s and s.Character and s.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = s.Character.Humanoid
        else
            notify("Шериф с пистолетом не найден!")
        end
    end)

    addButton(VisualPage, "Сбросить камеру на себя", function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА: ТЕЛЕПОРТЫ
    ---------------------------------------------------------
    createGroup(TeleportPage, "Перемещение")
    addButton(TeleportPage, "Телепорт в Лобби", function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(-108, 142, 11) end
    end)

    addButton(TeleportPage, "Телепорт на Карту", function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetMap = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Innocent")
        if hrp and targetMap then
            hrp.CFrame = targetMap:GetPivot() + Vector3.new(0, 8, 0)
        else
            notify("Раунд ещё не начался!")
        end
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА: TROLL (ФЛИHГ ТУТ)
    ---------------------------------------------------------
    createGroup(TrollPage, "Разнос Сервера")

    local function runGlitchFling(targetChar)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            local oldN = noclip
            noclip = true
            
            local FlingVelocity = Instance.new("BodyAngularVelocity")
            FlingVelocity.Name = "FlingVel"
            FlingVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            FlingVelocity.AngularVelocity = Vector3.new(0, 99999, 0)
            FlingVelocity.Parent = hrp

            local startT = tick()
            while tick() - startT < 1.2 and targetChar and targetChar:FindFirstChild("HumanoidRootPart") do
                RunService.Heartbeat:Wait()
                hrp.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0.2, 0)
                hrp.AssemblyLinearVelocity = Vector3.new(0, 5000, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
            end
            
            if hrp:FindFirstChild("FlingVel") then hrp.FlingVel:Destroy() end
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
            hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
            noclip = oldN
        end
    end

    addButton(TrollPage, "Флинг ВСЕХ Игроков", function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then runGlitchFling(p.Character) end
        end
    end)

    local TargetFlingBtn = addButton(TrollPage, "Выбрать цель флинга", function()
        local list = Players:GetPlayers()
        if #list <= 1 then return end
        flingIndex = flingIndex + 1 if flingIndex > #list then flingIndex = 1 end
        if list[flingIndex] == LocalPlayer then flingIndex = flingIndex + 1 end
        local t = list[flingIndex]
        if t then flingTarget = t.Name TargetFlingBtn.Text = "Цель: " .. t.DisplayName end
    end)

    addButton(TrollPage, "Запустить Флинг в Цель", function()
        local tp = Players:FindFirstChild(flingTarget)
        if tp and tp.Character then runGlitchFling(tp.Character) else notify("Цель не найдена!") end
    end)

    ---------------------------------------------------------
    -- АВТОРИЗАЦИЯ
    ---------------------------------------------------------
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 320, 0, 180)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 26); KeyFrame.Parent = MainGui
    round(KeyFrame, 10)

    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1, 0, 0, 35); KTitle.Text = "LEMONHUB V9.2 | Авторизация"; KTitle.TextColor3 = Color3.fromRGB(255,255,255)
    KTitle.BackgroundTransparency = 1; KTitle.Font = Enum.Font.SourceSansBold; KTitle.Parent = KeyFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 260, 0, 38); InputBox.Position = UDim2.new(0.5, -130, 0.4, -10)
    InputBox.PlaceholderText = "Введите ключ доступа..."; InputBox.Text = ""; InputBox.TextColor3 = Color3.fromRGB(255, 255, 255); InputBox.BackgroundColor3 = Color3.fromRGB(38, 38, 42); InputBox.Parent = KeyFrame
    round(InputBox, 6)

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 120, 0, 35); Submit.Position = UDim2.new(0.5, -60, 0.7, 5)
    Submit.Text = "Войти"; Submit.BackgroundColor3 = Color3.fromRGB(80, 110, 240); Submit.TextColor3 = Color3.fromRGB(255, 255, 255); Submit.Parent = KeyFrame
    round(Submit, 6)

    Submit.MouseButton1Click:Connect(function()
        if InputBox.Text == "ilovepigs" then KeyFrame:Destroy() MenuFrame.Visible = true else InputBox.Text = "" InputBox.PlaceholderText = "Неверный ключ!" end
    end)
end

pcall(safeLoad)
