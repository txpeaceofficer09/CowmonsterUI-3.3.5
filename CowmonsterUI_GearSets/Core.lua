local frame = CreateFrame("Frame", "SteakGearSetsAnchor", UIParent)

frame:SetSize(200, 24)
frame:SetPoint("CENTER", 300, 0)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

local bg = frame:CreateTexture(nil, "BACKGROUND")
bg:SetTexture(0, 0, 0, 0.5)
bg:SetAllPoints(frame)

local buttons = {}

frame:SetScript("OnEvent", function(self, event, ...)
	for _, button in ipairs(buttons) do
		button:Hide()
	end

	self:SetWidth(GetNumEquipmentSets()*26)

	for i=1,GetNumEquipmentSets() do
		local button = buttons[i]
		
		if not button then
			button = CreateFrame("Button", nil, self)
			button:SetSize(24, 24)
			button:SetPoint("LEFT", self, "LEFT", ((i-1)*26), 0)
			
			button.icon = button:CreateTexture(nil, "BACKGROUND")
			button.icon:SetAllPoints(button)
			
			button:SetScript("OnEnter", function(self, motion)
				if motion then
					GameTooltip:SetOwner(button)
					GameTooltip:SetEquipmentSet(self.name)
					GameTooltip:Show()
				end
			end)
			
			button:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
				GameTooltip:ClearLines()
			end)
			
			button:SetScript("OnMouseUp", function(self, button)
				local equipped = UseEquipmentSet(self.name)
				
				DEFAULT_CHAT_FRAME:AddMessage(self.name.." equipped.", 0.5, 1, 1, 1)
			end)
			
			button:RegisterForDrag("LeftButton")
			button:SetScript("OnDragStart", frame.StartMoving)
			button:SetScript("OnDragStop", frame.StopMovingOrSizing)
			
			buttons[i] = button
		end
		
		local name, icon, setID = GetEquipmentSetInfo(i)
		
		button.name = name
		button.icon:SetTexture(icon)
		
		button:Show()
	end
end)

frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
