-- Create a new frame to hold the buttons
local buffFrame = CreateFrame("Frame", "DruidBuffFrame", UIParent)
buffFrame:SetSize(64, 32) -- Adjust size as needed
buffFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -100) -- Adjust position as needed
buffFrame:SetMovable(true)

local spells = {
	--"Barkskin", -- 22812
	--"Mangle (Cat)", -- 33983
	--"Mangle (Bear)", -- 33987
	--"Bash", -- 8983
	--"Rake", -- 48573
	--"Rip", -- 49799
	"Maim",
	--"Faerie Fire (Feral)", -- 16857
	"Faerie Fire",
	"Nature's Grasp",
	"Entangling Roots",
	"Cyclone",
	--"Lacerate", -- 48567
	"Berserk",
	"Demoralizing Roar",
	"Challenging Roar",
	--"Growl", -- 6795
	"Enrage",
	"Tiger's Fury",
	"Pounce",
	"Innervate" -- Make an addon to whisper people when you cast a buff and when it fades.
}

local ACTIVE_ALPHA = 1
local INACTIVE_ALPHA = 0.25

-- Function to create a buff button
local function CreateBuffButton(parent, name, size, xOffset, spellID, duration)
	local texture = select(2, GetSpellInfo(spellID))

	texture = string.gsub(texture, "\\", "\\\\");

	local button = CreateFrame("Frame", name, parent)
	button:SetSize(size, size)
	button:SetPoint("LEFT", parent, "LEFT", xOffset, 0)
	--button:SetMovable(true)
	button:EnableMouse(true)
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", function(self) self:GetParent():StartMoving() end)
	button:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
	button:SetAlpha(INACTIVE_ALPHA)
	button.spellID = spellID
	button.duration = duration

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetSize(size-4, size-4)
	button.icon:SetPoint("CENTER", button, "CENTER", 0, 0)
	button.icon:SetTexture(texture)

	-- Cooldown Text (optional, for displaying remaining time)
	button.cooldownText = button:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	button.cooldownText:SetPoint("CENTER", button, "CENTER", 0, 0)
	button.cooldownText:SetJustifyH("CENTER")
	button.cooldownText:SetTextColor(0, 1, 0, 1)
	button.cooldownText:SetText("") -- Initially empty

	button:SetScript("OnUpdate", OnUpdate)
	button:SetScript("OnEvent", OnEvent)

	button:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	print("Created "..name)

	button:Show()

	return button
end

buffFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName = ...

		if srcGUID == UnitGUID("player") then
			if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" then
				if tContains(spells, spellName) then
					print(spellName, spellID)
				end
			end
		end
	end
end)

local function OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName = ...

		if srcGUID == UnitGUID("player") then
			if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" then
				if spellID == self.spellID then
					self:SetAlpha(ACTIVE_ALPHA)
					self.startTime = GetTime()
					self.endTime = self.startTime + self.duration
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

if UnitClass("player") == "Druid" then
	print("Loaded DruidBuffs")
	buffFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	CreateBuffButton(buffFrame, "BarkskinButton", 64, 0, 22812, 12)

	buffFrame:Show()
else
    buffFrame:Hide()
end
