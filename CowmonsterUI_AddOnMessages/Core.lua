local f = CreateFrame("Frame", "AddOnMessagesFrame", UIParent)

f.messages = {}
f.channel = "AddOnMessages"

local MESSAGE_DELAY = 5

local ErrorFilter = {
	"send message of this type until you reach level",
	"your target is dead",
	"there is nothing to attack",
	"not enough rage",
	"not enough energy",
	"that ability requires combo points",
	"not enough runic power",
	"not enough runes",
	"invalid target",
	"you have no target",
	"you cannot attack that target",
	"spell is not ready yet",
	"ability is not ready yet",
	"you can't do that yet",
	"you are too far away",
	"out of range",
	"another action is in progress",
	"not enough mana",
	"not enough focus"
}

--[[
local origAddMessage = UIErrorsFrame:AddMessage
function UIErrorsFrame:AddMessage(msg, r, g, b, a)
	for k, v in ipairs(ErrorFilter) do
		if string.find( string.lower(msg), v ) then
			return
		end
	end

	return origAddMessage(msg, r, g, b, a)
end
]]

local origErrorOnEvent = UIErrorsFrame:GetScript("OnEvent")
UIErrorsFrame:SetScript("OnEvent", function(self, event, ...)
	if AddOnMessagesFrame[event] then
		return AddOnMessagesFrame[event](self, event, ...)
	else
		return origErrorOnEvent(self, event, ...)
	end
end)

function AddOnMessagesFrame:UI_ERROR_MESSAGE(event, name, ...)
	for k, v in ipairs(ErrorFilter) do
		if( string.find( string.lower(name), v ) ) then
			return
		end
	end

	return origErrorOnEvent(self, event, name, ...)
end

local function GetPrefix(msg)
	local index = string.find(msg, ":")

	if index and index > 1 then
		return gsub(msg, 1, index - 1)
	else
		return nil
	end
end

function QueueAddOnMessage(msg)
	if UnitLevel("player") < 15 then return end

	for i, existingMsg in ipairs(f.messages) do
		if existingMsg == msg then return end
		if GetPrefix(existingMsg) == GetPrefix(msg) and GetPrefix(existingMsg) ~= nil then
			f.messages[i] = msg
			return
		end
	end

	table.insert(f.messages, msg)
end

local function SendAddOnMessage()
	if GetChannelName(f.channel) > 0 then
		SendChatMessage(f.messages[1], "CHANNEL", nil, GetChannelName(f.channel))
	end
end

local function OnEvent(self, event, ...)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		JoinChannelByName(self.channel)

		for i=1,NUM_CHAT_WINDOWS,1 do
			RemoveChatWindowChannel(i, self.channel)
		end
	elseif ( event == "CHAT_MSG_CHANNEL" ) then
		local msg, name, _, _, _, _, _, _, chan = ...		

		if ( chan == f.channel and CowmonsterUI.IsInParty(name) ) then
			local type, args = string.split(":", msg, 2)

			if name == UnitName("player") then
				for a,b in ipairs(self.messages) do
					if msg == b then
						table.remove(self.messages, a)
					end
				end
			end
		end
	end

	if event:sub(1, 9) == "CHAT_MSG_" then
		local name = select(2, ...)

		if name == UnitName("player") then
			self.lastMessageTime = GetTime()
			--self.counter = (self.counter or 0) + 1
		end
	end
end

f:RegisterEvent("CHAT_MSG_GUILD")
f:RegisterEvent("CHAT_MSG_PARTY")
f:RegisterEvent("CHAT_MSG_PARTY_LEADER")
f:RegisterEvent("CHAT_MSG_RAID")
f:RegisterEvent("CHAT_MSG_RAID_LEADER")
--f:RegisterEvent("CHAT_MSG_GUILD_OFFICER")
f:RegisterEvent("CHAT_MSG_YELL")
f:RegisterEvent("CHAT_MSG_SAY")
f:RegisterEvent("CHAT_MSG_CHANNEL")
f:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("RAID_ROSTER_UPDATE")
--f:RegisterEvent("PARTY_MEMBERS_CHANGED")

local function OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	--self.timer2 = (self.timer2 or 0) + elapsed
	self.lastMessageTime = self.lastMessageTime or GetTime()

	if self.timer > 0.2 then
		--if GetTime() - self.lastMessageTime > MESSAGE_DELAY and (self.counter or 0) < 3 then
		if GetTime() - self.lastMessageTime > MESSAGE_DELAY then
			if #(self.messages) > 0 then
				SendAddOnMessage()
			end
		end

		self.timer = 0
	end

	--[[
	if self.timer2 >= MESSAGE_DELAY then
		if (self.counter or 0) > 0 then
			self.counter = self.counter - 1
		end

		self.timer2 = 0
	end
	]]
end

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)
