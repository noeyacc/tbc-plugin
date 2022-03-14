local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local modulname = 'char'
local events = {}
local modul = {
    ['frame'] = CreateFrame("FRAME"),
	['name'] = modulname
}
local db
local desc = format('%sCount', modulname)
local playerID = false
function child:getPID()
	if(playerID) then
		return playerID
	end
	local pname, pserver = UnitFullName("player")
	if(not pserver) then
		return
	end
	local player = format("%s - %s", pname, pserver)
	playerID = 0
	local units = child:GetNamespace('units')
	for k,v in pairs(units) do
		if(v['name']==player) then
			playerID = k
			return playerID
		end
		if(k>=playerID) then
			playerID = k
		end
	end
	playerID = playerID + 1
	units[playerID]= {
		['name'] = player,
		['faction'] = UnitFactionGroup('player')
	}
	return playerID
end
function child:ResetPID()
	playerID = nil
	child:getPID()
end
local function scanChar()
	local itemlist = {}
	local empty = true
	for i=1,19 do
		local id = GetInventoryItemID("player", i)
		if(id) then
			empty = false
			itemlist[id] = itemlist[id] or {}
			itemlist[id]['count'] = (itemlist[id]['count'] or 0) + 1
			child:getName(id)
		end
	end
	return empty and nil or itemlist
end
local function bagLoop(id,res)
	for k,v in pairs(modul['db']) do
		local units = child:GetNamespace('units')
		if(units[k]) then
			local playerID = child.getPID()
			if(playerID and units[k]['faction']==units[playerID]['faction']) then
				local unitname = units[k]['name']
				for bag,list in pairs(v) do
					for a,b in pairs(list) do
						if(a == id) then
							res[unitname] = res[unitname] or {
								[desc] = 0
							}
							res[unitname][desc] = (res[unitname][desc] or 0) + b['count']
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
	return playerID and bagLoop(id,res) or res
end
function modul.Output(input,sum,b)
	if(b[desc] and b[desc]>0) then
		input[#input+1] = format("Equip %s",b[desc])
		sum = sum + b[desc]					
	end
	return input,sum
end
function events:PLAYER_EQUIPMENT_CHANGED(event,...)
	local playerID = child.getPID()
	if(playerID) then
		modul['db'][playerID][0] = scanChar(nil)
	end
end
function events:ITEM_UNLOCKED(event,...)
	local playerID = child.getPID()
	if(playerID) then
		modul['db'][playerID][0] = scanChar(nil)
	end
end
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
	self.status = true
	local list = {}
	for event,func in pairs(events) do
		list[#list+1] = event
	end
	for i = 1, #list do
		self['frame']:RegisterEvent(list[i])
	end
	OnEvent(child, "PLAYER_EQUIPMENT_CHANGED")
end
function modul:Disable()
	self.status = false
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