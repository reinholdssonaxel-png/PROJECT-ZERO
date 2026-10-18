local G=require(script.Parent.Geometry)
local Catalog=require(script.Parent.HeroCatalog)
local Fit=require(script.Parent.ArmorFit)
local Weapons=require(script.Parent.HeroWeapons)
local Style={}
-- Distinct meshes and fitted proportions; shared limb shells are modular equipment.
local shapes={
 TITAN={chest=Vector3.new(2.7,1.55,1.6),helmet=Vector3.new(1.55,1.5,1.55),shoulder=1.4,arm=1.18,leg=1.2},
 ATLAS={chest=Vector3.new(2.15,1.35,1.45),helmet=Vector3.new(1.4,1.4,1.4),shoulder=1.1,arm=1.3,leg=1.1},
 VEX={chest=Vector3.new(2.08,1.3,1.28),helmet=Vector3.new(1.32,1.38,1.35),shoulder=.9,arm=1,leg=1},
 PHANTOM={chest=Vector3.new(1.85,1.25,1.15),helmet=Vector3.new(1.28,1.35,1.3),shoulder=.68,arm=.86,leg=.9},
 HAVOC={chest=Vector3.new(2.35,1.5,1.45),helmet=Vector3.new(1.48,1.35,1.48),shoulder=1.15,arm=1.15,leg=1.1},
 SPECTRE={chest=Vector3.new(1.95,1.35,1.22),helmet=Vector3.new(1.4,1.55,1.45),shoulder=.65,arm=.9,leg=.9},
 NOVA={chest=Vector3.new(1.95,1.3,1.25),helmet=Vector3.new(1.3,1.4,1.35),shoulder=.8,arm=.95,leg=.95},
 ECHO={chest=Vector3.new(2.05,1.35,1.3),helmet=Vector3.new(1.35,1.4,1.4),shoulder=.85,arm=1,leg=1},
}
function Style.decorate(m,id,faction)
 local assets=game.ReplicatedStorage:FindFirstChild("ZeroAssets")
 local art=assets and assets:FindFirstChild("HeroArt")
 local kit=art and art:FindFirstChild(id)
 if not kit or not kit:FindFirstChild("Helmet") or not kit:FindFirstChild("Chest") then
  require(script.Parent.HeroStyle).decorate(m,id,faction) m:SetAttribute("ArtStatus","FALLBACK") return
 end
 local h,s=Catalog.Heroes[id],shapes[id]
 local dark,metal=Color3.fromRGB(25,30,37),Color3.fromRGB(110,123,132)
 for _,p in m:GetChildren() do if p:IsA("BasePart") then p.Color=dark p.Material=Enum.Material.Fabric end end
 m.Head.Color=Color3.fromRGB(179,141,116) m.Head.Material=Enum.Material.SmoothPlastic
 local function attach(name,body,size,cf,color,material)
  local p=G.part(m,name,size,m[body].CFrame*cf,color or h.Primary,material or Enum.Material.Metal)
  p.Anchored,p.Massless,p.CanCollide,p.CanQuery,p.CanTouch=false,true,false,false,false
  p:SetAttribute("ArmorLimb",body)
  local w=Instance.new("WeldConstraint") w.Name,w.Part0,w.Part1,w.Parent="ArmorMount",m[body],p,p
  return p
 end
 local function plate(name,body,size,pos,color,mat) return attach(name,body,size,CFrame.new(pos),color,mat) end
 -- Keep the original server hit volumes while fitting a slimmer human undersuit
 -- inside hollow armor. The visible suit must not fill the plate's hollow interior.
 local narrow=if id=="PHANTOM" or id=="NOVA" then .84 elseif id=="TITAN" then 1 else .92
 for _,body in m:GetChildren() do if body:IsA("MeshPart") then
  local suit=body:Clone() suit:ClearAllChildren() suit.Name="Undersuit_"..body.Name suit.Size*=Vector3.new(narrow,.98,.65)
  suit.Color=if id=="NOVA" then Color3.fromRGB(145,158,168) elseif id=="TITAN" or id=="ECHO" or id=="SPECTRE" then h.Primary:Lerp(dark,.35) else dark
  suit.CanCollide,suit.CanQuery,suit.CanTouch,suit.Massless=false,false,false,true
  suit:SetAttribute("ArmorLimb",body.Name)
  local w=Instance.new("WeldConstraint") w.Name,w.Part0,w.Part1,w.Parent="ArmorMount",body,suit,suit
  suit.Parent=m body.Transparency=1
 end end
 Fit.equip(kit.Helmet,m,"Head","MeshHelmet",s.helmet,CFrame.new(0,.05,0))
 Fit.equip(kit.Chest,m,"UpperTorso","MeshCuirass",s.chest,CFrame.new(0,-.03,-.12))
 local common=art:FindFirstChild("Common")
 for _,side in {"Left","Right"} do
  local sign=if side=="Left" then -1 else 1
  for _,d in {{"Shoulder","UpperArm",Vector3.new(.95,.65,1.05)*s.shoulder,CFrame.new(sign*.06,.28,0)},
   {"Forearm","LowerArm",Vector3.new(.72,.9,.78)*s.arm,CFrame.identity},
   {"Shin","UpperLeg",Vector3.new(.76,.7,.22)*s.leg,CFrame.new(0,-.05,-.43)},
   {"Shin","LowerLeg",Vector3.new(.8,.9,.3)*s.leg,CFrame.new(0,0,-.42)}} do
   if common and common:FindFirstChild(d[1]) then
    local group=Fit.equip(common[d[1]],m,side..d[2],d[1]..side..d[2],d[3],d[4])
    for _,p in group:GetDescendants() do if p:IsA("MeshPart") then p.TextureID="" p.Color=h.Primary:Lerp(Color3.new(1,1,1),.12) p.Material=Enum.Material.Metal end end
   end
  end
  plate("SuitSeam"..side,side.."UpperArm",Vector3.new(.08,.35,.06),Vector3.new(sign*.34,0,-.4),h.Accent)
 end
 local visor=plate("Visor","Head",Vector3.new(1.1,.11,.05),Vector3.new(0,.16,-s.helmet.Z/2-.02),h.Accent:Lerp(Color3.new(),.25),Enum.Material.Neon)
 if id=="VEX" or id=="PHANTOM" then plate("TacticalRespirator","Head",Vector3.new(.96,.42,.13),Vector3.new(0,-.22,-.62),dark) end
 if id=="TITAN" then
  visor.Size=Vector3.new(1.1,.075,.05)
  plate("BlastCollar","UpperTorso",Vector3.new(2.6,.28,1.5),Vector3.new(0,.65,0),h.Primary)
  for _,x in {-.5,.5} do plate("CannonCell","UpperTorso",Vector3.new(.25,.75,.3),Vector3.new(x,0,.9),h.Accent) end
 elseif id=="ATLAS" then
  for _,side in {"Left","Right"} do
   local sign=if side=="Left" then -1 else 1
   local gauntlet=assets:FindFirstChild("WeaponArt") and assets.WeaponArt:FindFirstChild("ATLAS")
   if gauntlet then Fit.equip(gauntlet,m,side.."Hand","PoweredGauntlet"..side,Vector3.new(1.12,.8,1.15),CFrame.new(0,-.1,-.1))
   else plate("PoweredGauntlet"..side,side.."Hand",Vector3.new(1.12,.7,1.15),Vector3.new(0,-.1,-.1),h.Primary) end
   for _,limb in {"UpperArm","UpperLeg","LowerLeg"} do
    local p=attach("Hydraulic"..side..limb,side..limb,Vector3.new(.85,.14,.14),CFrame.new(sign*.45,0,.15)*CFrame.Angles(0,0,math.pi/2),metal) p.Shape=Enum.PartType.Cylinder
   end
  end
  plate("HydraulicPowerUnit","UpperTorso",Vector3.new(.7,1.5,.5),Vector3.new(0,.1,.85),h.Primary)
 elseif id=="PHANTOM" then
  visor.Size=Vector3.new(.7,.07,.06)
  for _,x in {-.48,.48} do plate("SplitCoat","LowerTorso",Vector3.new(.62,1.35,.12),Vector3.new(x,-.65,.5),dark,Enum.Material.Fabric) end
 elseif id=="HAVOC" then
  for n=1,4 do local p=attach("GrenadeBandolier","UpperTorso",Vector3.new(.42,.22,.22),CFrame.new(-.65+n*.27,.55-n*.2,-.8)*CFrame.Angles(0,0,math.pi/2-.5),metal) p.Shape=Enum.PartType.Cylinder end
  plate("BlastShield","LeftUpperArm",Vector3.new(.9,.85,.28),Vector3.new(0,0,-.55),h.Primary)
 elseif id=="SPECTRE" then
  visor.Transparency=1
  for _,x in {-.28,.28} do local p=plate("OpticalLens","Head",Vector3.new(.23,.23,.07),Vector3.new(x,.15,-.76),h.Accent,Enum.Material.Neon) p.Shape=Enum.PartType.Ball end
  plate("ReconAntenna","UpperTorso",Vector3.new(.045,1.5,.045),Vector3.new(.55,.8,.8),metal)
 elseif id=="NOVA" then
  plate("MedicalPack","UpperTorso",Vector3.new(1.15,1.15,.45),Vector3.new(0,0,.85),h.Primary)
  for _,sign in {-1,1} do attach("MedicChevron","UpperTorso",Vector3.new(.45,.09,.05),CFrame.new(sign*.16,.1,-.71)*CFrame.Angles(0,0,sign*.7),h.Accent,Enum.Material.Neon) end
  for _,x in {-.65,.65} do local p=attach("OxygenCylinder","UpperTorso",Vector3.new(.8,.25,.25),CFrame.new(x,0,.85)*CFrame.Angles(0,0,math.pi/2),metal) p.Shape=Enum.PartType.Cylinder end
 elseif id=="ECHO" then
  for _,side in {"Left","Right"} do local p=plate("HologramEmitter"..side,side.."LowerArm",Vector3.new(.035,.7,1.05),Vector3.new(if side=="Left" then -.5 else .5,0,0),h.Accent,Enum.Material.Neon) p.Transparency=.6 end
  plate("ProjectionCore","UpperTorso",Vector3.new(.3,.3,.06),Vector3.new(0,.1,-.72),h.Accent,Enum.Material.Neon).Shape=Enum.PartType.Ball
 end
 plate("TeamStripe","UpperTorso",Vector3.new(1.3,.055,.045),Vector3.new(0,.48,-s.chest.Z/2-.03),if faction=="Alpha" then Color3.fromRGB(75,211,240) else Color3.fromRGB(255,121,64),Enum.Material.Neon)
 local gun=Weapons.create(id,m) gun:PivotTo(m.RightHand.CFrame*CFrame.Angles(-1.3,0,0)*CFrame.new(0,.2,-.4))
 for _,p in gun:GetDescendants() do if p:IsA("BasePart") then
  p.Anchored,p.CanCollide,p.CanQuery,p.CanTouch,p.Massless=false,false,false,false,true
  local hand=if p:GetAttribute("GripHand")=="Left" then m.LeftHand else m.RightHand
  if hand==m.LeftHand then p.CFrame=hand.CFrame*m.RightHand.CFrame:ToObjectSpace(p.CFrame) end
  local w=Instance.new("WeldConstraint") w.Part0,w.Part1,w.Parent=hand,p,p
 end end
 m:SetAttribute("WeaponName",h.Weapon) m:SetAttribute("ArtStatus","MESH")
end
return Style
