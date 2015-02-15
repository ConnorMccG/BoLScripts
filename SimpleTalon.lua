--[[
	- Author: ConnorMcG

v1.0 - Initial release (15-02-2015)

--]]

local AUTO_UPDATE = true
local VERSION = 1.0


if AUTO_UPDATE then
    local server_version = tonumber(GetWebResult("raw.github.com", "/ConnorMccG/BoLScripts/master/version/SimpleTalon.version")) -- I have a file on my github which just shows the newest version, what I'm doing here is downloading it and comparing with the constant value above and if there is a newer version then go through the update process
    if server_version > VERSION then -- compare
        PrintChat("Script is outdated. Updating to version: " .. server_version .. "...")
        DownloadFile("https://raw.github.com//ConnorMccG/BoLScripts/master/SimpleTalon.lua", SCRIPT_PATH .. "AkaliRevenge.lua", function() -- Download the new script (we're literally overwriting the current one)
            PrintChat("Script updated. Please reload (F9).")
        end)
    end
    if server_version > VERSION then return end -- Quit out the script as it will cause issues
end


if myHero.charName ~= "Talon" then return end

require "SxOrbWalk"
require "VPrediction"

local qRange = 1250
local wRange = 600
local eRange = 700
local rRange = 450
local ts

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
				SxO:RegisterAfterAttackCallback(function() CastSpell(_Q) end)	
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
		if GetDistance(ts.target) < 600 and ts.target.health <= (50 + (20 * myHero.level)) then
				CastSpell(ignite, ts.target)
		end
	end

end	

function Harass()
	
		if (ts.target ~= nil) and Wready then
			if ValidTarget(ts.target, 600) and TalonMenu.KB.HarassKey then
				if GetDistance(ts.target, myHero) <= 600 and TalonMenu.HS.harassW then
						CastSpell(_W, ts.target)
				end
			end
		end

end
