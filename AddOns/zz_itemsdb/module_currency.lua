local _, addon = ...
local childName = addon['childName']
local child = addon[childName]
local modulname = 'currency'
local events = {}
local modul = {
    ['frame'] = CreateFrame("FRAME"),
	['name'] = modulname
}
local GetCurrencyListLink = GetCurrencyListLink
local GetCurrencyListSize = GetCurrencyListSize
local GetCurrencyListInfo = GetCurrencyListInfo
if(C_CurrencyInfo) then
	if(C_CurrencyInfo.GetCurrencyListLink) then
		GetCurrencyListLink = C_CurrencyInfo.GetCurrencyListLink
	end
	if(C_CurrencyInfo.GetCurrencyListSize) then
		GetCurrencyListSize = C_CurrencyInfo.GetCurrencyListSize
	end
	if(C_CurrencyInfo.GetCurrencyListInfo) then
		GetCurrencyListInfo = C_CurrencyInfo.GetCurrencyListInfo
	end
end
local function getCurrencyItem(index)
	local currencyLink = GetCurrencyListLink(index)
	if(currencyLink) then
		return tonumber(currencyLink:match("currency:(%d+)")) or nil
	end
end
local function GetMax(intable, ign)
    local mx = 0
    for unitname, v in pairs(intable) do
        for a, b in pairs(v) do
            if(not ign or b['count']<ign) then
                mx = max(mx, b['count'])
            end
        end
    end
    return mx
end
local function ordered(intable)
    local tmp = {}
    local lines = 0
    for unitname, v in pairs(intable) do
        tmp[unitname] = CopyTable(v)
        lines = lines + 1
    end
    local newtmp = {}
    local mx = GetMax(tmp)
    while lines > 0 do
        local found
        for unitname, v in pairs(tmp) do
            for a, b in pairs(v) do
                if(b['count'] == mx) then
                    found = true
                    newtmp[#newtmp + 1] = CopyTable(v)
                    newtmp[#newtmp][a]['name'] = unitname
                    lines = lines - 1
                end
            end
        end
        if(not found) then
            lines = 0
        else
            mx = GetMax(tmp, mx)
        end
    end
    return newtmp
end
function child:curLoop(res, id)
    local units = child:GetNamespace('units')
    local unordered = {}
	for k, v in pairs(modul['db']) do
		if(units and units[k]) then
			local unitname = units[k]['name']
			for a, b in pairs(v) do
                if(a == id and b['count'] > 0) then
                    unordered[unitname] = unordered[unitname] or {}
                    unordered[unitname][a] = CopyTable(b)
                end
			end
		end
	end
    for k, v in ipairs(ordered(unordered, id)) do
        for a, b in pairs(v) do
            local unitname = b['name']
            if(unitname) then
                if(b['max'] > 0) then
                    res[#res + 1] = {
                        text = child:colorize(format("%s/%s", b['count'], b['max']), b['count'] == b['max'] and "ff0000" or "ffffff"),
                        name = unitname
                    }
                else
                    res[#res + 1] = {
                        text = child:colorize(format("%s", b['count']), "ffffff"),
                        name = unitname
                    }
                end
            end
        end
    end
	return res
end
local function SetCurrencyByID(tooltip, itemID)
	if(itemID) then
		local res = child:curLoop({},itemID)
		if(type(res) == 'table') then
            local tName = format("%sTooltip", modul.name)
			tooltip:AddLine(" ")
			for i, b in ipairs(res) do
				if(child['db'][tName]) then
                    local curName = b['name']
					tooltip:AddLine(format("%s %s: %s", child:getIcon(itemID), curName, b['text']))
				end
			end
		end
		tooltip:Show()
	end
	return tooltip, itemID
end
local function SetCurrencyToken(tooltip, index)
	SetCurrencyByID(tooltip, getCurrencyItem(index))
end
local function GameTooltip_SetHyperlink(tooltip, link)
	SetCurrencyByID(tooltip, tonumber(link:match("currency:(%d+)")))
end
function events:CURRENCY_DISPLAY_UPDATE(event)
	local playerID = child.getPID()
	if(playerID) then
		modul['db'][playerID] = modul['db'][playerID] or {}
		local tab = modul['db'][playerID]
		for index = 1, GetCurrencyListSize() do
			local curInfo
			if(C_CurrencyInfo and C_CurrencyInfo.GetCurrencyListInfo) then
				curInfo = GetCurrencyListInfo(index)
			else
				local curName, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount = GetCurrencyListInfo(index)
				curInfo = {
					['isHeader'] = isHeader,
					['quantity'] = count,
					['iconFileID'] = icon,
					['maxQuantity'] = maximum
				}
			end
			local itemID = getCurrencyItem(index)
			if((not curInfo['isHeader']) and itemID) then
				tab[tonumber(itemID)] = {
					['count'] = curInfo['quantity'],
					['max'] = curInfo['maxQuantity'],
				}
				child:setIcon(itemID, curInfo['iconFileID'])
			end
		end
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
local skip = {
	[WOW_PROJECT_CLASSIC] = {
		['CURRENCY_DISPLAY_UPDATE'] = true
	}
}
if(WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	dkip[WOW_PROJECT_BURNING_CRUSADE_CLASSIC] = {
		['PLAYERREAGENTBANKSLOTS_CHANGED'] = true
	}
end
function modul:Enable()
	if(child:IsRetail()) then
		self.status = true
		local list = {}
		for event, func in pairs(events) do
			if(not skip[WOW_PROJECT_ID] or not skip[WOW_PROJECT_ID][event]) then
				list[#list+1] = event
			end
		end
        for i = 1, #list do
            self['frame']:RegisterEvent(list[i])
        end
        self['frame']:SetScript("OnEvent", OnEvent)
		OnEvent(self.frame, "CURRENCY_DISPLAY_UPDATE")
		hooksecurefunc(GameTooltip, "SetCurrencyByID", SetCurrencyByID)
		hooksecurefunc(GameTooltip, "SetCurrencyToken", SetCurrencyToken)
		hooksecurefunc(GameTooltip,"SetHyperlink", GameTooltip_SetHyperlink)
	else
		self.status = false
	end
end
function modul:Disable()
    self.status = false
    for event, func in pairs(events) do
        if(not child:IsClassic() or (child:IsClassic() and not skipClassic[event])) then
           self.frame:UnregisterEvent(event)
        end
    end
end
child:IgnoreClassic(modulname)
child:IgnoreBCC(modulname)
local init = {
	Setup = function(self)
        modul.db, modul.status = child:RegisterModul(modul, modulname)
        if(modul.status) then
            modul:Enable()
        end
    end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')