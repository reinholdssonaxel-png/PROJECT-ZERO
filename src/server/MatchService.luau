local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local C=require(game.ReplicatedStorage.ZeroShared.Config)
local Characters=require(script.Parent.Characters)
local Combat=require(script.Parent.Combat)
local Bots=require(script.Parent.Bots)
local Match={doors={},round=0,buckets={},selectSerial={}}
local function now() return workspace:GetServerTimeNow() end
local function phase(p,value) p:SetAttribute("ZeroSession",value) end
local function removeCharacter(p)
 local m=p.Character p.Character=nil if m then m:Destroy() end
end
local function freeze(p,value)
 local m=p.Character if not m then return end
 m.HumanoidRootPart.Anchored=value m.Humanoid.WalkSpeed=if value then 0 else C.WalkSpeed
 m.Humanoid.JumpPower=if value then 0 else 42
 if not value then m.HumanoidRootPart:SetNetworkOwner(p) end
end
function Match.setDoors(open)
 for _,d in Match.doors do
  local closed=d:GetAttribute("ClosedCFrame") d.CanCollide=not open d.CanQuery=not open
  TweenService:Create(d,TweenInfo.new(.6),{CFrame=if open then closed+Vector3.new(0,16,0) else closed}):Play()
 end
end
function Match.participants()
 local n=0 for _,p in Players:GetPlayers() do local s=p:GetAttribute("ZeroSession") if s=="ACTIVE" or s=="INSPECT" or s=="PREPARE" then n+=1 end end return n
end
function Match.reset()
 Match.round+=1 Bots.reset() workspace:SetAttribute("ZeroPhase","IDLE") workspace:SetAttribute("ZeroRoundEnd",0) Match.setDoors(false)
end
function Match.finishRound()
 Match.round+=1 Bots.reset() workspace:SetAttribute("ZeroPhase","RESULTS")
 for _,p in Players:GetPlayers() do
  local s=p:GetAttribute("ZeroSession")
  if s=="ACTIVE" or s=="INSPECT" or s=="PREPARE" then
   p:SetAttribute("ZeroResultKills",p.leaderstats.Kills.Value) p:SetAttribute("ZeroResultDeaths",p.leaderstats.Deaths.Value)
   phase(p,"RESULTS") removeCharacter(p)
  end
 end
 Match.setDoors(false)
end
function Match.startRound()
 Match.round+=1 local token=Match.round
 workspace:SetAttribute("ZeroPhase","PREPARE") workspace:SetAttribute("ZeroPhaseEnd",now()+C.PreparationTime)
 Match.setDoors(false)
 task.delay(C.PreparationTime,function()
  if Match.round~=token or Match.participants()==0 then return end
  workspace:SetAttribute("ZeroPhase","ACTIVE") workspace:SetAttribute("ZeroRoundEnd",now()+180) Match.setDoors(true)
  for _,p in Players:GetPlayers() do if p:GetAttribute("ZeroSession")=="PREPARE" then phase(p,"ACTIVE") freeze(p,false) end end
  for i=1,C.BotCount do Bots.spawn(i) end
  task.delay(180,function() if Match.round==token then Match.finishRound() end end)
 end)
end
function Match.spawn(p)
 if p.Parent~=Players then return end
 local session=p:GetAttribute("ZeroSession")
 if session~="ACTIVE" and session~="PREPARE" and session~="INSPECT" then return end
 removeCharacter(p)
 local faction=p.Team.Name
 local m=Characters.create(p.Name,faction,Characters.spawnPosition(faction)) m.Parent=workspace
 if faction=="Alpha" then m:PivotTo(CFrame.new(m:GetPivot().Position)*CFrame.Angles(0,math.pi,0)) end
 Characters.register(m,function()
  p.leaderstats.Deaths.Value+=1
  task.delay(C.RespawnTime,function() if p.Parent==Players and (p:GetAttribute("ZeroSession")=="ACTIVE" or p:GetAttribute("ZeroSession")=="INSPECT") then phase(p,"ACTIVE") Match.spawn(p) end end)
 end)
 Combat.register(m) p.Character=m p.CameraMode=Enum.CameraMode.LockFirstPerson
 freeze(p,session=="PREPARE" or session=="INSPECT")
end
function Match.deploy(p,hero)
 if p:GetAttribute("ZeroSession")~="SELECT" or hero~="VEX" then return false end
 p.leaderstats.Kills.Value=0 p.leaderstats.Deaths.Value=0
 local roundPhase=workspace:GetAttribute("ZeroPhase")
 if roundPhase~="ACTIVE" and roundPhase~="PREPARE" then Match.startRound() roundPhase="PREPARE" end
 phase(p,roundPhase) Match.spawn(p) return true
end
function Match.request(p,action,arg)
 local t=now() local b=Match.buckets[p] or {tokens=8,time=t}
 b.tokens=math.min(8,b.tokens+(t-b.time)*4) b.time=t Match.buckets[p]=b
 if b.tokens<1 then return end b.tokens-=1
 local s=p:GetAttribute("ZeroSession")
 if action=="Play" and (s=="MENU" or s=="RESULTS") then
  phase(p,"SELECT") Match.selectSerial[p]=(Match.selectSerial[p] or 0)+1 local serial=Match.selectSerial[p]
  p:SetAttribute("ZeroSelectEnd",t+30)
  task.delay(30,function() if p.Parent==Players and Match.selectSerial[p]==serial and p:GetAttribute("ZeroSession")=="SELECT" then Match.deploy(p,"VEX") end end)
 elseif action=="Deploy" then Match.deploy(p,arg)
 elseif action=="Menu" then
  phase(p,"MENU") removeCharacter(p)
  if Match.participants()==0 then Match.reset() end
 elseif action=="Inspect" and s=="ACTIVE" then phase(p,"INSPECT") freeze(p,true)
 elseif action=="Resume" and s=="INSPECT" then phase(p,"ACTIVE") freeze(p,false) end
end
function Match.addPlayer(p)
 phase(p,"MENU")
 removeCharacter(p)
end
return Match
