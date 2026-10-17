local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local C = require(game.ReplicatedStorage.ZeroShared.Config)
local Characters = require(script.Parent.Characters)
local Combat = require(script.Parent.Combat)
local Bots = {active = {}}
local rng = Random.new()
function Bots.spawn(index)
	local m = Characters.create("VEX_BOT_" .. index, "Bravo", Characters.spawnPosition("Bravo"))
	m:SetAttribute("Bot", true)
	m.Parent = workspace
	m.HumanoidRootPart:SetNetworkOwner(nil)
	local brain = {model = m, index = index, nextPath = 0, waypoints = {}, waypoint = 1, computing = false, target = nil, spottedAt = 0}
	Bots.active[m] = brain
	Characters.register(m, function()
		Bots.active[m] = nil
		task.delay(C.RespawnTime, function() Bots.spawn(index) end)
	end)
	Combat.register(m)
	return m
end
local function visible(m, target)
	local params = RaycastParams.new() params.FilterDescendantsInstances = {m}
	local result = workspace:Raycast(m.Head.Position, target.Head.Position - m.Head.Position, params)
	return result and result.Instance:IsDescendantOf(target)
end
function Bots.think()
	if workspace:GetAttribute("ZeroPhase") ~= "ACTIVE" then return end
	local time = workspace:GetServerTimeNow()
	for m, b in Bots.active do
		if not m.Parent or m.Humanoid.Health <= 0 then continue end
		local target, distance = nil, 220
		for _, player in Players:GetPlayers() do
			local char = player.Character
			if char and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid") and char.Humanoid.Health > 0
				and char:GetAttribute("Faction") ~= m:GetAttribute("Faction") and math.abs(char.HumanoidRootPart.Position.Z) < 100 then
				local d = (char.HumanoidRootPart.Position - m.HumanoidRootPart.Position).Magnitude
				if d < distance then target, distance = char, d end
			end
		end
		local goal = if target then target.HumanoidRootPart.Position else Vector3.new(0, 3, -55)
		local los = target and visible(m, target)
		if target ~= b.target or not los then b.spottedAt = time end
		b.target = target
		if los then
			local root = m.HumanoidRootPart
			root.CFrame = CFrame.lookAt(root.Position, Vector3.new(goal.X, root.Position.Y, goal.Z))
			m.Humanoid:MoveTo(if distance > 60 then goal else root.Position)
			if time - b.spottedAt >= C.BotReactionTime then
				local jitter = Vector3.new(rng:NextNumber(-1, 1), rng:NextNumber(-1, 1), rng:NextNumber(-1, 1)) * C.BotSpread * distance
				Combat.fire(m, (target.UpperTorso.Position + jitter - m.Head.Position).Unit)
			end
		else
			if time >= b.nextPath and not b.computing then
				b.nextPath, b.computing = time + 1.25, true
				task.spawn(function()
					local path = PathfindingService:CreatePath({AgentRadius = 2, AgentHeight = 6, AgentCanJump = true, WaypointSpacing = 6})
					local ok = pcall(function() path:ComputeAsync(m.HumanoidRootPart.Position, goal) end)
					if ok and path.Status == Enum.PathStatus.Success and m.Parent then
						b.waypoints, b.waypoint = path:GetWaypoints(), 2
					end
					b.computing = false
				end)
			end
			local waypoint = b.waypoints[b.waypoint]
			if waypoint then
				if (m.HumanoidRootPart.Position - waypoint.Position).Magnitude < 4 then b.waypoint += 1 end
				if waypoint.Action == Enum.PathWaypointAction.Jump then m.Humanoid.Jump = true end
				m.Humanoid:MoveTo(waypoint.Position)
			else m.Humanoid:MoveTo(goal) end
		end
		local state = Combat.states[m]
		if state and state.ammo == 0 then Combat.reload(m) end
	end
end
return Bots
