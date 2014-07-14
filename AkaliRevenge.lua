-- Credit to Jarvis101, Used his scripts to learn alot of what I put
-- Credit to Jorj, Basically held my hand when creating from the beginning Da best yo
-- Credit to Bilbao, Answered alot of my forum questions

-- I in no way claim to be a expert, I got babysat like hell on this script #First Script

--[[
v1.0 - Initial release
v1.01 - Harass /w E removed temporarily
v1.02 - Last hitting + Lane clear /w abilities added
v1.03 - Fixed a bug where if E wasn't learn't lane clear / last hit would bug out

--]]


-- Champion selecton verification --
if myHero.charName ~= "Akali" then return end
-- Champion selecton verification --

-- Libs --
require "SOW"
require "VPrediction"

local qRange = 600
local eRange = 325
local rRange = 800
local eDmg = nil

-- Target Selector thingy --
local ts

local AUTO_UPDATE = true
local VERSION = 1.03


if AUTO_UPDATE then
    local server_version = tonumber(GetWebResult("raw.github.com", "/ConnorMccG/BoLScripts/master/version/AkaliRevenge.version")) -- I have a file on my github which just shows the newest version, what I'm doing here is downloading it and comparing with the constant value above and if there is a newer version then go through the update process
    if server_version > VERSION then -- compare
        PrintChat("Script is outdated. Updating to version: " .. server_version .. "...")
        DownloadFile("https://raw.github.com//ConnorMccG/BoLScripts/master/AkaliRevenge.lua", SCRIPT_PATH .. "AkaliRevenge.lua", function() -- Download the new script (we're literally overwriting the current one)
            PrintChat("Script updated. Please reload (F9).")
        end)
    end
    if server_version > VERSION then return end -- Quit out the script as it will cause issues
end



 
 -- Loaded just once (Beginning of the game) --
function OnLoad()

enemyMinions = minionManager(MINION_ENEMY, qRange, myHero, MINION_SORT_MAXHEALTH_DEC)
VP = VPrediction()
SOWi = SOW(VP)
SOWi:RegisterAfterAttackCallback(AutoAttackRese)
Variables()
AkalisMenu()
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 650)

PrintChat("<font color='#aaff34'>Thanks for using AkaliRevenge, Report bugs on the forum</font>")


-- Checking for Ignite --
if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then 
	ignite = SUMMONER_1
		elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then 
	ignite = SUMMONER_2
		else 
	ignite = nil
	end
	
end

-- Full menu --
function AkalisMenu()

	AkaliMenu = scriptConfig("Akali, The flying assassin", "Akali")
	-- Combo Menu --
		AkaliMenu:addSubMenu("Combo Settings", "combo")
			AkaliMenu.combo:addParam("ComboKey", "Preform full combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			AkaliMenu.combo:addParam("AllowQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.combo:addParam("AllowE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.combo:addParam("AllowR", "Use R in combo", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.combo:addParam("ChaseR", "Chase with R only", SCRIPT_PARAM_ONOFF, true)
			
	-- Harass menu --
		AkaliMenu:addSubMenu("Harass Settings", "harass")
			AkaliMenu.harass:addParam("HarassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
	
	-- Draw Menu --
		AkaliMenu:addSubMenu("Draw settings", "drawing")
			AkaliMenu.drawing:addParam("QRange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.drawing:addParam("ERange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.drawing:addParam("RRange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.drawing:addParam("ChasingR", "Draw R Chase Range", SCRIPT_PARAM_ONOFF, true)
			
	-- Lane Clear --
		AkaliMenu:addSubMenu("Lane Clear Settings", "lc")
			AkaliMenu.lc:addParam("useQ", "Use Q in laneclear", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.lc:addParam("useE", "Use E in laneclear", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.lc:addParam("laneclear", "Laneclear mode", SCRIPT_PARAM_ONKEYDOWN, false, 86)
	
	-- Last hitting --
		AkaliMenu:addSubMenu("Last hit settings", "lh")
			AkaliMenu.lh:addParam("lasthit", "Lasthit mode", SCRIPT_PARAM_ONKEYDOWN, false, 88)
			AkaliMenu.lh:addParam("useQ", "Use Q to lasthit", SCRIPT_PARAM_ONOFF, false)
			AkaliMenu.lh:addParam("useE", "Use E to lasthit", SCRIPT_PARAM_ONOFF, true)
			
	-- Item Management Menu --
		AkaliMenu:addSubMenu("Item Management", "IM")
			AkaliMenu.IM:addParam("AutoZhonya", "Zhonya's Low health", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.IM:addParam("useDFG", "Use Deathfire grasp", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.IM:addParam("useBWC", "Use BilgeWaterCutlass", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.IM:addParam("useHEX", "Use HexTech Revolver", SCRIPT_PARAM_ONOFF, true)
		
	-- Placeholder Menu --
		AkaliMenu:addSubMenu("Extras", "SS")
			AkaliMenu.SS:addParam("IgniteUse", "Use Ignite in combo", SCRIPT_PARAM_ONOFF, true)
			AkaliMenu.SS:addParam("usepackets", "Use packets (VIP ONLY)", SCRIPT_PARAM_ONOFF, true)
			
	-- SOW Orbwalking handler --
		AkaliMenu:addSubMenu("Orbwalker", "SOWiorb")	
			SOWi:LoadToMenu(AkaliMenu.SOWiorb)
			
			
end

-- Calc E damage /w levels --
function eDamage()
  if myHero:GetSpellData(_E).level == 1 then eDmg = 30
  elseif myHero:GetSpellData(_E).level == 2 then eDmg = 55
  elseif myHero:GetSpellData(_E).level == 3 then eDmg = 80
  elseif myHero:GetSpellData(_E).level == 4 then eDmg = 105
  elseif myHero:GetSpellData(_E).level == 5 then eDmg = 130
  end
end 

-- Last hitting zone --
function LastHitMode()
eDamage()
  for i, minion in pairs(enemyMinions.objects) do
    if minion ~= nil then
      if ValidTarget(minion, qRange) and AkaliMenu.lh.useQ and Qready and getDmg("Q", minion, myHero) >= minion.health then
        CastSpell(_Q, minion)
      end
      if ValidTarget(minion, eRange) and AkaliMenu.lh.useE and EReady and (getDmg("AD", minion, myHero) + (eDmg + (myHero.ap * 0.4 ))) >= minion.health then 
        CastSpell(_E)
      end
    end
  end
end

 -- Lane clear zone --
function LaneclearMode() 
  for i, minion in pairs(enemyMinions.objects) do
    if minion ~= nil and ValidTarget(minion, qRange) and Qready and AkaliMenu.lc.useQ then
      if getDmg("Q", minion, myHero) >= minion.health then
        CastSpell(_Q, minion)
      else
        CastSpell(_Q, minion)
      end
    end
    if minion ~= nil and ValidTarget(minion, eRange) and Eready and AkaliMenu.lc.useE then
        CastSpell(_E)
    end
  end
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

-- Variables used to call easier --
function Variables()
Qready = (myHero:CanUseSpell(_Q) == READY)
Eready = (myHero:CanUseSpell(_E) == READY)
Rready = (myHero:CanUseSpell(_R) == READY)
end

-- Executed every couple of milliseconds --
function OnTick()
ts:update()
Variables()
ItemManagement()
SOWi:EnableAttacks()
enemyMinions:update()

if AkaliMenu.lh.lasthit then LastHitMode() end
if AkaliMenu.lc.laneclear then LaneclearMode() end

	if (myHero.health < 400) and AkaliMenu.IM.AutoZhonya then
		CastSpell(Zhonya)
	end
	
	if (ts.target ~= nil) then
		if (AkaliMenu.harass.HarassKey) then
			FullHarass()
		end
	end

	if (ts.target ~= nil) then
		if (AkaliMenu.combo.ComboKey) then
			FullCombo()
		end
	end
end

function FullHarass()

	if GetDistance(ts.target, myHero) <= 600 then
		if ValidTarget(ts.target, 600) then
			if VIP_USER and AkaliMenu.SS.usepackets then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = ts.target.networkID}):send()
			else
				CastSpell(_Q, ts.target)
			end
		end
	end
end


function FullCombo()
	if AkaliMenu.combo.ComboKey and DFGR and AkaliMenu.IM.useDFG and GetDistance(ts.target, myHero) < 500 then 
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

-- Combo settings --
function ChaseRActivate()
if GetDistance(ts.target, myHero) >= 450 then
	if GetDistance(ts.target, myHero) <= 800 then
		if ValidTarget(ts.target) then
			if VIP_USER and AkaliMenu.SS.usepackets then
				Packet("S_CAST", {spellId = _R}):send()
			else
				CastSpell(_R, ts.target)
			end
		end
	end
end
end

function ActivateQ()
	if GetDistance(ts.target, myHero) <= 600 then
		if ValidTarget(ts.target, 600) then
			    if VIP_USER and AkaliMenu.SS.usepackets then
						Packet("S_CAST", {spellId = _Q, targetNetworkId = ts.target.networkID}):send()
					else
						CastSpell(_Q, ts.target)
					end
			end
		end
end

function ActivateE()
	if GetDistance(ts.target, myHero) <= 325 then
		if ValidTarget(ts.target, 325) then
			if VIP_USER and AkaliMenu.SS.usepackets then
				Packet("S_CAST", {spellId = _E}):send()
				else
					CastSpell(_E, ts.target)
			end
		end
	end
end

function ActivateR()
if GetDistance(ts.target, myHero) <= 800 then
			if ValidTarget(ts.target, 800) then
				if VIP_USER and AkaliMenu.SS.usepackets then
					Packet("S_CAST", {spellId = _R, targetNetworkId = ts.target.networkID}):send()
				else
					CastSpell(_R, ts.target)
			end
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
