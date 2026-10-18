local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Teams=game:GetService("Teams")
local C=require(ReplicatedStorage.ZeroShared.Config)
local Characters=require(script.Parent.Characters)
local Combat=require(script.Parent.Combat)
local Bots=require(script.Parent.Bots)
local Match=require(script.Parent.MatchService)
Players.CharacterAutoLoads=false Players.RespawnTime=C.RespawnTime
local folder=Instance.new("Folder") folder.Name="ZeroRemotes" folder.Parent=ReplicatedStorage
local remotes={}
for _,name in {"Action","FX","Flow"} do local e=Instance.new("RemoteEvent") e.Name=name e.Parent=folder remotes[name]=e end
Combat.init(remotes) remotes.Action.OnServerEvent:Connect(Combat.request) remotes.Flow.OnServerEvent:Connect(Match.request)
local arena,doors=require(script.Parent.Arena).build() Match.doors=doors Match.reset()
for _,name in {"Baseplate","SpawnLocation"} do local p=workspace:FindFirstChild(name) if p and p:IsA("BasePart") then p.Transparency=1 p.CanCollide=false p.CanQuery=false end end
for _,name in {"Alpha","Bravo"} do local team=Teams:FindFirstChild(name) or Instance.new("Team") team.Name=name team.AutoAssignable=false team.TeamColor=BrickColor.new(if name=="Alpha" then "Cyan" else "Bright orange") team.Parent=Teams end
local joined=0
local function add(p)
 joined+=1 p.Team=Teams:FindFirstChild(if workspace:GetAttribute("ZeroPvP") and joined%2==0 then "Bravo" else "Alpha")
 local stats=Instance.new("Folder") stats.Name="leaderstats" stats.Parent=p
 for _,name in {"Kills","Deaths"} do local v=Instance.new("IntValue") v.Name=name v.Parent=stats end
 Match.addPlayer(p)
end
Players.PlayerAdded:Connect(add)
for _,p in Players:GetPlayers() do add(p) end
Players.PlayerRemoving:Connect(function(p) Combat.buckets[p]=nil Match.buckets[p]=nil Match.selectSerial[p]=nil if p.Character then p.Character:Destroy() end task.defer(function() if Match.participants()==0 then Match.reset() end end) end)
local elapsed,regen=0,0
RunService.Heartbeat:Connect(function(dt)
 elapsed+=dt regen+=dt
 if elapsed>=C.BotThinkInterval then elapsed=0 Bots.think() end
 if regen>=.2 then Characters.regenerate(regen) regen=0 end
end)