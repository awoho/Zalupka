--[[
    DIMSTAT ULTIMATE REMOTE SCANNER v2.0
    Максимально полный инструмент для поиска и тестирования ремутов.
    Автор: @zazayaga
]]

-- ========================== СЕРВИСЫ ==========================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========================== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ==========================
local remotes = {}          -- таблица всех найденных ремутов
local remoteLog = {}        -- лог вызовов (для вкладки Hooks)
local hookEnabled = false   -- флаг перехвата (если поддерживается)
local spamRunning = false   -- флаг спам-кликера
local spamTasks = {}        -- задачи спама

-- ========================== УЯЗВИМОСТЬ CONSOLE ==========================
local function getConsoleEnv()
    local console = game:FindFirstChild("Config") and game.Config:FindFirstChild("Console")
    if console then
        return getfenv(console)
    end
    return nil
end

local function runInConsole(code)
    local env = getConsoleEnv()
    if env then
        local fn, err = loadstring(code)
        if fn then
            setfenv(fn, env)
            return fn()
        else
            warn("Console error: " .. tostring(err))
        end
    else
        warn("Console module not found")
    end
end

-- ========================== СКАНИРОВАНИЕ РЕМУТОВ ==========================
local function scanRemotes(container, path, output)
    output = output or {}
    path = path or "game"
    for _, child in ipairs(container:GetChildren()) do
        local fullPath = path .. "." .. child.Name
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("BindableEvent") or child:IsA("BindableFunction") then
            table.insert(output, {
                Instance = child,
                Path = fullPath,
                ClassName = child.ClassName,
                Name = child.Name
            })
        end
        if child:IsA("Folder") or child:IsA("Model") or child:IsA("ModuleScript") or child:IsA("LocalScript") or child:IsA("Script") then
            scanRemotes(child, fullPath, output)
        end
    end
    return output
end

-- Первичное сканирование
remotes = scanRemotes(game)

-- Отслеживание новых ремутов
local function watchForNewRemotes()
    game.DescendantAdded:Connect(function(instance)
        if instance:IsA("RemoteEvent") or instance:IsA("RemoteFunction") or instance:IsA("BindableEvent") or instance:IsA("BindableFunction") then
            local fullPath = instance:GetFullName()
            table.insert(remotes, {
                Instance = instance,
                Path = fullPath,
                ClassName = instance.ClassName,
                Name = instance.Name
            })
            -- Обновляем GUI, если он открыт
            if refreshRemoteList then
                refreshRemoteList()
            end
            warn("Новый ремут обнаружен: " .. fullPath)
        end
    end)
end
watchForNewRemotes()

-- ========================== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ==========================
-- Парсинг аргументов из строки
local function parseArgs(str)
    local args = {}
    if str and str ~= "" then
        for token in string.gmatch(str, "([^,]+)") do
            local trimmed = token:gsub("^%s*(.-)%s*$", "%1")
            if trimmed == "true" then args[#args+1] = true
            elseif trimmed == "false" then args[#args+1] = false
            elseif tonumber(trimmed) then args[#args+1] = tonumber(trimmed)
            else args[#args+1] = trimmed
            end
        end
    end
    return args
end

-- Вызов ремута с параметрами
local function callRemote(remote, args)
    local success, err = pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
            return "FireServer"
        elseif remote:IsA("RemoteFunction") then
            local result = remote:InvokeServer(unpack(args))
            return "InvokeServer -> " .. tostring(result)
        elseif remote:IsA("BindableEvent") then
            remote:Fire(unpack(args))
            return "Fire (Bindable)"
        elseif remote:IsA("BindableFunction") then
            local result = remote:Invoke(unpack(args))
            return "Invoke (Bindable) -> " .. tostring(result)
        end
    end)
    if not success then
        warn("Ошибка вызова: " .. tostring(err))
        return false, err
    end
    return true, success
end

-- ========================== СОЗДАНИЕ GUI ==========================
local function createGUI()
    local old = PlayerGui:FindFirstChild("UltimateRemoteScanner")
    if old then old:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltimateRemoteScanner"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Active = true
    mainFrame.Draggable = false
    mainFrame.ZIndex = 20
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame

    -- Заголовок
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
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔍 ULTIMATE REMOTE SCANNER"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.ZIndex = 30
    titleLabel.Parent = titleBar

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

    -- Вкладки
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 35)
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local tabs = {
        {name = "📡 Scanner", id = "scanner"},
        {name = "📋 Logs", id = "logs"},
        {name = "💻 Console", id = "console"},
        {name = "⚙️ Settings", id = "settings"}
    }
    local tabButtons = {}
    local tabPanels = {}

    for i, t in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
        btn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(70, 70, 100) or Color3.fromRGB(40, 40, 60)
        btn.Text = t.name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamMedium
        btn.AutoButtonColor = false
        btn.ZIndex = 25
        btn.Parent = tabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        tabButtons[i] = btn

        local panel = Instance.new("Frame")
        panel.Size = UDim2.new(1, -10, 1, -45)
        panel.Position = UDim2.new(0, 5, 0, 45)
        panel.BackgroundTransparency = 1
        panel.Visible = (i == 1)
        panel.Parent = mainFrame
        tabPanels[i] = panel
    end

    -- Переключение вкладок
    for i, btn in ipairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            for j, p in ipairs(tabPanels) do
                p.Visible = (j == i)
                tabButtons[j].BackgroundColor3 = (j == i) and Color3.fromRGB(70, 70, 100) or Color3.fromRGB(40, 40, 60)
            end
        end)
    end

    -- ============================================================
    -- ВКЛАДКА "SCANNER"
    -- ============================================================
    local scannerPanel = tabPanels[1]

    -- Поиск
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(0.9, 0, 0, 30)
    searchBox.Position = UDim2.new(0.05, 0, 0, 5)
    searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    searchBox.TextColor3 = Color3.new(1,1,1)
    searchBox.PlaceholderText = "Поиск по имени/пути..."
    searchBox.Text = ""
    searchBox.Font = Enum.Font.GothamMedium
    searchBox.TextScaled = true
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = scannerPanel
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 5)
    searchCorner.Parent = searchBox

    -- Список ремутов (ScrollingFrame)
    local remoteList = Instance.new("ScrollingFrame")
    remoteList.Size = UDim2.new(1, 0, 1, -45)
    remoteList.Position = UDim2.new(0, 0, 0, 40)
    remoteList.BackgroundTransparency = 1
    remoteList.BorderSizePixel = 0
    remoteList.ScrollingDirection = Enum.ScrollingDirection.Y
    remoteList.CanvasSize = UDim2.new(0, 0, 0, 0)
    remoteList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    remoteList.ZIndex = 20
    remoteList.Parent = scannerPanel

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = remoteList

    -- Функция обновления списка (будет вызываться при изменении фильтра или новых ремутах)
    local function refreshRemoteList(filter)
        filter = filter or ""
        filter = string.lower(filter)
        -- Очищаем список
        for _, child in ipairs(remoteList:GetChildren()) do
            if child ~= listLayout then child:Destroy() end
        end

        local count = 0
        for _, data in ipairs(remotes) do
            local path = data.Path
            local name = data.Name
            if filter == "" or string.find(string.lower(path), filter) or string.find(string.lower(name), filter) then
                count = count + 1
                -- Создаём кнопку для каждого ремута
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0.9, 0, 0, 35)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                btn.Text = path
                btn.TextColor3 = Color3.new(1,1,1)
                btn.TextScaled = true
                btn.Font = Enum.Font.GothamMedium
                btn.AutoButtonColor = false
                btn.ZIndex = 25
                btn.Parent = remoteList
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn

                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(80, 80, 120)}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 70)}):Play()
                end)

                -- При клике открываем диалог вызова
                btn.MouseButton1Click:Connect(function()
                    showCallDialog(data)
                end)

                -- Дополнительно: кнопка "Копировать путь"
                local copyBtn = Instance.new("TextButton")
                copyBtn.Size = UDim2.new(0.1, 0, 0, 25)
                copyBtn.Position = UDim2.new(0.9, 0, 0.05, 0)
                copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                copyBtn.Text = "📋"
                copyBtn.TextColor3 = Color3.new(1,1,1)
                copyBtn.TextScaled = true
                copyBtn.Font = Enum.Font.GothamMedium
                copyBtn.AutoButtonColor = false
                copyBtn.ZIndex = 30
                copyBtn.Parent = btn
                local copyCorner = Instance.new("UICorner")
                copyCorner.CornerRadius = UDim.new(0, 4)
                copyCorner.Parent = copyBtn

                copyBtn.MouseButton1Click:Connect(function()
                    setclipboard and setclipboard(path) or warn("Копирование в буфер не поддерживается")
                end)
            end
        end
        if count == 0 then
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.9, 0, 0, 30)
            label.BackgroundTransparency = 1
            label.Text = "Ремуты не найдены"
            label.TextColor3 = Color3.new(1,1,1)
            label.TextScaled = true
            label.Font = Enum.Font.GothamMedium
            label.Parent = remoteList
        end
    end

    -- Вызов диалога для ремута
    local function showCallDialog(data)
        local remote = data.Instance
        local path = data.Path

        local dialog = Instance.new("ScreenGui")
        dialog.Name = "RemoteDialog"
        dialog.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 350, 0, 200)
        frame.Position = UDim2.new(0.5, -175, 0.5, -100)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        frame.BackgroundTransparency = 0.1
        frame.ZIndex = 40
        frame.Parent = dialog
        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 10)
        dCorner.Parent = frame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = path
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.GothamMedium
        label.Parent = frame

        local argsBox = Instance.new("TextBox")
        argsBox.Size = UDim2.new(0.9, 0, 0, 35)
        argsBox.Position = UDim2.new(0.05, 0, 0, 40)
        argsBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
        argsBox.TextColor3 = Color3.new(1,1,1)
        argsBox.PlaceholderText = "Аргументы (через запятую)"
        argsBox.Text = ""
        argsBox.Font = Enum.Font.GothamMedium
        argsBox.TextScaled = true
        argsBox.Parent = frame
        local argsCorner = Instance.new("UICorner")
        argsCorner.CornerRadius = UDim.new(0, 5)
        argsCorner.Parent = argsBox

        local delayBox = Instance.new("TextBox")
        delayBox.Size = UDim2.new(0.4, 0, 0, 30)
        delayBox.Position = UDim2.new(0.05, 0, 0, 85)
        delayBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
        delayBox.TextColor3 = Color3.new(1,1,1)
        delayBox.PlaceholderText = "Задержка (сек)"
        delayBox.Text = "0.5"
        delayBox.Font = Enum.Font.GothamMedium
        delayBox.TextScaled = true
        delayBox.Parent = frame
        local delayCorner = Instance.new("UICorner")
        delayCorner.CornerRadius = UDim.new(0, 5)
        delayCorner.Parent = delayBox

        local countBox = Instance.new("TextBox")
        countBox.Size = UDim2.new(0.4, 0, 0, 30)
        countBox.Position = UDim2.new(0.55, 0, 0, 85)
        countBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
        countBox.TextColor3 = Color3.new(1,1,1)
        countBox.PlaceholderText = "Кол-во"
        countBox.Text = "1"
        countBox.Font = Enum.Font.GothamMedium
        countBox.TextScaled = true
        countBox.Parent = frame
        local countCorner = Instance.new("UICorner")
        countCorner.CornerRadius = UDim.new(0, 5)
        countCorner.Parent = countBox

        local callBtn = Instance.new("TextButton")
        callBtn.Size = UDim2.new(0.4, 0, 0, 35)
        callBtn.Position = UDim2.new(0.05, 0, 0, 125)
        callBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        callBtn.Text = "Вызвать"
        callBtn.TextColor3 = Color3.new(1,1,1)
        callBtn.TextScaled = true
        callBtn.Font = Enum.Font.GothamBold
        callBtn.AutoButtonColor = false
        callBtn.Parent = frame
        local callCorner = Instance.new("UICorner")
        callCorner.CornerRadius = UDim.new(0, 5)
        callCorner.Parent = callBtn

        local spamBtn = Instance.new("TextButton")
        spamBtn.Size = UDim2.new(0.4, 0, 0, 35)
        spamBtn.Position = UDim2.new(0.55, 0, 0, 125)
        spamBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 40)
        spamBtn.Text = "Спам"
        spamBtn.TextColor3 = Color3.new(1,1,1)
        spamBtn.TextScaled = true
        spamBtn.Font = Enum.Font.GothamBold
        spamBtn.AutoButtonColor = false
        spamBtn.Parent = frame
        local spamCorner = Instance.new("UICorner")
        spamCorner.CornerRadius = UDim.new(0, 5)
        spamCorner.Parent = spamBtn

        local closeDialog = Instance.new("TextButton")
        closeDialog.Size = UDim2.new(0.2, 0, 0, 30)
        closeDialog.Position = UDim2.new(0.75, 0, 0, 165)
        closeDialog.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        closeDialog.Text = "Закрыть"
        closeDialog.TextColor3 = Color3.new(1,1,1)
        closeDialog.TextScaled = true
        closeDialog.Font = Enum.Font.GothamBold
        closeDialog.AutoButtonColor = false
        closeDialog.Parent = frame
        local closCorner = Instance.new("UICorner")
        closCorner.CornerRadius = UDim.new(0, 5)
        closCorner.Parent = closeDialog

        -- Вызов (один раз)
        callBtn.MouseButton1Click:Connect(function()
            local args = parseArgs(argsBox.Text)
            local success, result = callRemote(remote, args)
            if success then
                warn("Вызов успешен: " .. tostring(result))
            else
                warn("Ошибка вызова: " .. tostring(result))
            end
        end)

        -- Спам-кликер
        spamBtn.MouseButton1Click:Connect(function()
            local args = parseArgs(argsBox.Text)
            local delay = tonumber(delayBox.Text) or 0.5
            local count = tonumber(countBox.Text) or 1
            if count < 1 then count = 1 end

            local taskId = HttpService:GenerateGUID(false)
            spamTasks[taskId] = true
            task.spawn(function()
                for i = 1, count do
                    if not spamTasks[taskId] then break end
                    local success, result = callRemote(remote, args)
                    if not success then
                        warn("Спам прерван: " .. tostring(result))
                        break
                    end
                    if i < count then
                        wait(delay)
                    end
                end
                spamTasks[taskId] = nil
            end)
            warn("Спам запущен (ID: " .. taskId .. ")")
        end)

        closeDialog.MouseButton1Click:Connect(function()
            dialog:Destroy()
        end)
    end

    -- Функция обновления списка с фильтром
    local currentFilter = ""
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        currentFilter = searchBox.Text
        refreshRemoteList(currentFilter)
    end)

    -- Первоначальное заполнение
    refreshRemoteList()

    -- Сделаем refreshRemoteList глобальной для обновления при новых ремутах
    _G.refreshRemoteList = refreshRemoteList

    -- ============================================================
    -- ВКЛАДКА "LOGS"
    -- ============================================================
    local logsPanel = tabPanels[2]

    local logFrame = Instance.new("ScrollingFrame")
    logFrame.Size = UDim2.new(1, 0, 1, -40)
    logFrame.Position = UDim2.new(0, 0, 0, 5)
    logFrame.BackgroundTransparency = 1
    logFrame.BorderSizePixel = 0
    logFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    logFrame.Parent = logsPanel

    local logLayout = Instance.new("UIListLayout")
    logLayout.FillDirection = Enum.FillDirection.Vertical
    logLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    logLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    logLayout.Padding = UDim.new(0, 2)
    logLayout.Parent = logFrame

    local function addLogEntry(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = logFrame
        -- Автоскролл вниз
        task.wait(0.05)
        logFrame.CanvasPosition = Vector2.new(0, logFrame.CanvasSize.Y.Offset)
    end

    -- Кнопка очистки логов
    local clearLogsBtn = Instance.new("TextButton")
    clearLogsBtn.Size = UDim2.new(0.3, 0, 0, 30)
    clearLogsBtn.Position = UDim2.new(0.35, 0, 0, 0)
    clearLogsBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    clearLogsBtn.Text = "Очистить логи"
    clearLogsBtn.TextColor3 = Color3.new(1,1,1)
    clearLogsBtn.TextScaled = true
    clearLogsBtn.Font = Enum.Font.GothamBold
    clearLogsBtn.AutoButtonColor = false
    clearLogsBtn.Parent = logsPanel
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 5)
    clearCorner.Parent = clearLogsBtn

    clearLogsBtn.MouseButton1Click:Connect(function()
        for _, child in ipairs(logFrame:GetChildren()) do
            if child ~= logLayout then child:Destroy() end
        end
        remoteLog = {}
    end)

    -- ============================================================
    -- ВКЛАДКА "CONSOLE"
    -- ============================================================
    local consolePanel = tabPanels[3]

    local codeBox = Instance.new("TextBox")
    codeBox.Size = UDim2.new(0.9, 0, 0, 100)
    codeBox.Position = UDim2.new(0.05, 0, 0, 10)
    codeBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    codeBox.TextColor3 = Color3.new(1,1,1)
    codeBox.PlaceholderText = "Введите Lua-код для выполнения (клиент)"
    codeBox.Text = ""
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 12
    codeBox.MultiLine = true
    codeBox.ClearTextOnFocus = false
    codeBox.Parent = consolePanel
    local codeCorner = Instance.new("UICorner")
    codeCorner.CornerRadius = UDim.new(0, 5)
    codeCorner.Parent = codeBox

    local execBtn = Instance.new("TextButton")
    execBtn.Size = UDim2.new(0.4, 0, 0, 35)
    execBtn.Position = UDim2.new(0.05, 0, 0, 120)
    execBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    execBtn.Text = "Выполнить"
    execBtn.TextColor3 = Color3.new(1,1,1)
    execBtn.TextScaled = true
    execBtn.Font = Enum.Font.GothamBold
    execBtn.AutoButtonColor = false
    execBtn.Parent = consolePanel
    local execCorner = Instance.new("UICorner")
    execCorner.CornerRadius = UDim.new(0, 5)
    execCorner.Parent = execBtn

    local consoleOutput = Instance.new("ScrollingFrame")
    consoleOutput.Size = UDim2.new(0.9, 0, 0, 100)
    consoleOutput.Position = UDim2.new(0.05, 0, 0, 165)
    consoleOutput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    consoleOutput.BorderSizePixel = 0
    consoleOutput.ScrollingDirection = Enum.ScrollingDirection.Y
    consoleOutput.CanvasSize = UDim2.new(0, 0, 0, 0)
    consoleOutput.AutomaticCanvasSize = Enum.AutomaticSize.Y
    consoleOutput.Parent = consolePanel
    local outCorner = Instance.new("UICorner")
    outCorner.CornerRadius = UDim.new(0, 5)
    outCorner.Parent = consoleOutput

    local outLayout = Instance.new("UIListLayout")
    outLayout.FillDirection = Enum.FillDirection.Vertical
    outLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    outLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    outLayout.Padding = UDim.new(0, 2)
    outLayout.Parent = consoleOutput

    local function addConsoleOutput(text, isError)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(150, 255, 150)
        label.TextScaled = true
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = consoleOutput
        task.wait(0.05)
        consoleOutput.CanvasPosition = Vector2.new(0, consoleOutput.CanvasSize.Y.Offset)
    end

    execBtn.MouseButton1Click:Connect(function()
        local code = codeBox.Text
        if code == "" then
            addConsoleOutput("Код пуст", true)
            return
        end
        local success, result = pcall(function()
            return runInConsole(code) or loadstring(code)() -- пробуем через консоль, если нет, то просто loadstring
        end)
        if success then
            addConsoleOutput("✅ Выполнено: " .. tostring(result))
        else
            addConsoleOutput("❌ Ошибка: " .. tostring(result), true)
        end
    end)

    -- ============================================================
    -- ВКЛАДКА "SETTINGS"
    -- ============================================================
    local settingsPanel = tabPanels[4]

    -- Настройки: автоматическое логирование вызовов (только ручных)
    local logToggle = Instance.new("TextButton")
    logToggle.Size = UDim2.new(0.8, 0, 0, 35)
    logToggle.Position = UDim2.new(0.1, 0, 0, 10)
    logToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    logToggle.Text = "Логировать вызовы: ВКЛ"
    logToggle.TextColor3 = Color3.new(1,1,1)
    logToggle.TextScaled = true
    logToggle.Font = Enum.Font.GothamBold
    logToggle.AutoButtonColor = false
    logToggle.Parent = settingsPanel
    local logCorner = Instance.new("UICorner")
    logCorner.CornerRadius = UDim.new(0, 5)
    logCorner.Parent = logToggle

    local logEnabled = true
    logToggle.MouseButton1Click:Connect(function()
        logEnabled = not logEnabled
        logToggle.Text = logEnabled and "Логировать вызовы: ВКЛ" or "Логировать вызовы: ВЫКЛ"
        logToggle.BackgroundColor3 = logEnabled and Color3.fromRGB(60, 60, 80) or Color3.fromRGB(80, 40, 40)
    end)

    -- Кнопка "Экспорт списка ремутов"
    local exportBtn = Instance.new("TextButton")
    exportBtn.Size = UDim2.new(0.8, 0, 0, 35)
    exportBtn.Position = UDim2.new(0.1, 0, 0, 55)
    exportBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 180)
    exportBtn.Text = "Экспортировать список ремутов"
    exportBtn.TextColor3 = Color3.new(1,1,1)
    exportBtn.TextScaled = true
    exportBtn.Font = Enum.Font.GothamBold
    exportBtn.AutoButtonColor = false
    exportBtn.Parent = settingsPanel
    local exportCorner = Instance.new("UICorner")
    exportCorner.CornerRadius = UDim.new(0, 5)
    exportCorner.Parent = exportBtn

    exportBtn.MouseButton1Click:Connect(function()
        local text = "Список ремутов:\n"
        for i, data in ipairs(remotes) do
            text = text .. i .. ". " .. data.Path .. " (" .. data.ClassName .. ")\n"
        end
        print(text)
        if setclipboard then
            setclipboard(text)
            addConsoleOutput("✅ Список скопирован в буфер обмена")
        else
            addConsoleOutput("⚠️ Копирование в буфер не поддерживается, вывод в консоль")
        end
    end)

    -- Кнопка "Очистить список ремутов" (пересканировать)
    local rescanBtn = Instance.new("TextButton")
    rescanBtn.Size = UDim2.new(0.8, 0, 0, 35)
    rescanBtn.Position = UDim2.new(0.1, 0, 0, 100)
    rescanBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 40)
    rescanBtn.Text = "Пересканировать ремуты"
    rescanBtn.TextColor3 = Color3.new(1,1,1)
    rescanBtn.TextScaled = true
    rescanBtn.Font = Enum.Font.GothamBold
    rescanBtn.AutoButtonColor = false
    rescanBtn.Parent = settingsPanel
    local rescanCorner = Instance.new("UICorner")
    rescanCorner.CornerRadius = UDim.new(0, 5)
    rescanCorner.Parent = rescanBtn

    rescanBtn.MouseButton1Click:Connect(function()
        remotes = scanRemotes(game)
        refreshRemoteList(currentFilter)
        addConsoleOutput("✅ Пересканирование завершено, найдено " .. #remotes .. " ремутов")
    end)

    -- ============================================================
    -- ПЕРЕТАСКИВАНИЕ
    -- ============================================================
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

    -- Сворачивание
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            mainFrame.Size = UDim2.new(0, 400, 0, 35)
            for i, panel in ipairs(tabPanels) do
                panel.Visible = false
            end
            minBtn.Text = "+"
        else
            mainFrame.Size = UDim2.new(0, 400, 0, 500)
            -- Показываем текущую вкладку
            for i, panel in ipairs(tabPanels) do
                panel.Visible = (i == 1) -- по умолчанию первая
            end
            minBtn.Text = "−"
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- ============================================================
    -- ДОПОЛНИТЕЛЬНО: Логирование вызовов (если включено)
    -- ============================================================
    -- Переопределим вызов через нашу функцию, чтобы логировать
    local originalCallRemote = callRemote
    callRemote = function(remote, args)
        local result = originalCallRemote(remote, args)
        if logEnabled then
            local msg = string.format("[%s] Вызов %s с аргументами: %s", os.date("%H:%M:%S"), remote:GetFullName(), table.concat(args, ", "))
            addLogEntry(msg)
            table.insert(remoteLog, msg)
        end
        return result
    end

    return screenGui
end

-- ========================== ЗАПУСК ==========================
local gui = createGUI()
print("✅ ULTIMATE REMOTE SCANNER запущен. Найдено ремутов: " .. #remotes)
print("✅ ULTIMATE REMOTE SCANNER запущен. Найдено ремутов: " .. #remotes)
