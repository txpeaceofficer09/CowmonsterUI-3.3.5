--[[
dmg
dps
dmgtaken
heal
hps
healtaken
miss
hit
absorb
dodge
block
crush
interrupt
steal
ok - overkill
kb - killingblow
]]

--[[
local CombatMetersDB = {}
local CombatMetersDisplay = "dps"

local f = CreateFrame("Frame", "InfoBarDPSList", InfoBarFrame)
f.columns = 4
f:SetFrameStrata("FULLSCREEN")
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

local function CreateBar(index)
	local bar = CreateFrame("StatusBar", ("InfoBarDPSListBar%s"):format(index), InfoBarDPSList)

	InfoBarDPSList.numRows = index

	if index == 0 then
		bar:SetPoint("TOPLEFT", InfoBarDPSList, "TOPLEFT", 4, -4)
		bar:SetPoint("TOPRIGHT", InfoBarDPSList, "TOPRIGHT", -4, -4)
	else
		bar:SetPoint("TOPLEFT", _G["InfoBarDPSListBar"..(index-1)], "BOTTOMLEFT", 0, -2)
		bar:SetPoint("TOPRIGHT", _G["InfoBarDPSListBar"..(index-1)], "BOTTOMRIGHT", 0, -2)
	end

	bar:SetHeight(16)
	bar:SetMinMaxValues(0,70)
	bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	--bar:GetStatusBarTexture():SetHorizTile(false)
	bar:SetStatusBarColor(0, 1, 0)
	bar:SetValue(0)

	for i=1,InfoBarDPSList.columns,1 do
		--Add labels to the bar
		--ctl:SetFont("Fonts\\ARIALN.ttf", FontSize, "OUTLINE")
		--local t = bar:CreateFontString(("InfoBarDPSListBar%sText%s"):format(index, i), "OVERLAY", "NumberFont_Outline_Med")
		local t = bar:CreateFontString(("InfoBarDPSListBar%sText%s"):format(index, i), "OVERLAY")
		t:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
		if i == 1 then
			t:SetPoint("LEFT", bar, "LEFT", 2, 0)
		else
			t:SetPoint("LEFT", _G[("InfoBarDPSListBar%sText%s"):format(index, (i-1))], "RIGHT", 0, 0)
		end

		t:SetJustifyH("LEFT")
	end

	return bar
end

local function ResizeColumn(index)
	local max = 0

	for i=0,onlineGuildMembers,1 do
		--local bar = _G[("InfoBarDPSListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarDPSListBar%sText%s"):format(i, index)]

		--if label == nil then ChatFrame:AddMessage(("InfoBarDPSListBar%sText%s not found."):format(i, index)) end

		if label:GetStringWidth() > max then max = label:GetStringWidth() end
		--label:SetWidth(label:GetStringWidth()+30)
	end

	for i=0,onlineGuildMembers,1 do
		--local bar = _G[("InfoBarDPSListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarDPSListBar%sText%s"):format(i, index)]
		
		label:SetWidth(max+30)
	end
end

local function ResizeList()
	local width = 0
	InfoBarDPSList:SetHeight((onlineGuildMembers*18)+18)

	for i=1,InfoBarDPSList.columns,1 do
		width = width + _G[("InfoBarDPSListBar1Text%s"):format(i)]:GetWidth() + 2
	end

	InfoBarDPSList:SetWidth(width)
end
]]

--[[
function InfoBarDPS_Refresh()
	sort(CombatMetersDB, function(a,b) return a[CombatMetersDisplay]<b[CombatMetersDisplay] end)
	local index = 1

	_G[("InfoBarDPSListBar%sText1"):format(0)]:SetText("NAME")
	_G[("InfoBarDPSListBar%sText2"):format(0)]:SetText("RANK")
	_G[("InfoBarDPSListBar%sText3"):format(0)]:SetText("LVL")
	_G[("InfoBarDPSListBar%sText4"):format(0)]:SetText("CLASS")
	--_G[("InfoBarDPSListBar%sText5"):format(0)]:SetText("ZONE")
	--_G[("InfoBarDPSListBar%sText6"):format(0)]:SetText("PUBLIC NOTE")
	--_G[("InfoBarDPSListBar%sText7"):format(0)]:SetText("OFFICER NOTE")

	for k,v in ipairs(CombatMetersDB) do
		if index == 1 then top = v[CombatMetersDisplay] end
		local bar = _G[("InfoBarDPSListBar%s"):format(index)] or CreateBar(index)

		_G[("InfoBarDPSListBar%sText1"):format(index)]:SetText(index)
		_G[("InfoBarDPSListBar%sText2"):format(index)]:SetText(v.name)
		_G[("InfoBarDPSListBar%sText3"):format(index)]:SetText(v[CombatMetersDisplay])
		_G[("InfoBarDPSListBar%sText4"):format(index)]:SetText((v[CombatMetersDisplay]/top)*100)
		--_G[("InfoBarDPSListBar%sText5"):format(index)]:SetText(v.zone)
		--_G[("InfoBarDPSListBar%sText6"):format(index)]:SetText(v.note)
		--_G[("InfoBarDPSListBar%sText7"):format(index)]:SetText(v.officernote)

		if k == UnitGUID("player") then
			InfoBarSetText("infoBarDPS", ("%s. %s - %s (%s)"):format(index, UnitName("player"), CombatMetersDB[CombatMetersDisplay], "%"))
		end

		index = index + 1

		bar:SetValue(v.level)

		if RAID_CLASS_COLORS[strupper(v.class)] then
			bar:SetStatusBarColor(RAID_CLASS_COLORS[strupper(v.class)].r, RAID_CLASS_COLORS[strupper(v.class)].g, RAID_CLASS_COLORS[strupper(v.class)].b, 1)
		end

		bar:Show()
	end

	for i=index,InfoBarDPSList.numRows,1 do
		_G[("InfoBarDPSListBar%s"):format(i)]:Hide()
	end

	for i=1,InfoBarDPSList.columns,1 do
		ResizeColumn(i)
	end

	ResizeList()
end
]]

--CreateBar(0)

--function InfoBarDPS_OnEnter(self)
--	if UnitAffectingCombat("player") then return end

	--InfoBarTooltip:ClearLines()
	--InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	--local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");

	--InfoBarTooltip:AddLine(("<%s>"):format(guildName))
	--InfoBarTooltip:AddLine(" ")

	--sort(GuildMembersDB, function(a,b) return a.rankIndex<b.rankIndex end)

	--[[
	for k,v in pairs(GuildMembersDB) do
		if v.online then
			--InfoBarTooltip:AddDoubleLine(("|cff%02x%02x%02x%s|r %s (%s) [%s]"):format(RAID_CLASS_COLORS[strupper(v.class)].r*255, RAID_CLASS_COLORS[strupper(v.class)].g*255, RAID_CLASS_COLORS[strupper(v.class)].b*255, v.name, v.level, v.rank, v.zone), ("|cffffffff%s|r"):format(v.note))
			--InfoBarTooltip:AddDoubleLine(("%s (%s:%s) [%s]"):format(v.name, v.rank, v.level, v.class), v.note)
		end
	end

        InfoBarTooltip:Show()
	]]
--	InfoBarDPS_Refresh()
--	InfoBarDPSList:SetPoint("BOTTOMRIGHT", InfoBarDPS, "TOPRIGHT", 0, 0)
--	InfoBarDPSList:Show()
--end

--[[
function InfoBarDPS_OnLeave(self)
	--InfoBarTooltip:Hide()
	--InfoBarTooltip:ClearLines()
	InfoBarDPSList:Hide()
end
]]

function InfoBarDPS_OnClick(self, button)
	self.sticky = self.sticky or 0
	if self.sticky == 0 then
		self.sticky = 1
	else
		self.sticky = 0
	end
	--[[
	LoadAddOn("Blizzard_GuildUI")
	if GuildFrame:IsShown() then
		HideUIPanel(GuildFrame)
	else
		ShowUIPanel(GuildFrame)
	end
	]]
	--PanelTemplates_SetTab(FriendsFrame, 3)
	-- Show the frame
	--ShowUIPanel(FriendsFrame)
end

--[[
function InfoBarDPS_AddData(sourceGUID, sourceName, sourceClass, type, amount)
	if srcGUID == nil or srcName == nil or srcClass == nil or type == nil then return end

	local db = CombatMeters[srcGUID] or { ["name"] = sourceName, ["class"] = sourceClass, ["startTime"] = GetTime(), ["endTime"] = GetTime(), ["dmg"] = 0, ["hit"] = 0, ["miss"] = 0, ["heal"] = 0, ["dispells"] = 0, ["interrupts"] = 0, ["taunts"] = 0, ["dmg_taken"] = 0, ["steals"] = 0 }

	if type and type ~= "heal" and type ~= "miss" and type ~= "dispells" and type ~= "interrupts" and type ~= "taunts" and type ~= "steals" then db.hit = db.hit + 1 end
	if type then db[type] = (db[type] or 0) + amount end

	db.endTime = GetTime()

	db.dps = db.dmg / (db.endTime - db.startTime)
	db.hps = db.heal / (db.endTime - db.startTime)

	if db ~= nil then CombatMeters[srcGUID] = db end
end
]]

function InfoBarDPS_OnEnter(self)
	self.sticky = self.sticky or 1

	if self.sticky == 0 then
		Recount_MainWindow:SetFrameStrata("FULLSCREEN")
		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 0)
	end
	Recount_MainWindow:Show()
end

function InfoBarDPS_OnLeave(self)
	self.sticky = self.sticky or 1
	if self.sticky == 0 then
		Recount_MainWindow:Hide()
	end
end

function InfoBarDPS_OnEvent(self, event, ...)
	--InfoBarSetText("InfoBarDPS", "DPS: %s", RecountPerCharDB.combatants[UnitName("player")].Fights.CurrentFightData.Damage / RecountPerCharDB.combatants[UnitName("player")].Fights.CurrentFightData.TimeDamage)
	--InfoBarSetText("InfoBarDPS", "DPS: %.0f", RecountPerCharDB.combatants[UnitName("player")].Fights.Fight1.Damage / RecountPerCharDB.combatants[UnitName("player")].Fights.Fight1.TimeDamage)

	if RecountPerCharDB.Combatants == nil then
		InfoBarSetText("InfoBarDPS", "DPS: No Data")
		return false
	end

	if UnitAffectingCombat("player") then
		local data = RecountPerCharDB.Combatants[UnitName("player")].Fights.CurrentFightData or RecountPerCharDB.Combatants[UnitName("player")].Fights.Fight1
	else
		local data = RecountPerCharDB.Combatants[UnitName("player")].Fights.Fight1
	end

	InfoBarSetText("InfoBarDPS", "DPS: %.0f", data.Damage / data.TimeDamage)

	--InfoBarSetText("InfoBarDPS", "Recount")

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local filterSettings, timestamp, subEvent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = ...
	end
end


function InfoBarDPS_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 0.2 then
		--Refresh the bars frame if :IsShown()
		--Refresh the label text with the type of data, the rank, the amount and the percentage of #1 spot
		if UnitAffectingCombat("player") then
			local tmpTbl = {}			

			for k,v in pairs(RecountPerCharDB.combatants) do
				if v.Fights.CurrentFightData ~= nil then
					local dmg = v.Fights.CurrentFightData.Damage or 0
					local secs = v.Fights.CurrentFightData.TimeDamage or 1

					tinsert(tmpTbl, {["name"]=k, ["dmg"]=dmg, ["secs"]=secs})
				end
			end

			sort(tmpTbl, function(a,b)
				return a.dmg>b.dmg
			end)

			local i = 0

			for k,v in ipairs(tmpTbl) do
				i = i + 1
				if v.name == UnitName("player") then
					InfoBarSetText("InfoBarDPS", "DPS %s. %.0f", i, v.dmg / v.secs)
				end
			end

			--InfoBarSetText("InfoBarDPS", "DPS: %.0f", RecountPerCharDB.combatants[UnitName("player")].Fights.CurrentFightData.Damage / RecountPerCharDB.combatants[UnitName("player")].Fights.CurrentFightData.TimeDamage)
		else
			local tmpTbl = {}			

			for k,v in pairs(RecountPerCharDB.combatants) do
				if v.Fights.Fight1 ~= nil then
					local dmg = v.Fights.Fight1.Damage or 0
					local secs = v.Fights.Fight1.TimeDamage or 1

					tinsert(tmpTbl, {["name"]=k, ["dmg"]=dmg, ["secs"]=secs})
				end
			end

			sort(tmpTbl, function(a,b)
				return a.dmg>b.dmg
			end)

			local i = 0

			for k,v in ipairs(tmpTbl) do
				i = i + 1
				if v.name == UnitName("player") then
					InfoBarSetText("InfoBarDPS", "DPS %s. %.0f", i, v.dmg / v.secs)
				end
			end

			--InfoBarSetText("InfoBarDPS", "DPS: %.0f", RecountPerCharDB.combatants[UnitName("player")].Fights.Fight1.Damage / RecountPerCharDB.combatants[UnitName("player")].Fights.Fight1.TimeDamage)
		end
		self.timer = 0
	end
end
