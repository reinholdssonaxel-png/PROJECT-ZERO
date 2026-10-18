local Suite={}
function Suite.run(player)
	local Match=require(game.ServerScriptService.ZeroServer.MatchService)
	local Combat=require(game.ServerScriptService.ZeroServer.Combat)
	local n=0
	local function check(ok,msg) assert(ok,msg) n+=1 end
	check(player:GetAttribute("ZeroSession")=="ACTIVE","test requires an active player")
	Match.buckets[player]=nil
	local m=player.Character local ammo=m:GetAttribute("Ammo")
	Match.request(player,"Inspect")
	check(player:GetAttribute("ZeroSession")=="INSPECT" and m.HumanoidRootPart.Anchored,"inspection locks server movement")
	check(not Combat.fire(m,Vector3.new(0,0,1)) and m:GetAttribute("Ammo")==ammo,"inspection blocks server fire")
	check(not Combat.dash(m,Vector3.new(1,0,0)),"inspection blocks server dash")
	Match.request(player,"Resume")
	check(player:GetAttribute("ZeroSession")=="ACTIVE" and not m.HumanoidRootPart.Anchored and m.Humanoid.WalkSpeed==22,"resume restores controls")
	Match.finishRound()
	check(player:GetAttribute("ZeroSession")=="RESULTS" and player.Character==nil,"results remove combat character")
	check(not Match.deploy(player,"VEX"),"deployment without selection rejected")
	Match.request(player,"Menu")
	check(player:GetAttribute("ZeroSession")=="MENU" and player.Character==nil,"menu has no movable character")
	Match.request(player,"Play")
	check(player:GetAttribute("ZeroSession")=="SELECT" and player.Character==nil,"play opens selection before spawn")
	check(not Match.deploy(player,"TITAN") and not Match.deploy(player,{}),"locked/invalid heroes rejected")
	check(Match.deploy(player,"VEX"),"VEX deployment accepted")
	check(player:GetAttribute("ZeroSession")=="PREPARE" and player.Character.HumanoidRootPart.Anchored,"preparation locks movement")
	check(not Combat.fire(player.Character,Vector3.new(0,0,1)),"preparation blocks combat")
	Match.request(player,"Menu")
	check(player:GetAttribute("ZeroSession")=="MENU" and player.Character==nil and workspace:GetAttribute("ZeroPhase")=="IDLE","leaving last player resets round")
	print("[PROJECT ZERO] Session verification: "..n.." checks")
	return n
end
return Suite
