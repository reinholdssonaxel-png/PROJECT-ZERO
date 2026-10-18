local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local SoundService=game:GetService("SoundService")
local Catalog=require(game.ReplicatedStorage.ZeroShared.HeroCatalog)
local Factory=require(game.ReplicatedStorage.ZeroShared.RigFactory)
local Weapons=require(game.ReplicatedStorage.ZeroShared.HeroWeapons)
local Pose=require(game.ReplicatedStorage.ZeroShared.AnimationPose)
local G=require(game.ReplicatedStorage.ZeroShared.Geometry)
local Menu={}
function Menu.create(player,flow)
 local self={isOpen=true,page="HOME",selected="VEX",pose="Idle",poseAt=0,orbit=0,zoom=1}
 local white,muted,orange=Color3.fromRGB(223,231,237),Color3.fromRGB(145,163,178),Color3.fromRGB(221,137,69)
 local gui=Instance.new("ScreenGui") gui.Name="ZeroMainMenu" gui.IgnoreGuiInset=true gui.ResetOnSpawn=false gui.DisplayOrder=30 gui.Parent=player:WaitForChild("PlayerGui")
 local bg=Instance.new("Frame") bg.Name="Backdrop" bg.Size=UDim2.fromScale(1,1) bg.BackgroundColor3=Color3.fromRGB(13,22,31) bg.BorderSizePixel=0 bg.Parent=gui
 local viewport=Instance.new("ViewportFrame") viewport.Name="Scene" viewport.BackgroundTransparency=1 viewport.Position=UDim2.fromScale(.35,.1) viewport.Size=UDim2.fromScale(.65,.9) viewport.Ambient=Color3.fromRGB(130,149,171) viewport.LightColor=Color3.fromRGB(216,195,173) viewport.LightDirection=Vector3.new(-1,-1,-2) viewport.Parent=bg
 local world=Instance.new("WorldModel") world.Parent=viewport
 local camera=Instance.new("Camera") camera.FieldOfView=37 camera.Parent=viewport viewport.CurrentCamera=camera
 local stage=Instance.new("Model") stage.Name="IndustrialStage" stage.Parent=world
 G.part(stage,"Floor",Vector3.new(28,.5,24),CFrame.new(0,-.3,0),Color3.fromRGB(36,48,59),Enum.Material.Concrete)
 G.part(stage,"TerminalWall",Vector3.new(26,15,1),CFrame.new(0,7,5),Color3.fromRGB(46,59,70),Enum.Material.Metal)
 for _,x in {-8,8} do
  G.part(stage,"StructuralColumn",Vector3.new(.7,15,2),CFrame.new(x,7,4.5),Color3.fromRGB(86,103,115),Enum.Material.Metal)
  G.part(stage,"WarningStrip",Vector3.new(.12,7,.1),CFrame.new(x,5,3.4),Color3.fromRGB(142,83,32),Enum.Material.Neon)
 end
 for n=1,7 do G.part(stage,"Shutter",Vector3.new(12,.15,.3),CFrame.new(0,n*1.5,4.3),Color3.fromRGB(29,42,54),Enum.Material.Metal) end
 local subject
 local function text(parent,name,value,pos,size,color,max)
  local l=Instance.new("TextLabel") l.Name=name l.Text=value l.Position=pos l.Size=size l.BackgroundTransparency=1 l.Font=Enum.Font.GothamBold l.TextColor3=color or white l.TextScaled=true l.TextXAlignment=Enum.TextXAlignment.Left l.TextYAlignment=Enum.TextYAlignment.Center l.Parent=parent
  l.TextWrapped=true
  local limit=Instance.new("UITextSizeConstraint") limit.MaxTextSize=max or 22 limit.MinTextSize=9 limit.Parent=l return l
 end
 local content=Instance.new("Frame") content.Name="Content" content.Size=UDim2.fromScale(1,1) content.BackgroundTransparency=1 content.Parent=bg
 local pages={}
 for _,name in {"HOME","PLAY","HEROES","ARMORY","SETTINGS","CREDITS","SELECT","RESULTS"} do local f=Instance.new("Frame") f.Name=name f.Size=UDim2.fromScale(1,1) f.BackgroundTransparency=1 f.Visible=false f.Parent=content pages[name]=f end
 local header=text(bg,"Logo","PROJECT: ZERO",UDim2.fromScale(.055,.065),UDim2.fromScale(.85,.105),white,76)
 header.RichText=true
 local sub=text(bg,"Subtitle","NORRHAMN  /  2042  /  ZERO INITIATIVE",UDim2.fromScale(.058,.17),UDim2.fromScale(.82,.04),orange,14)
 local footer=text(bg,"Footer","TRAINING PROTOTYPE   •   HAMNVERKET",UDim2.fromScale(.055,.95),UDim2.fromScale(.8,.025),muted,11)
 local fade=Instance.new("Frame") fade.Name="Transition" fade.Size=UDim2.fromScale(1,1) fade.BackgroundColor3=bg.BackgroundColor3 fade.BackgroundTransparency=1 fade.BorderSizePixel=0 fade.ZIndex=40 fade.Parent=bg
 local group=SoundService:FindFirstChild("ZeroAudio") or Instance.new("SoundGroup") group.Name="ZeroAudio" group.Volume=.7 group.Parent=SoundService
 local click=Instance.new("Sound") click.Name="ZeroMenuClick" click.SoundId="rbxasset://sounds/button.wav" click.Volume=.1 click.SoundGroup=group click.Parent=SoundService
 player:SetAttribute("ZeroAimSensitivity",1) player:SetAttribute("ZeroReducedEffects",false)
 local function button(parent,name,value,pos,size,callback,locked)
  local b=Instance.new("TextButton") b.Name=name b.Text="  "..value b.Position=pos b.Size=size b.BackgroundColor3=Color3.fromRGB(30,45,59) b.BackgroundTransparency=.1 b.BorderSizePixel=0 b.TextColor3=if locked then muted else white b.Font=Enum.Font.GothamBold b.TextScaled=true b.TextXAlignment=Enum.TextXAlignment.Left b.AutoButtonColor=false b.Selectable=not locked b.Active=not locked b.Parent=parent
  local limit=Instance.new("UITextSizeConstraint") limit.MaxTextSize=22 limit.MinTextSize=9 limit.Parent=b
  local stroke=Instance.new("UIStroke") stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border stroke.Color=Color3.fromRGB(66,86,102) stroke.Transparency=.4 stroke.Parent=b
  if not locked then
   b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.16),{BackgroundColor3=Color3.fromRGB(65,73,77),TextColor3=orange}):Play() end)
   b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.18),{BackgroundColor3=Color3.fromRGB(30,45,59),TextColor3=white}):Play() end)
   b.Activated:Connect(function() click:Play() callback() end)
  end
  return b
 end
 local show,choose
 local back=button(bg,"Back","←  BACK",UDim2.fromScale(.055,.88),UDim2.fromScale(.22,.052),function()
  local s=player:GetAttribute("ZeroSession")
  if s=="INSPECT" then flow:FireServer("Resume") elseif s=="SELECT" then flow:FireServer("Menu") else show("HOME") end
 end)
 local nav=Instance.new("Frame") nav.Name="Navigation" nav.Position=UDim2.fromScale(.055,.32) nav.Size=UDim2.fromScale(.34,.54) nav.BackgroundTransparency=1 nav.Parent=pages.HOME
 for i,name in {"PLAY","HEROES","ARMORY","SETTINGS","CREDITS"} do button(nav,"Nav_"..name,name,UDim2.fromScale(0,(i-1)*.19),UDim2.fromScale(1,.15),function() show(name) end) end
 text(pages.HOME,"Tagline","HUMAN OPERATIVES.\nADVANCED WARFARE.",UDim2.fromScale(.6,.78),UDim2.fromScale(.34,.12),muted,21)
 text(pages.PLAY,"Title","SELECT OPERATION",UDim2.fromScale(.055,.29),UDim2.fromScale(.6,.06),white,32)
 button(pages.PLAY,"Training","TRAINING  /  VEX vs AI",UDim2.fromScale(.055,.4),UDim2.fromScale(.42,.1),function() flow:FireServer("Play") end)
 text(pages.PLAY,"TrainingInfo","HAMNVERKET • 3-minute training round\n30-second hero selection • 15-second preparation",UDim2.fromScale(.058,.52),UDim2.fromScale(.43,.11),muted,18)
 button(pages.PLAY,"MultiplayerLocked","MULTIPLAYER  /  COMING SOON",UDim2.fromScale(.055,.67),UDim2.fromScale(.42,.07),nil,true)
 button(pages.PLAY,"ControlLocked","CONTROL / ESCORT  /  LOCKED",UDim2.fromScale(.055,.77),UDim2.fromScale(.42,.07),nil,true)
 local heroFrames={}
 for _,mode in {"HEROES","ARMORY","SELECT"} do
  local f=pages[mode]
  local cards=Instance.new("Frame") cards.Name="Cards" cards.BackgroundTransparency=1 cards.Position=UDim2.fromScale(.055,.29) cards.Size=UDim2.fromScale(.23,.55) cards.Parent=f
  for i,id in Catalog.Order do button(cards,"Hero_"..id,id..(if id=="VEX" then "" else "  / PREVIEW"),UDim2.fromScale(0,(i-1)*.125),UDim2.fromScale(1,.105),function() choose(id) end) end
  local info=text(f,"HeroInfo","",UDim2.fromScale(.73,.3),UDim2.fromScale(.235,.4),white,24)
  local status=text(f,"HeroStatus","",UDim2.fromScale(.73,.71),UDim2.fromScale(.235,.12),orange,16)
  local inspect=Instance.new("Frame") inspect.Name="Inspect" inspect.BackgroundTransparency=1 inspect.Position=UDim2.fromScale(.32,.78) inspect.Size=UDim2.fromScale(.39,.045) inspect.Parent=f
  for i,d in {{"RotateLeft","LEFT",-.4,0},{"RotateRight","RIGHT",.4,0},{"ZoomIn","+",0,-.15},{"ZoomOut","−",0,.15},{"ResetView","RESET",0,0}} do
   button(inspect,d[1],d[2],UDim2.fromScale((i-1)*.2,0),UDim2.fromScale(.185,1),function()
    if d[1]=="ResetView" then self.orbit,self.zoom=0,1 else self.orbit+=d[3] self.zoom=math.clamp(self.zoom+d[4],.65,1.45) end
    gui:SetAttribute("InspectYaw",self.orbit) gui:SetAttribute("InspectZoom",self.zoom)
   end)
  end
  local poses=Instance.new("Frame") poses.Name="Poses" poses.BackgroundTransparency=1 poses.Position=UDim2.fromScale(.32,.84) poses.Size=UDim2.fromScale(.39,.045) poses.Parent=f
  for i,a in {"Idle","Run","Fire","Reload"} do button(poses,"Pose_"..a,a,UDim2.fromScale((i-1)*.25,0),UDim2.fromScale(.235,1),function() self.pose=a self.poseAt=os.clock() gui:SetAttribute("PreviewAction",a) end) end
  heroFrames[mode]={cards=cards,info=info,status=status,poses=poses}
 end
 local deploy=button(pages.SELECT,"Deploy","DEPLOY VEX",UDim2.fromScale(.73,.85),UDim2.fromScale(.235,.065),function() if self.selected=="VEX" then flow:FireServer("Deploy","VEX") end end)
 local timer=text(pages.SELECT,"SelectTimer","",UDim2.fromScale(.055,.23),UDim2.fromScale(.8,.04),orange,18)
 local settings=pages.SETTINGS
 text(settings,"Title","FIELD SETTINGS",UDim2.fromScale(.055,.29),UDim2.fromScale(.65,.065),white,32)
 local volume=text(settings,"VolumeValue","",UDim2.fromScale(.055,.4),UDim2.fromScale(.47,.06),white,23)
 local sensitivity=text(settings,"SensitivityValue","",UDim2.fromScale(.055,.53),UDim2.fromScale(.47,.06),white,23)
 local quality=text(settings,"QualityValue","",UDim2.fromScale(.055,.66),UDim2.fromScale(.47,.06),white,23)
 local function refreshSettings()
  volume.Text="MASTER AUDIO  /  "..math.floor(group.Volume*100+.5).."%"
  sensitivity.Text=string.format("FPS AIM  /  %.1f ×",player:GetAttribute("ZeroAimSensitivity"))
  quality.Text="LOCAL EFFECTS  /  "..(if player:GetAttribute("ZeroReducedEffects") then "LOW" else "HIGH")
 end
 for _,d in {{"VolumeMinus",.4,-.1},{"VolumePlus",.4,.1},{"SensitivityMinus",.53,-.1},{"SensitivityPlus",.53,.1}} do
  local name,y,delta=d[1],d[2],d[3]
  button(settings,name,if delta<0 then "  −" else "  +",UDim2.fromScale(if delta<0 then .55 else .65,y),UDim2.fromScale(.08,.065),function()
   if string.find(name,"Volume") then group.Volume=math.clamp(group.Volume+delta,0,1) else player:SetAttribute("ZeroAimSensitivity",math.clamp(player:GetAttribute("ZeroAimSensitivity")+delta,.2,2)) end refreshSettings()
  end)
 end
 button(settings,"QualityToggle","TOGGLE",UDim2.fromScale(.55,.66),UDim2.fromScale(.18,.065),function()
  local low=not player:GetAttribute("ZeroReducedEffects") player:SetAttribute("ZeroReducedEffects",low) game.Lighting.GlobalShadows=not low refreshSettings()
 end)
 text(settings,"SettingsNote","Applies this session. FPS aim controls this game's camera.\nLOW reduces local effects and shadows. Roblox device quality stays in Roblox settings.",UDim2.fromScale(.055,.77),UDim2.fromScale(.69,.075),muted,15)
 text(pages.CREDITS,"Credits","PROJECT: ZERO\nAn original Roblox hero-shooter prototype\n\nNORRHAMN / 2042 • ZERO INITIATIVE\nLuau, Rojo and fitted human R15 models\nArmor meshes created with Roblox AI, then reviewed and adapted\n\nPoly Haven / Jorge Camacho: CC0 industrial pipes\nCreator Store: Elttob, DesiredDestinyx1, circles_squared\nSources, AI provenance and terms: repository docs/ASSETS.md\n\nVisual prototype • only VEX currently playable",UDim2.fromScale(.055,.29),UDim2.fromScale(.66,.53),white,23)
 local results=text(pages.RESULTS,"Results","",UDim2.fromScale(.055,.32),UDim2.fromScale(.53,.3),white,34)
 button(pages.RESULTS,"ReturnMenu","RETURN TO MAIN MENU",UDim2.fromScale(.055,.68),UDim2.fromScale(.43,.08),function() flow:FireServer("Menu") end)
 button(pages.RESULTS,"PlayAgain","PLAY AGAIN",UDim2.fromScale(.055,.79),UDim2.fromScale(.43,.065),function() flow:FireServer("Play") end)
 choose=function(id)
  local nextSubject=if self.page=="ARMORY" then Weapons.create(id,world,true) else Factory.create(id.."_Menu","Alpha",Vector3.zero,id)
  if subject then subject:Destroy() end subject=nextSubject subject.Parent=world self.selected=id self.orbit,self.zoom=0,1 gui:SetAttribute("SelectedHero",id)
  gui:SetAttribute("InspectYaw",0) gui:SetAttribute("InspectZoom",1)
  if self.page=="ARMORY" then for _,p in subject:GetDescendants() do if p:IsA("BasePart") then p.Anchored=true p.CanCollide=false end end subject:ScaleTo(2.5)
  else for _,p in subject:GetDescendants() do if p:IsA("BasePart") then p.Anchored=p.Name=="HumanoidRootPart" p.CanCollide=false end end end
  local h=Catalog.Heroes[id]
  for _,f in heroFrames do
   f.info.Text=id.."\n"..h.Role.." / "..h.HP.." HP\n\n"..h.Name.."\n"..h.Weapon
   f.status.Text=if id=="VEX" then "PLAYABLE\nVX-7 + Dash\nGrenade / ultimate pending" else "VISUAL PREVIEW\nGameplay kit locked\n"..h.Kit
  end
  deploy.Text=if id=="VEX" then "  DEPLOY VEX" else "  KIT LOCKED / PREVIEW ONLY" deploy.Active=id=="VEX" deploy.Selectable=id=="VEX"
  heroFrames.ARMORY.status.Text=h.Silhouette.."\n\nPLANNED KIT: "..h.Kit
 end
 local function responsive()
  local narrow=gui.AbsoluteSize.X<700
  for _,f in heroFrames do
   f.cards.Position=if narrow then UDim2.fromScale(.055,.27) else UDim2.fromScale(.055,.29)
   f.cards.Size=if narrow then UDim2.fromScale(.25,.56) else UDim2.fromScale(.23,.55)
   f.info.Position=UDim2.fromScale(.73,.3) f.info.Size=UDim2.fromScale(.235,.4)
  end
  nav.Size=UDim2.fromScale(if narrow then .43 else .34,.54)
 end
 show=function(page)
  self.page=page gui:SetAttribute("Page",page)
  for name,f in pages do f.Visible=name==page end
  back.Visible=page~="HOME" and page~="RESULTS"
  header.Text=if page=="HOME" then 'PROJECT: <font color="#DD8945">ZERO</font>' elseif page=="SELECT" then "CHOOSE YOUR OPERATIVE" else "ZERO // "..page
  sub.Text=if page=="HOME" then "NORRHAMN / 2042 / ZERO INITIATIVE" else "HAMNVERKET / OPERATIVE COMMAND"
  viewport.Visible=page=="HOME" or page=="PLAY" or heroFrames[page]~=nil or page=="RESULTS"
  viewport.Position=if heroFrames[page] then UDim2.fromScale(.29,.24) else UDim2.fromScale(.38,.15)
  viewport.Size=if heroFrames[page] then UDim2.fromScale(.43,.59) else UDim2.fromScale(.62,.8)
  if page=="HOME" or page=="PLAY" or page=="RESULTS" then choose("VEX") elseif heroFrames[page] then choose(self.selected) end
  if page=="RESULTS" then results.Text="TRAINING COMPLETE\n\n"..(player:GetAttribute("ZeroResultKills") or 0).." ELIMINATIONS\n"..(player:GetAttribute("ZeroResultDeaths") or 0).." DEATHS" end
  heroFrames.ARMORY.poses.Visible=false
  fade.BackgroundTransparency=.4 TweenService:Create(fade,TweenInfo.new(.25),{BackgroundTransparency=1}):Play()
  refreshSettings() responsive()
 end
 local function sync()
  local s=player:GetAttribute("ZeroSession") or "MENU"
  self.isOpen=s=="MENU" or s=="SELECT" or s=="RESULTS" or s=="INSPECT" gui.Enabled=self.isOpen
  if self.isOpen then workspace.CurrentCamera.CameraType=Enum.CameraType.Scriptable UIS.MouseBehavior=Enum.MouseBehavior.Default UIS.MouseIconEnabled=true
   show(if s=="SELECT" then "SELECT" elseif s=="RESULTS" then "RESULTS" elseif s=="INSPECT" then "HEROES" else "HOME")
  else UIS.MouseIconEnabled=false end
 end
 player:GetAttributeChangedSignal("ZeroSession"):Connect(sync)
 gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(responsive)
 UIS.InputBegan:Connect(function(input,processed)
  if processed then return end
  if input.KeyCode==Enum.KeyCode.M then flow:FireServer("Menu")
  elseif input.KeyCode==Enum.KeyCode.H and player:GetAttribute("ZeroSession")=="ACTIVE" then flow:FireServer("Inspect") end
 end)
 RunService:BindToRenderStep("ZeroMainMenu",Enum.RenderPriority.Camera.Value+3,function(dt)
  if not self.isOpen then return end
  UIS.MouseBehavior=Enum.MouseBehavior.Default UIS.MouseIconEnabled=true workspace.CurrentCamera.CameraType=Enum.CameraType.Scriptable
  if self.page=="SELECT" then timer.Text="VEX AVAILABLE / OTHER KITS LOCKED  •  AUTO-DEPLOY IN "..math.max(0,math.ceil((player:GetAttribute("ZeroSelectEnd") or workspace:GetServerTimeNow())-workspace:GetServerTimeNow())).."s" end
  if not subject then return end
  local aspect=math.max(.15,viewport.AbsoluteSize.X/math.max(1,viewport.AbsoluteSize.Y))
  camera.FieldOfView=math.clamp(math.deg(2*math.atan(math.tan(math.rad(18.5))*math.max(1,.8/aspect))),37,82)
  if self.page=="ARMORY" then
   subject:PivotTo(CFrame.new(0,2,0)*CFrame.Angles(0,self.orbit+1.2+math.sin(os.clock()*.25)*.25,0))
   local center,size=subject:GetBoundingBox()
   local distance=math.max(10,size.Magnitude*.65/math.tan(math.rad(camera.FieldOfView/2))*math.max(1,1/aspect))
   camera.CFrame=CFrame.lookAt(center.Position+Vector3.new(0,1,-distance*self.zoom),center.Position)
  else
   subject.HumanoidRootPart.CFrame=CFrame.new(0,3.1,0)*CFrame.Angles(0,self.orbit-.18+math.sin(os.clock()*.22)*.08,0)
   local elapsed=os.clock()-self.poseAt local progress=if self.pose=="Reload" then (elapsed%2.5)/1.8 else (elapsed%.5)/.2
   Pose.apply(subject,os.clock(),if self.pose=="Run" and heroFrames[self.page] then 1 else 0,if heroFrames[self.page] then self.pose else "Idle",progress)
   local distance=14*Catalog.Heroes[self.selected].Scale*self.zoom*math.max(1,.72/aspect)
   camera.CFrame=CFrame.lookAt(Vector3.new(distance*.32,4.2,-distance),Vector3.new(0,2.8,0))
  end
 end)
 sync()
 return self
end
return Menu
