local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local modulname = 'guildbank'
local events = {}
local modul = {
    ['frame'] = CreateFrame("FRAME"),
    ['typ'] = 'guild',
	['name'] = modulname
}
local db
local GuildBankIsOpen = false
local failCount = 0
local lgbc, guildID
local dName = format("%sCount", modulname)
function child:getGID()
	local pname, pserver = UnitFullName("player")
	if(not pserver) then
		return
	end
	local guildName, guildRankName, guildRankIndex, guildRealm = GetGuildInfo("player")
	guildID = 0
	if(not guildName) then return end
	local guild = format("%s - %s", guildName, guildRealm and guildRealm or pserver)
	local guilds = child:GetNamespace('guilds')
	for k, v in pairs(guilds) do
		if(v['name'] == guild) then
			guildID = k
			return guildID
		end
		if(k >= guildID) then
			guildID = k
		end
	end
	guildID = guildID + 1
	guilds[guildID]= {
		['name'] = guild,
		['faction'] = UnitFactionGroup('player')
	}
	return guildID	
end
function child:checkGID()
	if(not guildID) then
		guildID = child:getGID()
	end
	if(guildID and guildID > 0) then
		child:GetNamespace('guildbank')
		return true
	end
end
local function gbagLoop(id)
	local res = {}
	for k, v in pairs(modul['db']) do
		local guilds = child:GetNamespace('guilds')
		if(guilds[k]) then
			local guildID = child.getGID()
			if(guildID and guilds[k]['faction']==guilds[guildID]['faction'] or not guildID) then
				local guildname = guilds[k]['name']
				for bag, list in pairs(v) do
					for a, b in pairs(list) do
						if(a == id) then
							res[guildname] = res[guildname] or {
								[dName] = 0
							}
							res[guildname][dName] = res[guildname][dName] + b['count']
						end
					end
				end
			end
		end
	end
	return res
end
function modul.Search2(id, res, mode)
	local guildID = child.getGID()
	if(guildID) then
		modul['db'][guildID] = modul['db'][guildID] or {}
	end
	res = res or {}
	for guildname, b in pairs(gbagLoop(id)) do
		if(mode) then
			res[#res+1] = format(" %s: %s", child:colorize(guildname, "00ffff"), child:colorize(b[dName], "ffffff"))
		else
			res[#res+1] = format("%s %s: %s", child:getIcon(id), guildname, child:colorize(b[dName], "ffffff"))
		end
	end
	return res
end
local function scanGuildBank(tab)
	if(not tab) then return end
	local itemlist = {}
	for slot = 1, 98 do
		local texturePath, itemCount = GetGuildBankItemInfo(tab, slot)
		if(itemCount > 0) then
			local itemLink = GetGuildBankItemLink(tab, slot)
			if(itemLink) then
                local item = Item:CreateFromItemLink(itemLink)
				local id = item:GetItemID()
				if(id) then
					itemlist[id] = itemlist[id] or {}
					itemlist[id]['count'] = itemlist[id]['count'] or 0
					itemlist[id]['count'] = itemlist[id]['count'] + itemCount
					child:getName(id)
				end
			end
		end
	end
	local count = 0
	for k,v in pairs(itemlist) do
		count = count + 1
	end
	if(count==0 and failCount<3) then
		C_Timer.After(.2, function(tab) scanGuildBank(tab) end)
		failCount = failCount + 1
		return
	end
	failCount = 0
	return count==0 and nil or itemlist
end
function events:GUILDBANKBAGSLOTS_CHANGED()
	if(not child.checkGID() or not GuildBankIsOpen) then return end
	local tab = GetCurrentGuildBankTab()
	if(tab > 0) then
		local guildID = child.getGID()
		if(guildID) then
			local list = scanGuildBank(tab)
			if(list) then
				modul['db'][guildID][tab] = list
			end
		end
	end
end
function events:GUILDBANKFRAME_CLOSED()
	GuildBankIsOpen = false
end
function events:GUILDBANKFRAME_OPENED()
	GuildBankIsOpen = true
end
local function OnEvent(self, event, ...)
	local guildID = child.getGID()
	if(guildID and type(events[event])=='function') then
		modul['db'] = child:GetNamespace(modul.name)
		modul['db'][guildID] = modul['db'][guildID] or {}
		events[event](self, event, ...)
	end
end
local function lgbc_scan(page)
	local guildID = child.getGID()
	if(guildID and page) then
		local itemlist = {}
		for slot, link, stack in lgbc:IteratePage(page) do
			local id = GetItemInfoInstant(link)
			if(id) then
				itemlist[id] = itemlist[id] or {}
				itemlist[id]['count'] = itemlist[id]['count'] or 0
				itemlist[id]['count'] = itemlist[id]['count'] + stack
				child:getName(id)
			end
		end
		modul['db'][guildID][page] = itemlist
	end
end
local function lgbc_scanAll()
	for page = 1, lgbc:GetNumBankTabs() do
		lgbc_scan(page)
	end
end
function modul:OnPageSync(event, sender, page, guildName)
--	print(event, sender, page, guildName)
	local guildID = child.getGID()
	lgbc_scan(page)
end
function modul:Delete(id, typ)
	self['db'] = child:GetNamespace(modul.name)
	if(typ == self['typ'] and id and id>0) then
		self['db'][id] = nil
	end
end
function modul:Enable()
	if(child:IsRetail()) then
		self.status = true
		local list = {}
		for event, func in pairs(events) do
			list[#list+1] = event
		end
		lgbc = LibStub("LibGuildBankComm-1.0",true)
		if(lgbc) then
			lgbc.RegisterCallback(self, "GuildBankComm_PageUpdate", "OnPageSync")
		end
        for i = 1, #list do
            self['frame']:RegisterEvent(list[i])
        end
        self['frame']:SetScript("OnEvent", OnEvent)
	else
		self.status = false
	end
end
function modul:Disable()
	self.status = false
	if(not child:IsClassic()) then
		for event, func in pairs(events) do
			self.frame:UnregisterEvent(event)
		end
		if(lgbc) then
			lgbc.UnregisterCallback(self, "GuildBankComm_PageUpdate")
		end
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