function InfoBarCoords_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 0.2 then
		--SetMapToCurrentZone()
		local posX, posY = GetPlayerMapPosition("player")

		InfoBarSetText("InfoBarCoords", "Coords: %.2f, %.2f", posX*100, posY*100)

		self.timer = 0
	end
end

function InfoBarCoords_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		SetMapToCurrentZone()
	end
end
