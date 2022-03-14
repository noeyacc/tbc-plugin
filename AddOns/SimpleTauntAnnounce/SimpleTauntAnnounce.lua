--[[-------------------------------------------------------------------------
-- Simple Taunt Announce
--
-- Copyright 2011-2020 BeathsCurse (Bowmore - Silvermoon EU)
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-------------------------------------------------------------------------]]--

local addonName, addon = ...
addon.version = GetAddOnMetadata(addonName, 'Version')

-- Expose our addon table through a global variable
_G[addonName] = addon

-- Configuration table with default values
-- Note: Valid values for own and other are: off, self, say, party, and raid
-- (which work depends on status).
addon.cfg = {
	cfgversion = 1,
	isEnabled = true,
	soundOwn = '',
	soundOther = '',
	-- When solo, how to announce your own taunts and those of others
	solo = { own = 'self', other = 'off' },
	-- When in a party
	party = { own = 'self', other = 'self' },
	-- When in a raid
	raid = { own = 'say', other = 'self' },
}

-- Create frame for handling events
addon.frame = CreateFrame('Frame', addonName .. 'Frame')
addon.frame:Hide()

-- Local shorthands for accessing the configuration and frame
local cfg = addon.cfg
local frame = addon.frame

-- Function to enable addon
function addon:Enable()
	if not self.cfg.isEnabled then
		self.cfg.isEnabled = true
		self.frame:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
end

-- Function to disable addon
function addon:Disable()
	if self.cfg.isEnabled then
		self.cfg.isEnabled = false
		self.frame:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
end

-- Table of taunt aura IDs
-- Note: These are 'real' taunts that apply an aura that forces the target
-- to focus the player.
local tauntAuras = {
	['嘲諷']=1,			-- Warrior, Taunt
	['懲戒痛擊']=1,		-- Warrior, Mocking Blow
	['挑戰怒吼']=1,	-- Warrior, Challenging Shout
	['低吼']=1,			-- Druid, Growl
	['挑戰咆哮']=1,		-- Druid, Challenging Roar
}

-- Table of taunt spell IDs
-- Note: These are spells that cause a high amount of threat, but do not
-- force aggro. It is problematic to handle misses for these, as we get the
-- spell cast success first, and if it misses the miss comes later. For now
-- we simply ignore misses for these.
local tauntSpells = {
	['低吼']=1,			-- Hunter pet, Growl
	['擾亂射擊']=1,		-- Hunter, Distracting Shot
	['折磨']=1,			-- Warlock Voidwalker, Torment
	['受難']=1,		-- Warlock Voidwalker, Suffering
}

-- Table for looking up raid icon id from destFlags
local raidIconLookup = {
	[COMBATLOG_OBJECT_RAIDTARGET1]=1,
	[COMBATLOG_OBJECT_RAIDTARGET2]=2,
	[COMBATLOG_OBJECT_RAIDTARGET3]=3,
	[COMBATLOG_OBJECT_RAIDTARGET4]=4,
	[COMBATLOG_OBJECT_RAIDTARGET5]=5,
	[COMBATLOG_OBJECT_RAIDTARGET6]=6,
	[COMBATLOG_OBJECT_RAIDTARGET7]=7,
	[COMBATLOG_OBJECT_RAIDTARGET8]=8,
}

-- Strings used to insert a raid icon in message to self
local raidIconMsgStrings = {
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1.blp:0|t',
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2.blp:0|t',
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3.blp:0|t',
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4.blp:0|t',
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5.blp:0|t',
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6.blp:0|t',
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7.blp:0|t',
	'|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8.blp:0|t',
}

-- Strings used to insert a raid icon in chat message
local raidIconChatStrings = {
	'{rt1}', '{rt2}', '{rt3}', '{rt4}',
	'{rt5}', '{rt6}', '{rt7}', '{rt8}',
}

-- Table for looking up compact modes
local compactModeLookup = {
	o='off',
	m='self',
	s='say',
	p='party',
	r='raid',
}

-- Variables used to prevent flooding on AoE taunts
local lastTime, lastSpellName

-- Local names for globals used in CLEU handler
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local GetZonePVPInfo = GetZonePVPInfo
local IsInGroup = IsInGroup
local IsInRaid = IsInRaid
local IsInInstance = IsInInstance
local PlaySoundFile = PlaySoundFile
local UnitClass = UnitClass
local UnitCreatureFamily = UnitCreatureFamily
local UnitInBattleground = UnitInBattleground
local UnitName = UnitName

-- Update configuration table
-- Note: Assumes all keys are simple and values are tables or simple.
-- Will overwrite a non-table with a table, but not the other way around.
local function UpdateCfg(dst, src)
	for k, v in pairs(src) do
		if type(v) == 'table' then
			if type(dst[k]) == 'table' then
				-- Update a table with a table
				UpdateCfg(dst[k], v)
			else
				-- Overwrite a value with a table
				dst[k] = UpdateCfg({}, v)
			end
		elseif type(dst[k]) ~= 'table' then
			-- Update a value with a value
			dst[k] = v
		end
	end
	return dst
end

-- Split a string into whitespace delimited parts and return them as a list
-- Note: Simple and slow, but we only use it to parse the slash commands.
local function SplitString(s)
	local t = {}
	-- Loop over matches of non-whitespace sequences in s, adding them to t
	for w in s:gmatch('%S+') do
		t[#t + 1] = w
	end
	return unpack(t)
end

-- Get name of player
-- Note: We cannot read the name into a local variable on load since
-- UnitName may return UNKNOWNOBJECT until the player has fully loaded.
-- We could potentially use the GUID instead.
local GetPlayerName
do
	local playerName

	function GetPlayerName()
		if not playerName then
			local a = UnitName('player')
			if a and a ~= UNKNOWNOBJECT then
				playerName = a
			end
		end
		return playerName
	end
end

-- Get string for raid icon based on chat mode
local function GetRaidIconString(raidIcon, mode)
	local s = ''

	if raidIcon then
		if mode == 'self' then
			s = raidIconMsgStrings[raidIcon]
		else
			s = raidIconChatStrings[raidIcon]
		end
	end

	return s
end

-- Event dispatcher
frame:SetScript('OnEvent', function(self, event, ...)
	local a = self[event]
	if a then
		a(self, ...)
	end
end)

-- Perform actions once all saved variables are loaded
function frame:ADDON_LOADED(name)
	if name ~= addonName then return end

	-- We do not have to be called for any further addons
	self:UnregisterEvent('ADDON_LOADED')

	-- Update current configuration table with saved
	if not STACFG then STACFG = {} end
	UpdateCfg(cfg, STACFG)

	-- Register combat log event handling if announcing is on
	if cfg.isEnabled then
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
	end
end

-- Perform actions as player is about to enter world
function frame:PLAYER_LOGIN()
	-- Add slash command
	SLASH_STA1 = '/sta'
	SlashCmdList['STA'] = function(msg)
		self:OnSlashCmd(SplitString((msg or ''):lower()))
	end
end

-- Perform actions as player is about to leave world
function frame:PLAYER_LOGOUT()
	-- Update saved configuration table with current
	UpdateCfg(STACFG, cfg)
end

-- The actual combat log event handler
-- Note: Naming the args was faster than select, and Lua adjusts the number
-- of arguments automatically.
function frame:COMBAT_LOG_EVENT_UNFILTERED()
	local timeStamp, subEvent, _, _, sourceName, sourceFlags, _, _, destName, _, destRaidFlags, _, spellName, _, missType = CombatLogGetCurrentEventInfo()
	local failString

--[[
	-- For debugging purposes
	if subEvent == 'SPELL_CAST_SUCCESS' then
		print((sourceName or '?') .. ' -> ' .. (destName or '?') .. ' spellcast ' .. (spellName or '?') .. ' flags ' .. bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MASK))
	elseif subEvent == 'SPELL_AURA_APPLIED' then
		print((sourceName or '?') .. ' -> ' .. (destName or '?') ..  ' aura ' .. (spellName or '?') .. ' flags ' .. bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MASK))
	end
--]]

	-- Check if event was a taunt aura applied, or a taunt spell
	if subEvent == 'SPELL_AURA_APPLIED' then
		-- If applied aura was not a taunt, return
		if not tauntAuras[spellName] then return end
	elseif subEvent == 'SPELL_CAST_SUCCESS' then
		-- If spell cast was not a taunt, return
		if not tauntSpells[spellName] then return end
		-- If Growl was cast by a player, return
		-- Note: This is to avoid double announce for Druid Growl
		if spellName == '低吼' and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then return end
	elseif subEvent == 'SPELL_MISSED' then
		-- If missed spell was not a taunt, return
		if not (tauntSpells[spellName] or tauntAuras[spellName]) then return end
		-- Set failString to a suitable indication the taunt failed
		failString = ' 失敗了!!! (' .. (missType or '?'):lower() .. ')'
	else
		-- Neither an aura applied nor a spell missed, so return
		return
	end

	-- If player is in a battleground or an arena, return
	if UnitInBattleground('player') or GetZonePVPInfo() == 'arena' then return end

	-- Check if time and spell was same as last
	-- Note: This is to prevent flooding announcements on AoE taunts.
	if timeStamp == lastTime and spellName == lastSpellName then return end

	-- Update last time and spell
	lastTime, lastSpellName = timeStamp, spellName

	-- Figure out grouping status
	local inGroup, inRaid = IsInGroup(), IsInRaid()
	local inInstance = IsInInstance()

	local config

	-- Select config based on grouping status
	if inRaid then
		config = cfg.raid
	elseif inGroup then
		config = cfg.party
	else
		config = cfg.solo
	end

	-- Get id of raid icon on target, or nil if none
	local raidIcon = raidIconLookup[bit.band(destRaidFlags, COMBATLOG_OBJECT_RAIDTARGET_MASK)]

	-- Check if source was the player, player's pet, or other
	if sourceName == GetPlayerName() then
		local mode = config.own

		-- If mode is off for this config, return
		if mode == 'off' then return end

		-- Outside instances, change say to self
		if not inInstance and mode == 'say' then mode = 'self' end

		-- Announce taunt
		self:AnnounceTaunt(mode, string.format('正在嘲諷 %s%s (使用 [%s]) %s', GetRaidIconString(raidIcon, mode), destName or '?', spellName or '?', failString or ''), cfg.soundOwn)
	elseif bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0 then
		local mode = config.own

		-- If mode is off for this config, return
		if mode == 'off' then return end

		-- Outside instances, change say to self
		if not inInstance and mode == 'say' then mode = 'self' end

		-- Announce taunt
		self:AnnounceTaunt(mode, string.format('我的 %s 正在嘲諷 %s%s (使用 [%s]) %s', sourceName or '?', GetRaidIconString(raidIcon, mode), destName or '?', spellName or '?', failString or ''), cfg.soundOwn)
	else
		local mode = config.other

		-- If mode is off for this config, return
		if mode == 'off' then return end

		-- Outside instances, change say to self
		if not inInstance and mode == 'say' then mode = 'self' end

		-- Announce if source was a player/pet in our party/raid
		if (inRaid and bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) > 0) or (inGroup and bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) > 0) then
			local name = sourceName or '?'

			-- Apply class color to name if announcing to self and source was a player
			if mode == 'self' and bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) > 0 then
				local _, classFileName = UnitClass(name)
				name = '|c' .. RAID_CLASS_COLORS[classFileName or 'PRIEST'].colorStr .. name .. '|r'
			end

			self:AnnounceTaunt(mode, string.format('%s 正在嘲諷 %s%s (使用 [%s]) %s', name, GetRaidIconString(raidIcon, mode), destName or '?', spellName or '?', failString or ''), cfg.soundOther)
		end
	end
end

-- Register the events we handle
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_LOGIN')
frame:RegisterEvent('PLAYER_LOGOUT')

-- Print with STA prefix
function frame:Print(...)
	return print('|cFFF0F050[嘲諷]|r:', ...)
end

-- Formatted print with STA prefix
function frame:Printf(s, ...)
	return print('|cFFF0F050[嘲諷]|r:', string.format(s, ...))
end

-- Announce message to self or channel based on mode
-- Note: mode has to be self, say, party, or raid
function frame:AnnounceTaunt(mode, msg, sound)
	if mode == 'self' then
		self:Print(msg)
	else
		-- Here mode is say, party, or raid
		SendChatMessage(msg, mode:upper())
	end
	if sound ~= '' then
		PlaySoundFile(sound, 'MASTER')
	end
end

-- Print a line with own and other modes in config
function frame:PrintMode(mode, config)
	self:Printf('|cFF20E020%s|r 模式: 自己 -> |cFF20E020%s|r, 他人 -> |cFF20E020%s|r', mode, config.own, config.other)
end

-- Update config with the modes from own and other
function frame:ParseCmdModes(cmd, config, own, other)
	-- Update own mode
	if own then
		if own == 'off' then
			config.own = 'off'
		elseif own == 'self' then
			config.own = 'self'
		elseif own == 'say' then
			config.own = 'say'
		elseif own == 'party' and (cmd == 'party' or cmd == 'raid') then
			config.own = 'party'
		elseif own == 'raid' and cmd == 'raid' then
			config.own = 'raid'
		else
			self:Print('|cFF20E020' .. cmd .. '|r 的模式無效，自己:', own)
			return
		end
	end

	-- Update other mode
	if other then
		if other == 'off' then
			config.other = 'off'
		elseif other == 'self' then
			config.other = 'self'
		elseif other == 'say' then
			config.other = 'say'
		elseif other == 'party' and (cmd == 'party' or cmd == 'raid') then
			config.other = 'party'
		elseif other == 'raid' and cmd == 'raid' then
			config.other = 'raid'
		else
			self:Print('|cFF20E020' .. cmd .. '|r 的模式無效，他人:', other)
			return
		end
	end
end

-- Update config with modes in compact form
function frame:ParseCompactCmdModes(cmd)
	if cmd:len() ~= 7 then
		self:Print('精簡模式必須包含 6 個字元')
		return
	end
	self:ParseCmdModes('solo', cfg.solo, compactModeLookup[cmd:sub(2, 2)], compactModeLookup[cmd:sub(3, 3)])
	self:ParseCmdModes('party', cfg.party, compactModeLookup[cmd:sub(4, 4)], compactModeLookup[cmd:sub(5, 5)])
	self:ParseCmdModes('raid', cfg.raid, compactModeLookup[cmd:sub(6, 6)], compactModeLookup[cmd:sub(7, 7)])
end

-- Slash command handler
function frame:OnSlashCmd(cmd, ...)
	if cmd == 'on' then
		-- Register combat log event handling to start announcing
		self:Print('通報已 |cFF20E020開啟|r')
		addon:Enable()
	elseif cmd == 'off' then
		-- Unregister combat log event handling to stop announcing
		self:Print('通報已 |cFFE02020關閉|r')
		addon:Disable()
	elseif cmd == 'solo' then
		self:ParseCmdModes(cmd, cfg.solo, ...)
		self:PrintMode(cmd, cfg.solo)
	elseif cmd == 'party' then
		self:ParseCmdModes(cmd, cfg.party, ...)
		self:PrintMode(cmd, cfg.party)
	elseif cmd == 'raid' then
		self:ParseCmdModes(cmd, cfg.raid, ...)
		self:PrintMode(cmd, cfg.raid)
	elseif cmd and cmd:sub(1, 1) == '!' then
		self:ParseCompactCmdModes(cmd)
	elseif cmd == 'info' then
		-- Show a little profiling info
		UpdateAddOnMemoryUsage()
		local usedKB = GetAddOnMemoryUsage(addonName)
		self:Printf('使用記憶體 %.2f KB', usedKB)
		if GetCVar('scriptProfile') == '1' then
			UpdateAddOnCPUUsage()
			local addOnTime = GetAddOnCPUUsage(addonName)
			self:Printf('插件使用 CPU %.2f (%.2f%%)', addOnTime, (100 * addOnTime) / GetScriptCPUUsage())
			local frameTime, frameCount = GetFrameCPUUsage(frame)
			self:Printf('框架使用 CPU %.2f 於 %d 次呼叫 (每次呼叫 %.4f)', frameTime, frameCount, frameTime / frameCount)
		end
	elseif cmd == 'help' then
		-- Show an explanation of status and modes
		self:Print('每種組隊狀態 (|cFF20E020solo party|r 和 |cFF20E020raid|r) 的')
		self:Print('自己和他人模式都可以設為 |cFF20E020off self say party|r 或 |cFF20E020raid|r。')
		self:Print('自己模式包含了你或你的寵物所做的嘲諷，')
		self:Print('他人模式包含了你的隊伍/團隊中的其他玩家或寵物所做的嘲諷。')
		self:Print('範例:')
		self:Print('  |cFF20E020/sta party|r - 顯示目前的隊伍模式。')
		self:Print('  |cFF20E020/sta solo self|r - 單人時，顯示自己的嘲諷給自己看。')
		self:Print('  |cFF20E020/sta raid say self|r - 團隊時，自己的嘲諷通報到說頻道，他人的只顯示給自己看。')
	else
		-- By default, show status and options
		self:Print(addonName, addon.version)
		self:Print('用法: /sta <指令> [選項]')
		self:Print('  |cFF20E020on/off|r - 開啟/關閉通報')
		self:Print('  |cFF20E020solo/party/raid [own [other]]|r - 設定模式')
		self:Print('  |cFF20E020help|r - 顯示更多說明')
		if cfg.isEnabled then
			self:Print('通報已 |cFF20E020開啟|r')
		else
			self:Print('通報已 |cFFE02020關閉|r')
		end
	end
end
