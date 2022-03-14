local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local db
local config = LibStub:GetLibrary("zzConfig")
local L = LibStub("AceLocale-3.0"):GetLocale(childName, true)
local done = true
local function getChars()
	local chars = {}
	for k, v in pairs(db['units']) do
		chars[k] = v['name']
	end
	return chars
end
local function deleteChar()
	local cid = db['selectCID']
	if(cid and cid > 0) then
		for k, modul in pairs(child['moduls']) do
			modul:Delete(cid)
		end
		db['units'][cid] = nil
		db['selectCID'] = nil
		db['deleteCID'] = nil
		child:ResetPID()
	end
end
local function getGuilds()
	local guilds = {}
	for k, v in pairs(db['guilds']) do
		guilds[k] = v['name']
	end
	return guilds
end
local function deleteGuild()
	local gid = db['selectGID']
	if(gid and gid > 0) then
		for k, modul in pairs(child['moduls']) do
			modul:Delete(gid, 'guild')
		end
		db['guilds'][gid] = nil
		db['selectGID'] = nil
		db['deleteGID'] = nil
	end
end
local function deleteNames()
	db['names'] = {}
end
local function deleteIcons()
	db['icons'] = {}
end
local function setup()
	if(done) then
		done = nil
	else
		return
	end
	local options = child['options']
	local main = options['args'][childName]
	config:AddConfigEntry(main, "ModulGroup", "group", L['pref_modul_header'], L['pref_modul_desc'], 1, nil, true)
	config:AddConfigEntry(main, "ModulTooltip", "group", L['pref_tooltip_header'], L['pref_tooltip_desc'], 1, nil, true)
	config:AddConfigEntry(main, "showID", "toggle", L['pref_itemid_header'], L['pref_itemid_desc'], 1, nil, true)

	if(child:IsClassic()) then
		local ct = config:AddConfigEntry(main,"CraftTip","group",L['pref_crafttip_header'],L['pref_crafttip_desc'],3, nil, true)
		config:AddConfigEntry(ct, "donthookCraftFrame", "toggle", L['pref_donthookCraftFrame_header'], L['pref_donthookCraftFrame_desc'],1)
		config:AddConfigEntry(ct, "CraftTipScale", "range", L['pref_crafttipscale_header'], L['pref_crafttipscale_desc'], 2, 0.01, 1, .01)
	end
	local menudb = config:AddConfigMenu(options, L['Database'], 20)
	config:AddConfigEntry(menudb,"deleteNames","execute",L['pref_maint_names_del_header'],L['pref_maint_names_del_desc'],2,deleteNames)
	config:AddConfigEntry(menudb,"deleteIcons","execute",L['pref_maint_icons_del_header'],L['pref_maint_icons_del_desc'],2,deleteIcons)
	local menuchar = config:AddConfigMenu(menudb, L['Character'], 10)
	config:AddConfigEntry(menuchar,"selectCID","select",L['pref_maint_char_header'],L['pref_maint_char_desc'],1,getChars)
	config:AddConfigEntry(menuchar,"deleteCID","execute",L['pref_maint_char_del_header'],L['pref_maint_char_del_desc'],2,deleteChar)
	if(not child:IsClassic()) then
		local menuguild = config:AddConfigMenu(menudb, L['Guild'], 20)
		config:AddConfigEntry(menuguild,"selectGID","select",L['pref_maint_guild_header'],L['pref_maint_guild_desc'],1,getGuilds)
		config:AddConfigEntry(menuguild,"deleteGID","execute",L['pref_maint_guild_del_header'],L['pref_maint_guild_del_desc'],2,deleteGuild)
	end
end
function child:AddToConfig(namespace)
	setup()
	local options = child['options']
	local main = options['args'][childName]
	config:AddConfigEntry(main['args']["ModulGroup"], format("%sToggle", namespace), "toggle", namespace, L['pref_modul_toggle'](namespace),1)
	config:AddConfigEntry(main['args']["ModulTooltip"], format("%sTooltip", namespace), "toggle", namespace, L['pref_tooltip_toggle'](namespace),1)
end
local init = {
	Setup = function(self)
		db = child['db']
		setup()
	end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')