-- Champion selecton verification --
if myHero.charName ~= "Akali" then return end
-- Champion selecton verification --



require "SOW"
require "VPrediction"
local ts

--[[		Auto Update		]]
local version = "1.01"

local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "AkaliRevenge"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "ConnorMccG/BoLScripts/master/AkaliRevenge.lua?rand="..math.random(1000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local ServerData
if autoupdateenabled then
	GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
	function update()
		if ServerData ~= nil then
			local ServerVersion
			local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
			if sstart then
				send, tmp = string.find(ServerData, "\"", sstart+1)
			end
			if send then
				ServerVersion = string.sub(ServerData, sstart+1, send-1)
			end

			if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
				DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. ("..version.." => "..ServerVersion.."). Press F9 Twice to Re-load.</font>") end)     
			elseif ServerVersion then
				print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
			end		
			ServerData = nil
		end
	end
	AddTickCallback(update)
end

 
 -- Loaded just once (Beginning of the game) --
function OnLoad()

VP = VPrediction()
SOWi = SOW(VP)
SOWi:RegisterAfterAttackCallback(AutoAttackRese)
Variables()
PrintChat("<font color='#aaff34'>Thanks for using AkaliRevenge, Report bugs on the forum</font>")
AkalisMenu()
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 650)

if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then 
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then 
		ignite = SUMMONER_2
	else 
		ignite = nil
end
	
end
 -- Loaded just once (Beginning of the game) --


-- Full menu --
function AkalisMenu()

	AkaliMenu = scriptConfig("Akali, The flying assassin", "Akali")
	-- Combo Menu
		AkaliMenu:addSubMenu("Combo Settings", "combo")
			AkaliMenu.combo:addParam("ComboKey", "Preform full combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			AkaliMenu.combo:addParam("AllowQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.combo:addParam("AllowE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.combo:addParam("AllowR", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.combo:addParam("ChaseR", "Chase with R only", SCRIPT_PARAM_ONOFF, true)
	
	-- Draw Menu
		AkaliMenu:addSubMenu("Draw settings", "drawing")
			AkaliMenu.drawing:addParam("QRange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.drawing:addParam("ERange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.drawing:addParam("RRange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.drawing:addParam("ChasingR", "Draw R Chase Range", SCRIPT_PARAM_ONOFF, true)

		AkaliMenu:addSubMenu("Item Management", "IM")
			AkaliMenu.IM:addParam("AutoZhonya", "Zhonya's Low health", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.IM:addParam("useDFG", "Use Deathfire grasp", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.IM:addParam("useBWC", "Use BilgeWaterCutlass", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.IM:addParam("useHEX", "Use HexTech Revolver", SCRIPT_PARAM_ONOFF, true)
		
		AkaliMenu:addSubMenu("Summoner Spells", "SS")
			AkaliMenu.SS:addParam("IgniteUse", "Use Ignite in combo", SCRIPT_PARAM_ONOFF, true)
			
		AkaliMenu:addSubMenu("Orbwalker", "SOWiorb")	
			SOWi:LoadToMenu(AkaliMenu.SOWiorb)
		--AkaliMenu:addSubMenu("Miscellaneousc", "misc")
			--AkaliMenu.misc:addParam("Autolevel", "Auto-Level skills", SCRIPT_PARAM_ONOFF, true)
end
-- Full menu --





 function ItemManagement()	
    BilgeWaterCutlass = GetInventorySlotItem(3144)
    BilgeWaterCutlassR = (BilgeWaterCutlass ~= nil and myHero:CanUseSpell(BilgeWaterCutlass))
		
		HexTech = GetInventorySlotItem(3146)
		HexTechR = (HexTech ~= nil and myHero:CanUseSpell(HexTech))
		
		Lich = GetInventorySlotItem(3100)
		LichR = (Lich ~= nil and myHero:CanUseSpell(Lich) == READY)
		
		DFG = GetInventorySlotItem(3128)
		DFGR = (DFG ~= nil and myHero:CanUseSpell(DFG) == READY)
		
		Zhonya = GetInventorySlotItem(3157)
		ZhonyaReady = (Zhonya ~= nil and myHero:CanUseSpell(Zhonya) == READY)
end

function Variables()
Qready = (myHero:CanUseSpell(_Q) == READY)
Eready = (myHero:CanUseSpell(_E) == READY)
Rready = (myHero:CanUseSpell(_R) == READY)

end

function OnTick()
	ts:update()
	Variables()
	ItemManagement()
	
	if (myHero.health < 400) and AkaliMenu.IM.AutoZhonya then
			CastSpell(Zhonya)
	end
	
		if (ts.target ~= nil) then

		if (AkaliMenu.combo.ComboKey) then
			FullCombo()
		end
	end
end

function FullCombo()
	if AkaliMenu.combo.ComboKey and DFGR and AkaliMenu.IM.useDFG and GetDistance(			ts.target, myHero) < 500 then
		CastSpell(DFG, ts.target)
	end
	
		if AkaliMenu.combo.ComboKey and BilgeWaterCutlassR and AkaliMenu.IM.useBWC and GetDistance(ts.target, myHero) < 500 then
		CastSpell(BilgeWaterCutlass, ts.target)
	end
	
		if AkaliMenu.combo.ComboKey and HexTechR and AkaliMenu.IM.useHEX and GetDistance(ts.target, myHero) < 500 then
		CastSpell(HexTech, ts.target)
	end
	
	if AkaliMenu.SS.IgniteUse and GetDistance(ts.target) < 600 and ts.target.health <= (50 + (20 * myHero.level))then
		CastSpell(ignite, ts.target)
		end
	

	if AkaliMenu.combo.AllowQ and Qready then
		ActivateQ()
	end
	if AkaliMenu.combo.AllowE and Eready then
		ActivateE()
	end
	if AkaliMenu.combo.AllowR and Rready then
		if not AkaliMenu.combo.ChaseR then
		ActivateR()
	else if
		AkaliMenu.combo.ChaseR then
		ChaseRActivate()
		end
	end
end
end

function ChaseRActivate()
if GetDistance(ts.target, myHero) >= 450 then
		if GetDistance(ts.target, myHero) <= 800 then
			if ValidTarget(ts.target) then
				CastSpell(_R, ts.target)
			end
		end
	end
end

function ActivateQ()
	if GetDistance(ts.target, myHero) <= 600 then
			if ValidTarget(ts.target, 600) then
					CastSpell(_Q, ts.target)
		end
	end
end

	
function ActivateE()
if GetDistance(ts.target, myHero) <= 325 then
	if ValidTarget(ts.target, 325) then
		CastSpell(_E, ts.target)
	end
end
end

function ActivateR()
if GetDistance(ts.target, myHero) <= 820 then
	if ValidTarget(ts.target, 820) then
		CastSpell(_R, ts.target)
	end
end
end

-- Drawing options --
function OnDraw()
	if AkaliMenu.drawing.QRange then 
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0x111121)
	end
		if AkaliMenu.drawing.ERange then
		DrawCircle(myHero.x, myHero.y, myHero.z, 325, 0x111111)
	end
		if AkaliMenu.drawing.RRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, 820, 0x111111)
	end
			if AkaliMenu.drawing.ChasingR then
		DrawCircle(myHero.x, myHero.y, myHero.z, 500, 0x111111)
	end
end

