local G=require(game.ReplicatedStorage.ZeroShared.Geometry)
local Detail={}
function Detail.build(arena)
 local f=Instance.new("Folder") f.Name="HarborDetail" f.Parent=arena
 local steel,dark,pale,orange=Color3.fromRGB(89,107,119),Color3.fromRGB(31,42,53),Color3.fromRGB(197,212,219),Color3.fromRGB(184,109,51)
 local count=0
 local function box(name,size,pos,color,mat,rotation)
  local p=G.part(f,name,size,CFrame.new(pos)*(rotation or CFrame.identity),color or steel,mat or Enum.Material.Metal)
  p.CanCollide=false p.CanQuery=false p.CanTouch=false p.CastShadow=size.Magnitude>18 count+=1
  if count%120==0 then task.wait() end
  return p
 end
 local function sign(text,pos,size,face,color)
  local p=box("Wayfinding",size,pos,dark)
  local gui=Instance.new("SurfaceGui") gui.Face=face or Enum.NormalId.Front gui.PixelsPerStud=24 gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud gui.LightInfluence=.2 gui.Parent=p
  local l=Instance.new("TextLabel") l.Size=UDim2.fromScale(.94,.88) l.Position=UDim2.fromScale(.03,.06) l.BackgroundTransparency=1 l.Text=text l.TextScaled=true l.Font=Enum.Font.GothamBold l.TextColor3=color or pale l.Parent=gui
 end
 local function light(pos,color,range)
  local p=box("Luminaire",Vector3.new(4,.4,1),pos,color,Enum.Material.Neon)
  local l=Instance.new("PointLight") l.Color=color l.Range=range or 35 l.Brightness=1.8 l.Shadows=false l.Parent=p
 end
 -- Architectural detail belongs to specific structures and never changes collision.
 for _,p in arena:GetChildren() do
  if p:IsA("BasePart") and (p.Name=="CrossDock" or p.Name=="WorkshopGatehouse" or p.Name=="TransferOffice" or p.Name=="DispatchHouse" or p.Name=="ServiceWarehouse") then
   local z=p.Position.Z local front=z-math.sign(z)*(p.Size.Z/2+.2)
   box("RoofCoping",p.Size*Vector3.new(1,0,1)+Vector3.new(2,1,2),p.Position+Vector3.new(0,p.Size.Y/2+.5,0),dark)
   local columns=math.max(1,math.floor(p.Size.X/14))
   for n=1,columns do
    local x=p.Position.X-p.Size.X/2+(n-.5)*p.Size.X/columns
    local panel=box("Clerestory",Vector3.new(math.min(8,p.Size.X/columns-2),3,.2),Vector3.new(x,p.Size.Y-6,front),if z<0 then Color3.fromRGB(154,171,176) else Color3.fromRGB(204,170,125),Enum.Material.Glass) panel.Transparency=.25
   end
   box("ServiceDoor",Vector3.new(math.min(9,p.Size.X-2),12,.3),Vector3.new(p.Position.X,6,front),dark)
   for y=2,12,2 do box("ShutterSlat",Vector3.new(math.min(9,p.Size.X-2),.1,.2),Vector3.new(p.Position.X,y,front-.15),steel) end
   light(Vector3.new(p.Position.X,16,front-math.sign(z)),Color3.fromRGB(235,207,168),34)
  end
 end
 for _,s in {-1,1} do
  local accent=if s<0 then Color3.fromRGB(65,157,190) else Color3.fromRGB(195,100,49)
  local face=if s<0 then Enum.NormalId.Front else Enum.NormalId.Back
  local inward=if s<0 then Enum.NormalId.Back else Enum.NormalId.Front
  -- Two wayfinding systems describe distinct operations rather than mirrored labels.
  sign(if s<0 then "VANGUARD // KAJKONTOR" else "ZERO // TULLTERMINAL",Vector3.new(0,20,s*214),Vector3.new(58,4,.2),face,accent)
  for _,x in {-42,42} do
   sign(if x<0 then "01 MAGASIN / VÄSTRA VÄGEN" else "03 VERKSTAD / ÖSTRA VÄGEN",Vector3.new(x,16,s*213.6),Vector3.new(24,2,.2),face,pale)
   light(Vector3.new(x,24,s*231),accent,32)
   sign("KAJVÄG / FÖLJ GUL LINJE",Vector3.new(x,10,s*185.2),Vector3.new(26,3,.2),face,pale)
  end
  for _,x in {-96,96} do
   light(Vector3.new(x,23,s*194),Color3.fromRGB(221,208,183),40)
   sign("←  LASTGÅRD  /  FÖLJ GUL LINJE",Vector3.new(x,9,s*137.3),Vector3.new(29,3,.2),face)
   -- Painted L-shaped circulation lines follow the actual two-turn routes.
   for _,a in {{69,198,54, .35},{96,173,.35,50},{72,148,48,.35},{48,122,.35,52}} do
    box("ExitRoutePaint",Vector3.new(a[3],.025,a[4]),Vector3.new(math.sign(x)*a[1],.025,s*a[2]),orange)
   end
  end
  for _,x in {-52,-44,44,52} do
   box("Locker",Vector3.new(5,11,3),Vector3.new(x,6,s*247),dark)
   box("LockerHandle",Vector3.new(.15,1,.1),Vector3.new(x,6,s*245.4),pale)
  end
  for _,x in {-26,26} do box("RoomBench",Vector3.new(14,2,3),Vector3.new(x,1.5,s*240),steel) end
  sign("HAMNVERKET 2042\n01 MAGASIN | 02 LASTGÅRD | 03 FABRIK",Vector3.new(0,12,s*250.8),Vector3.new(32,9,.2),inward)
  sign("02 LASTGÅRD\nCENTRAL KONTROLLPUNKT",Vector3.new(0,18,s*30.7),Vector3.new(30,5,.2),inward)
  -- Functional bays on the dispatch buildings give them a recognizable purpose.
  for _,x in {-19,19} do box("OfficeDownpipe",Vector3.new(.5,24,.5),Vector3.new(x,12,s*42),steel) end
 end
 -- The west brick warehouse has repeated structural bays and roof sawteeth.
 for z=-72,72,24 do
  box("WarehouseButtress",Vector3.new(2,28,2),Vector3.new(-61.2,14,z),steel)
  box("WarehouseRoofVent",Vector3.new(30,2,8),Vector3.new(-104,31,z),steel)
  -- Repeated sawtooth roof bays give the brick warehouse a coherent industrial profile.
  local roof=box("SawtoothRoof",Vector3.new(78,.6,15),Vector3.new(-103,33.2,z),dark,Enum.Material.Metal,CFrame.Angles(-.2,0,0))
  roof.CastShadow=true
  local glazing=box("NorthlightGlazing",Vector3.new(74,3,.2),Vector3.new(-103,32.8,z+7.4),Color3.fromRGB(132,160,172),Enum.Material.Glass)
  glazing.Transparency=.3
  for _,x in {-131,-103,-75} do box("RoofGlazingMullion",Vector3.new(.2,3,.3),Vector3.new(x,32.8,z+7.2),steel) end
  light(Vector3.new(-103,26,z),Color3.fromRGB(226,201,157),30)
 end
 for z=-60,60,24 do
  box("FactoryColumn",Vector3.new(2,28,2),Vector3.new(64.8,14,z),steel)
  box("FactoryTruss",Vector3.new(78,1.2,1.2),Vector3.new(104,30,z),steel)
 end
 for _,s in {-1,1} do
  for z=20,60,10 do
   for _,x in {129,143} do box("CatwalkRailPost",Vector3.new(.2,3,.2),Vector3.new(x,12.5,s*z),orange) end
  end
  for _,x in {129,143} do box("CatwalkHandrail",Vector3.new(.2,.2,44),Vector3.new(x,14,s*42),orange) end
  light(Vector3.new(110,25,s*58),Color3.fromRGB(187,210,221),40)
 end
 for _,p in arena:GetChildren() do if p:GetAttribute("ArtContainer") then
  for dx=-7,7,2 do box("ContainerRib",Vector3.new(.18,10,28.2),p.Position+Vector3.new(dx,0,0),dark) end
  for _,dx in {-4,4} do box("CargoDoor",Vector3.new(7.6,10,.2),p.Position+Vector3.new(dx,0,-14.2),p.Color) end
  sign("NHU 2042 // KAJ 02",p.Position+Vector3.new(0,3,-14.4),Vector3.new(13,1.5,.2))
 end end
 for _,x in {-54,54} do
  box("Drain",Vector3.new(1,.03,180),Vector3.new(x,.02,0),dark,Enum.Material.DiamondPlate)
  for _,z in {-90,90} do light(Vector3.new(x,19,z),Color3.fromRGB(206,218,221),38) end
 end
 -- Puddles are restrained and placed in loading/drainage areas, away from stair treads.
 for _,p in {{-40,-92,12,5},{38,88,9,4},{-35,15,7,5},{42,-18,8,3},{96,152,13,4},{-96,-152,11,3}} do
  local puddle=box("RainPuddle",Vector3.new(p[3],.02,p[4]),Vector3.new(p[1],.035,p[2]),Color3.fromRGB(66,92,108),Enum.Material.Glass) puddle.Transparency=.35 puddle.Reflectance=.3
 end
 local art=game.ServerStorage:FindFirstChild("ZeroArt")
 if art and art:FindFirstChild("IndustrialPipes") then
  for _,p in {{-151,7,-165},{151,7,165},{70,7,-58},{70,7,58}} do local kit=art.IndustrialPipes:Clone() kit.Name="ReviewedServicePipes" kit:ScaleTo(1.5) kit:PivotTo(CFrame.new(unpack(p))*CFrame.Angles(0,0,math.pi/2)) kit.Parent=f end
 end
 -- Harbor scenery has no combat collision; the quay remains visually open to water.
 for _,z in {-98,105} do
  for _,x in {-205,-178} do box("GantryLeg",Vector3.new(3,64,3),Vector3.new(x,28,z),orange) end
  box("GantryBeam",Vector3.new(87,4,5),Vector3.new(-200,61,z),orange)
  box("CraneCabin",Vector3.new(7,7,7),Vector3.new(-180,55,z),steel)
  for y=5,45,20 do
   box("GantryBrace",Vector3.new(36,.7,.7),Vector3.new(-191,y+7,z),orange,Enum.Material.Metal,CFrame.Angles(0,0,.45))
  end
  box("CraneCable",Vector3.new(.2,35,.2),Vector3.new(-232,42,z),dark)
  box("CraneSpreader",Vector3.new(18,2,4),Vector3.new(-232,24,z),orange)
 end
 box("ShipHull",Vector3.new(38,16,140),Vector3.new(-243,-1,5),dark)
 box("ShipBridge",Vector3.new(28,24,26),Vector3.new(-243,17,47),steel)
 if art and art:FindFirstChild("ShippingContainer") then for n=1,6 do local c=art.ShippingContainer:Clone() c.Name="ShipCargo" c:ScaleTo(.6) c:PivotTo(CFrame.new(-243,10,10-n*16)) c.Parent=f end end
 for n=1,9 do
  local h=24+(n%4)*7 box("NorrhamnSkyline",Vector3.new(24,h,28),Vector3.new(-170+n*40,h/2-4,-320),dark,Enum.Material.Brick)
 end
 for _,x in {-22,22} do box("ControlEdge",Vector3.new(.3,.04,42),Vector3.new(x,.03,0),Color3.fromRGB(55,154,174),Enum.Material.Neon) end
 return f
end
return Detail
