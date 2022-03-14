local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "AceTimer-3.0", "LibSink-2.0")
local Debug = core.Debug

local L = {}
L["fake"] = "假的"
L["mouseover"] = "滑鼠指向"
L["target"] = "目標"
L["grouptarget"] = "隊友目標"
L["vignette"] = "小地圖星號"
L["macro"] = "巨集"
L["nameplate"] = "血條"
L["point-of-interest"] = "探索點"
L["GUILD"] = "公會"
L["PARTY"] = "隊伍"
L["groupsync"] = "隊伍同步"
L["guildsync"] = "公會同步"

local LSM = LibStub("LibSharedMedia-3.0")

if LSM then
	-- Register some media
	LSM:Register("sound", "Fireworks", "sound/doodad/g_fireworkboomgeneral4.ogg")
	LSM:Register("sound", "Shing!", "sound/doodad/nox_door_portcullisclose.ogg")
	LSM:Register("sound", "Beast Call", "sound/spells/beastcall.ogg")
	LSM:Register("sound", "Cheer", "sound/spells/crowdcheerhorde2.ogg")
	LSM:Register("sound", "PVP Flag (Alliance)", "sound/spells/pvpflagtaken.ogg")
	LSM:Register("sound", "PVP Flag (Horde)", "sound/spells/pvpflagtakenhorde.ogg")
	LSM:Register("sound", "PVP Long Warning (Alliance)", "sound/spells/pvpwarningalliance.ogg")
	LSM:Register("sound", "PVP Long Warning (Horde)", "sound/spells/pvpwarninghorde.ogg")
	LSM:Register("sound", "Loatheb: You are mine now", "sound/creature/loathstare/loa_naxx_aggro01.ogg")
	LSM:Register("sound", "Loatheb: I see you", "sound/creature/loathstare/loa_naxx_aggro02.ogg")
	LSM:Register("sound", "Loatheb: You are next", "sound/creature/loathstare/loa_naxx_aggro03.ogg")
end

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Announce", {
		profile = {
			sink = true,
			drums = true,
			sound = true,
			soundgroup = true,
			soundguild = false,
			sound_mount = true,
			sound_boss = true,
			soundfile = "Loatheb: I see you",
			soundfile_mount = "PVP Long Warning (Horde)",
			soundfile_boss = "PVP Long Warning (Alliance)",
			sound_loop = 1,
			sound_mount_loop = 3,
			sound_boss_loop = 1,
			flash = true,
			flash_texture = "Blizzard Low Health",
			flash_color = {r=1,g=0,b=1,a=1,},
			flash_mount = true,
			flash_texture_mount = "Blizzard Low Health",
			flash_color_mount = {r=0,g=1,b=0,a=1,},
			flash_boss = false,
			flash_texture_boss = "Blizzard Low Health",
			flash_color_boss = {r=1,g=0,b=1,a=1,},
			instances = false,
			dead = true,
			already = false,
			sink_opts = {},
			channel = "Master",
			unmute = false,
			background = false,
		},
	})

	self:SetSinkStorage(self.db.profile.sink_opts)

	if self.db.profile.sink_opts.sink20OutputSink == "Channel" then
		-- 8.2.5 / Classic removed the ability to output to channels, outside of hardware-driven events
		self.db.profile.sink_opts.sink20OutputSink = "Default"
	end

	core.RegisterCallback(self, "Seen")

	local config = core:GetModule("Config", true)
	if config then
		local toggle = config.toggle
		local get = function(info) return self.db.profile[info[#info]] end
		local set = function(info, v) self.db.profile[info[#info]] = v end

		local sink_config = self:GetSinkAce3OptionsDataTable()
		local sink_args = {}
		for k,v in pairs(sink_config.args) do
			if k ~= "Channel" then
				sink_args[k] = v
			end
		end
		sink_config.args = sink_args
		sink_config.inline = true
		sink_config.order = 15
		sink_config.args.Channel = nil

		local faker = function(id, name, zone, x, y)
			return {
				type = "execute", name = name,
				desc = "假裝看到 " .. name,
				func = function()
					-- id, zone, x, y, is_dead, source, unit
					core.events:Fire("Seen", id, zone, x, y, false, "fake", false)
				end,
			}
		end
		local soundfile = function(enabled_key, order)
			return {
				type = "select", dialogControl = "LSM30_Sound",
				name = "播放音效", desc = "選擇要播放的音效",
				values = AceGUIWidgetLSMlists.sound,
				disabled = function() return not self.db.profile[enabled_key] end,
				order = order,
			}
		end
		local soundrange = function(order)
			return {
				type = "range",
				name = "重複...",
				desc = "音效重複播放的次數",
				min = 1, max = 10, step = 1,
				order = order,
			}
		end
		local colorget = function(info)
			local color = self.db.profile[info[#info]]
			return color.r, color.g, color.b, color.a
		end
		local colorset = function(info, r, g, b, a)
			local color = self.db.profile[info[#info]]
			color.r, color.g, color.b, color.a = r, g, b, a
		end

		local options = {
			general = {
				type = "group", name = "一般", inline = true,
				order = 10,
				get = get, set = set,
				args = {
					already = toggle("已經找到過", "發現已經擊殺過 / (已知) 成就已達成的稀有怪要顯示通知。"),
					dead = toggle("已經死亡", "發現已經死亡的稀有怪 (如果能夠知道的話) 要通知。並非所有的掃描方法都能夠知道稀有怪是否已經死亡，所以並不完全可靠。"),
					instances = toggle("副本", "在副本中要顯示通知。"),
				},
			},
			message = {
				type = "group", name = "訊息",
				order = 20,
				get = get, set = set,
				args = {
					sink = toggle("啟用", "傳送訊息到你正在使用的任何一種捲動文字插件。", 10),
					output = sink_config,
				},
			},
			test = {
				type = "group", name = "測試!",
				inline =  true,
				args = {
					-- id, name, zone, x, y, is_dead, is_new_location, source, unit
					thuros = faker(61, "索羅斯·萊特芬格", 1429, 0.2840, 0.5960),
				},
			},
			sound = {
				type = "group", name = "音效",
				get = get, set = set,
				order = 10,
				args = {
					about = config.desc("發現稀有怪時要播放音效通知? 特別的稀有怪還可以有特別音效。*絕對* 不會讓你錯過... 像是... 時光流逝元龍，絕對不會...", 0),
					channel = {
						type = "select",
						name = _G.SOUND_CHANNELS,
						descStyle = "inline",
						values = {
							Ambience = _G.AMBIENCE_VOLUME,
							Master = "主音量",
							Music = _G.MUSIC_VOLUME,
							SFX = _G.SOUND_VOLUME,
							Dialog = _G.DIALOG_VOLUME,
						},
						order = 11,
					},
					unmute = toggle("忽略靜音", "就算是靜音時也要播放音效", 12),
					background = toggle(_G.ENABLE_BGSOUND, _G.OPTION_TOOLTIP_ENABLE_BGSOUND, 13),
					drums = toggle("鼓聲", "搭配鼓聲更有氣氛", 14),
					soundgroup = toggle("隊伍同步音效", "從隊伍/團隊成員同步稀有怪時播放音效", 15),
					soundguild = toggle("公會同步音效", "從不在隊伍中的公會成員同步稀有怪時播放音效", 16),
					regular = {type="header", name="", order=20,},
					sound = toggle("音效", "一般稀有怪播放音效", 21),
					soundfile = soundfile("sound", 22),
					sound_loop = soundrange(23),
					mount = {type="header", name="", order=25,},
					sound_mount = toggle("坐騎音效", "掉落坐騎的稀有怪播放音效", 26),
					soundfile_mount = soundfile("sound_mount", 27),
					sound_mount_loop = soundrange(28),
					boss = {type="header", name="", order=30,},
					sound_boss = toggle("首領音效", "需要組隊擊殺的稀有怪播放音效", 31),
					soundfile_boss = soundfile("sound_boss", 35),
					sound_boss_loop = soundrange(37),
				},
			},
			flash = {
				type = "group", name = "閃爍畫面",
				get = get, set = set,
				order = 15,
				args = {
					about = config.desc("發現稀有怪時閃爍遊戲畫面", 0),
					flash = toggle("啟用", "閃爍畫面?", 1),
					flash_color = {
						name = COLOR,
						type = "color",
						hasAlpha = true,
						descStyle = "inline",
						get = colorget,
						set = colorset,
						order = 2,
					},
					flash_texture = {
						name = TEXTURES_SUBHEADER,
						type = "select",
						descStyle = "inline",
						dialogControl = "LSM30_Background",
						values = AceGUIWidgetLSMlists.background,
						order = 3,
					},
					preview = {
						name = PREVIEW,
						type = "execute",
						func = function()
							module:Flash(50065) -- Armagedillo
						end,
						order = 4,
					},
					mount = {type="header", name="", order=10,},
					flash_mount = toggle("坐騎閃爍", "發現會掉落坐騎的稀有怪時，用不同的方式閃爍?", 11),
					flash_color_mount = {
						name = COLOR,
						type = "color",
						hasAlpha = true,
						descStyle = "inline",
						get = colorget,
						set = colorset,
						order = 12,
					},
					flash_texture_mount = {
						name = TEXTURES_SUBHEADER,
						type = "select",
						descStyle = "inline",
						dialogControl = "LSM30_Background",
						values = AceGUIWidgetLSMlists.background,
						order = 13,
					},
					preview_mount = {
						name = PREVIEW,
						type = "execute",
						func = function()
							module:Flash(32491) -- time lost
						end,
						order = 14,
					},
					boss = {type="header", name="", order=20,},
					flash_boss = toggle("首領閃爍", "發現首領級的稀有怪時，用不同的方式閃爍?", 21),
					flash_color_boss = {
						name = COLOR,
						type = "color",
						hasAlpha = true,
						descStyle = "inline",
						get = colorget,
						set = colorset,
						order = 22,
					},
					flash_texture_boss = {
						name = TEXTURES_SUBHEADER,
						type = "select",
						descStyle = "inline",
						dialogControl = "LSM30_Background",
						values = AceGUIWidgetLSMlists.background,
						order = 23,
					},
					preview_boss = {
						name = PREVIEW,
						type = "execute",
						func = function()
							module:Flash(70096) -- War-God Dokah
						end,
						order = 24,
					},
				},
			},
		}

		config.options.args.outputs.plugins.announce = options
	end
end

function module:Seen(callback, id, zone, x, y, is_dead, source, ...)
	Debug("Announce:Seen", id, zone, x, y, is_dead, ...)

	if not self.db.profile.instances and IsInInstance() then
		return
	end

	if not self:ShouldAnnounce(id, zone, x, y, is_dead, source, ...) then
		return
	end

	core.events:Fire("Announce", id, zone, x, y, is_dead, source, ...)
end

function module:ShouldAnnounce(id, zone, x, y, is_dead, source, ...)
	if is_dead and not self.db.profile.dead then
		return
	end
	if core.db.global.always[id] then
		-- If you've manually added a mob, bypass any other checks
		return true
	end
	if not self.db.profile.already then
		-- hide already-completed mobs
		local quest, achievement = ns:CompletionStatus(id)
		if quest ~= nil or achievement ~= nil then
			-- knowable
			if achievement ~= nil then
				-- achievement knowable
				if quest ~= nil then
					-- quest also knowable
					return not quest
				end
				if source == 'vignette' then
					-- No quest known, but the vignette wouldn't be present if the quest was complete, so...
					return true
				end
				-- can just fall back on achievement
				return not achievement
			else
				-- just quest knowable
				return not quest
			end
		end
	end

	return true
end

core.RegisterCallback("SD Announce Sink", "Announce", function(callback, id, zone, x, y, dead, source)
	if not module.db.profile.sink then
		return
	end

	Debug("Pouring")
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel and player then
			local localized_zone = core.zone_names[zone] or UNKNOWN
			source = "由" .. (L[channel] or channel) .. "的 " .. player .. " 發現；在" .. localized_zone
		end
	end
	if x and y then
		-- 偵測方式翻譯為中文
		if L[source] then source = L[source] end

		if x == 0 and y == 0 then
			source = source .. " @ 未知位置"
		else
			source = source .. " @ " .. core.round(x * 100, 1) .. "," .. core.round(y * 100, 1)
		end
	end
	local prefix = "發現稀有怪: "
	module:Pour((prefix .. "%s%s (%s)"):format(core:GetMobLabel(id), dead and "... 但是已經死了" or '', source or ''))
end)

local cvar_overrides
local channel_cvars = {
	Ambience = "Sound_EnableAmbience",
	Master = "Sound_EnableAllSound",
	Music = "Sound_EnableMusic",
	SFX = "Sound_EnableSFX",
	Dialog = "Sound_EnableDialog",
}
local delays = {}
local nowplaying
function module:PlaySound(s)
	-- Arg is a table, to make scheduling the loops easier. I am lazy.
	Debug("Playing sound", s.soundfile, s.loops)
	-- boring check:
	if s and s.handle then
		StopSound(s.handle)
		if s.drumshandle then
			StopSound(s.drumshandle)
		end
		s.handle = nil
		s.drumshandle = nil
	end
	if not s.loops or s.loops == 0 then
		if cvar_overrides and s.cvars then
			for cvar, value in pairs(s.cvars) do
				SetCVar(cvar, value)
			end
			cvar_overrides = false
		end
		nowplaying = false
		return
	end
	if not cvar_overrides then
		if self.db.profile.background and GetCVar("Sound_EnableSoundWhenGameIsInBG") == "0" then
			cvar_overrides = true
			s.cvars = s.cvars or {}
			s.cvars["Sound_EnableSoundWhenGameIsInBG"] = GetCVar("Sound_EnableSoundWhenGameIsInBG")
			SetCVar("Sound_EnableSoundWhenGameIsInBG", "1")
		end
		if self.db.profile.unmute and GetCVar(channel_cvars[self.db.profile.channel]) == "0" then
			cvar_overrides = true
			s.cvars = s.cvars or {}
			s.cvars[channel_cvars[self.db.profile.channel]] = GetCVar(channel_cvars[self.db.profile.channel])
			SetCVar(channel_cvars[self.db.profile.channel], "1")
		end
	end
	-- now, noise!
	local drums = self.db.profile.drums
	if s.soundfile == "NPCScan" then
		--Override default behavior and force npcscan behavior of two sounds at once
		drums = true
		PlaySoundFile(LSM:Fetch("sound", "Scourge Horn"), self.db.profile.channel)
	else
		--Play whatever sound is set
		PlaySoundFile(LSM:Fetch("sound", s.soundfile), self.db.profile.channel)
	end
	if drums and not s.drumsplaying then
		local willPlay, handle = PlaySoundFile("sound/doodad/trolldrumloop1.ogg", "Master")
		s.drumshandle = handle
		if willPlay then
			-- drums are ~10s long, so stop them lingering
			self:ScheduleTimer(StopSound, s.loops * 4.5, handle)
		end
	end
	s.loops = s.loops - 1
	-- we guarantee one callback, in case we need to do cleanup
	self:ScheduleTimer("PlaySound", delays[s.soundfile] or 4.5, s)
	nowplaying = true
end
core.RegisterCallback("SD Announce Sound", "Announce", function(callback, id, zone, x, y, dead, source)
	if not LSM then return end
	if nowplaying then return end
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" and not module.db.profile.soundguild or (channel == "PARTY" or channel == "RAID") and not module.db.profile.soundgroup then return end
	end
	local soundfile, loops
	if module.db.profile.sound_mount and ns.mobdb[id] and ns.mobdb[id].mount then
		soundfile = module.db.profile.soundfile_mount
		loops = module.db.profile.sound_mount_loop
	elseif ns.mobdb[id] and ns.mobdb[id].boss then
		if not module.db.profile.sound_boss then return end
		soundfile = module.db.profile.soundfile_boss
		loops = module.db.profile.sound_boss_loop
	else
		if not module.db.profile.sound then return end
		soundfile = module.db.profile.soundfile
		loops = module.db.profile.sound_loop
	end
	module:PlaySound{soundfile = soundfile, loops = loops}
end)

do
	local flashframe
	function module:Flash(id)
		if not module.db.profile.flash then
			return
		end
		if not flashframe then
			flashframe = CreateFrame("Frame", nil, WorldFrame)
			flashframe:SetClampedToScreen(true)
			flashframe:SetFrameStrata("FULLSCREEN_DIALOG")
			flashframe:SetToplevel(true)
			flashframe:SetAllPoints(UIParent)
			flashframe:Hide()

			-- Use the OutOfControl (blue) and LowHealth (red) textures to get a purple flash
			local texture = flashframe:CreateTexture(nil, "BACKGROUND")
			texture:SetBlendMode("ADD")
			texture:SetDesaturated(true)
			texture:SetAllPoints()

			local group = flashframe:CreateAnimationGroup()
			group:SetLooping("BOUNCE")
			local pulse = group:CreateAnimation("Alpha")
			pulse:SetFromAlpha(0.3)
			pulse:SetToAlpha(0.75)
			pulse:SetDuration(0.5236)

			local loops = 0
			group:SetScript("OnLoop", function(frame, state)
				loops = loops + 1
				if loops == 9 then
					group:Finish()
				end
			end)
			group:SetScript("OnFinished", function(self)
				loops = 0
				flashframe:Hide()
			end)

			flashframe:SetScript("OnShow", function(self)
				local background = module.db.profile.flash_texture
				local color = module.db.profile.flash_color
				if self.id and ns.mobdb[self.id] then
					if ns.mobdb[self.id].mount and module.db.profile.flash_mount then
						background = module.db.profile.flash_texture_mount
						color = module.db.profile.flash_color_mount
					elseif ns.mobdb[self.id].boss and module.db.profile.flash_boss then
						background = module.db.profile.flash_texture_boss
						color = module.db.profile.flash_color_boss
					end
				end
				texture:SetTexture(LSM:Fetch("background", background))
				texture:SetVertexColor(color.r, color.g, color.b, color.a)

				group:Play()
			end)
		end

		Debug("Flashing")
		flashframe.id = id
		flashframe:Hide()
		flashframe:Show()
	end

	core.RegisterCallback("SD Announce Flash", "Announce", function(callback, id)
		module:Flash(id)
	end)
end
