local G = require(script.Parent.Geometry)
local Catalog = require(script.Parent.HeroCatalog)
local Weapons = {}
function Weapons.create(heroId, parent, preview)
	local hero = Catalog.Heroes[heroId]
	if heroId == "VEX" then return G.rifle(parent) end
	local mesh=G.meshWeapon(heroId,parent,preview)
	if mesh then return mesh end
	local m = Instance.new("Model") m.Name = "Weapon_" .. heroId
	local metal, dark, accent = Color3.fromRGB(90,103,116), Color3.fromRGB(31,38,45), hero.Accent
	local function p(name,size,pos,color,mat)
		return G.part(m,name,size,CFrame.new(pos),color or dark,mat)
	end
	local root=p("Receiver",Vector3.new(.32,.4,1.3),Vector3.zero)
	m.PrimaryPart=root
	if heroId=="ATLAS" then
		root.Transparency=1
		-- The two powered gauntlets are fitted directly to LeftHand/RightHand by HeroStyle.
		if preview then
			for _,x in {-.75,.75} do
				p("Gauntlet",Vector3.new(.9,.8,1.1),Vector3.new(x,0,0),hero.Primary)
				p("PowerRail",Vector3.new(.35,.15,.8),Vector3.new(x,.5,0),accent,Enum.Material.Neon)
			end
		end
	elseif heroId=="PHANTOM" then
		root.Transparency=1
		for _,x in {-.4,.4} do
			p("PistolSlide",Vector3.new(.25,.28,1.1),Vector3.new(x,.05,-.25))
			p("PistolGrip",Vector3.new(.22,.6,.3),Vector3.new(x,-.35,.05))
			p("SuppressedBarrel",Vector3.new(.2,.2,.5),Vector3.new(x,.03,-1),metal)
			p("PistolSight",Vector3.new(.08,.06,.3),Vector3.new(x,.22,-.35),accent,Enum.Material.Neon)
		end
		for _,part in m:GetChildren() do if part:IsA("BasePart") and part~=root then part:SetAttribute("GripHand",if part.Position.X<0 then "Left" else "Right") end end
	elseif heroId=="TITAN" then
		root.Size=Vector3.new(.7,.65,1.6) root.Color=hero.Primary
		for _,x in {-.2,.2} do for _,y in {-.16,.16} do p("CannonBarrel",Vector3.new(.2,.2,1.8),Vector3.new(x,y,-1.35),metal) end end
		p("Drum",Vector3.new(.95,.8,.8),Vector3.new(0,-.6,.15),metal)
		p("TopRail",Vector3.new(.18,.1,1.6),Vector3.new(0,.4,-.2),accent,Enum.Material.Neon)
	elseif heroId=="HAVOC" then
		root.Color=hero.Primary
		local drum=p("GrenadeDrum",Vector3.new(.8,.9,.9),Vector3.new(0,-.3,0),metal) drum.Shape=Enum.PartType.Ball
		p("WideMuzzle",Vector3.new(.5,.5,.85),Vector3.new(0,.1,-1.1),metal)
		p("MuzzleOpening",Vector3.new(.3,.3,.03),Vector3.new(0,.1,-1.54),dark)
		p("WarningStripe",Vector3.new(.34,.08,.8),Vector3.new(0,.3,-.6),accent)
	elseif heroId=="SPECTRE" then
		p("LongBarrel",Vector3.new(.12,.12,2.3),Vector3.new(0,.05,-1.7),metal)
		p("Scope",Vector3.new(.27,.3,.85),Vector3.new(0,.45,-.2))
		p("ScopeLens",Vector3.new(.24,.24,.03),Vector3.new(0,.45,-.64),accent,Enum.Material.Neon)
		p("PrecisionStock",Vector3.new(.26,.45,.8),Vector3.new(0,-.05,.9),hero.Primary)
		p("Bolt",Vector3.new(.28,.12,.15),Vector3.new(.26,0,.15),metal)
	else
		root.Color=hero.Primary
		p("EnergyBarrel",Vector3.new(.22,.22,1.2),Vector3.new(0,.05,-1.15),metal)
		for _,x in {-.23,.23} do p("EnergyRail",Vector3.new(.08,.16,1.35),Vector3.new(x,.05,-.5),accent,Enum.Material.Neon) end
		p("Cell",Vector3.new(.26,.65,.3),Vector3.new(0,-.4,.2),accent,Enum.Material.Neon)
		p("Optic",Vector3.new(.2,.15,.3),Vector3.new(0,.3,-.2),accent,Enum.Material.Neon)
	end
	if heroId~="ATLAS" and heroId~="PHANTOM" then p("Grip",Vector3.new(.23,.55,.28),Vector3.new(0,-.4,.4)) end
	m.Parent=parent
	return m
end
return Weapons
