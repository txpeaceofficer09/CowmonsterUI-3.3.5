local RecordsDisplay = "dmg"
local playerName = UnitName("player")

local mobFilter = {
	"Curator",
	"Vexallus",
}

local f = CreateFrame("Frame", "InfoBarRecordsList", InfoBarFrame)
f.columns = 7 -- spell, normal, normTarget, normZone, critical, critTarget, critZone
--f:SetFrameLevel(99)
f:SetFrameStrata("FULLSCREEN")
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

local function count(table)
	local count = 0

	for _, _ in pairs(table) do
		count = count + 1
	end

	return count
end

local function CreateBar(index)
	--print(("Call: CreateBar(%s)"):format(index))
	local bar = CreateFrame("Frame", ("InfoBarRecordsListBar%s"):format(index), InfoBarRecordsList)

	InfoBarRecordsList.numRows = index

	if index == 0 then
		bar:SetPoint("TOPLEFT", InfoBarRecordsList, "TOPLEFT", 4, -4)
		bar:SetPoint("TOPRIGHT", InfoBarRecordsList, "TOPRIGHT", -4, -4)
	else
		bar:SetPoint("TOPLEFT", _G["InfoBarRecordsListBar"..(index-1)], "BOTTOMLEFT", 0, -2)
		bar:SetPoint("TOPRIGHT", _G["InfoBarRecordsListBar"..(index-1)], "BOTTOMRIGHT", 0, -2)
	end

	bar:SetHeight(16)
	--bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")

	for i=1,InfoBarRecordsList.columns,1 do
		--Add labels to the bar
		--ctl:SetFont("Fonts\\ARIALN.ttf", FontSize, "OUTLINE")
		--local t = bar:CreateFontString(("InfoBarRecordsListBar%sText%s"):format(index, i), "OVERLAY", "NumberFont_Outline_Med")
		local t = bar:CreateFontString(("InfoBarRecordsListBar%sText%s"):format(index, i), "OVERLAY")
		t:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
		if i == 1 then
			t:SetPoint("LEFT", bar, "LEFT", 2, 0)
		else
			t:SetPoint("LEFT", _G[("InfoBarRecordsListBar%sText%s"):format(index, (i-1))], "RIGHT", 0, 0)
		end

		t:SetJustifyH("LEFT")
	end

	return bar
end

local function ResizeColumn(index)
	--print(("Call: ResizeColumn(%d)"):format(index))
	local max = 0

	for i=0,count(RecordsDB[playerName][RecordsDisplay]),1 do
		--local bar = _G[("InfoBarRecordsListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarRecordsListBar%sText%s"):format(i, index)]

		if label == nil then ChatFrame:AddMessage(("InfoBarRecordsListBar%sText%s not found."):format(i, index)) end

		if label:GetStringWidth() > max then max = label:GetStringWidth() end
		--label:SetWidth(label:GetStringWidth()+30)
	end

	for i=0,count(RecordsDB[playerName][RecordsDisplay]),1 do
		--local bar = _G[("InfoBarRecordsListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarRecordsListBar%sText%s"):format(i, index)]
		
		label:SetWidth(max+30)
	end
end

local function ResizeList()
	--print("Call: ResizeList()")
	local width = 0
	InfoBarRecordsList:SetHeight((count(RecordsDB[playerName][RecordsDisplay])*18)+18)

	for i=1,InfoBarRecordsList.columns,1 do
		local lbl = _G[("InfoBarRecordsListBar1Text%s"):format(i)]
		if lbl ~= nil then
			--width = width + _G[("InfoBarRecordsListBar1Text%s"):format(i)]:GetWidth() + 2
			width = width + lbl:GetWidth() + 2
		end
	end

	InfoBarRecordsList:SetWidth(width)
end

function InfoBarRecords_Refresh()
	--print("Call: InfoBarRecords_Refresh()")
	--print(("Records count: %d"):format(count(RecordsDB[playerName][RecordsDisplay])))

	local data = RecordsDB[playerName][RecordsDisplay]

	if count(data) > 0 then
		local tbl = {}

		for k,v in pairs(data) do
			tinsert(tbl, {["name"] = k or "???", ["norm"] = v["norm"] or 0, ["crit"] = v["crit"] or 0, ["normTarget"] = v["normTarget"] or "???", ["critTarget"] = v["critTarget"] or "???", ["normZone"] = v["normZone"] or "???", ["critZone"] = v["critZone"] or "???"})
		end

		sort(tbl, function(a,b)		
			if a["crit"] or 0==b["crit"] or 0 then
				return a["norm"] or 0 > b["norm"] or 0
			else
				return a["crit"] or 0 > b["crit"] or 0
			end
		end)

		local index = 1

		_G[("InfoBarRecordsListBar%sText1"):format(0)]:SetText("SPELL")
		_G[("InfoBarRecordsListBar%sText2"):format(0)]:SetText("NORMAL")
		_G[("InfoBarRecordsListBar%sText3"):format(0)]:SetText("TARGET")
		_G[("InfoBarRecordsListBar%sText4"):format(0)]:SetText("ZONE")
		_G[("InfoBarRecordsListBar%sText5"):format(0)]:SetText("CRITICAL")
		_G[("InfoBarRecordsListBar%sText6"):format(0)]:SetText("TARGET")
		_G[("InfoBarRecordsListBar%sText7"):format(0)]:SetText("ZONE")

		for k,v in ipairs(tbl) do
			if index == 1 then
				InfoBarSetText("InfoBarRecords", "%s: %s / %s", v.name, CowmonsterUI.AddComma(v["norm"]), CowmonsterUI.AddComma(v["crit"]))
			end

			local bar = _G[("InfoBarRecordsListBar%s"):format(index)] or CreateBar(index)

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
			ResizeColumn(i)
		end

		ResizeList()
	end
end

CreateBar(0)

function InfoBarRecords_OnEnter(self)
	--print(("Call: InfoBarRecords_OnEnter(%s)"):format(self:GetName()))
	if UnitAffectingCombat("player") then return end

	InfoBarRecords_Refresh()
	InfoBarRecordsList:SetPoint("BOTTOMRIGHT", InfoBarRecords, "TOPRIGHT", 0, 0)
	InfoBarRecordsList:Show()
end

function InfoBarRecords_OnLeave(self)
	
	InfoBarRecordsList:Hide()
end

function InfoBarRecords_OnClick(self, button)
	--print(("Call: InfoBarRecords_OnClick(%s, %s)"):format(self:GetName(), button))
	if RecordsDisplay == "dmg" then
		RecordsDisplay = "heal"
	elseif RecordsDisplay == "heal" then
		RecordsDisplay = "absorb"
	elseif RecordsDisplay == "absorb" then
		RecordsDisplay = "dmg"
	end

	print(("InfoBarRecords: switched to %s"):format(RecordsDisplay))

	InfoBarRecords_Refresh()
end

function InfoBarRecords_OnUpdate(self, elapsed)
	--print(("Call: InfoBarRecords_OnUpdate(%s, %s)"):format(self:GetName(), elapsed))
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		InfoBarRecords_Refresh()
		self.timer = 0
	end
end

function InfoBarRecords_OnEvent(self, event, ...)
	--print(("Call: InfoBarRecords_OnEvent(%s, %s, ...)"):format(self:GetName(), event))
	if ( event == "ADDON_LOADED" and select(1, ...) == "CowmonsterUI_InfoBar" ) or event == "VARIABLES_LOADED" then
		if RecordsDB == nil then RecordsDB = {} end
		--[[
		if RecordsDB[playerName] == nil then
			RecordsDB[playerName] = {["dmg"] = {}, ["heal"] = {}, ["absorb"] = {}}
		end
		]]
		if playerName == nil then playerName = UnitName("player") end
		InfoBarSetText("InfoBarRecords", "No Records")
		InfoBarRecords_Refresh()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, combatEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, amount, overkill, resisted, blocked, absorbed, critical, glancing, crushing, multistrike, extraAttacks = ...

		--if tContains(mobFilter, destName) ~= true then return end

		--if sourceName == playerName then
		if bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 and sourceName ~= nil then
			if RecordsDB == nil then RecordsDB = {} end
			if RecordsDB[sourceName] == nil then RecordsDB[sourceName] = {} end
			if RecordsDB[sourceName]["dmg"] == nil then RecordsDB[sourceName]["dmg"] = {} end
			if RecordsDB[sourceName]["heal"] == nil then RecordsDB[sourceName]["heal"] = {} end
			if RecordsDB[sourceName]["absorb"] == nil then RecordsDB[sourceName]["absorb"] = {} end

			if string.find(combatEvent, "SWING") then
				local spell = "Auto Attack"
				local amount = spellID or 0
				local crit = spellName or 0

				if RecordsDB[sourceName]["dmg"][spell] == nil then RecordsDB[sourceName]["dmg"][spell] = {} end

				local data = RecordsDB[sourceName]["dmg"][spell]

				if crit or 0 == 1 then
					if data.crit or 0 < amount then
						RecordsDB[sourceName]["dmg"][spell]["crit"] = amount
						RecordsDB[sourceName]["dmg"][spell]["critTarget"] = destName
						RecordsDB[sourceName]["dmg"][spell]["critZone"] = GetRealZoneText()
					end					
				else
					if data.norm or 0 < amount then
						RecordsDB[sourceName]["dmg"][spell]["norm"] = amount
						RecordsDB[sourceName]["dmg"][spell]["normTarget"] = destName
						RecordsDB[sourceName]["dmg"][spell]["normZone"] = GetRealZoneText()
					end
				end
				RecordsDB[sourceName]["dmg"][spell]["spellID"] = spellID
			elseif string.find(combatEvent, "_DAMAGE") then
				local spell = spellName
				local amount = amount or 0
				--local crit = critDmg or 0
				local crit = critical or 0

				if spell and type(spell) == "string" then
					--print(("%s (%d) %d %d"):format(spell, spellID, amount, crit))
					--InfoBarRecords_AddRecord(destName, spell, spellID, "dmg", amount, crit)
					RecordsDB[sourceName]["dmg"][spell] = RecordsDB[sourceName]["dmg"][spell] or {}
					if crit == 1 then
						local record = RecordsDB[sourceName]["dmg"][spell]["crit"] or 0
	
						if record < amount then
							RecordsDB[sourceName]["dmg"][spell]["crit"] = amount
							RecordsDB[sourceName]["dmg"][spell]["critTarget"] = destName
							RecordsDB[sourceName]["dmg"][spell]["spellID"] = spellID
							RecordsDB[sourceName]["dmg"][spell]["critZone"] = GetRealZoneText()
							--ChatFrame:AddMessage(("New %s critical record (%s)"):format(spell, amount))

							--print(("%s hit a new %s crit record %d!"):format(sourceName, spell, amount))
						end
					else
						local record = RecordsDB[sourceName]["dmg"][spell]["norm"] or 0
	
						if record < amount then
							RecordsDB[sourceName]["dmg"][spell]["norm"] = amount
							RecordsDB[sourceName]["dmg"][spell]["normTarget"] = destName
							RecordsDB[sourceName]["dmg"][spell]["spellID"] = spellID
							RecordsDB[sourceName]["dmg"][spell]["normZone"] = GetRealZoneText()
							--ChatFrame:AddMessage(("New %s normal record (%s)"):format(spell, amount))

							--print(("%s hit a new %s normal record %d!"):format(sourceName, spell, amount))
						end
					end
				end
			elseif string.find(combatEvent, "_HEAL") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
	
				if spell and type(spell) == "string" then
					RecordsDB[sourceName]["heal"][spell] = RecordsDB[sourceName]["heal"][spell] or {}
	
					if crit == 1 then
						local record = RecordsDB[sourceName]["heal"][spell]["crit"] or 0
	
						if record < amount then
							RecordsDB[sourceName]["heal"][spell]["crit"] = amount
							RecordsDB[sourceName]["heal"][spell]["critTarget"] = destName
							RecordsDB[sourceName]["heal"][spell]["spellID"] = spellID
							RecordsDB[sourceName]["heal"][spell]["critZone"] = GetRealZoneText()

							--print(("%s hit a new %s crit record %d!"):format(sourceName, spell, amount))
						end
					else
						local record = RecordsDB[sourceName]["heal"][spell]["norm"] or 0
	
						if record < amount then
							RecordsDB[sourceName]["heal"][spell]["norm"] = amount
							RecordsDB[sourceName]["heal"][spell]["normTarget"] = destName
							RecordsDB[sourceName]["heal"][spell]["spellID"] = spellID
							RecordsDB[sourceName]["heal"][spell]["normZone"] = GetRealZoneText()

							--print(("%s hit a new %s crit record %d!"):format(sourceName, spell, amount))
						end
					end
				end
			elseif string.find(combatEvent, "_ABSORBED") then
				local spell = spellName
				local amount = amount or 0
				local crit = critHeal or 0
				
				if spell and type(spell) == "string" then
					RecordsDB[sourceName].absorb[spell] = RecordsDB[sourceName].absorb[spell] or {}
					
					if crit == 1 then
						local record = RecordsDB[sourceName].absorb[spell]["crit"] or 0
						
						if record < amount then
							RecordsDB[sourceName].absorb[spell]["crit"] = amount
							RecordsDB[sourceName].absorb[spell]["critTarget"] = destName
							RecordsDB[sourceName].absorb[spell]["spellID"] = spellID
							RecordsDB[sourceName].absorb[spell]["critZone"] = GetRealZoneText()

							--print(("%s hit a new %s crit record %d!"):format(sourceName, spell, amount))
						end
					else
						local record = RecordsDB[sourceName].absorb[spell]["norm"] or 0
						
						if record < amount then
							RecordsDB[sourceName].absorb[spell]["norm"] = amount
							RecordsDB[sourceName].absorb[spell]["normTarget"] = destName
							RecordsDB[sourceName].absorb[spell]["spellID"] = spellID
							RecordsDB[sourceName].absorb[spell]["normZone"] = GetRealZoneText()

							--print(("%s hit a new %s normal record %d!"):format(sourceName, spell, amount))
						end
					end
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
		DEFAULT_CHAT_FRAME:AddMessage("Records: "..input)
	end
end
