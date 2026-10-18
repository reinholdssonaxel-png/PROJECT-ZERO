local PathfindingService=game:GetService("PathfindingService")
local C=require(game.ReplicatedStorage.ZeroShared.Config)
local Layout=require(game.ReplicatedStorage.ZeroShared.MapLayout)
local Characters=require(script.Parent.Characters)
local Combat=require(script.Parent.Combat)
local Bots={active={},generation=0}
local rng=Random.new()
function Bots.reset()
 Bots.generation+=1
 for m in Bots.active do m:Destroy() end
 table.clear(Bots.active)
end
function Bots.spawn(index,faction)
 faction=faction or "Bravo"
 local m=Characters.create("VEX_BOT_"..index.."_"..faction,faction,Characters.spawnPosition(faction))
 m:SetAttribute("Bot",true) m.Parent=workspace
 if faction=="Alpha" then m:PivotTo(CFrame.new(m:GetPivot().Position)*CFrame.Angles(0,math.pi,0)) end
 m.HumanoidRootPart:SetNetworkOwner(nil)
 local b={model=m,index=index,faction=faction,stage=1,route=Layout.route(faction,if index%2==1 then 1 else 2),nextPath=0,waypoints={},waypoint=1,computing=false,spottedAt=0,shots=0}
 Bots.active[m]=b
 local generation=Bots.generation
 Characters.register(m,function()
  Bots.active[m]=nil
  task.delay(C.RespawnTime,function() if generation==Bots.generation and workspace:GetAttribute("ZeroPhase")=="ACTIVE" then Bots.spawn(index,faction) end end)
 end)
 Combat.register(m)
 return m,b
end
function Bots.visible(m,target)
 local params=RaycastParams.new() params.FilterDescendantsInstances={m}
 local hit=workspace:Raycast(m.Head.Position,target.Head.Position-m.Head.Position,params)
 return hit~=nil and hit.Instance:IsDescendantOf(target)
end
local function navigate(b,goal,time)
 local m=b.model
 if not b.goal or (b.goal-goal).Magnitude>8 then b.nextPath=0 b.waypoints={} end
 b.goal=goal
 if time>=b.nextPath and not b.computing then
  b.nextPath=time+1.2 b.computing=true
  task.spawn(function()
   local path=PathfindingService:CreatePath({AgentRadius=2.5,AgentHeight=6,AgentCanJump=true,WaypointSpacing=5})
   local ok=pcall(function() path:ComputeAsync(m.HumanoidRootPart.Position,goal) end)
   if m.Parent and ok and path.Status==Enum.PathStatus.Success and b.goal and (b.goal-goal).Magnitude<8 then
    b.waypoints=path:GetWaypoints() b.waypoint=2 m:SetAttribute("BotPathStatus","Success")
   elseif m.Parent then m:SetAttribute("BotPathStatus","NoPath") end
   b.computing=false
  end)
 end
 local p=b.waypoints[b.waypoint]
 if p and (m.HumanoidRootPart.Position-p.Position).Magnitude<4.5 then b.waypoint+=1 p=b.waypoints[b.waypoint] end
 if p then
  if p.Action==Enum.PathWaypointAction.Jump then m.Humanoid.Jump=true end
  m.Humanoid:MoveTo(p.Position)
 else m.Humanoid:MoveTo(m.HumanoidRootPart.Position) end
end
-- The same brain entry point is exercised with real R15 targets by Studio tests.
function Bots.step(b,time,candidates)
 local m=b.model
 if not m.Parent or m.Humanoid.Health<=0 then return end
 local node=b.route[b.stage]
 if node and (m.HumanoidRootPart.Position-node).Magnitude<6 then b.stage+=1 node=b.route[b.stage] end
 m:SetAttribute("BotStage",b.stage)
 if node and b.stage<=7 then navigate(b,node,time) return end
 local target,distance=nil,230
 if Layout.inCombatArea(m.HumanoidRootPart.Position) then
  for _,char in candidates do
   if char~=m and char.Parent and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.Health>0 and char:GetAttribute("Faction")~=b.faction and Layout.inCombatArea(char.HumanoidRootPart.Position) then
    local d=(char.HumanoidRootPart.Position-m.HumanoidRootPart.Position).Magnitude
    if d<distance then target,distance=char,d end
   end
  end
 end
 local los=target and Bots.visible(m,target)
 if target~=b.target or not los then b.spottedAt=time end
 b.target=target m:SetAttribute("BotTarget",if target then target.Name else "")
 if los then
  local root=m.HumanoidRootPart local goal=target.HumanoidRootPart.Position
  root.CFrame=CFrame.lookAt(root.Position,Vector3.new(goal.X,root.Position.Y,goal.Z))
  if distance>60 then navigate(b,goal,time) else m.Humanoid:MoveTo(root.Position) end
  if time-b.spottedAt>=C.BotReactionTime then
   local jitter=Vector3.new(rng:NextNumber(-1,1),rng:NextNumber(-1,1),rng:NextNumber(-1,1))*C.BotSpread*distance
   if Combat.fire(m,(target.UpperTorso.Position+jitter-m.Head.Position).Unit) then b.shots+=1 m:SetAttribute("BotShots",b.shots) end
  end
 else navigate(b,Vector3.new(0,3,0),time) end
 local state=Combat.states[m] if state and state.ammo==0 then Combat.reload(m) end
end
function Bots.think()
 if workspace:GetAttribute("ZeroPhase")~="ACTIVE" then return end
 local targets={} for m in Characters.records do if m.Parent then table.insert(targets,m) end end
 for _,b in Bots.active do Bots.step(b,workspace:GetServerTimeNow(),targets) end
end
return Bots
