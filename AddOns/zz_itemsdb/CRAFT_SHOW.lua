local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local events, db = {}
local hookedCraft = {}
local craftTip = CreateFrame("GameTooltip", format("%sCraftReagentTip",childName), nil, "GameTooltipTemplate")
local function CraftReagent_OnLeave(self)
	craftTip:Hide()
end
local function CraftReagent_OnEnter(self)
	if(self.hasItem==1) then
		local itemName = self['Name']:GetText()
		if(itemName) then
			local id = GetItemInfoInstant(itemName)
			craftTip:Hide()
			craftTip:ClearLines()
			craftTip:SetOwner(self, "ANCHOR_TOPLEFT")
			if(id) then
				craftTip:SetItemByID(id)
				child.GameTooltip_OnTooltipSetItem(craftTip)
			else
				craftTip:SetCraftItem(GetCraftSelectionIndex(), self:GetID())
			end
			craftTip:Show()
			CursorUpdate()
		end
	end
end
function events:CRAFT_SHOW()
	if(not db['donthookCraftFrame']) then
		for i = 1, MAX_CRAFT_REAGENTS do
			local reag = format("CraftReagent%i", i)
			if(not hookedCraft[reag]) then
				_G[reag]:SetScript("OnEnter", CraftReagent_OnEnter)
				_G[reag]:SetScript("OnLeave", CraftReagent_OnLeave)
				hookedCraft[reag] = true
			end
		end
	end
end
child:IgnoreRetail("CRAFT_SHOW")
child:AddEvent(events)
local init = {
	Setup = function(self)
		db = child['db']
		if(not db["CraftTipScale"]) then
			db["CraftTipScale"] = 0.9
		end
		craftTip:SetScale(db["CraftTipScale"])
	end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')