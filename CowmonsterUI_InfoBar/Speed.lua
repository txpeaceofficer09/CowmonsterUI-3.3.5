function InfoBarSpeed_OnEvent(self, event, ...)
	local unit = ...
	if (event == "UNIT_ENTERED_VEHICLE") then
		if unit == "player" then
			self.currentUnit = "vehicle"
		end
	elseif (event == "UNIT_EXITED_VEHICLE") then
		if unit == "player" then
			self.currentUnit = "player"
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		InfoBarSetText("InfoBarSpeed", "Speed: |cffffaa00%s...|r", "initializing")
	end
end

function InfoBarSpeed_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if (self.timer >= 0.1) then
		local iSpeed = GetUnitSpeed(self.currentUnit or "player")

		if iSpeed and iSpeed >= 0 then
			if not (IsSwimming() or IsFlying()) then
				self.currentSpeed = CowmonsterUI.Round(iSpeed/7 * 100)
			else
				self.currentSpeed = CowmonsterUI.Round((iSpeed/7 * 100) * math.cos(GetUnitPitch(self.currentUnit or "player")))
			end
			if self.currentSpeed == 0 then
				InfoBarSetText("InfoBarSpeed", "Speed: |cffcccccc%d%%|r", self.currentSpeed)
			elseif self.currentSpeed == 100 then
				InfoBarSetText("InfoBarSpeed", "Speed: |cff8888ff%d%%|r", self.currentSpeed)
			else		
				InfoBarSetText("InfoBarSpeed", "Speed: |cff88ff88%d%%|r", self.currentSpeed)
			end
			self.timer = 0
		else
			InfoBarSetText("InfoBarSpeed", "Speed: |cffcccccc%s|r", "???")
		end
	end
end
