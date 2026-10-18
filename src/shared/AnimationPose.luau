-- Original R15 preview/gameplay placeholder animation, no external clip dependency.
local Pose = {}
function Pose.apply(m,time,speed,action,progress)
	local hero=m:GetAttribute("Hero")
	local wave=math.sin(time*10)*math.clamp(speed,0,1)*.5
	local recoil=if action=="Fire" then math.max(0,1-progress)*.18 else 0
	local reload=if action=="Reload" then math.sin(math.clamp(progress,0,1)*math.pi) else 0
	for _,j in m:GetDescendants() do if j:IsA("Motor6D") then
		-- Store the bind pose on the joint. Weak Instance-key caches can lose their
		-- Lua wrappers during GC and accidentally capture an already animated C0.
		local base=j:GetAttribute("ZeroBindC0")
		if not base then base=j.C0 j:SetAttribute("ZeroBindC0",base) end
		local name=j.Name
		if name=="RightUpperLegJoint" then j.C0=base*CFrame.Angles(wave,0,0)
		elseif name=="LeftUpperLegJoint" then j.C0=base*CFrame.Angles(-wave,0,0)
		elseif name=="RightUpperArmJoint" then
			local pitch=if hero=="ATLAS" then .4 elseif hero=="TITAN" then 1 else 1.05
			j.C0=base*CFrame.Angles(pitch+recoil-reload*.7,0,-.1-reload*.25)
		elseif name=="LeftUpperArmJoint" then
			local pitch=if hero=="PHANTOM" then 1.05 elseif hero=="ATLAS" then .4 else .85
			j.C0=base*CFrame.Angles(pitch+recoil+reload*.4,0,if hero=="PHANTOM" or hero=="ATLAS" then .1 else .75)
		elseif name=="RightLowerArmJoint" or name=="LeftLowerArmJoint" then j.C0=base*CFrame.Angles(.25+reload*.5,0,0)
		elseif name=="UpperTorsoJoint" then j.C0=base*CFrame.Angles(0,math.sin(time*1.6)*.015,0)
		elseif name=="HeadJoint" then j.C0=base*CFrame.Angles(.015*math.sin(time*1.4),0,0) end
	end end
end
return Pose
