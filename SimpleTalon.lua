         --[[
	- Author: ConnorMcG

v1.0 - Initial release (15-02-2015)

--]]


if myHero.charName ~= "Talon" then return end

require "SxOrbWalk"
require "VPrediction"

local qRange = 1250
local wRange = 600
local eRange = 700
local rRange = 450
local ts
local version = 1.1

local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/ConnorMccG/BoLScripts/master/SimpleTalon.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."SimpleTalon.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Yours Teemo:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/ConnorMccG/BoLScripts/master/version/SimpleTalon.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
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
