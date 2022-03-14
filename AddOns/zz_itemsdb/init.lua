local addonName, addon = ...
addon['childName'] = "zz_itemsdb"
addon['callbacks'] = addon['callbacks'] or LibStub("CallbackHandler-1.0"):New(addon)
addon[addon['childName']] = {
	['parentName'] = addonName ~= addon['childName'] and addonName or nil,
	['events'] = {}
}
LibStub:GetLibrary("zzAddOn"):Embed(addon[addon['childName']])