local f = CreateFrame("Frame", nil, UIParent)

local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" and select(1, ...) == "RecordTip" or event == "VARIABLES_LOADED" then
		--if RecordTipDB and ( RecordTipDB["dmg"] or RecordTipDB["heal"] ) then RecordTipDB = nil end -- Remove old format database so we can use the new that has per spec records.

		if RecordTipDB == nil then
			RecordTipDB = {["dmg"] = {}, ["heal"] = {}, ["absorb"] = {}}
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		--local timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, amount, critSwing, _, critHeal, _, _, critDmg = ...
		local timestamp, combatEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, amount, overkill, schoolMask, resisted, blocked, absorbed, critical, glancing, crushing, multistrike, extraAttacks = ...

		if RecordTipDB.dmg == nil then RecordTipDB.dmg = {} end
		if RecordTipDB.heal == nil then RecordTipDB.heal = {} end
		if RecordTipDB.absorb == nil then RecordTipDB.absorb = {} end

		if sourceName == UnitName("player") then
			if string.find(combatEvent, "SWING") then
				local spell = "Auto Attack"
				local amount = spellName or 0
				local crit = critSwing or 0

				RecordTipDB.dmg[spell] = RecordTipDB.dmg[spell] or {["norm"] = 0, ["crit"] = 0}
				if crit == 1 then
					local record = RecordTipDB.dmg[spell].crit or 0
					
					if record < amount then
						RecordTipDB.dmg[spell].crit = amount
					end
				else
					local record = RecordTipDB.dmg[spell].norm or 0

					if record < amount then
						RecordTipDB.dmg[spell].norm = amount
					end
				end
			elseif string.find(combatEvent, "_DAMAGE") then
				local spell = spellName
				local amount = amount or 0
				local crit = critDmg or 0
	
				if spell and type(spell) == "string" then
					RecordTipDB.dmg[spell] = RecordTipDB.dmg[spell] or {["norm"] = 0, ["crit"] = 0}
					if crit == 1 then
						local record = RecordTipDB.dmg[spell].crit or 0
	
						if record < amount then
							RecordTipDB.dmg[spell].crit = amount
						end
					else
						local record = RecordTipDB.dmg[spell].norm or 0
	
						if record < amount then
							RecordTipDB.dmg[spell].norm = amount
						end
					end
				end
			elseif string.find(combatEvent, "_HEAL") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
	
				if spell and type(spell) == "string" then
					RecordTipDB.heal[spell] = RecordTipDB.heal[spell] or {["norm"] = 0, ["crit"] = 0}
	
					if crit == 1 then
						local record = RecordTipDB.heal[spell].crit or 0
	
						if record < amount then
							RecordTipDB.heal[spell].crit = amount
						end
					else
						local record = RecordTipDB.heal[spell].norm or 0
	
						if record < amount then
							RecordTipDB.heal[spell].norm = amount
						end
					end
				end
			elseif string.find(combatEvent, "_ABSORBED") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
				
				if spell and type(spell) == "string" then
					RecordTipDB.absorb[spell] = RecordTipDB.absorb[spell] or {["norm"] = 0, ["crit"] = 0}
					
					if crit == 1 then
						local record = RecordTipDB.absorb[spell].cirt or 0
						
						if record < amount then
							RecordTipDB.absorb[spell].crit = amount
						end
					else
						local record = RecordTipDB.absorb[spell].norm or 0
						
						if record < amount then
							RecordTipDB.absorb[spell].norm = amount
						end
					end
				end
			end
		end
	end
end

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", OnEvent)

local function OnTooltipSetSpell(self)
	DEFAULT_CHAT_FRAME:AddMessage("OnTooltipSetSpell")
end

local GameTooltip = GameTooltip

GameTooltip:HookScript("OnTOoltipSetSpell", OnTooltipSetSpell)

--GameTooltip:HookScript("OnShow", function(self)
--[[
GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local spell = self:GetSpell();

	DEFAULT_CHAT_FRAME:AddMessage(spell)

	if RecordTipDB == nil then RecordTipDB = {} end
	if RecordTipDB == nil then RecordTipDB = {} end

	if RecordTipDB.dmg == nil then RecordTipDB.dmg = {} end
	if RecordTipDB.heal == nil then RecordTipDB.heal = {} end
	if RecordTipDB.absorb == nil then RecordTipDB.absorb = {} end

	if spell and RecordTipDB.dmg[spell] and (RecordTipDB.dmg[spell].crit > 0 or RecordTipDB.dmg[spell].norm > 0) then
		self:AddLine(" ");
		self:AddLine("|cFFFFFF44["..spec.."] |cFFFF4444Damage");
		if RecordTipDB.dmg[spell.."!"] and ( RecordTipDB.dmg[spell.."!"].norm or 0 ) > ( RecordTipDB.dmg[spell].norm or 0 ) then
			self:AddDoubleLine("Normal", CowmonsterUI.AddComma(RecordTipDB.dmg[spell.."!"].norm), 1, 1, 1, 0, 1, 0);
		elseif ( RecordTipDB.dmg[spell].norm or 0 ) > 0 then
			self:AddDoubleLine("Normal", CowmonsterUI.AddComma(RecordTipDB.dmg[spell].norm), 1, 1, 1, 0, 1, 0);
		end

		if RecordTipDB.dmg[spell.."!"] and ( RecordTipDB.dmg[spell.."!"].crit or 0 ) > ( RecordTipDB.dmg[spell].crit or 0 ) then
			self:AddDoubleLine("Critical", CowmonsterUI.AddComma(RecordTipDB.dmg[spell.."!"].crit), 1, 1, 1, 0, 1, 0);
		elseif ( RecordTipDB.dmg[spell].crit or 0 ) > 0 then
			self:AddDoubleLine("Critical", CowmonsterUI.AddComma(RecordTipDB.dmg[spell].crit), 1, 1, 1, 0, 1, 0);
		end
	end

	if spell and RecordTipDB.heal[spell] and (RecordTipDB.heal[spell].crit > 0 or RecordTipDB.heal[spell].norm > 0) then
		self:AddLine(" ");
		self:AddLine("|cFFFFFF44["..spec.."] |cFF44FF44Heal");
		if RecordTipDB.heal[spell.."!"] and ( RecordTipDB.heal[spell.."!"].norm or 0 ) > ( RecordTipDB.heal[spell].norm or 0 ) then
			self:AddDoubleLine("Normal", CowmonsterUI.AddComma(RecordTipDB.heal[spell.."!"].norm), 1, 1, 1, 0, 1, 0);
		elseif ( RecordTipDB.heal[spell].norm or 0 ) > 0 then
			self:AddDoubleLine("Normal", CowmonsterUI.AddComma(RecordTipDB.heal[spell].norm), 1, 1, 1, 0, 1, 0);
		end

		if RecordTipDB.heal[spell.."!"] and ( RecordTipDB.heal[spell.."!"].crit or 0 ) > ( RecordTipDB.heal[spell].crit or 0 ) then
			self:AddDoubleLine("Critical", CowmonsterUI.AddComma(RecordTipDB.heal[spell.."!"].crit), 1, 1, 1, 0, 1, 0);
		elseif ( RecordTipDB.heal[spell].crit or 0 ) > 0 then
			self:AddDoubleLine("Critical", CowmonsterUI.AddComma(RecordTipDB.heal[spell].crit), 1, 1, 1, 0, 1, 0);
		end
	end
		
	if spell and RecordTipDB.absorb[spell] and ( RecordTipDB.absorb[spell.."!"].norm or 0 ) > ( RecordTipDB.absorb[spell].norm or 0 ) then
		self:AddLine(" ");
		self:AddLine("|cFFFFFF44["..spec.."] |cFFFFFF44Absorb");
		if RecordTipDB.absorb[spell.."!"] and ( RecordTipDB.absorb[spell.."!"].norm or 0 ) > ( RecordTipDB.absorb[spell].norm or 0 ) then
			self:AddDoubleLine("Normal", CowmonsterUI.AddComma(RecordTipDB.absorb[spell.."!"].norm), 1, 1, 1, 0, 1, 0);
		elseif ( RecordTipDB.absorb[spell].norm or 0 ) > 0 then
			self:AddDoubleLine("Normal", CowmonsterUI.AddComma(RecordTipDB.absorb[spell].norm), 1, 1, 1, 0, 1, 0);
		end

		if RecordTipDB.absorb[spell.."!"] and ( RecordTipDB.absorb[spell.."!"].crit or 0 ) > ( RecordTipDB.absorb[spell].crit or 0 ) then
			self:AddDoubleLine("Critical", CowmonsterUI.AddComma(RecordTipDB.absorb[spell.."!"].crit), 1, 1, 1, 0, 1, 0);
		elseif ( RecordTipDB.absorb[spell].crit or 0 ) > 0 then
			self:AddDoubleLine("Critical", CowmonsterUI.AddComma(RecordTipDB.absorb[spell].crit), 1, 1, 1, 0, 1, 0);
		end
	end
end);
]]

--[[
local function ResetDB()
	RecordTipDB = nil
	RecordTipDB = {["dmg"] = {}, ["heal"] = {}, ["absorb"] = {}}
	DEFAULT_CHAT_FRAME:AddMessage("|cFF44FF44RecordTip|cFFFFFFFF all records reset.")	
end

local function SlashCmdHandler(...)
	if select(1, ...) and string.lower(select(1, ...)) == "reset" then
		--RecordTipDB = nil
		--RecordTipDB = {[1] = {["dmg"] = {}, ["heal"] = {}}, [2] = {["dmg"] = {}, ["heal"] = {}}, [3] = {["dmg"] = {}, ["heal"] = {}}, [4] = {["dmg"] = {}, ["heal"] = {}}}
		--DEFAULT_CHAT_FRAME:AddMessage("|cFF44FF44RecordTip|cFFFFFFFF all records reset.")
		ResetDB()
	end
end

SlashCmdList['RECORDTIP_SLASHCMD'] = SlashCmdHandler
SLASH_RECORDTIP_SLASHCMD1 = '/recordtip'
SLASH_RECORDTIP_SLASHCMD2 = '/rt'
]]
