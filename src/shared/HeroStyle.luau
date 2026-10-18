local G = require(script.Parent.Geometry)
local Catalog = require(script.Parent.HeroCatalog)
local Weapons = require(script.Parent.HeroWeapons)
local Style = {}
function Style.decorate(m, heroId, faction)
	local h = Catalog.Heroes[heroId]
	local primary, accent = h.Primary, h.Accent
	local dark, metal = Color3.fromRGB(26,32,39), Color3.fromRGB(94,106,118)
	for _,p in m:GetChildren() do if p:IsA("BasePart") then p.Color=primary end end
	-- Human skin under a fitted mask/helmet, rather than a robotic replacement head.
	m.Head.Color=Color3.fromRGB(179,141,116)
	local function attach(name,body,size,offset,color,mat)
		local limb=m[body]
		local p=G.part(m,name,size,limb.CFrame*offset,color or primary,mat)
		p.Anchored,p.CanCollide,p.CanQuery,p.CanTouch,p.Massless=false,false,false,false,true
		local w=Instance.new("WeldConstraint") w.Part0,w.Part1,w.Parent=limb,p,p
		return p
	end
	local function plate(name,body,size,pos,color,mat) return attach(name,body,size,CFrame.new(pos),color,mat) end
	local bulk=if heroId=="TITAN" then 1.3 elseif heroId=="ATLAS" then 1.15 else 1
	plate("ChestArmor","UpperTorso",Vector3.new(1.9*bulk,.9,.28),Vector3.new(0,.05,-.58))
	plate("AbdominalPlate","LowerTorso",Vector3.new(1.55,.5,.22),Vector3.new(0,0,-.53),dark)
	plate("Backpack","UpperTorso",Vector3.new(1.3,1.1,.5),Vector3.new(0,0,.7),dark)
	for _,side in {"Left","Right"} do
		local sign=if side=="Left" then -1 else 1
		plate("Pauldron"..side,side.."UpperArm",Vector3.new(.9*bulk,.5,1),Vector3.new(sign*.06,.35,0))
		plate("ForearmGuard"..side,side.."LowerArm",Vector3.new(.7,.75,.78),Vector3.new(0,0,0),dark)
		plate("Kneepad"..side,side.."LowerLeg",Vector3.new(.78,.45,.2),Vector3.new(0,.35,-.47),metal)
		plate("Boot"..side,side.."Foot",Vector3.new(.83,.45,1.14),Vector3.zero,dark)
		plate("SuitTrim"..side,side.."UpperArm",Vector3.new(.15,.32,.08),Vector3.new(sign*.3,.35,-.53),accent,Enum.Material.Neon)
	end
	local shell=plate("HelmetShell","Head",Vector3.new(1.3,1.05,1.3),Vector3.new(0,.2,.02),dark)
	plate("Mask","Head",Vector3.new(1.13,.5,.18),Vector3.new(0,-.25,-.61),primary)
	local visorColor=Color3.new(accent.R*.65,accent.G*.65,accent.B*.65)
	local visor=plate("Visor","Head",Vector3.new(1.18,.16,.12),Vector3.new(0,.15,-.68),visorColor,Enum.Material.Neon)
	-- Reviewed Creator Store helmet mesh is only a base shell; recolored and augmented.
	local template=game.ReplicatedStorage:FindFirstChild("ZeroAssets") and game.ReplicatedStorage.ZeroAssets:FindFirstChild("HelmetReference")
	if template and (heroId=="VEX" or heroId=="TITAN" or heroId=="ECHO") then
		local source=template:FindFirstChild("Handle")
		if source then
			local helmet=source:Clone() helmet.Name="AdaptedHelmet"
			helmet.CFrame=m.Head.CFrame*CFrame.new(0,.1,0) helmet.Anchored=false helmet.Massless=true
			helmet.CanCollide,helmet.CanQuery,helmet.CanTouch=false,false,false helmet.Color=primary
			local mesh=helmet:FindFirstChildOfClass("SpecialMesh")
			if mesh then mesh.TextureId="" mesh.Scale*=1.05 end
			local w=Instance.new("WeldConstraint") w.Part0,w.Part1,w.Parent=m.Head,helmet,helmet helmet.Parent=m shell.Color=primary
		end
	end
	if heroId=="TITAN" then
		visor.Size=Vector3.new(1.1,.1,.13)
		plate("Collar","UpperTorso",Vector3.new(2.45,.35,1.4),Vector3.new(0,.65,0),metal)
		for _,x in {-.5,.5} do plate("CannonCell","UpperTorso",Vector3.new(.3,.8,.28),Vector3.new(x,.05,-.81),accent,Enum.Material.Neon) end
	elseif heroId=="ATLAS" then
		for _,side in {"Left","Right"} do
			plate("ExoForearm"..side,side.."LowerArm",Vector3.new(1,.8,1),Vector3.zero,primary)
			plate("DrivePiston"..side,side.."UpperLeg",Vector3.new(.22,1.05,.25),Vector3.new(.48,0,.2),metal)
			plate("PoweredGauntlet"..side,side.."Hand",Vector3.new(1.15,.7,1.2),Vector3.new(0,-.1,-.1),primary)
		end
		plate("ExoSpine","UpperTorso",Vector3.new(.6,1.7,.5),Vector3.new(0,.2,.95),accent)
	elseif heroId=="PHANTOM" then
		shell.Color=primary visor.Transparency=1
		for _,x in {-.3,.3} do plate("StealthLens","Head",Vector3.new(.27,.16,.12),Vector3.new(x,.12,-.7),accent,Enum.Material.Neon) end
		for _,x in {-.48,.48} do plate("SplitCoat","LowerTorso",Vector3.new(.8,1.5,.14),Vector3.new(x,-.7,.55),dark,Enum.Material.Fabric) end
	elseif heroId=="HAVOC" then
		for n=1,4 do
			attach("GrenadeBandolier","UpperTorso",Vector3.new(.23,.4,.28),CFrame.new(-.65+n*.26,.6-n*.2,-.8)*CFrame.Angles(0,0,-.6),metal)
		end
		plate("BlastShield","LeftUpperArm",Vector3.new(1.1,.9,1.1),Vector3.new(-.12,.15,0),dark)
		plate("ArmorScar","UpperTorso",Vector3.new(.6,.06,.04),Vector3.new(.45,.3,-.74),metal)
	elseif heroId=="SPECTRE" then
		shell.Color=primary shell.Material=Enum.Material.Fabric
		plate("HoodBack","Head",Vector3.new(1.4,1.55,.3),Vector3.new(0,-.1,.65),dark,Enum.Material.Fabric)
		for _,x in {-.72,.72} do plate("HoodSide","Head",Vector3.new(.18,1.5,1.3),Vector3.new(x,-.05,0),dark,Enum.Material.Fabric) end
		visor.Size=Vector3.new(.35,.28,.2) visor.CFrame=m.Head.CFrame*CFrame.new(-.3,.15,-.73)
		plate("OpticalLens","Head",Vector3.new(.35,.28,.2),Vector3.new(.3,.15,-.73),accent,Enum.Material.Neon)
		plate("ReconAntenna","UpperTorso",Vector3.new(.08,1.8,.08),Vector3.new(.5,1,.8),metal)
	elseif heroId=="NOVA" then
		shell.Color=primary
		plate("MedicalPack","UpperTorso",Vector3.new(1.4,1.3,.4),Vector3.new(0,0,1),primary)
		plate("MedicalCrossH","UpperTorso",Vector3.new(.65,.16,.08),Vector3.new(0,.1,-.76),accent,Enum.Material.Neon)
		plate("MedicalCrossV","UpperTorso",Vector3.new(.16,.65,.08),Vector3.new(0,.1,-.77),accent,Enum.Material.Neon)
		for _,x in {-.7,.7} do plate("MedCanister","UpperTorso",Vector3.new(.3,.8,.3),Vector3.new(x,0,.9),accent) end
	elseif heroId=="ECHO" then
		for _,side in {"Left","Right"} do
			local panel=plate("HologramEmitter"..side,side.."LowerArm",Vector3.new(.13,.8,1.3),Vector3.new(if side=="Left" then -.5 else .5,0,0),accent,Enum.Material.Neon)
			panel.Transparency=.45
		end
		plate("ProjectionCore","UpperTorso",Vector3.new(.5,.5,.2),Vector3.new(0,.05,-.8),accent,Enum.Material.Neon)
	else
		for _,x in {-.62,0,.62} do plate("MagazinePouch","UpperTorso",Vector3.new(.4,.55,.2),Vector3.new(x,-.25,-.78),dark) end
	end
	local stripe=plate("TeamStripe","UpperTorso",Vector3.new(1.45,.08,.08),Vector3.new(0,.48,-.78),if faction=="Alpha" then Color3.fromRGB(75,211,240) else Color3.fromRGB(255,121,64),Enum.Material.Neon)
	local gun=Weapons.create(heroId,m)
	gun:PivotTo(m.RightHand.CFrame*CFrame.new(0,-.1,-.9))
	for _,p in gun:GetDescendants() do if p:IsA("BasePart") then
		p.Anchored,p.CanCollide,p.CanQuery,p.CanTouch,p.Massless=false,false,false,false,true
		local hand=if p:GetAttribute("GripHand")=="Left" then m.LeftHand else m.RightHand
		if hand==m.LeftHand then p.CFrame=hand.CFrame*m.RightHand.CFrame:ToObjectSpace(p.CFrame) end
		local w=Instance.new("WeldConstraint") w.Part0,w.Part1,w.Parent=hand,p,p
	end end
	m:SetAttribute("WeaponName",h.Weapon)
end
return Style
