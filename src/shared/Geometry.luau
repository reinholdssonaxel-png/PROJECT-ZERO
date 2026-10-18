--!strict
local Geometry = {}
function Geometry.part(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?): Part
	local p = Instance.new("Part")
	p.Name, p.Size, p.CFrame = name, size, cf
	p.Color, p.Material = color, material or Enum.Material.Metal
	p.Anchored = true
	p.TopSurface, p.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
function Geometry.meshWeapon(heroId: string, parent: Instance, preview: boolean?): Model?
	local assets=game.ReplicatedStorage:FindFirstChild("ZeroAssets")
	local art=assets and assets:FindFirstChild("WeaponArt")
	local template=art and art:FindFirstChild(heroId)
	if not template or (heroId=="ATLAS" and not preview) then return nil end
	local sizes={VEX=Vector3.new(.32,.8,2.9),TITAN=Vector3.new(.85,1.15,3.3),PHANTOM=Vector3.new(.25,.62,1.5),HAVOC=Vector3.new(.65,.95,2.3),SPECTRE=Vector3.new(.3,.85,4.2),NOVA=Vector3.new(.35,.75,2.55),ECHO=Vector3.new(.38,.78,2.6),ATLAS=Vector3.new(.95,.85,1.1)}
	local m=template:Clone() m:ClearAllChildren() -- Retain AI provenance on the model.
	m.Name=if heroId=="VEX" then "VX7" else "Weapon_"..heroId
	local receiver=Geometry.part(m,"Receiver",Vector3.one*.1,CFrame.identity,Color3.new()) receiver.Transparency=1
	m.PrimaryPart=receiver
	local center,bounds=template:GetBoundingBox()
	local ratio=sizes[heroId]/bounds
	local function copy(offset: CFrame, hand: string?)
		for _,source in template:GetDescendants() do if source:IsA("MeshPart") then
			local p=source:Clone() p.Name="WeaponMesh"
			local cf=center:ToObjectSpace(source.CFrame)
			p.Size*=ratio p.CFrame=offset*CFrame.new(cf.Position*ratio)*cf.Rotation
			p.Anchored,p.CanCollide,p.CanQuery,p.CanTouch=true,false,false,false
			p:SetAttribute("GripHand",hand) p.Parent=m
		end end
	end
	if heroId=="PHANTOM" or heroId=="ATLAS" then
		for _,sign in {-1,1} do copy(CFrame.new(if preview then sign*.45 else 0,0,-.3),if sign<0 then "Left" else "Right") end
	else copy(CFrame.new(0,-.05,-.45)) end
	local muzzle=Geometry.part(m,"Barrel",Vector3.one*.05,CFrame.new(0,.05,-.45-sizes[heroId].Z/2),Color3.new()) muzzle.Transparency=1
	m.Parent=parent
	return m
end
function Geometry.rifle(parent: Instance): Model
	local mesh=Geometry.meshWeapon("VEX",parent)
	if mesh then return mesh end
	local m = Instance.new("Model")
	m.Name = "VX7"
	local dark, orange = Color3.fromRGB(40, 47, 56), Color3.fromRGB(179, 91, 30)
	local p = Geometry.part
	p(m, "Receiver", Vector3.new(.32, .42, 1.45), CFrame.new(0, 0, -.3), dark)
	p(m, "Barrel", Vector3.new(.13, .13, 1.05), CFrame.new(0, .05, -1.5), dark)
	p(m, "Stock", Vector3.new(.25, .35, .55), CFrame.new(0, 0, .62), dark)
	p(m, "Magazine", Vector3.new(.23, .58, .35), CFrame.new(0, -.43, -.1) * CFrame.Angles(-.18, 0, 0), dark)
	p(m, "Grip", Vector3.new(.22, .48, .25), CFrame.new(0, -.4, .4) * CFrame.Angles(-.2, 0, 0), dark)
	p(m, "Optic", Vector3.new(.19, .17, .3), CFrame.new(0, .29, -.35), orange, Enum.Material.Neon)
	p(m, "HeatStrip", Vector3.new(.335, .05, .85), CFrame.new(0, .1, -.52), orange, Enum.Material.Neon)
	m.PrimaryPart = m.Receiver
	m.Parent = parent
	return m
end
return Geometry
