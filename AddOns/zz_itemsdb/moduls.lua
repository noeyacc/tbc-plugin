local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
child['moduls'] = {}
local moduls = child['moduls']
local db
local skip = {
	[WOW_PROJECT_CLASSIC] = {}	
}
if(WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	skip[WOW_PROJECT_BURNING_CRUSADE_CLASSIC] = {}
end
function child:GetModul(modName)
	for k,modul in pairs(moduls) do
		if(modul.name==modName) then
			return modul
		end
	end
end
function child:IgnoreClassic(ign)
    skip[WOW_PROJECT_CLASSIC][ign] = true
end
function child:IgnoreBCC(ign)
	if(WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
	    skip[WOW_PROJECT_BURNING_CRUSADE_CLASSIC][ign] = true
	end
end
function child:RegisterModul(modul, namespace)
	moduls[#moduls+1] = modul
	if(not skip[WOW_PROJECT_ID] or not skip[WOW_PROJECT_ID][namespace]) then
        child:AddToConfig(namespace)
	else
		child['db'][namespace.."Toggle"] = nil
	end
	return self:GetNamespace(namespace), child['db'][namespace.."Toggle"]
end
function child:output(b)
	local input, sum = {}, 0
	for _, modul in pairs(moduls) do
		if(type(modul.Output)=='function') then
			if(child['db'][format('%sTooltip', modul.name)]) then
				input, sum = modul.Output(input,sum,b)
			end
		end
	end
	return input,sum
end
function child:specialoutput(tooltip, id)
	for _, modul in pairs(moduls) do
		if(type(modul.Search2)=='function' and child['db'][format('%sTooltip', modul.name)]) then
			local res = modul.Search2(id)
			if(res) then
				for _, v in pairs(res) do
					tooltip:AddLine(v)
				end
			end
		end
	end
end
function child:specialoutput2(id, res)
	for k, modul in pairs(moduls) do
		if(type(modul.Search2) == 'function') then
			res = modul.Search2(id, res, true)
		end
	end
	return res
end
function child:Search(id)
	local res = {}
	for _, modul in pairs(moduls) do
		if(modul.status and type(modul.Search) == 'function') then
			res = modul.Search(id, res)
		end
	end
	return res
end
local init = {
	Setup = function(self)
		db = child['db']
	end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')