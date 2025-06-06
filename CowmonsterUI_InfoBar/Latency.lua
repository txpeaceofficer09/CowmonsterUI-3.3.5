function InfoBarLat_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 1 then
		--local _, _, home, world = GetNetStats()
		local _, _, home = GetNetStats()
		local homeClr = { ["r"] = 0, ["g"] = 0, ["b"] = 0 }
		--local worldClr = { ["r"] = 0, ["g"] = 0, ["b"] = 0 }

		if home <= 200 then
			homeClr.g = 255
		elseif home <= 300 then
			homeClr.r = 255
			homeClr.g = 255
		elseif home <= 400 then
			homeClr.r = 255
			homeClr.g = 128
		else
			homeClr.r = 255
		end

--[[
		if world <= 200 then
			worldClr.g = 255
		elseif world <= 300 then
			worldClr.r = 255
			worldClr.g = 255
		elseif world <= 400 then
			worldClr.r = 255
			worldClr.g = 128
		else
			worldClr.r = 255
		end
]]

		--InfoBarSetText("InfoBarLat", "|cff%02x%02x%02x%.0f |cFFFFFFFF(|cff%02x%02x%02x%.0f|cFFFFFFFF) MS", homeClr.r, homeClr.g, homeClr.b, home, worldClr.r, worldClr.g, worldClr.b, world)
		InfoBarSetText("InfoBarLat", "|cff%02x%02x%02x%.0f|cFFFFFFFF MS", homeClr.r, homeClr.g, homeClr.b, home)

		self.timer = 0
	end
end
