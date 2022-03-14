local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local ignItems = {}
local events, db = {}
local function setName(id, itemname)
	if(id and itemname) then
		local names = child:GetNamespace('names')
		names[tonumber(id)] = itemname
	end
end
function child:getName(id)
	db = child['db']
	local names = child:GetNamespace('names')
	if(not names[tonumber(id)]) then
		setName(id, C_Item.GetItemNameByID(id))
	end
	return db['names'][id]
end
function child:setIcon(id, icon)
	if(id and icon) then
		local icons = child:GetNamespace('icons')
		icons[tonumber(id)] = format("|T%s:0|t", icon)
	end
end
function child:getIcon(id)
	id = tonumber(id)
	if(id and not db['icons'][id]) then
		local itemName = C_Item.GetItemNameByID(id)
		local icon = C_Item.GetItemIconByID(id)
		setName(id,itemName)
		child:setIcon(id,icon)
	end
	return db['icons'][id] or ''
end
function events:GET_ITEM_INFO_RECEIVED(event, id)
	if(id and id>0) then
		if(ignItems[id]) then return end
		local itemName = C_Item.GetItemNameByID(id)
		if(itemName) then
			setName(id,itemName)
		else
			ignItems[id] = true
		end
	end
end
events.ITEM_DATA_LOAD_RESULT = events.GET_ITEM_INFO_RECEIVED
child:AddEvent(events)
local init = {
	Setup = function(self)
		db = child['db']
	end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')