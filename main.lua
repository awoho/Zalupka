local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

if RunService:IsServer() then

_G.Nova = {}
_G.Nova.Admins = {123456789}
_G.Nova.Moderators = {}
_G.Nova.Prefix = "/"
_G.Nova.Version = "2.0"
_G.Nova.ItemDatabase = {}

_G.Nova.findPlayer = function(i)
 local f = {}
 for _,p in ipairs(Players:GetPlayers()) do
  if string.lower(p.Name):find(string.lower(i)) or string.lower(p.DisplayName):find(string.lower(i)) then
   table.insert(f,p)
  end
 end
 return f
end

_G.Nova.isAdmin = function(p)
 if not p then return false end
 for _,id in ipairs(_G.Nova.Admins) do if p.UserId == id then return true end end
 return false
end

_G.Nova.isModerator = function(p)
 if _G.Nova.isAdmin(p) then return true end
 for _,id in ipairs(_G.Nova.Moderators) do if p.UserId == id then return true end end
 return false
end

_G.Nova.notify = function(p,t,text,d)
 d = d or 3
 if p and p:IsA("Player") then
  local ev = ReplicatedStorage:FindFirstChild("Notify")
  if ev then ev:FireClient(p, t, text, d) end
 end
end

_G.Nova.getChar = function(p)
 if not p then return nil end
 local c = p.Character
 if not c or not c.Parent then p:LoadCharacter() c = p.Character end
 return c
end

_G.Nova.getHRP = function(p) local c = _G.Nova.getChar(p) return c and c:FindFirstChild("HumanoidRootPart") end
_G.Nova.getHumanoid = function(p) local c = _G.Nova.getChar(p) return c and c:FindFirstChild("Humanoid") end

_G.Nova.kick = function(e,t,r)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 r = r or "Нарушение"
 t:Kick("Кикнут "..e.Name..": "..r)
 _G.Nova.notify(e,"Успех","Кикнут "..t.Name)
end

_G.Nova.ban = function(e,t,r)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 r = r or "Бан"
 t:Kick("Забанен "..e.Name..": "..r)
 _G.Nova.notify(e,"Успех","Забанен "..t.Name)
end

_G.Nova.tp = function(e,t)
 if not _G.Nova.isModerator(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local h1 = _G.Nova.getHRP(e) local h2 = _G.Nova.getHRP(t)
 if h1 and h2 then h1.CFrame = h2.CFrame + Vector3.new(0,3,0) _G.Nova.notify(e,"Успех","Телепорт к "..t.Name) end
end

_G.Nova.bring = function(e,t)
 if not _G.Nova.isModerator(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local h1 = _G.Nova.getHRP(e) local h2 = _G.Nova.getHRP(t)
 if h1 and h2 then h2.CFrame = h1.CFrame + Vector3.new(0,3,0) _G.Nova.notify(e,"Успех","Призван "..t.Name) end
end

_G.Nova.heal = function(e,t)
 if not _G.Nova.isModerator(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 t = t or e
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local hum = _G.Nova.getHumanoid(t)
 if hum then hum.Health = hum.MaxHealth _G.Nova.notify(e,"Успех","Вылечен "..t.Name) end
end

_G.Nova.kill = function(e,t)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local hum = _G.Nova.getHumanoid(t)
 if hum then hum.Health = 0 _G.Nova.notify(e,"Успех","Убит "..t.Name) end
end

_G.Nova.announce = function(e,m)
 if not _G.Nova.isModerator(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 for _,p in ipairs(Players:GetPlayers()) do _G.Nova.notify(p,"Объявление от "..e.Name,m,5) end
end

_G.Nova.respawnAll = function(e)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 for _,p in ipairs(Players:GetPlayers()) do p:LoadCharacter() end
 _G.Nova.notify(e,"Успех","Все перерождены")
end

_G.Nova.freezeAll = function(e)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 for _,p in ipairs(Players:GetPlayers()) do local h = _G.Nova.getHumanoid(p) if h then h.PlatformStand = true end end
 _G.Nova.notify(e,"Успех","Все заморожены")
end

_G.Nova.unfreezeAll = function(e)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 for _,p in ipairs(Players:GetPlayers()) do local h = _G.Nova.getHumanoid(p) if h then h.PlatformStand = false end end
 _G.Nova.notify(e,"Успех","Все разморожены")
end

_G.Nova.shutdown = function(e)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 for _,p in ipairs(Players:GetPlayers()) do p:Kick("Сервер закрыт "..e.Name) end
end

local flyData = {}
_G.Nova.fly = function(e,t)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 t = t or e
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local hum = _G.Nova.getHumanoid(t)
 if not hum then return end
 if flyData[t] then
  flyData[t] = nil
  hum.PlatformStand = false
  _G.Nova.notify(e,"Успех","Fly выключен для "..t.Name)
  return
 end
 flyData[t] = true
 hum.PlatformStand = true
 _G.Nova.notify(e,"Успех","Fly включён для "..t.Name)
 local conn
 conn = RunService.Heartbeat:Connect(function(dt)
  if not flyData[t] or not t.Parent then conn:Disconnect() return end
  local hrp = _G.Nova.getHRP(t)
  if hrp then
   local inp = _G.Nova.getInput(t)
   if inp then
    hrp.CFrame = hrp.CFrame + (hrp.CFrame.RightVector * inp.X + hrp.CFrame.LookVector * inp.Y + Vector3.new(0, inp.Z, 0)) * dt * 50
   end
  end
 end)
end

local noclipData = {}
_G.Nova.noclip = function(e,t)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 t = t or e
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local c = _G.Nova.getChar(t)
 if not c then return end
 if noclipData[t] then
  noclipData[t] = nil
  for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
  _G.Nova.notify(e,"Успех","NoClip выключен для "..t.Name)
  return
 end
 noclipData[t] = true
 for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
 _G.Nova.notify(e,"Успех","NoClip включён для "..t.Name)
end

local invisibleData = {}
_G.Nova.invisible = function(e,t)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 t = t or e
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local c = _G.Nova.getChar(t)
 if not c then return end
 if invisibleData[t] then
  invisibleData[t] = nil
  for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 0 end end
  _G.Nova.notify(e,"Успех","Invisible выключен для "..t.Name)
  return
 end
 invisibleData[t] = true
 for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = 1 end end
 _G.Nova.notify(e,"Успех","Invisible включён для "..t.Name)
end

local godData = {}
_G.Nova.god = function(e,t)
 if not _G.Nova.isAdmin(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 t = t or e
 if not t or not t:IsA("Player") then _G.Nova.notify(e,"Ошибка","Игрок не найден") return end
 local hum = _G.Nova.getHumanoid(t)
 if not hum then return end
 if godData[t] then
  godData[t] = nil
  hum.MaxHealth = 100
  hum.Health = 100
  _G.Nova.notify(e,"Успех","God выключен для "..t.Name)
  return
 end
 godData[t] = true
 hum.MaxHealth = math.huge
 hum.Health = math.huge
 _G.Nova.notify(e,"Успех","God включён для "..t.Name)
end

_G.Nova.setWalkspeed = function(e,t,v)
 if not _G.Nova.isModerator(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 t = t or e
 v = tonumber(v) or 16
 local hum = _G.Nova.getHumanoid(t)
 if hum then hum.WalkSpeed = math.clamp(v,0,200) _G.Nova.notify(e,"Успех","WalkSpeed = "..v.." для "..t.Name) end
end

_G.Nova.setJumppower = function(e,t,v)
 if not _G.Nova.isModerator(e) then _G.Nova.notify(e,"Ошибка","Недостаточно прав") return end
 t = t or e
 v = tonumber(v) or 50
 local hum = _G.Nova.getHumanoid(t)
 if hum then hum.JumpPower = math.clamp(v,0,500) _G.Nova.notify(e,"Успех","JumpPower = "..v.." для "..t.Name) end
end

_G.Nova.antiAntiCheat = function(p)
 local hum = _G.Nova.getHumanoid(p)
 if not hum then return end
 local oldW = hum.WalkSpeed
 local oldJ = hum.JumpPower
 hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
  if hum.WalkSpeed ~= oldW and hum.WalkSpeed > 16 then hum.WalkSpeed = oldW end
 end)
 hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
  if hum.JumpPower ~= oldJ and hum.JumpPower > 50 then hum.JumpPower = oldJ end
 end)
 local hrp = _G.Nova.getHRP(p)
 if hrp then
  hrp:GetPropertyChangedSignal("Velocity"):Connect(function()
   if hrp.Velocity.Y < -100 then hrp.Velocity = Vector3.new(hrp.Velocity.X, -50, hrp.Velocity.Z) end
  end)
 end
 for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
  if v:IsA("RemoteEvent") and string.find(v.Name, "AntiCheat") then
   v.OnServerEvent:Connect(function(plr, ...) if plr == p then return end end)
  end
 end
end

_G.Nova.bypassExploitDetection = function(p)
 local hrp = _G.Nova.getHRP(p)
 if not hrp then return end
 local lastPos = hrp.Position
 local lastTime = tick()
 RunService.Heartbeat:Connect(function(dt)
  if not hrp.Parent then return end
  local now = tick()
  if now - lastTime > 0.1 then
   lastTime = now
   local newPos = hrp.Position
   local vel = (newPos - lastPos) / 0.1
   if vel.Magnitude > 50 then
    hrp.Velocity = Vector3.new(vel.X * 0.2, vel.Y, vel.Z * 0.2)
   end
   lastPos = newPos
  end
 end)
 p:SetAttribute("MoveInput", Vector3.new(0,0,0))
 p:SetAttribute("JumpInput", false)
end

_G.Nova.antiBan = function(p)
 local oldKick = p.Kick
 p.Kick = function(self, msg)
  if msg and string.find(msg, "ban") then warn("Попытка бана отклонена для "..p.Name) return end
  oldKick(self, msg)
 end
 local ds = DataStoreService:GetDataStore("PlayerData")
 if ds then
  local oldSet = ds.SetAsync
  ds.SetAsync = function(self, key, value)
   if key == p.UserId then
    value = value or {}
    value.LastAction = "legit"
    return oldSet(self, key, value)
   end
   return oldSet(self, key, value)
  end
 end
end

_G.Nova.teleportBypass = function(p, targetPos)
 local hrp = _G.Nova.getHRP(p)
 if not hrp then return end
 local tween = TweenService:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
 tween:Play()
 tween.Completed:Wait()
 hrp.Velocity = Vector3.new(0,0,0)
 local fake = Instance.new("RemoteEvent")
 fake.Name = "FakeMove"
 fake.Parent = ReplicatedStorage
 fake:FireServer(p, hrp.Position, hrp.Velocity)
 wait(0.1)
 fake:Destroy()
end

_G.Nova.speedBypass = function(p, speed)
 local hum = _G.Nova.getHumanoid(p)
 if not hum then return end
 hum.WalkSpeed = speed
 local conn
 conn = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
  if hum.WalkSpeed ~= speed then hum.WalkSpeed = speed else conn:Disconnect() end
 end)
 local rep = p:FindFirstChild("CharacterReplication")
 if rep then rep:SetAttribute("WalkSpeed", speed) end
end

_G.Nova.remoteSpam = function(p, amount)
 amount = amount or 100
 for i = 1, amount do
  for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
   if v:IsA("RemoteEvent") then
    pcall(function() v:FireServer("spam", i, os.time()) end)
   end
  end
 end
end

_G.Nova.characterClone = function(p)
 local old = p.Character
 if not old then return end
 local new = old:Clone()
 new.Parent = workspace
 p.Character = new
 old:Destroy()
 local hum = new:FindFirstChild("Humanoid")
 if hum then hum.WalkSpeed = 16 hum.JumpPower = 50 end
 local hrp = new:FindFirstChild("HumanoidRootPart")
 if hrp then hrp.CFrame = CFrame.new(0,100,0) end
end

_G.Nova.antiLagSwitch = function(p)
 local hrp = _G.Nova.getHRP(p)
 if not hrp then return end
 local lastPos = hrp.Position
 local timer = 0
 RunService.Heartbeat:Connect(function(dt)
  timer = timer + dt
  if timer > 0.5 then
   timer = 0
   local newPos = hrp.Position
   local dist = (newPos - lastPos).Magnitude
   if dist > 100 then hrp.CFrame = CFrame.new(lastPos) end
   lastPos = hrp.Position
  end
 end)
end

_G.Nova.bypassGravity = function(p)
 local hrp = _G.Nova.getHRP(p)
 if not hrp then return end
 hrp:SetAttribute("Mass", 0)
 hrp:GetPropertyChangedSignal("Velocity"):Connect(function()
  if hrp.Velocity.Y < -100 then hrp.Velocity = Vector3.new(hrp.Velocity.X, -20, hrp.Velocity.Z) end
 end)
end

_G.Nova.bypassAntiTeleport = function(p, targetCF)
 local hrp = _G.Nova.getHRP(p)
 if not hrp then return end
 for i = 1, 10 do
  local frac = i / 10
  local newCF = hrp.CFrame:Lerp(targetCF, frac)
  hrp.CFrame = newCF
  wait(0.01)
 end
 hrp.CFrame = targetCF
end

_G.Nova.antiFreeze = function(p)
 local hum = _G.Nova.getHumanoid(p)
 if not hum then return end
 hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
  if hum.PlatformStand and not _G.Nova.isAdmin(p) then hum.PlatformStand = false end
 end)
 hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
  if hum.WalkSpeed == 0 then hum.WalkSpeed = 16 end
 end)
end

_G.Nova.bypassRemoteBlock = function(p)
 for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
  if v:IsA("RemoteEvent") then
   local old = v.FireServer
   v.FireServer = function(self, plr, ...)
    if plr == p then return end
    old(self, plr, ...)
   end
  end
 end
end

_G.Nova.getInput = function(p)
 local input = Vector3.new()
 local hrp = _G.Nova.getHRP(p)
 if hrp then
  local move = p:GetAttribute("MoveInput")
  if move then input = Vector3.new(move.X, move.Y, move.Z) end
 end
 return input
end

_G.Nova.ItemDatabase = {
 Sword = {Name = "Меч", Damage = 10, Rarity = "Common"},
 Gun = {Name = "Пистолет", Damage = 25, Rarity = "Rare"},
 Shield = {Name = "Щит", Defense = 15, Rarity = "Uncommon"},
 Potion = {Name = "Зелье", Heal = 30, Rarity = "Common"},
 Crystal = {Name = "Кристалл", Power = 50, Rarity = "Legendary"},
 Coin = {Name = "Монета", Value = 100, Rarity = "Common"},
 Key = {Name = "Ключ", Type = "Golden", Rarity = "Epic"},
 Armor = {Name = "Броня", Defense = 40, Rarity = "Rare"},
 Bow = {Name = "Лук", Damage = 15, Rarity = "Uncommon"},
 Staff = {Name = "Посох", Magic = 60, Rarity = "Legendary"},
 Ring = {Name = "Кольцо", Buff = "Speed", Rarity = "Epic"},
 Amulet = {Name = "Амулет", Buff = "Health", Rarity = "Rare"},
}

_G.Nova.generateItem = function(typeName)
 local template = _G.Nova.ItemDatabase[typeName]
 if not template then return nil end
 local item = {}
 for k,v in pairs(template) do item[k] = v end
 item.UID = HttpService:GenerateGUID(false)
 item.CreatedAt = os.time()
 item.RandomSeed = math.random(1,1000)
 return item
end

_G.Nova.spamItems = function(executor, target, itemType, count, delay)
 if not _G.Nova.isAdmin(executor) then _G.Nova.notify(executor,"Ошибка","Недостаточно прав") return end
 target = target or executor
 if not target or not target:IsA("Player") then _G.Nova.notify(executor,"Ошибка","Игрок не найден") return end
 count = tonumber(count) or 50
 delay = tonumber(delay) or 0.05
 if count > 10000 then count = 10000 end
 if delay < 0.01 then delay = 0.01 end
 _G.Nova.notify(executor,"Запуск","Спам "..count.." предметов типа "..itemType.." для "..target.Name)
 local total = 0
 local start = tick()
 local function createOne()
  local item = _G.Nova.generateItem(itemType)
  if not item then
   local keys = {}
   for k,_ in pairs(_G.Nova.ItemDatabase) do table.insert(keys,k) end
   item = _G.Nova.generateItem(keys[math.random(1,#keys)])
  end
  local part = Instance.new("Part")
  part.Size = Vector3.new(1,1,1)
  part.Anchored = true
  part.CanCollide = false
  part.Transparency = 0.5
  part.BrickColor = BrickColor.Random()
  part.Name = "Item_"..item.UID
  part.Parent = workspace
  part:SetAttribute("ItemType", itemType)
  part:SetAttribute("UID", item.UID)
  part:SetAttribute("Rarity", item.Rarity or "Common")
  part:SetAttribute("Owner", target.Name)
  local hrp = _G.Nova.getHRP(target)
  if hrp then
   local off = Vector3.new((math.random()-0.5)*20, math.random()*5+1, (math.random()-0.5)*20)
   part.CFrame = hrp.CFrame + off
  else
   part.CFrame = CFrame.new(math.random(-100,100), math.random(10,50), math.random(-100,100))
  end
  if item.Rarity == "Legendary" then
   local light = Instance.new("PointLight")
   light.Parent = part
   light.Color = Color3.fromRGB(255,200,50)
   light.Range = 10
   light.Brightness = 2
  end
  part.Size = Vector3.new(0.1,0.1,0.1)
  TweenService:Create(part, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = Vector3.new(1,1,1)}):Play()
  total = total + 1
  Debris:AddItem(part, 60)
  return part
 end
 local co = coroutine.create(function()
  for i = 1, count do
   createOne()
   if i % 100 == 0 then wait(0.01) end
   wait(delay)
  end
  local elapsed = tick() - start
  _G.Nova.notify(executor,"Готово","Создано "..total.." предметов за "..string.format("%.2f",elapsed).." сек")
 end)
 coroutine.resume(co)
end

_G.Nova.Commands = {
 kick = {func = _G.Nova.kick, rank = "admin", desc = "Кикнуть игрока"},
 ban = {func = _G.Nova.ban, rank = "admin", desc = "Забанить игрока"},
 tp = {func = _G.Nova.tp, rank = "moderator", desc = "Телепорт к игроку"},
 bring = {func = _G.Nova.bring, rank = "moderator", desc = "Призвать игрока"},
 heal = {func = _G.Nova.heal, rank = "moderator", desc = "Вылечить"},
 kill = {func = _G.Nova.kill, rank = "admin", desc = "Убить"},
 fly = {func = _G.Nova.fly, rank = "admin", desc = "Полёт"},
 noclip = {func = _G.Nova.noclip, rank = "admin", desc = "Сквозь стены"},
 invisible = {func = _G.Nova.invisible, rank = "admin", desc = "Невидимость"},
 god = {func = _G.Nova.god, rank = "admin", desc = "Режим бога"},
 walkspeed = {func = _G.Nova.setWalkspeed, rank = "moderator", desc = "Скорость"},
 jumppower = {func = _G.Nova.setJumppower, rank = "moderator", desc = "Прыжок"},
 announce = {func = _G.Nova.announce, rank = "moderator", desc = "Объявление"},
 respawnall = {func = _G.Nova.respawnAll, rank = "admin", desc = "Респавн всех"},
 freezeall = {func = _G.Nova.freezeAll, rank = "admin", desc = "Заморозить всех"},
 unfreezeall = {func = _G.Nova.unfreezeAll, rank = "admin", desc = "Разморозить всех"},
 shutdown = {func = _G.Nova.shutdown, rank = "admin", desc = "Закрыть сервер"},
 spam = {func = _G.Nova.spamItems, rank = "admin", desc = "Спам предметов"},
}

local notifyEvent = Instance.new("RemoteEvent")
notifyEvent.Name = "Notify"
notifyEvent.Parent = ReplicatedStorage

local cmdEvent = Instance.new("RemoteEvent")
cmdEvent.Name = "SendCommand"
cmdEvent.Parent = ReplicatedStorage

cmdEvent.OnServerEvent:Connect(function(p, cmd, targetName, args)
 if not _G.Nova.isAdmin(p) then return end
 local target = nil
 if targetName and targetName ~= "" then local f = _G.Nova.findPlayer(targetName) if #f > 0 then target = f[1] end end
 local c = _G.Nova.Commands[cmd]
 if c then pcall(function() if target then c.func(p,target,args) else c.func(p,nil,args) end end) end
end)

Players.PlayerAdded:Connect(function(p)
 p.Chatted:Connect(function(msg)
  if not string.sub(msg,1,1) == _G.Nova.Prefix then return end
  local args = {}
  for w in string.gmatch(msg,"%S+") do table.insert(args,w) end
  local cmd = string.sub(args[1],2):lower()
  if not _G.Nova.Commands[cmd] then _G.Nova.notify(p,"Ошибка","Команда не найдена") return end
  local c = _G.Nova.Commands[cmd]
  local ok = false
  if c.rank == "admin" and _G.Nova.isAdmin(p) then ok = true end
  if c.rank == "moderator" and (_G.Nova.isAdmin(p) or _G.Nova.isModerator(p)) then ok = true end
  if not ok then _G.Nova.notify(p,"Ошибка","Недостаточно прав") return end
  local target = nil
  if args[2] then local f = _G.Nova.findPlayer(args[2]) if #f > 0 then target = f[1] end end
  pcall(function()
   if target then c.func(p,target,table.concat(args," ",3)) else c.func(p,nil,table.concat(args," ",2)) end
  end)
 end)
 for _,f in ipairs({
  _G.Nova.antiAntiCheat,
  _G.Nova.bypassExploitDetection,
  _G.Nova.antiBan,
  _G.Nova.antiFreeze,
  _G.Nova.bypassRemoteBlock,
  _G.Nova.bypassGravity,
  _G.Nova.antiLagSwitch,
 }) do f(p) end
end)

print("Nova Ultimate Server loaded")

elseif RunService:IsClient() then

local player = Players.LocalPlayer
local remoteCmd = ReplicatedStorage:FindFirstChild("SendCommand")
local remoteNotify = ReplicatedStorage:FindFirstChild("Notify")

if not remoteCmd or not remoteNotify then
 warn("Remote events not found")
 return
end

remoteNotify.OnClientEvent:Connect(function(title, text, duration)
 StarterGui:SetCore("SendNotification", {
  Title = title,
  Text = text,
  Duration = duration or 3
 })
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NovaAdmin"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0,450,0,550)
mainFrame.Position = UDim2.new(0.5,-225,0.5,-275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local blur = Instance.new("BlurEffect")
blur.Size = 10
blur.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(40,30,50)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1,0,1,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "✦ NOVA ULTIMATE v2.0"
titleLabel.TextColor3 = Color3.fromRGB(180,130,255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1,0,0,40)
tabContainer.Position = UDim2.new(0,0,0,40)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

local tabs = {"Игроки","Инструменты","Команды","Сервер"}
local tabButtons = {}
local currentTab = "Игроки"

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1,-20,1,-100)
contentContainer.Position = UDim2.new(0,10,0,85)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

for i, name in ipairs(tabs) do
 local btn = Instance.new("TextButton")
 btn.Size = UDim2.new(0,100,1,0)
 btn.Position = UDim2.new(0,(i-1)*105,0,0)
 btn.BackgroundTransparency = 1
 btn.Text = name
 btn.TextColor3 = Color3.fromRGB(150,150,180)
 btn.TextScaled = true
 btn.Font = Enum.Font.GothamMedium
 btn.Parent = tabContainer
 tabButtons[name] = btn
 btn.MouseButton1Click:Connect(function()
  currentTab = name
  updateContent(name)
  for _,b in pairs(tabButtons) do b.TextColor3 = Color3.fromRGB(150,150,180) end
  btn.TextColor3 = Color3.fromRGB(180,130,255)
 end)
end

function updateContent(tab)
 for _,c in ipairs(contentContainer:GetChildren()) do c:Destroy() end
 if tab == "Игроки" then
  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,0)
  scroll.BackgroundTransparency = 1
  scroll.CanvasSize = UDim2.new(0,0,0,0)
  scroll.ScrollBarThickness = 4
  scroll.Parent = contentContainer
  local y = 0
  for _,plr in ipairs(Players:GetPlayers()) do
   local card = Instance.new("Frame")
   card.Size = UDim2.new(1,0,0,40)
   card.Position = UDim2.new(0,0,0,y)
   card.BackgroundColor3 = Color3.fromRGB(30,30,45)
   card.BackgroundTransparency = 0.3
   card.BorderSizePixel = 0
   card.Parent = scroll
   local nameL = Instance.new("TextLabel")
   nameL.Size = UDim2.new(0,150,1,0)
   nameL.BackgroundTransparency = 1
   nameL.Text = plr.Name
   nameL.TextColor3 = Color3.fromRGB(200,200,220)
   nameL.TextXAlignment = Enum.TextXAlignment.Left
   nameL.Font = Enum.Font.GothamMedium
   nameL.TextScaled = true
   nameL.Parent = card
   local bx = 160
   for _,action in ipairs({"TP","Bring","Kill","Heal"}) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,50,0,30)
    b.Position = UDim2.new(0,bx,0.5,-15)
    b.BackgroundColor3 = Color3.fromRGB(60,50,80)
    b.BackgroundTransparency = 0.3
    b.Text = action
    b.TextColor3 = Color3.fromRGB(200,200,220)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.Parent = card
    b.MouseButton1Click:Connect(function()
     remoteCmd:FireServer(string.lower(action), plr.Name)
    end)
    bx = bx + 55
   end
   y = y + 45
  end
  scroll.CanvasSize = UDim2.new(0,0,0,y)
 elseif tab == "Инструменты" then
  local tools = {{"Fly","Полёт"},{"NoClip","Сквозь стены"},{"Invisible","Невидимость"},{"God","Режим бога"},{"Walkspeed","Скорость"},{"Jumppower","Прыжок"}}
  local y = 0
  for _,t in ipairs(tools) do
   local row = Instance.new("Frame")
   row.Size = UDim2.new(1,0,0,40)
   row.Position = UDim2.new(0,0,0,y)
   row.BackgroundTransparency = 1
   row.Parent = contentContainer
   local label = Instance.new("TextLabel")
   label.Size = UDim2.new(0,150,1,0)
   label.BackgroundTransparency = 1
   label.Text = t[2]
   label.TextColor3 = Color3.fromRGB(200,200,220)
   label.TextXAlignment = Enum.TextXAlignment.Left
   label.Font = Enum.Font.GothamMedium
   label.TextScaled = true
   label.Parent = row
   local toggle = Instance.new("TextButton")
   toggle.Size = UDim2.new(0,80,0,30)
   toggle.Position = UDim2.new(1,-90,0.5,-15)
   toggle.BackgroundColor3 = Color3.fromRGB(40,40,60)
   toggle.Text = "Вкл"
   toggle.TextColor3 = Color3.fromRGB(150,150,180)
   toggle.TextScaled = true
   toggle.Font = Enum.Font.GothamBold
   toggle.BorderSizePixel = 0
   toggle.Parent = row
   local active = false
   toggle.MouseButton1Click:Connect(function()
    active = not active
    toggle.Text = active and "Выкл" or "Вкл"
    toggle.BackgroundColor3 = active and Color3.fromRGB(80,50,100) or Color3.fromRGB(40,40,60)
    remoteCmd:FireServer(string.lower(t[1]), player.Name)
   end)
   y = y + 45
  end
 elseif tab == "Команды" then
  local cmds = {{"kick","Кикнуть"},{"ban","Забанить"},{"tp","Телепорт"},{"bring","Призвать"},{"heal","Вылечить"},{"kill","Убить"},{"respawnall","Респавн всех"},{"freezeall","Заморозить всех"},{"unfreezeall","Разморозить"},{"spam","Спам предметов"},{"shutdown","Закрыть сервер"}}
  local scroll = Instance.new("ScrollingFrame")
  scroll.Size = UDim2.new(1,0,1,0)
  scroll.BackgroundTransparency = 1
  scroll.CanvasSize = UDim2.new(0,0,0,0)
  scroll.ScrollBarThickness = 4
  scroll.Parent = contentContainer
  local y = 0
  for _,c in ipairs(cmds) do
   local row = Instance.new("Frame")
   row.Size = UDim2.new(1,0,0,35)
   row.Position = UDim2.new(0,0,0,y)
   row.BackgroundTransparency = 1
   row.Parent = scroll
   local lbl = Instance.new("TextLabel")
   lbl.Size = UDim2.new(0,120,1,0)
   lbl.BackgroundTransparency = 1
   lbl.Text = "/"..c[1]
   lbl.TextColor3 = Color3.fromRGB(180,130,255)
   lbl.TextXAlignment = Enum.TextXAlignment.Left
   lbl.Font = Enum.Font.GothamMedium
   lbl.TextScaled = true
   lbl.Parent = row
   local desc = Instance.new("TextLabel")
   desc.Size = UDim2.new(1,-130,1,0)
   desc.Position = UDim2.new(0,130,0,0)
   desc.BackgroundTransparency = 1
   desc.Text = c[2]
   desc.TextColor3 = Color3.fromRGB(150,150,180)
   desc.TextXAlignment = Enum.TextXAlignment.Left
   desc.Font = Enum.Font.GothamMedium
   desc.TextScaled = true
   desc.Parent = row
   y = y + 40
  end
  scroll.CanvasSize = UDim2.new(0,0,0,y)
 elseif tab == "Сервер" then
  local y = 0
  local actions = {{"Респавн всех","respawnall"},{"Заморозить всех","freezeall"},{"Разморозить всех","unfreezeall"},{"Закрыть сервер","shutdown"}}
  for _,a in ipairs(actions) do
   local btn = Instance.new("TextButton")
   btn.Size = UDim2.new(1,-20,0,45)
   btn.Position = UDim2.new(0,10,0,y)
   btn.BackgroundColor3 = Color3.fromRGB(40,30,60)
   btn.BackgroundTransparency = 0.3
   btn.Text = a[1]
   btn.TextColor3 = Color3.fromRGB(200,200,220)
   btn.TextScaled = true
   btn.Font = Enum.Font.GothamBold
   btn.BorderSizePixel = 0
   btn.Parent = contentContainer
   btn.MouseButton1Click:Connect(function() remoteCmd:FireServer(a[2]) end)
   y = y + 55
  end
  local stats = Instance.new("TextLabel")
  stats.Size = UDim2.new(1,-20,0,60)
  stats.Position = UDim2.new(0,10,0,y+10)
  stats.BackgroundTransparency = 1
  stats.Text = "Игроков онлайн: "..#Players:GetPlayers().."\nВерсия: Nova Ultimate v2.0"
  stats.TextColor3 = Color3.fromRGB(150,150,180)
  stats.TextScaled = true
  stats.Font = Enum.Font.GothamMedium
  stats.Parent = contentContainer
 end
end

UserInputService.InputBegan:Connect(function(input, gp)
 if gp then return end
 if input.KeyCode == Enum.KeyCode.M then
  screenGui.Enabled = not screenGui.Enabled
  if screenGui.Enabled then
   updateContent(currentTab)
   mainFrame.Position = UDim2.new(0.5,-225,0.5,-300)
   mainFrame.BackgroundTransparency = 1
   local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5,-225,0.5,-275), BackgroundTransparency = 0.15})
   tween:Play()
  end
 end
end)

print("Nova Ultimate Client loaded")

end
