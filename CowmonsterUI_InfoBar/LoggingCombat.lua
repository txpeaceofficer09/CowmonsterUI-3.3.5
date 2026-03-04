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
