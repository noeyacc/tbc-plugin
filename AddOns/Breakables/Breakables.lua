local L = LibStub("AceLocale-3.0"):GetLocale("Breakables", false)
Breakables = LibStub("AceAddon-3.0"):NewAddon("Breakables", "AceConsole-3.0", "AceEvent-3.0")
local babbleInv = LibStub("LibBabble-Inventory-3.0"):GetLookupTable()
local LBF = LibStub("Masque", true)

local lbfGroup

local IsArtifactRelicItem = IsArtifactRelicItem
if not IsArtifactRelicItem then
	IsArtifactRelicItem = function()
		return false
	end
end

local WowVer = select(4, GetBuildInfo())
local IsClassic = WOW_PROJECT_ID and WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
local IsClassicBC = WOW_PROJECT_ID and WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC

local MillingId = 51005
local MillingItemSubType = babbleInv["Herb"]
local MillingItemSecondarySubType = babbleInv["Other"]
local CanMill = false

local AdditionalMillableItems = {
	-- WoD herbs
	109124,
	109125,
	109126,
	109127,
	109128,
	109129,
	-- Legion herbs
	124101,
	124102,
	124103,
	124104,
	124105,
	124106,
	128304,
	151565,
	-- BfA herbs
	152505,
	152506,
	152507,
	152508,
	152509,
	152510,
	152511,
	168487,
	-- Shadowlands herbs
	168586, -- rising glory
	168589, -- marrowroot
	170554, -- vigil's torch
	168583, -- widowbloom
	169701, -- death blossom
	171315, -- nightshade
	187699, -- first flower, 9.2.0
}

local AdditionalProspectableItems = {
	-- Legion ore
	123918,
	123919,
	151564,
	-- BfA ore
	152512,
	152513,
	152579,
	168185,
	-- Shadowlands ore
	171828, -- laestrite
	171833, -- elethium
	171829, -- solenium
	171830, -- oxxein
	171831, -- phaedrum
	171832, -- sinvyr
	187700, -- progenium ore, 9.2.0
}

local MassMilling = {
	-- wod
	[109124] = 190381,
	[109125] = 190382,
	[109126] = 190383,
	[109127] = 190384,
	[109128] = 190385,
	[109129] = 190386,
	-- legion
	[124101] = 209658,
	[124102] = 209659,
	[124103] = 209660,
	[124104] = 209661,
	[124105] = 209662,
	[124106] = 209664,
	[128304] = 210116,
	[151565] = 247861,
	-- shadowlands
	[168586] = 311417,
	[168589] = 311416,
	[170554] = 311414,
	[168583] = 311415,
	[169701] = 311413,
	[171315] = 311418,
	[187699] = 359490,
}

local HerbCombineItems = {
	-- MoP
	97619, -- torn green tea leaf
	97620, -- rain poppy petal
	97621, -- silkweed stem
	97622, -- snow lily petal
	97623, -- fool's cap spores
	97624, -- desecrated herb pod
	-- WoD
	109624, -- broken frostweed stem
	109625, -- broken fireweed stem
	109626, -- gorgrond flytrap ichor
	109627, -- starflower petal
	109628, -- nagrand arrowbloom petal
	109629, -- talador orchid petal
	-- shadowlands
	169550, -- rising glory petal
	168591, -- marrowroot petal
	169699, -- vigil's torch petal
	169698, -- widowbloom petal
	169700, -- death blossom petal
	169697, -- nightshade petal
}

local UnProspectableItems = {
	109119, -- WoD True Iron Ore
}

local ProspectingId = 31252
local ProspectingItemSubType = babbleInv["Metal & Stone"]
local CanProspect = false

local OreCombineItems = {
	-- MoP
	97512, -- ghost iron nugget
	97546, -- kyparite fragment
	90407, -- sparkling shard
	-- WoD
	109991, -- true iron nugget
	109992, -- blackrock fragment
}

local DisenchantId = 13262
local DisenchantTypes = {babbleInv["Armor"], babbleInv["Weapon"]}
local CanDisenchant = false
local EnchantingProfessionId = 333

local AdditionalDisenchantableItems = {
	137195, -- highmountain armor
}

local PickLockId = 1804
local PickableItems = {
	16882, -- battered junkbox
	16883, -- worn junkbox
	16884, -- sturdy junkbox
	16885, -- heavy junkbox
	29569, -- strong junkbox
	43575, -- reinforced junkbox
	63349, -- flame-scarred junkbox
	88165, -- vine-cracked junkbox
	106895, -- iron-bound junkbox
	4632, -- ornate bronze lockbox
	4633, -- heavy bronze lockbox
	4634, -- iron lockbox
	4636, -- strong iron lockbox
	4637, -- steel lockbox
	4638, -- reinforced steel lockbox
	5758, -- mithril lockbox
	5759, -- throium lockbox
	5760, -- eternium lockbox
	31952, -- khorium lockbox
	43622, -- froststeel lockbox
	43624, -- titanium lockbox
	45986, -- tiny titanium lockbox
	68729, -- elementium lockbox
	88567, -- ghost iron lockbox
	116920, -- true steel lockbox
	121331, -- leystone lockbox
	169475, -- barnacled lockbox
	-- shadowlands
	179311, -- venthyr
	180532, -- maldraxxi
	180533, -- kyrian
	180522, -- night fae
	186161, -- stygian lockbox, 9.1.0
}
local CanPickLock = false

-- item rarity must meet or surpass this to be considered for disenchantability (is that a word?)
local RARITY_UNCOMMON = 2
local RARITY_RARE = 3
local RARITY_EPIC = 4
local RARITY_HEIRLOOM = 7

local IDX_LINK = 1
local IDX_COUNT = 2
local IDX_TYPE = 3
local IDX_TEXTURE = 4
local IDX_BAG = 5
local IDX_SLOT = 6
local IDX_SUBTYPE = 7
local IDX_LEVEL = 8
local IDX_BREAKABLETYPE = 9
local IDX_SOULBOUND = 10
local IDX_NAME = 11
local IDX_RARITY = 12

local BREAKABLE_HERB = 1
local BREAKABLE_ORE = 2
local BREAKABLE_DE = 3
local BREAKABLE_PICK = 4
local BREAKABLE_COMBINE = 5

local BagUpdateCheckDelay = 0.1
local nextCheck = {}
for i=0,NUM_BAG_SLOTS do
	nextCheck[i] = -1
end

local buttonSize = 45

local _G = _G

local validGrowDirections = {L["Left"], L["Right"], L["Up"], L["Down"]}

-- can be 1, 2, or 3 (in the case of a rogue with pick lock)
local numEligibleProfessions = 0

local showingTooltip = nil

Breakables.optionsFrame = {}
Breakables.justClicked = false

function Breakables:OnInitialize()
	self.defaults = {
		profile = {
			buttonFrameLeft = {100, 100},
			buttonFrameTop = {700, 650},
			hideIfNoBreakables = true,
			maxBreakablesToShow = 5,
			showSoulbound = false,
			hideEqManagerItems = true,
			hide = false,
			hideInCombat = false,
			hideInPetBattle = true,
			buttonScale = 1,
			fontSize = 11,
			growDirection = 2,
			ignoreList = {},
			showTooltipForBreakables = true,
			showTooltipForProfession = true,
		}
	}
	self.db = LibStub("AceDB-3.0"):New("BreakablesDB", self.defaults, true)
	self.settings = self.db.profile

	self:RegisterChatCommand("brk", "OnSlashCommand")

	if type(self.settings.buttonFrameLeft) ~= "table" then
		local old = self.settings.buttonFrameLeft
		self.settings.buttonFrameLeft = {}
		self.settings.buttonFrameLeft[1] = old
		self.settings.buttonFrameLeft[2] = self.defaults.profile.buttonFrameLeft[2]
	end
	if type(self.settings.buttonFrameTop) ~= "table" then
		local old = self.settings.buttonFrameTop
		self.settings.buttonFrameTop = {}
		self.settings.buttonFrameTop[1] = old
		self.settings.buttonFrameTop[2] = self.defaults.profile.buttonFrameTop[2]
	end

	self:InitLDB()
end

function Breakables:ButtonFacadeCallback(Group, SkinID, Gloss, Backdrop, Colors, Disabled)
	if not Group then
		self.settings.SkinID = SkinID
		self.settings.Gloss = Gloss
		self.settings.Backdrop = Backdrop
		self.settings.Colors = Colors
	end
end

function Breakables:InitLDB()
	local LDB = LibStub and LibStub("LibDataBroker-1.1", true)

	if (LDB) then
		local ldbButton = LDB:NewDataObject("Breakables", {
			type = "launcher",
			text = L["Breakables"],
			icon = "Interface\\Icons\\ability_warrior_sunder",
			OnClick = function(button, msg)
				self:OnSlashCommand()
			end,
		})

		if ldbButton then
			function ldbButton:OnTooltipShow()
				self:AddLine(L["Breakables"] .. " 1.8.3")
				self:AddLine(L["Click to open Breakables options."], 1, 1, 1)
			end
		end
	end
end

function Breakables:OnEnable()
	CanMill = IsUsableSpell(GetSpellInfo(MillingId))
	CanProspect = IsUsableSpell(GetSpellInfo(ProspectingId))
	CanDisenchant = IsUsableSpell(GetSpellInfo(DisenchantId))
	CanPickLock = IsUsableSpell(GetSpellInfo(PickLockId))

	self.EnchantingLevel = 0

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Breakables", self:GetOptions(), "breakables")
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Breakables")

	if LBF then
		LBF:Register("Breakables", self.ButtonFacadeCallback, self)

		lbfGroup = LBF:Group("Breakables")
		if lbfGroup then
			lbfGroup:ReSkin()
		end
	end

	self:RegisterEvents()

	if CanMill or CanProspect or CanDisenchant or CanPickLock then
		if CanMill then
			numEligibleProfessions = numEligibleProfessions + 1
		end
		if CanProspect then
			numEligibleProfessions = numEligibleProfessions + 1
		end
		if CanDisenchant then
			numEligibleProfessions = numEligibleProfessions + 1
			self:GetEnchantingLevel()
		end
		if CanPickLock then
			numEligibleProfessions = numEligibleProfessions + 1
		end

		self:CreateButtonFrame()
		if self.settings.hide then
			self:ToggleButtonFrameVisibility(false)
		else
			self:FindBreakables()
		end
		if not self.frame.OnUpdateFunc then
			self.frame.OnUpdateFunc = function() self:CheckShouldFindBreakables() end
		end
		self.frame:SetScript("OnUpdate", self.frame.OnUpdateFunc)
	else
		self:UnregisterAllEvents()
	end
end

function Breakables:ToggleButtonFrameVisibility(show)
	for i=1,numEligibleProfessions do
		if self.buttonFrame[i] then
			if show == nil then
				show = not self.buttonFrame[i]:IsVisible()
			end

			if not show then
				self.buttonFrame[i]:Hide()
			else
				self.buttonFrame[i]:Show()
			end
		end
	end
end

function Breakables:RegisterEvents()
	-- would have used ITEM_PUSH here, but that seems to fire after looting and before the bag actually gets the item
	-- another alternative is to parse the chat msg, but that seems lame...however, that should only fire once as opposed to BAG_UPDATE's potential double-fire
	self:RegisterEvent("BAG_UPDATE", "OnItemReceived")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEnterCombat")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnLeaveCombat")

	self:RegisterEvent("MODIFIER_STATE_CHANGED", "FindBreakables")

	if CanDisenchant and WowVer < 80000 then
		self:RegisterEvent("TRADE_SKILL_UPDATE", "OnTradeSkillUpdate")
	end

	if CanPickLock then
		self:RegisterEvent("CHAT_MSG_OPENING", "OnBagItemLockPicked")
	end

	if UnitCanPetBattle then
		self:RegisterEvent("PET_BATTLE_OPENING_START", "PetBattleStarted")
		self:RegisterEvent("PET_BATTLE_OVER", "PetBattleEnded")
	end
end

function Breakables:OnModifierChanged()
	if showingTooltip ~= nil and not self.bCombat then
		self:OnEnterBreakableButton(showingTooltip)
	end
end

function Breakables:OnDisable()
	self:UnregisterAllEvents()
	self.frame:SetScript("OnUpdate", nil)
end

function Breakables:OnSlashCommand(input)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end

function Breakables:OnItemReceived(event, bag)
	if self.justClicked then
		self:FindBreakables()
		self.justClicked = false
		self:OnLeaveProfessionButton()
	elseif not bag or bag >= 0 then
		nextCheck[bag] = GetTime() + BagUpdateCheckDelay
	end
end

function Breakables:CheckShouldFindBreakables()
	local latestTime = -1
	for i=0,#nextCheck do
		if nextCheck[i] and nextCheck[i] > latestTime then
			latestTime = nextCheck[i]
		end
	end

	if latestTime > 0 and latestTime <= GetTime() then
		self:FindBreakables()
		for i=0,#nextCheck do
			nextCheck[i] = -1
		end
	end
end

function Breakables:OnEnterCombat()
	self.bCombat = true
	if self.settings.hideInCombat then
		self:ToggleButtonFrameVisibility(false)
	end
end

function Breakables:OnLeaveCombat()
	self.bCombat = false

	if self.bPendingUpdate or self.settings.hideInCombat then
		self.bPendingUpdate = false
		self:FindBreakables()
	end
end

function Breakables:OnTradeSkillUpdate()
	self:GetEnchantingLevel()
	self:FindBreakables()
end

function Breakables:OnBagItemLockPicked()
	self:FindBreakables()
end

function Breakables:PetBattleStarted()
	if self.settings.hideInPetBattle then
		self:ToggleButtonFrameVisibility(false)
	end
end

function Breakables:PetBattleEnded()
	self:ToggleButtonFrameVisibility(true)
end

function Breakables:FindLevelOfProfessionIndex(idx)
	if idx ~= nil then
		local name, texture, rank, maxRank, numSpells, spelloffset, skillLine = GetProfessionInfo(idx)
		return skillLine, rank
	end
end

function Breakables:GetEnchantingLevel()
	if GetProfessions then
		local prof1, prof2 = GetProfessions()

		local skillId, rank = self:FindLevelOfProfessionIndex(prof1)
		if skillId ~= nil and skillId == EnchantingProfessionId then
			self.EnchantingLevel = rank
		else
			skillId, rank = self:FindLevelOfProfessionIndex(prof2)
			if skillId ~= nil and skillId == EnchantingProfessionId then
				self.EnchantingLevel = rank
			end
		end
	end
end

local function GetIgnoreListOptions()
	local ret = {}

	for k,v in pairs(Breakables.settings.ignoreList) do
		local name, _, _, _, _, _, _, _, _, texture = GetItemInfo(k)
		if texture ~= nil and name ~= nil then
			ret[k] = ("|T%s:0|t %s"):format(texture, name)
		end
	end

	return ret
end

local function IsIgnoringAnything()
	for k,v in pairs(Breakables.settings.ignoreList) do
		if v ~= nil then
			return true
		end
	end

	return false
end

function Breakables:GetOptions()
	local opts = {
		name = L["Breakables"],
		handler = Breakables,
		type = "group",
		args = {
			intro = {
				type = "description",
				fontSize = "small",
				name = L["Welcome"],
				order = 0,
			},
			hideAlways = {
				type = "toggle",
				name = L["Hide bar"],
				desc = L["This will completely hide the breakables bar whether you have anything to break down or not. Note that you can toggle this in a macro using the /breakables command as well."],
				get = function(info)
					return self.settings.hide
				end,
				set = function(info, v)
					self.settings.hide = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78maxBreakables|r to " .. tostring(self.settings.hide))
					end
					self:ToggleButtonFrameVisibility(not v)
					if not v then
						self:FindBreakables()
					end
				end,
				order = 1
			},
			hideNoBreakables = {
				type = "toggle",
				name = L["Hide if no breakables"],
				desc = L["Whether or not to hide the action bar if no breakables are present in your bags"],
				get = function(info)
					return self.settings.hideIfNoBreakables
				end,
				set = function(info, v)
					self.settings.hideIfNoBreakables = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78hideIfNoBreakables|r to " .. tostring(self.settings.hideIfNoBreakables))
					end
					self:FindBreakables()
				end,
				order = 2,
			},
			hideInCombat = {
				type = "toggle",
				name = L["Hide during combat"],
				desc = L["Whether or not to hide the breakables bar when you enter combat and show it again when leaving combat."],
				get = function(info)
					return self.settings.hideInCombat
				end,
				set = function(info, v)
					self.settings.hideInCombat = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78hideInCombat|r to " .. tostring(self.settings.hideInCombat))
					end
				end,
				order = 3,
			},
			maxBreakables = {
				type = 'range',
				name = L["Max number to display"],
				desc = L["How many breakable buttons to display next to the profession button at maximum"],
				min = 1,
				max = 50,
				step = 1,
				get = function(info)
					return self.settings.maxBreakablesToShow
				end,
				set = function(info, v)
					self.settings.maxBreakablesToShow = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78maxBreakables|r to " .. tostring(self.settings.maxBreakablesToShow))
					end
					self:FindBreakables()
				end,
				order = 4,
			},
			buttonScale = {
				type = 'range',
				name = L["Button scale"],
				desc = L["This will scale the size of each button up or down."],
				min = 0.1,
				max = 2,
				step = 0.01,
				get = function(info)
					return self.settings.buttonScale
				end,
				set = function(info, v)
					self.settings.buttonScale = v
					Breakables:ApplyScale()
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78buttonScale|r to " .. tostring(self.settings.buttonScale))
					end
				end,
				order = 5,
			},
			fontSize = {
				type = 'range',
				name = L["Font size"],
				desc = L["This sets the size of the text that shows how many items you have to break."],
				min = 4,
				max = 90,
				step = 1,
				get = function(info)
					return self.settings.fontSize
				end,
				set = function(info, v)
					self.settings.fontSize = v
					Breakables:ApplyScale()
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78fontSize|r to " .. tostring(self.settings.fontSize))
					end
				end,
				order = 6,
			},
			growDirection = {
				type = 'select',
				name = L["Button grow direction"],
				desc = L["This controls which direction the breakable buttons grow toward."],
				values = validGrowDirections,
				get = function()
					return self.settings.growDirection
				end,
				set = function(info, v)
					self.settings.growDirection = v
					self:FindBreakables()
				end,
				order = 7,
			},
			showTooltipForBreakables = {
				type = "toggle",
				name = L["Show tooltip on breakables"],
				desc = L["Whether or not to show an item tooltip when hovering over a breakable item button."],
				get = function(info)
					return self.settings.showTooltipForBreakables
				end,
				set = function(info, v)
					self.settings.showTooltipForBreakables = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78showTooltipForBreakables|r to " .. tostring(self.settings.showTooltipForBreakables))
					end
				end,
				order = 8,
			},
			showTooltipForProfession = {
				type = "toggle",
				name = L["Show tooltip on profession"],
				desc = L["Whether or not to show an item tooltip when hovering over a profession button on the Breakables bar."],
				get = function(info)
					return self.settings.showTooltipForProfession
				end,
				set = function(info, v)
					self.settings.showTooltipForProfession = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78showTooltipForProfession|r to " .. tostring(self.settings.showTooltipForProfession))
					end
				end,
				order = 9,
			},
			ignoreList = {
				type = 'multiselect',
				name = L["Ignore list"],
				desc = L["Items that have been right-clicked to exclude from the breakable list. Un-check the box to remove the item from the ignore list."],
				get = function(info, key)
					return true
				end,
				set = function(info, key)
					Breakables.settings.ignoreList[key] = nil
					Breakables:FindBreakables()
				end,
				confirm = function()
					return L["Are you sure you want to remove this item from the ignore list?"]
				end,
				values = GetIgnoreListOptions,
				hidden = function() return not IsIgnoringAnything() end,
				order = 30,
			},
			clearIgnoreList = {
				type = 'execute',
				func = function()
					for k,v in pairs(Breakables.settings.ignoreList) do
						Breakables.settings.ignoreList[k] = nil
					end
					Breakables:FindBreakables()
				end,
				name = L["Clear ignore list"],
				confirm = function()
					return L["Are you sure you want to clear the ignore list?"]
				end,
				hidden = function() return not IsIgnoringAnything() end,
				order = 31,
			},
		},
	}

	if CanDisenchant then
		opts.args.showSoulbound = {
			type = "toggle",
			name = L["Show soulbound items"],
			desc = L["Whether or not to display soulbound items as breakables."],
			get = function(info)
				return self.settings.showSoulbound
			end,
			set = function(info, v)
				self.settings.showSoulbound = v
				if info.uiType == "cmd" then
					print("|cff33ff99Breakables|r: set |cffffff78showSoulbound|r to " .. tostring(self.settings.showSoulbound))
				end
				self:FindBreakables()
			end,
			order = 20,
		}
		if GetNumEquipmentSets or C_EquipmentSet then
			opts.args.hideEqManagerItems = {
				type = "toggle",
				name = L["Hide Eq. Mgr items"],
				desc = L["Whether or not to hide items that are part of an equipment set in the game's equipment manager."],
				get = function(info)
					return self.settings.hideEqManagerItems
				end,
				set = function(info, v)
					self.settings.hideEqManagerItems = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78hideEqManagerItems|r to " .. tostring(self.settings.hideEqManagerItems))
					end
					self:FindBreakables()
				end,
				hidden = function()
					return not self.settings.showSoulbound
				end,
				order = 21,
			}
		end
		if WowVer >= 80000 then
			opts.args.hideTabards = {
				type = "toggle",
				name = L["Hide Tabards"],
				desc = L["Whether or not to hide tabards from the disenchantable items list."],
				get = function(info)
					return self.settings.hideTabards
				end,
				set = function(info, v)
					self.settings.hideTabards = v
					if info.uiType == "cmd" then
						print("|cff33ff99Breakables|r: set |cffffff78hideTabards|r to " .. tostring(self.settings.hideTabards))
					end
					self:FindBreakables()
				end,
				order = 22,
			}
		end
	end

	if UnitCanPetBattle then
		opts.args.hideInPetBattle = {
			type = "toggle",
			name = L["Hide during pet battles"],
			desc = L["Whether or not to hide the breakables bar when you enter a pet battle."],
			get = function(info)
				return self.settings.hideInPetBattle
			end,
			set = function(info, v)
				self.settings.hideInPetBattle = v
				if info.uiType == "cmd" then
					print("|cff33ff99Breakables|r: set |cffffff78hideInPetBattle|r to " .. tostring(self.settings.hideInPetBattle))
				end
			end,
			order = 3.5,
		}
	end

	return opts
end

function Breakables:CreateButtonFrame()
	if not self.frame then
		self.frame = CreateFrame("Frame", nil, UIParent)
	end
	self.frame:SetScale(self.settings.buttonScale)
	if not self.buttonFrame then
		self.buttonFrame = {}
	end

	for i=1,numEligibleProfessions do
		if not self.buttonFrame[i] then
			self.buttonFrame[i] = CreateFrame("Button", "BREAKABLES_BUTTON_FRAME"..i, self.frame, "SecureActionButtonTemplate")
		end
		local frame = self.buttonFrame[i]
		frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.settings.buttonFrameLeft[i], self.settings.buttonFrameTop[i])

		if CanMill and (i == 1 or self.buttonFrame[1].type ~= BREAKABLE_HERB) then
			frame.type = BREAKABLE_HERB
		elseif CanDisenchant and (i == 1 or self.buttonFrame[1].type ~= BREAKABLE_DE) then
			frame.type = BREAKABLE_DE
		elseif CanProspect and (i == 1 or self.buttonFrame[1].type ~= BREAKABLE_ORE) then
			frame.type = BREAKABLE_ORE
		elseif CanPickLock and (i == 1 or self.buttonFrame[1].type ~= BREAKABLE_PICK) then
			frame.type = BREAKABLE_PICK
		end

		if frame.type then
			frame:SetWidth(buttonSize)
			frame:SetHeight(buttonSize)

			frame:EnableMouse(true)
			frame:RegisterForClicks("LeftButtonUp")

			if not frame.OnMouseDownFunc then
				frame.OnMouseDownFunc = function(frame) self:OnMouseDown(frame) end
			end
			if not frame.OnMouseUpFunc then
				frame.OnMouseUpFunc = function(frame) self:OnMouseUp(frame) end
			end

			frame:SetMovable(true)
			frame:RegisterForDrag("LeftButton")
			frame:SetScript("OnMouseDown", frame.OnMouseDownFunc)
			frame:SetScript("OnMouseUp", frame.OnMouseUpFunc)
			frame:SetClampedToScreen(true)

			local spellName, _, texture = GetSpellInfo(self:GetSpellIdFromProfessionButton(frame.type))

			frame:SetAttribute("type1", "spell")
			frame:SetAttribute("spell1", spellName)

			if not lbfGroup then
				frame:SetNormalTexture(texture)
			else
				frame.icon = frame:CreateTexture(frame:GetName().."Icon", "BACKGROUND")
				frame.icon:SetTexture(texture)

				lbfGroup:AddButton(frame)
			end

			if not frame.OnEnterFunc then
				frame.OnEnterFunc = function(this) self:OnEnterProfessionButton(this) end
			end
			if not frame.OnLeaveFunc then
				frame.OnLeaveFunc = function() self:OnLeaveProfessionButton() end
			end

			frame:SetScript("OnEnter", frame.OnEnterFunc)
			frame:SetScript("OnLeave", frame.OnLeaveFunc)
		end
	end
end

function Breakables:GetSpellIdFromProfessionButton(itemType, itemId)
	if itemType == BREAKABLE_HERB and itemId ~= nil then
		if MassMilling[itemId] ~= nil and IsPlayerSpell(MassMilling[itemId]) then
			--return MassMilling[itemId]
		end
	end

	if itemType == BREAKABLE_COMBINE then
		return nil
	end

	return (itemType == BREAKABLE_HERB and MillingId)
		or (itemType == BREAKABLE_ORE and ProspectingId)
		or (itemType == BREAKABLE_DE and DisenchantId)
		or PickLockId
end

function Breakables:ApplyScale()
	if not self.buttonFrame then
		return
	end
	self.frame:SetScale(self.settings.buttonScale)

	for i=1,numEligibleProfessions do
		if self.breakableButtons[i] then
			for j=1,#self.breakableButtons[i] do
				self.breakableButtons[i][j].text:SetFont(NumberFont_Outline_Med:GetFont(), self.settings.fontSize, "OUTLINE")
			end
		end
	end
end

function Breakables:OnMouseDown(frame)
	if IsShiftKeyDown() then
		frame:StartMoving()
	end
end

function Breakables:OnMouseUp(frame)
	frame:StopMovingOrSizing()

	local frameNum = 1
	for i=1,numEligibleProfessions do
		if self.buttonFrame[i] == frame then
			frameNum = i
			break
		end
	end

	self.settings.buttonFrameLeft[frameNum] = frame:GetLeft()
	self.settings.buttonFrameTop[frameNum] = frame:GetTop()
end

local function IgnoreFunc(self, button)
	if button == "RightButton" and not InCombatLockdown() then
		Breakables.settings.ignoreList[self.itemId] = true
		Breakables:FindBreakables()
		LibStub("AceConfigRegistry-3.0"):NotifyChange("Breakables")
	end
end

function Breakables:FindBreakables(bag)
	if self.settings.hide then
		return
	end

	if self.bCombat then
		self.bPendingUpdate = true
		return
	end

	local foundBreakables = {}
	local i=1
	local numBreakableStacks = {}

	for bagId=0,NUM_BAG_SLOTS do
		-- this is where i tried to throttle updates...can't just yet since the full breakables list is rebuilt every time this function is called
		-- consider ways of caching off the last-known state of all breakables
		--if bag == nil or bag == bagId then
			local found = self:FindBreakablesInBag(bagId)
			for n=1,#found do
				local addedToExisting = self:MergeBreakables(found[n], foundBreakables)

				if not addedToExisting then
					foundBreakables[i] = found[n]
					i = i + 1
				end
			end
		--end
	end

	self:SortBreakables(foundBreakables)

	if not self.breakableButtons then
		self.breakableButtons = {}
	end

	for i=1,#foundBreakables do
		for j=1,numEligibleProfessions do
			if not self.breakableButtons[j] then
				self.breakableButtons[j] = {}
			end

			if not numBreakableStacks[j] then
				numBreakableStacks[j] = 0
			end

			if (foundBreakables[i][IDX_BREAKABLETYPE] == self.buttonFrame[j].type or (foundBreakables[i][IDX_BREAKABLETYPE] == BREAKABLE_COMBINE and foundBreakables[i][IDX_COUNT] >= 10)) and numBreakableStacks[j] < self.settings.maxBreakablesToShow then
				local isDisenchantable = self:BreakableIsDisenchantable(foundBreakables[i][IDX_TYPE], foundBreakables[i][IDX_LEVEL], foundBreakables[i][IDX_RARITY], foundBreakables[i][IDX_LINK])
				local isLockedItem = foundBreakables[i][IDX_BREAKABLETYPE] == BREAKABLE_PICK

				if (CanDisenchant and isDisenchantable) or (CanPickLock and isLockedItem) or (foundBreakables[i][IDX_COUNT] >= 5) then
					numBreakableStacks[j] = numBreakableStacks[j] + 1
					local btnIdx = numBreakableStacks[j]

					local btn = self.breakableButtons[j][btnIdx]
					if not self.breakableButtons[j][btnIdx] then
						self.breakableButtons[j][btnIdx] = CreateFrame("Button", "BREAKABLES_BUTTON"..j.."-"..btnIdx, self.buttonFrame[j], "SecureActionButtonTemplate")

						btn = self.breakableButtons[j][btnIdx]

						if lbfGroup then
							btn.icon = btn:CreateTexture(btn:GetName().."Icon", "BACKGROUND")
						end

						btn:SetWidth(buttonSize)
						btn:SetHeight(buttonSize)
						btn:EnableMouse(true)
						btn:RegisterForClicks("AnyUp")

						btn:SetAttribute("type1", "spell")

						if not btn.text then
							btn.text = btn:CreateFontString()
							btn.text:SetPoint("BOTTOM", btn, "BOTTOM", 0, 2)
						end
						btn.text:SetFont(NumberFont_Outline_Med:GetFont(), self.settings.fontSize, "OUTLINE")

						btn:HookScript("OnClick", IgnoreFunc)

						if lbfGroup then
							lbfGroup:AddButton(btn)
						end
					end

					btn.itemId = self:GetItemIdFromLink(foundBreakables[i][IDX_LINK])

					local attachFrom = "LEFT"
					local attachTo = "RIGHT"
					if self.settings.growDirection then
						if self.settings.growDirection == 1 then -- left
							attachFrom = "RIGHT"
							attachTo = "LEFT"
						--elseif self.settings.growDirection == 2 then -- right
						elseif self.settings.growDirection == 3 then -- up
							attachFrom = "BOTTOM"
							attachTo = "TOP"
						elseif self.settings.growDirection == 4 then -- down
							attachFrom = "TOP"
							attachTo = "BOTTOM"
						end
					end

					btn:ClearAllPoints()
					btn:SetPoint(attachFrom, btnIdx == 1 and self.buttonFrame[j] or self.breakableButtons[j][btnIdx - 1], attachTo)

					if not isDisenchantable then
						local appendText = ""
						if not isLockedItem then
							local breakStackSize = 5
							if foundBreakables[i][IDX_BREAKABLETYPE] == BREAKABLE_COMBINE then
								breakStackSize = 10
							end
							appendText = " ("..(floor(foundBreakables[i][IDX_COUNT]/breakStackSize))..")"
						end

						btn.text:SetText(foundBreakables[i][IDX_COUNT] .. appendText)
					end

					local BreakableAbilityName = GetSpellInfo(self:GetSpellIdFromProfessionButton(foundBreakables[i][IDX_BREAKABLETYPE], self:GetItemIdFromLink(foundBreakables[i][IDX_LINK])))
						--GetSpellInfo((foundBreakables[i][IDX_BREAKABLETYPE] == BREAKABLE_HERB and MillingId)
						--or (foundBreakables[i][IDX_BREAKABLETYPE] == BREAKABLE_ORE and ProspectingId)
						--or (foundBreakables[i][IDX_BREAKABLETYPE] == BREAKABLE_DE and DisenchantId)
						--or PickLockId)
					if BreakableAbilityName then
						btn:SetAttribute("type1", "spell")
						btn:SetAttribute("spell", BreakableAbilityName)

						btn:SetAttribute("target-bag", foundBreakables[i][IDX_BAG])
						btn:SetAttribute("target-slot", foundBreakables[i][IDX_SLOT])
					else
						btn:SetAttribute("type1", "item")
						btn:SetAttribute("item", "item:" .. self:GetItemIdFromLink(foundBreakables[i][IDX_LINK]))
					end

					if lbfGroup then
						btn.icon:SetTexture(foundBreakables[i][IDX_TEXTURE])
					else
						btn:SetNormalTexture(foundBreakables[i][IDX_TEXTURE])
					end
					btn.bag = foundBreakables[i][IDX_BAG]
					btn.slot = foundBreakables[i][IDX_SLOT]

					if not btn.OnEnterFunc then
						btn.OnEnterFunc = function(this) self:OnEnterBreakableButton(this) end
					end
					if not btn.OnLeaveFunc then
						btn.OnLeaveFunc = function() self:OnLeaveBreakableButton() end
					end
					if not btn.PostClickedFunc then
						btn.PostClickedFunc = function(this) self:PostClickedBreakableButton(this) end
					end

					btn:SetScript("OnEnter", btn.OnEnterFunc)
					btn:SetScript("OnLeave", btn.OnLeaveFunc)
					btn:SetScript("PostClick", btn.PostClickedFunc)

					btn:Show()
				end
			end
		end
	end

	for i=1,numEligibleProfessions do
		if not numBreakableStacks[i] then
			numBreakableStacks[i] = 0
		end

		if self.breakableButtons[i] and numBreakableStacks[i] < #self.breakableButtons[i] then
			for j=numBreakableStacks[i]+1,#self.breakableButtons[i] do
				self.breakableButtons[i][j]:Hide()
			end
		end

		if self.buttonFrame[i] then
			if numBreakableStacks[i] == 0 and self.settings.hideIfNoBreakables then
				self.buttonFrame[i]:Hide()
			else
				self.buttonFrame[i]:Show()
			end
		end
	end

	if showingTooltip ~= nil then
		self:OnEnterBreakableButton(showingTooltip)
	end
end

function Breakables:OnEnterProfessionButton(btn)
	local spellId = self:GetSpellIdFromProfessionButton(btn.type)
	if spellId and self.settings.showTooltipForProfession then
		GameTooltip:SetOwner(btn, "ANCHOR_BOTTOMLEFT")
		GameTooltip:SetSpellByID(spellId)

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["Hold shift and left-click to drag the Breakables bar around."], 1, 1, 1, 1)
		GameTooltip:Show()
	end
end

function Breakables:OnLeaveProfessionButton()
	GameTooltip:Hide()
end

function Breakables:OnEnterBreakableButton(this)
	if self.settings.showTooltipForBreakables then
		GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
		GameTooltip:SetBagItem(this.bag, this.slot)

		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["You can click on this button to break this item without having to click on the profession button first."], 1, 1, 1, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["You can right-click on this button to ignore this item. Items can be unignored from the options screen."], 1, 1, 1, 1)
		GameTooltip:Show()
		showingTooltip = this
	end
end

function Breakables:OnLeaveBreakableButton()
	if showingTooltip then
		GameTooltip:Hide()
		showingTooltip = nil
	end
end

function Breakables:PostClickedBreakableButton(this)
	if this.type == BREAKABLE_HERB or this.type == BREAKABLE_ORE or this.type == BREAKABLE_DE or this.type == BREAKABLE_COMBINE then
		self.justClicked = true
	end
end

function Breakables:FindBreakablesInBag(bagId)
	local foundBreakables = {}
	local i=1

	if GetBagName(bagId) then
		for slotId=1,GetContainerNumSlots(bagId) do
			local found = self:FindBreakablesInSlot(bagId, slotId)
			if found then
				local addedToExisting = self:MergeBreakables(found, foundBreakables)

				if not addedToExisting then
					foundBreakables[i] = found
					i = i + 1
				end
			end
		end
	end

	return foundBreakables
end

function Breakables:FindBreakablesInSlot(bagId, slotId)
	if not self.myTooltip then
		self.myTooltip = CreateFrame("GameTooltip", "BreakablesTooltip", nil, "GameTooltipTemplate")
		self.myTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	end

	local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bagId, slotId)
	if texture then
		local itemLink = GetContainerItemLink(bagId, slotId)
		local itemId = self:GetItemIdFromLink(itemLink)
		if self.settings.ignoreList[itemId] then
			return nil
		end

		local itemName, _, itemRarity, itemLevel, _, itemType, itemSubType, _, equipSlot, itemTexture, vendorPrice = GetItemInfo(itemLink)

		self.myTooltip:SetBagItem(bagId, slotId)

		if CanDisenchant and itemRarity and itemRarity >= RARITY_UNCOMMON and itemRarity < RARITY_HEIRLOOM
			and self:BreakableIsDisenchantable(itemType, itemLevel, itemRarity, itemLink, itemId) then
			local i = 1
			local soulbound = false
			for i=1,15 do
				if _G["BreakablesTooltipTextLeft"..i] then
					local textLine = _G["BreakablesTooltipTextLeft"..i]:GetText()
					if textLine == ITEM_SOULBOUND or textLine == ITEM_ACCOUNTBOUND or textLine == ITEM_BNETACCOUNTBOUND then
						soulbound = true
						break
					end
				end
			end

			local isInEquipmentSet = false
			if self.settings.hideEqManagerItems then
				isInEquipmentSet = self:IsInEquipmentSet(itemId)
			end

			local isTabard = false
			if self.settings.hideTabards then
				isTabard = equipSlot == "INVTYPE_TABARD"
			end

			local shouldHideThisItem = (self.settings.hideEqManagerItems and isInEquipmentSet) or (self.settings.hideTabards and isTabard)
				or equipSlot == nil or (equipSlot == "" and not IsArtifactRelicItem(itemLink))

			if (not soulbound or self.settings.showSoulbound) and not shouldHideThisItem then
				return {itemLink, itemCount, itemType, itemTexture, bagId, slotId, itemSubType, itemLevel, BREAKABLE_DE, soulbound, itemName, itemRarity}
			else
				return nil
			end
		end

		local idx = 1
		local millable = false
		local prospectable = false
		for idx=1,5 do
			if _G["BreakablesTooltipTextLeft"..idx] then
				if _G["BreakablesTooltipTextLeft"..idx]:GetText() == ITEM_MILLABLE then
					millable = true
					break
				elseif _G["BreakablesTooltipTextLeft"..idx]:GetText() == ITEM_PROSPECTABLE then
					prospectable = true
					break
				end
			end
		end

		if CanMill and not millable then
			for i=1,#AdditionalMillableItems do
				if AdditionalMillableItems[i] == itemId then
					millable = true
				end
			end
		end

		if CanProspect then
			if not prospectable then
				for i=1,#AdditionalProspectableItems do
					if AdditionalProspectableItems[i] == itemId then
						prospectable = true
					end
				end
			end
			if prospectable then
				for i=1,#UnProspectableItems do
					if UnProspectableItems[i] == itemId then
						prospectable = false
					end
				end
			end
		end

		if CanMill --[[and (itemSubType == MillingItemSubType or itemSubType == MillingItemSecondarySubType)]] then
			if millable then
				return {itemLink, itemCount, itemType, itemTexture, bagId, slotId, itemSubType, itemLevel, BREAKABLE_HERB, false, itemName, itemRarity}
			else
				for i=1,#HerbCombineItems do
					if HerbCombineItems[i] == itemId then
						return {itemLink, itemCount, itemType, itemTexture, bagId, slotId, itemSubType, itemLevel, BREAKABLE_COMBINE, false, itemName, itemRarity}
					end
				end
			end
		end

		if CanProspect --[[and itemSubType == ProspectingItemSubType]] then
			if prospectable then
				return {itemLink, itemCount, itemType, itemTexture, bagId, slotId, itemSubType, itemLevel, BREAKABLE_ORE, false, itemName, itemRarity}
			else
				for i=1,#OreCombineItems do
					if OreCombineItems[i] == itemId then
						return {itemLink, itemCount, itemType, itemTexture, bagId, slotId, itemSubType, itemLevel, BREAKABLE_COMBINE, false, itemName, itemRarity}
					end
				end
			end
		end

		if CanPickLock and self:ItemIsPickable(itemId) and self:ItemIsLocked(bagId, slotId) then
			return {itemLink, itemCount, itemType, itemTexture, bagId, slotId, itemSubType, itemLevel, BREAKABLE_PICK, false, itemName, itemRarity}
		end
	end

	return nil
end

function Breakables:ItemIsPickable(itemId)
	for i=1,#PickableItems do
		if PickableItems[i] == itemId then
			return true
		end
	end

	return nil
end

do
	local regions = {}
	local tooltipBuffer = CreateFrame("GameTooltip","tooltipBuffer",nil,"GameTooltipTemplate")
	tooltipBuffer:SetOwner(WorldFrame, "ANCHOR_NONE")

	local function makeTable(t, ...)
		wipe(t)
		for i = 1, select("#", ...) do
			t[i] = select(i, ...)
		end
	end

	function Breakables:ItemIsLocked(bagId, slotId)
		tooltipBuffer:ClearLines()
		tooltipBuffer:SetBagItem(bagId, slotId)

		-- Grab all regions, stuff em into our table
		makeTable(regions, tooltipBuffer:GetRegions())

		-- Convert FontStrings to strings, replace anything else with ""
		for i=1, #regions do
			local region = regions[i]
			if region:GetObjectType() == "FontString" then
				if region:GetText() == LOCKED then
					return true
				end
			end
		end

		return false
	end
end

function Breakables:IsInEquipmentSet(itemId)
	if WowVer < 80000 and GetNumEquipmentSets then
		for setIdx=1, GetNumEquipmentSets() do
			local set = GetEquipmentSetInfo(setIdx)
			local itemArray = GetEquipmentSetItemIDs(set)

			for i=1, EQUIPPED_LAST do
				if itemArray[i] and itemArray[i] == itemId then
					return true
				end
			end
		end
	elseif C_EquipmentSet then
		local sets = C_EquipmentSet.GetEquipmentSetIDs()
		for k, v in ipairs(sets) do
			local itemArray = C_EquipmentSet.GetItemIDs(v)

			for i=1, EQUIPPED_LAST do
				if itemArray[i] and itemArray[i] == itemId then
					return true
				end
			end
		end
	end

	return false
end

function Breakables:GetItemIdFromLink(itemLink)
	local _, foundItemId = strsplit(":", itemLink)
	return tonumber(foundItemId)
end

function Breakables:MergeBreakables(foundBreakable, breakableList)
	for n=1,#breakableList do
		if foundBreakable[IDX_LINK] == breakableList[n][IDX_LINK] then
			-- always prefer the larger stack
			if foundBreakable[IDX_COUNT] > breakableList[n][IDX_COUNT] then
				breakableList[n][IDX_BAG] = foundBreakable[IDX_BAG]
				breakableList[n][IDX_SLOT] = foundBreakable[IDX_SLOT]
			end
			breakableList[n][IDX_COUNT] = breakableList[n][IDX_COUNT] + foundBreakable[IDX_COUNT]
			return true
		end
	end

	return false
end

function Breakables:SortBreakables(foundBreakables)
	for i=1,#foundBreakables do
		local iId = self:GetItemIdFromLink(foundBreakables[i][IDX_LINK])
		for j=i,#foundBreakables do
			local jId = self:GetItemIdFromLink(foundBreakables[j][IDX_LINK])
			if iId < jId then
				local temp = foundBreakables[i]
				foundBreakables[i] = foundBreakables[j]
				foundBreakables[j] = temp
			end
		end
	end
end

function Breakables:BreakableIsDisenchantable(itemType, itemLevel, itemRarity, itemLink, itemId)
	for i=1,#DisenchantTypes do
		if DisenchantTypes[i] == itemType or IsArtifactRelicItem(itemLink) then
			-- temp hack for bfa until disenchant item level scales are identified. and for classic until finding the profession level api
			if WowVer >= 80000 or IsClassic or IsClassicBC then
				return true
			end

			-- account for WoD and higher no longer needing specific ilvl. numbers from http://wow.gamepedia.com/Item_level
			if (itemRarity == RARITY_UNCOMMON and itemLevel >= 483)
				or (itemRarity == RARITY_RARE and itemLevel >= 515)
				or (itemRarity == RARITY_EPIC and itemLevel >= 640) then
				return true
			end

			-- this is awful. is there an easier way? taken from www.wowpedia.org/Disenchanting
			if itemRarity == RARITY_UNCOMMON then
				if itemLevel <= 20 then
					return self.EnchantingLevel >= 1
				elseif itemLevel <= 25 then
					return self.EnchantingLevel >= 25
				elseif itemLevel <= 30 then
					return self.EnchantingLevel >= 50
				elseif itemLevel <= 35 then
					return self.EnchantingLevel >= 75
				elseif itemLevel <= 40 then
					return self.EnchantingLevel >= 100
				elseif itemLevel <= 45 then
					return self.EnchantingLevel >= 125
				elseif itemLevel <= 50 then
					return self.EnchantingLevel >= 150
				elseif itemLevel <= 55 then
					return self.EnchantingLevel >= 175
				elseif itemLevel <= 60 then
					return self.EnchantingLevel >= 200
				elseif itemLevel <= 99 then
					return self.EnchantingLevel >= 225
				elseif itemLevel <= 120 then
					return self.EnchantingLevel >= 275
				elseif itemLevel <= 150 then
					return self.EnchantingLevel >= 325
				elseif itemLevel <= 182 then
					return self.EnchantingLevel >= 350
				elseif itemLevel <= 318 then
					return self.EnchantingLevel >= 425
				elseif itemLevel <= 437 then
					return self.EnchantingLevel >= 475
				else
					return self.EnchantingLevel >= 475
				end
			elseif itemRarity == RARITY_RARE then
				if itemLevel <= 25 then
					return self.EnchantingLevel >= 25
				elseif itemLevel <= 30 then
					return self.EnchantingLevel >= 50
				elseif itemLevel <= 35 then
					return self.EnchantingLevel >= 75
				elseif itemLevel <= 40 then
					return self.EnchantingLevel >= 100
				elseif itemLevel <= 45 then
					return self.EnchantingLevel >= 125
				elseif itemLevel <= 50 then
					return self.EnchantingLevel >= 150
				elseif itemLevel <= 55 then
					return self.EnchantingLevel >= 175
				elseif itemLevel <= 60 then
					return self.EnchantingLevel >= 200
				elseif itemLevel <= 97 then
					return self.EnchantingLevel >= 225
				elseif itemLevel <= 115 then
					return self.EnchantingLevel >= 275
				elseif itemLevel <= 200 then
					return self.EnchantingLevel >= 325
				elseif itemLevel <= 346 then
					return self.EnchantingLevel >= 450
				elseif itemLevel <= 424 then
					return self.EnchantingLevel >= 525
				elseif itemLevel <= 463 then
					return self.EnchantingLevel >= 550
				else
					return self.EnchantingLevel >= 550
				end
			elseif itemRarity == RARITY_EPIC then
				if itemLevel <= 95 then
					return self.EnchantingLevel >= 225
				elseif itemLevel <= 164 then
					return self.EnchantingLevel >= 300
				elseif itemLevel <= 277 then
					return self.EnchantingLevel >= 375
				elseif itemLevel <= 416 then
					return self.EnchantingLevel >= 475
				elseif itemLevel <= 575 then
					return self.EnchantingLevel >= 575
				else
					return self.EnchantingLevel >= 575
				end
			else
				return false
			end
			return true
		end
	end

	for i=1,#AdditionalDisenchantableItems do
		if AdditionalDisenchantableItems[i] == itemId then
			return true
		end
	end

	return false
end
