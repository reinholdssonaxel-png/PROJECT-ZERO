local Suite={}
function Suite.run()
	local Layout=require(game.ReplicatedStorage.ZeroShared.MapLayout)
	local Pathfinding=game:GetService("PathfindingService")
	local Characters=require(game.ServerScriptService.ZeroServer.Characters)
	local Combat=require(game.ServerScriptService.ZeroServer.Combat)
	local Bots=require(game.ServerScriptService.ZeroServer.Bots)
	local arena=workspace.ZeroArena
	local report={assertions=0,rays=0,routes={}}
	local function check(ok,message) assert(ok,message) report.assertions+=1 end
	local params=RaycastParams.new() params.FilterType=Enum.RaycastFilterType.Include params.FilterDescendantsInstances={arena}
	local function distance(a,b)
		local path=Pathfinding:CreatePath({AgentRadius=2.5,AgentHeight=6,AgentCanJump=true,WaypointSpacing=4})
		path:ComputeAsync(a,b)
		check(path.Status==Enum.PathStatus.Success,"Navigation failed: "..tostring(a).." -> "..tostring(b))
		local waypoints=path:GetWaypoints() local length=0
		for i=2,#waypoints do length+=(waypoints[i].Position-waypoints[i-1].Position).Magnitude end
		return length
	end
	check(arena:GetAttribute("LayoutVersion")==2,"correct layout")
	for _,faction in {"Alpha","Bravo"} do
		check(Layout.isSafe(Layout.spawnPosition(faction)),faction.." spawn safe")
		local doors=0
		for _,v in arena:GetChildren() do if string.find(v.Name,faction) and string.find(v.Name,"Door") then doors+=1 check(not v.CanCollide,"test requires active/open doors") end end
		check(doors==2,faction.." has two doors")
		for _,target in Layout.exitSamples(faction) do
			for _,x in {-140,-104,-48,0,48,104,140} do for _,z in {-90,-70,0,70,90} do for _,height in {5.5,15.5,24} do
				local origin=Vector3.new(x,height,z)
				check(workspace:Raycast(origin,target-origin,params)~=nil,"EXPOSED EXIT: "..faction.." "..tostring(target).." from "..tostring(origin))
				report.rays+=1 if report.rays%160==0 then task.wait() end
			end end end
		end
		for exit=1,2 do
			local route=Layout.route(faction,exit)
			local length=distance(route[1],route[7])
			local seconds=length/Layout.WalkSpeed
			check(seconds>=7 and seconds<=15,"deployment traversal outside 7–15 s budget")
			table.insert(report.routes,{team=faction,exit=exit,length=length,seconds=seconds})
		end
	end
	for i=1,2 do check(math.abs(report.routes[i].length-report.routes[i+2].length)<10,"team route parity") end
	for _,x in {-110,36,110} do
		distance(Vector3.new(x,3,-90),Vector3.new(x,3,90))
		check(workspace:Raycast(Vector3.new(x,5.5,-90),Vector3.new(0,0,180),params)~=nil,"lane has an uninterrupted 180-stud shooting corridor")
	end
	-- Real server-authoritative bot brain + real R15 targets, no spawn invulnerability.
	Bots.reset()
	for _,faction in {"Alpha","Bravo"} do
		local enemy=if faction=="Alpha" then "Bravo" else "Alpha"
		local m,b=Bots.spawn(40,faction) Bots.active[m]=nil b.stage=8 m.HumanoidRootPart.Anchored=true
		m:PivotTo(CFrame.new(0,3.2,if faction=="Alpha" then -70 else 70))
		local target=Characters.create("SpawnSightTarget",enemy,Vector3.zero) target.Parent=workspace target.HumanoidRootPart.Anchored=true
		target:SetAttribute("ProtectedUntil",0)
		for _,p in Layout.exitSamples(enemy) do
			target:PivotTo(CFrame.new(p-Vector3.new(0,1.8,0)))
			local ammo=Combat.states[m].ammo
			Bots.step(b,workspace:GetServerTimeNow(),{target}) Bots.step(b,workspace:GetServerTimeNow()+1,{target})
			check(Combat.states[m].ammo==ammo and b.target==nil,"bot targets/shoots protected deployment")
		end
		m:PivotTo(CFrame.new(0,3.2,10)) target:PivotTo(CFrame.new(0,3.2,-10))
		b.target=nil b.spottedAt=0
		Bots.step(b,workspace:GetServerTimeNow(),{target})
		for n=1,5 do Combat.states[m].lastShot=-math.huge Bots.step(b,workspace:GetServerTimeNow()+1+n,{target}) end
		check(Combat.states[m].ammo<36 and target.Humanoid.Health<275,"bot can still engage at control point")
		Characters.records[m]=nil m:Destroy() target:Destroy()
	end
	if workspace:GetAttribute("ZeroPhase")=="ACTIVE" then Bots.spawn(1) end
	print("[PROJECT ZERO] Map verification: "..report.assertions.." checks / "..report.rays.." blocked exit rays")
	return report
end
return Suite
