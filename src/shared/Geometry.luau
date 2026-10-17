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
function Geometry.rifle(parent: Instance): Model
	local m = Instance.new("Model")
	m.Name = "VX7"
	local dark, orange = Color3.fromRGB(32, 38, 45), Color3.fromRGB(255, 137, 48)
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
