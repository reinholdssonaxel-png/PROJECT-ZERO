--!strict
local Lighting = game:GetService("Lighting")
local G = require(game.ReplicatedStorage.ZeroShared.Geometry)
local Arena = {}
local steel = Color3.fromRGB(57, 72, 86)
local charcoal = Color3.fromRGB(31, 39, 49)
local orange = Color3.fromRGB(255, 143, 55)
local cyan = Color3.fromRGB(68, 208, 240)
function Arena.build()
	local existing = workspace:FindFirstChild("ZeroArena")
	if existing then existing:Destroy() end
	local f = Instance.new("Folder")
	f.Name = "ZeroArena"
	f.Parent = workspace
	local doors = {}
	local function box(name, size, pos, color, mat)
		return G.part(f, name, size, CFrame.new(pos), color, mat)
	end
	local function sign(part, text, face)
		local gui = Instance.new("SurfaceGui")
		gui.Face, gui.SizingMode, gui.PixelsPerStud = face or Enum.NormalId.Front, Enum.SurfaceGuiSizingMode.PixelsPerStud, 24
		gui.Parent = part
		local label = Instance.new("TextLabel")
		label.Size, label.BackgroundTransparency = UDim2.fromScale(1, 1), 1
		label.Font, label.TextScaled, label.TextColor3 = Enum.Font.GothamBold, true, Color3.fromRGB(223, 236, 242)
		label.Text = text
		label.Parent = gui
	end
	local function lamp(pos, color)
		local p = box("LightPanel", Vector3.new(8, .3, 1), pos, color, Enum.Material.Neon)
		local l = Instance.new("PointLight")
		l.Color, l.Brightness, l.Range = color, 2, 28
		l.Parent = p
	end
	local ground = box("DampAsphalt", Vector3.new(184, 2, 290), Vector3.new(0, -1, 0), charcoal, Enum.Material.Asphalt)
	ground.Reflectance = .12
	box("Sea", Vector3.new(900, 2, 900), Vector3.new(0, -5, 0), Color3.fromRGB(18, 48, 66), Enum.Material.Glass)
	for _, x in {-91, 91} do box("Boundary", Vector3.new(2, 17, 290), Vector3.new(x, 8, 0), steel, Enum.Material.Concrete) end
	for _, z in {-145, 145} do box("HarborSeawall", Vector3.new(184, 3, 2), Vector3.new(0, 1, z), steel, Enum.Material.Concrete) end
	for _, side in {-1, 1} do
		local accent = if side == -1 then cyan else orange
		local faction = if side == -1 then "Alpha" else "Bravo"
		local z = side * 121
		box("SpawnFloor" .. faction, Vector3.new(140, 1, 42), Vector3.new(0, .5, z), steel, Enum.Material.DiamondPlate)
		box("SpawnRoof", Vector3.new(142, 1, 44), Vector3.new(0, 19, z), charcoal)
		for _, x in {-70, 70} do box("SpawnWall", Vector3.new(2, 19, 44), Vector3.new(x, 9.5, z), steel) end
		-- Back wall with broad panoramic glazing overlooking the water.
		box("WindowBase", Vector3.new(140, 4, 1), Vector3.new(0, 2, side * 142), steel)
		local window = box("PanoramicWindow", Vector3.new(138, 13, .5), Vector3.new(0, 10.5, side * 142), cyan, Enum.Material.Glass)
		window.Transparency = .65
		for _, x in {-46, 0, 46} do box("WindowMullion", Vector3.new(.6, 15, 1), Vector3.new(x, 11, side * 142), charcoal) end
		for _, x in {-43, 43} do box("SpawnFront", Vector3.new(54, 19, 2), Vector3.new(x, 9.5, side * 100), steel) end
		box("DoorLintel", Vector3.new(32, 5, 2), Vector3.new(0, 16.5, side * 100), charcoal)
		local door = box("Door" .. faction, Vector3.new(32, 14, 1), Vector3.new(0, 7, side * 100), accent)
		table.insert(doors, door)
		sign(door, "ZERO // " .. string.upper(faction), if side == -1 then Enum.NormalId.Back else Enum.NormalId.Front)
		for _, x in {-58, -50, -42, 42, 50, 58} do
			box("Locker", Vector3.new(5, 10, 3), Vector3.new(x, 5.5, side * 136), charcoal)
			box("LockerStripe", Vector3.new(3, .3, 3.1), Vector3.new(x, 8, side * 136), accent, Enum.Material.Neon)
		end
		local map = box("MapDisplay", Vector3.new(17, 8, .4), Vector3.new(30, 9, side * 139), charcoal)
		sign(map, "HAMNVERKET\nW  |  C  |  E", if side == -1 then Enum.NormalId.Back else Enum.NormalId.Front)
		for _, x in {-46, 0, 46} do lamp(Vector3.new(x, 17.8, z), accent) end
		local spawn = Instance.new("SpawnLocation")
		spawn.Name, spawn.Size = faction .. "Spawn", Vector3.new(12, 1, 10)
		spawn.CFrame, spawn.Anchored, spawn.Transparency = CFrame.new(0, 1, z), true, 1
		spawn.CanCollide, spawn.CanQuery, spawn.Duration = false, false, 0
		spawn.Parent = f
	end
	for _, x in {-52, 0, 52} do
		box("LaneMarking", Vector3.new(.35, .04, 180), Vector3.new(x, .04, 0), orange)
	end
	-- Mirrored cover leaves three approach lanes and cross-connections.
	for _, side in {-1, 1} do
		for _, x in {-30, 30} do
			for _, z in {28, 68} do
				local color = if x < 0 then steel else Color3.fromRGB(132, 78, 43)
				box("CargoContainer", Vector3.new(20, 12, 23), Vector3.new(x, 6, side * z), color)
				for rib = -9, 9, 3 do box("ContainerRib", Vector3.new(.35, 11, 23.3), Vector3.new(x + rib, 6, side * z), charcoal) end
			end
		end
		for _, x in {-64, 64} do
			box("Warehouse", Vector3.new(24, 20, 32), Vector3.new(x, 10, side * 42), Color3.fromRGB(83, 64, 60), Enum.Material.Brick)
			lamp(Vector3.new(x, 16, side * 23), cyan)
		end
		for _, x in {-10, 10} do box("LowCover", Vector3.new(7, 4, 7), Vector3.new(x, 2, side * 14), steel) end
	end
	box("ControlPoint", Vector3.new(18, .1, 18), Vector3.new(0, .08, 0), cyan, Enum.Material.Neon)
	for _, x in {-84, 84} do
		for _, z in {-78, 0, 78} do
			box("FloodlightPole", Vector3.new(1, 22, 1), Vector3.new(x, 11, z), charcoal)
			local fixture = box("Floodlight", Vector3.new(3, 1, 2), Vector3.new(x, 22, z), Color3.fromRGB(235, 219, 189), Enum.Material.Neon)
			local light = Instance.new("PointLight") light.Brightness, light.Range, light.Color = 3, 55, Color3.fromRGB(213, 225, 242) light.Parent = fixture
		end
	end
	for _, x in {48, 76} do
		for _, z in {-14, 14} do box("CatwalkPillar", Vector3.new(1.5, 8, 1.5), Vector3.new(x, 4, z), steel) end
	end
	box("FactoryCatwalk", Vector3.new(30, 1, 30), Vector3.new(62, 8.5, 0), steel, Enum.Material.DiamondPlate)
	for _, side in {-1, 1} do
		for n = 1, 8 do box("CatwalkStair", Vector3.new(8, n, 2.5), Vector3.new(62, n / 2, side * (35 - n * 2.5)), steel) end
	end
	-- Harbor silhouette outside the playable boundary.
	for _, z in {-60, 65} do
		for _, x in {-125, -102} do box("CraneLeg", Vector3.new(3, 65, 3), Vector3.new(x, 27, z), orange) end
		box("CraneBeam", Vector3.new(73, 4, 4), Vector3.new(-118, 60, z), orange)
		box("CraneCable", Vector3.new(.3, 35, .3), Vector3.new(-148, 40, z), charcoal)
	end
	box("ShipHull", Vector3.new(28, 14, 96), Vector3.new(-165, -1, 5), charcoal)
	box("ShipBridge", Vector3.new(22, 20, 20), Vector3.new(-165, 13, 35), steel)
	Lighting.ClockTime, Lighting.Brightness = 20.5, 3
	Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(82, 99, 126), Color3.fromRGB(90, 107, 135)
	local at = Lighting:FindFirstChild("ZeroAtmosphere") or Instance.new("Atmosphere")
	at.Name, at.Density, at.Haze, at.Color = "ZeroAtmosphere", .22, 1, Color3.fromRGB(158, 180, 206)
	at.Parent = Lighting
	local cc = Lighting:FindFirstChild("ZeroColor") or Instance.new("ColorCorrectionEffect")
	cc.Name, cc.Contrast, cc.Saturation = "ZeroColor", .08, -.12
	cc.Parent = Lighting
	require(script.Parent.HarborDetail).build(f)
	return f, doors
end
return Arena
