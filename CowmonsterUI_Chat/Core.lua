local chatColors = {
	["CHAT_MSG_MONSTER_SAY"] = {
		["r"] = 0.5,
		["g"] = 0.5,
		["b"] = 0.5,
		["a"] = 1,
	},
	["CHAT_MSG_MONSTER_WHISPER"] = {
		["r"] = 1,
		["g"] = 0.8,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_AFK"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_DND"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_ADDON"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_CHANNEL"] = {
		["r"] = 0.992157,
		["g"] = 0.752941,
		["b"] = 0.752941,
		["a"] = 1,
	},
	["CHAT_MSG_CHANNEL_JOIN"] = {
		["r"] = 0.992157,
		["g"] = 0.752941,
		["b"] = 0.752941,
		["a"] = 1,
	},
	["CHAT_MSG_CHANNEL_LEAVE"] = {
		["r"] = 0.992157,
		["g"] = 0.752941,
		["b"] = 0.752941,
		["a"] = 1,
	},
	["CHAT_MSG_EMOTE"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_TEXT_EMOTE"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_GUILD"] = {
		["r"] = 0.235294,
		["g"] = 0.886275,
		["b"] = 0.247059,
		["a"] = 1,
	},
	["CHAT_MSG_GUILD_ACHIEVEMENT"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_OFFICER"] = {
		["r"] = 0.250980,
		["g"] = 0.737255,
		["b"] = 0.250980,
		["a"] = 1,
	},
	["CHAT_MSG_MONSTER_SAY"] = {
		["r"] = 1,
		["g"] = 0.6,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_MONSTER_WHISPER"] = {
		["r"] = 1,
		["g"] = 0,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_PARTY"] = {
		["r"] = 0.666667,
		["g"] = 0.670588,
		["b"] = 1,
		["a"] = 1,
	},
	["CHAT_MSG_PARTY_LEADER"] = {
		["r"] = 0.4,
		["g"] = 0.4,
		["b"] = 0.8,
		["a"] = 1,
	},
	["CHAT_MSG_RAID"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0.039216,
		["a"] = 1,
	},
	["CHAT_MSG_RAID_LEADER"] = {
		["r"] = 1,
		["g"] = 0.282353,
		["b"] = 0.035294,
		["a"] = 1,
	},
	["CHAT_MSG_SAY"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 1,
		["a"] = 1,
	},
	["CHAT_MSG_WHISPER"] = {
		["r"] = 1,
		["g"] = 0.4,
		["b"] = 0.7,
		["a"] = 1,
	},
	["CHAT_MSG_WHISPER_INFORM"] = {
		["r"] = 0.8,
		["g"] = 0.2,
		["b"] = 0.5,
		["a"] = 1,
	},
	["CHAT_MSG_YELL"] = {
		["r"] = 1,
		["g"] = 0,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_BATTLEGROUND"] = {
		["r"] = 1,
		["g"] = 0.5,
		["b"] = 0,
		["a"] = 1,
	},
	["CHAT_MSG_BATTLEGROUND_LEADER"] = {
		["r"] = 1,
		["g"] = 0.862745,
		["b"] = 0.717647,
		["a"] = 1,
	},
	["CHAT_MSG_SYSTEM"] = {
		["r"] = 1,
		["g"] = 1,
		["b"] = 0,
		["a"] = 1,
	},
}

local ToastEvents = {
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	--"CHAT_MSG_BATTLEGROUND",
	--"CHAT_MSG_BATTLEGROUND_LEADER",
}

--[[
local ChatEvents = {
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_BATTLEGROUND",
	"CHAT_MSG_BATTLEGROUND_LEADER",
	"CHAT_MSG_SYSTEM",
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_CHANNEL",
	--"CHAT_MSG_CHANNEL_JOIN",
	--"CHAT_MSG_CHANNEL_LEAVE",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_TEXT_EMOTE",
	"CHAT_MSG_MONSTER_SAY",
	"CHAT_MSG_MONSTER_WHISPER",
	"CHAT_MSG_MONSTER_YELL",
	--"CHAT_MSG_COMBAT_SELF_HITS",
	--"CHAT_MSG_COMBAT_PARTY_HITS",
	--"CHAT_MSG_COMBAT_FRIENDLY_HITS",
	--"CHAT_MSG_COMBAT_HOSTILE_HITS",
	--"CHAT_MSG_COMBAT_SELF_MISSES",
	--"CHAT_MSG_COMBAT_PARTY_MISSES",
	--"CHAT_MSG_COMBAT_FRIENDLY_MISSES",
	--"CHAT_MSG_COMBAT_HOSTILE_MISSES",
}
]]

local OriginalDefaultChatFrameAddMessage = DEFAULT_CHAT_FRAME.AddMessage

function DEFAULT_CHAT_FRAME:AddMessage(message, r, g, b, messageID, ...)
	local currentTime = date("%H:%M:%S")
	local modifiedMessage = string.format("[%s] %s", currentTime, message)
	return OriginalDefaultChatFrameAddMessage(self, modifiedMessage, r, g, b, messageID, ...)
end

SteakChatPlayerData = {}

--[[
local function PrependTimestamp(self, event, message, sender, ...)
	local timestamp = date("%H:%M:%S")
	return false, string.format("[%s] %s", timestamp, message), sender, ...
end
]]

local function GetNumGroupMembers()
	if GetNumRaidMembers() > 0 then
		return GetNumRaidMembers()
	elseif GetNumPartyMembers() > 0 then
		return GetNumPartyMembers()
	else
		return 0
	end
end

local function AddPlayerData(name, rank, level, class, note)
	--if not SteakChatPlayerData[name] then SteakChatPlayerData[name] = {} end
	SteakChatPlayerData[name] = SteakChatPlayerData[name] or {}

	if name ~= nil then SteakChatPlayerData[name].name = name end
	if level ~= nil then SteakChatPlayerData[name].level = level end
	if class ~= nil then SteakChatPlayerData[name].class = strupper(class) end
	if rank ~= nil then SteakChatPlayerData[name].rank = rank end
	if note ~= nil then SteakChatPlayerData[name].note = note end
end

function PrintPlayerData()
	for a,b in pairs(SteakChatPlayerData) do
		print(b.name, b.level, b.class, b.rank, b.note)
	end
end

local function BetterDate(timestamp)
	local timestamp = time()
	--timestamp = tonumber(timestamp)
	local year = math.floor(timestamp / 31556926) + 1970
	local month = math.floor((timestamp % 31556926) / 2629743) + 1
	local day = math.floor((timestamp % 2629743) / 86400) + 1
	local hour = math.floor((timestamp % 86400) / 3600)
	local minute = math.floor((timestamp % 3600) / 60)
	local second = timestamp % 60

	return ("%02d:%02d:%02d"):format(hour, minute, second)
end

local function IsInCity()
	if select(2, EnumerateServerChannels()) == "Trade" then
		return true
	else
		return false
	end
end

function GetGuildInfoByName(memberName)
	for i=1,GetNumGuildMembers(),1 do
		local name, rank, rankIndex, level, class, _, note = GetGuildRosterInfo(i)

		if name == memberName then
			return name, rank, rankIndex, level, class, note
		end
	end
	return false
end

function GetPublicNote(charName)
	if not IsInGuild() then return end

	local tmp = GetGuildRosterShowOffline()
	SetGuildRosterShowOffline(false)

	for i=1,GetNumGuildMembers(),1 do
		local name, _, _, _, _, _, note = GetGuildRosterInfo(i)

		if name == charName or charName == name:sub(1, -4) and note ~= "" then
			return note
		end
	end

	return false
end

local function GetPlayerLink(playerName, lineID)
	if strlen(playerName) == 0 then return end

	local link = ""
	local name, rank, _, level, class, note = GetGuildInfoByName(playerName)

	if name == playerName then
		--print(name, rank, level, class, note)
		AddPlayerData(playerName, rank, level, class, note or "")
		--[[
		if RAID_CLASS_COLORS[strupper(class)] then
			return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format((RAID_CLASS_COLORS[strupper(class)].r * 255), (RAID_CLASS_COLORS[strupper(class)].g * 255), (RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
		else
			return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format((1 * 255), (1 * 255), (1 * 255), playerName, lineID, playerName)
		end
		]]
		local r, g, b, a = CowmonsterUI.GetClassColor(class)
		return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format((r * 255), (g * 255), (b * 255), playerName, lineID, playerName)
	elseif GetNumGroupMembers() > 0 then
		for i=1,GetNumGroupMembers(),1 do
			if UnitExists("raid"..i) and UnitName("raid"..i) == playerName then
				class = select(2, UnitClass("raid"..i))
				level = UnitLevel("raid"..i)
				AddPlayerData(playerName, nil, level, class, nil)
				--return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
				local r, g, b, a = CowmonsterUI.GetClassColor(class)
				return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( r * 255), ( g * 255), ( b * 255), playerName, lineID, playerName)
			elseif UnitExists("party"..i) and UnitName("party"..i) == playerName then
				class = select(2, UnitClass("party"..i))
				level = UnitLevel("party"..i)
				AddPlayerData(playerName, nil, level, class, nil)
				--return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
				local r, g, b, a = CowmonsterUI.GetClassColor(class)
				return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( r * 255), ( g * 255), ( b * 255), playerName, lineID, playerName)
			end
		end
	elseif SteakChatPlayerData[playerName] ~= nil then
		class = SteakChatPlayerData[playerName].class
		level = SteakChatPlayerData[playerName].level
		--return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( RAID_CLASS_COLORS[strupper(class)].r * 255), ( RAID_CLASS_COLORS[strupper(class)].g * 255), ( RAID_CLASS_COLORS[strupper(class)].b * 255), playerName, lineID, playerName)
		local r, g, b, a = CowmonsterUI.GetClassColor(class)
		return ("|cff%02x%02x%02x|Hplayer:%s:%s|h%s|h|r"):format(( r * 255), ( g * 255), ( b * 255), playerName, lineID, playerName)
	else
		return ("|Hplayer:%s:%s|h%s|h|r"):format(playerName, lineID, playerName)
	end
end

local f = CreateFrame("Frame")

--[[
for _,event in ipairs(ChatEvents) do
	print("Registered "..event)
	f:RegisterEvent(event)
end
]]

local FontSize = 16

local expandedHeight = 600
local collapsedHeight = 150

ChatFrameMenuButton:SetScript("OnShow", function(self) self:Hide() end)

f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		for i=1, NUM_CHAT_WINDOWS do
			local cf = _G["ChatFrame"..i]

			if cf then
				--cf:HookScript("OnNewMessage", PrependTimestamp)
			end
		end
	end

	if event == "PLAYER_ENTERING_WORLD" then
		ChatFrameMenuButton:Hide()
	end

	if event == "UPDATE_CHAT_WINDOWS" or event == "PLAYER_ENTERING_WORLD" then
		--self.MainMenuBarNeedsMove = 1

		--SetCVar("colorChatNamesByClass", 1, true)

		for i=1,NUM_CHAT_WINDOWS,1 do
			local cf = _G["ChatFrame"..i]
			local tab = _G["ChatFrame"..i.."Tab"]
			cf.defaultLanguage = GetDefaultLanguage()

			SetChatWindowAlpha(i, 0.8) -- Set the alpha of the chat window to 80%
			SetChatWindowColor(i, 0, 0, 0) -- Set the background color of the chat window to black

			cf:SetScript("OnEnter", function(self)
				cf.FrameStrata = cf:GetFrameStrata()
				cf:SetFrameStrata("HIGH")
				ChatFrame1.action = "grow"
			end)

			cf:SetScript("OnLeave", function(self)
				cf:SetFrameStrata(cf.FrameStrata)
				ChatFrame1.action = "shrink"
			end)

			cf:HookScript("OnHyperlinkEnter", function(self, link)
				ChatFrame1.action = "grow"
				self:SetFrameStrata("HIGH")

				local type = strmatch(link, "^(.-):")
				if(type == "item" or type == "enchant" or type == "spell" or type == "quest") then
					ShowUIPanel(GameTooltip)
					GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
					GameTooltip:SetHyperlink(link)
					GameTooltip:Show()
				end
			end)

			cf:HookScript("OnHyperlinkLeave", function(self, link)
				if link ~= nil then
					local type = strmatch(link, "^(.-):")
					if(type == "item" or type == "enchant" or type == "spell" or type == "quest") then
						HideUIPanel(GameTooltip)
					end
				end
			end)

			cf:SetScript("OnUpdate", function(self, elapsed)
				ChatFrame1.timer = (ChatFrame1.timer or 0) + elapsed

				if ChatFrame1.timer >= 0.01 then
					if ChatFrame1.action == "shrink" and ChatFrame1:GetHeight() > collapsedHeight then
						local newHeight = ChatFrame1:GetHeight() - 50

						if newHeight < collapsedHeight then
							ChatFrame1:SetHeight(collapsedHeight)
						else
							ChatFrame1:SetHeight(newHeight)
						end
					elseif ChatFrame1.action == "grow" and ChatFrame1:GetHeight() < expandedHeight then
						local newHeight = ChatFrame1:GetHeight() + 50

						if newHeight > expandedHeight then
							ChatFrame1:SetHeight(expandedHeight)
						else
							ChatFrame1:SetHeight(newHeight)
						end
					end

					if self:GetName() == "ChatFrame2" then
						self:ClearAllPoints()
						self:SetPoint("TOPLEFT", ChatFrame1, "TOPLEFT", 0, -24)
						self:SetPoint("TOPRIGHT", ChatFrame1, "TOPRIGHT", 0, -24)
						self:SetPoint("BOTTOMLEFT", ChatFrame1, "BOTTOMLEFT", 0, 0)
						self:SetPoint("BOTTOMRIGHT", ChatFrame1, "BOTTOMRIGHT", 0, 0)
					elseif self:GetName() == ChatFrame1:GetName() then
						self:ClearAllPoints()
						self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 27)
					elseif self:GetName() ~= ChatFrame1:GetName() then
						self:ClearAllPoints()
						self:SetAllPoints(ChatFrame1)
					end

					ChatFrame1.timer = 0
				end
			end)

			cf:EnableKeyboard(true)
			cf:EnableMouse(true)
			cf:EnableMouseWheel(true)
			cf:SetFading(false)

			--cf:ClearAllPoints()
			--cf:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 27)
		end
	end
end)

local function GetNumGuildMembersTotal()
        local i = 1

        while GetGuildRosterInfo(i) ~= nil do
                i = i + 1
        end

        return i - 1
end

local function AddGuildInfo(self, event, msg, ...)
	local charName = select(1, ...)

	local tmp = GetGuildRosterShowOffline()
	SetGuildRosterShowOffline(false)

	for i=1,GetNumGuildMembers(),1 do
		local name, rank, _, level, _, _, note, _, online = GetGuildRosterInfo(i)

		if name == charName or charName == name:sub(1, -4) then
			if note ~= "" then
				msg = ("[|cffffff00%s:%d|r](|cffffff00%s|r) %s"):format(rank, level, note, msg)
			else
				msg = ("[|cffffff00%s:%d|r] %s"):format(rank, level, msg)
			end
		end
	end

	SetGuildRosterShowOffline(tmp)

	return false, msg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ITEM_LOOTED", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", AddGuildInfo)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", AddGuildInfo)

local tf = CreateFrame("ScrollingMessageFrame", "ToastChatFrame", UIParent)
tf:SetPoint("CENTER", UIParent, "CENTER", 0, 250)
tf:EnableMouse(false)
tf:SetWidth(500)
tf:SetHeight(300)

tf:EnableKeyboard(false)
tf:EnableMouseWheel(false)
tf:SetFading(true)
tf:SetTimeVisible(10)
tf:SetFadeDuration(3)

tf:SetFont("Fonts\\ARIALN.TTF", FontSize+2, "OUTLINE")
tf:SetTextColor(1, 1, 1, 1)
tf:SetJustifyH("LEFT")
tf:SetMaxLines(64)

for _,event in ipairs(ToastEvents) do
	tf:RegisterEvent(event)
end

tf:SetScript("OnEvent", function(self, event, ...)
	local text, playerName, languageName, channelName, _, specialFlags, zoneChannelID, channelIndex, channelBaseName, languageID, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, suppressRaidIcons = ...

	local r, g, b, a = 1, 1, 0, 1

	if chatColors[event] ~= nil then
		r = chatColors[event].r
		g = chatColors[event].g
		b = chatColors[event].b
		a = chatColors[event].a
	end

	local term
	if type(text) == "string" then
		for tag in string.gmatch(text, "%b{}") do
			term = strlower(string.gsub(tag, "[{}]", ""))
			if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
				text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t")
			end
		end
	end

	local chanData = "["..date("%H:%M:%S").."]"

	if channelBaseName ~= nil and channelIndex ~= 0 then
		chanData = chanData.."["..channelIndex.." - "..channelBaseName.."]"
		if channelBaseName:sub(1,3) == "Crb" then return end
	end

	if playerName ~= nil and type(playerName) == "string" and strlen(playerName) > 0 then
		local name, rank, _, level, class, note = GetGuildInfoByName(playerName)

		playerName = GetPlayerLink(playerName, lineID) or playerName
		chanData = chanData.."["..playerName.."]"

		if name ~= false then
			chanData = ("%s[%s:%s]"):format(chanData, rank, level)
		elseif level ~= nil then
			chanData = ("%s[%s]"):format(chanData, level)
		end

		if note ~= "" and note ~= nil and note ~= false then
			chanData = chanData.."(|cffffffff"..note.."|r)"
		end

		if specialFlags ~= nil and strlen(specialFlags) > 0 then
			if specialFlags == "GM" then
				chanData = chanData.."|TInterface\\ChatFrame\\UI-ChatIcon-Blizz.blp:0:2:0:-3|t "
			else
				if getglobal("CHAT_FLAG_"..specialFlags) ~= nil then
					chanData = chanData..getglobal("CHAT_FLAG_"..specialFlags).." "
				end
			end
		end
	end

	if event == "UPDATE_CHAT_WINDOWS" or event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		--DEFAULT_CHAT_FRAME = ChatFrame

		for k,v in pairs(ChatTypeInfo) do
			ChatTypeInfo[k].colorNameByClass = true
		end

		ChatTabsFrame:SetWidth(UIParent:GetWidth()-MainMenuBar:GetWidth())

		ChatFrameEditBox:ClearAllPoints()
		ChatFrameEditBox:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -5, -5)
		ChatFrameEditBox:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 5, -5)

		ChatFrameEditBox:SetBackdrop(nil)
		ChatFrameEditBoxLeft:Hide()
		ChatFrameEditBoxRight:Hide()
		ChatFrameEditBox:Hide()

		for i=1, NUM_CHAT_WINDOWS, 1 do
			local n = _G["ChatFrame"..i]
			local t = _G["ChatFrame"..i.."Tab"]

			t:Hide()

			t:SetScript("OnShow", function(self) self:Hide() end)

			n:SetFont("Fonts\\ARIALN.TTF", FontSize+2, "OUTLINE")

			n:ClearAllPoints()
			n:SetClampedToScreen(false)
			n:SetPoint("RIGHT", UIParent, "LEFT", -500, 0)
		end
	elseif event == "UPDATE_CHAT_COLOR" then
		local arg1, arg2, arg3, arg4 = ...
		local info = ChatTypeInfo[strupper(arg1)]

		if ( info ) then
			info.r = arg2;
			info.g = arg3;
			info.b = arg4;
			self:UpdateColorByID(info.id, info.r, info.g, info.b);

			if ( strupper(arg1) == "WHISPER" ) then
				info = ChatTypeInfo["REPLY"];
				if ( info ) then
					info.r = arg2;
					info.g = arg3;
					info.b = arg4;
					self:UpdateColorByID(info.id, info.r, info.g, info.b);
				end
			end
		end
	elseif event == "UPDATE_CHAT_COLOR_NAME_BY_CLASS" then
		local arg1 = ...
		local info = ChatTypeInfo[strupper(arg1)]

		if ( info ) then
			info.colorNameByClass = true;
			if ( strupper(arg1) == "WHISPER" ) then
				info = ChatTypeInfo["REPLY"];
				if ( info ) then
					info.colorNameByClass = true;
				end
			end
		end
	elseif event == "UPDATE_INSTANCE_INFO" then

	elseif event == "CHAT_SERVER_DISCONNECTED" then

	elseif event == "CHAT_SERVER_RECONNECTED" then

	elseif event == "CHAT_MSG_LOOT" then
		self:AddMessage(text, r, g, b, a)
	elseif event == "CHAT_MSG_MONEY" then
		self:AddMessage(text, r, g, b, a)
	elseif event == "CHAT_MSG_TRADESKILL" then
		self:AddMessage(text, r, g, b, a)
	elseif event == "CHAT_MSG_SYSTEM" then
		if strfind(text, "Arena Queue: Team Joined") then
			--Add message to misc
		elseif strfind(text, "players total") then
			--Add message to who frame
		else
			--AddMessageAll(text, r, g, b, a)
			AddMessageActive(text, r, g, b, a)
		end
	elseif event == "CHAT_MSG_ACHIEVEMENT" then
		AddMessageActive(text:format(chanData), r, g, b, a)
	elseif event == "CHAT_MSG_GUILD_ACHIEVEMENT" then
		AddMessageActive(text:format(chanData), r, g, b, a)
	elseif event == "CHAT_MSG_EMOTE" then
		AddMessageActive(("%s: %s"):format(chanData, text), r, g, b, a)
	elseif event == "CHAT_MSG_TEXT_EMOTE" then
		AddMessageActive(text, r, g, b, a)
	elseif event == "WHO_LIST_UPDATE" then
		--[[
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		local total = GetNumWhoResults()

		if total > 0 then
			for i=1,total,1 do
				local name, guild, level, race, class, zone = GetWhoInfo(i)
				--if guild == "" or guild == nil then
					--GuildInvite(name)
					--GuildInvites[#(GuildInvites)] = name
				--end
				name = ("|cff%02x%02x%02x%s|r"):format((RAID_CLASS_COLORS[strupper(class)].r * 255), (RAID_CLASS_COLORS[strupper(class)].g * 255), (RAID_CLASS_COLORS[strupper(class)].b * 255), name)

				WhoChatFrame:AddMessage(("%s <%s> level %s %s %s in %s"):format(name, guild, level, race, class, zone), r, g, b, a)
			end
		end
		]]

		local total = GetNumWhoResults()

		--print(("%d who results"):format(total))

		if total > 0 then
			for i=1,total,1 do
				local name, guild, level, race, class, zone = GetWhoInfo(i)

				AddPlayerData(name, rank, level, class, nil)
			end
		end
	elseif event == "CHAT_MSG_WHISPER" then
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		self:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a)	
	elseif event == "CHAT_MSG_WHISPER_INFORM" then
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		self:AddMessage(("To %s: %s"):format(chanData, (text or "")), r, g, b, a)	

	elseif event == "UNIT_ENTERED_VEHICLE" then
		local unitTarget, showVehicleFrame, isControlSeat, vehicleUIIndicatorID, vehicleGUID, mayChooseExit, hasPitch = ...

		self:AddMessage(("%s %s"):format(event, unitTarget), r, g, b, a)
	elseif event == "PLAYER_GAINS_VEHICLE_DATA" then
		local unitTarget, vehicleUIIndicatorID = ...

		self:AddMessage(("%s %s"):format(unitTarget, vehicleUIIndicatorID), r, g, b, a)
	elseif event == "PLAYER_LOSES_VEHICLE_DATA" then
		local unitTarget = ...

		self:AddMessage(unitTarget, r, g, b, a)		
	elseif event == "UNIT_ENTERING_VEHICLE" then
		local unitTarget, showVehicleFrame, isControlSeat, vehicleUIIndicatorID, vehicleGUID, mayChooseExit, hasPitch = ...

		self:AddMessage(event.." "..unitTarget, r, g, b, a)
	elseif event == "UNIT_EXITED_VEHICLE" then
		local unitTarget = ...

		self:AddMessage(event.." "..unitTarget, r, g, b, a)
	elseif event == "UNIT_EXITING_VEHICLE" then
		local unitTarget = ...

		self:AddMessage(event.." "..unitTarget, r, g, b, a)
	elseif event == "VEHICLE_UPDATE" then
		self:AddMessage(event, r, g, b, a)
	elseif event == "CHAT_MSG_CHANNEL" then
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		self:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a)			

		--Send who if user is not already in the player list
		if SteakChatPlayerData[playerName] == nil then
			SendWho(playerName)
		end
	else
		if self:IsVisible() == nil then
			_G[self:GetName().."Tab"].alerting = 1
		end

		--[[
		if specialFlags ~= nil then
			msg = msg.."("..specialFlags..")"
		end
		]]

		self:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a)	
	end

	--[[
	for _,v in ipairs(ToastEvents) do
		if v == event then
			UIErrorsFrame:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a);
			ToastChatFrame:AddMessage(("%s: %s"):format(chanData, (text or "")), r, g, b, a);
		end
	end
	]]
end)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_CHAT_WINDOWS")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("CHAT_MSG_WHISPER")
f:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED")

--			"UPDATE_CHAT_COLOR",
--			"UPDATE_INSTANCE_INFO",
--			"UPDATE_CHAT_COLOR_NAME_BY_CLASS",
--			"CHAT_SERVER_DISCONNECTED",
--			"CHAT_SERVER_RECONNECTED",
