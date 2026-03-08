function InfoBarLC_OnEvent(self, event, ...)
	if event == "COMBAT_LOGGING_STARTED" then
		InfoBarSetText("InfoBarLC", "|cffffffffLogging Combat: |cff00ff00ON")
	elseif event == "COMBAT_LOGGING_STOPPED" then
		InfoBarSetText("InfoBarLC", "|cffffffffLogging Combat: |cffff0000OFF")
	elseif event == "PLAYER_ENTERING_WORLD" then
		if not LoggingCombat() then
			InfoBarSetText("InfoBarLC", "|cffffffffLogging Combat: |cffff0000OFF")
		else
			InfoBarSetText("InfoBarLC", "|cffffffffLogging Combat: |cff00ff00ON")
		end
	end
end

function InfoBarLC_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		if not LoggingCombat() then
			InfoBarSetText("InfoBarLC", "|cffffffffLogging Combat: |cffff0000OFF")
		else
			InfoBarSetText("InfoBarLC", "|cffffffffLogging Combat: |cff00ff00ON")
		end

		self.timer = 0
	end
end
