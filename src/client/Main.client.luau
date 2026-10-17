local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local C = require(game.ReplicatedStorage.ZeroShared.Config)
local G = require(game.ReplicatedStorage.ZeroShared.Geometry)
local Hud = require(script.Parent.Hud)
local player = Players.LocalPlayer
local remotes = game.ReplicatedStorage:WaitForChild("ZeroRemotes")
local hud = Hud.create(player)
local character, humanoid, viewmodel
local ammo, localReloadEnd, nextShot, recoil, hitUntil = 36, 0, 0, 0, 0
local holding = false
local shotSound = Instance.new("Sound") shotSound.SoundId = C.ShotSound shotSound.Volume = .35 shotSound.Parent = SoundService
local tickSound = Instance.new("Sound") tickSound.SoundId = "rbxasset://sounds/button.wav" tickSound.Volume = .15 tickSound.Parent = SoundService
workspace:GetAttributeChangedSignal("ZeroPhase"):Connect(function() tickSound:Play() end)
local fxFolder = Instance.new("Folder") fxFolder.Name = "ZeroLocalFX" fxFolder.Parent = workspace
local gaitJoints = setmetatable({}, {__mode = "k"})
local function makeViewmodel()
	if viewmodel then viewmodel:Destroy() end
	viewmodel = Instance.new("Model") viewmodel.Name = "VEX_FirstPerson"
	local root = G.part(viewmodel, "Root", Vector3.one * .1, CFrame.identity, Color3.new()) root.Transparency = 1
	viewmodel.PrimaryPart = root
	local rifle = G.rifle(viewmodel)
	rifle:PivotTo(CFrame.new(.62, -.5, -1.1))
	G.part(viewmodel, "RightGlove", Vector3.new(.33, .35, .48), CFrame.new(.63, -.83, -.7), Color3.fromRGB(29, 34, 41))
	G.part(viewmodel, "RightArm", Vector3.new(.38, .4, 1.15), CFrame.new(.68, -.92, -.05) * CFrame.Angles(-.15, 0, 0), Color3.fromRGB(48, 55, 64))
	G.part(viewmodel, "LeftArm", Vector3.new(.38, .4, 1.25), CFrame.new(.05, -.89, -1.04) * CFrame.Angles(-.2, -.8, -.15), Color3.fromRGB(48, 55, 64))
	for _, p in viewmodel:GetDescendants() do
		if p:IsA("BasePart") then p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = false, false, false, false end
	end
	viewmodel.Parent = workspace.CurrentCamera
end
local ammoConnection
local function attach(m)
	character = m humanoid = m:WaitForChild("Humanoid")
	workspace.CurrentCamera.CameraSubject = humanoid
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	workspace.CurrentCamera.FieldOfView = 80
	local root = m:WaitForChild("HumanoidRootPart")
	workspace.CurrentCamera.CFrame = CFrame.lookAt(m.Head.Position, m.Head.Position + root.CFrame.LookVector * 30)
	player.CameraMode = Enum.CameraMode.LockFirstPerson
	UserInputService.MouseIconEnabled = false
	ammo, localReloadEnd, nextShot, recoil, holding = m:GetAttribute("Ammo") or 36, 0, 0, 0, false
	if ammoConnection then ammoConnection:Disconnect() end
	ammoConnection = m:GetAttributeChangedSignal("Ammo"):Connect(function() ammo = m:GetAttribute("Ammo") or 0 end)
	makeViewmodel()
end
player.CharacterAdded:Connect(attach)
if player.Character then task.spawn(attach, player.Character) end
local function reload()
	if not humanoid or humanoid.Health <= 0 or ammo == 36 or workspace:GetServerTimeNow() < localReloadEnd then return end
	localReloadEnd = workspace:GetServerTimeNow() + C.Weapon.ReloadTime
	remotes.Action:FireServer("Reload")
	tickSound:Play()
end
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then holding = true
	elseif input.KeyCode == Enum.KeyCode.R then reload()
	elseif input.KeyCode == Enum.KeyCode.Q and humanoid and humanoid.Health > 0 then
		local d = humanoid.MoveDirection
		if d.Magnitude < .1 then d = workspace.CurrentCamera.CFrame.LookVector end
		remotes.Action:FireServer("Dash", d.Unit)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then holding = false end
end)
UserInputService.WindowFocusReleased:Connect(function() holding = false end)
local function tracer(origin, endpoint, color)
	local delta = endpoint - origin
	if delta.Magnitude < .05 then return end
	local p = G.part(fxFolder, "Tracer", Vector3.new(.035, .035, delta.Magnitude), CFrame.lookAt((origin + endpoint) / 2, endpoint), color, Enum.Material.Neon)
	p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = false, false, false, false
	Debris:AddItem(p, .055)
	local impact = G.part(fxFolder, "Impact", Vector3.one * .16, CFrame.new(endpoint), color, Enum.Material.Neon)
	impact.CanCollide, impact.CanQuery, impact.CanTouch = false, false, false
	Debris:AddItem(impact, .1)
end
remotes.FX.OnClientEvent:Connect(function(shooter, origin, endpoint, hit, headshot, killed)
	tracer(origin, endpoint, if shooter == character then Color3.fromRGB(255, 173, 73) else Color3.fromRGB(255, 83, 48))
	if shooter == character then
		if hit then
			hitUntil = os.clock() + .16
			hud.hit.TextColor3 = if killed then Color3.fromRGB(255, 58, 63) elseif headshot then Color3.fromRGB(255, 178, 55) else Color3.new(1, 1, 1)
			tickSound:Play()
		end
	elseif shooter and shooter:FindFirstChild("Head") then
		local sound = shotSound:Clone() sound.Volume = .2 sound.RollOffMaxDistance = 220 sound.Parent = shooter.Head sound:Play() Debris:AddItem(sound, 2)
	end
end)
RunService:BindToRenderStep("ZeroFPS", Enum.RenderPriority.Camera.Value + 1, function(dt)
	local time = workspace:GetServerTimeNow()
	local alive = humanoid and humanoid.Health > 0
	local phase = workspace:GetAttribute("ZeroPhase")
	hud.phase.Text = if phase == "PREPARE" then "PREPARE  /  " .. math.max(0, math.ceil((workspace:GetAttribute("ZeroPhaseEnd") or time) - time)) else "TRAINING  /  LIVE"
	hud.info.Text = if phase == "PREPARE" then "VEX ONLINE  •  DOORS OPEN AT ZERO" else "ALPHA vs BRAVO  /  ELIMINATE HOSTILES"
	hud.hit.Visible = os.clock() < hitUntil
	if not character or not humanoid then return end
	hud.health.Text = tostring(math.ceil(humanoid.Health))
	hud.healthBar.Size = UDim2.fromScale(math.clamp(humanoid.Health / C.MaxHealth, 0, 1), 1)
	hud.ammo.Text = string.format("%02d", ammo)
	local serverReload = character:GetAttribute("ReloadEnd") or 0
	local reloading = time < math.max(serverReload, localReloadEnd)
	hud.reload.Text = if reloading then "RELOADING  " .. string.format("%.1f", math.max(serverReload, localReloadEnd) - time) .. "s" else "R  RELOAD"
	local cooldown = math.max(0, (character:GetAttribute("DashReadyAt") or 0) - time)
	hud.dash.Text = if cooldown > 0 then "Q  DASH  /  " .. string.format("%.1fs", cooldown) else "Q  DASH  /  READY"
	local respawnAt = character:GetAttribute("RespawnAt") or time
	hud.death.Text = if not alive then "VEX DOWN\nREDEPLOY IN " .. math.max(0, math.ceil(respawnAt - time)) .. "s" elseif math.abs(character.HumanoidRootPart.Position.Z) >= 100 then "SPAWN PROTECTED" else ""
	if holding and alive and not reloading and phase == "ACTIVE" and time >= nextShot and math.abs(character.HumanoidRootPart.Position.Z) < 100 then
		if ammo > 0 then
			nextShot = time + C.Weapon.FireInterval
			ammo -= 1
			remotes.Action:FireServer("Fire", workspace.CurrentCamera.CFrame.LookVector)
			recoil = math.min(.16, recoil + .045)
			workspace.CurrentCamera.CFrame *= CFrame.Angles(math.rad(.45), 0, 0)
			shotSound.PlaybackSpeed = .96 + math.random() * .08 shotSound:Play()
			local muzzle = viewmodel and viewmodel:FindFirstChild("VX7") and viewmodel.VX7:FindFirstChild("Barrel")
			if muzzle then
				local flash = Instance.new("PointLight") flash.Color = Color3.fromRGB(255, 181, 81) flash.Brightness = 2 flash.Range = 8 flash.Parent = muzzle Debris:AddItem(flash, .04)
			end
		else reload() end
	end
	recoil *= math.exp(-dt * 16)
	if viewmodel then
		viewmodel.Parent = if alive then workspace.CurrentCamera else nil
		local bob = math.sin(os.clock() * 10) * math.min(humanoid.MoveDirection.Magnitude, 1) * .025
		local tilt = if reloading then math.sin(math.clamp(1 - (math.max(serverReload, localReloadEnd) - time) / C.Weapon.ReloadTime, 0, 1) * math.pi) else 0
		viewmodel:PivotTo(workspace.CurrentCamera.CFrame * CFrame.new(0, bob - tilt * .35, recoil) * CFrame.Angles(tilt * -.4, 0, tilt * -.65))
	end
	for _, p in character:GetDescendants() do if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end end
end)
-- Lightweight original procedural R15 placeholder gait, including other players.
local gaitClock = 0
RunService.Heartbeat:Connect(function(dt)
	gaitClock += dt
	if gaitClock < .05 then return end
	gaitClock = 0
	for _, m in workspace:GetChildren() do
		if m:IsA("Model") and m:GetAttribute("Hero") == "VEX" and m:FindFirstChild("HumanoidRootPart") then
			local speed = m.HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
			local wave = math.sin(os.clock() * 11) * math.min(1, speed.Magnitude / C.WalkSpeed) * .45
			for _, joint in m:GetDescendants() do
				if joint:IsA("Motor6D") then
					local base = gaitJoints[joint] or joint.C0 gaitJoints[joint] = base
					if joint.Name == "RightUpperLegJoint" then joint.C0 = base * CFrame.Angles(wave, 0, 0)
					elseif joint.Name == "LeftUpperLegJoint" then joint.C0 = base * CFrame.Angles(-wave, 0, 0)
					elseif joint.Name == "RightUpperArmJoint" then joint.C0 = base * CFrame.Angles(-1.1, 0, -.1)
					elseif joint.Name == "LeftUpperArmJoint" then joint.C0 = base * CFrame.Angles(-.9, 0, .5) end
				end
			end
		end
	end
end)
