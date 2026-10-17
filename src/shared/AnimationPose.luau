-- Original R15 preview/gameplay placeholder animation, no external clip dependency.
local Pose = {}
local bases=setmetatable({}, {__mode="k"})
function Pose.apply(m,time,speed,action,progress)
	local hero=m:GetAttribute("Hero")
	local wave=math.sin(time*10)*math.clamp(speed,0,1)*.5
	local recoil=if action=="Fire" then math.max(0,1-progress)*.18 else 0
	local reload=if action=="Reload" then math.sin(math.clamp(progress,0,1)*math.pi) else 0
	for _,j in m:GetDescendants() do if j:IsA("Motor6D") then
		local base=bases[j] or j.C0 bases[j]=base
		local name=j.Name
		if name=="RightUpperLegJoint" then j.C0=base*CFrame.Angles(wave,0,0)
		elseif name=="LeftUpperLegJoint" then j.C0=base*CFrame.Angles(-wave,0,0)
		elseif name=="RightUpperArmJoint" then
			local pitch=if hero=="ATLAS" then -.4 elseif hero=="TITAN" then -1 else -1.1
			j.C0=base*CFrame.Angles(pitch-recoil+reload*.7,0,-.1-reload*.25)
		elseif name=="LeftUpperArmJoint" then
			local pitch=if hero=="PHANTOM" then -1.1 elseif hero=="ATLAS" then -.4 else -.9
			j.C0=base*CFrame.Angles(pitch-recoil-reload*.4,0,if hero=="PHANTOM" then .1 else .45)
		elseif name=="UpperTorsoJoint" then j.C0=base*CFrame.Angles(0,math.sin(time*1.6)*.015,0)
		elseif name=="HeadJoint" then j.C0=base*CFrame.Angles(.015*math.sin(time*1.4),0,0) end
	end end
end
return Pose
