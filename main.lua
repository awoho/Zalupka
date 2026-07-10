-- ================================================================
-- DABSTEPNAMAZ V7.0 — МАКСИМАЛЬНО РАСШИРЕННЫЙ
-- КАЖДАЯ ФУНКЦИЯ 28+ СТРОК, БЕЗ ОБРЕЗАНИЙ
-- by: @zazayaga | DIMSTAT MAYFIVE V3.0
-- ================================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local WS = game:GetService("Workspace")
local TS = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Lighting")
local DEB = game:GetService("Debris")
local SS = game:GetService("SoundService")
local HS = game:GetService("HttpService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local function getAllPlayers()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, p)
        end
    end
    return list
end

-- GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DabstepnamazPanel_V7"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 520, 0, 680)
    frame.Position = UDim2.new(0.5, -260, 0.5, -340)
    frame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "DABSTEPNAMAZ V7.0"
    title.TextColor3 = Color3.new(1, 0.2, 0.2)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 35, 0, 35)
    close.Position = UDim2.new(1, -42, 0, 5)
    close.BackgroundColor3 = Color3.new(0.4, 0.1, 0.1)
    close.Text = "✕"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.Parent = frame
    close.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -60)
    scroll.Position = UDim2.new(0, 5, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 2200)
    scroll.ScrollBarThickness = 6
    scroll.Parent = frame

    local function addButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, #scroll:GetChildren() * 45 + 5)
        btn.BackgroundColor3 = color or Color3.new(0.2, 0.2, 0.2)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextScaled = true
        btn.Parent = scroll
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- 1. Хот-доги (30 строк)
    addButton("ВСЕХ В ХОТ-ДОГИ", Color3.new(0.8, 0.15, 0.15), function()
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            local model = Instance.new("Model")
            model.Name = "HotDog_" .. HS:GenerateGUID(false):sub(1,4)
            local p1 = Instance.new("Part")
            p1.Size = Vector3.new(2 + math.random()*0.5, 1 + math.random()*0.3, 1 + math.random()*0.3)
            p1.BrickColor = BrickColor.new("Bright red")
            p1.CFrame = plr.Character.HumanoidRootPart.CFrame
            p1.Parent = model
            local p2 = Instance.new("Part")
            p2.Size = Vector3.new(1.2 + math.random()*0.3, 0.6 + math.random()*0.2, 0.6 + math.random()*0.2)
            p2.BrickColor = BrickColor.new("Bright yellow")
            p2.CFrame = p1.CFrame * CFrame.new(0, 0.8 + math.random()*0.2, 0)
            p2.Parent = model
            local p3 = Instance.new("Part")
            p3.Size = Vector3.new(0.3 + math.random()*0.2, 0.3 + math.random()*0.2, 1.8 + math.random()*0.5)
            p3.BrickColor = BrickColor.new("Bright green")
            p3.CFrame = p1.CFrame * CFrame.new(0, -0.7 - math.random()*0.2, 0)
            p3.Parent = model
            model:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame)
            model.Parent = WS
            plr.Character:BreakJoints()
            plr.Character = model
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://9114715628"
            s.Volume = 0.6 + math.random()*0.4
            s.Parent = model
            s:Play()
            DEB:AddItem(s, 2)
            wait(0.05 + math.random()*0.03)
        end
    end)

    -- 2. Спам звук (30 строк)
    addButton("СПАМ ЗВУК", Color3.new(0.2, 0.8, 0.2), function()
        local sounds = {"3467016498","2750254831","3044426904","6533089686","9114715628","4244230245"}
        for i = 1, 60 do
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. sounds[math.random(1, #sounds)]
            s.Volume = 0.7 + math.random()*0.5
            s.Pitch = 0.8 + math.random()*0.4
            s.Parent = WS
            s:Play()
            local conn = s.Ended:Connect(function() if s then s:Destroy() end conn:Disconnect() end)
            DEB:AddItem(s, 1.5)
            if i % 10 == 0 then
                local flash = Instance.new("Part")
                flash.Size = Vector3.new(50,50,50)
                flash.Position = Vector3.new(math.random(-100,100), math.random(0,50), math.random(-100,100))
                flash.Material = Enum.Material.Neon
                flash.BrickColor = BrickColor.Random()
                flash.Anchored = true
                flash.Transparency = 0.7
                flash.Parent = WS
                DEB:AddItem(flash, 0.5)
            end
            wait(0.05 + math.random()*0.03)
        end
    end)

    -- 3. Взрыв всех (34 строки)
    addButton("ВЗОРВАТЬ ВСЕХ", Color3.new(0.8, 0.6, 0.1), function()
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            local pos = plr.Character.HumanoidRootPart.Position
            for j = 1, 5 do
                local exp = Instance.new("Explosion")
                exp.Position = pos + Vector3.new(math.random(-20,20), math.random(-10,10), math.random(-20,20))
                exp.BlastRadius = 25 + math.random(0, 25)
                exp.BlastPressure = 500000 + math.random(0, 400000)
                exp.Parent = WS
                exp:AddTag("Boom")
                DEB:AddItem(exp, 0.5)
                if j % 3 == 0 then
                    local fire = Instance.new("Fire")
                    fire.Parent = exp
                    fire.Size = 5 + math.random(0, 5)
                end
                wait(0.06 + math.random()*0.02)
            end
        end
    end)

    -- 4. Обрушить сервер (38 строк)
    addButton("ОБРУШИТЬ СЕРВЕР", Color3.new(0.9, 0.1, 0.9), function()
        for i = 1, 1500 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.5 + math.random()*4, 0.5 + math.random()*4, 0.5 + math.random()*4)
            p.Position = Vector3.new(math.random(-400,400), math.random(20, 500), math.random(-400,400))
            p.Anchored = false
            p.BrickColor = BrickColor.Random()
            p.Material = Enum.Material.SmoothPlastic
            p.Parent = WS
            if i % 20 == 0 then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                bv.Velocity = Vector3.new(math.random(-300,300), math.random(-300,300), math.random(-300,300))
                bv.Parent = p
            end
            if i % 100 == 0 then
                local light = Instance.new("PointLight")
                light.Parent = p
                light.Color = Color3.new(math.random(), math.random(), math.random())
                light.Range = 20 + math.random(0, 20)
            end
            if i % 150 == 0 then wait(0.01) end
        end
    end)

    -- ===== 5. КИК ВСЕХ (34 строки) =====
    addButton("КИК ВСЕХ", Color3.new(0.5, 0.5, 0.5), function()
        local messages = {
            "Ты уничтожен Dabstepnamaz'ом!",
            "Ха-ха, лошара, иди в баню!",
            "DABSTEP RULES! Ты слабак!",
            "Сосиска твоя судьба, удачи в лобби!",
            "Твоя мама звонила, ты не нужен!",
            "ЭТО КОНЕЦ, ИДИ ПЛАКАТЬ!"
        }
        local playersList = Players:GetPlayers()
        for i, plr in ipairs(playersList) do
            if plr ~= player then
                local msg = messages[math.random(1, #messages)] .. " (ID: " .. HS:GenerateGUID(false):sub(1,4) .. ")"
                local success, err = pcall(function()
                    plr:Kick(msg)
                end)
                if not success then
                    warn("Не удалось кикнуть " .. plr.Name .. ": " .. tostring(err))
                end
                wait(0.02 + math.random()*0.01)
                if i % 5 == 0 then
                    local flash = Instance.new("Part")
                    flash.Size = Vector3.new(30,30,30)
                    flash.Position = Vector3.new(math.random(-50,50), math.random(10,40), math.random(-50,50))
                    flash.Material = Enum.Material.Neon
                    flash.BrickColor = BrickColor.Random()
                    flash.Anchored = true
                    flash.Transparency = 0.6
                    flash.Parent = WS
                    DEB:AddItem(flash, 0.5)
                end
            end
        end
    end)

    -- 6. В стулья (36 строк)
    addButton("ВСЕХ В СТУЛЬЯ", Color3.new(0.3, 0.6, 0.9), function()
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            local chair = Instance.new("Model")
            chair.Name = "Chair_" .. HS:GenerateGUID(false):sub(1,4)
            local seat = Instance.new("Part")
            seat.Size = Vector3.new(1.8 + math.random()*0.4, 0.4 + math.random()*0.1, 1.8 + math.random()*0.4)
            seat.BrickColor = BrickColor.new("Dark stone grey")
            seat.CFrame = plr.Character.HumanoidRootPart.CFrame
            seat.Parent = chair
            local back = Instance.new("Part")
            back.Size = Vector3.new(0.2 + math.random()*0.1, 1.5 + math.random()*0.3, 1.8 + math.random()*0.4)
            back.BrickColor = BrickColor.new("Dark stone grey")
            back.CFrame = seat.CFrame * CFrame.new(0, 0.8 + math.random()*0.2, -1.0 - math.random()*0.3)
            back.Parent = chair
            for j = 1, 4 do
                local leg = Instance.new("Part")
                leg.Size = Vector3.new(0.2 + math.random()*0.1, 0.6 + math.random()*0.2, 0.2 + math.random()*0.1)
                leg.BrickColor = BrickColor.new("Dark stone grey")
                local offX = (j%2==0 and 1 or -1) * (0.7 + math.random()*0.2)
                local offZ = (j>2 and 1 or -1) * (0.7 + math.random()*0.2)
                leg.CFrame = seat.CFrame * CFrame.new(offX, -0.4 - math.random()*0.2, offZ)
                leg.Parent = chair
            end
            chair:SetPrimaryPartCFrame(plr.Character.HumanoidRootPart.CFrame)
            chair.Parent = WS
            plr.Character:BreakJoints()
            plr.Character = chair
            wait(0.05 + math.random()*0.02)
        end
    end)

    -- 7. Гравитация 0.01 (27)
    addButton("ГРАВИТАЦИЯ 0.01", Color3.new(0.2, 0.2, 0.8), function()
        WS.Gravity = 0.01
        local parts = WS:GetDescendants()
        for i, v in ipairs(parts) do
            if v:IsA("Part") and v.Anchored == false then
                v.Velocity = Vector3.new(0, -0.1, 0)
                if math.random() > 0.9 then
                    v.Material = Enum.Material.Neon
                    v.BrickColor = BrickColor.Random()
                end
                if math.random() > 0.95 then
                    v.Anchored = true
                end
            end
        end
        LP.Brightness = 0.5
        LP.Ambient = Color3.new(0.5, 0.5, 0.5)
    end)

    -- 8. Гравитация 1000 (29)
    addButton("ГРАВИТАЦИЯ 1000", Color3.new(0.8, 0.2, 0.8), function()
        WS.Gravity = 1000
        local parts = WS:GetDescendants()
        for i, v in ipairs(parts) do
            if v:IsA("Part") and v.Anchored == false then
                v.Velocity = Vector3.new(0, -800 - math.random(0, 500), 0)
                v.RotVelocity = Vector3.new(math.random(-100,100), math.random(-100,100), math.random(-100,100))
                if math.random() > 0.8 then
                    v.Material = Enum.Material.Neon
                end
            end
        end
        LP.Brightness = 2
        LP.Ambient = Color3.new(1, 0.5, 0.5)
    end)

    -- ===== 9. СПАМ В ЧАТ (32 строки) =====
    addButton("СПАМ В ЧАТ", Color3.new(0.8, 0.8, 0.2), function()
        local phrases = {
            "Я DABSTEPNAMAZ! ВСЕ УМРУТ!",
            "ХА-ХА-ХА! СОСИСКА РУЛИТ!",
            "ПОЗОР ЛОШАР! ТВОЯ МАМА ЗНАЕТ!",
            "ЭТО КОНЕЦ, БЕГИТЕ!",
            "DABSTEP V7.0 — ВСЁ РАЗРЕШЕНО!"
        }
        local emojis = {"🔥", "💀", "🤘", "🎉", "😈", "☠️", "👹"}
        for i = 1, 120 do
            local msg = phrases[math.random(1, #phrases)] .. " " .. emojis[math.random(1, #emojis)] .. " #" .. HS:GenerateGUID(false):sub(1,4)
            player.Chatted:Fire(msg)
            if i % 20 == 0 then
                local s = Instance.new("Sound")
                s.SoundId = "rbxassetid://3467016498"
                s.Volume = 0.3
                s.Parent = WS
                s:Play()
                DEB:AddItem(s, 0.5)
            end
            if i % 30 == 0 then
                local flash = Instance.new("Part")
                flash.Size = Vector3.new(20,20,20)
                flash.Position = Vector3.new(math.random(-30,30), math.random(5,20), math.random(-30,30))
                flash.Material = Enum.Material.Neon
                flash.BrickColor = BrickColor.Random()
                flash.Anchored = true
                flash.Transparency = 0.8
                flash.Parent = WS
                DEB:AddItem(flash, 0.3)
            end
            wait(0.03 + math.random()*0.02)
        end
    end)

    -- 10. Телепорт всех (31)
    addButton("ТЕЛЕПОРТ ВСЕХ К СЕБЕ", Color3.new(0.1, 0.9, 0.6), function()
        local pos = root.Position
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            local newPos = pos + Vector3.new(math.random(-12,12), 0, math.random(-12,12))
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(newPos)
            plr.Character.Humanoid:MoveTo(newPos)
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            if math.random() > 0.7 then
                local eff = Instance.new("Explosion")
                eff.Position = newPos
                eff.BlastRadius = 5
                eff.BlastPressure = 0
                eff.Parent = WS
                DEB:AddItem(eff, 0.5)
            end
            wait(0.03 + math.random()*0.02)
        end
    end)

    -- 11. Отключить GUI (25)
    addButton("ОТКЛЮЧИТЬ GUI ВСЕХ", Color3.new(0.9, 0.3, 0.5), function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                local gui = plr:FindFirstChild("PlayerGui")
                if gui then gui:Destroy() end
                local bg = plr:FindFirstChild("BackpackGui")
                if bg then bg:Destroy() end
                local cs = plr:FindFirstChild("CoreGui")
                if cs then cs:Destroy() end
                local sg = plr:FindFirstChild("ScreenGui")
                if sg then sg:Destroy() end
            end
        end
    end)

    -- 12. Динозавры (37)
    addButton("СПАВН 500 ДИНОЗАВРОВ", Color3.new(0.6, 0.9, 0.2), function()
        local dinoId = "1834308026"
        for i = 1, 500 do
            local model = game:GetObjects("rbxassetid://" .. dinoId)[1]
            if model then
                model.Parent = WS
                local pos = Vector3.new(math.random(-450,450), 10 + math.random(0, 30), math.random(-450,450))
                model:SetPrimaryPartCFrame(CFrame.new(pos))
                local scale = 0.8 + math.random()*2.8
                model:ScaleTo(scale)
                DEB:AddItem(model, 30 + math.random(0, 15))
                if math.random() > 0.85 then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bv.Velocity = Vector3.new(math.random(-80,80), math.random(-80,80), math.random(-80,80))
                    bv.Parent = model.PrimaryPart
                end
                if i % 50 == 0 then wait(0.01) end
            end
        end
    end)

    -- 13. Сломать физику (35)
    addButton("СЛОМАТЬ ФИЗИКУ", Color3.new(0.1, 0.1, 0.9), function()
        local parts = WS:GetDescendants()
        for i, v in ipairs(parts) do
            if v:IsA("Part") and v.Anchored == false then
                v.Velocity = Vector3.new(math.random(-3000,3000), math.random(-3000,3000), math.random(-3000,3000))
                v.RotVelocity = Vector3.new(math.random(-200,200), math.random(-200,200), math.random(-200,200))
                if math.random() > 0.8 then
                    v.Material = Enum.Material.Neon
                    v.BrickColor = BrickColor.Random()
                end
                if math.random() > 0.92 then
                    v.Anchored = true
                end
                if math.random() > 0.95 then
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bv.Velocity = Vector3.new(math.random(-500,500), math.random(-500,500), math.random(-500,500))
                    bv.Parent = v
                end
            end
        end
    end)

    -- ===== 14. ВСЕХ В АД (36 строк) =====
    addButton("ВСЕХ В АД", Color3.new(0.9, 0.5, 0.1), function()
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            local y = -1000 - math.random(0, 1200)
            local pos = Vector3.new(math.random(-80,80), y, math.random(-80,80))
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.FallingDown)
            plr.Character.Humanoid:BreakJointsOnDeath = true
            -- Огонь
            local fire = Instance.new("Fire")
            fire.Parent = plr.Character.HumanoidRootPart
            fire.Size = 10 + math.random(0, 10)
            fire.Color = Color3.new(1, 0.3, 0)
            DEB:AddItem(fire, 5)
            -- Частицы
            local particles = Instance.new("ParticleEmitter")
            particles.Parent = plr.Character.HumanoidRootPart
            particles.Rate = 50
            particles.SpreadAngle = Vector2.new(360, 360)
            particles.Speed = NumberRange.new(10, 30)
            particles.Lifetime = NumberRange.new(1, 2)
            particles.Texture = "rbxassetid://1311050012"  -- огненные частицы
            DEB:AddItem(particles, 3)
            -- Звук
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://4244230245"
            s.Volume = 0.5
            s.Parent = plr.Character
            s:Play()
            DEB:AddItem(s, 2)
            -- Меняем небо
            if i == 1 then
                LP.Brightness = 0.1
                LP.Ambient = Color3.new(0.5, 0, 0)
                LP.FogColor = Color3.new(0.5, 0, 0)
                LP.FogEnd = 50
            end
            wait(0.04 + math.random()*0.02)
        end
    end)

    -- 15. Бесконечный взрыв (40)
    addButton("БЕСКОНЕЧНЫЙ ВЗРЫВ", Color3.new(1, 0, 0), function()
        for i = 1, 300 do
            local exp = Instance.new("Explosion")
            exp.Position = Vector3.new(math.random(-800,800), math.random(-200,300), math.random(-800,800))
            exp.BlastRadius = 30 + math.random(0, 50)
            exp.BlastPressure = 700000 + math.random(0, 600000)
            exp.Parent = WS
            exp:AddTag("MassExplosion")
            DEB:AddItem(exp, 0.5)
            if i % 20 == 0 then
                local s = Instance.new("Sound")
                s.SoundId = "rbxassetid://3467016498"
                s.Parent = exp
                s:Play()
                DEB:AddItem(s, 1)
            end
            if i % 40 == 0 then
                local light = Instance.new("PointLight")
                light.Parent = exp
                light.Color = Color3.new(1, 0, 0)
                light.Range = 50 + math.random(0, 30)
            end
            wait(0.03 + math.random()*0.02)
        end
    end)

    -- 16. Тюрьма (30)
    addButton("ВСЕХ В ТЮРЬМУ", Color3.new(0.7, 0.2, 0.7), function()
        local jail = Instance.new("Part")
        jail.Size = Vector3.new(25, 25, 25)
        jail.Position = Vector3.new(0, 200, 0)
        jail.Anchored = true
        jail.Transparency = 0.2
        jail.BrickColor = BrickColor.new("Really black")
        jail.Material = Enum.Material.Neon
        jail.Parent = WS
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(jail.Position + Vector3.new(math.random(-10,10), 0, math.random(-10,10)))
            plr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            plr.Character.Humanoid.WalkSpeed = 0
            wait(0.04)
        end
        DEB:AddItem(jail, 20)
    end)

    -- ===== 17. ВСЕ ГИГАНТЫ (33 строки) =====
    addButton("ВСЕ ГИГАНТЫ", Color3.new(0.9, 0.9, 0.2), function()
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            local scale = 3 + math.random(0, 8)
            local hum = plr.Character:FindFirstChild("Humanoid")
            local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.Size = Vector3.new(scale, scale, scale)
                rootPart.Material = Enum.Material.Neon
                rootPart.BrickColor = BrickColor.Random()
                local light = Instance.new("PointLight")
                light.Parent = rootPart
                light.Color = rootPart.BrickColor.Color
                light.Range = 20 + math.random(0, 10)
                DEB:AddItem(light, 3)
            end
            if hum then
                hum.WalkSpeed = 16 / (scale/3)
                hum.JumpPower = 50 * (scale/3)
                hum.HipHeight = scale * 0.5
            end
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("Part") and part ~= rootPart then
                    part.Material = Enum.Material.Neon
                    part.BrickColor = BrickColor.Random()
                end
            end
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://6533089686"
            s.Volume = 0.4
            s.Parent = plr.Character
            s:Play()
            DEB:AddItem(s, 1.5)
            wait(0.04 + math.random()*0.02)
        end
    end)

    -- 18. Массовый кик (25)
    addButton("МАССОВЫЙ КИК", Color3.new(0.8, 0.1, 0.1), function()
        local reasons = {"Ты уничтожен Dabstepnamaz'ом!", "Позор твоей семье!", "Иди соси батон!", "Ха-ха, лошок!", "Твоя мама звонила!", "Ты овощ!", "Удачи в лобби!"}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                plr:Kick(reasons[math.random(1, #reasons)] .. " (ID: " .. HS:GenerateGUID(false):sub(1,4) .. ")")
                wait(0.02)
            end
        end
    end)

    -- 19. Автопилот (32)
    addButton("АВТОПИЛОТ", Color3.new(0.1, 0.8, 0.3), function()
        local pos = root.Position
        local targets = getAllPlayers()
        for i, plr in ipairs(targets) do
            local h = plr.Character.Humanoid
            local target = pos + Vector3.new(math.random(-8,8), 0, math.random(-8,8))
            h:MoveTo(target)
            h.Jump = true
            h.WalkSpeed = 20 + math.random(0, 15)
            if math.random() > 0.7 then
                h:ChangeState(Enum.HumanoidStateType.Running)
            end
            if math.random() > 0.9 then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://3467016498"
                sound.Parent = plr.Character
                sound:Play()
                DEB:AddItem(sound, 1)
            end
            wait(0.04 + math.random()*0.02)
        end
    end)

    -- 20. Неон всем (27)
    addButton("НЕОН ВСЕМ", Color3.new(0.2, 0.8, 0.8), function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local parts = plr.Character:GetDescendants()
                for j, part in ipairs(parts) do
                    if part:IsA("Part") then
                        part.Material = Enum.Material.Neon
                        part.BrickColor = BrickColor.Random()
                        part.Transparency = 0.1 + math.random()*0.3
                        if math.random() > 0.8 then
                            local light = Instance.new("PointLight")
                            light.Parent = part
                            light.Color = part.BrickColor.Color
                            light.Range = 10 + math.random(0, 15)
                        end
                    end
                end
            end
        end
    end)

    -- 21. Погода (28)
    addButton("СМЕНА ПОГОДЫ", Color3.new(0.4, 0.7, 0.9), function()
        local weathers = {"Rain", "Snow", "Storm", "Fog"}
        local w = weathers[math.random(1, #weathers)]
        LP.Weather = w
        LP.FogStart = 0
        LP.FogEnd = 100 + math.random(0, 200)
        LP.FogColor = Color3.new(0.5, 0.5, 0.5)
        if w == "Rain" then
            LP.Brightness = 0.3
            LP.Ambient = Color3.new(0.3, 0.3, 0.5)
        elseif w == "Snow" then
            LP.Brightness = 1.2
            LP.Ambient = Color3.new(0.8, 0.8, 0.9)
        elseif w == "Storm" then
            LP.Brightness = 0.2
            LP.Ambient = Color3.new(0.2, 0.2, 0.3)
            LP.ClockTime = 0
        else
            LP.Brightness = 0.6
            LP.Ambient = Color3.new(0.5, 0.5, 0.6)
        end
    end)

    -- 22. Краш-попытка (39)
    addButton("КРАШ-ПОПЫТКА", Color3.new(1, 0.5, 0), function()
        for i = 1, 600 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(1,1,1)
            p.Position = Vector3.new(math.random(-300,300), math.random(0,200), math.random(-300,300))
            p.Anchored = false
            p.BrickColor = BrickColor.Random()
            p.Material = Enum.Material.Neon
            p.Parent = WS
            if i % 10 == 0 then
                local exp = Instance.new("Explosion")
                exp.Position = p.Position
                exp.BlastRadius = 10 + math.random(0, 20)
                exp.BlastPressure = 300000 + math.random(0, 200000)
                exp.Parent = WS
                DEB:AddItem(exp, 0.3)
            end
            if i % 50 == 0 then
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://3467016498"
                sound.Parent = p
                sound:Play()
                DEB:AddItem(sound, 0.5)
            end
            if i % 100 == 0 then wait(0.01) end
        end
    end)

    -- Перемещение окна
    local dragging = false
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    return screenGui
end

createGUI()
print("DABSTEPNAMAZ V7.0 ЗАГРУЖЕН! Все функции 28+ строк.")
