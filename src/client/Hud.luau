local Hud = {}
local WHITE, CYAN, ORANGE = Color3.fromRGB(226, 238, 244), Color3.fromRGB(74, 216, 241), Color3.fromRGB(255, 148, 65)
function Hud.create(player)
	local gui = Instance.new("ScreenGui")
	gui.Name, gui.ResetOnSpawn, gui.IgnoreGuiInset = "ZeroHUD", false, true
	gui.Parent = player:WaitForChild("PlayerGui")
	local function label(name, text, pos, size, fontSize, color, align)
		local t = Instance.new("TextLabel")
		t.Name, t.Text = name, text
		t.Position, t.Size = pos, size
		t.BackgroundTransparency, t.TextColor3 = 1, color or WHITE
		t.TextSize, t.Font = fontSize, Enum.Font.GothamBold
		t.TextXAlignment = align or Enum.TextXAlignment.Left
		t.Parent = gui
		return t
	end
	local function panel(pos, size)
		local p = Instance.new("Frame")
		p.Position, p.Size = pos, size
		p.BackgroundColor3, p.BackgroundTransparency, p.BorderSizePixel = Color3.fromRGB(13, 22, 30), .15, 0
		p.Parent = gui
		local line = Instance.new("Frame") line.Size = UDim2.new(1, 0, 0, 2) line.BackgroundColor3 = CYAN line.BorderSizePixel = 0 line.Parent = p
		return p
	end
	panel(UDim2.new(0, 28, 1, -134), UDim2.fromOffset(255, 105))
	panel(UDim2.new(1, -255, 1, -134), UDim2.fromOffset(227, 105))
	label("Brand", "PROJECT: ZERO", UDim2.fromOffset(28, 30), UDim2.fromOffset(260, 32), 25)
	label("Build", "2042  /  ZERO INITIATIVE", UDim2.fromOffset(30, 64), UDim2.fromOffset(260, 20), 11, CYAN)
	label("Map", "HAMNVERKET", UDim2.new(1, -280, 0, 32), UDim2.fromOffset(250, 30), 21, WHITE, Enum.TextXAlignment.Right)
	label("Location", "NORRHAMN  /  20:30", UDim2.new(1, -280, 0, 64), UDim2.fromOffset(250, 20), 11, CYAN, Enum.TextXAlignment.Right)
	local phase = label("Phase", "PREPARE", UDim2.new(.5, -220, 0, 35), UDim2.fromOffset(440, 32), 19, ORANGE, Enum.TextXAlignment.Center)
	local info = label("Info", "TRAINING DEATHMATCH", UDim2.new(.5, -240, 0, 70), UDim2.fromOffset(480, 20), 11, WHITE, Enum.TextXAlignment.Center)
	label("Hero", "VEX  /  DAMAGE", UDim2.new(0, 46, 1, -122), UDim2.fromOffset(220, 22), 14, CYAN)
	local health = label("Health", "275", UDim2.new(0, 46, 1, -97), UDim2.fromOffset(115, 43), 37)
	label("MaxHealth", "/ 275 HP", UDim2.new(0, 142, 1, -82), UDim2.fromOffset(120, 22), 13)
	local healthBg = Instance.new("Frame") healthBg.Position = UDim2.new(0, 46, 1, -48) healthBg.Size = UDim2.fromOffset(218, 6) healthBg.BackgroundColor3 = Color3.fromRGB(45, 64, 73) healthBg.BorderSizePixel = 0 healthBg.Parent = gui
	local healthBar = Instance.new("Frame") healthBar.Size = UDim2.fromScale(1, 1) healthBar.BackgroundColor3 = CYAN healthBar.BorderSizePixel = 0 healthBar.Parent = healthBg
	label("Weapon", "VX-7  /  ASSAULT RIFLE", UDim2.new(1, -237, 1, -122), UDim2.fromOffset(200, 22), 12, ORANGE)
	local ammo = label("Ammo", "36", UDim2.new(1, -237, 1, -97), UDim2.fromOffset(110, 43), 37)
	label("MaxAmmo", "/ 36", UDim2.new(1, -142, 1, -82), UDim2.fromOffset(75, 22), 16)
	local reload = label("Reload", "R  RELOAD", UDim2.new(1, -237, 1, -51), UDim2.fromOffset(200, 18), 11, ORANGE)
	local dash = label("Dash", "Q  DASH  /  READY", UDim2.new(.5, -150, 1, -89), UDim2.fromOffset(300, 28), 17, CYAN, Enum.TextXAlignment.Center)
	label("FutureAbilities", "PULSE GRENADE  /  OVERDRIVE  [LOCKED]", UDim2.new(.5, -210, 1, -57), UDim2.fromOffset(420, 18), 10, Color3.fromRGB(143, 159, 171), Enum.TextXAlignment.Center)
	label("Controls", "WASD  MOVE     MOUSE  AIM / FIRE     SPACE  JUMP", UDim2.new(.5, -260, 1, -29), UDim2.fromOffset(520, 16), 10, WHITE, Enum.TextXAlignment.Center)
	local crosshair = Instance.new("Frame") crosshair.Name = "Crosshair" crosshair.Size = UDim2.fromOffset(2, 2) crosshair.Position = UDim2.fromScale(.5, .5) crosshair.BackgroundTransparency = 1 crosshair.Parent = gui
	for _, data in {{-12, 0, 7, 2}, {6, 0, 7, 2}, {0, -12, 2, 7}, {0, 6, 2, 7}} do
		local line = Instance.new("Frame") line.Position = UDim2.fromOffset(data[1], data[2]) line.Size = UDim2.fromOffset(data[3], data[4]) line.BorderSizePixel = 0 line.BackgroundColor3 = WHITE line.Parent = crosshair
	end
	local hit = label("Hit", "×", UDim2.new(.5, -20, .5, -20), UDim2.fromOffset(40, 40), 36, ORANGE, Enum.TextXAlignment.Center) hit.Visible = false
	local death = label("Death", "", UDim2.new(.5, -300, .5, 60), UDim2.fromOffset(600, 70), 24, ORANGE, Enum.TextXAlignment.Center)
	return {gui = gui, health = health, healthBar = healthBar, ammo = ammo, reload = reload, dash = dash, phase = phase, info = info, hit = hit, death = death}
end
return Hud
