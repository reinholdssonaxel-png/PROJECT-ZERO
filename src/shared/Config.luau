--!strict
-- 1 stud = 0.28 metres. All distances and speeds below use Roblox studs.
return table.freeze({
	Hero = "VEX", MaxHealth = 275, WalkSpeed = 22,
	StudsPerMetre = 1 / 0.28,
	Weapon = table.freeze({Name = "VX-7", Damage = 13, HeadMultiplier = 1.5,
		Magazine = 36, ReloadTime = 1.8, FireInterval = 1 / 9, Range = 650}),
	Dash = table.freeze({Speed = 18 / 0.28, Duration = 0.18, Cooldown = 8}),
	RegenDelay = 5, RegenRate = 15, RespawnTime = 8, PreparationTime = 15,
	BotCount = 1, BotThinkInterval = 0.15, BotReactionTime = 0.65, BotSpread = 0.035,
	-- Free Creator Store audio; source and usage notes are in docs/ASSETS.md.
	ShotSound = "rbxassetid://113879008765178",
})
