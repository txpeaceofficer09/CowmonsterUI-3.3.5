-- Create a new frame to hold the buttons
local buffFrame = CreateFrame("Frame", "HunterBuffFrame", UIParent)
buffFrame:SetSize(64, 32) -- Adjust size as needed
buffFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -100) -- Adjust position as needed
buffFrame:SetMovable(true)

local spells = {
	27046, -- Mend Pet
	1539, -- Feed Pet
}

local ACTIVE_ALPHA = 1
local INACTIVE_ALPHA = 0.25

local function GetUnitByGUID(guid)
	if UnitGUID("player") == guid then
		return "player"
	end

	if UnitGUID("playerpet") == guid then
		return "playerpet"
	end
	
	if UnitGUID("target") == guid then
		return "target"
	end
	
	if UnitGUID("targetpet") == guid then
		return "targetpet"
	end
	
	if UnitGUID("focus") == guid then
		return "focus"
	end

	if UnitGUID("focustarget") == guid then
		return "focustarget"
	end
	
	if UnitGUID("focuspet") == guid then
		return "focuspet"
	end

	for i=1,40,1 do
		if UnitGUID("party"..i) and UnitGUID("party"..i) == guid then
			return "party"..i
		elseif UnitGUID("party"..i.."target") and UnitGUID("party"..i.."target") == guid then
			return "party"..i.."target"
		elseif UnitGUID("party"..i.."pet") and UnitGUID("party"..i.."pet") == guid then
			return "party"..i.."pet"
		elseif UnitGUID("raid"..i) and UnitGUID("raid"..i) == guid then
			return "raid"..i
		elseif UnitGUID("raid"..i.."target") and UnitGUID("raid"..i.."target") == guid then
			return "raid"..i.."target"
		elseif UnitGUID("raid"..i.."pet") and UnitGUID("raid"..i.."pet") == guid then
			return "raid"..i.."pet"
		end		
	end
	
	return nil
end

local function GetAuraInfo(unit, spellID)
	local spellName = GetSpellInfo(spellID)
	
	for i=1,40,1 do
		local name, _, _, stacks, _, duration, expirationTime = UnitBuff(unit, i)
		if name ~= spellName then
			name, _, _, stacks, _, duration, expirationTime = UnitDebuff(unit, i)
		end

		if name == spellName then
			if duration and expirationTime then
				local remaining = expirationTime - GetTime();
				return duration, remaining, stacks
			end
		end
	end
	
	return nil, nil, nil
end

local function GetSpellTexture(spellID)
	local _, _, texture = GetSpellInfo(spellID)

	return texture
end

local function OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName = ...

		if srcGUID == UnitGUID("player") then
			if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_APPLIED_DOSE" or subEvent == "SPELL_AURA_REFRESH" then
				if spellID == self.spellID then
					local unit = GetUnitByGUID(dstGUID)

					self:SetAlpha(ACTIVE_ALPHA)
					self.startTime = GetTime()
					
					if unit ~= nil then
						local duration, endTime, stacks = GetAuraInfo(unit, spellID)

						if endTime ~= nil then
							self.endTime = self.startTime + endTime
						elseif duration ~= nil then
							self.endTime = self.startTime + duration
						end
						if ( stacks or 0 ) > 0 then
							self.stackText:SetText(stacks)
						else
							self.stackText:SetText("")
						end
					end

					--self.endTime = self.startTime + self.duration
				end
			elseif subEvent == "SPELL_AURA_REMOVED" then
				self:SetAlpha(INACTIVE_ALPHA)
				self.startTime = nil
				self.endTime = nil
			end
		end
	end
end

local function OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if ( self.timer >= 0.2 ) then
		if self.startTime ~= nil and self.endTime ~= nil then
			local duration = self.endTime - GetTime()

			self.cooldownText:SetText(("%.1f"):format(duration))
		else
			self.cooldownText:SetText("")
		end
	end
end

-- Function to create a buff button
local function CreateBuffButton(parent, size, xOffset, spellID)
	local spellName = GetSpellInfo(spellID)

	local buttonName = ("%sFrame"):format(spellName:gsub("\'", ""):gsub(" ", ""))

	local button = CreateFrame("Frame", buttonName, parent)
	button:SetSize(size, size)
	button:SetPoint("LEFT", parent, "LEFT", xOffset, 0)
	--button:SetMovable(true)
	button:EnableMouse(true)
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	button:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
	button:SetAlpha(INACTIVE_ALPHA)
	button.spellID = spellID
	--button.duration = duration

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetSize(size-4, size-4)
	button.icon:SetPoint("CENTER", button, "CENTER", 0, 0)
	button.icon:SetTexture(GetSpellTexture(spellID))

	-- Cooldown Text (optional, for displaying remaining time)
	button.cooldownText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	button.cooldownText:SetPoint("CENTER", button, "CENTER", 0, 0)
	button.cooldownText:SetJustifyH("CENTER")
	button.cooldownText:SetTextColor(0, 1, 0, 1)
	button.cooldownText:SetText("") -- Initially empty

	button.stackText = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.stackText:SetPoint("BOTTOM", button, "BOTTOM", 0, 0)
	button.stackText:SetJustifyH("CENTER")
	button.stackText:SetTextColor(1, 1, 1, 1)
	button.stackText:SetText("")

	button:SetScript("OnUpdate", OnUpdate)
	button:SetScript("OnEvent", OnEvent)

	button:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	button:Show()

	return button
end

if UnitClass("player") == "Hunter" then
	for k, spell in pairs(spells) do
		CreateBuffButton(buffFrame, 48, (k*48)-48, spell) 
	end

	buffFrame:Show()
else
    buffFrame:Hide()
end
