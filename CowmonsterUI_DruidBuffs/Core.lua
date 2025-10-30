local spells = {
	--53307, -- Thorns
	29166, --"Innervate" -- Make an addon to whisper people when you cast a buff and when it fades.
	69369, -- Predator's Swiftness
	62606, -- Savage Defense
	22812, -- Barkskin
	50334, -- Berserker
	61336, -- Survival Instincts
	22842, -- Frenzied Regeneration
	50212, -- Tiger's Fury
	52610, -- Savage Roar
	5229, -- Enrage
	--33983, -- Mangle (Cat)
	--33987, -- Mangle (Bear)
	8983, -- Bash
	48573, -- Rake
	49799, -- Rip
	33786, -- Cyclone
	26989, -- Entangling Roots
	27009, -- Nature's Grasp (Buff)
	27010, -- Nature's Grasp (Debuff)
	18658, -- Hibernate
	26995, -- Soothe Animal
	--"Maim",
	--16857, -- Faerie Fire (Feral)
	--770, --"Faerie Fire",
	--48567, -- Lacerate
	--"Demoralizing Roar",
	--"Challenging Roar",
	--6795, -- Growl
	--49803, -- Pounce
	--2893, -- Abolish Poison
	--48450, -- Lifebloom
	--48440, -- Rejuvenation
	--48442, -- Regrowth
	--16870, -- Clearcastings
}

local ACTIVE_ALPHA = 1
local INACTIVE_ALPHA = 0.25
local BUTTON_SIZE = 32

-- Create a new frame to hold the buttons
local buffFrame = CreateFrame("Frame", "DruidBuffFrame", UIParent)
buffFrame:SetSize((#spells * BUTTON_SIZE), BUTTON_SIZE) -- Adjust size as needed
buffFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -100) -- Adjust position as needed
buffFrame:SetMovable(true)

local events = {
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_SUCCESS",
	"SPELL_PERIODIC_HEAL",
	"SPELL_AURA_REMOVED",
	"SPELL_HEAL",
	"SPELL_ENERGIZE",
	"SPELL_CAST_START",
	"SPELL_AURA_REMOVED",
	"SPELL_PERIODIC_ENERGIZE",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_DAMAGE",
	"SPELL_CAST_FAILED",
	"SPELL_AURA_REFRESH",
	"SPELL_MISSED",
}

local units = {
	"player",
	"playerpet",
	"target",
	"targetpet",
	"focus",
	"focustarget",
	"focuspet",
}

for i=1,40,1 do
	if i <= 5 then
		tinsert(units, "party"..i)
		tinsert(units, "party"..i.."target")
		tinsert(units, "party"..i.."pet")
	end
	
	tinsert(units, "raid"..i)
	tinsert(units, "raid"..i.."target")
	tinsert(units, "raid"..i.."pet")
end


local function GetUnitByGUID(guid)
	for _, unit in ipairs(units) do
		if UnitGUID(unit) and UnitGUID(unit) == guid then
			return unit
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
		local timeStamp, subEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName = ...

		if srcGUID == UnitGUID("player") then
			if subEvent == "SPELL_CAST_SUCCESS" or subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_APPLIED_DOSE" or subEvent == "SPELL_AURA_REFRESH" then
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
				
				self.cooldownText:SetText("")
				self.stackText:SetText("")
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
			--self.cooldownText:SetText("")
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

buffFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName = ...

		if srcGUID == UnitGUID("player") then
			if subEvent == "SPELL_CAST_SUCCESS" or subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" or subEvent == "SPELL_AURA_APPLIED_DOSE" then
				--if tContains(spells, spellName) then
					print(spellName, spellID)
				--end
			end
			
			
			if subEvent:sub(1, 5) == "SPELL" then
				print(subEvent)
			end
			
		end
	end
end)

if UnitClass("player") == "Druid" then
	--print("Loaded DruidBuffs")
	--buffFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	for k, spell in pairs(spells) do
		CreateBuffButton(buffFrame, BUTTON_SIZE, (k*BUTTON_SIZE)-BUTTON_SIZE, spell) 
	end

	buffFrame:Show()
else
    buffFrame:Hide()
end
