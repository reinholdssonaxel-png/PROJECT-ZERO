local Suite={}
function Suite.run()
	local Catalog=require(game.ReplicatedStorage.ZeroShared.HeroCatalog)
	local Factory=require(game.ReplicatedStorage.ZeroShared.RigFactory)
	local Pose=require(game.ReplicatedStorage.ZeroShared.AnimationPose)
	local expected={TITAN=700,ATLAS=650,VEX=275,PHANTOM=250,HAVOC=300,SPECTRE=225,NOVA=250,ECHO=275}
	local checks=0
	local function check(ok,message) assert(ok,message) checks+=1 end
	check(#Catalog.Order==8,"eight canonical heroes")
	for _,id in Catalog.Order do
		local m=Factory.create(id,"Alpha",Vector3.new(0,50,0),id)
		local ok,err=pcall(function()
			check(m.Humanoid.RigType==Enum.HumanoidRigType.R15,id.." R15")
			check(m.Humanoid.MaxHealth==expected[id],id.." canonical HP")
			check(m:GetAttribute("Hero")==id,id.." identity")
			check(m:GetAttribute("WeaponName")==Catalog.Heroes[id].Weapon,id.." weapon")
			check(m:FindFirstChild("Visor")~=nil,id.." visual identity")
			check(m:GetAttribute("ArtStatus")=="MESH",id.." reviewed mesh art available")
			check(m.UpperTorso:IsA("MeshPart"),id.." native R15 human body mesh")
			local motors,parts,sources=0,0,0
			for _,v in m:GetDescendants() do
				if v:IsA("Motor6D") then motors+=1 end
				if v:IsA("BasePart") then parts+=1 end
				if v:IsA("LuaSourceContainer") then sources+=1 end
			end
			check(motors==15,id.." full articulated R15 skeleton")
			check(parts<100,id.." part budget")
			check(sources==0,id.." no embedded gameplay scripts")
			local mounts=0
			for _,v in m:GetDescendants() do if v:IsA("BasePart") and v:GetAttribute("ArmorLimb") then
				local weld=v:FindFirstChild("ArmorMount")
				check(not v.Anchored and v.Massless and not v.CanCollide and not v.CanQuery and not v.CanTouch,id.." armor cannot affect hitboxes/physics")
				check(weld and weld.Part0==m[v:GetAttribute("ArmorLimb")] and weld.Part1==v,id.." correct single-limb armor mount")
				mounts+=1
			end end
			check(mounts>=8,id.." articulated mesh armor fitted")
			for _,action in {"Idle","Run","Fire","Reload"} do Pose.apply(m,1,.5,action,.5) end
			check(m.Humanoid:FindFirstChildOfClass("Animator")~=nil,id.." future clip support")
			check(Catalog.Heroes[id].Playable==(id=="VEX"),id.." honest selection availability")
			if id=="PHANTOM" then
				local left=0
				for _,v in m:GetDescendants() do if v:IsA("WeldConstraint") and v.Part0==m.LeftHand and v.Part1:GetAttribute("GripHand")=="Left" then left+=1 end end
				check(left>=1,"PHANTOM left pistol is held in left hand")
			elseif id=="ATLAS" then
				check(m:FindFirstChild("PoweredGauntletLeft")~=nil and m:FindFirstChild("PoweredGauntletRight")~=nil,"ATLAS paired fitted gauntlets")
			end
		end)
		m:Destroy()
		if not ok then error(err) end
	end
	local arena=workspace:FindFirstChild("ZeroArena")
	if arena then
		check(#arena:GetDescendants()<1600,"arena instance budget")
		local parts,meshes=0,0
		for _,v in arena:GetDescendants() do if v:IsA("BasePart") then parts+=1 if v:IsA("MeshPart") then meshes+=1 end end end
		check(parts<1100,"arena part budget")
		check(meshes<=40,"bounded imported mesh count")
	end
	print("[PROJECT ZERO] PASS: "..checks.." hero/art assertions")
	return checks
end
return Suite
