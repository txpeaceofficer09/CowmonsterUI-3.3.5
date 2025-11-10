local RecordsDisplay = "dmg"
local playerName = UnitName("player")

local mobFilter = {
	"Curator",
	"Vexallus",
}

local f = CreateFrame("Frame", "InfoBarRecordsList", InfoBarFrame)
f.columns = 7 -- spell, normal, normTarget, normZone, critical, critTarget, critZone
f:SetFrameStrata("FULLSCREEN")
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

function InfoBarRecords_Refresh()
	--print("InfoBarRecords_Refresh()")
	local data = RecordsDB[playerName][RecordsDisplay]

	if CowmonsterUI.Count(data) > 0 then
		--[[
		local tbl = {}

		for k,v in pairs(data) do
			table.insert(tbl, {
				["name"] = k or "???",
				["norm"] = v["norm"] or 0,
				["crit"] = v["crit"] or 0,
				["normTarget"] = v["normTarget"] or "???",
				["critTarget"] = v["critTarget"] or "???",
				["normZone"] = v["normZone"] or "???",
				["critZone"] = v["critZone"] or "???"
			})
		end
		
		table.sort(tbl, function(a,b)
			if a.crit or 0 == b.crit or 0 then
				return a["norm"] or 0 > b["norm"] or 0
			else
				return a["crit"] or 0 > b["crit"] or 0
			end
		end)
		]]

		--[[
		table.sort(data, function(a,b)
			if a.crit or 0 == b.crit or 0 then
				return a.norm or 0 > b.norm or 0
			else
				return a.crit or 0 > b.crit or 0
			end
		end)
		]]

		table.sort(data, function(a, b)
			if a == b then return end

			local critA, critB = (a.crit or 0), (b.crit or 0)
			if critA == critB then
				local normA, normB = (a.norm or 0), (b.norm or 0)
				return normA > normB
			else
				return critA > critB
			end
		end)

		local index = 1

		local bar = _G["InfoBarRecordsListBar0"] or CowmonsterUI.CreateBar("InfoBarRecords", 0, 0, 100)

		if bar then
			_G[("InfoBarRecordsListBar%sText1"):format(0)]:SetText("SPELL")
			_G[("InfoBarRecordsListBar%sText2"):format(0)]:SetText("NORMAL")
			_G[("InfoBarRecordsListBar%sText3"):format(0)]:SetText("TARGET")
			_G[("InfoBarRecordsListBar%sText4"):format(0)]:SetText("ZONE")
			_G[("InfoBarRecordsListBar%sText5"):format(0)]:SetText("CRITICAL")
			_G[("InfoBarRecordsListBar%sText6"):format(0)]:SetText("TARGET")
			_G[("InfoBarRecordsListBar%sText7"):format(0)]:SetText("ZONE")
		end

		for k,v in ipairs(data) do
			if index == 1 then
				InfoBarSetText("InfoBarRecords", "%s: %s / %s", v.name, CowmonsterUI.AddComma(v.norm), CowmonsterUI.AddComma(v.crit))
			end

			local bar = _G[("InfoBarRecordsListBar%s"):format(index)] or CowmonsterUI.CreateBar("InfoBarRecords", index, 0, 100)

			_G[("InfoBarRecordsListBar%sText1"):format(index)]:SetText(v.name)
			_G[("InfoBarRecordsListBar%sText2"):format(index)]:SetText(CowmonsterUI.AddComma(v["norm"]))
			_G[("InfoBarRecordsListBar%sText3"):format(index)]:SetText(v["normTarget"] or "")
			_G[("InfoBarRecordsListBar%sText4"):format(index)]:SetText(v["normZone"] or "")
			_G[("InfoBarRecordsListBar%sText5"):format(index)]:SetText(CowmonsterUI.AddComma(v["crit"]))
			_G[("InfoBarRecordsListBar%sText6"):format(index)]:SetText(v["critTarget"] or "")
			_G[("InfoBarRecordsListBar%sText7"):format(index)]:SetText(v["critZone"] or "")

			index = index + 1

			bar:Show()
		end

		for i=index,InfoBarRecordsList.numRows,1 do
			_G[("InfoBarRecordsListBar%s"):format(i)]:Hide()
		end

		for i=1,InfoBarRecordsList.columns,1 do
			CowmonsterUI.ResizeColumn("InfoBarRecords", i)
		end

		CowmonsterUI.ResizeList("InfoBarRecords", index)
	end
end

--CowmonsterUI.CreateBar("InfoBarRecords", 0, 0, 100)

function InfoBarRecords_OnEnter(self)
	--print("InfoBarRecords_OnEnter")
	if UnitAffectingCombat("player") then return end

	InfoBarRecords_Refresh()
	InfoBarRecordsList:SetPoint("BOTTOMRIGHT", InfoBarRecords, "TOPRIGHT", 0, 0)
	InfoBarRecordsList:Show()
end

function InfoBarRecords_OnLeave(self)
	--print("InfoBarRecords_OnLeave")
	InfoBarRecordsList:Hide()
end

function InfoBarRecords_OnClick(self, button)
	--print("InfoBarRecords_OnClick")
	--[[
	if RecordsDisplay == "dmg" then
		RecordsDisplay = "heal"
	elseif RecordsDisplay == "heal" then
		RecordsDisplay = "absorb"
	elseif RecordsDisplay == "absorb" then
		RecordsDisplay = "dmg"
	end
	]]
	if RecordsDisplay == "dmg" then
		RecordsDisplay = "heal"
	else
		RecordsDisplay = "dmg"
	end

	--print(("InfoBarRecords: switched to %s"):format(RecordsDisplay))

	InfoBarRecords_Refresh()
end

function InfoBarRecords_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		InfoBarRecords_Refresh()
		self.timer = 0
	end
end

local function AddSpellRecord(sourceName, destName, spellName, amount, crit, type)
	local index = 0

	--print(sourceName, destName, spellName, amount, crit, type)

	for k,v in ipairs(RecordsDB[UnitName("player")][type]) do
		if v.name == spellName then index = k end
	end

	if index > 0 then
		local data = RecordsDB[playerName][type][index]

		if (crit or 0) == 1 then
			if data.crit < amount then
				RecordsDB[playerName][type][index].crit = amount
				RecordsDB[playerName][type][index].critTarget = destName
				RecordsDB[playerName][type][index].critZone = GetRealZoneText()

				print(("New critical %s record (%d)"):format(spellName, amount))
			end
		else
			if data.norm < amount then
				RecordsDB[playerName][type][index].norm = amount
				RecordsDB[playerName][type][index].normTarget = destName
				RecordsDB[playerName][type][index].normZone = GetRealZoneText()

				print(("New normal %s record (%d)"):format(spellName, amount))
			end
		end
	else
		if (crit or 0) == 1 then
			table.insert(RecordsDB[playerName][type], {
				["name"] = spellName,
				["crit"] = amount,
				["critTarget"] = destName,
				["critZone"] = GetRealZoneText(),
				["norm"] = 0,
				["normTarget"] = "",
				["normZone"] = "",
			})

			print(("New critical %s record (%d)"):format(spellName, amount))
		else
			table.insert(RecordsDB[playerName][type], {
				["name"] = spellName,
				["crit"] = 0,
				["critTarget"] = "",
				["critZone"] = "",
				["norm"] = amount,
				["normTarget"] = destName,
				["normZone"] = GetRealZoneText(),
			})

			print(("New normal %s record (%d)"):format(spellName, amount))
		end
	end
end

function InfoBarRecords_OnEvent(self, event, ...)
	--print(("Call: InfoBarRecords_OnEvent(%s, %s)"):format(self:GetName(), event), ...)
	--if ( event == "ADDON_LOADED" and select(1, ...) == "CowmonsterUI_InfoBar" ) or event == "VARIABLES_LOADED" then
	if event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		if RecordsDB == nil then RecordsDB = {} end
		if playerName == nil then playerName = UnitName("player") end

		InfoBarSetText("InfoBarRecords", "No Records")
		InfoBarRecords_Refresh()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, combatEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, amount, overkill, resisted, blocked, absorbed, critical, glancing, crushing, multistrike, extraAttacks = ...

		--if tContains(mobFilter, destName) ~= true then return end

		if sourceName ~= playerName then return end

		if bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and sourceName ~= nil then
			if RecordsDB == nil then RecordsDB = {} end
			if RecordsDB[sourceName] == nil then RecordsDB[sourceName] = {} end
			if RecordsDB[sourceName]["dmg"] == nil then RecordsDB[sourceName]["dmg"] = {} end
			if RecordsDB[sourceName]["heal"] == nil then RecordsDB[sourceName]["heal"] = {} end
			if RecordsDB[sourceName]["absorb"] == nil then RecordsDB[sourceName]["absorb"] = {} end

			if string.find(combatEvent, "SWING") then
				local spell = "Auto Attack"
				local amount = select(9, ...) or 0
				local crit = select(10, ...) or 0

				AddSpellRecord(sourceName, destName, spell, amount, crit, "dmg")
			elseif string.find(combatEvent, "_DAMAGE") then
				local spell = select(10, ...)
				local amount = amount or 0
				local crit = select(18, ...) or 0

				--print(...)

				if string.find(combatEvent, "_PERIODIC_") then spell = spell.." (DoT)" end

				if spell and type(spell) == "string" then
					AddSpellRecord(sourceName, destName, spell, amount, crit, "dmg")
				end
			elseif string.find(combatEvent, "_HEAL") then
				local spell = spellName
				local amount = amount or 0
				local crit = blocked or 0

				if string.find(combatEvent, "PERIODIC") then spell = spell.." (HoT)" end
	
				if spell and type(spell) == "string" then
					AddSpellRecord(sourceName, destName, spell, amount, crit, "heal")
				end
			elseif string.find(combatEvent, "_ABSORBED") then
				local spell = spellName
				local amount = amount or 0
				local crit = blocked or 0
				
				if spell and type(spell) == "string" then
					AddSpellRecord(sourceName, destName, spell, amount, crit, "absorb")
				end
			end
		end
	end
end

SLASH_RECORDS1 = "/records"
SlashCmdList["RECORDS"] = function(input)
	-- split the string and then if the first parameter is reset and there is a second parameter that second parameter is the name of the player to reset
	if input == "reset" then
		RecordsDB[playerName] = {["dmg"] = {}, ["heal"] = {}, ["absorb"] = {}};
		DEFAULT_CHAT_FRAME:AddMessage("Records have been reset.")
		InfoBarSetText("InfoBarRecords", "No Records")
	else
		--DEFAULT_CHAT_FRAME:AddMessage("Records: "..input)
		for k,v in pairs(RecordsDB[playerName]) do
			print("=====[ "..k.." ]=====")
			for a,b in pairs(v) do
				print(a, b.norm, b.crit)
			end
		end
	end
end
