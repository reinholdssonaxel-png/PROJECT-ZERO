local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local Catalog=require(game.ReplicatedStorage.ZeroShared.HeroCatalog)
local Factory=require(game.ReplicatedStorage.ZeroShared.RigFactory)
local Pose=require(game.ReplicatedStorage.ZeroShared.AnimationPose)
local Armory={isOpen=false}
function Armory.create(player)
	local gui=Instance.new("ScreenGui") gui.Name="ZeroArmory" gui.IgnoreGuiInset=true gui.ResetOnSpawn=false gui.DisplayOrder=20 gui.Enabled=false gui.Parent=player.PlayerGui
	local bg=Instance.new("Frame") bg.Size=UDim2.fromScale(1,1) bg.BackgroundColor3=Color3.new(1,1,1) bg.BorderSizePixel=0 bg.Parent=gui
	local grad=Instance.new("UIGradient") grad.Color=ColorSequence.new(Color3.fromRGB(12,20,29),Color3.fromRGB(35,53,68)) grad.Rotation=30 grad.Parent=bg
	local function label(text,pos,size,color,fontSize)
		local l=Instance.new("TextLabel") l.Text=text l.Position=pos l.Size=size l.BackgroundTransparency=1 l.TextColor3=color or Color3.fromRGB(220,231,238) l.Font=Enum.Font.GothamBold l.TextScaled=true l.TextXAlignment=Enum.TextXAlignment.Left l.Parent=bg
		local limit=Instance.new("UITextSizeConstraint") limit.MaxTextSize=fontSize or 24 limit.MinTextSize=9 limit.Parent=l
		return l
	end
	local function button(text,pos,size,callback)
		local b=Instance.new("TextButton") b.Text=text b.Position=pos b.Size=size b.BackgroundColor3=Color3.fromRGB(38,56,70) b.BorderSizePixel=0 b.TextColor3=Color3.fromRGB(217,230,238) b.Font=Enum.Font.GothamBold b.TextScaled=true b.Parent=bg
		local limit=Instance.new("UITextSizeConstraint") limit.MaxTextSize=17 limit.Parent=b
		b.Activated:Connect(callback)
		return b
	end
	label("ZERO // OPERATIVE ARCHIVE",UDim2.fromScale(.04,.04),UDim2.fromScale(.7,.055),nil,30)
	label("NORRHAMN 2042  /  EIGHT HUMAN OPERATIVES",UDim2.fromScale(.04,.105),UDim2.fromScale(.7,.035),Color3.fromRGB(103,180,208),13)
	local viewport=Instance.new("ViewportFrame") viewport.Name="HeroPreview" viewport.Position=UDim2.fromScale(.31,.15) viewport.Size=UDim2.fromScale(.36,.78) viewport.BackgroundTransparency=1 viewport.Ambient=Color3.fromRGB(163,177,196) viewport.LightColor=Color3.fromRGB(250,228,207) viewport.LightDirection=Vector3.new(-1,-1,-2) viewport.Parent=bg
	local world=Instance.new("WorldModel") world.Parent=viewport
	local camera=Instance.new("Camera") camera.FieldOfView=35 camera.CFrame=CFrame.lookAt(Vector3.new(7,4.8,-12),Vector3.new(0,2.8,0)) camera.Parent=viewport viewport.CurrentCamera=camera
	local name=label("VEX",UDim2.fromScale(.69,.25),UDim2.fromScale(.28,.09),nil,48)
	local role=label("",UDim2.fromScale(.69,.35),UDim2.fromScale(.27,.04),nil,18)
	local identity=label("",UDim2.fromScale(.69,.42),UDim2.fromScale(.27,.07),nil,18)
	local weapon=label("",UDim2.fromScale(.69,.51),UDim2.fromScale(.27,.06),nil,18)
	local silhouette=label("",UDim2.fromScale(.69,.59),UDim2.fromScale(.27,.08),nil,15)
	local status=label("",UDim2.fromScale(.69,.7),UDim2.fromScale(.27,.11),nil,14)
	local preview,selected,action,actionAt="","VEX","Idle",0
	local cards={}
	local function choose(id)
		local h=Catalog.Heroes[id]
		local nextPreview=Factory.create(id.."_Preview","Alpha",Vector3.zero,id)
		if typeof(preview)=="Instance" then preview:Destroy() end
		preview=nextPreview selected=id gui:SetAttribute("SelectedHero",id)
		for _,p in preview:GetDescendants() do if p:IsA("BasePart") then p.Anchored=p.Name=="HumanoidRootPart" p.CanCollide=false end end
		preview.Parent=world
		name.Text,role.Text,identity.Text=id,string.upper(h.Role).."  /  "..h.HP.." HP",h.Name.."\n"..h.Origin
		name.TextColor3,role.TextColor3=h.Accent,h.Accent
		weapon.Text,silhouette.Text=h.Weapon,h.Silhouette
		status.Text=if h.Playable then "VEX: PLAYABLE\nDash available / grenade + ultimate pending" else "VISUAL PROTOTYPE\nWeapon and animation previews ready\nGameplay kit remains locked"
		status.TextColor3=if h.Playable then Color3.fromRGB(110,222,193) else Color3.fromRGB(230,177,109)
		for key,b in cards do b.BackgroundColor3=if key==id then h.Primary else Color3.fromRGB(30,44,57) end
	end
	for i,id in Catalog.Order do
		local h=Catalog.Heroes[id]
		cards[id]=button(id.."  /  "..string.upper(h.Role)..(if h.Playable then "" else "  [PREVIEW]"),UDim2.fromScale(.04,.19+(i-1)*.083),UDim2.fromScale(.25,.065),function() choose(id) end)
		cards[id].Name="Hero_"..id
	end
	for i,a in {"Idle","Run","Fire","Reload"} do
		local b=button(a,UDim2.fromScale(.32+(i-1)*.085,.91),UDim2.fromScale(.078,.04),function() action=a actionAt=os.clock() gui:SetAttribute("PreviewAction",a) end)
		b.Name="Pose_"..a
	end
	local function close()
		Armory.isOpen=false gui.Enabled=false
		workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
		player.CameraMode=Enum.CameraMode.LockFirstPerson
		UIS.MouseIconEnabled=false
	end
	button("RETURN TO VEX  /  H",UDim2.fromScale(.69,.87),UDim2.fromScale(.27,.065),close)
	label("Visual previews do not unlock unimplemented kits.",UDim2.fromScale(.04,.94),UDim2.fromScale(.26,.025),Color3.fromRGB(132,152,167),11)
	UIS.InputBegan:Connect(function(input,processed)
		if processed or input.KeyCode~=Enum.KeyCode.H then return end
		if Armory.isOpen then close() else
			Armory.isOpen=true gui.Enabled=true workspace.CurrentCamera.CameraType=Enum.CameraType.Scriptable UIS.MouseIconEnabled=true UIS.MouseBehavior=Enum.MouseBehavior.Default
		end
	end)
	player.CharacterAdded:Connect(function() if Armory.isOpen then close() end end)
	RunService:BindToRenderStep("ZeroArmory",Enum.RenderPriority.Camera.Value+3,function()
		if not Armory.isOpen then return end
		UIS.MouseBehavior=Enum.MouseBehavior.Default UIS.MouseIconEnabled=true
		local elapsed=os.clock()-actionAt
		local progress=if action=="Reload" then (elapsed%2.5)/1.8 elseif action=="Fire" then (elapsed%(.5))/.2 else 0
		Pose.apply(preview,os.clock(),if action=="Run" then 1 else 0,action,progress)
		preview.HumanoidRootPart.CFrame=CFrame.new(0,3.1,0)*CFrame.Angles(0,math.sin(os.clock()*.18)*.18,0)
	end)
	choose("VEX")
	return Armory
end
return Armory
