local f = CreateFrame("Frame")

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local function OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, subevent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName = ...

		if subevent == "UNIT_DIED" and dstGUID == UnitGUID("player") then
			TakeScreenshot()
		end
	end
end

f:SetScript("OnEvent", OnEvent)
