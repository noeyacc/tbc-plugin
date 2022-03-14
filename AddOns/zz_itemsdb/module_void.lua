local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local modulname = 'void'
local events = {}
local modul = {
    ['frame'] = CreateFrame("FRAME"),
	['name'] = modulname
}
local db
local voidOpen
local failCount = 0
local dName = format("%sCount", modulname)
local function scanVoid()
	if(not voidOpen) then return end
	local playerID = child.getPID()
	if(playerID) then
		local itemlist = {}
		local empty = true
		for tab = 1, 2 do
			for slot = 1, 80 do
				local id, icon = GetVoidItemInfo(tab, slot)
				if(id) then
					id = tonumber(id)
					empty = false
					itemlist[id] = itemlist[id] or {}
					itemlist[id]['count'] = (itemlist[id]['count'] or 0) + 1
					child:getName(id)
					child:setIcon(id, icon)		
				end
			end
		end
		local count = 0
		for k, v in pairs(itemlist) do
			count = count + 1
		end
		if(count == 0 and failCount < 3) then
			C_Timer.After(.2, scanVoid)
			failCount = failCount + 1
			return
		end
		failCount = 0
		modul['db'][playerID][0] = itemlist
	end
end
local function bagLoop(id, res)
	for k, v in pairs(modul['db']) do
		local units = child:GetNamespace('units')
		if(units[k]) then
			local playerID = child.getPID()
			if(playerID and units[k]['faction'] == units[playerID]['faction']) then
				local unitname = units[k]['name']
				for bag, list in pairs(v) do
					for a, b in pairs(list) do
						if(a == id) then
							res[unitname] = res[unitname] or {
								[dName] = 0
							}
							res[unitname][dName] = (res[unitname][dName] or 0) + b['count']
						end
					end
				end
			end
		end
	end
	return res
end
function modul.Search(id, res)
	local playerID = child.getPID()
	if(playerID) then
		modul['db'][playerID] = modul['db'][playerID] or {}
	end
	return playerID and bagLoop(id, res) or res
end
function modul.Output(input, sum, b)
	if(b[dName] and b[dName]>0) then
		input[#input + 1] = format("Void %s", b[dName])
		sum = sum + b[dName]					
	end
	return input, sum
end
function events:VOID_STORAGE_CLOSE()
	voidOpen = false
end
function events:VOID_STORAGE_OPEN()
	voidOpen = true
	scanVoid()
end
events.VOID_STORAGE_CONTENTS_UPDATE = scanVoid
events.VOID_STORAGE_DEPOSIT_UPDATE = scanVoid
events.ITEM_UNLOCKED = scanVoid
events.VOID_TRANSFER_DONE = scanVoid
local function OnEvent(self, event, ...)
	local playerID = child.getPID()
	if(playerID and type(events[event])=='function') then
		modul['db'] = child:GetNamespace(modul.name)
		modul['db'][playerID] = modul['db'][playerID] or {}
		events[event](self, event, ...)
	end
end
function modul:Delete(id, typ)
	self['db'] = child:GetNamespace(modul.name)
	if(typ == self['typ'] and id and id>0) then
		self['db'][id] = nil
	end
end
function modul:Enable()
	self['status'] = true
	local list = {}
	for event, func in pairs(events) do
		list[#list+1] = event
	end
    for i = 1, #list do
	    self['frame']:RegisterEvent(list[i])
    end
    self['frame']:SetScript("OnEvent", OnEvent)
end
function modul:Disable()
	self['status'] = false
	for event, func in pairs(events) do
		self['frame']:UnregisterEvent(event)
	end
end
child:IgnoreClassic(modulname)
child:IgnoreBCC(modulname)
local init = {
	Setup = function(self)
		db = child['db']
        modul.db, modul.status = child:RegisterModul(modul, modulname)
        if(modul.status) then
            modul:Enable()
        end
    end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')