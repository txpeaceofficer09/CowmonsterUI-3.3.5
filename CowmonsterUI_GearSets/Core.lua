local f = CreateFrame("Frame", nil, UIParent)

local function CreateEquipmentButtons()
	for i=1,GetNumEquipmentSets() do
		local name, icon, setID = GetEquipmentSetInfo(i)

		--local f = CreateFrame("Frame", "EQ"..i.."Button", UIParent)
		local btn = CreateFrame("Button", "EQ"..i.."Button", UIParent)

		btn:SetSize(24, 24)
		if i == 1 then
			btn:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 200)
		else
			btn:SetPoint("BOTTOMRIGHT", _G["EQ"..(i-1).."Button"], "BOTTOMLEFT", -2, 0)
		end

		btn.name = name
		local t = btn:CreateTexture(btn:GetName().."Icon", "ARTWORK")
		--local t = _G[btn:GetName().."Icon"]
		t:SetAllPoints(f)
		t:SetTexture(icon)
		t:Show()

		_G["EQ"..i.."ButtonIcon"]:SetTexture(icon)
		btn:SetScript("OnEnter", function(self, motion)
			if motion == true then
				GameTooltip:SetOwner(self)
				GameTooltip:SetEquipmentSet(self.name)
				GameTooltip:Show()
			end
		end)

		btn:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
			GameTooltip:ClearLines()
		end)

		btn:SetScript("OnMouseUp", function(self, button)
			local equipped = UseEquipmentSet(self.name)
			
--			if equipped then
--				DEFAULT_CHAT_FRAME:AddMessage(self.name.." already equipped.", 0, 0.5, 1, 1)
--			else
--				DEFAULT_CHAT_FRAME:AddMessage("Equipping "..self.name..".", 0, 1, 1, 1)
--			end

			DEFAULT_CHAT_FRAME:AddMessage(self.name.." equipped.", 0.5, 1, 1, 1)
		end)

		btn:Show()
	end
end

f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		CreateEquipmentButtons()
	elseif event == "EQUIPMENT_SETS_CHANGED" then
		CreateEquipmentButtons()
	elseif event == "ADDON_LOADED" then
		--if IsAddOnLoaded("CowmonsterUI_ActionBars") then
		--	EQ1Button:ClearAllPoints()
		--	EQ1Button:SetPoint("BOTTOMRIGHT", SocialsMicroButton, "TOPRIGHT", 0, 0)
		--end
	end
end)

f:RegisterEvent("EQUIPMENT_SETS_CHANGED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
