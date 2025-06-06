local professsionTexture = {
	["blacksmithing"] = "Interface\\Icons\\Trade_Blacksmithing",
	["leatherworking"] = "Interface\\Icons\\Trade_Leatherworking",
	["alchemy"] = "Interface\\Icons\\Trade_Alchemy",
	["herbalism"] = "Interface\\Icons\\Trade_Herbalism",
	["mining"] = "Interface\\Icons\\Trade_Mining",
	["enchanting"] = "Interface\\Icons\\Trade_Enchanting",
	["tailoring"] = "Interface\\Icons\\Trade_Tailoring",
	["skinning"] = "Interface\\Icons\\Trade_Skinning",
	["engineering"] = "Interface\\Icons\\Trade_Engineering",
	["jewelcrafting"] = "Interface\\Icons\\Trade_Jewelcrafting",
}

--[[
function InfoBarProfessions_IsProfession(name)
	local professions = { "blacksmithing", "leatherworking", "alchemy", "herbalism", "mining", "enchanting", "tailoring", "skinning", "engineering", "jewelcrafting" }

	for _, prof in ipairs(professions) do
		if prof == strlower(name) then
			return true
		end
	end

	return nil
end
]]

--[[
function InfoBarProfessions_GetProfString(index)
	local name, icon, skillLevel, maxSkillLevel, numAbilities, spelloffset, skillLine, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(index)

	return ("%s / %s |T%s|t"):format(skillLevel, maxSkillLevel, icon)
end
]]

function InfoBarProfessions_OnUpdate(self, elapsed)

end

function InfoBarProfessions_UpdateProfessions()
	local text = ""
	local numTradeSkills = GetNumTradeSkills()
	--local numTradeSkills = 14
	for i=1,numTradeSkills,1 do
		local professionID = GetTradeSkillInfoByIndex(i)
		local name, icon, currentSkill, maxSkill = GetTradeSkillInfo(professionID)

		ChatFrame:AddMessage("Profession: "..professionID.." "..name.." "..icon.." "..currentSkill.." / "..maxSkill)

		if strlen(text) > 0 then
			text = ("%s |T%s:0|t %s / %s"):format(text, icon, currentSkill, maxSkill)
		else
			text = ("|T%s:0|t %s / %s"):format(icon, currentSkill, maxSkill)
		end
	end

	InfoBarSetText("InfoBarProfessions", "Professions: %s", text)
end

--[[
function InfoBarProfessions_Spells()
	for i = 1, GetNumSpellTabs() do
		local offset, numSlots = select(3, GetSpellTabInfo(i))
		for j = offset+1, offset+numSlots do
			print(i, j, GetSpellBookItemName(j, BOOKTYPE_SPELL))
		end
	end
end
]]

function InfoBarProfessions_OnEvent(self, event, ...)
	--InfoBarProfessions_UpdateProfessions()
	--InfoBarProfessions_Spells()
end
