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
local Version = 1.01

local Version = 1.04
local ScriptName = GetCurrentEnv().FILE_NAME

AddLoadCallback(function()
	Updater(true)
end)

class 'Updater'
function Updater:__init(au)
	--[[Credits to Bilbao & Aroc]]
	if au ~= true then return end
	self.Host = "raw.githubusercontent.com"
	self.VersionPath = "/ConnorMccG/BoLScripts/master/version/SimpleTalon.version"
	self.ScriptPath = "/ConnorMccG/BoLScripts/master/SimpleTalon.lua"
	self.SavePath = SCRIPT_PATH..ScriptName
	self.LuaSocket = require("socket")
	Print("Checking for updates.")
	AddTickCallback(function()
		if not self.OnlineVersion and not self.VersionSocket then
			self.VersionSocket = self.LuaSocket.connect("sx-bol.eu", 80)
			self.VersionSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.VersionPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
		end
		if not self.OnlineVersion and self.VersionSocket then
			self.VersionSocket:settimeout(0, 'b')
			self.VersionSocket:settimeout(99999999, 't')
			self.VersionReceive, self.VersionStatus = self.VersionSocket:receive('*a')
		end
		if not self.OnlineVersion and self.VersionSocket and self.VersionStatus ~= 'timeout' then
			if self.VersionReceive then
				self.OnlineVersion = tonumber(string.sub(self.VersionReceive, string.find(self.VersionReceive, "<bols".."cript>")+11, string.find(self.VersionReceive, "</bols".."cript>")-1))
			else
				Print("AutoUpdate has failed, please download manually.")
				self.OnlineVersion = 0
			end
			if self.OnlineVersion > Version then
				self.ScriptSocket = self.LuaSocket.connect("sx-bol.eu", 80)
				self.ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.ScriptPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
				self.ScriptReceive, self.ScriptStatus = self.ScriptSocket:receive('*a')
				self.ScriptRAW = string.sub(self.ScriptReceive, string.find(self.ScriptReceive, "<bols".."cript>")+11, string.find(self.ScriptReceive, "</bols".."cript>")-1)
				local ScriptFileOpen = io.open(self.SavePath, "w+")
				ScriptFileOpen:write(self.ScriptRAW)
				ScriptFileOpen:close()
			end
			if Version < self.OnlineVersion then
				Print("Automatically reloading "..ScriptName)
				DelayAction(function() dofile(SCRIPT_PATH..ScriptName) end, 0.5)
			else
				self:Load()
			end
		end
	end)
end

function Updater:Load()
	Print("Loaded")
	--[[Place OnLoad items here]]
	Loaded = true
end

function Print(m)
	print("<font color=\"#FF0000\">[SimpleTalon]</font> <font color=\"#FFFFFF\">"..m.."</font>")
end


function OnTick()
	
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)
	
	ts:update()
	Combo()
	Harass()
	if Loaded ~= true then return end

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
