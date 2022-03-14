local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local modulname = 'bags'
local events = {}
local modul = {
    ['frame'] = CreateFrame("FRAME"),
	['name'] = modulname
}
local db
local desc = format('%sCount', modulname)
function child:scanBag(bag)
	local slot = 1
	local itemlist = {}
	local empty = true
	while(slot<=GetContainerNumSlots(bag)) do
		local item = Item:CreateFromBagAndSlot(bag, slot)
		if(item) then
			local _, itemCount = GetContainerItemInfo(bag, slot)
            local id = item:GetItemID()
            if(id) then
                empty = false
                itemlist[id] = itemlist[id] or {}
                itemlist[id]['count'] = itemlist[id]['count'] or 0
                itemlist[id]['count'] = itemlist[id]['count'] + itemCount
                child:getName(id)
            end
		end
		slot = slot + 1
	end
	return empty and nil or itemlist
end
local function scanAllBags(delayed)
	if(not child:funcSync(scanAllBags, delayed)) then return end
	local playerID = child.getPID()
	if(playerID) then
		local tab = modul['db'][playerID]
		for bag=0,4 do
			tab[bag] = child:scanBag(bag) -- loop all bought bags
		end
		for k,v in pairs(modul['db'][playerID]) do
			if(k<0 or k>4) then
				tab[k] = nil -- prevent bogus bags
			end
		end
	end
end
local function bagLoop(id, res)
	local units = child:GetNamespace('units')
	local playerID = child.getPID()
	for k, v in pairs(modul['db']) do
		if(units[k]) then
			if(playerID and units[k]['faction'] == units[playerID]['faction']) then
				local unitname = units[k]['name']
				for bag, list in pairs(v) do
					for a, b in pairs(list) do
						if(a == id) then
							res[unitname] = res[unitname] or {
								[desc] = 0
							}
							res[unitname][desc] = res[unitname][desc] or 0
							res[unitname][desc] = res[unitname][desc] + b['count']
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
	if(b[desc] and b[desc] > 0) then
		input[#input+1] = format("Bags %s",b[desc])
		sum = sum + b[desc]					
	end
	return input, sum
end
function events:ITEM_UNLOCKED(event,...)
	scanAllBags(nil)
end
function events:BAG_UPDATE_DELAYED(event,...)
	scanAllBags(nil)
end
local function OnEvent(self, event, ...)
	local playerID = child.getPID()
--    print(modulname, event, ...)
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
	for event,func in pairs(events) do
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
local init = {
	Setup = function(self)
		db = child['db']
        modul.db,modul.status = child:RegisterModul(modul, modulname)
        if(modul.status) then
            modul:Enable()
        end
    end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')