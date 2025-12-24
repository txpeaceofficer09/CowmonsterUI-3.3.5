local FONT_SIZE = 12

local f = CreateFrame("Frame", "InfoBarBattlegroundList", InfoBarFrame)
f.columns = 9 -- name, rank, kb, hk, death, class, damage, healing, honor
f:SetFrameStrata("FULLSCREEN")
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

local BattlegroundDB = {}

function InfoBarBattleground_Refresh()
	local bar = _G["InfoBarBattlegroundListBar0"] or CowmonsterUI.CreateBar("InfoBarBattleground", 0, 0, 100)

	if bar then
		_G[("InfoBarBattlegroundListBar%sText1"):format(0)]:SetText("NAME")
		_G[("InfoBarBattlegroundListBar%sText2"):format(0)]:SetText("RANK")
		_G[("InfoBarBattlegroundListBar%sText3"):format(0)]:SetText("KB")
		_G[("InfoBarBattlegroundListBar%sText4"):format(0)]:SetText("HK")
		_G[("InfoBarBattlegroundListBar%sText5"):format(0)]:SetText("DEATH")
		_G[("InfoBarBattlegroundListBar%sText6"):format(0)]:SetText("CLASS")
		_G[("InfoBarBattlegroundListBar%sText7"):format(0)]:SetText("DAMAGE")
		_G[("InfoBarBattlegroundListBar%sText8"):format(0)]:SetText("HEALING")
		_G[("InfoBarBattlegroundListBar%sText9"):format(0)]:SetText("HONOR")
	end

	for i,data in pairs(BattlegroundDB) do
		local bar = _G[("InfoBarBattlegroundListBar%d"):format(i)] or CowmonsterUI.CreateBar("InfoBarBattleground", i, 0, 80)

		_G[("InfoBarBattlegroundListBar%sText1"):format(i)]:SetText(data.name)
		_G[("InfoBarBattlegroundListBar%sText2"):format(i)]:SetText(data.rank)
		_G[("InfoBarBattlegroundListBar%sText3"):format(i)]:SetText(data.killingBlows)
		_G[("InfoBarBattlegroundListBar%sText4"):format(i)]:SetText(data.honorKills)
		_G[("InfoBarBattlegroundListBar%sText5"):format(i)]:SetText(data.deaths)
		_G[("InfoBarBattlegroundListBar%sText6"):format(i)]:SetText(data.class)
		_G[("InfoBarBattlegroundListBar%sText7"):format(i)]:SetText(data.damageDone)
		_G[("InfoBarBattlegroundListBar%sText8"):format(i)]:SetText(data.healingDone)
		_G[("InfoBarBattlegroundListBar%sText9"):format(i)]:SetText(data.honorGained)

		bar:SetValue(100)

		if faction == 1 then
			bar:SetStatusBarColor(0, 0, 1, 1)
		else
			bar:SetStatusBarColor(1, 0, 0, 1)
		end
	end

	--[[
	for i=1,GetNumBattlefieldScores(),1 do
		local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i)

		local bar = _G[("InfoBarBattlegroundListBar%d"):format(i)] or CowmonsterUI.CreateBar("InfoBarBattleground", i, 0, 80)

		_G[("InfoBarBattlegroundListBar%sText1"):format(i)]:SetText(name)
		_G[("InfoBarBattlegroundListBar%sText2"):format(i)]:SetText(rank)
		_G[("InfoBarBattlegroundListBar%sText3"):format(i)]:SetText(killingBlows)
		_G[("InfoBarBattlegroundListBar%sText4"):format(i)]:SetText(honorKills)
		_G[("InfoBarBattlegroundListBar%sText5"):format(i)]:SetText(deaths)
		_G[("InfoBarBattlegroundListBar%sText6"):format(i)]:SetText(class)
		_G[("InfoBarBattlegroundListBar%sText7"):format(i)]:SetText(damageDone)
		_G[("InfoBarBattlegroundListBar%sText8"):format(i)]:SetText(healingDone)
		_G[("InfoBarBattlegroundListBar%sText9"):format(i)]:SetText(honorGained)
		
		bar:SetValue(100)

		if faction == 1 then
			bar:SetStatusBarColor(0, 0, 1, 1)
		else
			bar:SetStatusBarColor(1, 0, 0, 1)
		end

		bar:Show()
	end
	]]

	for i=GetNumBattlefieldScores()+1,InfoBarBattlegroundList.numRows,1 do
		_G[("InfoBarBattlegroundListBar%s"):format(i)]:Hide()
	end

	for i=1,InfoBarBattlegroundList.columns,1 do
		CowmonsterUI.ResizeColumn("InfoBarBattleground", i)
	end

	CowmonsterUI.ResizeList("InfoBarBattleground", #(BattlegroundDB)+1)
end

function InfoBarBattleground_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	if not IsInBattleground() then return end

	InfoBarBattleground_Refresh()
	InfoBarBattlegroundList:SetPoint("BOTTOMLEFT", InfoBarBattleground, "TOPLEFT", 0, 0)
	InfoBarBattlegroundList:Show()
end

function InfoBarBattleground_OnLeave(self)
	InfoBarBattlegroundList:Hide()
end

function InfoBarBattleground_OnClick(self, button)
	--PanelTemplates_SetTab(FriendsFrame, 3)
	-- Show the frame
	--ShowUIPanel(FriendsFrame)
end

function IsInBattleground()
	for i=1, MAX_BATTLEFIELD_QUEUES, 1 do
		local status = GetBattlefieldStatus(i)
		if status == "active" then
			return true
		end
	end

	return false
end

local function RequestData()
	if IsInBattleground() then
		f.lastRequest = GetTime()
		RequestBattlefieldScoreData()
	end
end

local function ProcessBG()
	BattlegroundDB = {}

	if IsInBattleground() then
		for i=1,GetNumBattlefieldScores(),1 do
			local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i)

			tinsert(BattlegroundDB, {
				name = name,
				killingBlows = killingBlows,
				honorKills = honorKills,
				deaths = deaths,
				honorGained = honorGained,
				faction = faction,
				rank = rank,
				race = race,
				class = class,
				filename = filename,
				damageDone = damageDone,
				healingDone = healingDone
			})

			if name == UnitName("player") then
				InfoBarSetText("InfoBarBattleground", "BG: %s / %s / %s", killingBlows, honorKills, deaths)
			end
		end
	end	
end

function InfoBarBattleground_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		--[[
		if IsInBattleground() then
			for i=1,GetNumBattlefieldScores(),1 do
				local name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, filename, damageDone, healingDone = GetBattlefieldScore(i)

				if name == UnitName("player") then
					InfoBarSetText("InfoBarBattleground", "BG: %s / %s / %s", killingBlows, honorKills, deaths)
					break
				end
			end
		else
			InfoBarSetText("InfoBarBattleground", "BG: |cffaaaaaa%s", "None")
		end
		]]

		if IsInBattleground() then
			--RequestBattlefieldScoreData()
			if GetTime()-(self.lastRequest or 0) >= 10 then
				RequestData()
			end
			for k,v in pairs(BattlegroundDB) do
				if v.name == UnitName("player") then
					InfoBarSetText("InfoBarBattleground", "BG: %s / %s / %s", v.killingBlows, v.honorKills, v.deaths)
					break
				end
			end
		else
			InfoBarSetText("InfoBarBattleground", "BG: |cffaaaaaa%s", "None")
		end

		self.timer = 0
	end
end

function InfoBarBattleground_OnEvent(self, event, ...)
	if event == "UPDATE_BATTLEFIELD_SCORE" then
		ProcessBG()
	elseif event == "PARTY_MEMBERS_CHANGE" or event == "RAID_ROSTER_UPDATE" then
		RequestData()
	elseif event == "PLAYER_ENTERING_WORLD" then
		--if IsInBattleground() then
			--RequestBattlefieldScoreData()
		--end
		RequestData()
	end
end
