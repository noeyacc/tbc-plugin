-- $Id: Data-Classic.lua 59 2022-02-19 13:44:17Z arithmandar $
--[[

	Atlas, a World of Warcraft instance map browser
	Copyright 2011 ~ 2022 - Arith Hsu, Atlas Team <atlas.addon at gmail dot com>

	This file is part of Atlas.

	Atlas is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	Atlas is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Atlas; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

--]]
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs = _G.pairs
-- Libraries
local WoWClassicEra, WoWClassicTBC, WoWRetail
local wowtocversion  = select(4, GetBuildInfo())
if wowtocversion < 20000 then
	WoWClassicEra = true
elseif wowtocversion > 19999 and wowtocversion < 90000 then 
	WoWClassicTBC = true
else
	WoWRetail = true
end

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub
local BZ = Atlas_GetLocaleLibBabble("LibBabble-SubZone-3.0")
local BF = Atlas_GetLocaleLibBabble("LibBabble-Faction-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local ALC = LibStub("AceLocale-3.0"):GetLocale("Atlas")
local ALIL = Atlas_IngameLocales
local Atlas = LibStub("AceAddon-3.0"):GetAddon("Atlas")
local addon = Atlas:GetModule(private.module_name)

local function Atlas_GetBossName(bossname, encounterID, creatureIndex)
	local BB = Atlas_GetLocaleLibBabble("LibBabble-Boss-3.0")

	if (bossname and BB[bossname]) then
		bossname = BB[bossname]
	elseif (bossname and L[bossname]) then
		bossname = L[bossname]
	else
		--bossname = bossname
	end

	return bossname
end

if WoWClassicTBC then
	local db = {}
	addon.db = db

	local BLUE = "|cff6666ff"
	local GREN = "|cff66cc33"
	local GREY = "|cff999999"
	local LBLU = "|cff33cccc"
	local _RED = "|cffcc3333"
	local ORNG = "|cffcc9933"
	local PINK = "|ccfcc33cc"
	local PURP = "|cff9900ff"
	local WHIT = "|cffffffff"
	local YLOW = "|cffcccc33"
	local INDENT = "      "

	db.AtlasMaps = {
		CL_AuchindounEnt = {
			ZoneName = { BZ["Auchindoun"]..ALC["L-Parenthesis"]..ALC["Entrance"]..ALC["R-Parenthesis"] },
			Location = { BZ["Terokkar Forest"] },
			LevelRange = "64-75",
			MinLevel = "62",
			PlayerLimit = { 5 },
			Acronym = L["Auch"],
			Module = "Atlas_BurningCrusade",
			{ BLUE.." A) "..BZ["Auchenai Crypts"], 10001 },
			{ BLUE.." B) "..BZ["Mana-Tombs"], 10002 },
			{ BLUE.." C) "..BZ["Sethekk Halls"], 10003 },
			{ BLUE.." D) "..BZ["Shadow Labyrinth"], 10004 },
			{ BLUE.." E) "..ALC["Entrance"], 10005 },
			{ GREY.." 1) "..L["Clarissa"], 10006 },
			{ GREN..INDENT..L["Greatfather Aldrimus"] },
			{ GREN..INDENT..L["Ha'lei"] },
			{ GREN..INDENT..L["Horvon the Armorer <Armorsmith>"] },
			{ GREN..INDENT..L["Ramdor the Mad"] },
			{ GREY.." 2) "..L["Nexus-Prince Haramad"], 10007 },
			{ GREN..INDENT..L["Artificer Morphalius"] },
			{ GREN..INDENT..L["Mamdy the \"Ologist\""] },
			{ GREN..INDENT..L["\"Slim\" <Shady Dealer>"] },
			{ GREN..INDENT..L["\"Captain\" Kaftiz"] },
			{ GREY.." 3) "..L["Isfar"], 10008 },
			{ GREY.." 4) "..L["Field Commander Mahfuun"], 10008 },
			{ GREN..INDENT..L["Provisioner Tsaalt"] },
			{ GREN..INDENT..L["Spy Grik'tha"] },
			{ GREN..INDENT..L["Dealer Tariq"] },
			{ GREY.." 5) "..ALC["Meeting Stone"], 10009 },
		},
		CL_AuchAuchenaiCrypts = {
			ZoneName = { BZ["Auchindoun"]..ALC["Colon"]..BZ["Auchenai Crypts"] },
			Location = { BZ["Terokkar Forest"] },
			Acronym = L["AC"],
			DungeonID = 149,
			DungeonHeroicID = 178,
			WorldMapID = 256,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Lower City"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ GREN..INDENT..L["Draenei Spirit"] },
			{ WHIT.." 1) "..Atlas_GetBossName("Shirrak the Dead Watcher", 523), 523 },
			{ WHIT.." 2) "..Atlas_GetBossName("Exarch Maladaar", 524), 524 },
			{ WHIT..INDENT..L["Avatar of the Martyred"] },
			{ GREN..INDENT..L["D'ore"] },
		},
		CL_AuchManaTombs = {
			ZoneName = { BZ["Auchindoun"]..ALC["Colon"]..BZ["Mana-Tombs"] },
			Location = { BZ["Terokkar Forest"] },
			Acronym = L["MT"],
			DungeonID = 148,
			DungeonHeroicID = 179,
			WorldMapID = 272,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["The Consortium"] },
			{ ORNG..L["Key"]..ALC["Colon"]..ALIL["The Eye of Haramad"]..ALC["L-Parenthesis"]..ALC["Exalted"]..ALC["Comma"]..Atlas_GetBossName("Yor")..ALC["R-Parenthesis"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ GREN..INDENT..L["Artificer Morphalius"] },
			{ GREN..INDENT..L["Mamdy the \"Ologist\""] },
			{ WHIT.." 1) "..Atlas_GetBossName("Pandemonius", 534), 534 },
			{ WHIT.." 2) "..Atlas_GetBossName("Tavarok", 535), 535 },
			{ WHIT.." 3) "..L["Ethereal Transporter Control Panel"] },
			{ WHIT.." 4) "..Atlas_GetBossName("Nexus-Prince Shaffar", 537), 537 },
			{ ORNG..INDENT..Atlas_GetBossName("Yor", 536)..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"], 536 },
		},
		CL_AuchSethekkHalls = {
			ZoneName = { BZ["Auchindoun"]..ALC["Colon"]..BZ["Sethekk Halls"] },
			Location = { BZ["Terokkar Forest"] },
			DungeonID = 150,
			DungeonHeroicID = 180,
			Acronym = L["Seth"],
			WorldMapID = 258,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Lower City"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ GREN..INDENT..L["Isfar"] },
			{ WHIT.." 1) "..Atlas_GetBossName("Darkweaver Syth", 541), 541 },
			{ GREN..INDENT..L["Dealer Vijaad"] },
			{ GREN..INDENT..L["Lakka"] },
			{ WHIT.." 2) "..Atlas_GetBossName("Anzu", 542)..ALC["L-Parenthesis"]..ALC["Heroic"]..ALC["R-Parenthesis"], 542 },
			{ GREN..INDENT..L["The Saga of Terokk"] },
			{ WHIT.." 3) "..Atlas_GetBossName("Talon King Ikiss", 543), 543 },
		},
		CL_AuchShadowLabyrinth = {
			ZoneName = { BZ["Auchindoun"]..ALC["Colon"]..BZ["Shadow Labyrinth"] },
			Location = { BZ["Terokkar Forest"] },
			DungeonID = 151,
			DungeonHeroicID = 181,
			Acronym = L["SL"],
			WorldMapID = 260,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Lower City"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ GREY.." 1) "..L["Spy To'gun"], 10003 },
			{ WHIT.." 2) "..Atlas_GetBossName("Ambassador Hellmaw", 544), 544 },
			{ WHIT.." 3) "..Atlas_GetBossName("Blackheart the Inciter", 545), 545 },
			{ WHIT.." 4) "..Atlas_GetBossName("Grandmaster Vorpil", 546), 546 },
			{ GREN..INDENT..L["The Codex of Blood"] },
			{ WHIT.." 5) "..Atlas_GetBossName("Murmur", 547), 547 },
			{ GREY.." 6) "..L["First Fragment Guardian"], 10002 },
			{ GREN..INDENT..ALC["Arcane Container"] },
		},
		CL_BlackTempleStart = {
			ZoneName = { BZ["Black Temple"]..ALC["MapA"]..ALC["L-Parenthesis"]..ALC["Start"]..ALC["R-Parenthesis"] },
			Location = { BZ["Shadowmoon Valley"] },
			DungeonID = 196,
			Acronym = L["BT"],
			PlayerLimit = { 25 },
			WorldMapID = 339,
			DungeonLevel = 1,
			JournalInstanceID = 751,
			PlayerLimit = { 10, 30 },
			Module = "Atlas_BurningCrusade",
			NextMap = "CL_BlackTempleBasement",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Ashtongue Deathsworn"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ BLUE.." B) "..L["Towards Reliquary of Souls"], 10002 },
			{ BLUE.." C) "..L["Towards Teron Gorefiend"], 10003 },
			{ BLUE.." D) "..L["Towards Illidan Stormrage"], 10004 },
			{ GREY.." 1) "..L["Spirit of Olum"], 10008 },
			{ WHIT.." 2) "..Atlas_GetBossName("High Warlord Naj'entus", 1582), 1582 },
			{ WHIT.." 3) "..Atlas_GetBossName("Supremus", 1583), 1583 },
			{ WHIT.." 4) "..Atlas_GetBossName("Shade of Akama", 1584), 1584 },
			{ GREY.." 5) "..L["Spirit of Udalo"], 10009 },
			{ GREN..INDENT..L["Aluyen <Reagents>"] },
			{ GREN..INDENT..L["Okuno <Ashtongue Deathsworn Quartermaster>"] },
			{ GREN..INDENT..L["Seer Kanai"] },
		},
		CL_BlackTempleBasement = {
			ZoneName = { BZ["Black Temple"]..ALC["MapB"]..ALC["L-Parenthesis"]..ALC["Basement"]..ALC["R-Parenthesis"] },
			Location = { BZ["Shadowmoon Valley"] },
			DungeonID = 196,
			Acronym = L["BT"],
			PlayerLimit = { 25 },
			WorldMapID = 342,
			DungeonLevel = 4,
			JournalInstanceID = 751,
			PlayerLimit = { 10, 30 },
			Module = "Atlas_BurningCrusade",
			PrevMap = "CL_BlackTempleStart",
			NextMap = "CL_BlackTempleTop",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Ashtongue Deathsworn"] },
			{ BLUE.." B) "..ALC["Entrance"], 10001 },
			{ BLUE.." C) "..ALC["Entrance"], 10002 },
			{ WHIT.." 6) "..Atlas_GetBossName("Gurtogg Bloodboil", 1586), 1586 },
			{ WHIT.." 7) "..Atlas_GetBossName("Reliquary of Souls", 1587), 1587 },
			{ WHIT..INDENT..Atlas_GetBossName("Essence of Suffering", 1587, 1) },
			{ WHIT..INDENT..Atlas_GetBossName("Essence of Desire", 1587, 2) },
			{ WHIT..INDENT..Atlas_GetBossName("Essence of Anger", 1587, 3) },
			{ WHIT.." 8) "..Atlas_GetBossName("Teron Gorefiend", 1585), 1585 },
		},
		CL_BlackTempleTop = {
			ZoneName = { BZ["Black Temple"]..ALC["MapC"]..ALC["L-Parenthesis"]..ALC["Top"]..ALC["R-Parenthesis"] },
			Location = { BZ["Shadowmoon Valley"] },
			DungeonID = 196,
			Acronym = L["BT"],
			PlayerLimit = { 25 },
			WorldMapID = 346,
			DungeonLevel = 8,
			JournalInstanceID = 751,
			PlayerLimit = { 10, 30 },
			Module = "Atlas_BurningCrusade",
			PrevMap = "CL_BlackTempleBasement",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Ashtongue Deathsworn"] },
			{ BLUE.." D) "..ALC["Entrance"], 10001 },
			{ WHIT.." 9) "..Atlas_GetBossName("Mother Shahraz", 1588), 1588 },
			{ WHIT.."10) "..Atlas_GetBossName("The Illidari Council", 1589), 1589 },
			{ WHIT..INDENT..Atlas_GetBossName("Gathios the Shatterer", 1589, 1)..ALC["L-Parenthesis"]..Atlas_GetClassName("PALADIN")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("High Nethermancer Zerevor", 1589, 2)..ALC["L-Parenthesis"]..Atlas_GetClassName("MAGE")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Lady Malande", 1589, 3)..ALC["L-Parenthesis"]..Atlas_GetClassName("PRIEST")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Veras Darkshadow", 1589, 4)..ALC["L-Parenthesis"]..Atlas_GetClassName("ROGUE")..ALC["R-Parenthesis"] },
			{ WHIT.."11) "..Atlas_GetBossName("Illidan Stormrage", 1590), 1590 },
		},
		CL_CoilfangReservoirEnt = {
			ZoneName = { BZ["Coilfang Reservoir"]..ALC["L-Parenthesis"]..ALC["Entrance"]..ALC["R-Parenthesis"] },
			Location = { BZ["Zangarmarsh"] },
			LevelRange = "62-73",
			MinLevel = "61",
			PlayerLimit = { 5, 25},
			Acronym = L["CR"],
			Module = "Atlas_BurningCrusade",
			{ BLUE.." A) "..BZ["The Slave Pens"], 10001 },
			{ BLUE.." B) "..BZ["The Steamvault"], 10002 },
			{ BLUE.." C) "..BZ["Serpentshrine Cavern"], 10003 },
			{ BLUE.." D) "..BZ["The Underbog"], 10004 },
			{ BLUE.." E) "..ALC["Entrance"]..ALC["L-Parenthesis"]..ALC["Underwater"]..ALC["R-Parenthesis"], 10005 },
			{ GREY.." 1) "..ALC["Meeting Stone"], 10006 },
			{ GREY..INDENT..L["Watcher Jhang"] },
			{ GREY.." 2) "..L["Mortog Steamhead"], 10007 },
		},
		CL_CFRSerpentshrineCavern = {
			ZoneName = { BZ["Coilfang Reservoir"]..ALC["Colon"]..BZ["Serpentshrine Cavern"] },
			Location = { BZ["Zangarmarsh"] },
			DungeonID = 194,
			Acronym = L["SSC"],
			PlayerLimit = { 25 },
			WorldMapID = 332,
			JournalInstanceID = 748,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Cenarion Expedition"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Hydross the Unstable", 1567), 1567 },
			{ WHIT.." 2) "..Atlas_GetBossName("The Lurker Below", 1568), 1568 },
			{ WHIT.." 3) "..Atlas_GetBossName("Leotheras the Blind", 1569), 1569 },
			{ WHIT.." 4) "..Atlas_GetBossName("Fathom-Lord Karathress", 1570), 1570 },
			{ GREN..INDENT..L["Seer Olum"] },
			{ WHIT.." 5) "..Atlas_GetBossName("Morogrim Tidewalker", 1571), 1571 },
			{ WHIT.." 6) "..Atlas_GetBossName("Lady Vashj", 1572), 1572 },
		},
		CL_CFRTheSlavePens = {
			ZoneName = { BZ["Coilfang Reservoir"]..ALC["Colon"]..BZ["The Slave Pens"] },
			Location = { BZ["Zangarmarsh"] },
			DungeonID = 140,
			DungeonHeroicID = 184,
			Acronym = L["SP"],
			WorldMapID = 265,
			JournalInstanceID = 260,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Cenarion Expedition"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Mennu the Betrayer", 570), 570 },
			{ GREY.." 2) "..L["Weeder Greenthumb"], 10003 },
			{ WHIT.." 3) "..L["Skar'this the Heretic"]..ALC["L-Parenthesis"]..ALC["Heroic"]..ALC["R-Parenthesis"], 10004 },
			{ WHIT.." 4) "..Atlas_GetBossName("Rokmar the Crackler", 571), 571 },
			{ GREY.." 5) "..L["Naturalist Bite"], 10005 },
			{ WHIT.." 6) "..Atlas_GetBossName("Quagmirran", 572), 572 },
		},
		CL_CFRTheSteamvault = {
			ZoneName = { BZ["Coilfang Reservoir"]..ALC["Colon"]..BZ["The Steamvault"] },
			Location = { BZ["Zangarmarsh"] },
			DungeonID = 147,
			DungeonHeroicID = 185,
			Acronym = L["SV"],
			WorldMapID = 263,
			JournalInstanceID = 261,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Cenarion Expedition"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Hydromancer Thespia", 573), 573 },
			{ GREN..INDENT..L["Main Chambers Access Panel"] },
			{ GREY.." 2) "..L["Second Fragment Guardian"], 10002 },
			{ GREN..INDENT..ALC["Arcane Container"] },
			{ WHIT.." 4) "..Atlas_GetBossName("Mekgineer Steamrigger", 574), 574 },
			{ GREN..INDENT..L["Main Chambers Access Panel"] },
			{ WHIT.." 5) "..Atlas_GetBossName("Warlord Kalithresh", 575), 575 },
		},
		CL_CFRTheUnderbog = {
			ZoneName = { BZ["Coilfang Reservoir"]..ALC["Colon"]..BZ["The Underbog"] },
			Location = { BZ["Zangarmarsh"] },
			DungeonID = 146,
			DungeonHeroicID = 186,
			Acronym = L["UB"],
			WorldMapID = 262,
			JournalInstanceID = 262,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Cenarion Expedition"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Hungarfen", 576), 576 },
			{ GREN..INDENT..L["The Underspore"] },
			{ WHIT.." 2) "..Atlas_GetBossName("Ghaz'an", 577), 577 },
			{ GREY.." 4) "..L["Earthbinder Rayge"], 10002 },
			{ WHIT.." 4) "..Atlas_GetBossName("Swamplord Musel'ek", 578), 578 },
			{ WHIT..INDENT..Atlas_GetBossName("Claw") },
			{ WHIT.." 5) "..Atlas_GetBossName("The Black Stalker", 579), 579 },
		},
		CL_GruulsLair = {
			ZoneName = { BZ["Gruul's Lair"] },
			Location = { BZ["Blade's Edge Mountains"] },
			DungeonID = 177,
			Acronym = L["GL"],
			PlayerLimit = { 25 },
			WorldMapID = 330,
			JournalInstanceID = 746,
			Module = "Atlas_BurningCrusade",
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("High King Maulgar", 1564), 1564 },
			{ WHIT..INDENT..Atlas_GetBossName("Kiggler the Crazed", 1564, 2)..ALC["L-Parenthesis"]..Atlas_GetClassName("SHAMAN")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Blindeye the Seer", 1564, 3)..ALC["L-Parenthesis"]..Atlas_GetClassName("PRIEST")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Olm the Summoner", 1564, 4)..ALC["L-Parenthesis"]..Atlas_GetClassName("WARLOCK")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Krosh Firehand", 1564, 5)..ALC["L-Parenthesis"]..Atlas_GetClassName("MAGE")..ALC["R-Parenthesis"] },
			{ WHIT.." 2) "..Atlas_GetBossName("Gruul the Dragonkiller", 1565), 1565 },
		},
		HellfireCitadelEnt = {
			ZoneName = { BZ["Hellfire Citadel"]..ALC["L-Parenthesis"]..ALC["Entrance"]..ALC["R-Parenthesis"] },
			Location = { BZ["Hellfire Peninsula"] },
			LevelRange = "59-73",
			MinLevel = "57",
			PlayerLimit = { 5, 25},
			Acronym = L["HC"],
			Module = "Atlas_BurningCrusade",
			{ BLUE.." A) "..BZ["Hellfire Ramparts"], 10001 },
			{ BLUE.." B) "..BZ["The Shattered Halls"], 10002 },
			{ BLUE.." C) "..BZ["The Blood Furnace"], 10003 },
			{ BLUE.." D) "..BZ["Magtheridon's Lair"], 10004 },
			{ GREN.." 1') "..L["Meeting Stone of Magtheridon's Lair"], 10005 },
			{ GREN.." 2') "..L["Meeting Stone of Hellfire Citadel"], 10006 },
			{ GREN.." 3') "..L["Steps and path to the Blood Furnace"], 10007 },
			{ GREN.." 4') "..L["Path to the Hellfire Ramparts and Shattered Halls"], 10008 },
		},
		CL_HCBloodFurnace = {
			ZoneName = { BZ["Hellfire Citadel"]..ALC["Colon"]..BZ["The Blood Furnace"] },
			Location = { BZ["Hellfire Peninsula"] },
			DungeonID = 137,
			DungeonHeroicID = 187,
			Acronym = L["BF"],
			WorldMapID = 261,
			JournalInstanceID = 256,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Honor Hold"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Thrallmar"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("The Maker", 555), 555 },
			{ WHIT.." 2) "..Atlas_GetBossName("Broggok", 556), 556 },
			{ WHIT.." 3) "..Atlas_GetBossName("Keli'dan the Breaker", 557), 557 },
		},
		CL_HCHellfireRamparts = {
			ZoneName = { BZ["Hellfire Citadel"]..ALC["Colon"]..BZ["Hellfire Ramparts"] },
			Location = { BZ["Hellfire Peninsula"] },
			DungeonID = 136,
			DungeonHeroicID = 188,
			Acronym = L["Ramp"],
			WorldMapID = 347,
			JournalInstanceID = 248,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Honor Hold"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Thrallmar"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Watchkeeper Gargolmar", 527), 527 },
			{ WHIT.." 2) "..Atlas_GetBossName("Omor the Unscarred", 528), 528 },
			{ WHIT.." 3) "..Atlas_GetBossName("Vazruden the Herald", 529), 529 },
			{ WHIT..INDENT..Atlas_GetBossName("Nazan") },
			{ GREN..INDENT..L["Reinforced Fel Iron Chest"] },
		},
		CL_HCMagtheridonsLair = {
			ZoneName = { BZ["Hellfire Citadel"]..ALC["Colon"]..BZ["Magtheridon's Lair"] },
			Location = { BZ["Hellfire Peninsula"] },
			DungeonID = 176,
			Acronym = L["Mag"],
			PlayerLimit = { 25 },
			WorldMapID = 331,
			JournalInstanceID = 747,
			Module = "Atlas_BurningCrusade",
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Magtheridon", 1566), 1566 },
		},
		CL_HCTheShatteredHalls = {
			ZoneName = { BZ["Hellfire Citadel"]..ALC["Colon"]..BZ["The Shattered Halls"] },
			Location = { BZ["Hellfire Peninsula"] },
			DungeonID = 138,
			DungeonHeroicID = 189,
			Acronym = L["SH"],
			WorldMapID = 246,
			JournalInstanceID = 259,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Honor Hold"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Thrallmar"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ GREN..INDENT..L["Advance Scout Chadwick"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Gunny"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Caza'rez"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Stone Guard Stok'ton"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["R-Parenthesis"] },
			{ GREY.." 1) "..L["Randy Whizzlesprocket"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"], 10002 },
			{ GREN..INDENT..L["Drisella"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
			{ WHIT.." 2) "..Atlas_GetBossName("Grand Warlock Nethekurse", 566), 566 },
			{ WHIT.." 3) "..Atlas_GetBossName("Blood Guard Porung", 728)..ALC["L-Parenthesis"]..ALC["Heroic"]..ALC["R-Parenthesis"], 728 },
			{ WHIT.." 4) "..Atlas_GetBossName("Warbringer O'mrogg", 568), 568 },
			{ WHIT.." 5) "..Atlas_GetBossName("Warchief Kargath Bladefist", 569), 569 },
			{ WHIT..INDENT..L["Shattered Hand Executioner"]..ALC["L-Parenthesis"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Private Jacint"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Rifleman Brownbeard"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Captain Alina"]..ALC["L-Parenthesis"]..FACTION_ALLIANCE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Scout Orgarr"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Korag Proudmane"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
			{ GREN..INDENT..L["Captain Boneshatter"]..ALC["L-Parenthesis"]..FACTION_HORDE..ALC["Comma"]..ALC["Heroic"]..ALC["R-Parenthesis"] },
		},
		CL_KarazhanEnt = {
			ZoneName = { BZ["Karazhan"]..ALC["L-Parenthesis"]..ALC["Entrance"]..ALC["R-Parenthesis"] },
			Location = { BZ["Deadwind Pass"] },
			DungeonID = 175,
			PlayerLimit = { 10 },
			Acronym = L["Kara"],
			WorldMapID = 42,
			JournalInstanceID = 745,
			Module = "Atlas_BurningCrusade",
			NextMap = "CL_KarazhanStart",
			{ BLUE.." A) "..ALC["Entrance"]..ALC["L-Parenthesis"]..ALC["Front"]..ALC["R-Parenthesis"], 10001 },
			{ BLUE.." B) "..ALC["Entrance"]..ALC["L-Parenthesis"]..ALC["Back"]..ALC["R-Parenthesis"], 10001 },
			{ BLUE.." C) "..ALC["Meeting Stone"] },
			{ BLUE.." D) "..ALC["Graveyard"] },
			{ GREY.." 1) "..L["Archmage Leryda"] },
			{ GREY.." 2) "..L["Apprentice Darius"] },
			{ GREY.." 3) "..L["Archmage Alturus"] },
			{ GREY.." 4) "..L["Stairs to Underground Pond"] },
			{ GREY.." 5) "..L["Stairs to Underground Well"] },
			{ GREY.." 6) "..L["Charred Bone Fragment"] },
		},
	--    [799] = { mapFile = "Karazhan", [1] = 350, [2] = 351, [3] = 352, [4] = 353, [5] = 354, [6] = 355, [7] = 356, [8] = 357, [9] = 358, [10] = 359, [11] = 360, [12] = 361, [13] = 362, [14] = 363, [15] = 364, [16] = 365, [17] = 366},
		CL_KarazhanStart = {
			ZoneName = { BZ["Karazhan"]..ALC["MapA"]..ALC["L-Parenthesis"]..ALC["Start"]..ALC["R-Parenthesis"] },
			Location = { BZ["Deadwind Pass"] },
			DungeonID = 175,
			Acronym = L["Kara"],
			PlayerLimit = { 10 },
			WorldMapID = 350,
			JournalInstanceID = 745,
			Module = "Atlas_BurningCrusade",
			PrevMap = "CL_KarazhanEnt",
			NextMap = "CL_KarazhanEnd",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["The Violet Eye"] },
			{ BLUE.." A) "..ALC["Entrance"]..ALC["L-Parenthesis"]..ALC["Front"]..ALC["R-Parenthesis"], 10001 },
			{ BLUE.." B) "..L["Staircase to the Ballroom (Moroes)"] },
			{ BLUE.." C) "..L["Stairs to Upper Stable"] },
			{ BLUE.." D) "..L["Ramp to the Guest Chambers (Maiden)"] },
			{ BLUE.." E) "..L["Stairs to Opera House Orchestra Level"] },
			{ BLUE.." F) "..L["Ramp from Mezzanine to Balcony"] },
			{ BLUE.." G) "..ALC["Entrance"]..ALC["L-Parenthesis"]..ALC["Back"]..ALC["R-Parenthesis"], 10001 },
			{ BLUE.." H) "..L["Connection to Master's Terrace (Nightbane)"] },
			{ BLUE.." I) "..L["Path to the Broken Stairs"] },
			{ GREY.." 1) "..L["Hastings <The Caretaker>"], 10009 },
			{ GREY.." 2) "..Atlas_GetBossName("Servant Quarters", 1552), 1552 },
			{ ORNG..INDENT..Atlas_GetBossName("Rokad the Ravager", 1552, 1)..ALC["L-Parenthesis"]..ALC["Rare"]..ALC["Comma"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ ORNG..INDENT..Atlas_GetBossName("Shadikith the Glider", 1552, 2)..ALC["L-Parenthesis"]..ALC["Rare"]..ALC["Comma"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ ORNG..INDENT..Atlas_GetBossName("Hyakiss the Lurker", 1552, 3)..ALC["L-Parenthesis"]..ALC["Rare"]..ALC["Comma"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ GREY.." 3) "..L["Berthold <The Doorman>"], 10010 },
			{ GREY.." 4) "..L["Calliard <The Nightman>"], 10011 },
			{ WHIT.." 5) "..Atlas_GetBossName("Attumen the Huntsman", 1553), 1553 },
			{ WHIT..INDENT..Atlas_GetBossName("Midnight", 1553, 2) },
			{ GREY.." 6) "..L["Koren <The Blacksmith>"], 10012 },
			{ WHIT.." 7) "..Atlas_GetBossName("Moroes", 1554), 1554 },
			{ WHIT..INDENT..L["Baroness Dorothea Millstipe"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["Comma"]..ALC["Shadow Priest"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Lady Catriona Von'Indi"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["Comma"]..ALC["Holy Priest"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Lady Keira Berrybuck"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["Comma"]..ALC["Holy Paladin"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Baron Rafe Dreuger"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["Comma"]..ALC["Retribution Paladin"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Lord Robin Daris"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["Comma"]..ALC["Arms Warrior"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Lord Crispin Ference"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["Comma"]..ALC["Protection Warrior"]..ALC["R-Parenthesis"] },
			{ GREY.." 8) "..L["Bennett <The Sergeant at Arms>"], 10013 },
			{ GREY.." 9) "..L["Ebonlocke <The Noble>"], 10015 },
			{ GREY.."10) "..L["Keanna's Log"], 10014 },
			{ WHIT.."11) "..Atlas_GetBossName("Maiden of Virtue", 1555), 1555 },
			{ GREY.."12) "..L["Sebastian <The Organist>"], 10016 },
			{ GREY.."13) "..L["Barnes <The Stage Manager>"], 10017 },
			{ WHIT.."14) "..Atlas_GetBossName("Opera Hall", 1556), 1556 },
			{ ORNG..INDENT..L["Red Riding Hood"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("The Big Bad Wolf") },
			{ ORNG..INDENT..L["Wizard of Oz"]..ALC["L-Parenthesis"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("Dorothee") },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("Tito") },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("Strawman") },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("Tinhead") },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("Roar") },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("The Crone", 1556, 4) },
			{ ORNG..INDENT..Atlas_GetBossName("Romulo & Julianne")..ALC["L-Parenthesis"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("Romulo", 1556, 2) },
			{ WHIT..INDENT..INDENT..Atlas_GetBossName("Julianne", 1556, 3) },
			{ GREY.."15) "..Atlas_GetBossName("Nightbane")..ALC["L-Parenthesis"]..ALC["Summon"]..ALC["R-Parenthesis"], 10018 },
			{ GREY..INDENT..L["The Master's Terrace"] },
		},
		CL_KarazhanEnd = {
			ZoneName = { BZ["Karazhan"]..ALC["MapB"]..ALC["L-Parenthesis"]..ALC["End"]..ALC["R-Parenthesis"] },
			Location = { BZ["Deadwind Pass"] },
			DungeonID = 175,
			Acronym = L["Kara"],
			PlayerLimit = { 10 },
			WorldMapID = 350, -- which level?
			JournalInstanceID = 745,
			Module = "Atlas_BurningCrusade",
			PrevMap = "CL_KarazhanStart",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["The Violet Eye"] },
			{ BLUE.." I) "..L["Path to the Broken Stairs"], 10001 },
			{ BLUE.." J) "..L["Broken Stairs"], 10002 },
			{ BLUE.." K) "..L["Ramp to Guardian's Library"]..ALC["L-Parenthesis"]..Atlas_GetBossName("Shade of Aran")..ALC["R-Parenthesis"], 10003 },
			{ BLUE.." L) "..L["Mysterious Bookshelf"]..ALC["L-Parenthesis"]..Atlas_GetBossName("Terestian Illhoof")..ALC["R-Parenthesis"], 10004 },
			{ BLUE.." M) "..L["Ramp up to the Celestial Watch"]..ALC["L-Parenthesis"]..Atlas_GetBossName("Netherspite")..ALC["R-Parenthesis"], 10005 },
			{ BLUE..INDENT..L["Ramp down to the Gamesman's Hall"]..ALC["L-Parenthesis"]..Atlas_GetBossName("Chess Event", 1764)..ALC["R-Parenthesis"], 1764 },
			{ BLUE.." N) "..L["Ramp to Medivh's Chamber"], 10006 },
			{ BLUE.." O) "..L["Spiral Stairs to Netherspace"]..ALC["L-Parenthesis"]..Atlas_GetBossName("Prince Malchezaar")..ALC["R-Parenthesis"], 10007 },
			{ WHIT.."16) "..Atlas_GetBossName("The Curator", 1557), 1557 },
			{ GREY.."17) "..L["Wravien <The Mage>"], 10014 },
			{ GREY.."18) "..L["Gradav <The Warlock>"], 10015 },
			{ GREY.."19) "..L["Kamsis <The Conjurer>"], 10016 },
			{ WHIT.."20) "..Atlas_GetBossName("Terestian Illhoof", 1560), 1560 },
			{ WHIT..INDENT..Atlas_GetBossName("Kil'rek")..ALC["L-Parenthesis"]..ALC["Imp"]..ALC["R-Parenthesis"] },
			{ WHIT.."21) "..Atlas_GetBossName("Shade of Aran", 1559), 1559 },
			{ WHIT.."22) "..Atlas_GetBossName("Netherspite", 1561), 1561 },
			{ GREY.."23) "..L["Ythyar"]..ALC["L-Parenthesis"]..ALC["Repair"]..ALC["Comma"]..ALC["Rewards"]..ALC["R-Parenthesis"], 10017 },
			{ GREY.."24) "..L["Echo of Medivh"], 10018 },
			{ WHIT.."25) "..Atlas_GetBossName("Chess Event", 1562), 1562 },
			{ GREN..INDENT..Atlas_GetBossName("Dust Covered Chest") },
			{ WHIT.."26) "..Atlas_GetBossName("Prince Malchezaar", 1563), 1563 },
		},
		CL_MagistersTerrace = {
			ZoneName = { BZ["Magisters' Terrace"] },
			Location = { BZ["Isle of Quel'Danas"] },
			DungeonID = 198,
			DungeonHeroicID = 201,
			Acronym = L["MaT"],
			WorldMapID = 348,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["Shattered Sun Offensive"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Selin Fireheart", 530), 530 },
			{ GREN..INDENT..L["Fel Crystals"] },
			{ GREY.." 2) "..L["Tyrith"], 10003 },
			{ WHIT.." 3) "..Atlas_GetBossName("Vexallus", 531), 531 },
			{ GREY.." 4) "..L["Scrying Orb"], 10004 },
			{ GREN..INDENT..Atlas_GetBossName("Kalecgos") },
			{ WHIT.." 5) "..Atlas_GetBossName("Priestess Delrissa", 532)..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["R-Parenthesis"], 532 },
			{ WHIT..INDENT..L["Apoko"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..Atlas_GetClassName("SHAMAN")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Eramas Brightblaze"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..L["Monk"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Ellrys Duskhallow"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..Atlas_GetClassName("WARLOCK")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..INDENT..L["Fizzle"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Garaxxas"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..Atlas_GetClassName("HUNTER")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..INDENT..L["Sliver <Garaxxas' Pet>"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Kagani Nightstrike"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..Atlas_GetClassName("ROGUE")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Warlord Salaris"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..Atlas_GetClassName("WARRIOR")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Yazzai"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..Atlas_GetClassName("MAGE")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..L["Zelfan"]..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["Comma"]..ALC["Random"]..ALC["Comma"]..ALC["Engineer"]..ALC["R-Parenthesis"] },
			{ WHIT.." 6) "..Atlas_GetBossName("Kael'thas Sunstrider", 533), 533 },
		},
		CL_SunwellPlateau = {
			ZoneName = { BZ["Sunwell Plateau"] },
			Location = { BZ["Isle of Quel'Danas"] },
			DungeonID = 199,
			Acronym = L["SuP"],
			PlayerLimit = { 25 },
			WorldMapID = 335,
			JournalInstanceID = 752,
			Module = "Atlas_BurningCrusade",
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Kalecgos", 1591), 1591 },
			{ WHIT..INDENT..Atlas_GetBossName("Sathrovarr the Corruptor", 1591, 2) },
			{ WHIT.." 2) "..Atlas_GetBossName("Brutallus", 1592), 1592 },
			{ WHIT..INDENT..Atlas_GetBossName("Felmyst", 1593), 1593 },
			{ GREN..INDENT..L["Madrigosa"] },
			{ WHIT.." 3) "..Atlas_GetBossName("The Eredar Twins", 1594)..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["R-Parenthesis"], 1594 },
			{ WHIT..INDENT..Atlas_GetBossName("Grand Warlock Alythess", 1594, 1)..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Lady Sacrolash", 1594, 2)..ALC["L-Parenthesis"]..ALC["Lower"]..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("M'uru", 1595, 1)..ALC["L-Parenthesis"]..ALC["Upper"]..ALC["R-Parenthesis"], 1595 },
			{ WHIT..INDENT..Atlas_GetBossName("Entropius", 1595, 2)..ALC["L-Parenthesis"]..ALC["Upper"]..ALC["R-Parenthesis"] },
			{ WHIT.." 4) "..Atlas_GetBossName("Kil'jaeden", 1596), 1596 },
		},
		TempestKeepEnt = {
			ZoneName = { BZ["Tempest Keep"]..ALC["L-Parenthesis"]..ALC["Entrance"]..ALC["R-Parenthesis"] },
			Location = { BZ["Netherstorm"] },
			LevelRange = "70-73",
			MinLevel= "67",
			PlayerLimit = { 5, 25},
			Acronym = L["TK"],
			Module = "Atlas_BurningCrusade",
			{ BLUE.." A) "..BZ["The Mechanar"], 10001 },
			{ BLUE.." B) "..BZ["The Botanica"], 10002 },
			{ BLUE.." C) "..BZ["The Arcatraz"], 10003 },
			{ BLUE.." D) "..BZ["Tempest Keep"], 10004 },
		},
		CL_TempestKeepArcatraz = {
			ZoneName = { BZ["Tempest Keep"]..ALC["Colon"]..BZ["The Arcatraz"] },
			Location = { BZ["Netherstorm"] },
			DungeonID = 174,
			DungeonHeroicID = 190,
			Acronym = L["Arca"],
			WorldMapID = 269,
			JournalInstanceID = 254,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["The Sha'tar"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Zereketh the Unbound", 548), 548 },
			{ GREY.." 2) "..L["Third Fragment Guardian"], 10002 },
			{ GREN..INDENT..ALC["Arcane Container"] },
			{ WHIT.." 3) "..Atlas_GetBossName("Dalliah the Doomsayer", 549), 549 },
			{ WHIT.." 4) "..Atlas_GetBossName("Wrath-Scryer Soccothrates", 550), 550 },
			{ GREY.." 5) "..L["Udalo"], 10003 },
			{ WHIT.." 6) "..Atlas_GetBossName("Harbinger Skyriss", 551), 551 },
			{ WHIT..INDENT..Atlas_GetBossName("Warden Mellichar") },
			{ GREN..INDENT..L["Millhouse Manastorm"] },
		},
		CL_TempestKeepBotanica = {
			ZoneName = { BZ["Tempest Keep"]..ALC["Colon"]..BZ["The Botanica"] },
			Location = { BZ["Netherstorm"] },
			DungeonID = 173,
			DungeonHeroicID = 191,
			Acronym = L["Bota"],
			WorldMapID = 266,
			JournalInstanceID = 257,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["The Sha'tar"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Commander Sarannis", 558), 558 },
			{ WHIT.." 2) "..Atlas_GetBossName("High Botanist Freywinn", 559), 559 },
			{ WHIT.." 3) "..Atlas_GetBossName("Thorngrin the Tender", 560), 560 },
			{ WHIT.." 4) "..Atlas_GetBossName("Laj", 561), 561 },
			{ WHIT.." 5) "..Atlas_GetBossName("Warp Splinter", 562), 562 },
		},
		CL_TempestKeepMechanar = {
			ZoneName = { BZ["Tempest Keep"]..ALC["Colon"]..BZ["The Mechanar"] },
			Location = { BZ["Netherstorm"] },
			DungeonID = 172,
			DungeonHeroicID = 192,
			Acronym = L["Mech"],
			WorldMapID = 267,
			JournalInstanceID = 258,
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["The Sha'tar"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Gatewatcher Gyro-Kill"), 10003 },
			{ WHIT.." 2) "..Atlas_GetBossName("Gatewatcher Iron-Hand"), 10004 },
			{ GREY..INDENT..Atlas_GetBossName("Cache of the Legion"), 10005 },
			{ WHIT.." 3) "..Atlas_GetBossName("Mechano-Lord Capacitus", 563)..ALC["L-Parenthesis"]..ALC["Wanders"]..ALC["R-Parenthesis"], 563 },
			{ GREN..INDENT..L["Overcharged Manacell"] },
			{ WHIT.." 4) "..Atlas_GetBossName("Nethermancer Sepethrea", 564), 564 },
			{ WHIT.." 5) "..Atlas_GetBossName("Pathaleon the Calculator", 565), 565 },
		},
		CL_TempestKeepTheEye = {
			ZoneName = { BZ["Tempest Keep"]..ALC["Colon"]..BZ["Tempest Keep"] },
			Location = { BZ["Netherstorm"] },
			DungeonID = "193",
			Acronym = L["TK"],
			PlayerLimit = "25",
			WorldMapID = 266,
			JournalInstanceID = "749",
			Module = "Atlas_BurningCrusade",
			{ ORNG..REPUTATION..ALC["Colon"]..BF["The Sha'tar"] },
			{ BLUE.." A) "..ALC["Entrance"], 10001 },
			{ WHIT.." 1) "..Atlas_GetBossName("Al'ar", 1573), 1573 },
			{ WHIT.." 2) "..Atlas_GetBossName("Void Reaver", 1574), 1574 },
			{ WHIT.." 3) "..Atlas_GetBossName("High Astromancer Solarian", 1575), 1575 },
			{ WHIT.." 4) "..Atlas_GetBossName("Kael'thas Sunstrider", 1576), 1576 },
			{ WHIT..INDENT..Atlas_GetBossName("Thaladred the Darkener", 1576, 2)..ALC["L-Parenthesis"]..Atlas_GetClassName("WARRIOR")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Master Engineer Telonicus", 1576, 5)..ALC["L-Parenthesis"]..Atlas_GetClassName("HUNTER")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Grand Astromancer Capernian", 1576, 4)..ALC["L-Parenthesis"]..Atlas_GetClassName("MAGE")..ALC["R-Parenthesis"] },
			{ WHIT..INDENT..Atlas_GetBossName("Lord Sanguinar", 1576, 3)..ALC["L-Parenthesis"]..Atlas_GetClassName("PALADIN")..ALC["R-Parenthesis"] },
		},
	}

	-- Atlas Map NPC Description Data
	db.AtlasMaps_NPC_DB = {
	}

	db.AssocDefaults = {
	}

	--[[
		SubZoneData{}

		Define SubZone data for default map to be selected for instance which has multiple maps.
		Subzone data should be able to be pulled out from WMOAreaTable for indoor areas, or from AreaTable for outdoor areas.

		Array Syntax: 
		["localized zone name"] = {
			["atlas map name"] = {
				["localized subzone name 1"],
				["localized subzone name 2"],
			},
		},
	]]
	db.SubZoneData = {
	}

	--[[
		OutdoorZoneToAtlas{}

		Maps to auto-select to from outdoor zones.

		Table index is sub-zone name, it need to be localized value, but we will handle
		the localization with BabbleSubZone library.
		The table value is map's key-name.

		Duplicates are commented out.
		Not for localization.
	]]
	db.OutdoorZoneToAtlas = {
		[BZ["Terokkar Forest"]] = 			"CL_AuchindounEnt",		-- Outland
		[BZ["Shadowmoon Valley"]] = 		"CL_BlackTempleStart",		-- Outland
		[BZ["Zangarmarsh"]] = 				"CL_CoilfangReservoirEnt",		-- Outland
		[BZ["Blade's Edge Mountains"]] = 	"CL_GruulsLair",			-- Outland
		[BZ["Hellfire Peninsula"]] = 		"HellfireCitadelEnt",		-- Outland
		[BZ["Deadwind Pass"]] = 			"CL_KarazhanEnt",
		[BZ["Isle of Quel'Danas"]] = 		"CL_SunwellPlateau",
		[BZ["Netherstorm"]] = 				"TempestKeepEnt",
	}

	-- Entrance maps to instance maps
	db.EntToInstMatches = {
		["CL_AuchindounEnt"] =			{"CL_AuchManaTombs","CL_AuchAuchenaiCrypts","CL_AuchSethekkHalls","CL_AuchShadowLabyrinth"},
		["CL_CoilfangReservoirEnt"] =	{"CL_CFRTheSlavePens","CL_CFRTheUnderbog","CL_CFRTheSteamvault","CL_CFRSerpentshrineCavern"},
		["HellfireCitadelEnt"] = 	{"CL_HCBloodFurnace", "CL_HCHellfireRamparts", "CL_HCMagtheridonsLair", "CL_HCTheShatteredHalls"},
		["CL_KarazhanEnt"] =			{"CL_KarazhanStart","CL_KarazhanEnd"},
		["TempestKeepEnt"] = 		{"CL_TempestKeepArcatraz", "CL_TempestKeepBotanica", "CL_TempestKeepMechanar", "CL_TempestKeepTheEye"},
	}

	-- Instance maps to entrance maps
	db.InstToEntMatches = {
		["CL_AuchManaTombs"] =			{"CL_AuchindounEnt"},
		["CL_AuchAuchenaiCrypts"] =		{"CL_AuchindounEnt"},
		["CL_AuchSethekkHalls"] =		{"CL_AuchindounEnt"},
		["CL_AuchShadowLabyrinth"] =	{"CL_AuchindounEnt"},
		["CL_CFRTheSlavePens"] =		{"CL_CoilfangReservoirEnt"},
		["CL_CFRTheUnderbog"] =			{"CL_CoilfangReservoirEnt"},
		["CL_CFRTheSteamvault"] =		{"CL_CoilfangReservoirEnt"},
		["CL_CFRSerpentshrineCavern"] =	{"CL_CoilfangReservoirEnt"},
		["CL_HCBloodFurnace"] = 		{"HellfireCitadelEnt"},
		["CL_HCHellfireRamparts"] = 	{"HellfireCitadelEnt"},
		["CL_HCMagtheridonsLair"] = 	{"HellfireCitadelEnt"},
		["CL_HCTheShatteredHalls"] = 	{"HellfireCitadelEnt"},
		["CL_KarazhanStart"] =			{"CL_KarazhanEnt"},
		["CL_KarazhanEnd"] =			{"CL_KarazhanEnt"},
		["CL_Maraudon"] =				{"CL_MaraudonEnt"},
		["CL_TempestKeepArcatraz"] = 	{"TempestKeepEnt"},
		["CL_TempestKeepBotanica"] = 	{"TempestKeepEnt"}, 
		["CL_TempestKeepMechanar"] = 	{"TempestKeepEnt"}, 
		["CL_TempestKeepTheEye"] = 		{"TempestKeepEnt"},
	}

	-- Defines the instance which have multiple maps
	-- Added only when the Entrance map is not available, for example, Ulduar do have entrance map, so no need to add it here
	db.MapSeries = {
		["CL_BlackTempleStart"] = 			{"CL_BlackTempleStart", "CL_BlackTempleBasement", "CL_BlackTempleTop" },
		["CL_BlackTempleBasement"] = 		{"CL_BlackTempleStart", "CL_BlackTempleBasement", "CL_BlackTempleTop" },
		["CL_BlackTempleTop"] = 			{"CL_BlackTempleStart", "CL_BlackTempleBasement", "CL_BlackTempleTop" },
	}

	-- Links maps together that are part of the same instance
	db.SubZoneAssoc = {
		["CL_BlackTempleStart"] =			BZ["Black Temple"],
		["CL_BlackTempleBasement"] =		BZ["Black Temple"],
		["CL_BlackTempleTop"] =			BZ["Black Temple"],
		["CL_KarazhanStart"] =			BZ["Karazhan"],
		["CL_KarazhanEnd"] =			BZ["Karazhan"],
		["CL_KarazhanEnt"] =			BZ["Karazhan"],
	}

	db.DropDownLayouts_Order = {
		[ATLAS_DDL_CONTINENT] = {
			ATLAS_DDL_CONTINENT_EASTERN,
			ATLAS_DDL_CONTINENT_OUTLAND,
		},
		[ATLAS_DDL_LEVEL] = {
			ATLAS_DDL_LEVEL_10TO30,
		},
		[ATLAS_DDL_EXPANSION] = {
			ATLAS_DDL_EXPANSION_BC,
		},
	}

	db.DropDownLayouts = {
		[ATLAS_DDL_CONTINENT] = {
			[ATLAS_DDL_CONTINENT_EASTERN] = {
				"CL_KarazhanEnd",			-- Burning Crusade
				"CL_KarazhanEnt",			-- Burning Crusade
				"CL_KarazhanStart",		-- Burning Crusade
				"CL_MagistersTerrace",		-- Burning Crusade
				"CL_SunwellPlateau",		-- Burning Crusade
			},
			[ATLAS_DDL_CONTINENT_KALIMDOR] = {
			},
			[ATLAS_DDL_CONTINENT_OUTLAND] = {
				"CL_AuchAuchenaiCrypts",
				"CL_AuchindounEnt",
				"CL_AuchManaTombs",
				"CL_AuchSethekkHalls",
				"CL_AuchShadowLabyrinth",
				"CL_BlackTempleBasement",
				"CL_BlackTempleStart",
				"CL_BlackTempleTop",
				"CL_CFRSerpentshrineCavern",
				"CL_CFRTheSlavePens",
				"CL_CFRTheSteamvault",
				"CL_CFRTheUnderbog",
				"CL_CoilfangReservoirEnt",
				"CL_GruulsLair",
				"HellfireCitadelEnt",
				"CL_HCBloodFurnace",
				"CL_HCHellfireRamparts",
				"CL_HCMagtheridonsLair",
				"CL_HCTheShatteredHalls",
				"TempestKeepEnt",
				"CL_TempestKeepArcatraz",
				"CL_TempestKeepBotanica",
				"CL_TempestKeepMechanar",
				"CL_TempestKeepTheEye",
			},
		},
		[ATLAS_DDL_EXPANSION] = {
			[ATLAS_DDL_EXPANSION_BC] = {
				"CL_AuchAuchenaiCrypts",
				"CL_AuchindounEnt",
				"CL_AuchManaTombs",
				"CL_AuchSethekkHalls",
				"CL_AuchShadowLabyrinth",
				"CL_BlackTempleBasement",
				"CL_BlackTempleStart",
				"CL_BlackTempleTop",
				"CL_CFRSerpentshrineCavern",
				"CL_CFRTheSlavePens",
				"CL_CFRTheSteamvault",
				"CL_CFRTheUnderbog",
				"CL_CoilfangReservoirEnt",
				"CL_GruulsLair",
				"HellfireCitadelEnt",
				"CL_HCBloodFurnace",
				"CL_HCHellfireRamparts",
				"CL_HCMagtheridonsLair",
				"CL_HCTheShatteredHalls",
				"CL_KarazhanEnd",
				"CL_KarazhanEnt",
				"CL_KarazhanStart",
				"CL_MagistersTerrace",
				"CL_SunwellPlateau",
				"TempestKeepEnt",
				"CL_TempestKeepArcatraz",
				"CL_TempestKeepBotanica",
				"CL_TempestKeepMechanar",
				"CL_TempestKeepTheEye",
			},
		},
		[ATLAS_DDL_LEVEL] = {
			[ATLAS_DDL_LEVEL_10TO30] = {
				"CL_AuchAuchenaiCrypts",		-- Burning Crusade
				"CL_AuchindounEnt",		-- Burning Crusade
				"CL_AuchManaTombs",		-- Burning Crusade
				"CL_AuchSethekkHalls",		-- Burning Crusade
				"CL_AuchShadowLabyrinth",		-- Burning Crusade
				"CL_CFRTheSlavePens",		-- Burning Crusade
				"CL_CFRTheSteamvault",		-- Burning Crusade
				"CL_CFRTheUnderbog",		-- Burning Crusade
				"CL_CoilfangReservoirEnt",		-- Burning Crusade
				"HellfireCitadelEnt",		-- Burning Crusade
				"CL_HCBloodFurnace",		-- Burning Crusade
				"CL_HCHellfireRamparts",		-- Burning Crusade
				"CL_HCTheShatteredHalls",		-- Burning Crusade
				"CL_MagistersTerrace",		-- Burning Crusade
				"TempestKeepEnt",		-- Burning Crusade
				"CL_TempestKeepArcatraz",		-- Burning Crusade
				"CL_TempestKeepBotanica",		-- Burning Crusade
				"CL_TempestKeepMechanar",		-- Burning Crusade
				"CL_BlackTempleBasement",		-- Burning Crusade
				"CL_BlackTempleStart",		-- Burning Crusade
				"CL_BlackTempleTop",		-- Burning Crusade
				"CL_CFRSerpentshrineCavern",	-- Burning Crusade
				"CL_KarazhanEnt",			-- Burning Crusade
				"CL_KarazhanStart",		-- Burning Crusade
				"CL_KarazhanEnd",			-- Burning Crusade
			},
		},
		[ATLAS_DDL_PARTYSIZE] = {
			[ATLAS_DDL_PARTYSIZE_5] = {
				"CL_AuchAuchenaiCrypts",		-- Burning Crusade
				"CL_AuchindounEnt",		-- Burning Crusade
				"CL_AuchManaTombs",		-- Burning Crusade
				"CL_AuchSethekkHalls",		-- Burning Crusade
				"CL_AuchShadowLabyrinth",		-- Burning Crusade
				"CL_CFRTheSlavePens",		-- Burning Crusade
				"CL_CFRTheSteamvault",		-- Burning Crusade
				"CL_CFRTheUnderbog",		-- Burning Crusade
				"CL_CoilfangReservoirEnt",		-- Burning Crusade
				"CL_HCBloodFurnace",		-- Burning Crusade
				"CL_HCHellfireRamparts",		-- Burning Crusade
				"CL_HCTheShatteredHalls",		-- Burning Crusade
				"HellfireCitadelEnt",		-- Burning Crusade
				"CL_MagistersTerrace",		-- Burning Crusade
				"CL_TempestKeepArcatraz",		-- Burning Crusade
				"CL_TempestKeepBotanica",		-- Burning Crusade
				"TempestKeepEnt",		-- Burning Crusade
				"CL_TempestKeepMechanar",		-- Burning Crusade
			},
			[ATLAS_DDL_PARTYSIZE_10] = {
				"CL_KarazhanEnd",			-- Burning Crusade
				"CL_KarazhanEnt",			-- Burning Crusade
				"CL_KarazhanStart",		-- Burning Crusade
			},
			[ATLAS_DDL_PARTYSIZE_20TO40] = {
				"CL_BlackTempleBasement",		-- Burning Crusade
				"CL_BlackTempleStart",		-- Burning Crusade
				"CL_BlackTempleTop",		-- Burning Crusade
				"CL_CFRSerpentshrineCavern",	-- Burning Crusade
				"CL_CoilfangReservoirEnt",		-- Burning Crusade
				"CL_GruulsLair",			-- Burning Crusade
				"CL_HCMagtheridonsLair",		-- Burning Crusade
				"HellfireCitadelEnt",		-- Burning Crusade
				"CL_SunwellPlateau",		-- Burning Crusade
				"TempestKeepEnt",		-- Burning Crusade
				"CL_TempestKeepTheEye",		-- Burning Crusade
			},
		},
		[ATLAS_DDL_TYPE] = {
			[ATLAS_DDL_TYPE_INSTANCE] = {
				"CL_AuchAuchenaiCrypts",		-- Burning Crusade
				"CL_AuchManaTombs",		-- Burning Crusade
				"CL_AuchSethekkHalls",		-- Burning Crusade
				"CL_AuchShadowLabyrinth",		-- Burning Crusade
				"CL_BlackTempleBasement",		-- Burning Crusade
				"CL_BlackTempleStart",		-- Burning Crusade
				"CL_BlackTempleTop",		-- Burning Crusade
				"CL_CFRSerpentshrineCavern",	-- Burning Crusade
				"CL_CFRTheSlavePens",		-- Burning Crusade
				"CL_CFRTheSteamvault",		-- Burning Crusade
				"CL_CFRTheUnderbog",		-- Burning Crusade
				"CL_GruulsLair",			-- Burning Crusade
				"CL_HCBloodFurnace",		-- Burning Crusade
				"CL_HCHellfireRamparts",		-- Burning Crusade
				"CL_HCMagtheridonsLair",		-- Burning Crusade
				"CL_HCTheShatteredHalls",		-- Burning Crusade
				"CL_KarazhanEnd",			-- Burning Crusade
				"CL_KarazhanStart",		-- Burning Crusade
				"CL_MagistersTerrace",		-- Burning Crusade
				"CL_SunwellPlateau",		-- Burning Crusade
				"CL_TempestKeepArcatraz",		-- Burning Crusade
				"CL_TempestKeepBotanica",		-- Burning Crusade
				"CL_TempestKeepMechanar",		-- Burning Crusade
				"CL_TempestKeepTheEye",		-- Burning Crusade
			},
			[ATLAS_DDL_TYPE_ENTRANCE] = {
				"CL_AuchindounEnt",		-- Burning Crusade
				"CL_CoilfangReservoirEnt",		-- Burning Crusade
				"CL_CoTHyjalEnt",			-- Burning Crusade
				"HellfireCitadelEnt",		-- Burning Crusade
				"CL_KarazhanEnt",			-- Burning Crusade
				"TempestKeepEnt",		-- Burning Crusade
			},
		},
	}
end
