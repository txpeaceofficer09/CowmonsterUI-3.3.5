local GuildMembersDB = {}
local onlineGuildMembers = 0

local f = CreateFrame("Frame", "InfoBarGuildList", InfoBarFrame)
f.columns = 8 -- name, race, class, rank, level, zone, note, officer note
--f:SetFrameLevel(99)
f:SetFrameStrata("FULLSCREEN")
f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

local function CreateBar(index)
	local bar = CreateFrame("StatusBar", ("InfoBarGuildListBar%s"):format(index), InfoBarGuildList)

	InfoBarGuildList.numRows = index

	if index == 0 then
		bar:SetPoint("TOPLEFT", InfoBarGuildList, "TOPLEFT", 4, -4)
		bar:SetPoint("TOPRIGHT", InfoBarGuildList, "TOPRIGHT", -4, -4)
	else
		bar:SetPoint("TOPLEFT", _G["InfoBarGuildListBar"..(index-1)], "BOTTOMLEFT", 0, -2)
		bar:SetPoint("TOPRIGHT", _G["InfoBarGuildListBar"..(index-1)], "BOTTOMRIGHT", 0, -2)
	end

	bar:SetHeight(16)
	bar:SetMinMaxValues(0,70)
	bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	--bar:GetStatusBarTexture():SetHorizTile(false)
	bar:SetStatusBarColor(0, 1, 0)
	bar:SetValue(0)

	for i=1,InfoBarGuildList.columns,1 do
		--Add labels to the bar
		--ctl:SetFont("Fonts\\ARIALN.ttf", FontSize, "OUTLINE")
		--local t = bar:CreateFontString(("InfoBarGuildListBar%sText%s"):format(index, i), "OVERLAY", "NumberFont_Outline_Med")
		local t = bar:CreateFontString(("InfoBarGuildListBar%sText%s"):format(index, i), "OVERLAY")
		t:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
		if i == 1 then
			t:SetPoint("LEFT", bar, "LEFT", 2, 0)
		else
			t:SetPoint("LEFT", _G[("InfoBarGuildListBar%sText%s"):format(index, (i-1))], "RIGHT", 0, 0)
		end

		t:SetJustifyH("LEFT")
	end

	return bar
end

local function ResizeColumn(index)
	local max = 0

	for i=0,onlineGuildMembers,1 do
		--local bar = _G[("InfoBarGuildListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarGuildListBar%sText%s"):format(i, index)]

		--if label == nil then ChatFrame:AddMessage(("InfoBarGuildListBar%sText%s not found."):format(i, index)) end

		if label:GetStringWidth() > max then max = label:GetStringWidth() end
		--label:SetWidth(label:GetStringWidth()+30)
	end

	for i=0,onlineGuildMembers,1 do
		--local bar = _G[("InfoBarGuildListBar%s"):format(i)] or CreateBar(i)
		local label = _G[("InfoBarGuildListBar%sText%s"):format(i, index)]
		
		label:SetWidth(max+30)
	end
end

local function ResizeList()
	local width = 0
	InfoBarGuildList:SetHeight((onlineGuildMembers*18)+18)

	for i=1,InfoBarGuildList.columns,1 do
		width = width + _G[("InfoBarGuildListBar1Text%s"):format(i)]:GetWidth() + 2
	end

	InfoBarGuildList:SetWidth(width)
end

function InfoBarGuild_Refresh()
	sort(GuildMembersDB, function(a,b) return a.rankIndex<b.rankIndex end)
	local index = 1

	_G[("InfoBarGuildListBar%sText1"):format(0)]:SetText("NAME")
	_G[("InfoBarGuildListBar%sText2"):format(0)]:SetText("RANK")
	_G[("InfoBarGuildListBar%sText3"):format(0)]:SetText("LVL")
	_G[("InfoBarGuildListBar%sText4"):format(0)]:SetText("CLASS")
	_G[("InfoBarGuildListBar%sText5"):format(0)]:SetText("ZONE")
	_G[("InfoBarGuildListBar%sText6"):format(0)]:SetText("PUBLIC NOTE")
	_G[("InfoBarGuildListBar%sText7"):format(0)]:SetText("OFFICER NOTE")

	for k,v in ipairs(GuildMembersDB) do
		if v.online then
			local bar = _G[("InfoBarGuildListBar%s"):format(index)] or CreateBar(index)

			_G[("InfoBarGuildListBar%sText1"):format(index)]:SetText(v.name)
			_G[("InfoBarGuildListBar%sText2"):format(index)]:SetText(v.rank)
			_G[("InfoBarGuildListBar%sText3"):format(index)]:SetText(v.level)
			_G[("InfoBarGuildListBar%sText4"):format(index)]:SetText(v.class)
			_G[("InfoBarGuildListBar%sText5"):format(index)]:SetText(v.zone)
			_G[("InfoBarGuildListBar%sText6"):format(index)]:SetText(v.note)
			_G[("InfoBarGuildListBar%sText7"):format(index)]:SetText(v.officernote)

			index = index + 1

			bar:SetValue(v.level)

			if RAID_CLASS_COLORS[strupper(v.class)] then
				bar:SetStatusBarColor(RAID_CLASS_COLORS[strupper(v.class)].r, RAID_CLASS_COLORS[strupper(v.class)].g, RAID_CLASS_COLORS[strupper(v.class)].b, 1)
			end

			bar:Show()
		end
	end

	for i=index,InfoBarGuildList.numRows,1 do
		_G[("InfoBarGuildListBar%s"):format(i)]:Hide()
	end

	for i=1,InfoBarGuildList.columns,1 do
		ResizeColumn(i)
	end

	ResizeList()
end

CreateBar(0)

function InfoBarGuild_OnEnter(self)
	if UnitAffectingCombat("player") then return end

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
	InfoBarGuild_Refresh()
	InfoBarGuildList:SetPoint("BOTTOMRIGHT", InfoBarGuild, "TOPRIGHT", 0, 0)
	InfoBarGuildList:Show()
end

function InfoBarGuild_OnLeave(self)
	--InfoBarTooltip:Hide()
	--InfoBarTooltip:ClearLines()
	InfoBarGuildList:Hide()
end

function InfoBarGuild_OnClick(self, button)
	--[[
	LoadAddOn("Blizzard_GuildUI")
	if GuildFrame:IsShown() then
		HideUIPanel(GuildFrame)
	else
		ShowUIPanel(GuildFrame)
	end
	]]
	PanelTemplates_SetTab(FriendsFrame, 3)
	-- Show the frame
	ShowUIPanel(FriendsFrame)
end

function InfoBarGuild_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if elapsed >= 1 then
		local numTotalGuildMembers, numOnlineGuildMembers, numOnlineAndMobileMembers = GetNumGuildMembers()

		InfoBarSetText("InfoBarGuild", "Guild: %s / %s", numOnlineGuildMembers, numTotalGuildMembers)
	end
end

local function RemoveGuildMember(name)
	for k,v in ipairs(GuildMembersDB) do
		if v.name == name then
			tremove(GuildMembersDB, k)
			break
		end
	end
end

local function AddGuildMember(name, rank, rankIndex, level, class, zone, note, officernote, online)
	tinsert(GuildMembersDB, {["name"] = name, ["rank"] = rank, ["rankIndex"] = rankIndex, ["level"] = level, ["class"] = class, ["zone"] = zone, ["note"] = note, ["officernote"] = officernote, ["online"] = online})
end

local function GuildMemberOffline(name)
	for k,v in ipairs(GuildMembersDB) do
		if v.name == name then
			GuildMembers[k].online = false
			onlineGuildMembers = onlineGuildMembers - 1
			break
		end
	end
end

local function GuildMemberOnline(name)
	for k,v in ipairs(GuildMembersDB) do
		if v.name == name then
			GuildMembersDB[k].online = 1
			onlineGuildMembers = onlineGuildMembers + 1
			break
		end
	end
end

function InfoBarGuild_OnEvent(self, event, ...)
	if event == "GUILD_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" or event == "GUILD_EVENT_GUILD_ROSTER_CHANGED" then
		SetGuildRosterShowOffline(1)

		local numGuildMembers = GetNumGuildMembers()
		onlineGuildMembers = 0

		GuildMembersDB = {}

		for i=1,numGuildMembers,1 do
			local name, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(i);

			if online then onlineGuildMembers = onlineGuildMembers + 1 end

			tinsert(GuildMembersDB, {["name"] = name, ["rank"] = rank, ["rankIndex"] = rankIndex, ["level"] = level, ["class"] = class, ["zone"] = zone, ["note"] = note, ["officernote"] = officernote, ["online"] = online})
		end

		InfoBarSetText("InfoBarGuild", "Guild: %s / %s", onlineGuildMembers, numGuildMembers)

		--SetGuildRosterShowOffline(SHOW_OFFLINE_GUILD_MEMBERS)
	elseif event == "CHAT_MSG_GUILD" then
		--[[
		local playerName, status = select(1, ...):match("%[(.+)%] has (joined|left) the guild")

		if status ~= nil then
			if status == "joined" then
				AddGuildMember
			else

			end
		end
		]]
	elseif event == "CHAT_MSG_SYSTEM" then
		local playerName, status = select(1, ...):match("%[(.+)%] has (come online|gone offline)")

		if status ~= nil then
			if status == "come online" then
				GuildMemberOnline(playerName)
				--GuildMembersDB[playerName].online = 1
			else
				GuildMemberOffline(playerName)
				--GuildMembersDB[playerName].online = false
			end
		end
	end
end

