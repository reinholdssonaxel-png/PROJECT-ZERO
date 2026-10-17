-- Run only in a Studio server play session:
-- require(game.ServerStorage.ZeroTests["Combat.spec"]).run()
local Suite = {}
function Suite.run()
	local C = require(game.ReplicatedStorage.ZeroShared.Config)
	local Rules = require(game.ReplicatedStorage.ZeroShared.WeaponRules)
	local Characters = require(game.ServerScriptService.ZeroServer.Characters)
	local Combat = require(game.ServerScriptService.ZeroServer.Combat)
	assert(workspace:GetAttribute("ZeroPhase") == "ACTIVE", "Wait for preparation to finish")
	local checks = 0
	local function check(condition, message) assert(condition, message) checks += 1 end
	local shooter, target
	local ok, err = xpcall(function()
		check(not Rules.direction(nil), "nil direction")
		check(not Rules.direction(Vector3.zero), "zero direction")
		check(not Rules.direction(Vector3.new(0/0, 0, 0)), "NaN direction")
		check(not Rules.direction(Vector3.new(math.huge, 0, 0)), "infinite direction")
		check(not Rules.direction(Vector3.new(0, 0, -20)), "scaled direction")
		shooter = Characters.create("TestShooter", "Alpha", Vector3.new(0, 35, -50))
		target = Characters.create("TestTarget", "Bravo", Vector3.new(0, 35, -30))
		shooter.Parent, target.Parent = workspace, workspace
		shooter.HumanoidRootPart.Anchored, target.HumanoidRootPart.Anchored = true, true
		Characters.register(shooter) Characters.register(target)
		target:SetAttribute("ProtectedUntil", 0)
		local state = Combat.register(shooter)
		Combat.register(target)
		local function aim(part) return (part.Position - shooter.Head.Position).Unit end
		check(Combat.fire(shooter, aim(target.UpperTorso)), "first shot accepted")
		check(target.Humanoid.Health == 262, "body shot is 13 damage")
		check(state.ammo == 35, "authoritative ammo decremented")
		check(not Combat.fire(shooter, aim(target.Head)), "rapid request rejected")
		state.lastShot = -math.huge
		check(Combat.fire(shooter, aim(target.Head)), "headshot accepted")
		check(target.Humanoid.Health == 242.5, "headshot multiplier is 1.5")
		local health = target.Humanoid.Health
		target:SetAttribute("Faction", "Alpha")
		state.lastShot = -math.huge Combat.fire(shooter, aim(target.Head))
		check(target.Humanoid.Health == health, "friendly fire blocked")
		target:SetAttribute("Faction", "Bravo")
		local wall = Instance.new("Part")
		wall.Name, wall.Size, wall.Anchored = "TestOccluder", Vector3.new(10, 12, 1), true
		wall.CFrame = CFrame.new(0, 39, -40) wall.Parent = workspace
		state.lastShot = -math.huge Combat.fire(shooter, aim(target.Head))
		wall:Destroy()
		check(target.Humanoid.Health == health, "wall stops damage")
		local originalPivot = target:GetPivot()
		target:PivotTo(originalPivot + Vector3.new(1000, 0, 0))
		state.lastShot = -math.huge Combat.fire(shooter, aim(target.Head))
		check(target.Humanoid.Health == health, "weapon range enforced")
		target:PivotTo(originalPivot)
		local originalShooter = shooter:GetPivot()
		shooter:PivotTo(originalShooter + Vector3.new(0, 0, -80))
		local beforeAmmo = state.ammo
		check(not Combat.fire(shooter, aim(target.Head)) and state.ammo == beforeAmmo, "safe room blocks firing without spending ammo")
		shooter:PivotTo(originalShooter)
		target:SetAttribute("ProtectedUntil", workspace:GetServerTimeNow() + 100)
		check(not Combat.damage(shooter, target, 13), "spawn protection")
		target:SetAttribute("ProtectedUntil", 0)
		check(Combat.reload(shooter), "reload accepted")
		check(not Combat.fire(shooter, aim(target.Head)), "shooting during reload blocked")
		check(not Combat.reload(shooter), "duplicate reload blocked")
		task.wait(C.Weapon.ReloadTime + .1)
		check(state.ammo == 36 and state.reloadEnd == 0, "reload completes")
		state.ammo = 0 state.lastShot = -math.huge
		check(not Combat.fire(shooter, aim(target.Head)), "empty magazine blocked")
		state.ammo = 36
		local record = Characters.records[target]
		record.lastDamage = workspace:GetServerTimeNow()
		Characters.regenerate(.2)
		check(target.Humanoid.Health == health, "regen delay enforced")
		record.lastDamage -= 6
		Characters.regenerate(.2)
		check(math.abs(target.Humanoid.Health - health - 3) < .01, "regen at 15 HP per second")
		shooter.HumanoidRootPart.Anchored = false
		check(Combat.dash(shooter, Vector3.new(1, 0, 0)), "dash accepted")
		check(not Combat.dash(shooter, Vector3.new(1, 0, 0)), "dash cooldown enforced")
		check(state.nextDash > workspace:GetServerTimeNow() + 7, "eight second dash cooldown")
		task.wait(C.Dash.Duration + .05)
		check(shooter.HumanoidRootPart:FindFirstChildOfClass("LinearVelocity") == nil, "dash force removed after duration")
		shooter.Humanoid.Health = 0
		check(not Combat.fire(shooter, aim(target.Head)), "dead shooter rejected")
	end, debug.traceback)
	if shooter then Characters.records[shooter] = nil shooter:Destroy() end
	if target then Characters.records[target] = nil target:Destroy() end
	if not ok then error(err) end
	print("[PROJECT ZERO] PASS: " .. checks .. " combat assertions")
	return checks
end
return Suite
