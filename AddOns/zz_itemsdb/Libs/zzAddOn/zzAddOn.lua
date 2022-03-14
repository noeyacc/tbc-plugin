local lib = LibStub:NewLibrary("zzAddOn", 10)
if not lib then return end
local config = LibStub:GetLibrary("zzConfig")
lib['callbacks'] = lib['callbacks'] or LibStub:GetLibrary("CallbackHandler-1.0"):New(lib)
lib['addons'] = lib['addons'] or {}
lib['events'] = lib['events'] or CreateFrame("FRAME")
local function errormsg(err)
	print(format("|cffff0000Error:|r %s",err))
end
local mixins = {'NewAddOn', 'GetAddOn', 'AddChild', 'HasChild', 'IsChild', 'HasParent', 'GetParent', 'GetOptions', 'RegisterEvent','UnregisterEvent','IsClassic','IsBCC','IsRetail', 'GetSpecs', 'Fire'}
function lib:Fire(...)
	lib['callbacks']:Fire(...)
end
function lib:GetAddOn(childName)
	return lib['addons'][childName]
end
function lib:GetOptions()
	return self['options']
end
function lib:GetParent()
	return self['parent']
end
function lib:HasParent()
	return self['parent'] and true or false
end
function lib:IsChild()
	return self:HasParent()
end
function lib:HasChild()
	return self['children'] and #self['children'] > 0
end
function lib:GetSpecs(childName)
	return lib['addons'][childName]['specs']
end
local function joinTables(tab1, tab2, prefix)
	prefix = prefix or ''
	for k, v in pairs(tab2) do
		if(tab1[k] and type(v) == 'table') then
			joinTables(tab1[k], v, format("%s  ", prefix))
		else
			tab1[k] = v
		end
	end
end
local function childExists(parent, child)
	if(parent['children']) then
		for i = 1, #parent['children'] do
			if(parent['children'][i]['specs']['name'] == child['specs']['name']) then return true end
		end
	end
end
function lib:AddChild(parentName, child)
	local parent = self:GetAddOn(parentName)
	if(parent) then
		parent['children'] = parent['children'] or {}
		if(childExists(parent, child)) then return end
		child['parent'] = parent
		parent['children'][#parent['children'] + 1] = child
		if(child['specs']['defaults']) then
			joinTables(parent['specs']['defaults'], child['specs']['defaults'])
		end
	end
end
function lib:RegisterEvent(event, globalfunc)
	if(type(event) == 'table') then
		for k, v in pairs(event) do
			local ev = k
			local func = v
			if(type(v) == 'string') then
				ev = v
				func = globalfunc
			end
			if(type(ev) == 'string' and type(func) == 'function' and not self['events'][ev]) then
				self['events'][ev] = func
			end
			self:RegisterEvent(ev, func)
		end
	elseif(type(event) == 'string') then
		if(not lib['events']:IsEventRegistered(event)) then
			lib['events']:RegisterEvent(event)
		end
		lib.RegisterCallback(self, event, globalfunc)
	else
		errormsg("ign reg", type(event), event)
	end
end
function lib:UnregisterEvent(event)
	if(type(event) == 'table') then
		for k, v in pairs(event) do
			local ev = type(v) == 'string' and v or k
			self:UnregisterEvent(ev)
		end
	else
		lib['UnregisterCallback'](self, event)
	end
end
function lib:IsBCC()
	return WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
end
function lib:IsClassic()
	return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end
function lib:IsRetail()
	return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end
function lib:NewAddOn(addonName, addonTable)
	local specs = self['specs']
	local childName = specs['name']
	if(type(childName) == 'string') then
		self.GetAddOnTable = function() return addonTable end
		lib['addons'][childName] = self
		local child = lib['addons'][childName]
		lib:Embed(self)
		if(childName ~= addonName) then
			local parent = lib['addons'][addonName]
			parent:AddChild(parent['specs']['name'], self)
		end
		if(self['events']) then
			for ev, func in pairs(self['events']) do
				if(type(func) == 'function') then
					self:RegisterEvent(ev, func)
				end
			end
		end
		return self
	end
end
function lib:Embed(target)
  for _,name in pairs(mixins) do
    target[name] = lib[name]
  end
end
for _, target in pairs(lib['addons']) do
  lib:Embed(target)
end
lib['events']:RegisterEvent('ADDON_LOADED')
local function addLDB(...)
	return LibStub:GetLibrary("zzLDB"):AddLDB(...)
end
local function addConfig(addonName, child, specs)
	local at = child:GetAddOnTable()
	if(addonName == child['specs']['name']) then
		config:InitConfig(child, addonName)
		child['options']['args']['profile'] = LibStub("AceDBOptions-3.0"):GetOptionsTable(at['db'])
	else
		config:AddConfig(child, addonName)
	end
	if(type(specs['cfgReset']) == 'function') then
		specs['cfgReset'](child)
		at['db'].RegisterCallback(specs, "OnProfileReset", 'cfgReset')
	end
end
local function SetupSpecs(addonName, child)
	local specs = child['specs']
	if(specs and specs['sv'] and not child['db']) then
		local dbname = format('%sDB', type(specs['sv']) == 'boolean' and addonName or specs['sv'])
		local at = child:GetAddOnTable()
		at['db'] = LibStub("AceDB-3.0"):New(dbname, type(specs['defaults']) == 'table' and specs['defaults'] or {}, 'Default')
		if(specs['ldb']) then
			addLDB(specs['name'], specs['ldb'], at['db'])
		end
		if(specs['cfg']) then
			addConfig(addonName, child, specs)
		end
		if(child:HasChild()) then
			for i = 1, #child['children'] do
				local child = child['children'][i]

				local childSpecs = child['specs']
				if(childSpecs['ldb']) then
					addLDB(childSpecs['name'], childSpecs['ldb'], at['db'])
				end
				if(childSpecs['cfg']) then
					addConfig(addonName, child, childSpecs)
				end			
			end
		end
	end	
end

lib['events']:SetScript("OnEvent", function(self, event, ...)
	local addonName = ...
	local child = lib['addons'][addonName]
	if(child) then
		if(event == 'ADDON_LOADED') then
			SetupSpecs(addonName, child)
		end
	end
	lib['callbacks']:Fire(event, self, event, ...)
end)