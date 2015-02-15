--[[
	- Author: ConnorMcG

v1.0 - Initial release (15-02-2015)

--]]


if myHero.charName ~= "Talon" then return end

require "SxOrbWalk"
require "VPrediction"

local qRange = 200
local wRange = 600
local eRange = 700
local rRange = 450
local ts
local Version = 1.02

function updater()
	local ServerResult = GetWebResult("raw.github.com","/ConnorMccG/BoLScripts/master/version/SimpleTalon.version")
	if ServerResult then
		ServerVersion = tonumber(ServerResult)
		if Version < ServerVersion then
			print("A new version is available: v"..ServerVersion..". Attempting to download now.")
			DelayAction(function() DownloadFile("https://raw.githubusercontent.com/ConnorMccG/BoLScripts/master/SimpleTalon.lua".."?rand"..math.random(1,9999), SCRIPT_PATH.."SimpleTalon.lua", function() Print("Successfully downloaded the latest version: v"..ServerVersion..".") end) end, 2)
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
	
	ts:update()
	Combo()
	Harass()

end


function OnLoad()
	
	PrintChat("<font color='#aaff34'>// Talon Script Initialized, Have Fun!</font>")
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 700)
	VP = VPrediction()
	SxO = SxOrbWalk(VP)
	TalonMenu()
	updater()

	
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then ignite = SUMMONER_2
	end
	
end


function TalonMenu()
	
	TalonMenu = scriptConfig("Talon", "TalonMenu")
		
		-- Combo Settings -- 
		TalonMenu:addSubMenu("Combo Settings", "CS")
			TalonMenu.CS:addParam("comboQ", "Use Noxian Diplomacy", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("comboW", "Use Rake", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("comboE", "Use Cutthroat", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("comboR", "Use Shadow Assault", SCRIPT_PARAM_ONOFF, true)
			TalonMenu.CS:addParam("comboI", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
			
		-- Harass Settings --
		TalonMenu:addSubMenu("Harass Settings", "HS")
			TalonMenu.HS:addParam("harassW", "Use Rake", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.HS:addParam("harassE", "Use Cutthroat", SCRIPT_PARAM_ONOFF, false)
			TalonMenu.HS:addParam("harassQ", "Use Noxian Diplomacy", SCRIPT_PARAM_ONOFF, false)
			
		-- TalonMenu:addSubMenu("Miscellaneous", "Misc")


		-- Keybindings --
		TalonMenu:addSubMenu("Keybindings", "KB")
			TalonMenu.KB:addParam("ComboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			TalonMenu.KB:addParam("HarassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		
		-- Orb Walker --
		TalonMenu:addSubMenu("Orbwalker", "SxOrb")
			SxO:LoadToMenu(TalonMenu.SxOrb)


end

function Combo()

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

	
	if (ts.target ~= nil) and TalonMenu.CS.comboI then
		if TalonMenu.KB.ComboKey then
			if GetDistance(ts.target) < 600 and ts.target.health <= (50 + (20 * myHero.level)) then
				CastSpell(ignite, ts.target)
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
