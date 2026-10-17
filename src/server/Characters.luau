-- R15 placeholder rigs made from original Parts; no avatar/network dependency.
local C = require(game.ReplicatedStorage.ZeroShared.Config)
local G = require(game.ReplicatedStorage.ZeroShared.Geometry)
local Characters = {records = {}}
function Characters.create(name, faction, position)
	local m = Instance.new("Model")
	m.Name = name
	m:SetAttribute("Faction", faction)
	m:SetAttribute("Hero", "VEX")
	local dark = Color3.fromRGB(38, 43, 51)
	local pieces = {
		{"HumanoidRootPart", Vector3.new(2, 2, 1), Vector3.new(0, 3.1, 0)},
		{"LowerTorso", Vector3.new(1.8, .6, .9), Vector3.new(0, 2.8, 0), "HumanoidRootPart"},
		{"UpperTorso", Vector3.new(2, 1.2, 1), Vector3.new(0, 3.7, 0), "LowerTorso"},
		{"Head", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 4.9, 0), "UpperTorso"},
	}
	for _, side in {"Left", "Right"} do
		local s = if side == "Left" then -1 else 1
		table.insert(pieces, {side .. "UpperArm", Vector3.new(.65, 1.1, .7), Vector3.new(s * 1.35, 3.7, 0), "UpperTorso"})
		table.insert(pieces, {side .. "LowerArm", Vector3.new(.6, 1, .65), Vector3.new(s * 1.35, 2.65, 0), side .. "UpperArm"})
		table.insert(pieces, {side .. "Hand", Vector3.new(.6, .4, .65), Vector3.new(s * 1.35, 1.95, 0), side .. "LowerArm"})
		table.insert(pieces, {side .. "UpperLeg", Vector3.new(.8, 1, .85), Vector3.new(s * .5, 2, 0), "LowerTorso"})
		table.insert(pieces, {side .. "LowerLeg", Vector3.new(.75, 1, .8), Vector3.new(s * .5, 1, 0), side .. "UpperLeg"})
		table.insert(pieces, {side .. "Foot", Vector3.new(.8, .5, 1.1), Vector3.new(s * .5, .25, -.15), side .. "LowerLeg"})
	end
	local origin = CFrame.new(position)
	for _, data in pieces do
		local p = G.part(m, data[1], data[2], origin * CFrame.new(data[3]), dark)
		p.Anchored = false
		p.CanCollide = data[1] == "UpperTorso" or data[1] == "LowerTorso"
		p.Massless = data[1] ~= "HumanoidRootPart"
		if data[1] == "HumanoidRootPart" then p.Transparency = 1 end
		if data[4] then
			local parent = m[data[4]]
			local joint = Instance.new("Motor6D")
			joint.Name, joint.Part0, joint.Part1 = data[1] .. "Joint", parent, p
			joint.C0 = parent.CFrame:ToObjectSpace(p.CFrame)
			joint.Parent = parent
		end
	end
	local h = Instance.new("Humanoid")
	h.RigType, h.MaxHealth, h.Health, h.WalkSpeed, h.HipHeight = Enum.HumanoidRigType.R15, C.MaxHealth, C.MaxHealth, C.WalkSpeed, 2.1
	h.DisplayName, h.BreakJointsOnDeath = "VEX", false
	h.Parent = m
	Instance.new("Animator", h)
	-- Suppress Roblox's default health regeneration: our server owns its rules.
	local health = Instance.new("Script") health.Name = "Health" health.Parent = m
	local visor = G.part(m, "Visor", Vector3.new(1.22, .25, .12), m.Head.CFrame * CFrame.new(0, .15, -.62), Color3.fromRGB(255, 136, 35), Enum.Material.Neon)
	visor.Anchored, visor.CanCollide, visor.CanQuery, visor.Massless = false, false, false, true
	local weld = Instance.new("WeldConstraint") weld.Part0, weld.Part1, weld.Parent = m.Head, visor, visor
	local stripe = G.part(m, "TeamStripe", Vector3.new(1.5, .18, .1), m.UpperTorso.CFrame * CFrame.new(0, .25, -.55), if faction == "Alpha" then Color3.fromRGB(70, 220, 255) else Color3.fromRGB(255, 125, 40), Enum.Material.Neon)
	stripe.Anchored, stripe.CanCollide, stripe.CanQuery, stripe.Massless = false, false, false, true
	local sw = Instance.new("WeldConstraint") sw.Part0, sw.Part1, sw.Parent = m.UpperTorso, stripe, stripe
	local gun = G.rifle(m)
	gun:PivotTo(m.RightHand.CFrame * CFrame.new(0, -.1, -.9))
	for _, p in gun:GetChildren() do
		if p:IsA("BasePart") then
			p.Anchored, p.CanCollide, p.CanQuery, p.Massless = false, false, false, true
			local w = Instance.new("WeldConstraint") w.Part0, w.Part1, w.Parent = m.RightHand, p, p
		end
	end
	m.PrimaryPart = m.HumanoidRootPart
	return m
end
function Characters.spawnPosition(faction)
	return Vector3.new(0, 1.5, if faction == "Alpha" then -121 else 121)
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
			r.humanoid.Health = math.min(C.MaxHealth, r.humanoid.Health + C.RegenRate * dt)
		end
	end
end
return Characters
