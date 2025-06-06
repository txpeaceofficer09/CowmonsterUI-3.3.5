function InfoBarAvoidance_OnEnter(self)
	if UnitAffectingCombat("player") then return end

	InfoBarTooltip:ClearLines()
	InfoBarTooltip:SetOwner(self, "ANCHOR_TOPLEFT")

	InfoBarTooltip:AddLine("Avoidance:")
	InfoBarTooltip:AddLine(" ")

	local d = GetDodgeChance()
	local p = GetParryChance()
	local b = GetBlockChance()
	local bv = GetShieldBlock()
	local a = UnitArmor("player")

	InfoBarTooltip:AddDoubleLine("Dodge", ("%.2f%%"):format(d))
	InfoBarTooltip:AddDoubleLine("Parry", ("%.2f%%"):format(p))
	InfoBarTooltip:AddDoubleLine("Block Chance", ("%.2f%%"):format(b))
	InfoBarTooltip:AddDoubleLine("Shield Block", ("%.2f%%"):format(bv))
	InfoBarTooltip:AddDoubleLine("Armor", ("%d"):format(a))

	InfoBarTooltip:Show()
end

function InfoBarAvoidance_OnLeave(self)
	InfoBarTooltip:Hide()
	InfoBarTooltip:ClearLines()
end

--[[
function InfoBarMoney_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_MONEY" then
		InfoBarSetText("InfoBarMoney", nil, CowmonsterUI.GetCoinTextureString(GetMoney()))

		CowmonsterUIDB[GetRealmName()][UnitName("player")].Money = GetMoney()
	end
end

function InfoBarMoney_OnClick(self, button)
	ToggleAllBags()
end
]]

function InfoBarAvoidance_OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed

	if self.timer >= 0.2 then
		local d = GetDodgeChance()
		local p = GetParryChance()
		local b = GetBlockChance()
		local bv = GetShieldBlock()
		local a = UnitArmor("player")
		--InfoBarSetText("InfoBarAvoidance", "Avoidance: %.2f%% + %.2f%% + %.2f%% = %.2f%% - %.0f Blocked %.2f%% of the time", d, p, (a/89.3), d+p+(a/89.3), bv, b)
		InfoBarSetText("InfoBarAvoidance", "Avoidance: %.2f%% - %.0f Blocked %.2f%% of the time", d+p+(a/89.3), bv, b)

		self.timer = 0
	end
end
