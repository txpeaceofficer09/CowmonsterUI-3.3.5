local FONT_SIZE = 12

local f = CreateFrame("Frame", "InfoBarGuildList", InfoBarFrame)
f.columns = 8 -- name, race, class, rank, level, zone, note, officer note
f:SetFrameStrata("FULLSCREEN")
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

function InfoBarGuild_Refresh()
	local numOnline, numTotal, index = 0, 0, 1
	local bar = _G["InfoBarGuildListBar0"] or CowmonsterUI.CreateBar("InfoBarGuild", 0, 0, 80)

	if bar then
		_G[("InfoBarGuildListBar%sText1"):format(0)]:SetText("NAME")
		_G[("InfoBarGuildListBar%sText2"):format(0)]:SetText("RANK")
		_G[("InfoBarGuildListBar%sText3"):format(0)]:SetText("LVL")
		_G[("InfoBarGuildListBar%sText4"):format(0)]:SetText("CLASS")
		_G[("InfoBarGuildListBar%sText5"):format(0)]:SetText("ZONE")
		_G[("InfoBarGuildListBar%sText6"):format(0)]:SetText("PUBLIC NOTE")
		_G[("InfoBarGuildListBar%sText7"):format(0)]:SetText("OFFICER NOTE")		
	end

	while GetGuildRosterInfo(index) ~= nil do
		local name, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(index)
		local bar = _G[("InfoBarGuildListBar%d"):format(index)] or CowmonsterUI.CreateBar("InfoBarGuild", index, 0, 80)

		_G[("InfoBarGuildListBar%sText1"):format(index)]:SetText(name)
		_G[("InfoBarGuildListBar%sText2"):format(index)]:SetText(rank)
		_G[("InfoBarGuildListBar%sText3"):format(index)]:SetText(level)
		_G[("InfoBarGuildListBar%sText4"):format(index)]:SetText(class)
		_G[("InfoBarGuildListBar%sText5"):format(index)]:SetText(zone)
		_G[("InfoBarGuildListBar%sText6"):format(index)]:SetText(note)
		_G[("InfoBarGuildListBar%sText7"):format(index)]:SetText(officernote)
		
		bar:SetValue(level)

		local r, g, b, a = CowmonsterUI.GetClassColor(class)
		bar:SetStatusBarColor(r, g, b, a)

		bar:Show()

		if online then numOnline = numOnline + 1 end
		numTotal = numTotal + 1

		index = index + 1
	end

	for i=index,InfoBarGuildList.numRows,1 do
		_G[("InfoBarGuildListBar%s"):format(i)]:Hide()
	end

	for i=1,InfoBarGuildList.columns,1 do
		CowmonsterUI.ResizeColumn("InfoBarGuild", i)
	end

	CowmonsterUI.ResizeList("InfoBarGuild", index)
end

function InfoBarGuild_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarGuild_Refresh()
	InfoBarGuildList:SetPoint("BOTTOMRIGHT", InfoBarGuild, "TOPRIGHT", 0, 0)
	InfoBarGuildList:Show()
end

function InfoBarGuild_OnLeave(self)
	InfoBarGuildList:Hide()
end

function InfoBarGuild_OnClick(self, button)
	PanelTemplates_SetTab(FriendsFrame, 3)
	-- Show the frame
	ShowUIPanel(FriendsFrame)
end

function InfoBarGuild_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if elapsed >= 1 then
		local numOnline, numTotal, index = 0, 0, 1

		while GetGuildRosterInfo(index) ~= nil do
			local name, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(index)

			if online then numOnline = numOnline + 1 end
			numTotal = numTotal + 1

			index = index + 1
		end

		InfoBarSetText("InfoBarGuild", "Guild: %s / %s", numOnline, numTotal)
	end
end
