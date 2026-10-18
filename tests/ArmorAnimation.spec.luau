-- Engine regression: armor follows moving R15 limbs; repeated poses never drift.
local Suite={}
function Suite.run()
 local Shared=game.ReplicatedStorage.ZeroShared
 local Factory,Pose=require(Shared.RigFactory),require(Shared.AnimationPose)
 local heartbeat=game:GetService("RunService").Heartbeat
 local report={assertions=0,maxMountError=0,heroes={}}
 local function check(ok,message) assert(ok,message) report.assertions+=1 end
 for _,id in require(Shared.HeroCatalog).Order do
  local m=Factory.create("ZeroArmorMotion_"..id,"Alpha",Vector3.new(0,400,0),id)
  m.HumanoidRootPart.Anchored=true m.Parent=workspace
  local ok,err=pcall(function()
   local mounts,motors={},{}
   local parts,meshes=0,0
   for _,v in m:GetDescendants() do
    if v:IsA("BasePart") then parts+=1 if v:IsA("MeshPart") then meshes+=1 end end
    if v:IsA("WeldConstraint") and v.Name=="ArmorMount" then mounts[v]=v.Part0.CFrame:ToObjectSpace(v.Part1.CFrame) end
    if v:IsA("Motor6D") then table.insert(motors,v) end
   end
   for _,action in {"Idle","Run","Fire","Reload"} do
    for step=1,4 do
     Pose.apply(m,step*.19,if action=="Run" then 1 else 0,action,step/4)
     heartbeat:Wait() heartbeat:Wait()
     for weld,offset in mounts do
      local now=weld.Part0.CFrame:ToObjectSpace(weld.Part1.CFrame)
      local error=(offset.Position-now.Position).Magnitude
      report.maxMountError=math.max(report.maxMountError,error)
      check(error<.003 and offset.UpVector:Dot(now.UpVector)>.9999 and offset.RightVector:Dot(now.RightVector)>.9999,id.." detached armor during "..action)
     end
    end
   end
   Pose.apply(m,1,0,"Idle",.5)
   local expected={} for _,j in motors do expected[j]=j.C0 end
   for step=1,100 do
    Pose.apply(m,step*.13,1,if step%2==0 then "Reload" else "Fire",(step%10)/10)
    if step%10==0 then heartbeat:Wait() end
   end
   Pose.apply(m,1,0,"Idle",.5)
   for _,j in motors do check(j.C0:FuzzyEq(expected[j],.0001),id.." cumulative animation drift") end
   report.heroes[id]={parts=parts,meshes=meshes,motors=#motors}
  end)
  m:Destroy()
  if not ok then error(err) end
 end
 print("[PROJECT ZERO] PASS: "..report.assertions.." moving armor assertions")
 return report
end
return Suite
