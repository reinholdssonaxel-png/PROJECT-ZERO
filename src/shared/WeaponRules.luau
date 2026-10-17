--!strict
local Rules = {}
function Rules.finiteNumber(n: any): boolean
	return type(n) == "number" and n == n and math.abs(n) < math.huge
end
function Rules.direction(v: any): boolean
	return typeof(v) == "Vector3" and Rules.finiteNumber(v.X)
		and Rules.finiteNumber(v.Y) and Rules.finiteNumber(v.Z)
		and v.Magnitude > 0.95 and v.Magnitude < 1.05
end
function Rules.canFire(state: any, now: number, interval: number): boolean
	return state.ammo > 0 and state.reloadEnd == 0 and now - state.lastShot >= interval
end
function Rules.enemy(a: Model, b: Model): boolean
	return a ~= b and a:GetAttribute("Faction") ~= nil
		and b:GetAttribute("Faction") ~= nil and a:GetAttribute("Faction") ~= b:GetAttribute("Faction")
end
return Rules
