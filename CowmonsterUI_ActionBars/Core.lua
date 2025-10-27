local f = CreateFrame("Frame", nil, UIParent)

local ACTIONBAR_OFFSETX = 60
local ACTIONBAR_OFFSETY = 0
local BAG_OFFSETY = 20

hooksecurefunc(PetActionBarFrame, "SetPoint", function(self)
	for i=1,10,1 do
		local button, lastButton = _G["PetActionButton"..i], _G["PetActionButton"..(i-1)]

		if button ~= nil then
			button:ClearAllPoints()

			if i == 1 then
				if ShapeshiftBarFrame:IsVisible() then
					button:SetPoint("BOTTOMLEFT", MultiBarRightButton2, "TOPLEFT", 0, 4)
				else
					button:SetPoint("BOTTOMLEFT", ExtraBarButton2, "TOPLEFT", 0, 4)
				end
			else
				button:SetPoint("LEFT", lastButton, "RIGHT", 4, 0)
			end
		end
	end
end)

hooksecurefunc(ShapeshiftBarFrame, "SetPoint", function(self)
	for i=1,10,1 do
		local button, lastButton = _G["ShapeshiftButton"..i], _G["ShapeshiftButton"..(i-1)]

		if button ~= nil then
			button:ClearAllPoints()

			if i == 1 then
				button:SetPoint("BOTTOMLEFT", ExtraBarButton2, "TOPLEFT", 0, 4)
			else
				button:SetPoint("LEFT", lastButton, "RIGHT", 4, 0)
			end
		end
	end
end)

local function UpdateBindings()
	for i=1,12,1 do
		local button = _G["ExtraBarButton"..i]
		local id = button:GetID()

		local hotkey = _G[button:GetName().."HotKey"]
		local key = GetBindingKey("EXTRABARBUTTON"..i)
		local text = GetBindingText(key, "KEY_", 1)

		if text == "" then
			hotkey:SetText(RANGE_INDICATOR)
			hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
			hotkey:Hide()
		else
			hotkey:SetText(text)
			hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", -2, -2)
			hotkey:Show()
			SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
		end
	end
end

local function HideBar()
	for i=1,12,1 do
		_G["ExtraBarButton"..i]:Hide()
	end
end

local function ShowBar()
	for i=1,12,1 do
		_G["ExtraBarButton"..i]:Show()
	end
end

for id=13,24 do
	local b = CreateFrame("CheckButton", "ExtraBarButton"..(id-12), UIParent, "ActionBarButtonTemplate")

	b:SetSize(36*UIParent:GetScale(), 36*UIParent:GetScale())
	b:SetAttribute("action", id)
	b:SetID(id)
	--b:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton"..(id-12)], "TOPLEFT", 0, 4)
	--b:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton"..(id-12)], "TOPLEFT", 0, 44)
	b:SetPoint("BOTTOMLEFT", _G["MultiBarBottomLeftButton"..(id-12)], "TOPLEFT", 0, 4)
	b:Show()
end

local function OnEvent(self, event, ...)
	if event == "ACTIONBAR_PAGE_CHANGED" then
		if GetActionBarPage() ~= 1 then	ChangeActionBarPage(1) end
	elseif event == "UPDATE_BINDINGS" then
		UpdateBindings()
	elseif event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
		MainMenuBar:ClearAllPoints()
		MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", ACTIONBAR_OFFSETX, ACTIONBAR_OFFSETY)

		for i=1,12,1 do
			if i == 1 then
				_G["MultiBarLeftButton"..i]:ClearAllPoints()
				_G["MultiBarLeftButton"..i]:SetPoint("LEFT", ActionButton12, "RIGHT", 14, 0)
			else
				_G["MultiBarLeftButton"..i]:ClearAllPoints()
				_G["MultiBarLeftButton"..i]:SetPoint("LEFT", _G["MultiBarLeftButton"..(i-1)], "RIGHT", 6, 0)
			end

			_G["MultiBarRightButton"..i]:ClearAllPoints()
			_G["MultiBarRightButton"..i]:SetPoint("BOTTOM", _G["MultiBarBottomRightButton"..i], "TOP", 0, 4)
		end

		local microButtons = {
			CharacterMicroButton,
			SpellbookMicroButton,
			TalentMicroButton,
			AchievementMicroButton,
			QuestLogMicroButton,
			SocialsMicroButton,
			LFDMicroButton,
			PVPMicroButton,
			MainMenuMicroButton,
			HelpMicroButton
		}

		for i=1, #microButtons do
			local button, previousButton = microButtons[i], microButtons[i-1]

			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "TOPRIGHT", 0, 4)
			else
				button:SetPoint("RIGHT", previousButton, "LEFT", -2, 0)
			end
		end

		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, BAG_OFFSETY)

		self.menuOffsetLeft = MainMenuBar:GetLeft()
		self.menuOffsetBottom = MainMenuBar:GetBottom()
	elseif event == "PLAYER_LOGIN" then
		BINDING_HEADER_EXTRABAR = "ExtraBar"
		BINDING_NAME_EXTRABARBUTTON1 = "Button 1"
		BINDING_NAME_EXTRABARBUTTON2 = "Button 2"
		BINDING_NAME_EXTRABARBUTTON3 = "Button 3"
		BINDING_NAME_EXTRABARBUTTON4 = "Button 4"
		BINDING_NAME_EXTRABARBUTTON5 = "Button 5"
		BINDING_NAME_EXTRABARBUTTON6 = "Button 6"
		BINDING_NAME_EXTRABARBUTTON7 = "Button 7"
		BINDING_NAME_EXTRABARBUTTON8 = "Button 8"
		BINDING_NAME_EXTRABARBUTTON9 = "Button 9"
		BINDING_NAME_EXTRABARBUTTON10 = "Button 10"
		BINDING_NAME_EXTRABARBUTTON11 = "Button 11"
		BINDING_NAME_EXTRABARBUTTON12 = "Button 12"
	elseif event == "ADDON_LOADED" then
		if IsAddOnLoaded("CowmonsterUI_InfoBar") then
			ACTIONBAR_OFFSETY = 20

			--self:UnregisterEvent("ADDON_LOADED")
		end

		if IsAddOnLoaded("CowmonsterUI_MiniMap") then
			BAG_OFFSETY = 170

			MainMenuBarBackpackButton:ClearAllPoints()
			MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, BAG_OFFSETY)
		end

		ActionBarUpButton:Disable()
		ActionBarDownButton:Disable()
	end
end

local function OnUpdate(self, elapsed)
	self.timer = (self.timer or 0) + elapsed
	self.menuOffsetLeft = self.menuOffsetLeft or 0
	self.menuOffsetBottom = self.menuOffsetBottom or 0

	if self.timer >= 1 then
		if MainMenuBar:GetLeft() or 0 ~= self.menuOffsetLeft or MainMenuBar:GetBottom() or 0 ~= self.menuOffsetBottom() then
			MainMenuBar:ClearAllPoints()
			MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", ACTIONBAR_OFFSETX, ACTIONBAR_OFFSETY)
		end

		for i=1,12,1 do
			if not UnitAffectingCombat("player") then
				if MainMenuBar:IsShown() == 1 and _G["ExtraBarButton"..i]:IsShown() == nil then
					_G["ExtraBarButton"..i]:Show()
				elseif MainMenuBar:IsShown() == nil and _G["ExtraBarButton"..i]:IsShown() == 1 then
					_G["ExtraBarButton"..i]:Hide()
				end
			end
		end

		self.timer = 0
	end
end

f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_BINDINGS")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")
f:RegisterEvent("VARIABLES_LOADED")

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)
