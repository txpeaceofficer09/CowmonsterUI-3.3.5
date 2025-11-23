local f = CreateFrame("Frame", "TauntAlertFrame", UIParent)

function f:print(msg)
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00[TauntAlert]:|r"..msg)
	end
end

function f:find(tbl, val)
	for k, v in pairs(tbl) do
		if v == val then
			return true, k
		end
	end

	return false, nil
end

function f:IsTauntSpell(spellID)
	local taunts = {
		--Warrior
		355, --Taunt
		1161, --Challenging Shout

		--Death Knight
		49576, --Death Grip
		56222, --Dark Command

		--Paladin
		62124, --Hand of Reckoning
		31789, --Righteous Defense

		--Druid
		6795, --Growl
		5209, --Challenging Roar

		--Hunter
		20736, --Distracting Shot

		--Hunter Pet
		2649, -- Growl

		--Shaman
		73684, --Unleash Earth
			
		--Monk
		115546, --Provoke

		--Warlock
		59671, --Challenging Howl
	};

	--[[
	for _,v in pairs(taunts) do
		if v == spellID then
			return true
		end
	end

	return false
	]]

	return f:find(taunts, spellID)
end

local function isInGroup(name)
	if UnitName("player") == name or UnitName("playerpet") == name then return true end

	for i=1,40,1 do
		if UnitName("party"..i) == name or UnitName("raid"..i) == name or UnitName("party"..i.."pet") == name or UnitName("raid"..i.."pet") == name then
			return true
		end
	end

	return false
end

function f:SPELL_CAST_SUCCESS(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, spellID, spellName)
	local msg = nil
	local link = GetSpellLink(spellID)

	if ( bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0 or bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0 ) and not bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) then
			local owner = GetPlayerInfoByGUID(srcGUID)
			msg = ("%s's pet, %s, taunted %s using %s (%s)."):format(owner, srcName, dstName, link, spellID)
		else
			msg = ("%s taunted %s using %s (%s)."):format(srcName, dstName, link, spellID)
		end
	elseif bit.band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		if bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PET) > 0 then
			msg = ("My pet, %s, taunted %s using %s (%s)."):format(srcName, dstName, link, spellID)
		else
			msg = ("I taunted %s using %s (%s)."):format(dstName, link, spellID)
		end
	end

	--[[
	if ( isInGroup(srcName) ) then
		msg = ("%s => %s => %s"):format(srcName, spellName, dstName)
	end
	]]

	if msg ~= nil then self:print(msg) end
end

local function OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, spellID, spellName, spellSchool = ...

		if self[subEvent] then
			if spellID ~= nil and self:IsTauntSpell(spellID) then
				self[subEvent](self, srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, spellID, spellName)
			end
		end
	end
end

f:SetScript("OnEvent", OnEvent)
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
