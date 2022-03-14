local lib = LibStub:NewLibrary("zzLDB", 4)
if not lib then return end
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local ldbicon = LibStub:GetLibrary("LibDBIcon-1.0")
local mixins = {'AddLDB', 'GetLDB', 'DefaultOnClick', 'DefaultOnText'}
local defaults = {
	['hide'] = false,
}
lib['ldbs'] = lib['ldbs'] or {}
local function proto_OnClick(self, button)
--	print("onclick required", self, button)
end
function lib:DefaultOnClick(_, button, addon, childName)
	if(IsShiftKeyDown() and button == "LeftButton") then
		local sb = addon['db']['global']['ldbicons']
		sb[childName]['hide'] = not sb[childName]['hide']
		if(ldbicon) then
			if(sb[childName]['hide']) then 
				ldbicon:Hide(childName)
			else
				ldbicon:Show(childName)
			end
		end
	else
		if(InterfaceOptionsFrame:IsVisible() and not InCombatLockdown()) then
			InterfaceOptionsFrame:Hide()
		else
			InterfaceOptionsFrame_OpenToCategory(childName)
			InterfaceOptionsFrame_OpenToCategory(childName) -- Twice because of a bug in InterfaceOptionsFrame_OpenToCategory
		end
	end
end
function lib:DefaultOnText(objname, message)
	local ldbobj = lib:GetLDB(objname)
	if(ldbobj['text'] ~= message) then
		ldbobj['text'] = message
	end
end
function lib:GetLDB(objname)
	return ldb:GetDataObjectByName(objname)
end
function lib:AddLDB(objname, obj, db)
	local obj = obj or {}
	obj['type'] = obj['type'] or 'launcher'
	obj['text'] = obj['text'] or objname
	if(obj['type '] == 'launcher') then
		obj['OnClick'] = obj['OnClick'] or proto_OnClick
	end
	if(ldb) then
		local ldbobj = ldb:GetDataObjectByName(objname) or ldb:NewDataObject(objname, obj)
		if(ldbobj) then
			if(not ldbicon:IsRegistered(objname)) then
				db['global']['ldbicons'] = db['global']['ldbicons'] or {}
				local sb = db['global']['ldbicons']
				sb[objname] = sb[objname] or CopyTable(defaults)
				local oldstatus = sb[objname]['hide']
				sb[objname]['hide'] = false
				ldbicon:Register(objname, ldbobj, sb[objname])
				sb[objname]['hide'] = oldstatus
			end
			return ldbobj
		end
	end
end
function lib:Embed(target)
  for _,name in pairs(mixins) do
    target[name] = lib[name]
  end
  lib['ldbs'][target] = true
end
for target, _ in pairs(lib['ldbs']) do
  lib:Embed(target)
end