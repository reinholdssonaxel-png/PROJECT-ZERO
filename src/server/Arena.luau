local Lighting=game:GetService("Lighting")
local G=require(game.ReplicatedStorage.ZeroShared.Geometry)
local Layout=require(game.ReplicatedStorage.ZeroShared.MapLayout)
local Arena={}
function Arena.build()
 local old=workspace:FindFirstChild("ZeroArena") if old then old:Destroy() end
 local arena=Instance.new("Folder") arena.Name="ZeroArena" arena.Parent=workspace arena:SetAttribute("LayoutVersion",2)
 local steel,dark,brick=Color3.fromRGB(78,94,107),Color3.fromRGB(38,48,59),Color3.fromRGB(111,76,66)
 local doors={}
 local function box(name,size,pos,color,mat)
  local p=G.part(arena,name,size,CFrame.new(pos),color or steel,mat or Enum.Material.Concrete) p.CanTouch=false return p
 end
 box("Quay",Vector3.new(320,3,520),Vector3.new(0,-1.5,0),dark,Enum.Material.Asphalt).Reflectance=.12
 local sea=box("HarborWater",Vector3.new(1100,2,1100),Vector3.new(0,-6,0),Color3.fromRGB(27,62,80),Enum.Material.Glass) sea.CanCollide=false sea.CanQuery=false sea.Reflectance=.2
 for _,x in {-159,159} do
  box("QuayBoundary",Vector3.new(2,5,520),Vector3.new(x,2.5,0),steel)
  local p=box("HarborBoundary",Vector3.new(2,60,520),Vector3.new(x,30,0)) p.Transparency=1 p.CanQuery=false
 end
 for _,z in {-259,259} do
  local p=box("HarborBoundary",Vector3.new(320,60,2),Vector3.new(0,30,z)) p.Transparency=1 p.CanQuery=false
  box("Seawall",Vector3.new(320,2,3),Vector3.new(0,1,z),steel)
 end
 -- Equal circulation footprints; different cladding and service identities.
 for _,s in {-1,1} do
  local faction=if s==-1 then "Alpha" else "Bravo"
  local skin=if s==-1 then brick else steel
  local mat=if s==-1 then Enum.Material.Brick else Enum.Material.Metal
  box(faction.."RoomFloor",Vector3.new(132,1,40),Vector3.new(0,.5,s*232),steel,Enum.Material.DiamondPlate)
  box(faction.."RoomRoof",Vector3.new(136,2,42),Vector3.new(0,25,s*232),dark)
  for _,x in {-66,66} do box("RoomSide",Vector3.new(2,25,40),Vector3.new(x,12.5,s*232),skin,mat) end
  box("WindowSill",Vector3.new(132,4,2),Vector3.new(0,2,s*252),skin,mat)
  local glass=box(faction.."PanoramicWindow",Vector3.new(130,18,1),Vector3.new(0,13,s*252),Color3.fromRGB(123,172,188),Enum.Material.Glass) glass.Transparency=.65
  box("WindowHeader",Vector3.new(132,3,2),Vector3.new(0,23.5,s*252),skin,mat)
  for _,x in {-44,0,44} do box("WindowMullion",Vector3.new(.5,20,2),Vector3.new(x,14,s*252),dark,Enum.Material.Metal) end
  for _,d in {{-58.5,15},{0,66},{58.5,15}} do box("RoomFront",Vector3.new(d[2],25,3),Vector3.new(d[1],12.5,s*212),skin,mat) end
  for _,x in {-42,42} do
   box("DoorHeader",Vector3.new(18,10,3),Vector3.new(x,20,s*212),skin,mat)
   local d=box(faction..(if x<0 then "WestDoor" else "EastDoor"),Vector3.new(18,15,1),Vector3.new(x,7.5,s*212),dark,Enum.Material.Metal)
   d:SetAttribute("ClosedCFrame",d.CFrame) table.insert(doors,d)
  end
  -- Split vestibules terminate at a real roofed cross-dock, forcing two turns.
  box("VestibuleDivider",Vector3.new(3,28,26),Vector3.new(0,14,s*198),skin,mat)
  box("CrossDock",Vector3.new(152,32,26),Vector3.new(0,16,s*172),skin,mat)
  box("VestibuleCanopy",Vector3.new(250,2,28),Vector3.new(0,28,s*198),dark,Enum.Material.Metal)
  for _,x in {-142,142} do box("ServiceWarehouse",Vector3.new(32,32,74),Vector3.new(x,16,s*177),skin,mat) end
  for _,x in {-98,98} do box("WorkshopGatehouse",Vector3.new(64,32,26),Vector3.new(x,16,s*123),skin,mat) end
  box("TransferOffice",Vector3.new(42,26,16),Vector3.new(0,13,s*110),skin,mat)
  box("DispatchHouse",Vector3.new(36,24,22),Vector3.new(0,12,s*42),skin,mat)
  local spawn=Instance.new("SpawnLocation") spawn.Name=faction.."Spawn" spawn.Size=Vector3.new(10,1,10) spawn.CFrame=CFrame.new(Layout.spawnPosition(faction)) spawn.Anchored=true spawn.Transparency=1 spawn.CanCollide=false spawn.CanQuery=false spawn.Duration=0 spawn.Parent=arena
 end
 -- West warehouse: two side portals and alternating fire compartments.
 box("WestWarehouseFloor",Vector3.new(78,.3,168),Vector3.new(-103,.15,0),steel)
 box("WestOuterWall",Vector3.new(3,28,168),Vector3.new(-143,14,0),brick,Enum.Material.Brick)
 box("WestWarehouseRoof",Vector3.new(82,2,172),Vector3.new(-103,29,0),dark,Enum.Material.Metal)
 for _,z in {-66,0,66} do box("WestInnerWall",Vector3.new(3,28,36),Vector3.new(-63,14,z),brick,Enum.Material.Brick) end
 for _,s in {-1,1} do
  for _,d in {{-133,22},{-81,34}} do box("WarehousePortal",Vector3.new(d[2],28,3),Vector3.new(d[1],14,s*84),brick,Enum.Material.Brick) end
  box("PortalHeader",Vector3.new(26,10,3),Vector3.new(-110,23,s*84),brick,Enum.Material.Brick)
 end
 box("WarehouseFireWallA",Vector3.new(46,26,4),Vector3.new(-120,13,-22),brick,Enum.Material.Brick)
 box("WarehouseFireWallB",Vector3.new(46,26,4),Vector3.new(-86,13,22),brick,Enum.Material.Brick)
 -- East factory: machinery, ground flank and a protected dogleg catwalk.
 box("FactoryOuterWall",Vector3.new(3,30,168),Vector3.new(145,15,0),steel,Enum.Material.Metal)
 for _,z in {-66,0,66} do box("FactoryInnerWall",Vector3.new(3,30,36),Vector3.new(63,15,z),steel,Enum.Material.Metal) end
 for _,s in {-1,1} do
  for _,d in {{77,26},{136,18}} do box("FactoryPortal",Vector3.new(d[2],30,3),Vector3.new(d[1],15,s*84),steel,Enum.Material.Metal) end
  box("FactoryPortalHeader",Vector3.new(36,15,3),Vector3.new(108,22.5,s*84),steel,Enum.Material.Metal)
  box("CatwalkDeck",Vector3.new(14,1,48),Vector3.new(136,10.5,s*40),dark,Enum.Material.DiamondPlate)
  box("CatwalkTurn",Vector3.new(38,1,14),Vector3.new(124,10.5,s*16),dark,Enum.Material.DiamondPlate)
  for n=1,20 do box("FactoryStairs",Vector3.new(14,n*.55,1.6),Vector3.new(136,n*.275,s*(94-n*1.5)),steel,Enum.Material.Metal) end
 end
 box("CatwalkBypass",Vector3.new(14,1,32),Vector3.new(112,10.5,0),dark,Enum.Material.DiamondPlate)
 box("FactoryLiftHouse",Vector3.new(22,32,16),Vector3.new(136,16,0),steel,Enum.Material.Metal)
 box("MachineIsland",Vector3.new(18,12,48),Vector3.new(81,6,0),dark,Enum.Material.Metal)
 for _,s in {-1,1} do box("Switchgear",Vector3.new(16,14,12),Vector3.new(114,7,s*30),steel,Enum.Material.Metal) end
 -- Marked cargo bays; no random container grid or uninterrupted central lane.
 for _,s in {-1,1} do
  local cargo=box("LoadingBayCargo",Vector3.new(16,11,28),Vector3.new(-44,5.5,s*56),Color3.fromRGB(145,91,48),Enum.Material.Metal) cargo:SetAttribute("ArtContainer",true)
  box("LoadingBayBarrier",Vector3.new(5,4,26),Vector3.new(49,2,s*60),steel)
 end
 box("ControlPoint",Vector3.new(34,.12,34),Vector3.new(0,.1,0),Color3.fromRGB(48,126,147),Enum.Material.Metal)
 for _,x in {-36,36} do box("WeighbridgeControlBooth",Vector3.new(18,18,18),Vector3.new(x,9,0),steel,Enum.Material.Metal) end
 for _,x in {-25,25} do for _,s in {-1,1} do box("ObjectiveParapet",Vector3.new(10,3.5,3),Vector3.new(x,1.75,s*15),steel) end end
 Lighting.ClockTime=20.5 Lighting.Brightness=3 Lighting.ExposureCompensation=.5 Lighting.GlobalShadows=true Lighting.Ambient=Color3.fromRGB(110,122,142) Lighting.OutdoorAmbient=Color3.fromRGB(116,132,157)
 local at=Lighting:FindFirstChild("ZeroAtmosphere") or Instance.new("Atmosphere") at.Name="ZeroAtmosphere" at.Density=.22 at.Haze=1 at.Color=Color3.fromRGB(185,196,208) at.Parent=Lighting
 at.Decay=Color3.fromRGB(83,103,130) at.Glare=.1 at.Offset=0
 local cc=Lighting:FindFirstChild("ZeroColor") or Instance.new("ColorCorrectionEffect") cc.Name="ZeroColor" cc.Contrast=.05 cc.Saturation=-.06 cc.Brightness=0 cc.TintColor=Color3.new(1,1,1) cc.Parent=Lighting
 require(script.Parent.HarborDetail).build(arena)
 return arena,doors
end
return Arena
