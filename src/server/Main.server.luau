local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Teams = game:GetService("Teams")
local C = require(ReplicatedStorage.ZeroShared.Config)
local Arena = require(script.Parent.Arena)
local Characters = require(script.Parent.Characters)
local Combat = require(script.Parent.Combat)
local Bots = require(script.Parent.Bots)
Players.CharacterAutoLoads, Players.RespawnTime = false, C.RespawnTime
local remotesFolder = Instance.new("Folder") remotesFolder.Name = "ZeroRemotes" remotesFolder.Parent = ReplicatedStorage
local remotes = {}
for _, name in {"Action", "FX"} do
	local event = Instance.new("RemoteEvent") event.Name = name event.Parent = remotesFolder remotes[name] = event
end
Combat.init(remotes)
remotes.Action.OnServerEvent:Connect(Combat.request)
local arena, doors = Arena.build()
-- Hide only the default baseplate/spawn; preserve unrelated user content.
for _, name in {"Baseplate", "SpawnLocation"} do
	local item = workspace:FindFirstChild(name)
	if item and item:IsA("BasePart") then item.CanCollide, item.CanQuery, item.Transparency = false, false, 1 end
end
for _, name in {"Alpha", "Bravo"} do
	local team = Teams:FindFirstChild(name) or Instance.new("Team")
	team.Name, team.AutoAssignable = name, false
	team.TeamColor = BrickColor.new(if name == "Alpha" then "Cyan" else "Bright orange")
	team.Parent = Teams
end
local function spawnPlayer(player)
	if player.Parent ~= Players then return end
	local old = player.Character
	if old then old:Destroy() end
	local faction = player.Team.Name
	local m = Characters.create(player.Name, faction, Characters.spawnPosition(faction))
	m.Parent = workspace
	if faction == "Alpha" then m:PivotTo(CFrame.new(m:GetPivot().Position) * CFrame.Angles(0, math.pi, 0)) end
	Characters.register(m, function()
		player.leaderstats.Deaths.Value += 1
		task.delay(C.RespawnTime, function() spawnPlayer(player) end)
	end)
	Combat.register(m)
	player.Character, player.CameraMode = m, Enum.CameraMode.LockFirstPerson
	-- Roblox clients simulate normal locomotion; server validates all combat actions.
	m.HumanoidRootPart:SetNetworkOwner(player)
end
local joined = 0
local function onPlayer(player)
	joined += 1
	player.Team = Teams:FindFirstChild(if workspace:GetAttribute("ZeroPvP") and joined % 2 == 0 then "Bravo" else "Alpha")
	local stats = Instance.new("Folder") stats.Name = "leaderstats" stats.Parent = player
	for _, name in {"Kills", "Deaths"} do local value = Instance.new("IntValue") value.Name = name value.Parent = stats end
	spawnPlayer(player)
end
Players.PlayerAdded:Connect(onPlayer)
Players.PlayerRemoving:Connect(function(player) Combat.buckets[player] = nil if player.Character then player.Character:Destroy() end end)
for _, player in Players:GetPlayers() do task.spawn(onPlayer, player) end
workspace:SetAttribute("ZeroPhase", "PREPARE")
workspace:SetAttribute("ZeroPhaseEnd", workspace:GetServerTimeNow() + C.PreparationTime)
local started = false
local function startMatch()
	if started then return end
	started = true
	workspace:SetAttribute("ZeroPhase", "ACTIVE")
	for _, door in doors do
		door.CanCollide, door.CanQuery = false, false
		TweenService:Create(door, TweenInfo.new(1), {CFrame = door.CFrame + Vector3.new(0, 15, 0)}):Play()
	end
	for index = 1, C.BotCount do Bots.spawn(index) end
	print("[PROJECT ZERO] Training active: VEX / VX-7 / HAMNVERKET")
end
-- Wait for the first player before consuming the preparation countdown.
task.spawn(function()
	while #Players:GetPlayers() == 0 do
		workspace:SetAttribute("ZeroPhaseEnd", workspace:GetServerTimeNow() + C.PreparationTime)
		task.wait(.25)
	end
	workspace:SetAttribute("ZeroPhaseEnd", workspace:GetServerTimeNow() + C.PreparationTime)
	task.wait(C.PreparationTime)
	startMatch()
end)
local accumulator, regenAccumulator = 0, 0
RunService.Heartbeat:Connect(function(dt)
	accumulator += dt regenAccumulator += dt
	if accumulator >= C.BotThinkInterval then accumulator = 0 Bots.think() end
	if regenAccumulator >= .2 then Characters.regenerate(regenAccumulator) regenAccumulator = 0 end
end)
