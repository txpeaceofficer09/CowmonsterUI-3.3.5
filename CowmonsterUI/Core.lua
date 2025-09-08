playerName = UnitName("player")
playerRealm = GetRealmName()

CowmonsterUIDB = {
	[playerRealm] = {
		[playerName] = {
		},
	},
}

local f = CreateFrame("Frame", "CowmonsterUI", UIParent)

local function OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		UIParent:SetScale(0.712)
		--UIParent:SetScale(1)
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()

		ActionBarUpButton:Hide()
		ActionBarDownButton:Hide()

		--MainMenuBarPerformanceBarFrame:Hide()
		--MainMenuBarTexture0:Hide()
		--MainMenuBarTexture1:Hide()
		--MainMenuBarTexture2:Hide()
		--MainMenuBarTexture3:Hide()
		for i=0,3,1 do
			_G["MainMenuBarTexture"..i]:Hide()
		end
		MainMenuBarPageNumber:Hide()
		SlidingActionBarTexture0:Hide()
		SlidingActionBarTexture1:Hide()

		--BuffFrame:Hide()
	elseif event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
		local currentName = GetWatchedFactionInfo()
		local msg = select(1, ...)
		local newFaction, amount = string.match(msg, "Reputation with (.+) increased by (%d+).")

		if newFaction and newFaction ~= currentName then
			--ExpandAllFactionHeaders()

			for i = 1, GetNumFactions(), 1 do
				local name = GetFactionInfo(i)

				if name == newFaction then
					SetWatchedFactionIndex(i)
				end

				if name == "Inactive" then
					CollapseFactionHeader(i)
					break
				end
			end
		end
	elseif event == "VARIABLES_LOADED" then
		if type(CowmonsterUIDB) == "table" then
			if type(CowmonsterUIDB[playerRealm]) ~= "table" then
				CowmonsterUIDB[playerRealm] = { [playerName] = { ["Settings"] = {} } }
			else
				if type(CowmonsterUIDB[playerRealm][playerName]) ~= "table" then
					CowmonsterUIDB[playerRealm][playerName] = { ["Settings"] = {} }
				end
			end
		else
			CowmonsterUIDB = { [playerRealm] = { [playerName] = { ["Settings"] = {} } } }
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		self.inCombat = 0
	elseif event == "PLAYER_REGEN_DISABLED" then
		self.inCombat = 1
	end
end

f:SetScript("OnEvent", OnEvent)

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("VARIABLES_LOADED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")

f: SetScript("OnUpdate", CombatLogClearEntries)
