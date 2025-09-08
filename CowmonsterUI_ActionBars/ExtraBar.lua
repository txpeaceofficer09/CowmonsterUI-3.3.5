local f = CreateFrame("Frame", nil, UIParent)

local function MovePetBar()
	if UnitAffectingCombat("player") then
		f.needMove = true
		return
	end
	
	--if StanceBarFrame:IsVisible() then
	if ShapeshiftBarFrame:IsVisible() then
		PetActionBarFrame:SetPoint("BOTTOMLEFT", ExtraBarButton1, "TOPLEFT", 0, 4)
	else
		--PetActionBarFrame:SetPoint("BOTTOMLEFT", StanceBarFrame, "BOTTOMLEFT", 0, 0)
		PetActionBarFrame:SetPoint("BOTTOMLEFT", ShapeshiftBarFrame, "BOTTOMLEFT", 0, 0)
	end
end

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
	b:SetPoint("BOTTOMLEFT", _G["MultiBarBottomRightButton"..(id-12)], "TOPLEFT", 0, 44)
	b:Show()
end

local function OnEvent(self, event, ...)
	if event == "ACTIONBAR_PAGE_CHANGED" then
		if GetActionBarPage() ~= 1 then	ChangeActionBarPage(1) end
	elseif event == "UPDATE_BINDINGS" then
		UpdateBindings()
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
	elseif event == "ADDON_LOADED" and ... == addonName then
		ActionBarUpButton:Disable()
		ActionBarDownButton:Disable()

		PetActionBarFrame:HookScript("OnShow", function() MovePetBar() end)

		MovePetBar()
	else
		MovePetBar()
	end
end

local function OnUpdate(self, elapsed)
	if self.needMove == true and UnitAffectingCombat("player") == false then
		MovePetBar()
		self.needMove = false
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
end

f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UPDATE_BINDINGS")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA")
f:RegisterEvent("PLAYER_GAINS_VEHICLE_DATA")

f:SetScript("OnEvent", OnEvent)
f:SetScript("OnUpdate", OnUpdate)
