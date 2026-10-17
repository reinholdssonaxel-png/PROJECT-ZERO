-- Canonical roster. Only VEX has a verified gameplay kit in this milestone.
local function c(r,g,b) return Color3.fromRGB(r,g,b) end
local heroes = {
	TITAN={Role="Tank",HP=700,Name="Viktor Holm",Origin="Sweden / 42",Weapon="M-90 heavy cannon",Primary=c(32,55,87),Accent=c(76,171,255),Scale=1.18,Playable=false,Kit="Shield / Slam",Silhouette="Heavy segmented armor / narrow blue visor"},
	ATLAS={Role="Tank",HP=650,Name="Marcus Cole",Origin="United Kingdom / 36",Weapon="Mechanical gauntlets",Primary=c(177,87,30),Accent=c(255,172,62),Scale=1.13,Playable=false,Kit="Melee / Charge",Silhouette="Industrial exosuit / reinforced gauntlets"},
	VEX={Role="Damage",HP=275,Name="Elias Berg",Origin="Sweden / 29",Weapon="VX-7 assault rifle",Primary=c(39,45,54),Accent=c(255,136,45),Scale=1,Playable=true,Kit="Dash / Pulse Grenade / Overdrive",Silhouette="Charcoal tactical armor / orange visor"},
	PHANTOM={Role="Damage",HP=250,Name="Yuna Takahashi",Origin="Japan / 27",Weapon="Twin pistols",Primary=c(35,29,48),Accent=c(184,107,255),Scale=.96,Playable=false,Kit="Cloak / Shadow Step / Nightfall",Silhouette="Stealth suit / purple lenses / split coat"},
	HAVOC={Role="Damage",HP=300,Name="Daniel Reyes",Origin="United States / 34",Weapon="Grenade launcher",Primary=c(127,45,43),Accent=c(255,101,65),Scale=1.05,Playable=false,Kit="Cluster Bomb / Rocket Jump / Annihilator",Silhouette="Battered red armor / explosive bandolier"},
	SPECTRE={Role="Damage",HP=225,Name="Anton Volkov",Origin="Ukraine / 38",Weapon="Precision rifle",Primary=c(45,56,49),Accent=c(126,238,118),Scale=.99,Playable=false,Kit="Recon Dart / Grapple / Deadeye",Silhouette="Hooded marksman / green optical lenses"},
	NOVA={Role="Support",HP=250,Name="Sofia Lind",Origin="Sweden / 31",Weapon="Energy carbine",Primary=c(201,215,220),Accent=c(72,223,239),Scale=.98,Playable=false,Kit="Healing Drone / Pulse Boost / Revival Field",Silhouette="White medical armor / cyan visor / med pack"},
	ECHO={Role="Support",HP=275,Name="Adrian Moreau",Origin="France / 33",Weapon="Pulse carbine",Primary=c(81,111,142),Accent=c(94,190,255),Scale=1,Playable=false,Kit="Shield Pulse / Disruptor / Amplify",Silhouette="Layered tech armor / holographic shield emitters"},
}
for _,h in heroes do table.freeze(h) end
return table.freeze({Order=table.freeze({"TITAN","ATLAS","VEX","PHANTOM","HAVOC","SPECTRE","NOVA","ECHO"}),Heroes=table.freeze(heroes)})
