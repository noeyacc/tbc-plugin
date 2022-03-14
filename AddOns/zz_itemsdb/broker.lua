local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local zzLDB = LibStub:GetLibrary("zzLDB")
local function OnClick(self, button)
	zzLDB:DefaultOnClick(self, button, addon, childName)
end
local function OnTooltipShow(tip)
	tip:AddLine(childName)
end
child['ldb'] = { -- https://github.com/tekkub/libdatabroker-1-1/wiki/Data-Specifications
	['type'] = 'launcher', -- required: 'data source' or 'launcher'
	['text'] = childName, -- required/optional for launcher
	['icon'] = 'Interface\\Icons\\INV_Misc_Bag_10_Blue', -- optional/required for launcher
	['OnClick'] = OnClick, -- optional/required for launcher
	['OnTooltipShow'] = OnTooltipShow, -- optional
}
local init = {
	Setup = function(self, childName, event)
--		print("setup ldb", childName, event)
		if(child['ldb']['type'] == 'data source') then
			child.OnText = zzLDB.DefaultOnText
		end
	end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup', childName)