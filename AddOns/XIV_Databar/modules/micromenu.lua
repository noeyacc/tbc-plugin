local AddOnName, XIVBar = ...;
local _G = _G;
local xb = XIVBar;
local L = XIVBar.L;

local MenuModule = xb:NewModule("MenuModule", 'AceEvent-3.0')

function MenuModule:GetName()
  return L['Micromenu'];
end

function MenuModule:OnInitialize()
  self.LTip=LibStub('LibQTip-1.0')
  self.mediaFolder = xb.constants.mediaPath..'microbar\\'
  self.icons = {}
  self.modifiers={SHIFT_KEY_TEXT,ALT_KEY_TEXT,CTRL_KEY_TEXT}
  self.frames = {}
  self.text = {}
  self.bgTexture = {}
  self.functions = {}
  self.menuWidth = 0
  self.iconSize = xb:GetHeight();
  self:CreateClickFunctions()
  self.socialIcons = {
    BSAp = {
      text = BNET_CLIENT_APP
    },
    App = {
      text = BNET_CLIENT_APP
    },
    D3 = {
      text = L['Diablo 3']
    },
	W3 = {
      text = L['Warcraft 3']
    },
    S1 = {
      text = L['Starcraft Remastered']
    },
    S2 = {
      text = L['Starcraft 2']
    },
    WTCG = {
      text = L['Hearthstone']
    },
    Hero = {
      text = L['Heroes of the Storm']
    },
    Pro = {
      text = L['Overwatch']
    },
    WoW = {
      text = ''
    },
    DST2 = {
      text = L['Destiny 2']
    },
    VIPR = {
      text = L['Call of Duty: Black Ops 4']
    },
	ODIN = {
      text = L['Call of Duty: Modern Warfare']
    },
	LAZR = {
      text = L['Call of Duty: Modern Warfare 2']
    },
	ZEUS = {
      text = L['Call of Duty: Black Ops Cold War']
    },
	OSI = {
      text = L['Diablo II: Resurrected']
    }
  }
end

-- Skin Support for ElvUI/TukUI
function MenuModule:SkinFrame(frame, name)
	if IsAddOnLoaded("ElvUI") or IsAddOnLoaded("Tukui") then
		if frame.StripTextures then
			frame:StripTextures()
		end
		if frame.SetTemplate then
			frame:SetTemplate("Transparent")
		end

		local close = _G[name.."CloseButton"] or frame.CloseButton
		if close and close.SetAlpha then
			if ElvUI then
				ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
			end

			if Tukui and Tukui[1] and Tukui[1].SkinCloseButton then
				Tukui[1].SkinCloseButton(close)
			end
			close:SetAlpha(1)
		end
	end
end

function MenuModule:OnEnable()
  if not xb.db.profile.modules.microMenu.enabled then return; end
  if self.microMenuFrame == nil then
    self.microMenuFrame = CreateFrame("FRAME", L['Micromenu'], xb:GetFrame('bar'))
    xb:RegisterFrame('microMenuFrame', self.microMenuFrame)
  end

  self.microMenuFrame:Show()

  if not self.frames.menu then
	self:CreateFrames()
	self:RegisterFrameEvents()
	self:CreateIcons()
  end
  xb:Refresh()
end

function MenuModule:OnDisable()
  self.microMenuFrame:Hide()
  self:UnregisterFrameEvents()
  xb:Refresh()
end

function MenuModule:Refresh()
  if not xb.db.profile.modules.microMenu.enabled then self:Disable(); return; end
  
  if self.frames.menu == nil then return; end

  if InCombatLockdown() then
    self:RegisterEvent('PLAYER_REGEN_ENABLED', function()
      self:Refresh()
      self:UnregisterEvent('PLAYER_REGEN_ENABLED')
    end)
    return
  end

  self.modifier=self.modifiers[xb.db.profile.modules.microMenu.modifierTooltip];

  self.iconSize = xb:GetHeight();

  local colors = xb.db.profile.color
  local totalWidth = 0;
  for name, frame in pairs(self.frames) do
    self:IconDefaults(name)
    if name == 'menu' then
      frame:SetPoint("LEFT", xb.db.profile.modules.microMenu.iconSpacing, 0)
      totalWidth = totalWidth + frame:GetWidth() + xb.db.profile.modules.microMenu.iconSpacing
    elseif frame:GetParent():GetName() == 'menu' then
      frame:SetPoint("LEFT", frame:GetParent(), "RIGHT", xb.db.profile.modules.microMenu.mainMenuSpacing, 0)
      totalWidth = totalWidth + frame:GetWidth() + xb.db.profile.modules.microMenu.mainMenuSpacing
    else
      frame:SetPoint("LEFT", frame:GetParent(), "RIGHT", xb.db.profile.modules.microMenu.iconSpacing, 0)
      totalWidth = totalWidth + frame:GetWidth() + xb.db.profile.modules.microMenu.iconSpacing
    end
  end
  self.microMenuFrame:SetPoint("LEFT", xb.db.profile.general.barPadding, 0)
  self.microMenuFrame:SetSize(totalWidth, xb:GetHeight())

  for name, frame in pairs(self.text) do
    frame:SetFont(xb:GetFont(xb.db.profile.text.smallFontSize))
    frame:SetPoint('CENTER', self.frames[name], xb.miniTextPosition)
    self.bgTexture[name]:SetColorTexture(xb.db.profile.color.barColor.r, xb.db.profile.color.barColor.g, xb.db.profile.color.barColor.b, xb.db.profile.color.barColor.a)
    self.bgTexture[name]:SetPoint('CENTER', frame, 'CENTER')
    if xb.db.profile.modules.microMenu.hideSocialText then
      frame:Hide()
	else
	  frame:Show()
    end
  end

  self:UpdateFriendText()
  self:UpdateGuildText()
end

function MenuModule:UpdateMenu()
	for _,frame in pairs(self.frames) do
		frame:Hide()
	end
	self:UnregisterFrameEvents()
	self:CreateFrames()
	self:CreateIcons()
	self:RegisterFrameEvents()
end

function MenuModule:CreateFrames()
  parentFrame = xb:GetFrame('microMenuFrame')

  if xb.db.profile.modules.microMenu.menu then
    self.frames.menu = CreateFrame("BUTTON", "menu", parentFrame)
    parentFrame = self.frames.menu
  else
	if self.frames.menu then
		self.frames.menu = nil
	end
  end

  if xb.db.profile.modules.microMenu.chat then
    self.frames.chat = CreateFrame("BUTTON", "chat", parentFrame)
    parentFrame = self.frames.chat
  else
	if self.frames.chat then
		self.frames.chat = nil
	end
  end

  if xb.db.profile.modules.microMenu.guild then
    self.frames.guild = CreateFrame("BUTTON", "guild", parentFrame)
    parentFrame = self.frames.guild
	self.text.guild = self.frames.guild:CreateFontString(nil, 'OVERLAY')
    self.bgTexture.guild = self.frames.guild:CreateTexture(nil, "OVERLAY")
  else
	if self.frames.guild then
		self.frames.guild = nil
		self.text.guild = nil
		self.bgTexture.guild = nil
	end
  end

  if xb.db.profile.modules.microMenu.social then
    self.frames.social = CreateFrame("BUTTON", "social", parentFrame)
    parentFrame = self.frames.social
	self.text.social = self.frames.social:CreateFontString(nil, 'OVERLAY')
    self.bgTexture.social = self.frames.social:CreateTexture(nil, "OVERLAY")
  else
	if self.frames.social then
		self.frames.social = nil
		self.text.social = nil
		self.bgTexture.social = nil
	end
  end

  if xb.db.profile.modules.microMenu.char then
    self.frames.char = CreateFrame("BUTTON", "char", parentFrame)
    parentFrame = self.frames.char
  else
	if self.frames.char then
		self.frames.char = nil
	end
  end

  if xb.db.profile.modules.microMenu.spell then
    self.frames.spell = CreateFrame("BUTTON", "spell", parentFrame)
    parentFrame = self.frames.spell
  else
	if self.frames.spell then
		self.frames.spell = nil
	end
  end

  if xb.db.profile.modules.microMenu.talent then
    self.frames.talent = CreateFrame("BUTTON", "talent", parentFrame)
    parentFrame = self.frames.talent
  else
	if self.frames.talent then
		self.frames.talent = nil
	end
  end

  if xb.db.profile.modules.microMenu.quest then
    self.frames.quest = CreateFrame("BUTTON", "quest", parentFrame)
    parentFrame = self.frames.quest
  else
	if self.frames.quest then
		self.frames.quest = nil
	end
  end

  if xb.db.profile.modules.microMenu.lfg then
    self.frames.lfg = CreateFrame("BUTTON", "lfg", parentFrame)
    parentFrame = self.frames.lfg
  else
	if self.frames.lfg then
		self.frames.lfg = nil
	end
  end

  if xb.db.profile.modules.microMenu.help then
    self.frames.help = CreateFrame("BUTTON", "help", parentFrame)
    parentFrame = self.frames.help
  else
	if self.frames.help then
		self.frames.help = nil
	end
  end

end

function MenuModule:CreateIcons()
  for name, frame in pairs(self.frames) do
    if frame['Click'] ~= nil then --Odd way of checking if it's a button
        self.icons[name] = frame:CreateTexture(nil, "OVERLAY")
        self.icons[name]:SetTexture(self.mediaFolder..name)
    end
  end
end

function MenuModule:IconDefaults(name)
  local colors = xb.db.profile.color
  if self.frames[name] == nil then return; end
  if self.frames[name]['Click'] ~= nil then
    self.frames[name]:SetSize(self.iconSize, self.iconSize)
  else
    self.frames[name]:SetSize(floor(self.iconSize / 3), self.iconSize)
  end

  if self.icons[name] == nil then return; end
  self.icons[name]:SetPoint('CENTER')
  self.icons[name]:SetSize(self.iconSize, self.iconSize)
  self.icons[name]:SetVertexColor(colors.normal.r, colors.normal.g, colors.normal.b, colors.normal.a)
end

function MenuModule:RegisterFrameEvents()
  for name, frame in pairs(self.frames) do
    frame:EnableMouse(true)

    if frame['Click'] ~= nil then
      frame:RegisterForClicks("AnyUp")
      if self.functions[name] ~= nil then
        frame:SetScript('OnClick', self.functions[name])
      end
    end
    if name == 'guild' then
      local leaveFunc = self:DefaultLeave(name)
      frame:SetScript("OnEnter", self:GuildHover(self:DefaultHover(name)))
      frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
        leaveFunc()
      end)
    elseif name == 'social' then
      local leaveFunc = self:DefaultLeave(name)
      frame:SetScript("OnEnter", self:SocialHover(self:DefaultHover(name)))
      frame:SetScript("OnLeave", leaveFunc)
    else
      frame:SetScript("OnEnter", self:DefaultHover(name))
      frame:SetScript("OnLeave", self:DefaultLeave(name))
    end
  end

  self:RegisterEvent('GUILD_ROSTER_UPDATE', function()
    self:UpdateGuildText()
  end)
  self:RegisterEvent('CHAT_MSG_GUILD', function()
    self:UpdateGuildText()
  end)
  self:RegisterEvent('BN_FRIEND_ACCOUNT_ONLINE', 'UpdateFriendText')
  self:RegisterEvent('BN_FRIEND_ACCOUNT_OFFLINE', 'UpdateFriendText')
  self:RegisterEvent('FRIENDLIST_UPDATE', 'UpdateFriendText')
end

function MenuModule:UnregisterFrameEvents()
  self:UnregisterEvent('GUILD_ROSTER_UPDATE')
  self:UnregisterEvent('BN_FRIEND_ACCOUNT_ONLINE')
  self:UnregisterEvent('BN_FRIEND_ACCOUNT_OFFLINE')
  self:UnregisterEvent('FRIENDLIST_UPDATE')
end

function MenuModule:UpdateGuildText()
  if xb.db.profile.modules.microMenu.hideSocialText or not xb.db.profile.modules.microMenu.guild then return; end
  GuildRoster()
  if IsInGuild() then
    local _, onlineMembers = GetNumGuildMembers()
    self.text.guild:SetText(onlineMembers)
    self.bgTexture.guild:SetPoint('CENTER', self.text.guild)
  else
    self.text.guild:Hide()
    self.bgTexture.guild:Hide()
  end
end

function MenuModule:UpdateFriendText()
  if xb.db.profile.modules.microMenu.hideSocialText or not xb.db.profile.modules.microMenu.social then return; end
  local _, bnOnlineMembers = BNGetNumFriends()
  local friendsOnline = C_FriendList.GetNumOnlineFriends()
  local totalFriends = bnOnlineMembers + friendsOnline
  self.text.social:SetText(totalFriends)
  self.bgTexture.social:SetPoint('CENTER', self.text.social)
end

function MenuModule:DefaultHover(name)
  return function()
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if self.icons[name] ~= nil then
      self.icons[name]:SetVertexColor(unpack(xb:HoverColors()))
	  self.tipHover=(name=="social")
	  self.gtipHover=(name=="guild")
    end
  end
end

function MenuModule:DefaultLeave(name)
  return function()
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if self.icons[name] ~= nil then
      self.icons[name]:SetVertexColor(xb.db.profile.color.normal.r, xb.db.profile.color.normal.g, xb.db.profile.color.normal.b, xb.db.profile.color.normal.a)
    end
  end
end

local function GetFriendInfo(friend)
    local info;
    if type(friend) == "number" then
      info = C_FriendList.GetFriendInfoByIndex(friend);
    elseif type(friend) == "string" then
      info = C_FriendList.GetFriendInfo(friend);
    end
 
    if info then
      local chatFlag = "";
      if info.dnd then
        chatFlag = CHAT_FLAG_DND;
      elseif info.afk then
        chatFlag = CHAT_FLAG_AFK;
      end
      return info.name,
        info.level,
        info.className,
        info.area,
        info.connected,
        chatFlag,
        info.notes,
        info.referAFriend,
        info.guid;
    end
end

function MenuModule:SocialHover(hoverFunc)
  return function()
    if not xb.db.profile.modules.microMenu.showTooltips then
      hoverFunc()
      return
    end

	local modifierFunc = IsShiftKeyDown
	if self.modifier == "ALT" then
		modifierFunc = IsAltKeyDown
	elseif self.modifier == "CONTROL" then
		modifierFunc = IsControlKeyDown
	end

	if self.LTip:IsAcquired("SocialToolTip") then
		self.LTip:Release(self.LTip:Acquire("SocialToolTip"))
	end
	local tooltip = self.LTip:Acquire("SocialToolTip", 2, "LEFT", "RIGHT")
	tooltip:EnableMouse(true)
	tooltip:SetScript("OnEnter",function() self.tipHover=true end)
	tooltip:SetScript("OnLeave",function() self.tipHover=false end)
	tooltip:SetScript("OnUpdate",function() if not self.tipHover and not self.lineHover then tooltip:Release() end end)
	MenuModule:SkinFrame(tooltip, "SocialToolTip")
    local totalBNFriends, totalBNOnlineFriends = BNGetNumFriends()
    local totalOnlineFriends = C_FriendList.GetNumOnlineFriends()
	local charNameFormat
    if (totalOnlineFriends + totalBNOnlineFriends) > 0 then
      tooltip:SmartAnchorTo(MenuModule.frames.social)
      tooltip:AddHeader('[|cff6699FF'..L['Social']..'|r]')
      tooltip:AddLine(' ',' ')
    end
	
	-- 名字顯示職業顏色用的對照表
	local colorHex
	local classLocTable = {
		["死亡騎士"] = "DEATHKNIGHT",
		["惡魔獵人"] = "DEMONHUNTER",
		["德魯伊"] = "DRUID",
		["獵人"] = "HUNTER",
		["法師"] = "MAGE",
		["武僧"] = "MONK",
		["聖騎士"] = "PALADIN",
		["牧師"] = "PRIEST",
		["盜賊"] = "ROGUE",
		["薩滿"] = "SHAMAN",
		["術士"] = "WARLOCK",
		["戰士"] = "WARRIOR",
	}

    if totalBNOnlineFriends then
      local clientsList = {BNET_CLIENT_WOW,BNET_CLIENT_SC2,BNET_CLIENT_D3,BNET_CLIENT_WTCG,BNET_CLIENT_HEROES,BNET_CLIENT_OVERWATCH,BNET_CLIENT_SC,BNET_CLIENT_DESTINY2,BNET_CLIENT_COD}

      for i = 1, BNGetNumFriends() do
        local battleID, battleName, battleTag, _, charName, gameAccount, gameClient, isOnline, _, isAfk, isDnd, _, note = BNGetFriendInfo(i)
        if isOnline then
          if not battleTag then
            battleTag = '['..L['No Tag']..']'
          end

          local _, _, _, realmName, _, _, _, class, _, zoneName, level, gameText = BNGetGameAccountInfo(gameAccount)
          local status = FRIENDS_LIST_ONLINE
          local statusIcon = FRIENDS_TEXTURE_ONLINE
          local socialIcon = BNet_GetClientTexture(gameClient)
          local gameName = MenuModule.socialIcons[gameClient].text

          if isAfk then
            statusIcon = FRIENDS_TEXTURE_AFK
            status = DEFAULT_AFK_MESSAGE
          end
          if isDnd then
            statusIcon = FRIENDS_TEXTURE_DND
            status = DEFAULT_DND_MESSAGE
          end

          if gameClient == BNET_CLIENT_WOW then
			-- 名字顯示職業顏色
			colorHex = "ffffffff"
			if classLocTable[class] then
				colorHex = RAID_CLASS_COLORS[classLocTable[class]].colorStr
			end
			if charName then
				charNameFormat = level.." |c"..colorHex..charName
				if realmName ~= '' then 
					charNameFormat = charNameFormat.."-"..realmName.."|r"
				end
				if zoneName ~= '' then
					zoneName = "@"..zoneName
				end
			else
				charNameFormat = UNKNOWN
			end
			
			if (not realmName or realmName == '') then
				if gameText and gameText ~= '' then
					zoneName = "@"..gameText -- zoneName .. L["BFA"]
				else
					zoneName = zoneName .. L["BFA"]
				end
			end
			charNameFormat = charNameFormat.." |cff999999"..zoneName.."|r"
          else
            charNameFormat = "|cff999999"..gameText.."|r"
          end

          if note ~= '' then
            note = "(|cffecd672"..note.."|r)"
          end

          if tContains(clientsList,gameClient) or not xb.db.profile.modules.microMenu.hideAppContact then
            local lineLeft = string.format("|T%s:16|t %s", statusIcon, charNameFormat)
			local lineRight = string.format("%s |cff82c5ff%s|r %s|T%s:16|t", note, battleName, gameName, socialIcon)
			tooltip:AddLine(lineLeft, lineRight)
      		tooltip:SetLineScript(tooltip:GetLineCount(),"OnEnter",function() self.lineHover = true;end)
      		tooltip:SetLineScript(tooltip:GetLineCount(),"OnLeave",function() self.lineHover = false; end)
      		tooltip:SetLineScript(tooltip:GetLineCount(),"OnMouseUp",function(self,_,button)

			if button == "LeftButton" then
  				if modifierFunc() then
  					if CanGroupWithAccount(battleID) then
  						InviteToGroup(charName.."-"..realmName)
  					end
  				else
  					ChatFrame_SendBNetTell(battleName)
  				end
			
  			elseif button == "RightButton" then
				if charName ~= '' and realmName ~= '' then
  					ChatFrame_SendTell(charName.."-"..realmName)
  				end
  			
			end
			
  		  end)
            end --optApp
        end -- isOnline
      end -- for in BNGetNumFriends
    end -- totalBNOnlineFriends

    if totalOnlineFriends then
      -- 暫時修正
	  for i = 1, C_FriendList.GetNumOnlineFriends() do
        local name, level, class, area, isOnline, status, note = GetFriendInfo(i)
        if isOnline then
          local status = FRIENDS_LIST_ONLINE
          local statusIcon = FRIENDS_TEXTURE_ONLINE
          if isAfk then
            statusIcon = FRIENDS_TEXTURE_AFK
            status = DEFAULT_AFK_MESSAGE
          end
          if isDnd then
            statusIcon = FRIENDS_TEXTURE_DND
            status = DEFAULT_DND_MESSAGE
          end
		  
		  -- 名字顯示職業顏色
		  colorHex = "ffffffff"
		  if classLocTable[class] then
		      colorHex = RAID_CLASS_COLORS[classLocTable[class]].colorStr
		  end
		  
		  charNameFormat = level.." |c"..colorHex..name.."|r |cff999999@"..area.."|r "
		  
		  if note then
            note = "(|cffecd672"..note.."|r)"
		  else
			note = ""
          end
          
		  local lineLeft = string.format("|T%s:16|t %s", statusIcon, charNameFormat)
		  local lineRight = note
          tooltip:AddLine(lineLeft, lineRight)
		  tooltip:SetLineScript(tooltip:GetLineCount(),"OnEnter",function() self.lineHover = true;end)
		  tooltip:SetLineScript(tooltip:GetLineCount(),"OnLeave",function() self.lineHover = false; end)
		  tooltip:SetLineScript(tooltip:GetLineCount(),"OnMouseUp",function(self,_,button)
		    --[[ 角色好友只能密語同伺服器的，還不支援伺服器群組。
			if not name:find('%u%U*-%u%U') then
				local homeRealm = GetRealmName()
				homeRealm = homeRealm:gsub("%s+", "")
				name=name.."-"..homeRealm
			end
			--]]
			if button == "RightButton" then
				ChatFrame_SendTell(name)
			elseif button == "LeftButton" then
				if modifierFunc() then
					InviteUnit(name)
				end
			end
		  end)
        end -- isOnline
      end -- for in GetNumFriends
    end -- totalOnlineFriends

	tooltip:AddLine(' ',' ')
	tooltip:AddLine('|cffffff00<'..L['Left-Click']..'>|r', '|cffffffff'..L['Whisper BNet']..'|r')
    tooltip:AddLine('|cffffff00<'..L['Right-Click']..'>|r', '|cffffffff'..L['Whisper Character']..'|r')
	tooltip:AddLine('|cffffff00<'..self.modifier..'+'..L['Left-Click']..'>|r', '|cffffffff'..CALENDAR_INVITELIST_INVITETORAID..'|r')
    if (totalOnlineFriends + totalBNOnlineFriends) > 0 then
      tooltip:Show()
    end
    hoverFunc()
  end
end

function MenuModule:GuildHover(hoverFunc)
  return function()
    if not IsInGuild() then
      hoverFunc()
      return
    end
    if not xb.db.profile.modules.microMenu.showTooltips then
      hoverFunc()
      return
    end

	local modifierFunc = IsShiftKeyDown
	if self.modifier == "ALT" then
		modifierFunc = IsAltKeyDown
	elseif self.modifier == "CONTROL" then
		modifierFunc = IsControlKeyDown
	end

	if self.LTip:IsAcquired("GuildToolTip") then
		self.LTip:Release(self.LTip:Acquire("GuildToolTip"))
	end
	local tooltip = self.LTip:Acquire("GuildToolTip", 2, "LEFT","RIGHT")
	tooltip:EnableMouse(true)
	tooltip:SetScript("OnEnter",function() self.gtipHover=true end)
	tooltip:SetScript("OnLeave",function() self.gtipHover=false end)
	tooltip:SetScript("OnUpdate",function() if not self.gtipHover and not self.glineHover then tooltip:Release() end end)
	MenuModule:SkinFrame(tooltip, "SocialToolTip")

    GuildRoster()
    tooltip:SmartAnchorTo(MenuModule.frames.guild)
	local gName, _, _, _ = GetGuildInfo('player')
    tooltip:AddHeader("[|cff6699FF"..GUILD.."|r]",'|cff00ff00'..gName..'|r')
    tooltip:AddLine(" "," ")
	if xb.db.profile.modules.microMenu.showGMOTD then
		if GetGuildRosterMOTD() ~= "" then
			tooltip:AddLine('|cff00ff00'..GetGuildRosterMOTD()..'|r', ' ') --should be cut down
		end
	end
	
	-- 台服不顯示伺服器名稱
	local realmName, hideRealmName
	realmName = GetRealmName()
	if realmName == "伊弗斯" or realmName == "馬拉頓" then
		hideRealmName = true
	end

    local totalGuild, _ = GetNumGuildMembers()
    for i = 0, totalGuild do
      local name, _, _, level, _, zone, note, _, isOnline, status, class, _, _, isMobile, _ = GetGuildRosterInfo(i)
      if isOnline then
        local colorHex = RAID_CLASS_COLORS[class].colorStr
		if hideRealmName then
			name = name:match("^(.+)\-")
		end
        if status == 1 then
          status = DEFAULT_AFK_MESSAGE;
        elseif status == 2 then
          status = DEFAULT_DND_MESSAGE;
        else
          status = ''
        end
		if note ~= '' then
			note = "(|cffecd672"..note.."|r)"
		end
        local lineLeft = string.format('%s |c%s%s|r %s %s', level, colorHex, name, status, note)
        local lineRight = string.format('%s|cffffffff %s', (isMobile and "|cffffffa0[M]|r " or ""), zone or '')
        tooltip:AddLine(lineLeft, lineRight)
		tooltip:SetLineScript(tooltip:GetLineCount(),"OnEnter",function() self.glineHover = true;end)
		tooltip:SetLineScript(tooltip:GetLineCount(),"OnLeave",function() self.glineHover = false; end)
		tooltip:SetLineScript(tooltip:GetLineCount(),"OnMouseUp",function(self,_,button)
		    if button == "LeftButton" then
				if modifierFunc() then
					InviteUnit(name)
				else
					ChatFrame_SendTell(name)
				end
			end
		  end)
      end
    end
    tooltip:AddLine(' ',' ')
    tooltip:AddLine('|cffffff00<'..L['Left-Click']..'>|r', '|cffffffff'..L['Whisper Character']..'|r')
    tooltip:AddLine('|cffffff00<'..self.modifier..'+'..L['Left-Click']..'>|r', '|cffffffff'..CALENDAR_INVITELIST_INVITETORAID..'|r')
    tooltip:Show()
    hoverFunc()
  end
end

function MenuModule:CreateClickFunctions()
  if self.functions.menu ~= nil then return; end

  self.functions.menu = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
      ToggleFrame(GameMenuFrame)
    elseif button == "RightButton" then
      if IsShiftKeyDown() then
        ReloadUI()
      else
        ToggleFrame(AddonList)
      end
    end
  end; --menu

  self.functions.chat = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
      if ChatMenu:IsVisible() then
		    ChatMenu:Hide()
  	  else
  	    ChatFrame_ToggleMenu()
  	  end
    end
  end; --chat

  self.functions.guild = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
      ToggleGuildFrame()
    end
  end; --guild

  self.functions.social = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
      ToggleFriendsFrame()
    end
  end; --social

  self.functions.char = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
		-- 加上與自戀插件的相容性
		if IsAddOnLoaded("Narcissus") then 
			SlashCmdList["NARCI"]("")
		else
			ToggleCharacter("PaperDollFrame")
		end
    end
  end; --char

  self.functions.spell = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
  		ToggleFrame(SpellBookFrame)
  	end
  end; --spell

  self.functions.talent = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
  		ToggleTalentFrame()
  	end
  end; --talent

  self.functions.lfg = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
  		if IsAddOnLoaded("LFGBulletinBoard") then
			SlashCmdList["LFGBulletinBoard"]("")
		else
			ToggleLFGParentFrame()
		end
	else
		ToggleLFGParentFrame()
  	end
  end; --lfg

  self.functions.quest = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
  		ToggleQuestLog()
  	end
  end; --quest

  self.functions.help = function(self, button, down)
    if (not xb.db.profile.modules.microMenu.combatEn) and InCombatLockdown() then return; end
    if button == "LeftButton" then
  		ToggleHelpFrame()
  	end
  end; --help
end

function MenuModule:GetDefaultOptions()
  return 'microMenu', {
      enabled = true,
      showTooltips = true,
      combatEn = true,
      mainMenuSpacing = 2,
      iconSpacing = 2,
      hideSocialText = false,
	  modifierTooltip = 1,
	  showGMOTD = false,
	  menu = true,
      chat = false,
      guild = true,
      social = true,
      char = true,
      spell = true,
      talent = true,
      quest = true,
	  lfg = true,
      help = true,
      hideAppContact = true
    }
end

function MenuModule:GetConfig()
  return {
    name = self:GetName(),
    type = "group",
    args = {
      enable = {
        name = ENABLE,
        order = 0,
        type = "toggle",
        get = function() return xb.db.profile.modules.microMenu.enabled; end,
        set = function(_, val)
          xb.db.profile.modules.microMenu.enabled = val
          if val then
            self:Enable()
          else
            self:Disable()
          end
        end
      },
      showTooltips = {
        name = L['Show Social Tooltips'],
        order = 1,
        type = "toggle",
        get = function() return xb.db.profile.modules.microMenu.showTooltips; end,
        set = function(_, val) xb.db.profile.modules.microMenu.showTooltips = val; self:Refresh(); end
      },
      hideSocialText = {
        name = L['Hide Social Text'],
        order = 2,
        type = "toggle",
        get = function() return xb.db.profile.modules.microMenu.hideSocialText; end,
        set = function(_, val) xb.db.profile.modules.microMenu.hideSocialText = val; self:Refresh(); end
      },
      combatEn = {
        name = L['Enable in combat'],
        order = 3,
        type = "toggle",
        get = function() return xb.db.profile.modules.microMenu.combatEn; end,
        set = function(_, val) xb.db.profile.modules.microMenu.combatEn = val; self:Refresh(); end
      },
      mainMenuSpacing = {
        name = L['Main Menu Icon Right Spacing'],
        order = 4,
        type="range",
        min = 2,
        max = 20,
        step = 1,
        get = function() return xb.db.profile.modules.microMenu.mainMenuSpacing; end,
        set = function(_, val) xb.db.profile.modules.microMenu.mainMenuSpacing = val; self:Refresh(); end
      },
      iconSpacing = {
        name = L['Icon Spacing'],
        order = 5,
        type="range",
        min = 2,
        max = 20,
        step = 1,
        get = function() return xb.db.profile.modules.microMenu.iconSpacing; end,
        set = function(_, val) xb.db.profile.modules.microMenu.iconSpacing = val; self:Refresh(); end
      },
	  showGMOTD = {
		name = L["GMOTD in Tooltip"],
		type = "toggle",
		order = 6,
		get = function() return xb.db.profile.modules.microMenu.showGMOTD end,
		set = function(_,val) xb.db.profile.modules.microMenu.showGMOTD = val; self:Refresh(); end
	  },
	  modifierTooltip = {
		name = L["Modifier for friend invite"],
		order = 7,
		type = "select",
		values = {SHIFT_KEY_TEXT,ALT_KEY_TEXT,CTRL_KEY_TEXT},
		style = "dropdown",
		get = function() return xb.db.profile.modules.microMenu.modifierTooltip; end,
		set = function(info, val) xb.db.profile.modules.microMenu.modifierTooltip = val; self:Refresh(); end,
		disabled = function() return not xb.db.profile.modules.microMenu.guild and not xb.db.profile.modules.microMenu.social end
	  },
    appFriendsHide = {
    name = L["Hide BNet App Friends"],
    type = "toggle",
    order = 8,
    get = function() return xb.db.profile.modules.microMenu.hideAppContact end,
    set = function(_,val) xb.db.profile.modules.microMenu.hideAppContact = val; self:Refresh(); end
    },
      buttons = {
        type = 'group',
        name = L['Show/Hide Buttons'],
        order = 9,
        inline = true,
        args = {
          menu = {
            name = L['Show Menu Button'],
            disabled = true,
            order = 1,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.menu; end,
            set = function(_, val) xb.db.profile.modules.microMenu.menu = val; self:Refresh(); end
          },
          chat = {
            name = L['Show Chat Button'],
            order = 2,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.chat; end,
            set = function(_, val) xb.db.profile.modules.microMenu.chat = val; self:UpdateMenu(); self:Refresh(); end
          },
          guild = {
            name = L['Show Guild Button'],
            order = 3,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.guild; end,
            set = function(_, val) xb.db.profile.modules.microMenu.guild = val; self:UpdateMenu(); self:Refresh(); end
          },
          social = {
            name = L['Show Social Button'],
            order = 4,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.social; end,
            set = function(_, val) xb.db.profile.modules.microMenu.social = val; self:UpdateMenu(); self:Refresh(); end
          },
          char = {
            name = L['Show Character Button'],
            order = 5,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.char; end,
            set = function(_, val) xb.db.profile.modules.microMenu.char = val; self:UpdateMenu(); self:Refresh(); end
          },
          spell = {
            name = L['Show Spellbook Button'],
            order = 6,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.spell; end,
            set = function(_, val) xb.db.profile.modules.microMenu.spell = val; self:UpdateMenu(); self:Refresh(); end
          },
          talent = {
            name = L['Show Talents Button'],
            order = 7,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.talent; end,
            set = function(_, val) xb.db.profile.modules.microMenu.talent = val; self:UpdateMenu(); self:Refresh(); end
          },
		  lfg = {
            name = L['Show LFG Button'],
            order = 10,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.lfg; end,
            set = function(_, val) xb.db.profile.modules.microMenu.lfg = val; self:UpdateMenu(); self:Refresh(); end
          },
          quest = {
            name = L['Show Quests Button'],
            order = 9,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.quest; end,
            set = function(_, val) xb.db.profile.modules.microMenu.quest = val; self:UpdateMenu(); self:Refresh(); end
          },
          help = {
            name = L['Show Help Button'],
            order = 15,
            type = "toggle",
            get = function() return xb.db.profile.modules.microMenu.help; end,
            set = function(_, val) xb.db.profile.modules.microMenu.help = val; self:UpdateMenu(); self:Refresh(); end
          }
        }
      }
    }
  }
end
