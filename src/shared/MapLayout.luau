local Layout = {Version=2, WalkSpeed=22, CombatLimit=92}
function Layout.side(faction) return if faction=="Alpha" then -1 else 1 end
function Layout.spawnPosition(faction) return Vector3.new(0,1.5,Layout.side(faction)*230) end
function Layout.isSafe(p)
	return math.abs(p.X)<=126 and math.abs(p.Z)>=184 and math.abs(p.Z)<=252 and p.Y<32
end
function Layout.inCombatArea(p)
	return math.abs(p.Z)<=Layout.CombatLimit and math.abs(p.X)<150 and p.Y<30
end
function Layout.route(faction,exit)
	local s,x=Layout.side(faction),if exit==1 then -1 else 1
	local points={{42,212},{42,198},{96,198},{96,148},{48,148},{48,96},{36,68},{36,22},{0,0}}
	local result={}
	for _,p in points do table.insert(result,Vector3.new(p[1]*x,3,p[2]*s)) end
	return result
end
function Layout.exitSamples(faction)
	local s=Layout.side(faction)
	return {Vector3.new(-42,5.5,210*s),Vector3.new(42,5.5,210*s),Vector3.new(-42,5.5,198*s),Vector3.new(42,5.5,198*s),Vector3.new(-96,5.5,194*s),Vector3.new(96,5.5,194*s),Vector3.new(-96,5.5,156*s),Vector3.new(96,5.5,156*s)}
end
return table.freeze(Layout)
