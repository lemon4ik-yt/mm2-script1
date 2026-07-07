-- УНИВЕРСАЛЬНАЯ ВЕРСИЯ (КЛЮЧ + МЕНЮ)
local Clipboard = setclipboard or toclipboard or function() end
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Функция запуска основного меню (срабатывает после верного ключа)
function startMainMenu()
    local success, err = pcall(function()
        local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
        local Window = OrionLib:MakeWindow({
            Name = "MM2 Кастомный Скрипт", 
            HidePremium = false, 
            SaveConfig = true, 
            ConfigFolder = "MM2Config"
        })

        local OrionGui = game:GetService("CoreGui"):FindFirstChild("Orion") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Orion")
        local MainOrionFrame = OrionGui and OrionGui:FindFirstChild("Main")

        -- КНОПКА СВЕРНУТЬ / РАЗВЕРНУТЬ
        local ToggleGui = Instance.new("ScreenGui")
        local ToggleBtn = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")

        ToggleGui.Name = "MM2ToggleGui"
        ToggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        ToggleGui.DisplayOrder = 999

        ToggleBtn.Size = UDim2.new(0, 140, 0, 30)
        ToggleBtn.Position = UDim2.new(0.5, -70, 0, 10)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleBtn.Text = "Прикрыть меню"
        ToggleBtn.Font = Enum.Font.SourceSansBold
        ToggleBtn.TextSize = 14
        ToggleBtn.Parent = ToggleGui

        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = ToggleBtn

        local menuVisible = true
        ToggleBtn.MouseButton1Click:Connect(function()
            if MainOrionFrame then
                menuVisible = not menuVisible
                MainOrionFrame.Visible = menuVisible
                ToggleBtn.Text = menuVisible and "Прикрыть меню" or "Открыть меню"
                ToggleBtn.BackgroundColor3 = menuVisible and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(0, 150, 0)
            end
        end)

        -- ФУНКЦИОНАЛ MM2
        local MainTab = Window:MakeTab({Name = "Главная", Icon = "rbxassetid://4483345998", PremiumOnly = false})
        local PlayerTab = Window:MakeTab({Name = "Игрок", Icon = "rbxassetid://4483345998", PremiumOnly = false})

        PlayerTab:AddSlider({
            Name = "Скорость", Min = 16, Max = 150, Default = 16, Color = Color3.fromRGB(255,255,255), Increment = 1,
            Callback = function(Value) pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = Value end) end    
        })

        PlayerTab:AddSlider({
            Name = "Прыжок", Min = 50, Max = 300, Default = 50, Color = Color3.fromRGB(255,255,255), Increment = 1,
            Callback = function(Value) pcall(function() LocalPlayer.Character.Humanoid.JumpPower = Value end) end    
        })

        local NoclipLoop
        PlayerTab:AddToggle({
            Name = "Noclip (Свозь стены)", Default = false,
            Callback = function(Value)
                if Value then
                    NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
                        pcall(function()
                            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
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
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local isMurder = p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")
                            local isSheriff = p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")
                            local color = isMurder and Color3.fromRGB(255,0,0) or (isSheriff and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
                            
                            if not p.Character:FindFirstChild("ESP_Highlight") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "ESP_Highlight"
                                hl.FillColor = color
                                hl.FillTransparency = 0.5
                                hl.Parent = p.Character
                            else
                                p.Character.ESP_Highlight.FillColor = color
                            end
                        end
                    end
                end
            end
        })

        MainTab:AddButton({
            Name = "Забрать пистолет",
            Callback = function()
                local gun = game.Workspace:FindFirstChild("GunDrop")
                if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame
                end
            end
        })

        OrionLib:Init()
    end)
    if not success then
        warn("Ошибка загрузки меню: " .. tostring(err))
    end
end

-- СОЗДАНИЕ ИНТЕРФЕЙСА КЛЮЧА В PLAYERGUI (РАБОТАЕТ СЕЙЧАС ВЕЗДЕ)
local KeyAuth = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local SubmitBtn = Instance.new("TextButton")
local SubmitCorner = Instance.new("UICorner")
local GetKeyBtn = Instance.new("TextButton")
local GetKeyCorner = Instance.new("UICorner")

KeyAuth.Name = "KeySystemMM2"
-- Закидываем в PlayerGui вместо CoreGui
KeyAuth.Parent = LocalPlayer:WaitForChild("PlayerGui")
KeyAuth.ResetOnSpawn = false

MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 320, 0, 200)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Parent = KeyAuth

FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

TextBox.Size = UDim2.new(0, 260, 0, 40)
TextBox.Position = UDim2.new(0.5, -130, 0.35, -20)
TextBox.PlaceholderText = "Введите ключ здесь..."
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(0,0,0)
TextBox.BackgroundColor3 = Color3.fromRGB(240,240,240)
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 16
TextBox.Parent = MainFrame

local TextCorner = Instance.new("UICorner")
TextCorner.CornerRadius = UDim.new(0, 6)
TextCorner.Parent = TextBox

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
