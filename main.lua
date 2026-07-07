-- LEMONHUB V8.0 | CLEAN REBOOT (ALL FIXED)
local function safeLoad()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    if not LocalPlayer then return end
    
    local StarterGui = game:GetService("StarterGui")
    local function notify(text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "LEMONHUB V8.0",
                Text = text,
                Duration = 3
            })
        end)
    end

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

    -- Состояния
    local noclip = false
    local autoKillActive = false
    local fpsBoostActive = false
    local originalMaterials = {}
    local savedLocation = nil
    local currentBind = Enum.KeyCode.E
    local bindingMode = false
    local flingTarget = ""
    local flingIndex = 1
    local walkSpeedValue = 16
    local flyActive = false
    local flySpeed = 50

    -- Окно меню
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 560, 0, 420)
    MenuFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    MenuFrame.Visible = false
    MenuFrame.Parent = MainGui
    round(MenuFrame, 10)

    -- Драг
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
    Header.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Header.Parent = MenuFrame
    round(Header, 10)

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
    round(CloseBtn, 5)
    CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

    local OpenPlacard = Instance.new("TextButton")
    OpenPlacard.Size = UDim2.new(0, 140, 0, 35)
    OpenPlacard.Position = UDim2.new(0.5, -70, 0, 15)
    OpenPlacard.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    OpenPlacard.Text = "Открыть LEMONHUB"; OpenPlacard.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenPlacard.Font = Enum.Font.SourceSansBold; OpenPlacard.TextSize = 14; OpenPlacard.Visible = false; OpenPlacard.Parent = MainGui
    round(OpenPlacard, 8)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
    MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -12.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(230, 180, 60)
    MinimizeBtn.Text = "-"; MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinimizeBtn.Parent = Header
    round(MinimizeBtn, 5)

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
        btn.Size = UDim2.new(0, 92, 1, 0)
        btn.Position = UDim2.new(0, (order-1) * 96, 0, 0)
        btn.BackgroundColor3 = order == 1 and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(50, 50, 55)
        btn.Text = name; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 14; btn.Parent = TabContainer
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
            for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(50, 50, 55) end
            page.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        end)
        table.insert(Tabs, btn) table.insert(Pages, page)
        return page
    end

    local CombatPage = createTab("Combat", 1)
    local PlayerPage = createTab("Player", 2)
    local VisualPage = createTab("Visual", 3)
    local TeleportPage = createTab("Teleports", 4)
    local ChatPage = createTab("Hub Chat", 5)

    local function createGroup(parent, title)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 30); frame.BackgroundTransparency = 1; frame.Parent = parent
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0); label.Text = "—— " .. title .. " ——"
        label.TextColor3 = Color3.fromRGB(150, 150, 160); label.Font = Enum.Font.SourceSansBold
        label.TextSize = 14; label.BackgroundTransparency = 1; label.Parent = frame
    end

    local function addButton(parent, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 16; btn.Parent = parent
        round(btn, 6)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function addToggle(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(45, 45, 50); frame.Parent = parent
        round(frame, 6)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = text; label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.SourceSans; label.TextSize = 16; label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1; label.Parent = frame
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 45, 0, 22); btn.Position = UDim2.new(1, -55, 0.5, -11)
        btn.BackgroundColor3 = Color3.fromRGB(75, 75, 80); btn.Text = ""; btn.Parent = frame
        round(btn, 11)
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 18, 0, 18); circle.Position = UDim2.new(0, 2, 0.5, -9)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); circle.Parent = btn
        round(circle, 9)
        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(0, enabled and 25 or 2, 0.5, -9)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = enabled and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(75, 75, 80)}):Play()
            task.spawn(callback, enabled)
        end)
    end

    -- Логика MM2
    local function getMurderer()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then return p end
        end
        return nil
    end

    local function findDroppedGun()
        return workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Setup") and workspace.Setup:FindFirstChild("GunDrop")
    end

    ---------------------------------------------------------
    -- COMBAT
    ---------------------------------------------------------
    createGroup(CombatPage, "Пистолет Функции")
    
    local function grabGunWithReturn()
        local gun = findDroppedGun()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if gun and hrp then
            savedLocation = hrp.CFrame
            hrp.CFrame = gun.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.2)
            if savedLocation then hrp.CFrame = savedLocation end
        end
    end

    addButton(CombatPage, "Подобрать Пистолет", grabGunWithReturn)
    addToggle(CombatPage, "Авто-подбор пистолета", function(v)
        _G.AutoGrab = v
        while _G.AutoGrab do
            task.wait(0.5)
            if findDroppedGun() then grabGunWithReturn() end
        end
    end)

    createGroup(CombatPage, "Авто-стрельба")

    local function fireAtMurderer()
        local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
        local m = getMurderer()
        if gun and m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.Humanoid:EquipTool(gun)
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, m.Character.HumanoidRootPart.Position)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(m.Character.HumanoidRootPart.Position.X, LocalPlayer.Character.HumanoidRootPart.Position.Y, m.Character.HumanoidRootPart.Position.Z))
            task.wait(0.05)
            gun:Activate()
        end
    end

    local BindBtn = addButton(CombatPage, "Бинд Shoot: [ " .. currentBind.Name .. " ]", function()
        bindingMode = true
        BindBtn.Text = "Нажмите клавишу..."
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if bindingMode and not gpe then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentBind = input.KeyCode
                bindingMode = false
                BindBtn.Text = "Бинд Shoot: [ " .. currentBind.Name .. " ]"
                notify("Кнопка переназначена!")
            end
        elseif input.KeyCode == currentBind and not gpe then
            fireAtMurderer()
        end
    end)

    -- Универсальная кнопка для мобилок (Экранная)
    local MobileShootBtn = Instance.new("TextButton")
    MobileShootBtn.Size = UDim2.new(0, 70, 0, 70)
    MobileShootBtn.Position = UDim2.new(0.8, 0, 0.3, 0)
    MobileShootBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    MobileShootBtn.Text = "SHOOT"; MobileShootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileShootBtn.Font = Enum.Font.SourceSansBold; MobileShootBtn.TextSize = 15; MobileShootBtn.Parent = MainGui
    round(MobileShootBtn, 35)
    
    local mDrag, mStart, mBarStart
    MobileShootBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then mDrag = true mStart = i.Position mBarStart = MobileShootBtn.Position end end)
    MobileShootBtn.InputChanged:Connect(function(i) if mDrag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then local d = i.Position - mStart MobileShootBtn.Position = UDim2.new(mBarStart.X.Scale, mBarStart.X.Offset + d.X, mBarStart.Y.Scale, mBarStart.Y.Offset + d.Y) end end)
    MobileShootBtn.InputEnded:Connect(function() mDrag = false end)
    MobileShootBtn.MouseButton1Click:Connect(fireAtMurderer)

    createGroup(CombatPage, "ПОЛНОЕ АВТО-УБИЙСТВО (САМО)")

    addToggle(CombatPage, "Включить Мясорубку (Авто-Само)", function(v)
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
                        myHrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
                        task.wait(0.05)
                        knife:Activate()
                    end
                end
            end
        end
    end)

    createGroup(CombatPage, "УЛЬТРА ФЛИНГ СИСТЕМА")

    local function runGlitchFling(targetChar)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            -- Создаем мощный крутящий угловой момент, обходящий защиту
            local bAV = Instance.new("BodyAngularVelocity", hrp)
            bAV.MaxTorque = Vector3.new(999999, 999999, 999999)
            bAV.AngularVelocity = Vector3.new(999999, 999999, 999999)
            
            local oldN = noclip
            noclip = true
            
            local startT = tick()
            while tick() - startT < 0.8 and targetChar and targetChar:FindFirstChild("HumanoidRootPart") do
                RunService.Heartbeat:Wait()
                hrp.CFrame = targetChar.HumanoidRootPart.CFrame
            end
            
            bAV:Destroy()
            noclip = oldN
        end
    end

    addButton(CombatPage, "Флинг ВСЕХ", function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then runGlitchFling(p.Character) end
        end
    end)

    local TargetFlingBtn = addButton(CombatPage, "Выбрать цель флинга", function()
        local list = Players:GetPlayers()
        if #list <= 1 then return end
        flingIndex = flingIndex + 1 if flingIndex > #list then flingIndex = 1 end
        if list[flingIndex] == LocalPlayer then flingIndex = flingIndex + 1 end
        local t = list[flingIndex]
        if t then flingTarget = t.Name TargetFlingBtn.Text = "Цель: " .. t.DisplayName end
    end)

    addButton(CombatPage, "Запустить Флинг в цель", function()
        local tp = Players:FindFirstChild(flingTarget)
        if tp and tp.Character then runGlitchFling(tp.Character) else notify("Цель не найдена!") end
    end)

    ---------------------------------------------------------
    -- PLAYER (СКОРОСТЬ И ПОЛЕТ)
    ---------------------------------------------------------
    createGroup(PlayerPage, "Настройки Изменений")

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 45); SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50); SliderFrame.Parent = PlayerPage
    round(SliderFrame, 6)
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.4, 0, 1, 0); SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.Text = "Скорость бега: 16"; SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left; SliderLabel.BackgroundTransparency = 1; SliderLabel.Parent = SliderFrame
    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(0, 200, 0, 10); SliderBtn.Position = UDim2.new(1, -220, 0.5, -5)
    SliderBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 85); SliderBtn.Text = ""; SliderBtn.Parent = SliderFrame
    round(SliderBtn, 5)
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(0, 0, 1, 0); SliderBar.BackgroundColor3 = Color3.fromRGB(90, 120, 255); SliderBar.Parent = SliderBtn
    round(SliderBar, 5)

    local function updateSlider(input)
        local percentage = math.clamp((input.Position.X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1)
        SliderBar.Size = UDim2.new(percentage, 0, 1, 0)
        walkSpeedValue = math.floor(16 + (percentage * 120))
        SliderLabel.Text = "Скорость бега: " .. tostring(walkSpeedValue)
    end
    local sDrag = false
    SliderBtn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sDrag = true updateSlider(i) end end)
    UIS.InputChanged:Connect(function(i) if sDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i) end end)
    UIS.InputEnded:Connect(function() sDrag = false end)

    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
    end)

    addToggle(PlayerPage, "Включить Полет (Fly)", function(v)
        flyActive = v
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if flyActive then
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Name = "LemonFlyVelocity"
                while flyActive and hrp and bv.Parent do
                    RunService.Heartbeat:Wait()
                    bv.MaxForce = Vector3.new(99999, 99999, 99999)
                    local moveDir = Vector3.new(0,0,0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
                    bv.Velocity = moveDir * flySpeed
                end
            else
                if hrp:FindFirstChild("LemonFlyVelocity") then hrp.LemonFlyVelocity:Destroy() end
            end
        end
    end)

    addToggle(PlayerPage, "Проходить сквозь стены (NoClip)", function(v)
        noclip = v
        RunService.Stepped:Connect(function()
            if noclip and LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
            end
        end)
    end)

    ---------------------------------------------------------
    -- VISUAL (ПРАВИЛЬНЫЙ ИСПРАВЛЕННЫЙ ESP)
    ---------------------------------------------------------
    createGroup(VisualPage, "Оригинальный Силуэт ESP")
    
    addToggle(VisualPage, "Подсветка Игроков (Роли)", function(v)
        _G.HighlightESP = v
        while _G.HighlightESP do task.wait(1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                    local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                    local color = isM and Color3.fromRGB(255, 0, 0) or (isS and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(0, 255, 0))
                    
                    local hl = p.Character:FindFirstChild("LemonHighlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "LemonHighlight"
                        hl.Parent = p.Character
                    end
                    hl.FillColor = color; hl.OutlineColor = color
                    hl.FillTransparency = 0.4; hl.OutlineTransparency = 0
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
        while _G.GunESP do task.wait(1)
            local gun = findDroppedGun()
            if gun then
                local hl = gun:FindFirstChild("LemonGunHl")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "LemonGunHl"
                    hl.Parent = gun
                end
                hl.FillColor = Color3.fromRGB(0, 255, 255)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.2
            end
        end
        if not _G.GunESP then
            local gun = findDroppedGun()
            if gun and gun:FindFirstChild("LemonGunHl") then gun.LemonGunHl:Destroy() end
        end
    end)

    ---------------------------------------------------------
    -- TELEPORTS (ФИКС ПРОВАЛОВ)
    ---------------------------------------------------------
    createGroup(TeleportPage, "Безопасный Телепорт")
    
    local function secureTeleport(cf)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local oldN = noclip
            noclip = true
            hrp.CFrame = cf + Vector3.new(0, 12, 0) -- Приподнимаем игрока повыше над полом карт
            task.wait(0.3)
            noclip = oldN
        end
    end

    addButton(TeleportPage, "Телепорт в Лобби (На Спавн)", function() 
        secureTeleport(CFrame.new(-108, 140, 11)) 
    end)
    
    addButton(TeleportPage, "Телепорт на Карту (На Пол)", function()
        local targetMap = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map") or workspace:FindFirstChild("Innocent")
        if targetMap then 
            secureTeleport(targetMap:GetPivot()) 
        else 
            notify("Активная карта не найдена в игре!") 
        end
    end)

    ---------------------------------------------------------
    -- СЕТЕВОЙ ЧАТ
    ---------------------------------------------------------
    createGroup(ChatPage, "LemonHub Чат")
    local Scroller = Instance.new("ScrollingFrame")
    Scroller.Size = UDim2.new(1, -10, 0, 210); Scroller.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Scroller.CanvasSize = UDim2.new(0, 0, 0, 0); Scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y; Scroller.Parent = ChatPage
    round(Scroller, 6)
    local chatLayout = Instance.new("UIListLayout")
    chatLayout.Padding = UDim.new(0, 6); chatLayout.Parent = Scroller

    local InBox = Instance.new("TextBox")
    InBox.Size = UDim2.new(1, -90, 0, 35); InBox.Position = UDim2.new(0, 0, 0, 225)
    InBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45); InBox.PlaceholderText = "Текст сообщения..."; InBox.TextColor3 = Color3.fromRGB(255,255,255); InBox.Parent = ChatPage
    round(InBox, 6)

    local function addPremiumMessage(userId, name, text)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 40); row.BackgroundTransparency = 1; row.Parent = Scroller
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, 34, 0, 34); img.Position = UDim2.new(0, 3, 0, 3)
        img.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150"; img.Parent = row
        round(img, 17)
        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -45, 1, 0); content.Position = UDim2.new(0, 45, 0, 0)
        content.Text = " " .. name .. ": " .. text; content.TextColor3 = Color3.fromRGB(240, 240, 240)
        content.Font = Enum.Font.SourceSansBold; content.TextSize = 14; content.TextXAlignment = Enum.TextXAlignment.Left; content.BackgroundTransparency = 1; content.Parent = row
    end

    local Send = addButton(ChatPage, "Отправить", function()
        if InBox.Text ~= "" then
            local chatVal = ReplicatedStorage:FindFirstChild("LemonHubSignal") or Instance.new("StringValue", ReplicatedStorage)
            chatVal.Name = "LemonHubSignal"
            chatVal.Value = tostring(LocalPlayer.UserId) .. "::" .. LocalPlayer.Name .. "::" .. InBox.Text
            InBox.Text = ""
        end
    end)
    Send.Size = UDim2.new(0, 80, 0, 35); Send.Position = UDim2.new(1, -85, 0, 225); Send.Parent = ChatPage

    local sig = ReplicatedStorage:WaitForChild("LemonHubSignal", 2) or Instance.new("StringValue", ReplicatedStorage)
    sig.Name = "LemonHubSignal"
    sig.Changed:Connect(function(v)
        local d = string.split(v, "::")
        if #d >= 3 then addPremiumMessage(d[1], d[2], d[3]) end
    end)

    ---------------------------------------------------------
    -- АВТОРИЗАЦИЯ И ССЫЛКА НА КЛЮЧ
    ---------------------------------------------------------
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 320, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28); KeyFrame.Parent = MainGui
    round(KeyFrame, 10)

    local KTitle = Instance.new("TextLabel")
    KTitle.Size = UDim2.new(1, 0, 0, 35); KTitle.Text = "LEMONHUB V8.0 | Ключ"; KTitle.TextColor3 = Color3.fromRGB(255,255,255)
    KTitle.BackgroundTransparency = 1; KTitle.Font = Enum.Font.SourceSansBold; KTitle.Parent = KeyFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 260, 0, 40); InputBox.Position = UDim2.new(0.5, -130, 0.4, -15)
    InputBox.PlaceholderText = "Введите ключ доступа..."; InputBox.Text = ""; InputBox.TextColor3 = Color3.fromRGB(255, 255, 255); InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45); InputBox.Parent = KeyFrame
    round(InputBox, 6)

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 120, 0, 35); Submit.Position = UDim2.new(0.1, 0, 0.7, 5)
    Submit.Text = "Проверить"; Submit.BackgroundColor3 = Color3.fromRGB(90, 120, 255); Submit.TextColor3 = Color3.fromRGB(255, 255, 255); Submit.Parent = KeyFrame
    round(Submit, 6)

    local GetKey = Instance.new("TextButton")
    GetKey.Size = UDim2.new(0, 130, 0, 35); GetKey.Position = UDim2.new(0.52, 0, 0.7, 5)
    GetKey.Text = "Получить ссылку"; GetKey.BackgroundColor3 = Color3.fromRGB(55, 55, 60); GetKey.TextColor3 = Color3.fromRGB(220, 220, 220); GetKey.Parent = KeyFrame
    round(GetKey, 6)

    GetKey.MouseButton1Click:Connect(function()
        Clipboard("https://discord.gg/lemonhub-best-mm2")
        GetKey.Text = "Скопировано!"
        task.wait(1.5) GetKey.Text = "Получить ссылку"
    end)

    Submit.MouseButton1Click:Connect(function()
        if InputBox.Text == "ilovepigs" then KeyFrame:Destroy() MenuFrame.Visible = true else InputBox.Text = "" InputBox.PlaceholderText = "Неверный ключ!" end
    end)
end

pcall(safeLoad)
