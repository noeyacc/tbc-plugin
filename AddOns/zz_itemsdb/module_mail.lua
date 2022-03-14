local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local modulname = 'mail'
local events = {}
local modul = {
    ['frame'] = CreateFrame("FRAME"),
	['name'] = modulname
}
local desc = format('%sCount', modulname)
local mailOpen = false
local db
--[[CLOSE_INBOX_ITEM: mailIndex
MAIL_CLOSED
MAIL_FAILED: itemID
MAIL_INBOX_UPDATE
MAIL_LOCK_SEND_ITEMS: attachSlot, itemLink
MAIL_SEND_INFO_UPDATE
MAIL_SEND_SUCCESS
MAIL_SHOW
MAIL_SUCCESS: itemID
MAIL_UNLOCK_SEND_ITEMS
SEND_MAIL_COD_CHANGED
SEND_MAIL_MONEY_CHANGED
UPDATE_PENDING_MAIL
]]
local function scan()
	if(not mailOpen) then return end
	local numItems, totalItems = GetInboxNumItems()
--	print("Found",numItems, totalItems)
	local playerID = child.getPID()
	local db = modul['db'][playerID]
	db[1] = {}
	for index = 1, numItems do
		local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned, 
		textCreated, canReply, isGM = GetInboxHeaderInfo(index)
--		print("Index", index, hasItem)
		if(hasItem) then

--			print("Mail has item", index)
			for itemIndex = 1, ATTACHMENTS_MAX_RECEIVE do
				local name, itemID, texture, count, quality, canUse  = GetInboxItem(index, itemIndex)
				if(name) then
					db[1][itemID] = db[1][itemID] or {
						['count'] = 0,
					}
					db[1][itemID]['count'] = db[1][itemID]['count'] + count
				end
			end
		end
	end
end
function events:MAIL_INBOX_UPDATE()
--	print("MIU")
	scan()
end
function events:MAIL_FAILED()
--	print('failed')
end
function events:MAIL_CLOSED()
--	print('closed')
	mailOpen = false
end
function events:MAIL_SEND_SUCCESS()
--	print("mail_send_success")
end
function events:MAIL_SUCCESS(event, itemID) --fires along with MAIL_SEND_SUCCESS, itemID always nil, fires when deleting mail
	scan()
end
function events:MAIL_SEND_INFO_UPDATE() -- item changed
 --   print("update")
	for index = 1, ATTACHMENTS_MAX_SEND do
		local name, itemID, texture, count, quality = GetSendMailItem(index)
		if name then
--		   print("You are sending",  name, "x", count)
		end
	 end

end
--[[function events:SEND_MAIL_COD_CHANGED() -- price added
    print("cod changed")
end]]
function events:MAIL_LOCK_SEND_ITEMS(event, attachSlot, itemLink)
 --   print(event, attachSlot, itemLink)
end
function events:UPDATE_PENDING_MAIL()
 --   print("Update pending mail")
end
function events:MAIL_SHOW()
 --   print("Mail show")
	mailOpen = true
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
local function bagLoop(id, res)
	for k, v in pairs(modul['db']) do
		local units = child:GetNamespace('units')
		if(units[k]) then
			local playerID = child.getPID()
			if(playerID and units[k]['faction'] == units[playerID]['faction']) then
				local unitname = units[k]['name']
				for bag,list in pairs(v) do
					for a,b in pairs(list) do
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
	if(b[desc] and b[desc]>0) then
		input[#input+1] = format("Mail %s",b[desc])
		sum = sum + b[desc]					
	end
	return input,sum
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