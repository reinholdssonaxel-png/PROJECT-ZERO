-- All authoritative ammo, raycasts, damage and ability timing live here.
local Players = game:GetService("Players")
local C = require(game.ReplicatedStorage.ZeroShared.Config)
local Rules = require(game.ReplicatedStorage.ZeroShared.WeaponRules)
local Combat = {states = {}, buckets = {}}
local function now() return workspace:GetServerTimeNow() end
local function alive(m)
	local h = m and m:FindFirstChildOfClass("Humanoid")
	return h and h.Health > 0 and m:FindFirstChild("Head") and m:FindFirstChild("HumanoidRootPart")
end
local function safe(m) return math.abs(m.HumanoidRootPart.Position.Z) >= 100 end
function Combat.init(remotes)
	Combat.remotes = remotes
end
function Combat.register(m)
	local state = {ammo = C.Weapon.Magazine, lastShot = -math.huge, reloadEnd = 0, dashEnd = 0, nextDash = 0}
	Combat.states[m] = state
	Combat.sync(m)
	m.Destroying:Once(function() Combat.states[m] = nil end)
	return state
end
function Combat.sync(m)
	local s = Combat.states[m]
	if not s then return end
	m:SetAttribute("Ammo", s.ammo)
	m:SetAttribute("ReloadEnd", s.reloadEnd)
	m:SetAttribute("DashReadyAt", s.nextDash)
end
function Combat.allowed(m)
	return alive(m) and Combat.states[m] ~= nil and workspace:GetAttribute("ZeroPhase") == "ACTIVE"
end
function Combat.reload(m)
	local s = Combat.states[m]
	if not Combat.allowed(m) or s.reloadEnd ~= 0 or s.ammo == C.Weapon.Magazine then return false end
	s.reloadEnd = now() + C.Weapon.ReloadTime
	Combat.sync(m)
	task.delay(C.Weapon.ReloadTime, function()
		if Combat.states[m] == s and alive(m) then
			s.ammo, s.reloadEnd = C.Weapon.Magazine, 0
			Combat.sync(m)
		end
	end)
	return true
end
function Combat.damage(shooter, target, amount)
	if not alive(target) or not Rules.enemy(shooter, target) or safe(target) then return false end
	if now() < (target:GetAttribute("ProtectedUntil") or 0) then return false end
	local h = target:FindFirstChildOfClass("Humanoid")
	local shooterPlayer = Players:GetPlayerFromCharacter(shooter)
	if h.Health <= amount and shooterPlayer then
		local kills = shooterPlayer:FindFirstChild("leaderstats") and shooterPlayer.leaderstats:FindFirstChild("Kills")
		if kills then kills.Value += 1 end
	end
	h:TakeDamage(amount)
	return true
end
function Combat.fire(m, direction)
	if not Combat.allowed(m) or not Rules.direction(direction) or safe(m) then return false end
	local s, time = Combat.states[m], now()
	if not Rules.canFire(s, time, C.Weapon.FireInterval) then return false end
	s.ammo -= 1
	s.lastShot = time
	Combat.sync(m)
	local origin = m.Head.Position
	local params = RaycastParams.new()
	params.FilterType, params.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, {m}
	local result = workspace:Raycast(origin, direction.Unit * C.Weapon.Range, params)
	local endpoint = if result then result.Position else origin + direction.Unit * C.Weapon.Range
	local hit, headshot, killed = false, false, false
	if result then
		local target = result.Instance:FindFirstAncestorOfClass("Model")
		if target and target:FindFirstChildOfClass("Humanoid") then
			headshot = result.Instance.Name == "Head"
			hit = Combat.damage(m, target, C.Weapon.Damage * (if headshot then C.Weapon.HeadMultiplier else 1))
			killed = hit and target.Humanoid.Health <= 0
		end
	end
	Combat.remotes.FX:FireAllClients(m, origin, endpoint, hit, headshot, killed)
	return true, result
end
function Combat.dash(m, direction)
	if not Combat.allowed(m) or not Rules.direction(direction) then return false end
	local s, time = Combat.states[m], now()
	if time < s.nextDash then return false end
	local horizontal = Vector3.new(direction.X, 0, direction.Z)
	if horizontal.Magnitude < .1 then return false end
	horizontal = horizontal.Unit
	s.nextDash, s.dashEnd = time + C.Dash.Cooldown, time + C.Dash.Duration
	Combat.sync(m)
	local root = m.HumanoidRootPart
	-- A block sweep prevents dashing through thin walls, including spawn doors.
	local params = RaycastParams.new() params.FilterDescendantsInstances = {m}
	local distance = C.Dash.Speed * C.Dash.Duration
	local block = workspace:Blockcast(root.CFrame, Vector3.new(2, 4, 2), horizontal * distance, params)
	local speed = if block then math.max(0, block.Distance - 1) / C.Dash.Duration else C.Dash.Speed
	local canOwn = root:CanSetNetworkOwnership()
	if canOwn then root:SetNetworkOwner(nil) end
	local attachment = Instance.new("Attachment") attachment.Parent = root
	local velocity = Instance.new("LinearVelocity")
	velocity.Attachment0, velocity.RelativeTo = attachment, Enum.ActuatorRelativeTo.World
	velocity.MaxForce = 100000
	velocity.VectorVelocity = horizontal * speed + Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
	velocity.Parent = root
	task.delay(C.Dash.Duration, function()
		velocity:Destroy() attachment:Destroy()
		if root.Parent then
			root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
			if canOwn and Players:GetPlayerFromCharacter(m) then root:SetNetworkOwnershipAuto() end
		end
	end)
	return true
end
function Combat.request(player, action, direction)
	-- Token bucket covers malformed actions as well as valid requests.
	local t = now()
	local b = Combat.buckets[player] or {tokens = 24, time = t}
	b.tokens = math.min(24, b.tokens + (t - b.time) * 16)
	b.time = t
	Combat.buckets[player] = b
	if b.tokens < 1 then return end
	b.tokens -= 1
	local m = player.Character
	if not m or not m.Parent then return end
	if action == "Fire" then Combat.fire(m, direction)
	elseif action == "Reload" then Combat.reload(m)
	elseif action == "Dash" then Combat.dash(m, direction) end
end
return Combat
