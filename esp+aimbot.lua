local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local TextBox = Instance.new("TextBox", ScreenGui)

-- Настройки текстового поля для ввода ника
TextBox.Size = UDim2.new(0, 200, 0, 50)
TextBox.Position = UDim2.new(0.5, -100, 0.8, -25) -- Позиция в нижней части экрана
TextBox.PlaceholderText = "Ближайший игрок"
TextBox.TextScaled = true

local isAiming = false
local targetPlayer = nil
local camera = workspace.CurrentCamera

-- Функция для нахождения ближайшего игрока
local function findNearestPlayer()
    local nearestPlayer = nil
    local nearestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player
            end
        end
    end

    targetPlayer = nearestPlayer
end

-- Переключение нацеливания при нажатии на R
local function toggleAim()
    isAiming = not isAiming
    if isAiming then
        findNearestPlayer() -- Находим ближайшего игрока при включении нацеливания
        if targetPlayer then
            print("Нацеливание на ближайшего игрока: " .. targetPlayer.Name)
        else
            print("Ближайший игрок не найден.")
        end
    else
        print("Нацеливание выключено.")
    end
end

-- Обработка нажатия клавиш
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.R and not gameProcessed then
        toggleAim()
    end
end)

-- Каждое обновление кадра
RunService.RenderStepped:Connect(function()
    if isAiming and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local head = targetPlayer.Character.Head
        -- Обновляем направление камеры на голову ближайшего игрока
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
    end
end)

local Players = game:GetService("Players")

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Цвет маркера
    highlight.FillTransparency = 0.5 -- Прозрачность
    highlight.OutlineColor = Color3.fromRGB(0, 0, 0) -- Цвет обводки
end

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        player.CharacterAdded:Connect(function()
            createESP(player)
        end)
        if player.Character then
            createESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)
