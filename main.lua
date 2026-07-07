-- LEMONHUB V6 | THE FINAL REBOOT
local function safeLoad()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")
    
    if not LocalPlayer then return end
    
    local StarterGui = game:GetService("StarterGui")
    local function notify(text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "LEMONHUB V6",
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

    -- Глобальные переменные состояний
    local noclip = false
    local autoKillActive = false
    local fpsBoostActive = false
    local originalMaterials = {}
    local savedLocation = nil
    local flingActive = false

    ---------------------------------------------------------
    -- ИНТЕРФЕЙС И МЕНЮ
    ---------------------------------------------------------
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0, 580, 0, 440)
    MenuFrame.Position = UDim2.new(0.5, -290, 0.5, -220)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
    MenuFrame.Visible = false
    MenuFrame.Parent = MainGui
    round(MenuFrame, 10)

    -- Перетаскивание меню
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

    -- Шапка
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Header.Parent = MenuFrame
    round(Header, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Text = "LEMONHUB V6 | Premium"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1; Title.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 25)
    CloseBtn.Position = UDim2.new(1, -40, 0.5, -12.5)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CloseBtn.TextSize = 20; CloseBtn.Parent = Header
    round(CloseBtn, 5)
    CloseBtn.MouseButton1Click:Connect(function() MainGui:Destroy() end)

    local OpenPlacard = Instance.new("TextButton")
    OpenPlacard.Size = UDim2.new(0, 140, 0, 35)
    OpenPlacard.Position = UDim2.new(0.5, -70, 0, 15)
    OpenPlacard.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    OpenPlacard.Text = "Открыть LEMONHUB"
    OpenPlacard.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenPlacard.Font = Enum.Font.SourceSansBold; OpenPlacard.TextSize = 14
    OpenPlacard.Visible = false; OpenPlacard.Parent = MainGui
    round(OpenPlacard, 8)
    OpenPlacard.MouseButton1Click:Connect(function() MenuFrame.Visible = true OpenPlacard.Visible = false end)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 25)
    MinimizeBtn.Position = UDim2.new(1, -75, 0.5, -12.5)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(220, 160, 40)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); MinimizeBtn.TextSize = 20; MinimizeBtn.Parent = Header
    round(MinimizeBtn, 5)
    MinimizeBtn.MouseButton1Click:Connect(function() MenuFrame.Visible = false OpenPlacard.Visible = true end)

    -- Контейнер вкладок
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -20, 0, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundTransparency = 1; TabContainer.Parent = MenuFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -115)
    ContentFrame.Position = UDim2.new(0, 10, 0, 105)
    ContentFrame.BackgroundTransparency = 1; ContentFrame.Parent = MenuFrame

    local Tabs, Pages = {}, {}
    local function createTab(name, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 95, 1, 0)
        btn.Position = UDim2.new(0, (order-1) * 100, 0, 0)
        btn.BackgroundColor3 = order == 1 and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(45, 45, 50)
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
            for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
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

    -- Вспомогательные элементы UI
    local function createGroup(parent, title)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 25); frame.BackgroundTransparency = 1; frame.Parent = parent
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0); label.Text = "— " .. title .. " —"
        label.TextColor3 = Color3.fromRGB(140, 140, 150); label.Font = Enum.Font.SourceSansBold
        label.TextSize = 13; label.BackgroundTransparency = 1; label.Parent = frame
    end

    local function addButton(parent, text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
        btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 15; btn.Parent = parent
        round(btn, 6)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function addToggle(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 42); frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45); frame.Parent = parent
        round(frame, 6)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0, 10, 0, 0)
        label.Text = text; label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.SourceSans; label.TextSize = 15; label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1; label.Parent = frame
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 40, 0, 20); btn.Position = UDim2.new(1, -50, 0.5, -10)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 75); btn.Text = ""; btn.Parent = frame
        round(btn, 10)
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 16, 0, 16); circle.Position = UDim2.new(0, 2, 0.5, -8)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); circle.Parent = btn
        round(circle, 8)
        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.1), {Position = UDim2.new(0, enabled and 22 or 2, 0.5, -8)}):Play()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = enabled and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(70, 70, 75)}):Play()
            task.spawn(callback, enabled)
        end)
    end

    ---------------------------------------------------------
    -- ЛОГИКА ПОИСКА МАРДЕРА И ПИСТОЛЕТА
    ---------------------------------------------------------
    local function getMurderer()
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
                return p
            end
        end
        return nil
    end

    local function findDroppedGun()
        local drop = workspace:FindFirstChild("GunDrop")
        if drop and drop:IsA("BasePart") then return drop end
        return nil
    end

    ---------------------------------------------------------
    -- ВКЛАДКА COMBAT
    ---------------------------------------------------------
    createGroup(CombatPage, "Функции Пистолета")

    local function grabGunLogic()
        local gun = findDroppedGun()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if gun and hrp then
            savedLocation = hrp.CFrame -- Сохраняем позицию
            local targetPos = gun.CFrame + Vector3.new(0, 2, 0)
            
            -- Быстрый телепорт на пест и возврат
            for i = 1, 5 do
                hrp.CFrame = targetPos
                task.wait(0.05)
            end
            task.wait(0.1)
            if savedLocation then hrp.CFrame = savedLocation end
        end
    end

    addButton(CombatPage, "Забрать Пистолет (С возвратом)", grabGunLogic)

    addToggle(CombatPage, "Авто-подбор пистолета", function(v)
        _G.AutoGrab = v
        while _G.AutoGrab do
            task.wait(0.3)
            if findDroppedGun() then grabGunLogic() end
        end
    end)

    createGroup(CombatPage, "Уничтожение игроков")

    local function stab(target)
        local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if knife and hrp and target and target:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.Humanoid:EquipTool(knife)
            hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
            knife:Activate()
        end
    end

    addToggle(CombatPage, "Авто-Убийство Всех (По кнопке)", function(v)
        autoKillActive = v
        while autoKillActive do
            local knife = LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")
            if knife then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        if not autoKillActive then break end
                        stab(p.Character)
                        task.wait(0.05)
                    end
                end
            else
                notify("Вы должны взять нож в руки или быть Мардером!")
                task.wait(2)
            end
            task.wait(0.1)
        end
    end)

    -- Авто-Стрельба (Shoot)
    local function performShoot()
        local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
        local m = getMurderer()
        if gun and m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.Humanoid:EquipTool(gun)
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, m.Character.HumanoidRootPart.Position)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(m.Character.HumanoidRootPart.Position.X, LocalPlayer.Character.HumanoidRootPart.Position.Y, m.Character.HumanoidRootPart.Position.Z))
            task.wait(0.05)
            gun:Activate()
        else
            notify("Вы не Шериф или Мардер не найден!")
        end
    end

    addButton(CombatPage, "Выстрелить в Мардера [Бинды: E]", performShoot)
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.E then performShoot() end
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА PLAYER
    ---------------------------------------------------------
    createGroup(PlayerPage, "Утилиты")

    addToggle(PlayerPage, "NoClip (Сквозь стены)", function(v)
        noclip = v
        RunService.Stepped:Connect(function()
            if noclip and LocalPlayer.Character then
                for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end)

    -- Смертоносный Флинг (Fling)
    addToggle(PlayerPage, "Активировать Флинг", function(v)
        flingActive = v
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if flingActive then
                local bg = Instance.new("BodyAngularVelocity", hrp)
                bg.Name = "LemonFling"
                bg.AngularVelocity = Vector3.new(0, 99999, 0)
                bg.MaxTorque = Vector3.new(0, 99999, 0)
            else
                if hrp:FindFirstChild("LemonFling") then hrp.LemonFling:Destroy() end
            end
        end
    end)

    -- Стабильный Автофарм Монет
    addToggle(PlayerPage, "Автофарм Монет (Безопасный)", function(v)
        _G.CoinFarm = v
        while _G.CoinFarm do
            task.wait(0.3)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("TouchInterest") and obj.Parent and string.find(string.lower(obj.Parent.Name), "coin") then
                        hrp.CFrame = obj.Parent.CFrame
                        task.wait(0.1)
                    end
                end
            end
        end
    end)

    -- FPS Boost (Вкл/Выкл)
    addToggle(PlayerPage, "FPS Буст (Сжатие графики)", function(v)
        fpsBoostActive = v
        if fpsBoostActive then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsA("Terrain") then
                    originalMaterials[obj] = {mat = obj.Material, col = obj.Color}
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
            Lighting.GlobalShadows = false
        else
            for obj, data in pairs(originalMaterials) do
                if obj and obj.Parent then
                    obj.Material = data.mat
                end
            end
            Lighting.GlobalShadows = true
            table.clear(originalMaterials)
        end
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА VISUAL (ЧИСТЫЙ БЕЗОПАСНЫЙ ESP)
    ---------------------------------------------------------
    createGroup(VisualPage, "Визуалы")

    addToggle(VisualPage, "ESP Роли", function(v)
        _G.RoleESP = v
        while _G.RoleESP do task.wait(1)
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local isM = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                    local isS = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                    local color = isM and Color3.fromRGB(255,0,0) or (isS and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
                    
                    if not p.Character:FindFirstChild("LemonBox") then
                        local box = Instance.new("BoxHandleAdornment", p.Character)
                        box.Name = "LemonBox"
                        box.Size = Vector3.new(4, 6, 4)
                        box.AlwaysOnTop = true
                        box.ZIndex = 5
                        box.Color3 = color
                        box.Transparency = 0.6
                        box.Adornee = p.Character.HumanoidRootPart
                    else
                        p.Character.LemonBox.Color3 = color
                    end
                end
            end
        end
        if not _G.RoleESP then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("LemonBox") then p.Character.LemonBox:Destroy() end
            end
        end
    end)

    -- Исправленный ESP Пистолета (Локальные Adornment, никакого синего мира!)
    addToggle(VisualPage, "ESP Пистолета (Только деталь)", function(v)
        _G.GunESP = v
        while _G.GunESP do task.wait(0.5)
            local gun = findDroppedGun()
            if gun then
                if not gun:FindFirstChild("LocalGunAdorn") then
                    local adorn = Instance.new("BoxHandleAdornment", gun)
                    adorn.Name = "LocalGunAdorn"
                    adorn.Size = Vector3.new(2, 2, 2)
                    adorn.Color3 = Color3.fromRGB(0, 255, 255)
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 6
                    adorn.Transparency = 0.3
                    adorn.Adornee = gun
                end
            else
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name == "LocalGunAdorn" then obj:Destroy() end
                end
            end
        end
        if not _G.GunESP then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "LocalGunAdorn" then obj:Destroy() end
            end
        end
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА TELEPORTS (СТАБИЛЬНАЯ ГЕОМЕТРИЯ)
    ---------------------------------------------------------
    local function safeTeleport(cframe)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
            
            -- Проверяем наличие пола под целевой точкой
            local rayResult = workspace:Raycast(cframe.Position + Vector3.new(0, 20, 0), Vector3.new(0, -40, 0), raycastParams)
            local finalPos = cframe.Position + Vector3.new(0, 6, 0)
            
            if rayResult then
                finalPos = rayResult.Position + Vector3.new(0, 4, 0)
            end

            local oldNoclip = noclip
            noclip = true
            hrp.CFrame = CFrame.new(finalPos)
            task.wait(0.2)
            noclip = oldNoclip
        end
    end

    createGroup(TeleportPage, "Перемещение по карте")
    addButton(TeleportPage, "Телепорт в безопасное Лобби", function()
        safeTeleport(CFrame.new(-108, 138, 11))
    end)

    addButton(TeleportPage, "Телепорт на Карту (Точно на пол)", function()
        local map = workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map")
        if map then
            local spawnPart = map:FindFirstChildDescendant("Spawn") or map:FindFirstChildDescendant("CoinContainer")
            if spawnPart then safeTeleport(spawnPart.CFrame) else safeTeleport(map:GetPivot()) end
        else
            notify("Карта еще не загружена!")
        end
    end)

    ---------------------------------------------------------
    -- ВКЛАДКА HUB CHAT (ПРИВАТНЫЙ ЧАТ ЧИТЕРОВ С ОЧИСТКОЙ)
    ---------------------------------------------------------
    createGroup(ChatPage, "Чат пользователей LemonHub")
    
    local ChatScroller = Instance.new("ScrollingFrame")
    ChatScroller.Size = UDim2.new(1, -10, 0, 220)
    ChatScroller.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    ChatScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChatScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ChatScroller.Parent = ChatPage
    round(ChatScroller, 6)
    
    local chatLayout = Instance.new("UIListLayout")
    chatLayout.Padding = UDim.new(0, 4); chatLayout.Parent = ChatScroller

    local ChatInput = Instance.new("TextBox")
    ChatInput.Size = UDim2.new(1, -90, 0, 35)
    ChatInput.Position = UDim2.new(0, 0, 0, 230)
    ChatInput.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    ChatInput.PlaceholderText = "Напишите сообщение..."
    ChatInput.Text = ""; ChatInput.TextColor3 = Color3.fromRGB(255,255,255)
    ChatInput.Parent = ChatPage
    round(ChatInput, 6)

    local function addMessage(sender, text)
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -10, 0, 22)
        msgLabel.Text = "[" .. sender .. "]: " .. text
        msgLabel.TextColor3 = sender == LocalPlayer.Name and Color3.fromRGB(90, 120, 255) or Color3.fromRGB(240, 240, 240)
        msgLabel.Font = Enum.Font.SourceSans; msgLabel.TextSize = 14
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left; msgLabel.BackgroundTransparency = 1
        msgLabel.Parent = ChatScroller
    end

    local SendBtn = addButton(ChatPage, "Send", function()
        if ChatInput.Text ~= "" then
            -- Симуляция репликации между игроками через StringValue
            local secureTag = workspace:FindFirstChild("LemonChatSignal") or Instance.new("StringValue", workspace)
            secureTag.Name = "LemonChatSignal"
            secureTag.Value = LocalPlayer.Name .. "::" .. ChatInput.Text
            ChatInput.Text = ""
        end
    end)
    SendBtn.Size = UDim2.new(0, 75, 0, 35)
    SendBtn.Position = UDim2.new(1, -80, 0, 230)
    SendBtn.Parent = ChatPage

    -- Отслеживание сообщений из сети чита
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "LemonChatSignal" then
            child.Changed:Connect(function(val)
                local data = string.split(val, "::")
                if #data >= 2 then addMessage(data[1], data[2]) end
            end)
        end
    end)

    -- Авто-очистка чата каждые 24 часа (клиентское смещение)
    task.spawn(function()
        while true do
            task.wait(86400) -- Ровно 24 часа
            for _, child in pairs(ChatScroller:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
            addMessage("Система", "Чат автоматически очищен (цикл 24 часа).")
        end
    end)

    ---------------------------------------------------------
    -- ОКНО АВТОРИЗАЦИИ (КЛЮЧ)
    ---------------------------------------------------------
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 320, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    KeyFrame.Parent = MainGui
    round(KeyFrame, 10)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.Text = "LEMONHUB V6 | Ключ доступа"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.Font = Enum.Font.SourceSansBold; KeyTitle.TextSize = 16
    KeyTitle.BackgroundTransparency = 1; KeyTitle.Parent = KeyFrame

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 260, 0, 40)
    InputBox.Position = UDim2.new(0.5, -130, 0.4, -15)
    InputBox.PlaceholderText = "Вставьте ключ доступа..."
    InputBox.Text = ""; InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 40); InputBox.Parent = KeyFrame
    round(InputBox, 6)

    local Submit = Instance.new("TextButton")
    Submit.Size = UDim2.new(0, 120, 0, 35)
    Submit.Position = UDim2.new(0.1, 0, 0.7, 5)
    Submit.Text = "Проверить"
    Submit.BackgroundColor3 = Color3.fromRGB(90, 120, 255)
    Submit.TextColor3 = Color3.fromRGB(255, 255, 255); Submit.Parent = KeyFrame
    round(Submit, 6)

    local GetKey = Instance.new("TextButton")
    GetKey.Size = UDim2.new(0, 120, 0, 35)
    GetKey.Position = UDim2.new(0.53, 0, 0.7, 5)
    GetKey.Text = "Копировать ссылку"
    GetKey.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    GetKey.TextColor3 = Color3.fromRGB(200, 200, 200); GetKey.Parent = KeyFrame
    round(GetKey, 6)

    GetKey.MouseButton1Click:Connect(function()
        Clipboard("https://discord.gg/lemonhub-best-mm2")
        GetKey.Text = "Ссылка в буфере!"
        task.wait(1.5) GetKey.Text = "Копировать ссылку"
    end)

    Submit.MouseButton1Click:Connect(function()
        if InputBox.Text == "ilovepigs" then
            KeyFrame:Destroy()
            MenuFrame.Visible = true
            notify("Успешный вход! Меню открыто.")
        else
            InputBox.Text = ""
            InputBox.PlaceholderText = "Неверный ключ!"
        end
    end)
end

local success, err = pcall(safeLoad)
if not success then print("Ошибка инициализации хаба: ", err) end
