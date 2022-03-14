local lib = LibStub:NewLibrary("zzConfig", 6)
if not lib then return end
local ldbicon = LibStub:GetLibrary("LibDBIcon-1.0")
local mixins = {'AddConfigMenu', 'AddConfigEntry', 'InitConfig', 'GetDefaultHandler'}
lib['configs'] = lib['configs'] or {}
local function getDB(objname)
	if(ldbicon) then
		ldbicon:Show(objname)
		local iconbtn = ldbicon:GetMinimapButton(objname)
		if(iconbtn) then
			local db = iconbtn['db']
			if(db['hide']) then
				ldbicon:Hide(objname)
			end
			return db
		else
--			print("noicon", objname)
		end
	end
	return {}
end
local function minimapGet(pref)
	local objname = pref[#pref - 2]
	local db = getDB(objname)
	return db[pref[#pref]]
end
local function minimapSet(pref,value)
	local objname = pref[#pref - 2]
	local db = getDB(objname)
	db[pref[#pref]] = value
end
local function notify(pref, value, oldvalue)
	if(type(pref['handler'].PrefChanged) == 'function') then
		pref['handler']:PrefChanged(pref, value, oldvalue)
	end
end
local function getPref(pref)
	if(type(pref['handler']['GetPref']) == 'function') then
		return pref['handler']:GetPref(pref)
	end
	local db = pref['handler']['db'] or pref['handler']:GetAddOnTable()['db']['profile'][pref['appName']]
	return db and db[pref[#pref]]
end
local function setPref(pref, value, ...)
	if(type(pref['handler']['SetPref']) == 'function') then
		pref['handler']:SetPref(pref, value, ...)
	else
		local db = pref['handler']['db'] or pref['handler']:GetAddonTable()['db']['profile'][pref[#pref-1]]
		local oldvalue = db[pref[#pref]]
		db[pref[#pref]] = value
		if(value ~= oldvalue) then
			notify(pref, value, oldvalue)
		end
	end
end
local function GDH_GetPref(self, pref)
		return self['db'][pref[#pref]]
end
local function GDH_SetPref(self, pref, value)
	self['db'][pref[#pref]] = value
	if(type(self['func']) == 'function') then
		self['func'](self)
	end
end
function lib:GetDefaultHandler(func, db)
	return  {
		['db'] = db,
		['func'] = func,
		SetDB = function(self, db) self.db = db end,
		GetPref = GDH_GetPref,
		SetPref = GDH_SetPref,
	}
end
function lib:AddLDBIconOptions(options, conf)
	options['args'][conf] = {
		['name']="Minimapicon",
		['type']='group',
		['inline']=true,
		['get'] = minimapGet,
		['set'] = minimapSet,
		['order'] = 100,
		['args']={
			['hide'] ={
				['type'] = 'toggle',
				['name'] = "Hide Minimapicon",
			},
			['minimapPos'] ={
				['type'] = 'range',
				['name'] = "Minimapicon Position",
				['min'] = 1,
				['max'] = 250,
				['step']=1,
			}
		}
	}
end
function lib:AddConfigEntry(options, ...)
	local input = {...}
	if(input) then
		local menu = {
			['type'] = input[2],
			['name'] = input[3],
			['desc'] = input[4],
			['order'] = input[5]
		}
		if(input[2] == 'range') then
			menu['min'] =  input[6]
			menu['max'] =  input[7]
			menu['step'] = input[8]
			menu['isPercent'] =  input[9]
		elseif(input[2] == 'execute') then
			menu['func'] =  input[6]
		elseif(input[2] == 'color') then
			menu['get'] =  input[6]
			menu['set'] =  input[7]
			menu['hasAlpha'] = true
		elseif(input[2] == 'select') then
			menu['values'] = input[6]
		elseif(input[2] == 'group') then
			menu['inline'] = input[7]
			menu['handler'] = input[6]
			menu['args'] = {
				['description'] = {
					['name'] = input[4],
					['type'] = 'header',
					['order'] = 0
				},
			}
		end
		options['args'][input[1]] = menu
		return menu
	end
end
function lib:AddConfigMenu(options, parentName, order, handler, more)
	local menu = {
		['name'] = parentName,
		['type'] = 'group',
		['handler'] = handler or self['handler'],
		['childGroups'] = 'tab',
		['order'] = order or 1,
		['args'] = {}	
	}
	if(more) then
		for k, v in pairs(more) do
			menu[k] = v
		end
	end
	options['args'][parentName] = menu
	return options['args'][parentName]
end
lib.AddedToBlizz = lib.AddedToBlizz or {}
local function addToBlizz(pName, cName)
	if(not lib['AddedToBlizz'][pName]) then
		lib['AddedToBlizz'][pName] = true
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions(pName, pName, cName)
	end
end
function lib:InitConfig(child, parentName, gp, sp)
	child['options'] = {
		['name'] = parentName,
		['type'] = 'group',
		['handler'] = child,
		['childGroups'] = 'tab',
		['get'] = gp or getPref,
		['set'] = sp or setPref,
		['args'] = {}
	}
	local options = child['options']
	local par = self:AddConfigMenu(options, parentName)
	self:AddLDBIconOptions(par, 'minimap')
	LibStub("AceConfig-3.0"):RegisterOptionsTable(parentName, options)
	addToBlizz(parentName, child['parentName'])
	return options
end
function lib:AddConfig(child, parentName, gp, sp)
	local specs = child['specs']
	child['options'] =  {
		['name'] = specs['name'],
		['type'] = 'group',
		['handler'] = child,
		['childGroups']='tab',
		['get']=gp or getPref,
		['set']=sp or setPref,
		['args'] = {}
	}
	local par = self:AddConfigMenu(child['options'], specs['name'])
	self:AddLDBIconOptions(par, 'minimap')
	LibStub("AceConfig-3.0"):RegisterOptionsTable(specs['name'], child['options'])
	addToBlizz(specs['name'], parentName)
	return child['options']
end
function lib:Embed(target)
  for _,name in pairs(mixins) do
    target[name] = lib[name]
  end
end
for target, _ in pairs(lib['configs']) do
  lib:Embed(target)
end
