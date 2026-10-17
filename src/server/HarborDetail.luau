-- Static art has no gameplay scripts, touch events or per-frame updates.
local G = require(game.ReplicatedStorage.ZeroShared.Geometry)
local Detail = {}
function Detail.build(arena)
	local f=Instance.new("Folder") f.Name="HarborDetail" f.Parent=arena
	local steel=Color3.fromRGB(73,87,99)
	local dark=Color3.fromRGB(32,43,54)
	local orange=Color3.fromRGB(213,121,48)
	local pale=Color3.fromRGB(185,209,221)
	local function box(name,size,pos,color,mat,rotation)
		local p=G.part(f,name,size,CFrame.new(pos)*(rotation or CFrame.identity),color or steel,mat)
		p.CanCollide,p.CanQuery,p.CanTouch=false,false,false
		p.CastShadow=size.Magnitude>15
		return p
	end
	local function beam(name,a,b,width,color)
		return box(name,Vector3.new(width,width,(b-a).Magnitude),(a+b)/2,color,Enum.Material.Metal,CFrame.lookAt(Vector3.zero,b-a).Rotation)
	end
	local function sign(name,text,pos,size,color,face)
		local p=box(name,size,pos,dark)
		local gui=Instance.new("SurfaceGui") gui.Face=face or Enum.NormalId.Front gui.PixelsPerStud=28 gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud gui.LightInfluence=.25 gui.Parent=p
		local t=Instance.new("TextLabel") t.Size=UDim2.fromScale(.94,.85) t.Position=UDim2.fromScale(.03,.075) t.BackgroundTransparency=1 t.TextColor3=color or pale t.TextScaled=true t.Font=Enum.Font.GothamBold t.Text=text t.Parent=gui
		return p
	end
	local function light(pos,color,range)
		local p=box("IndustrialLuminaire",Vector3.new(4,.4,1.5),pos,color,Enum.Material.Neon)
		local l=Instance.new("PointLight") l.Color,l.Brightness,l.Range,l.Shadows=color,2,range or 32,false l.Parent=p
	end
	-- Wet asphalt, drained service strips and flush loading-rail seams.
	for _,x in {-80,80} do
		box("DrainChannel",Vector3.new(1.4,.04,194),Vector3.new(x,.03,0),dark,Enum.Material.DiamondPlate)
		for z=-90,90,15 do box("DrainSlot",Vector3.new(1.6,.03,.22),Vector3.new(x,.06,z),pale) end
	end
	for _,x in {-8,8} do box("LoadingRail",Vector3.new(.25,.06,168),Vector3.new(x,.04,0),steel) end
	local rng=Random.new(2042)
	for n=1,22 do
		local p=box("RainPuddle",Vector3.new(rng:NextNumber(2,8),.025,rng:NextNumber(2,12)),Vector3.new(rng:NextNumber(-77,77),.035,rng:NextNumber(-92,92)),Color3.fromRGB(61,82,96),Enum.Material.Glass)
		p.Transparency,p.Reflectance=.38,.38
	end
	-- Containers gain end doors, hinges, latches, serial numbers and hazard corners.
	for _,p in arena:GetChildren() do
		if p.Name=="CargoContainer" then
			local x,z=p.Position.X,p.Position.Z
			for _,side in {-1,1} do
				box("ContainerDoor",Vector3.new(9.3,10.8,.16),Vector3.new(x+side*4.85,6,z-11.65),p.Color)
				box("LockingBar",Vector3.new(.15,9.7,.18),Vector3.new(x+side*4.7,6,z-11.8),steel)
				box("LockHandle",Vector3.new(1,.14,.3),Vector3.new(x+side*4.7,5,z-11.95),pale)
			end
			for _,side in {-1,1} do box("HazardCorner",Vector3.new(.5,1.2,.2),Vector3.new(x+side*9.5,10.5,z-11.8),orange) end
			sign("CargoSerial","NHU 2042\nNORRHAMN",Vector3.new(x,9.5,z-11.85),Vector3.new(5,1.6,.1),pale)
		end
	end
	for _,x in {-64,64} do for _,side in {-1,1} do
		local z=side*42
		box("WarehouseRoof",Vector3.new(27,1.5,35),Vector3.new(x,20.5,z),dark)
		box("LoadingDoor",Vector3.new(13,12,.3),Vector3.new(x,6,z-side*16.2),steel)
		for n=1,8 do box("DoorSlat",Vector3.new(13,.12,.2),Vector3.new(x,n*1.35,z-side*16.4),dark) end
		for _,dx in {-8,8} do
			local w=box("WarehouseWindow",Vector3.new(4,3,.25),Vector3.new(x+dx,16,z-side*16.25),Color3.fromRGB(195,168,114),Enum.Material.Neon) w.Transparency=.25
		end
		light(Vector3.new(x,14,z-side*17),Color3.fromRGB(245,205,146),37)
		box("VentilationDuct",Vector3.new(4,2,9),Vector3.new(x-5,22,z),steel,Enum.Material.DiamondPlate)
		box("ExtractionStack",Vector3.new(2,7,2),Vector3.new(x+6,24,z+5),dark)
		sign("WarehouseID",if x<0 then "MAGASIN 04\nVÄSTRA KAJEN" else "VERKSTAD 07\nÖSTRA FABRIKEN",Vector3.new(x,12,z-side*16.5),Vector3.new(14,2.5,.2),pale,if side==1 then Enum.NormalId.Front else Enum.NormalId.Back)
	end end
	-- Safety rails on the factory bridge, with two open stair approaches.
	for _,x in {47,77} do
		for _,z in {-14,0,14} do box("CatwalkPost",Vector3.new(.25,3,.25),Vector3.new(x,10.5,z),orange) end
		for _,y in {10,12} do beam("CatwalkRail",Vector3.new(x,y,-15),Vector3.new(x,y,15),.18,orange) end
	end
	-- Perimeter fences are decorative over the existing collision boundary.
	for _,x in {-90,90} do
		for z=-90,90,12 do
			box("FencePost",Vector3.new(.35,8,.35),Vector3.new(x,4,z),steel)
			if z<90 then for _,y in {2,4,6} do beam("FenceWire",Vector3.new(x,y,z),Vector3.new(x,y,z+12),.07,steel) end end
		end
	end
	-- Readable lane names / central future Control site.
	sign("CenterSign","HAMNVERKET\nNORRHAMN • 2042",Vector3.new(0,24,96),Vector3.new(38,7,.5),pale)
	sign("AlphaLaneGuide","01 MAGASIN   /   02 LASTGÅRD   /   03 FABRIK",Vector3.new(0,13,-99),Vector3.new(46,1.6,.2),pale,Enum.NormalId.Back)
	sign("BravoLaneGuide","03 FABRIK   /   02 LASTGÅRD   /   01 MAGASIN",Vector3.new(0,13,99),Vector3.new(46,1.6,.2),pale)
	for _,x in {-10,10} do for _,z in {-10,10} do
		box("ObjectiveBollard",Vector3.new(.8,1.5,.8),Vector3.new(x,.75,z),dark)
		box("ObjectiveIndicator",Vector3.new(.82,.15,.82),Vector3.new(x,1.4,z),Color3.fromRGB(80,196,220),Enum.Material.Neon)
	end end
	-- Adapted, reviewed Creator Store meshes. Visual only; collisions stay simple.
	local art=game.ServerStorage:FindFirstChild("ZeroArt")
	if art then
		local pipes=art:FindFirstChild("IndustrialPipes")
		if pipes then
			for _,x in {-78,78} do for _,side in {-1,1} do
				local kit=pipes:Clone() kit.Name="ReviewedPipeKit" kit:ScaleTo(1.7) kit:PivotTo(CFrame.new(x,5,side*42)*CFrame.Angles(0,0,math.pi/2)) kit.Parent=f
			end end
		end
		local cargo=art:FindFirstChild("ShippingContainer")
		if cargo then
			for n=1,6 do
				local copy=cargo:Clone() copy.Name="BackgroundCargo" copy:ScaleTo(.6)
				copy:PivotTo(CFrame.new(-125+(n%3)*22,4+math.floor((n-1)/3)*12,168)) copy.Parent=f
			end
		end
	end
	-- Additional gantry bracing, suspended spreaders, cabin and harbor hardware.
	for _,z in {-60,65} do
		for _,y in {8,28,48} do
			beam("CraneCrossBrace",Vector3.new(-125,y,z),Vector3.new(-102,y+12,z),.6,orange)
			beam("CraneCrossBrace",Vector3.new(-102,y,z),Vector3.new(-125,y+12,z),.6,orange)
		end
		box("CraneCabin",Vector3.new(6,6,7),Vector3.new(-105,54,z),steel)
		box("CraneCabinGlass",Vector3.new(.1,3,5),Vector3.new(-101.9,55,z),Color3.fromRGB(124,192,216),Enum.Material.Glass)
		box("CraneSpreader",Vector3.new(13,2,4),Vector3.new(-148,22,z),orange)
		light(Vector3.new(-118,57,z),Color3.fromRGB(242,193,122),50)
	end
	for _,x in {-160,-170} do for z=-25,25,10 do box("ShipCargo",Vector3.new(8,6,8),Vector3.new(x,9,z),if z%20==0 then steel else orange) end end
	for _,z in {-120,120} do
		for _,x in {-80,-60,-40,40,60,80} do
			box("MooringBollard",Vector3.new(1.2,1.5,1.2),Vector3.new(x,.8,z+math.sign(z)*26),dark)
		end
	end
	for n=1,14 do
		local x=-220+n*31
		local height=rng:NextInteger(20,54)
		box("DistantNorrhamn",Vector3.new(18,height,24),Vector3.new(x,height/2-4,-225),Color3.fromRGB(42,56,72),Enum.Material.Concrete)
		for y=8,height-3,10 do box("DistantWindowBand",Vector3.new(16,1,.1),Vector3.new(x,y,-212.9),Color3.fromRGB(146,168,184),Enum.Material.Neon) end
	end
	-- Enrich safe rooms without narrowing their playable circulation.
	for _,side in {-1,1} do
		local z=side*121
		for _,x in {-28,28} do
			box("SpawnBench",Vector3.new(12,1.2,3),Vector3.new(x,2,z+side*10),steel)
			for _,dx in {-4,4} do box("BenchLeg",Vector3.new(.5,2,.5),Vector3.new(x+dx,1,z+side*10),dark) end
		end
		sign("SafetyNotice","SKYDDSZON\nZERO INITIATIVE / 2042",Vector3.new(-28,10,side*139),Vector3.new(17,6,.3),pale,if side==-1 then Enum.NormalId.Back else Enum.NormalId.Front)
		for _,x in {-68,68} do box("SpawnFloorGuide",Vector3.new(.4,.04,34),Vector3.new(x,1.02,z),orange,Enum.Material.Neon) end
	end
	local L=game.Lighting
	L.Brightness,L.ExposureCompensation=3.5,.65
	L.Ambient,L.OutdoorAmbient=Color3.fromRGB(110,122,142),Color3.fromRGB(116,132,157)
	local at=L:FindFirstChild("ZeroAtmosphere")
	if at then at.Density,at.Color,at.Decay,at.Glare=.24,Color3.fromRGB(185,192,203),Color3.fromRGB(65,83,115),.15 end
	return f
end
return Detail
