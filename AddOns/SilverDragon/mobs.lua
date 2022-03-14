local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Mobs", "AceConsole-3.0")
local Debug = core.Debug

local function toggle_mob(id)
	return {
		arg = id,
		name = core:GetMobLabel(id),
		desc = "ID: " .. id,
		type = "toggle",
		-- width = "double",
		descStyle = "inline",
		order = id,
	}
end

local function input_to_mobid(value)
	if not value then return end
	value = value:trim()
	if value == "target" or value == "mouseover" then
		return core:UnitID(value)
	end
	if value:match("^%d+$") then
		return tonumber(value)
	end
	return core:IdForMob(value)
end
ns.input_to_mobid = input_to_mobid

local function mob_input(name, desc, order, setter)
	return {
		type = "input",
		name = name,
		desc = desc,
		get = function() return "" end,
		set = function(info, value)
			setter(info, input_to_mobid(value))
		end,
		validate = function(info, value)
			if input_to_mobid(value) then
				return true
			end
		end,
		order = order,
	}
end

function module:OnEnable()
	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.mobs = {
			mobs = {
				type = "group",
				name = "稀有怪",
				childGroups = "tab",
				order = 15,
				args = {
					custom = {
						type = "group",
						name = "自訂",
						order = 1,
						args = {
							add = mob_input(ADD, "要加入稀有怪，輸入 ID、名稱，\"將滑鼠指向它\" 或 \"選為目標\"。", 1, function(info, id)
								core:SetCustom(id, true)
							end),
							mobs = {
								type = "group",
								name = REMOVE,
								inline = true,
								get = function() return true end,
								set = function(info, value)
									core:SetCustom(info.arg, false)
								end,
								args = {},
							},
						},
					},
					ignore = {
						type = "group",
						name = "忽略",
						desc = "想要忽略和已經忽略的稀有怪",
						args = {
							add = mob_input(ADD, "要加入稀有怪，輸入 ID、名稱，\"將滑鼠指向它\" 或 \"選為目標\"。", 1, function(info, id)
								core:SetIgnore(id, true)
							end),
							mobs = {
								type = "group",
								name = REMOVE,
								inline = true,
								get = function() return true end,
								set = function(info, value)
									core:SetIgnore(info.arg, false)
								end,
								args = {},
							}
						},
						order = 2,
					},
				},
			},
		}

		self:BuildIgnoreList(config.options)
		self:BuildCustomList(config.options)
		self:BuildMobList(config.options)

		core.RegisterCallback(self, "IgnoreChanged")
		core.RegisterCallback(self, "CustomChanged")
	end
end

function module:IgnoreChanged(callback, id, ignored)
	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.mobs.mobs.args.ignore.args.mobs.args["mob"..id] = ignored and toggle_mob(id) or nil
	end
end
function module:CustomChanged(callback, id, watched)
	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.mobs.mobs.args.custom.args.mobs.args["mob"..id] = watched and toggle_mob(id) or nil
	end
end

function module:BuildIgnoreList(options)
	wipe(options.plugins.mobs.mobs.args.ignore.args.mobs.args)
	for id, ignored in pairs(core.db.global.ignore) do
		if ignored then
			options.plugins.mobs.mobs.args.ignore.args.mobs.args["mob"..id] = toggle_mob(id)
		end
	end
end

function module:BuildCustomList(options)
	wipe(options.plugins.mobs.mobs.args.custom.args.mobs.args)
	for id, active in pairs(core.db.global.always) do
		if active then
			options.plugins.mobs.mobs.args.custom.args.mobs.args["mob"..id] = toggle_mob(id)
		end
	end
end

function module:BuildMobList(options)
	for source, data in pairs(core.datasources) do
		local group = {
			type = "group",
			name = source,
			get = function(info)
				return not core.db.global.ignore[info.arg]
			end,
			set = function(info, value)
				core:SetIgnore(info.arg, not value)
			end,
			args = {
				enabled = {
					type = "toggle",
					name = ENABLE,
					desc = "停用時，只是讓稀有怪獸與牠們的產地不認識這些稀有怪。當你將滑鼠指向牠們時，仍然會發出通知，就像其他未知的稀有怪一樣。",
					arg = source,
					get = function(info) return core.db.global.datasources[info.arg] end,
					set = function(info, value)
						core.db.global.datasources[info.arg] = value
						core:BuildLookupTables()
					end,
					disabled = false,
				},
				ignore = {
					type = "toggle",
					name = IGNORE,
					desc = "這個功能會忽略每一隻稀有怪，不會發出任何通知，並且會無視任何其他的設定。",
					arg = source,
					get = function(info) return core.db.global.ignore_datasource[info.arg] end,
					set = function(info, value)
						core.db.global.ignore_datasource[info.arg] = value
						core:BuildLookupTables()
					end,
					disabled = function(info)
						return not core.db.global.datasources[info.arg]
					end,
				},
				zones = {
					type = "group",
					name = "區域",
					inline = false,
					childGroups = "tree",
					args = {},
				},
			},
		}
		local mob_toggle_disabled = function(info)
			return not core.db.global.datasources[info[#info - 3]]
		end
		for id, mob in pairs(data) do
			if not mob.hidden and mob.locations then
				for zone in pairs(mob.locations) do
					if not group.args.zones.args["map"..zone] then
						group.args.zones.args["map"..zone] = {
							type = "group",
							inline = false,
							name = core.zone_names[zone] or ("map"..zone),
							desc = "ID: " .. zone,
							args = {
								all = {
									type = "execute",
									name = ALL,
									desc = "選取清單中的每一個稀有怪",
									func = function(info)
										if not ns.mobsByZone[zone] then return end
										for mobid, locations in pairs(ns.mobsByZone[zone]) do
											core:SetIgnore(mobid, false, true)
										end
										self:BuildIgnoreList(info.options)
									end,
									width = "half",
									order = 1,
								},
								none = {
									type = "execute",
									name = NONE,
									desc = "取消選取清單中的每一個稀有怪",
									func = function(info)
										if not ns.mobsByZone[zone] then return end
										for mobid, locations in pairs(ns.mobsByZone[zone]) do
											core:SetIgnore(mobid, true, true)
										end
										self:BuildIgnoreList(info.options)
									end,
									width = "half",
									order = 2,
								},
							},
						}
					end
					local toggle = toggle_mob(id)
					toggle.disabled = mob_toggle_disabled
					group.args.zones.args["map"..zone].args["mob"..id] = toggle
				end
			end
		end
		options.plugins.mobs.mobs.args[source] = group
	end
end
