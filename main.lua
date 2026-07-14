-- ================================================================
-- KingMiraiReborn v13 — MOBILE EDITION (FIXED)
-- GUI БОЛЬШЕ НЕ ЗАКРЫВАЕТСЯ ПРИ ОШИБКАХ
-- ================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- ================================================================
-- БЭКДОР (С ПРОВЕРКОЙ)
-- ================================================================

local BackdoorEvent = nil
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and (v.Name:match("SystemService_") or v.Name:match("Backdoor_") or v.Name:match("KingMirai_")) then
        BackdoorEvent = v
        break
    end
end

if not BackdoorEvent then
    BackdoorEvent = Instance.new("RemoteEvent")
    BackdoorEvent.Name = "SystemService_" .. HttpService:GenerateGUID(false):sub(1, 8)
    BackdoorEvent.Parent = ReplicatedStorage
end

-- ================================================================
-- ГЛОБАЛЬНЫЕ КОМАНДЫ (С ЗАЩИТОЙ ОТ ОШИБОК)
-- ================================================================

local function GlobalCommand(command, args)
    if not BackdoorEvent then
        warn("[KingMirai] Бэкдор не найден!")
        return false
    end
    local success, err = pcall(function()
        BackdoorEvent:FireServer(command, args or "")
    end)
    if not success then
        warn("[KingMirai] Ошибка выполнения команды: " .. tostring(err))
        return false
    end
    return true
end

local function GlobalExecute(code)
    if not BackdoorEvent then
        warn("[KingMirai] Бэкдор не найден!")
        return false
    end
    local success, err = pcall(function()
        BackdoorEvent:FireServer("execute", code)
    end)
    if not success then
        warn("[KingMirai] Ошибка выполнения кода: " .. tostring(err))
        return false
    end
    return true
end

local function GlobalBroadcast(message)
    if not BackdoorEvent then
        warn("[KingMirai] Бэкдор не найден!")
        return false
    end
    local success, err = pcall(function()
        BackdoorEvent:FireServer("broadcast", message)
    end)
    if not success then
        warn("[KingMirai] Ошибка отправки уведомления: " .. tostring(err))
        return false
    end
    return true
end

local function GlobalChat(message)
    if not BackdoorEvent then
        warn("[KingMirai] Бэкдор не найден!")
        return false
    end
    local success, err = pcall(function()
        BackdoorEvent:FireServer("chat", message)
    end)
    if not success then
        warn("[KingMirai] Ошибка отправки чата: " .. tostring(err))
        return false
    end
    return true
end

-- ================================================================
-- ЛОГИ
-- ================================================================

local Logs = {}
local LogLabel = nil

local function AddLog(text)
    local time = os.date("%H:%M:%S")
    table.insert(Logs, time .. " | " .. text)
    if #Logs > 50 then table.remove(Logs, 1) end
    if LogLabel then
        LogLabel.Text = table.concat(Logs, "\n")
        local scroll = LogLabel.Parent
        if scroll and scroll:IsA("ScrollingFrame") then
            scroll.CanvasPosition = Vector2.new(0, scroll.AbsoluteCanvasSize.Y)
        end
    end
end

AddLog("KingMirai v13 Mobile FIXED загружен")

-- ================================================================
-- GUI (ТОТ ЖЕ, НО С ЗАЩИТОЙ)
-- ================================================================

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KingMiraiMobile"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0.95, 0, 0.85, 0)
Main.Position = UDim2.new(0.025, 0, 0.075, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
Main.BackgroundTransparency = 0.1
Main.Draggable = false
Main.Visible = true
Main.ClipsDescendants = true
Instance.new("UICorner").Parent = Main

local MainTitle = Instance.new("TextLabel", Main)
MainTitle.Size = UDim2.new(0.6, 0, 0, 40)
MainTitle.Position = UDim2.new(0.05, 0, 0, 5)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "KingMirai Mobile (FIXED)"
MainTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
MainTitle.Font = Enum.Font.Code
MainTitle.TextSize = 18
MainTitle.TextXAlignment = Enum.TextXAlignment.Left

local MainClose = Instance.new("TextButton", Main)
MainClose.Size = UDim2.new(0, 50, 0, 40)
MainClose.Position = UDim2.new(1, -60, 0, 5)
MainClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
MainClose.Text = "X"
MainClose.TextColor3 = Color3.new(1, 1, 1)
MainClose.Font = Enum.Font.Code
MainClose.TextSize = 20
Instance.new("UICorner").Parent = MainClose
MainClose.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
    AddLog("GUI свёрнут")
end)

local OpenBtn = Instance.new("ImageButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 70, 0, 70)
OpenBtn.Position = UDim2.new(0, 10, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15, 20, 15)
OpenBtn.Image = "rbxassetid://99069516147091"
OpenBtn.Visible = false
OpenBtn.Draggable = true
Instance.new("UICorner").Parent = OpenBtn
local OpenText = Instance.new("TextLabel", OpenBtn)
OpenText.Size = UDim2.new(1, 0, 1, 0)
OpenText.BackgroundTransparency = 1
OpenText.Text = "卍"
OpenText.TextColor3 = Color3.fromRGB(0, 255, 100)
OpenText.TextSize = 50
OpenText.Font = Enum.Font.Code
OpenBtn.MouseButton1Click:Connect(function()
    OpenBtn.Visible = false
    Main.Visible = true
    AddLog("GUI открыт")
end)

-- ================================================================
-- НАВИГАЦИЯ
-- ================================================================

local function CreateNavButton(text, x, y, target)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.3, -5, 0.08, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
    btn.Text = text
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Font = Enum.Font.Code
    btn.TextSize = 16
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        local tabs = {
            PlayersTab, WorldTab, ExecTab, BroadcastTab, GuisTab,
            SettingsTab, LogTab, FunTab, ToolsTab, AdminTab,
            AntiTab, FlyTab, NoclipTab, GodmodeTab, SpeedTab
        }
        for _, t in ipairs(tabs) do
            t.Visible = false
        end
        Main.Visible = false
        target.Visible = true
        AddLog("Переход в " .. text)
    end)
    return btn
end

CreateNavButton("PLAYERS", 0.02, 0.12, PlayersTab)
CreateNavButton("WORLD", 0.35, 0.12, WorldTab)
CreateNavButton("EXEC", 0.68, 0.12, ExecTab)
CreateNavButton("BROADCAST", 0.02, 0.24, BroadcastTab)
CreateNavButton("GUIS", 0.35, 0.24, GuisTab)
CreateNavButton("SETTINGS", 0.68, 0.24, SettingsTab)
CreateNavButton("LOGS", 0.02, 0.36, LogTab)
CreateNavButton("FUN", 0.35, 0.36, FunTab)
CreateNavButton("TOOLS", 0.68, 0.36, ToolsTab)
CreateNavButton("ADMIN", 0.02, 0.48, AdminTab)
CreateNavButton("ANTI", 0.35, 0.48, AntiTab)
CreateNavButton("FLY", 0.68, 0.48, FlyTab)
CreateNavButton("NOCLIP", 0.02, 0.60, NoclipTab)
CreateNavButton("GODMODE", 0.35, 0.60, GodmodeTab)
CreateNavButton("SPEED", 0.68, 0.60, SpeedTab)

local CloseGUI = Instance.new("TextButton", Main)
CloseGUI.Size = UDim2.new(0.9, 0, 0.08, 0)
CloseGUI.Position = UDim2.new(0.05, 5, 0.75, 5)
CloseGUI.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseGUI.Text = "CLOSE GUI"
CloseGUI.TextColor3 = Color3.new(1, 1, 1)
CloseGUI.Font = Enum.Font.Code
CloseGUI.TextSize = 18
Instance.new("UICorner").Parent = CloseGUI
CloseGUI.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
    AddLog("GUI свёрнут")
end)

-- ================================================================
-- ВКЛАДКИ (СОЗДАНИЕ)
-- ================================================================

local function CreateTabFrame(title)
    local frame = Instance.new("Frame", ScreenGui)
    frame.Size = UDim2.new(0.95, 0, 0.85, 0)
    frame.Position = UDim2.new(0.025, 0, 0.075, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
    frame.BackgroundTransparency = 0.1
    frame.Draggable = false
    frame.Visible = false
    frame.ClipsDescendants = true
    Instance.new("UICorner").Parent = frame

    local t = Instance.new("TextLabel", frame)
    t.Size = UDim2.new(0.6, 0, 0, 35)
    t.Position = UDim2.new(0.05, 0, 0, 5)
    t.BackgroundTransparency = 1
    t.Text = "KingMirai Mobile // " .. title
    t.TextColor3 = Color3.fromRGB(255, 215, 0)
    t.Font = Enum.Font.Code
    t.TextSize = 16
    t.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("TextButton", frame)
    c.Size = UDim2.new(0, 50, 0, 40)
    c.Position = UDim2.new(1, -60, 0, 5)
    c.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    c.Text = "X"
    c.TextColor3 = Color3.new(1, 1, 1)
    c.Font = Enum.Font.Code
    c.TextSize = 18
    Instance.new("UICorner").Parent = c
    c.MouseButton1Click:Connect(function()
        frame.Visible = false
        Main.Visible = true
    end)

    return frame
end

local PlayersTab = CreateTabFrame("PLAYERS")
local WorldTab = CreateTabFrame("WORLD")
local ExecTab = CreateTabFrame("EXEC")
local BroadcastTab = CreateTabFrame("BROADCAST")
local GuisTab = CreateTabFrame("GUIS")
local SettingsTab = CreateTabFrame("SETTINGS")
local LogTab = CreateTabFrame("LOGS")
local FunTab = CreateTabFrame("FUN")
local ToolsTab = CreateTabFrame("TOOLS")
local AdminTab = CreateTabFrame("ADMIN")
local AntiTab = CreateTabFrame("ANTI")
local FlyTab = CreateTabFrame("FLY")
local NoclipTab = CreateTabFrame("NOCLIP")
local GodmodeTab = CreateTabFrame("GODMODE")
local SpeedTab = CreateTabFrame("SPEED")

-- ================================================================
-- PLAYERS TAB (С ЗАЩИТОЙ)
-- ================================================================

local PlayerList = Instance.new("ScrollingFrame", PlayersTab)
PlayerList.Size = UDim2.new(1, -20, 0.75, 0)
PlayerList.Position = UDim2.new(0, 10, 0, 50)
PlayerList.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
PlayerList.BackgroundTransparency = 0.5
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 6
Instance.new("UICorner").Parent = PlayerList

local function UpdatePlayerList()
    for _, c in pairs(PlayerList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local y = 0
    for _, p in pairs(Players:GetPlayers()) do
        local btn = Instance.new("TextButton", PlayerList)
        btn.Size = UDim2.new(1, -10, 0, 45)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = (p == Player) and Color3.fromRGB(0, 60, 0) or Color3.fromRGB(25, 35, 25)
        btn.Text = p.Name .. (p == Player and " (YOU)" or "")
        btn.TextColor3 = Color3.fromRGB(0, 255, 100)
        btn.Font = Enum.Font.Code
        btn.TextSize = 14
        Instance.new("UICorner").Parent = btn

        btn.MouseButton1Click:Connect(function()
            AddLog("Выбран игрок: " .. p.Name)
            local actions = {
                "Kill", "Teleport", "Bring", "God", "Speed",
                "Freeze", "Ban", "Explode", "Clone", "Remove",
                "Fly", "NoClip", "Invisible", "Fire", "Smoke"
            }
            local actionFrame = Instance.new("Frame", PlayersTab)
            actionFrame.Size = UDim2.new(1, -20, 0.2, 0)
            actionFrame.Position = UDim2.new(0, 10, 0.78, 5)
            actionFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
            actionFrame.BackgroundTransparency = 0.3
            Instance.new("UICorner").Parent = actionFrame

            local ay = 0
            for _, act in ipairs(actions) do
                local abtn = Instance.new("TextButton", actionFrame)
                abtn.Size = UDim2.new(0.18, -5, 0.4, -5)
                abtn.Position = UDim2.new((ay % 5) * 0.2, 5, math.floor(ay / 5) * 0.45, 5)
                abtn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
                abtn.Text = act
                abtn.TextColor3 = Color3.new(1, 1, 1)
                abtn.Font = Enum.Font.Code
                abtn.TextSize = 12
                Instance.new("UICorner").Parent = abtn

                abtn.MouseButton1Click:Connect(function()
                    AddLog("Действие " .. act .. " над " .. p.Name)
                    local code = string.format([[
                        local target = game.Players:FindFirstChild("%s")
                        if target and target.Character then
                            local hum = target.Character:FindFirstChild("Humanoid")
                            local root = target.Character:FindFirstChild("HumanoidRootPart")
                            if "%s" == "Kill" and hum then hum.Health = 0
                            elseif "%s" == "Teleport" and root then root.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            elseif "%s" == "Bring" and root then root.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            elseif "%s" == "God" and hum then hum.MaxHealth = math.huge hum.Health = math.huge
                            elseif "%s" == "Speed" and hum then hum.WalkSpeed = 100
                            elseif "%s" == "Freeze" and hum then hum.WalkSpeed = 0
                            elseif "%s" == "Ban" then target:Kick("Banned by KingMirai")
                            elseif "%s" == "Explode" and root then
                                local exp = Instance.new("Explosion")
                                exp.Position = root.Position
                                exp.BlastRadius = 30
                                exp.BlastPressure = 500000
                                exp.Parent = workspace
                            elseif "%s" == "Clone" and root then
                                local c = target.Character:Clone()
                                c.Parent = workspace
                                c:SetPrimaryPartCFrame(root.CFrame + Vector3.new(5,0,0))
                            elseif "%s" == "Remove" then target.Character:Destroy()
                            elseif "%s" == "Fly" and hum then hum.PlatformStand = true root.Velocity = Vector3.new(0,50,0)
                            elseif "%s" == "NoClip" and root then
                                for _, p in pairs(target.Character:GetDescendants()) do
                                    if p:IsA("BasePart") then p.CanCollide = false
                                    end
                                end
                            elseif "%s" == "Invisible" then
                                for _, p in pairs(target.Character:GetDescendants()) do
                                    if p:IsA("BasePart") then p.Transparency = 1
                                    end
                                end
                            elseif "%s" == "Fire" and root then
                                local fire = Instance.new("Fire", root)
                                fire.Size = 10
                            elseif "%s" == "Smoke" and root then
                                local smoke = Instance.new("Smoke", root)
                                smoke.RiseVelocity = 50
                                smoke.Opacity = 0.5
                            end
                        end
                    ]], p.Name, act, act, act, act, act, act, act, act, act, act, act, act, act, act, act)
                    GlobalExecute(code)
                    actionFrame:Destroy() -- удаляем только фрейм действий, вкладка остаётся открытой
                end)
                ay = ay + 1
            end
        end)
        y = y + 50
    end
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, y)
end

UpdatePlayerList()
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- ================================================================
-- WORLD TAB (С ЗАЩИТОЙ)
-- ================================================================

local function AddWorldButton(text, cmd, x, y, color)
    local btn = Instance.new("TextButton", WorldTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 15, 15)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Глобальная команда: " .. cmd)
        GlobalCommand(cmd, "")
    end)
end

AddWorldButton("NUKE", "nuke", 0.02, 0.02)
AddWorldButton("DESTROY", "destroy", 0.35, 0.02)
AddWorldButton("KICK ALL", "kickall", 0.68, 0.02)
AddWorldButton("GRAV 0", "gravity0", 0.02, 0.14)
AddWorldButton("GRAV 1000", "gravity1000", 0.35, 0.14)
AddWorldButton("DAY", "day", 0.68, 0.14)
AddWorldButton("NIGHT", "night", 0.02, 0.26)
AddWorldButton("FIRE", "fire", 0.35, 0.26)
AddWorldButton("REMOVE PARTS", "removeparts", 0.68, 0.26)
AddWorldButton("KILL ALL", "killall", 0.02, 0.38)
AddWorldButton("BAN ALL", "banall", 0.35, 0.38)
AddWorldButton("TP ALL", "tpall", 0.68, 0.38)
AddWorldButton("EXPLODE ALL", "explodeall", 0.02, 0.50)
AddWorldButton("FREEZE ALL", "freezeall", 0.35, 0.50)
AddWorldButton("UNFREEZE ALL", "unfreezeall", 0.68, 0.50)
AddWorldButton("GOD ALL", "godall", 0.02, 0.62)

-- ================================================================
-- EXEC TAB
-- ================================================================

local CodeBox = Instance.new("TextBox", ExecTab)
CodeBox.Size = UDim2.new(1, -20, 0.45, 0)
CodeBox.Position = UDim2.new(0, 10, 0, 50)
CodeBox.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
CodeBox.Text = "-- Paste any Lua code here --"
CodeBox.TextColor3 = Color3.fromRGB(200, 255, 200)
CodeBox.TextWrapped = true
CodeBox.MultiLine = true
CodeBox.ClearTextOnFocus = false
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 14
Instance.new("UICorner").Parent = CodeBox

local ExecBtn = Instance.new("TextButton", ExecTab)
ExecBtn.Size = UDim2.new(0.5, -10, 0.1, 0)
ExecBtn.Position = UDim2.new(0.25, 5, 0.55, 5)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
ExecBtn.Text = "EXECUTE (GLOBAL)"
ExecBtn.TextColor3 = Color3.new(0, 0, 0)
ExecBtn.Font = Enum.Font.Code
ExecBtn.TextSize = 18
Instance.new("UICorner").Parent = ExecBtn
ExecBtn.MouseButton1Click:Connect(function()
    AddLog("Выполнение кода на сервере")
    GlobalExecute(CodeBox.Text)
end)

-- ================================================================
-- BROADCAST TAB
-- ================================================================

local MsgBox = Instance.new("TextBox", BroadcastTab)
MsgBox.Size = UDim2.new(1, -20, 0.2, 0)
MsgBox.Position = UDim2.new(0, 10, 0, 50)
MsgBox.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
MsgBox.Text = "Type your message here..."
MsgBox.TextColor3 = Color3.fromRGB(0, 255, 100)
MsgBox.Font = Enum.Font.Code
MsgBox.TextSize = 16
MsgBox.ClearTextOnFocus = false
Instance.new("UICorner").Parent = MsgBox

local HintBtn = Instance.new("TextButton", BroadcastTab)
HintBtn.Size = UDim2.new(0.4, -10, 0.1, 0)
HintBtn.Position = UDim2.new(0.05, 5, 0.35, 5)
HintBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
HintBtn.Text = "HINT (POPUP)"
HintBtn.TextColor3 = Color3.new(0, 0, 0)
HintBtn.Font = Enum.Font.Code
HintBtn.TextSize = 16
Instance.new("UICorner").Parent = HintBtn
HintBtn.MouseButton1Click:Connect(function()
    AddLog("Отправка глобального уведомления: " .. MsgBox.Text)
    GlobalBroadcast(MsgBox.Text)
end)

local ChatBtn = Instance.new("TextButton", BroadcastTab)
ChatBtn.Size = UDim2.new(0.4, -10, 0.1, 0)
ChatBtn.Position = UDim2.new(0.55, 5, 0.35, 5)
ChatBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
ChatBtn.Text = "CHAT (GLOBAL)"
ChatBtn.TextColor3 = Color3.new(1, 1, 1)
ChatBtn.Font = Enum.Font.Code
ChatBtn.TextSize = 16
Instance.new("UICorner").Parent = ChatBtn
ChatBtn.MouseButton1Click:Connect(function()
    AddLog("Отправка в чат: " .. MsgBox.Text)
    GlobalChat(MsgBox.Text)
end)

-- ================================================================
-- GUIS TAB
-- ================================================================

local GScroll = Instance.new("ScrollingFrame", GuisTab)
GScroll.Size = UDim2.new(1, -20, 1, -60)
GScroll.Position = UDim2.new(0, 10, 0, 50)
GScroll.BackgroundTransparency = 1
GScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UIListLayout", GScroll).Padding = UDim.new(0, 5)

local function addGuiBtn(name, url)
    local btn = Instance.new("TextButton", GScroll)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
    btn.Text = name:upper()
    btn.TextColor3 = Color3.fromRGB(0, 255, 100)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Загрузка GUI: " .. name)
        GlobalExecute('loadstring(game:HttpGet("' .. url .. '"))()')
    end)
end

local GuiList = {
    {"RoXploit f3x", "https://rawscripts.net/raw/Universal-Script-RoXploit-Ported-By-x9d-f3x-122683"},
    {"k22lgui", "https://rawscripts.net/raw/Universal-Script-K22lgui-237529"},
    {"pixel gui", "https://rawscripts.net/raw/Universal-Script-pixel-f3x-gui-leaked-240610"},
    {"krnl1 gui", "https://rawscripts.net/raw/Universal-Script-Loophax-gui-237638"},
    {"TheHackLord", "https://rawscripts.net/raw/Universal-Script-MOST-OP-GUI-F3X-MOST-OP-GUI-HAS-FE-BYPASS-AND-BACKDOOR-167144"},
    {"star v1.0", "https://rawscripts.net/raw/Universal-Script-My-script-167061"},
    {"z000rz gui", "https://rawscripts.net/raw/Universal-Script-z000rzkidd-F3X-GUI-40-buttons-113528"},
    {"zibran gui", "https://rawscripts.net/raw/Universal-Script-zibranF3X-Gui-148771"},
    {"syphonx", "https://rawscripts.net/raw/Universal-Script-SyphonX-f3x-abuse-gui-156472"},
    {"c00lgui", "https://rawscripts.net/raw/Universal-Script-C00LGUI-F3X-PORT-MADE-BY-LOOPSKIDD-LEAKED-BY-PELUSIN-166496"},
    {"trafficconeHax", "https://rawscripts.net/raw/Universal-Script-TrafficConeHax-f3x-gui-reupload-135819"},
    {"d00mgui", "https://rawscripts.net/raw/Universal-Script-D00MKIDD-F3x-GUI-IS-BACK-143642"},
    {"mango gui", "https://rawscripts.net/raw/Universal-Script-Mangotrollfaceedit-F3X-gui-60940"},
    {"k00pgui v8", "https://rawscripts.net/raw/Universal-Script-k00pgui-v8-F3X-EDITON-52670"},
    {"bl1ss ultimate", "https://rawscripts.net/raw/Universal-Script-Reposted-Bliss-ultimate-f3x-gui-v5-87781"},
    {"rovan gui v3", "https://rawscripts.net/raw/Universal-Script-R0van-Gui-F3x-v3-110647"},
    {"redkidd gui", "https://rawscripts.net/raw/Universal-Script-REDKIDD-GUI-F3X-115010"},
    {"warmkidd gui", "https://rawscripts.net/raw/Universal-Script-warmkidd-gui-f3x-port-147385"},
    {"loopkidd gui", "https://rawscripts.net/raw/Universal-Script-loopkidd-gui-v4-f3x-122839"},
    {"Teamkevin gui", "https://rawscripts.net/raw/Universal-Script-TEAMKEVINX5HEB-F3X-GUI-V1-135072"},
}
for _, item in ipairs(GuiList) do
    addGuiBtn(item[1], item[2])
end

-- ================================================================
-- LOGS TAB
-- ================================================================

local LogFrame = Instance.new("ScrollingFrame", LogTab)
LogFrame.Size = UDim2.new(1, -20, 1, -60)
LogFrame.Position = UDim2.new(0, 10, 0, 50)
LogFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
LogFrame.BackgroundTransparency = 0.3
LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogFrame.ScrollBarThickness = 6
Instance.new("UICorner").Parent = LogFrame

LogLabel = Instance.new("TextLabel", LogFrame)
LogLabel.Size = UDim2.new(1, 0, 0, 0)
LogLabel.Position = UDim2.new(0, 0, 0, 0)
LogLabel.BackgroundTransparency = 1
LogLabel.Text = ""
LogLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
LogLabel.TextScaled = false
LogLabel.TextSize = 14
LogLabel.TextWrapped = true
LogLabel.Font = Enum.Font.Code

local function UpdateLogSize()
    if LogLabel then
        LogLabel.Size = UDim2.new(1, 0, 0, LogLabel.TextBounds.Y + 10)
        LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogLabel.TextBounds.Y + 10)
        LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)
    end
end

local oldAddLog = AddLog
AddLog = function(text)
    oldAddLog(text)
    task.wait()
    UpdateLogSize()
end

-- ================================================================
-- FUN TAB
-- ================================================================

local function AddFunButton(text, cmd, x, y)
    local btn = Instance.new("TextButton", FunTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Фан-команда: " .. cmd)
        GlobalCommand(cmd, "")
    end)
end

AddFunButton("RAINBOW", "rainbow", 0.02, 0.02)
AddFunButton("PARTY", "party", 0.35, 0.02)
AddFunButton("EXPLODE SELF", "explodeself", 0.68, 0.02)
AddFunButton("TELEPORT RANDOM", "teleportrandom", 0.02, 0.14)
AddFunButton("FLY ALL", "flyall", 0.35, 0.14)
AddFunButton("NOGRAVITY", "nogravity", 0.68, 0.14)
AddFunButton("KILL SELF", "killself", 0.02, 0.26)

-- ================================================================
-- TOOLS TAB
-- ================================================================

local function AddToolsButton(text, cmd, x, y)
    local btn = Instance.new("TextButton", ToolsTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    btn.Text = text
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Инструмент: " .. cmd)
        GlobalCommand(cmd, "")
    end)
end

AddToolsButton("GIVE TOOLS", "givetools", 0.02, 0.02)
AddToolsButton("GIVE ADMIN", "giveadmin", 0.35, 0.02)
AddToolsButton("GIVE SWORD", "givesword", 0.68, 0.02)
AddToolsButton("GIVE GUN", "givegun", 0.02, 0.14)
AddToolsButton("GIVE ALL ITEMS", "giveallitems", 0.35, 0.14)

-- ================================================================
-- ADMIN TAB
-- ================================================================

local function AddAdminButton(text, cmd, x, y)
    local btn = Instance.new("TextButton", AdminTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Админ-команда: " .. cmd)
        GlobalCommand(cmd, "")
    end)
end

AddAdminButton("SHUTDOWN", "shutdown", 0.02, 0.02)
AddAdminButton("CRASH", "crash", 0.35, 0.02)
AddAdminButton("LAG", "lag", 0.68, 0.02)
AddAdminButton("RESET SERVER", "resetserver", 0.02, 0.14)
AddAdminButton("LOG ALL", "logall", 0.35, 0.14)

-- ================================================================
-- ANTI TAB
-- ================================================================

local function AddAntiButton(text, cmd, x, y)
    local btn = Instance.new("TextButton", AntiTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Защита: " .. cmd)
        GlobalCommand(cmd, "")
    end)
end

AddAntiButton("ANTI-KICK", "antikick", 0.02, 0.02)
AddAntiButton("ANTI-BAN", "antiban", 0.35, 0.02)
AddAntiButton("ANTI-CRASH", "anticrash", 0.68, 0.02)
AddAntiButton("ANTI-TP", "antitp", 0.02, 0.14)

-- ================================================================
-- FLY TAB
-- ================================================================

local function AddFlyButton(text, speed, x, y)
    local btn = Instance.new("TextButton", FlyTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Полёт: " .. speed)
        GlobalCommand("flyspeed", tostring(speed))
    end)
end

AddFlyButton("FLY OFF", "0", 0.02, 0.02)
AddFlyButton("FLY SLOW", "20", 0.35, 0.02)
AddFlyButton("FLY MEDIUM", "50", 0.68, 0.02)
AddFlyButton("FLY FAST", "100", 0.02, 0.14)
AddFlyButton("FLY ULTRA", "200", 0.35, 0.14)

-- ================================================================
-- NOCLIP TAB
-- ================================================================

local function AddNoclipButton(text, state, x, y)
    local btn = Instance.new("TextButton", NoclipTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    btn.Text = text
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Ноклип: " .. state)
        GlobalCommand("noclipstate", state)
    end)
end

AddNoclipButton("NOCLIP ON", "on", 0.02, 0.02)
AddNoclipButton("NOCLIP OFF", "off", 0.35, 0.02)

-- ================================================================
-- GODMODE TAB
-- ================================================================

local function AddGodmodeButton(text, state, x, y)
    local btn = Instance.new("TextButton", GodmodeTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Бог-режим: " .. state)
        GlobalCommand("godmodestate", state)
    end)
end

AddGodmodeButton("GODMODE ON", "on", 0.02, 0.02)
AddGodmodeButton("GODMODE OFF", "off", 0.35, 0.02)

-- ================================================================
-- SPEED TAB
-- ================================================================

local function AddSpeedButton(text, speed, x, y)
    local btn = Instance.new("TextButton", SpeedTab)
    btn.Size = UDim2.new(0.3, -5, 0.1, 0)
    btn.Position = UDim2.new(x, 5, y, 5)
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    btn.Text = text
    btn.TextColor3 = Color3.new(0, 0, 0)
    btn.Font = Enum.Font.Code
    btn.TextSize = 14
    Instance.new("UICorner").Parent = btn
    btn.MouseButton1Click:Connect(function()
        AddLog("Скорость: " .. speed)
        GlobalCommand("speedset", tostring(speed))
    end)
end

AddSpeedButton("SPEED 0", "0", 0.02, 0.02)
AddSpeedButton("SPEED 16", "16", 0.35, 0.02)
AddSpeedButton("SPEED 30", "30", 0.68, 0.02)
AddSpeedButton("SPEED 50", "50", 0.02, 0.14)
AddSpeedButton("SPEED 100", "100", 0.35, 0.14)
AddSpeedButton("SPEED 200", "200", 0.68, 0.14)

-- ================================================================
-- SETTINGS TAB
-- ================================================================

local InfoLabel = Instance.new("TextLabel", SettingsTab)
InfoLabel.Size = UDim2.new(1, -20, 0.45, 0)
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = [[KingMiraiReborn v13 — MOBILE EDITION (FIXED)

🟢 GUI НЕ ЗАКРЫВАЕТСЯ ПРИ ОШИБКАХ
🟢 Все команды глобальные
🟢 15 вкладок с функциями
🟢 Логирование всех действий
🟢 Поддержка loadstring на сервере

Команды для консоли:
  GlobalExecute("code")
  GlobalBroadcast("msg")
  GlobalChat("msg")

by @KingMirai | DIMSTAT EDITION]]
InfoLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
InfoLabel.TextScaled = false
InfoLabel.TextSize = 14
InfoLabel.TextWrapped = true
InfoLabel.Font = Enum.Font.Code
InfoLabel.LineHeight = 1.3
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top

local ReloadBtn = Instance.new("TextButton", SettingsTab)
ReloadBtn.Size = UDim2.new(0.4, -10, 0.08, 0)
ReloadBtn.Position = UDim2.new(0.3, 5, 0.6, 5)
ReloadBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
ReloadBtn.Text = "RELOAD GUI"
ReloadBtn.TextColor3 = Color3.new(1, 1, 1)
ReloadBtn.Font = Enum.Font.Code
ReloadBtn.TextSize = 16
Instance.new("UICorner").Parent = ReloadBtn
ReloadBtn.MouseButton1Click:Connect(function()
    AddLog("Перезагрузка GUI")
    ScreenGui:Destroy()
    task.wait(0.5)
    _G.RestartKingMirai = true
end)

local ClearLogsBtn = Instance.new("TextButton", SettingsTab)
ClearLogsBtn.Size = UDim2.new(0.4, -10, 0.08, 0)
ClearLogsBtn.Position = UDim2.new(0.3, 5, 0.72, 5)
ClearLogsBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
ClearLogsBtn.Text = "CLEAR LOGS"
ClearLogsBtn.TextColor3 = Color3.new(0, 0, 0)
ClearLogsBtn.Font = Enum.Font.Code
ClearLogsBtn.TextSize = 16
Instance.new("UICorner").Parent = ClearLogsBtn
ClearLogsBtn.MouseButton1Click:Connect(function()
    Logs = {}
    AddLog("Логи очищены")
end)

-- ================================================================
-- ЗАЩИТА GUI
-- ================================================================

ScreenGui.AncestryChanged:Connect(function()
    if not ScreenGui.Parent then
        task.wait(0.5)
        ScreenGui.Parent = CoreGui
    end
end)

-- ================================================================
-- ЗАПУСК
-- ================================================================

Main.Visible = true
OpenBtn.Visible = false
AddLog("FIXED MOBILE EDITION загружена! GUI НЕ ЗАКРЫВАЕТСЯ.")

print("[KingMiraiReborn v13] MOBILE EDITION FIXED ЗАГРУЖЕНА!")
print("[KingMiraiReborn v13] GUI больше не закрывается при ошибках.")
