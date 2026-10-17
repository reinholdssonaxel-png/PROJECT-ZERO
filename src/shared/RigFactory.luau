local C = require(script.Parent.Config)
local G = require(script.Parent.Geometry)
local Catalog = require(script.Parent.HeroCatalog)
local Style = require(script.Parent.HeroStyle)
local Factory = {}
function Factory.create(name, faction, position, heroId)
 heroId = heroId or "VEX"
 local hero = assert(Catalog.Heroes[heroId], "Unknown hero")
	local m = Instance.new("Model")
	m.Name = name
	m:SetAttribute("Faction", faction)
	m:SetAttribute("Hero", heroId)
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
	h.RigType, h.MaxHealth, h.Health, h.WalkSpeed, h.HipHeight = Enum.HumanoidRigType.R15, hero.HP, hero.HP, C.WalkSpeed, 2.1
	h.DisplayName, h.BreakJointsOnDeath = heroId, false
	h.Parent = m
	Instance.new("Animator", h)
	Style.decorate(m, heroId, faction)
	m.PrimaryPart = m.HumanoidRootPart
	m:ScaleTo(hero.Scale)
	return m
end

return Factory
