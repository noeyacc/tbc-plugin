local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local events = {}
local skipRetail = {}
local db
local playerID,guildID
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemInfo = GetContainerItemInfo
local format = string.format
local sync = {}
local L = LibStub("AceLocale-3.0"):GetLocale(childName, true)
LibStub("zzHelper"):Embed(child)
local function prepareDB()
	db = addon['db']['profile'][childName]
	child['db'] = db
	addon['callbacks']:Fire(format("Init%s", childName))
end
function child:funcSync(func, delayed)
	local st = GetTime()
	if(delayed and sync[func]['times'][delayed]) then
		sync[func]['times'][delayed] = nil
	end
	sync[func] = sync[func] or {
		['last'] = 0,
		['times'] = {}
	}
	if(not (st == sync[func]['last'])) then
		sync[func]['last'] = st
		return true
	else
		if(not sync[func]['times'][st]) then
			sync[func]['times'][st] = true
			C_Timer.After(.1, function() func(st) end)
		end
		return
	end	
end
function child:GetNamespace(namespace)
	if(namespace) then
		db[namespace] = db[namespace] or {}
		return db[namespace]
	end
end
function child:AddEvent(evTable, func)
	if(type(evTable) == 'table') then
		for k, v in pairs(evTable) do
			if(type(v) == 'function') then
				self:AddEvent(k, v)
			elseif(type(v) == 'string' and type(func) == 'function') then
				self:AddEvent(v, func)
			end
		end
	else
		events[evTable] = func
	end
end
function child:IgnoreRetail(ign)
	skipRetail[ign] = true
end
child['specs']  = {
	['name'] = childName,
	['sv'] = true,
	['cfg'] = true,
	['cfgReset'] = prepareDB,
	['ldb'] = child['ldb'],
	['defaults'] = {
		['profile'] = {
			[childName] = {
				['bagsToggle'] = true,
				['bankToggle'] = true,
				['charToggle'] = true,
				['mailToggle'] = true,
				['bagsTooltip'] = true,
				['bankTooltip'] = true,
				['charTooltip'] = true,
				['mailTooltip'] = true,
				['showID'] = true,
				['icons'] = {},
				['names'] = {},
				['currencies'] = {},
				['bags'] = {},
				['bank'] = {},
				['guildbank'] = {},
				['units'] = {},
				['guilds'] = {},
				['mail'] = {},
				['CraftTipScale'] = 0.9
			}
		}
	}
}
local function OnEvent(lib, self, event, ...)
	if(type(events[event])=='function') then
		events[event](self,event,...)
	else
		print("[itemsdb] Failed", ...)
	end
end
function child.events:PLAYER_ENTERING_WORLD(event)
	child:UnregisterEvent('PLAYER_ENTERING_WORLD')
	local list = {}
	for event,func in pairs(events) do
		if(child:IsClassic() or (not child:IsClassic() and not skipRetail[event])) then
			list[#list+1] = event
		end
	end
	child:RegisterEvent(list, OnEvent)
end
child:NewAddOn(...)