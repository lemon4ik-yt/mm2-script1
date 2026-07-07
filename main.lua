-- ОБЪЕДИНЕННЫЙ СКРИПТ MM2 (КЛЮЧ + МЕНЮ)
local Clipboard = setclipboard or toclipboard or function() end

-- ФУНКЦИЯ ОСНОВНОГО МЕНЮ (Сработает после ввода ключа)
function startMainMenu()
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
    local Window = OrionLib:MakeWindow({Name = "MM2 Кастомный Скрипт", HidePremium = false, SaveConfig = true, ConfigFolder = "MM2Config"})

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

-- СОЗДАНИЕ ИНТЕРФЕЙСА АВТОРИЗАЦИИ (КЛЮЧА)
local KeyAuth = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local SubmitBtn = Instance.new("TextButton")
local GetKeyBtn = Instance.new("TextButton")

KeyAuth.Name = "KeySystem"
KeyAuth.Parent = game:GetService("CoreGui")

MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Parent = KeyAuth

TextBox.Size = UDim2.new(0, 240, 0, 40)
TextBox.Position = UDim2.new(0.5, -120, 0.3, -20)
TextBox.PlaceholderText = "Введите ключ здесь..."
TextBox.Text = ""
TextBox.Parent = MainFrame

SubmitBtn.Size = UDim2.new(0, 110, 0, 40)
SubmitBtn.Position = UDim2.new(0.2, -10, 0.7, -20)
SubmitBtn.Text = "Submit"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Parent = MainFrame

GetKeyBtn.Size = UDim2.new(0, 110, 0, 40)
GetKeyBtn.Position = UDim2.new(0.8, -100, 0.7, -20)
GetKeyBtn.Text = "Получить ключ"
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyBtn.Parent = MainFrame

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
