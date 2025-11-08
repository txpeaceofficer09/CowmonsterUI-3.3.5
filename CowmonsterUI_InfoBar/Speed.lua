function InfoBarSpeed_OnEvent(self, event, ...)
	local unit = ...
	if (event == "UNIT_ENTERED_VEHICLE") then
		if unit == "player" then
			self.currentUnit = "vehicle"
		end
	end
	if (event == "UNIT_EXITED_VEHICLE") then
		if unit == "player" then
			self.currentUnit = "player"
		end
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
				self.currentSpeed = CowmonsterUI.Round((iSpeed/7 * 100) * math.cos(GetUnitPitch(MonkeySpeedTemp.currentUnit)))
			end
			InfoBarSetText("InfoBarSpeed", "Speed: |cff88ff88%d%%|r", self.currentSpeed)

			self.timer = 0
		else
			InfoBarSetText("InfoBarSpeed", "Speed: |cffcccccc%s|r", "???")
		end
	end
end
