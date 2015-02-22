--[[

	- Author: ConnorMcG
	- Released: 15-02-2015

--]]

if myHero.charName ~= "Talon" then return end
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("SFIGIFENGLE") 

require "SxOrbWalk"
require "VPrediction"

local KillText = {}
local KillTextColor = ARGB(255, 216, 247, 8)
local KillTextList = {		
			"Harass Him", --1
			"Combo Kill", --2
					}
					
local qRange = 200
local wRange = 600
local eRange = 700
local rRange = 450
local ts

 function updater()
	local Version = 1.07
	local ServerResult = GetWebResult("raw.github.com","/ConnorMccG/BoLScripts/master/version/SimpleTalon.version")
	print(ServerResult)
	if ServerResult then
		ServerVersion = tonumber(ServerResult)
		if Version < ServerVersion then
			print("A new version is available: v"..ServerVersion..". Attempting to download now.")
			print("A new version is available: v"..ServerVersion..". Attempting to download now.")
			DelayAction(function() DownloadFile("https://raw.githubusercontent.com/ConnorMccG/BoLScripts/master/SimpleTalon.lua".."?rand"..math.random(1,9999), SCRIPT_PATH.."SimpleTalon.lua", function() print("Successfully downloaded the latest version (please reload): v"..ServerVersion..".") end) end, 2)
		else
			print("You are running the latest version: v"..Version..".")
		end
	else
		print("Error finding server version.")
	end
end

function OnTick()
	
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 700)
	
	ts:update()
	Harass()
	ComboSettings()
	if TalonMenu.KS.enableKS then
	killsteal()
	end
	DmgCalculations()

end

function ComboSettings()
	if TalonMenu.KB.ComboKey then
		if TalonMenu.CS.cMode == 1 then
			Combo1()
		elseif TalonMenu.CS.cMode == 2 then
			Combo2()
		end
	end
end

function OnLoad()
	
	PrintChat("<font color='#aaff34'>// Talon Script Initialized, Have Fun!</font>")
	VP = VPrediction()
	SxO = SxOrbWalk(VP)
	TalonMenu()
	updater()
--[[
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then useIgnite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then useIgnite = SUMMONER_2
	end
	--]]
	
end


function TalonMenu()
	
	TalonMenu = scriptConfig("Talon", "TalonMenu")
		
		-- Combo Settings -- 
		TalonMenu:addSubMenu("Combo Settings", "CS")
			TalonMenu.CS:addParam("comboQ", "Use Noxian Diplomacy", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("comboW", "Use Rake", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("comboE", "Use Cutthroat", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("comboR", "Use Shadow Assault", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("cMode", "Combo Mode", SCRIPT_PARAM_LIST, 1, {"E,W,Q,R","E,Q,R,W"})
			
		-- Harass Settings --
		TalonMenu:addSubMenu("Harass Settings", "HS")
			TalonMenu.HS:addParam("harassW", "Use Rake", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.HS:addParam("harassE", "Use Cutthroat", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.HS:addParam("harassQ", "Use Noxian Diplomacy", SCRIPT_PARAM_ONOFF, false)
			
		-- Killsteal Settings --
		TalonMenu:addSubMenu("Killsteal Settings", "KS")
			TalonMenu.KS:addParam("enableKS", "Enable Killsteal", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.KS:addParam("killstealQ", "Use Noxian Diplomacy", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.KS:addParam("killstealW", "Use Rake", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.KS:addParam("killstealR", "Use Shadow Assault", SCRIPT_PARAM_ONOFF, true)
			
		-- Keybinding settings --
		TalonMenu:addSubMenu("Keybindings", "KB")
			TalonMenu.KB:addParam("ComboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			TalonMenu.KB:addParam("HarassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			
		-- Drawing Settings --
		TalonMenu:addSubMenu("Drawing", "Drawing")
			TalonMenu.Drawing:addParam("WRange", "W Range", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.Drawing:addParam("ERange", "E Range", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.Drawing:addParam("RRange", "R Range", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.Drawing:addParam("DmgCalcs", "Killable Text", SCRIPT_PARAM_ONOFF, true)
			
		-- Orb Walker --
		TalonMenu:addSubMenu("Orbwalker", "SxOrb")
			SxO:LoadToMenu(TalonMenu.SxOrb)

end

function killsteal()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
		local qDmg = ((getDmg("Q", enemy, myHero)) or 0)	
		local wDmg = ((getDmg("W", enemy, myHero)) or 0)	
		local eDmg = ((getDmg("E", enemy, myHero)) or 0)	
		local rDmg = ((getDmg("R", enemy, myHero)) or 0)
	if ValidTarget(enemy) and Enemy ~= nil and TalonMenu.KS.enableKS then
		if enemy.health < qDmg and TalonMenu.KS.killstealQ and ValidTarget(enemy, qRange) then
			CastSpell(_Q, enemy)
		elseif enemy.health < wDmg and TalonMenu.KS.killstealW and ValidTarget(enemy, wRange) then
			CastSpell(_W, enemy)
		end
	end
end
end

function DmgCalculations()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
	local qDmg = ((getDmg("Q", enemy, myHero)) or 0)	
local wDmg = ((getDmg("W", enemy, myHero)) or 0)	
local eDmg = ((getDmg("E", enemy, myHero)) or 0)	
local rDmg = ((getDmg("R", enemy, myHero)) or 0)
local aaDmg = ((getDmg("AD", enemy, myHero)))
			if ValidTarget(enemy) and enemy ~= nil then
				if TalonMenu.Drawing.DmgCalcs then
				if enemy.health <= (aaDmg + qDmg + wDmg + eDmg + rDmg) then
					KillText[i] = 2
				elseif enemy.health > (aaDmg + wDmg + eDmg + rDmg) then
					KillText[i] = 1
				end
			end
		end
	end
end


function Combo1()

	if (ts.target ~= nil) and Eready then
		if ValidTarget(ts.target, 700) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 700 and TalonMenu.CS.comboE then
				CastSpell(_E, ts.target)
			end
		end
	end

	if (ts.target ~= nil) and Wready then
		if ValidTarget(ts.target, 600) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 600 and TalonMenu.CS.comboW then
				CastSpell(_W, ts.target)
			end
		end
	end
	
	if (ts.target ~= nil) and Qready then
		if ValidTarget(ts.target, 250) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 250 and TalonMenu.CS.comboQ then
				CastSpell(_Q, myHero:Attack(ts.target))
			end
		end
	end

	if (ts.target ~= nil) and Rready then
		if ValidTarget(ts.target, 500) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 500 and TalonMenu.CS.comboR then
				CastSpell(_R)
			end
		end
	end
end
end

function Combo2()

	if (ts.target ~= nil) and Eready then
		if ValidTarget(ts.target, 700) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 700 and TalonMenu.CS.comboE then
				CastSpell(_E, ts.target)
			end
		end
	end
	
	if (ts.target ~= nil) and Qready then
		if ValidTarget(ts.target, 250) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 250 and TalonMenu.CS.comboQ then
				CastSpell(_Q, myHero:Attack(ts.target))
			end
		end
	end
	
	if (ts.target ~= nil) and Rready then
		if ValidTarget(ts.target, 500) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 500 and TalonMenu.CS.comboR then
				CastSpell(_R)
			end
		end
	end
	
	if (ts.target ~= nil) and Wready then
		if ValidTarget(ts.target, 600) and TalonMenu.KB.ComboKey then
			if GetDistance(ts.target, myHero) <= 600 and TalonMenu.CS.comboW then
				CastSpell(_W, ts.target)
			end
		end
	end

end	

function Harass()
	
	if (ts.target ~= nil) and Eready then
			if ValidTarget(ts.target, 700) and TalonMenu.KB.HarassKey then
				if GetDistance(ts.target, myHero) <= 700 and TalonMenu.HS.harassE then
						CastSpell(_E, ts.target)
			end
		end
	end
		
	if (ts.target ~= nil) and Qready then
			if ValidTarget(ts.target, 250) and TalonMenu.KB.HarassKey then
				if GetDistance(ts.target, myHero) <= 250 and TalonMenu.HS.harassQ then
						CastSpell(_Q, myHero:Attack(ts.target))
			end
		end
	end
	
	if (ts.target ~= nil) and Wready then
		if ValidTarget(ts.target, 600) and TalonMenu.KB.HarassKey then
			if GetDistance(ts.target, myHero) <= 600 and TalonMenu.HS.harassW then
						CastSpell(_W, ts.target)
			end
		end
	end
end

function OnDraw()

	if TalonMenu.Drawing.WRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0x111111)
	end
	if TalonMenu.Drawing.ERange then
		DrawCircle(myHero.x, myHero.y, myHero.z, 700, 0x111111)
	end
	if TalonMenu.Drawing.RRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, 500, 0x111111)
	end
	
	
		if TalonMenu.Drawing.DmgCalcs then
		for i = 1, heroManager.iCount do
			local enemy = heroManager:GetHero(i)
				if ValidTarget(enemy) and enemy ~= nil then
					local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
					local PosX = barPos.x - 60
					local PosY = barPos.y - 10
					DrawText(KillTextList[KillText[i]], 15, PosX, PosY, KillTextColor)
				end
			end
	end
end
