local InfoBarXPtoggle
local playerName = UnitName("player")
local playerRealm = GetRealmName()
local tmr = 0
local InfoBarStrings = {
	{
		["Name"] = "InfoBarMoney",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarMoney_OnEnter",
			["OnLeave"] = "InfoBarMoney_OnLeave",
			["OnEvent"] = "InfoBarMoney_OnEvent",
			["OnClick"] = "InfoBarMoney_OnClick",
		},
		["Events"] = {
			"PLAYER_MONEY",
			"PLAYER_ENTERING_WORLD",
		},
	},
	--[[
	{
		["Name"] = "InfoBarXP",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarXP_OnEnter",
			["OnLeave"] = "InfoBarXP_OnLeave",
			["OnClick"] = "InfoBarXP_OnClick",
			["OnEvent"] = "InfoBarXP_OnEvent",
		},
		["Events"] = {
			"UPDATE_FACTION",
			"CHAT_MSG_COMBAT_FACTION_CHANGE",
			"CHAT_MSG_COMBAT_XP_GAIN",
			"CHAT_MSG_COMBAT_GUILD_XP_GAIN",
			"GUILD_XP_UPDATE",
		},
	},
	]]
	{
		["Name"] = "InfoBarMem",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarMem_OnEnter",
			["OnLeave"] = "InfoBarMem_OnLeave",
			["OnUpdate"] = "InfoBarMem_OnUpdate",
		},
	},
	{
		["Name"] = "InfoBarBags",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnClick"] = "InfoBarBags_OnClick",
			["OnEvent"] = "InfoBarBags_OnEvent",
		},
		["Events"] = {
			"BAG_UPDATE",
			"PLAYER_ENTERING_WORLD",
		},
	},
	{
		["Name"] = "InfoBarCoords",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarCoords_OnUpdate",
		},
		["Events"] = {
			"PLAYER_ENTERING_WORLD",
		},
	},
	--[[
	{
		["Name"] = "InfoBarAvoidance",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarAvoidance_OnUpdate",
			["OnEnter"] = "InfoBarAvoidance_OnEnter",
			["OnLeave"] = "InfoBarAvoidance_OnLeave",
		},
	},
	]]
	{
		["Name"] = "InfoBarSpellBonus",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarSpellBonus_OnUpdate",
			["OnEnter"] = "InfoBarSpellBonus_OnEnter",
			["OnLeave"] = "InfoBarSpellBonus_OnLeave",
		},
	},
	{
		["Name"] = "InfoBarProfessions",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEvent"] = "InfoBarProfessions_OnEvent",
		},
		["Events"] = {
			"PLAYER_ENTERING_WORLD",
			"TRADE_SKILL_LEVEL_CHANGED",
		},
	},
	{
		["Name"] = "InfoBarRecords",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEvent"] = "InfoBarRecords_OnEvent",
			["OnUpdate"] = "InfoBarRecords_OnUpdate",
			["OnEnter"] = "InfoBarRecords_OnEnter",
			["OnLeave"] = "InfoBarRecords_OnLeave",
			["OnClick"] = "InfoBarRecords_OnClick",
		},
		["Events"] = {
			"COMBAT_LOG_EVENT_UNFILTERED",
			"ADDON_LOADED",
			"VARIABLES_LOADED",
		},
	},
	{
		["Name"] = "InfoBarDPS",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEvent"] = "InfoBarDPS_OnEvent",
			["OnEnter"] = "InfoBarDPS_OnEnter",
			["OnLeave"] = "InfoBarDPS_OnLeave",
			["OnClick"] = "InfoBarDPS_OnClick",
			["OnUpdate"] = "InfoBarDPS_OnUpdate",
		},
		["Events"] = {
			"PLAYER_ENTERING_WORLD",
			"COMBATLOG_EVENT_UNFILTERED",
		},
	},
	{
		["Name"] = "InfoBarGuild",
		["JustifyH"] = "LEFT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarGuild_OnEnter",
			["OnLeave"] = "InfoBarGuild_OnLeave",
			["OnClick"] = "InfoBarGuild_OnClick",
			--["OnUpdate"] = "InfoBarGuild_OnUpdate",
			["OnEvent"] = "InfoBarGuild_OnEvent",
		},
		["Events"] = {
			"GUILD_ROSTER_UPDATE",
			"PLAYER_ENTERING_WORLD",
			--"CHAT_MSG_SYSTEM",
			"GUILD_EVENT_GUILD_ROSTER_CHANGED",
			--"VARIABLES_LOADED",
		},
	},
	--[[
	{
		["Name"] = "InfoBarMicroMenu",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarMicroMenu_OnEnter",
			["OnLeave"] = "InfoBarMicroMenu_OnLeave",
			["OnEvent"] = "InfoBarMicroMenu_OnEvent",
			["OnClick"] = "InfoBarMicroMenu_OnClick",
			--["OnMouseUp"] = "InfoBarMicroMenu_OnClick",
		},
		["Events"] = {
			"PLAYER_ENTERING_WORLD",
		},
	},
	]]
	--[[
	{
		["Name"] = "InfoBarLFG",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnEnter"] = "InfoBarLFG_OnEnter",
			["OnLeave"] = "InfoBarLFG_OnLeave",
			["OnEvent"] = "InfoBarLFG_OnEvent",
			["OnClick"] = "InfoBarLFG_OnClick",
		},
		["Events"] = {
			"PLAYER_ENTERING_WORLD",
			"LFG_QUEUE_STATUS_UPDATE",
		},
	},
	]]
	{
		["Name"] = "InfoBarLat",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarLat_OnUpdate",
		},
	},
	{
		["Name"] = "InfoBarFPS",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarFPS_OnUpdate",
		},
	},
	{
		["Name"] = "InfoBarClock",
		["JustifyH"] = "RIGHT",
		["Scripts"] = {
			["OnUpdate"] = "InfoBarClock_OnUpdate",
		},
	},
--[[
	{
		["Name"] = "InfoBarMail",
		["JustifyH"] = "RIGHT",
		["Events"] = {
			"PLAYER_ENTERING_WORLD",
			"UPDATE_PENDING_MAIL",
		},
	},
]]
}

local f = CreateFrame("Frame", "InfoBarFrame", UIParent)
local t = CreateFrame("GameTooltip", "InfoBarTooltip", UIParent, "GameTooltipTemplate")

f:SetHeight(20)
f:ClearAllPoints()
f:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

f:SetBackdrop( { bgFile = "Interface\\DialogFrame\\UI-DialogBox-BackGround-Dark", edgeFile = nil, tile = true, tileSize = 32, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 } } )

for k, v in ipairs(InfoBarStrings) do
	local b = CreateFrame("Button", v.Name, InfoBarFrame)
	local s = b:CreateFontString(v.Name.."Text", "ARTWORK")
	s:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")

	s:SetAllPoints(b)

	s:SetJustifyH(v.JustifyH)
	b:SetHeight(f:GetHeight())

	if v.Scripts then
		for i, a in pairs(v.Scripts) do
			--b:SetScript(i, _G[v.Name.."_"..i])
			b:SetScript(i, _G[a])
		end
	end

	if v.Events then
		for i, a in pairs(v.Events) do
			b:RegisterEvent(a)
		end
	end

	s:Show()
	b:Show()
end

f:Show()

function InfoBarSetText(i, format, ...)
	if type(i) ~= "number" then
		for k, v in pairs(InfoBarStrings) do
			if v.Name == i then i = k end
		end
	end

	if not InfoBarStrings or not InfoBarStrings[i] then
		return
	end

	local btn = _G[InfoBarStrings[i].Name]
	local str = _G[InfoBarStrings[i].Name.."Text"] --or f:CreateFontString(InfoBarStrings[i].Name, "ARTWORK", "NumberFont_Outline_Med")

	if format then
		str:SetFormattedText(format, ...)
	else
		str:SetText(select(1, ...))
	end

	btn:SetWidth(str:GetStringWidth()+30)

	for i = 1, floor(#(InfoBarStrings)/2), 1 do
		local s = _G[InfoBarStrings[i].Name]

		if i == 1 then
			s:SetPoint("TOPLEFT", InfoBarFrame, "TOPLEFT", 10, 0)
		else
			s:SetPoint("TOPLEFT", _G[InfoBarStrings[(i-1)].Name], "TOPRIGHT", 0, 0)
		end
	end

	for i = #(InfoBarStrings), floor(#(InfoBarStrings)/2)+1, -1 do
		local s = _G[InfoBarStrings[i].Name]

		if i == #(InfoBarStrings) then
			s:SetPoint("TOPRIGHT", InfoBarFrame, "TOPRIGHT", -10, 0)
		else
			s:SetPoint("TOPRIGHT", _G[InfoBarStrings[(i+1)].Name], "TOPLEFT", 0, 0)
		end
	end
end

function f.OnEvent(self, event, ...)
	if event == "VARIABLES_LOADED" then
		CowmonsterUIDB[GetRealmName()] = CowmonsterUIDB[GetRealmName()] or {}
		CowmonsterUIDB[GetRealmName()][UnitName("player")] = CowmonsterUIDB[GetRealmName()][UnitName("player")] or {["Settings"]={}}

		--self:SetPoint("CENTER", UIParent, "CENTER", 0, 10-(GetScreenHeight()/2))
		--if not IsAddOnLoaded("CowmonsterUI_ActionBars") then
			MainMenuBar:ClearAllPoints()
			MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 60, 20)

			--for i=1,12,1 do
			--	_G[("ActionButton%d"):format(i)]:SetParent(UIParent)
			--end

			--[[
			local kids = { MainMenuBarArtFrame:GetChildren() }
			for _, kid in pairs(kids) do
				kid:SetParent(UIParent)
			end

			MainMenuBarArtFrame:Hide()
			]]

			self.menuOffsetLeft = MainMenuBar:GetLeft()
			self.menuOffsetBottom = MainMenuBar:GetBottom()
		--end
	end
end

f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", f.OnEvent)

f:SetScript("OnUpdate", function(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	self.menuOffsetLeft = self.menuOffsetLeft or 0
	self.menuOffsetBottom = self.menuOffsetBottom or 0

	if self.timer >= 1 then
		if MainMenuBar:GetLeft() ~= self.menuOffsetLeft or MainMenuBar:GetBottom() ~= self.menuOffsetBottom then
			MainMenuBar:ClearAllPoints()
			MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 60, 20)
		end

		self.timer = 0
	end
end)

local t = f:CreateTexture(nil, "ARTWORK")
t:SetAllPoints(f)
t:Show()
t:SetTexture("Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill")
t:SetVertexColor(0.2, 0.2, 0.2)
