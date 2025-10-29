local f = CreateFrame("Frame", "AddOnMessagesFrame", UIParent)

f.messages = {}
f.channel = "AddOnMessages"

function QueueAddOnMessage(msg)
	for _, existingMsg in ipairs(f.messages) do
		if existingMsg == msg then
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

		if ( chan == f.channel and IsInParty(name) ) then
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
			self.counter = (self.counter or 0) + 1
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
	self.timer2 = (self.timer2 or 0) + elapsed
	self.lastMessageTime = self.lastMessageTime or GetTime()

	if self.timer > 0.2 then
		if GetTime() - self.lastMessageTime > 5 and (self.counter or 0) < 3 then
			if #(self.messages) > 0 then
				SendAddOnMessage()
			end
		end

		self.timer = 0
	end

	if self.timer2 >= 5 then
		if (self.counter or 0) > 0 then
			self.counter = self.counter - 1
		end

		self.timer2 = 0
	end
end

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)
