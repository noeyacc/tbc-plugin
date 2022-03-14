local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local modulname = 'bank'
local events = {}
local modul = {
    ['frame'] = CreateFrame("FRAME"),
	['name'] = modulname
}
local db
local desc = format('%sCount', modulname)
local desc2 = 'reagentCount'
local BankIsOpen = false
function modul.Guess(id)
	local dbcount = modul.Get(id)
	local count = GetItemCount(id,true)
	local playerID = child.getPID()
	local tt = false
	if(playerID and dbcount > count) then
		local dif = dbcount - count
		modul['db'][playerID] = modul['db'][playerID] or {}
		local tab = modul['db'][playerID]
		for bag = 5, GetNumBankSlots() + 4 do
			local btab = tab[bag]
			if(btab and btab[id] and btab[id]['count'] > 0) then
				while(dif > 0 and btab[id]['count'] > 0) do
					tt = true
					dif = dif - 1
					btab[id]['count'] = btab[id]['count'] - 1
					if(btab[id]['count'] == 0) then
						btab[id] = nil
					end
				end
			end
		end
	end
	if(tt) then
		child:updateTT()
	end
end
local function guess(bag)
	if(bag) then
		for id, v in pairs(bag) do
			local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, isCraftingReagent = GetItemInfo(id)
			if(isCraftingReagent) then
				modul.Guess(id)
			end
		end
	end
end
local function scanAllBankBags(delayed)
	if(not child:funcSync(scanAllBankBags, delayed)) then return end
	local playerID = child.getPID()
	if(playerID) then
		modul['db'][playerID] = modul['db'][playerID] or {}
		local tab = modul['db'][playerID]
		for bag=5,GetNumBankSlots()+4 do
			tab[bag] = tab[bag] or {}
			if(BankIsOpen) then
				tab[bag] = child:scanBag(bag) -- loop all bought bankbags
			else
				guess(tab)
			end
		end
		if(BankIsOpen) then
			tab[-1] = child:scanBag(-1) -- Main bankbag
		else
			guess(tab[-1])
		end
		tab[-3] = child:scanBag(-3) -- Main reagentbag
		for k,v in pairs(modul['db'][playerID]) do
			if(not(k == -1) and not(k == -3) and not(k > 4 and k <= GetNumBankSlots() + 4)) then
				tab[k] = nil -- prevent bogus bankbags
			end
		end
		child:updateTT()
	end
end
local function bagLoop(id, res)
	local dName = desc
	local units = child:GetNamespace('units')
	local playerID = child.getPID()
	for k,v in pairs(modul['db']) do
		if(units[k]) then
			if(playerID and units[k]['faction'] == units[playerID]['faction']) then
				local unitname = units[k]['name']
				for bag, list in pairs(v) do
					dName = (bag == -3) and desc2 or desc
					for a, b in pairs(list) do
						if(a == id) then
							res[unitname] = res[unitname] or {
								[dName] = 0
							}
							res[unitname][dName] = res[unitname][dName] or 0
							res[unitname][dName] = res[unitname][dName] + b['count']
						end
					end
				end
			end
		end
	end
	return res
end
function modul.Get(id)
	local dName = desc
	local res = 0
	local playerID = child.getPID()
	for k, v in pairs(modul['db']) do
		if(playerID and k == playerID) then
			for bag, list in pairs(v) do
				for a, b in pairs(list) do
					if(a == id) then
						res = res + b['count']
					end
				end
			end
		end
	end
	return res
end


function events:BANKFRAME_OPENED()
	BankIsOpen = true
	scanAllBankBags()
end
function events:BANKFRAME_CLOSED()
	BankIsOpen = false
end
function events:PLAYERBANKBAGSLOTS_CHANGED(...)
	scanAllBankBags()
end
events.PLAYERBANKSLOTS_CHANGED = events.PLAYERBANKBAGSLOTS_CHANGED
events.PLAYERREAGENTBANKSLOTS_CHANGED = events.PLAYERBANKBAGSLOTS_CHANGED
events.ITEM_UNLOCKED = events.PLAYERBANKBAGSLOTS_CHANGED
events.BAG_UPDATE_DELAYED = events.PLAYERBANKBAGSLOTS_CHANGED
local function OnEvent(self, event, ...)
--    print(modulname, event, ...)
	local playerID = child.getPID()
	if(playerID and type(events[event])=='function') then
		modul['db'] = child:GetNamespace(modul.name)
		modul['db'][playerID] = modul['db'][playerID] or {}
		events[event](self, event, ...)
	end
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
		input[#input+1] = format("Bank %s", b[desc])
		sum = sum + b[desc]
	end
	if(b[desc2] and b[desc2] > 0) then
		input[#input+1] = format("Reagents %s", b[desc2])
		sum = sum + b[desc2]					
	end
	return input,sum
end
function modul:Delete(id, typ)
	self['db'] = child:GetNamespace(modul.name)
	if(typ == self['typ'] and id and id>0) then
		self['db'][id] = nil
	end
end
local skip = {
	[WOW_PROJECT_CLASSIC] = {
		['PLAYERREAGENTBANKSLOTS_CHANGED'] = true
	}
}
if(WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	skip[WOW_PROJECT_BURNING_CRUSADE_CLASSIC] = {
		['PLAYERREAGENTBANKSLOTS_CHANGED'] = true
	}
end
function modul:Enable()
	self['status'] = true
	local list = {}
	for event,func in pairs(events) do
		if(not skip[WOW_PROJECT_ID] or not skip[WOW_PROJECT_ID][event]) then
			list[#list+1] = event
		end
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