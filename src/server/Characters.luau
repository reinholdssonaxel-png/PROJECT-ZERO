local C = require(game.ReplicatedStorage.ZeroShared.Config)
local Factory = require(game.ReplicatedStorage.ZeroShared.RigFactory)
local Layout = require(game.ReplicatedStorage.ZeroShared.MapLayout)
local Characters = {records = {}}
function Characters.create(name, faction, position, heroId)
 local m = Factory.create(name, faction, position, heroId)
 local health = Instance.new("Script") health.Name = "Health" health.Parent = m
 return m
end
function Characters.spawnPosition(faction)
	return Layout.spawnPosition(faction)
end
function Characters.register(m, onDeath)
	local h = m:FindFirstChildOfClass("Humanoid")
	local r = {model = m, humanoid = h, lastDamage = -math.huge, lastHealth = h.Health, spawnUntil = workspace:GetServerTimeNow() + 2}
	Characters.records[m] = r
	m:SetAttribute("ProtectedUntil", r.spawnUntil)
	h.HealthChanged:Connect(function(value)
		if value < r.lastHealth then r.lastDamage = workspace:GetServerTimeNow() end
		r.lastHealth = value
	end)
	h.Died:Once(function()
		m:SetAttribute("RespawnAt", workspace:GetServerTimeNow() + C.RespawnTime)
		if onDeath then onDeath(m) end
		task.delay(C.RespawnTime, function() Characters.records[m] = nil m:Destroy() end)
	end)
	return r
end
function Characters.regenerate(dt)
	local now = workspace:GetServerTimeNow()
	for m, r in Characters.records do
		if not m.Parent then Characters.records[m] = nil
		elseif r.humanoid.Health > 0 and now - r.lastDamage >= C.RegenDelay then
			r.humanoid.Health = math.min(r.humanoid.MaxHealth, r.humanoid.Health + C.RegenRate * dt)
		end
	end
end
return Characters
