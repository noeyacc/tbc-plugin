--------------------------------------- 聊天頻道點擊切換-- Author:M-------------------------------------local locale = GetLocale()local pullTickerlocal buttonFontSize = locale:sub(1,2) == "zh" and 13 or 11--不需要顯示的頻道repl寫成空字符或<del>local channelRules = {    { locale = "enUS", pat = ".*General.+",          repl = "GEN" },    { locale = "enUS", pat = ".*Trade.+",            repl = "T"   },    { locale = "enUS", pat = ".*WorldDefense.*",     repl = "WD"  },    { locale = "enUS", pat = ".*LocalDefense.+",     repl = "LD"  },    { locale = "enUS", pat = ".*LookingForGroup.*",  repl = "LFG" },    { locale = "enUS", pat = ".*GuildRecruitment.*", repl = "GR"  },    { locale = "zhCN", pat = ".*综合.+",     repl = "综合"  },    { locale = "zhCN", pat = ".*交易.+",     repl = "交易"  },    { locale = "zhCN", pat = ".*寻求组队.*", repl = "寻组"  },    { locale = "zhCN", pat = ".*本地防务.+", repl = "<del>" },    { locale = "zhCN", pat = ".*世界防务.*", repl = "<del>" },    { locale = "zhCN", pat = ".*公会招募.*", repl = "<del>" },    { locale = "zhCN", pat = ".*大脚世界.*", repl = "大脚"  },    { locale = "zhTW", pat = ".*綜合.+",     repl = "綜合"  },    { locale = "zhTW", pat = ".*交易.+",     repl = "交易"  },    { locale = "zhTW", pat = ".*尋求組隊.*", repl = "尋組"  },    { locale = "zhTW", pat = ".*本地防務.+", repl = "本防" },    { locale = "zhTW", pat = ".*世界防務.*", repl = "世防" },    { locale = "zhTW", pat = ".*公會招募.*", repl = "招募" },}--全局变量CHATSWITCH = {    { TypeInfoKey = "SAY",      default = "S", zhCN = "说", zhTW = "說", textLoc = CHAT_MSG_SAY },    -- { TypeInfoKey = "YELL",     default = "Y", zhCN = "喊话", zhTW = "喊話", textLoc = CHAT_MSG_YELL },	-- { TypeInfoKey = "EMOTE",     default = "E", zhCN = "表情", zhTW = "表情", textLoc = CHAT_MSG_EMOTE },    { TypeInfoKey = "GUILD",    default = "G", zhCN = "会频", zhTW = "公會", textLoc = CHAT_MSG_GUILD, check = IsInGuild },    -- { TypeInfoKey = "OFFICER",  default = "O", zhCN = "官员", zhTW = "幹部", textLoc = CHAT_MSG_OFFICER, check = CanEditOfficerNote },    { TypeInfoKey = "PARTY",    default = "P", zhCN = "队伍", zhTW = "隊伍", textLoc = CHAT_MSG_PARTY, blockExtra = {"PARTY_LEADER"}, check = function() return IsInGroup(LE_PARTY_CATEGORY_HOME) end },    { TypeInfoKey = "RAID",     default = "R", zhCN = "团队", zhTW = "團隊", textLoc = CHAT_MSG_RAID, blockExtra = {"RAID_LEADER"}, check = function() return IsInRaid() end },    { TypeInfoKey = "RAID_WARNING",     default = "RW", zhCN = "警告", zhTW = "警告", textLoc = CHAT_MSG_RAID_WARNING, check = function() return IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) end },    { TypeInfoKey = "INSTANCE_CHAT", default ="I", zhCN = "副本", zhTW = "副本", textLoc = INSTANCE_CHAT, blockExtra = {"INSTANCE_CHAT_LEADER"}, check = function() return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) end },    { TypeInfoKey = "CHANNEL1", chanId = 1 },    { TypeInfoKey = "CHANNEL2", chanId = 2 },    { TypeInfoKey = "CHANNEL3", chanId = 3 },    { TypeInfoKey = "CHANNEL4", chanId = 4 },    { TypeInfoKey = "CHANNEL5", chanId = 5 },    { TypeInfoKey = "CHANNEL6", chanId = 6 },    { TypeInfoKey = "CHANNEL7", chanId = 7 },    { TypeInfoKey = "CHANNEL8", chanId = 8 },    { TypeInfoKey = "CHANNEL9", chanId = 9 },    { TypeInfoKey = "CHANNEL10", chanId = 10 },    { TypeInfoKey = "CHANNEL11", chanId = 11 },    { TypeInfoKey = "CHANNEL12", chanId = 12 },    { TypeInfoKey = "CHANNEL13", chanId = 13 },    { TypeInfoKey = "CHANNEL14", chanId = 14 },    { TypeInfoKey = "CHANNEL15", chanId = 15 },    { TypeInfoKey = "CHANNEL16", chanId = 16 },    { TypeInfoKey = "CHANNEL17", chanId = 17 },    { TypeInfoKey = "CHANNEL18", chanId = 18 },    { TypeInfoKey = "CHANNEL19", chanId = 19 },    { TypeInfoKey = "CHANNEL20", chanId = 20 },    CUSTOM = {        --自定义按钮		{ zhCN = "确认", zhTW = "確認", default = "Check", check = function() return (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) end, func = function() DoReadyCheck() end },        { zhCN = "開怪", zhTW = "開怪", default = "Pull", check = function() return IsInGroup() or IsInRaid() end,			func = function(self, button) 				-- 滑鼠左鍵開始倒數，右鍵取消倒數				if button=="LeftButton" then					if not TinyChatDB.PullTime then TinyChatDB.PullTime = 5 end					local s = TinyChatDB.PullTime					-- DBM 或 BigWigs 倒數					if SlashCmdList["DEADLYBOSSMODS"] then						SlashCmdList["DEADLYBOSSMODS"]("PULL "..s);					elseif SlashCmdList["DEADLYBOSSMODSPULL"] then						SlashCmdList["DEADLYBOSSMODSPULL"](tostring(s));					elseif not IsAddOnLoaded("BigWigs_Plugins") then						LoadAddOn("BigWigs_Plugins");						if SlashCmdList["BIGWIGSPULL"] then							SlashCmdList["BIGWIGSPULL"](tostring(s));						end					elseif SlashCmdList["BIGWIGSPULL"] then						SlashCmdList["BIGWIGSPULL"](tostring(s));					end					if IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then						SendChatMessage("注意！準備開怪啦！", "RAID_WARNING")					end										if TinyChatDB.PullText then						-- 倒數喊話頻道						local channel = nil											if IsInRaid() then							channel = "RAID"						elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then							channel = "INSTANCE_CHAT"						elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then							channel = "PARTY"						end												-- 開始倒數喊話						if channel then							SendChatMessage("注意！準備開怪啦！", channel)							SendChatMessage(format((">> 開怪倒數 %d 秒 <<"), s), channel)														s=s-1														pullTicker = C_Timer.NewTicker(1, function(self)								if s<0 then									self:Cancel()								else									SendChatMessage(format((s>0 and ">> 開怪倒數 %d 秒 <<" or "動起來！！！"), s), channel)								end 								s=s-1							end)						end					end									elseif button=="RightButton" then					if SlashCmdList["DEADLYBOSSMODS"] then						SlashCmdList["DEADLYBOSSMODS"]("pull 0");					elseif SlashCmdList["DEADLYBOSSMODSPULL"] then						SlashCmdList["DEADLYBOSSMODSPULL"]("0");					elseif not IsAddOnLoaded("BigWigs_Plugins") then						LoadAddOn("BigWigs_Plugins");						if SlashCmdList["BIGWIGSPULL"] then							SlashCmdList["BIGWIGSPULL"]("0");						end					elseif SlashCmdList["BIGWIGSPULL"] then						SlashCmdList["BIGWIGSPULL"]("0");					end					if IsInRaid() and (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then						SendChatMessage(">> 取消開怪，停手！！！ <<", "RAID_WARNING")					end					if TinyChatDB.PullText then						if pullTicker then							pullTicker:Cancel()						end						SendChatMessage(">> 取消開怪，停手！！！ <<", "YELL")					end				end			end		},		{ zhCN = "骰子", zhTW = "骰子", default = "Roll", func = function() RandomRoll(1, 100) end },		{ zhCN = "布告栏", zhTW = "佈告欄", default = "LFG", check = function() return IsAddOnLoaded("LFGBulletinBoard") end, func = function() SlashCmdList["LFGBulletinBoard"]("") end },    },    FirstWord = 1,    --是否只顯示首字(英文除外)    ShowBackdrop = 1, --是否显示按钮背景材质	ShowSocial = 1,   --是否顯示社群頻道按鈕}--計算寬度local function length(s)    if not s then return 0 end    if (string.byte(s) >= 128) then        return ceil(#s/3)    else        return max(1, #s/2)    endend--多字節取第一個local function word(s)    local b = string.byte(s)    if (b >= 240) then        return s:sub(1, 4)    elseif (b >= 224) then        return s:sub(1, 3)    elseif (b >= 192) then        return s:sub(1, 2)    else	-- 純英文字，或英文開頭、中英文混合的文字，取出開頭的英文字。		local lenInByte = #s		local i = 1		while (i<=lenInByte) do			b = string.byte(s, i)			if b > 0 and b <= 127 then				i = i + 1			else				break			end		end		local sWord = ChatBar_GetFirstWord(s:sub(1, i-1))		-- 第一個英文單字還是太長，取前4個字母。		if sWord:len() > 10 then			return sWord:sub(1, 4)		else			return sWord		end    endend--獲取配置的顔色信息local function getTypeinfoColor(config)    if (not config.TypeInfoKey) then        return NORMAL_FONT_COLOR    elseif (config.color) then        return config.color    elseif (config.r and config.g and config.b) then        return config    end    if (ChatTypeInfo[config.TypeInfoKey]) then        return ChatTypeInfo[config.TypeInfoKey]    else        local proxy = getmetatable(ChatTypeInfo).__index        return proxy[config.TypeInfoKey] or NORMAL_FONT_COLOR    endend--按鈕點擊local function click(self, button)    if (self.func) then        self.func(self, button)    else        local type = self.TypeInfoKey		local text = self.textLoc        local editBox = ChatEdit_ChooseBoxForSend()        local i, j = string.find(type, "CHANNEL")				--滑鼠右鍵開關頻道		if (button == "RightButton") then			if (i) then				--全區頻道：有頻道編號				local checked				if self.channelNameCommunity then					checked = not ChatBar_IsListeningForChannel(self.channelNameCommunity)				else					checked = not ChatBar_IsListeningForChannel(self.channelName)				end				ChatBar_ToggleChatChannel(self, checked)			else				--一般對話頻道				local checked = not ChatBar_IsListeningForChatType(type, self.blockExtra);				ChatBar_ToggleChatMessageGroup(self, checked)			end		else			if (i) then				editBox:SetAttribute("channelTarget", tonumber(string.sub(type, j+1)))				type = string.sub(type, i, j)			end			editBox:SetAttribute("chatType", type)			ChatEdit_ActivateChat(editBox)			editBox:SetText(editBox:GetText() or "")		end    endend--創建按鈕local function CreateButton(buttonName, config, index)    local button, text    button = CreateFrame("Button", buttonName, _G["ChatSwitchFrame"] or UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")    button:SetHeight(config.height or 20)    button:RegisterForClicks("AnyUp")    button:SetScript("OnClick", click)    button.text = button:CreateFontString(nil, "ARTWORK")    button.text:SetFont(UNIT_NAME_FONT, buttonFontSize, "THINOUTLINE")    button.text:SetShadowOffset(1, 0)    button.text:SetShadowColor(0, 0, 0, 0.5)    button.text:SetPoint("CENTER", button, "CENTER", 1, 0)    button.text:SetJustifyH("CENTER")    return buttonend--顯示按鈕local function ShowButton(index, config)    local buttonName, button, color, textString, chanId, checked, clubInfo, streamInfo    --频道需要单独处理名称    if (config.chanId) then        chanId, textString  = GetChannelName(config.chanId)        if (chanId < 1) then return false end        for _, rule in ipairs(channelRules) do            if (not rule.locale or rule.locale == locale) then                textString = textString:gsub(rule.pat, rule.repl)            end        end        if (textString == "" or textString == "<del>") then return false end		-- 處理社群頻道 (也可改用 ResolveChannelName() )		if strfind(textString, "Community") then			if CHATSWITCH.ShowSocial == 1 then				clubInfo = C_Club.GetClubInfo(textString:match(":(%d+):"));				if clubInfo then					streamInfo = C_Club.GetStreamInfo(clubInfo.clubId, textString:match(":(%d+)$"));					if streamInfo and CHATSWITCH.ShowSocial == 1 then						textString = (clubInfo.shortName and clubInfo.shortName or clubInfo.name) .. " - " .. streamInfo.name					else						return false					end				else					return false				end			else				return false			end        end    else        textString = config[locale] or config.default    end	-- 縮寫頻道名稱    if (CHATSWITCH.FirstWord == 1 and not config.static) then        -- 第一個子頻道取頻道名稱的第一個字，第二個以後的子頻道取子頻道名稱的第一個字。		if streamInfo and streamInfo.streamId > 1 then			textString = word(streamInfo.name)		else			textString = word(textString)		end    end    buttonName = "ChatSwitchButton"..index    button = _G[buttonName]    if (not button) then        button = CreateButton(buttonName, config, index)        if (index == 1) then            button:SetPoint("LEFT", button:GetParent(), "LEFT", 4, 0)        else            button:SetPoint("LEFT", _G["ChatSwitchButton"..(index-1)], "RIGHT", 3, 0)        end    end    button.TextString  = textString    button.TypeInfoKey = config.TypeInfoKey    button.channelName = config.textLoc    button.blockExtra = config.blockExtra    button:SetWidth(config.width or length(textString) * 20)    button.text:SetWidth(button:GetWidth())    button.text:SetText(textString)    color = getTypeinfoColor(config)	button.color = color    if (CHATSWITCH.ShowBackdrop == 1) then        button:SetBackdrop({          bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",          edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8, edgeSize = 8,          insets = { left = 2, right = 2, top = 2, bottom = 2 }        })        button:SetBackdropColor(0, 0, 0, 0.3)        button:SetBackdropBorderColor(color.r, color.g, color.b, 0.3)    else        button:SetBackdrop(nil)    end	-- 依據頻道開關狀態顯示按鈕文字顏色	if (config.chanId) then		-- 全區頻道：有頻道編號		if clubInfo and streamInfo then			button.channelName = clubInfo.name .. " - " .. streamInfo.name			button.channelNameCommunity = "Community:" .. clubInfo.clubId .. ":" .. streamInfo.streamId			checked = ChatBar_IsListeningForChannel(button.channelNameCommunity)		else			_, button.channelName = GetChannelName(config.chanId)			-- 綜合和交易頻道取前幾個字			button.channelName = ChatBar_GetFirstWord(button.channelName)			checked = ChatBar_IsListeningForChannel(button.channelName)		end		    elseif (config.func) then		-- 自訂按鈕		checked = true	else		-- 一般對話頻道        checked = ChatBar_IsListeningForChatType(button.TypeInfoKey, button.blockExtra)    end	-- 改顏色	if (checked) then 		button.text:SetTextColor(color.r, color.g, color.b, 1)	else		button.text:SetTextColor(color.r, color.g, color.b, 0.2)	end        button.func = config.func    button:Show()    return trueend--渲染數據local function render()    local index = 1    for _, config in ipairs(CHATSWITCH) do        if (not config.check or config.check()) then            if (ShowButton(index, config)) then                index = index + 1            end        end    end    for _, config in ipairs(CHATSWITCH.CUSTOM) do        if (not config.check or config.check()) then            if (ShowButton(index, config)) then                index = index + 1            end        end    end    while (_G["ChatSwitchButton"..index]) do        _G["ChatSwitchButton"..index]:Hide()        index = index + 1    endend--事件註冊local ChatSwitchFrame = CreateFrame("Frame", "ChatSwitchFrame", UIParent)ChatSwitchFrame:SetSize(24,24)ChatSwitchFrame:SetPoint("BOTTOMLEFT", _G["ChatFrame1"], "TOPLEFT", 4, 26)  --調整位置的地方ChatSwitchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")ChatSwitchFrame:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")ChatSwitchFrame:RegisterEvent("GROUP_ROSTER_UPDATE")ChatSwitchFrame:RegisterEvent("PARTY_LEADER_CHANGED")ChatSwitchFrame:RegisterEvent("CLUB_STREAMS_LOADED")ChatSwitchFrame:RegisterEvent("CLUB_STREAM_SUBSCRIBED")ChatSwitchFrame:RegisterEvent("CLUB_STREAM_UNSUBSCRIBED")ChatSwitchFrame.OnEvent = function(self, event, ...)    local inRaid = IsInRaid(LE_PARTY_CATEGORY_HOME)    local inParty = IsInGroup(LE_PARTY_CATEGORY_HOME)    local inInstace = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)    if (self.inParty ~= inParty or self.inRaid ~= inRaid or self.inInstace ~= inInstace        or event == "CUSTOM_EVENT"   -- 自定義事件名        or event == "PLAYER_ENTERING_WORLD"		or event == "PARTY_LEADER_CHANGED"		or event == "CLUB_STREAMS_LOADED"		or event == "CLUB_STREAM_SUBSCRIBED"		or event == "CLUB_STREAM_UNSUBSCRIBED"        or event == "CHAT_MSG_CHANNEL_NOTICE") then        self.inRaid = inRaid        self.inParty = inParty        self.inInstace = inInstace        render() 		-- 延遲		C_Timer.After(15, function()		 	render()		end)    endendChatSwitchFrame:SetScript("OnEvent", ChatSwitchFrame.OnEvent)---------------------------------------------------- 開關頻道的函數-- functions borrowed from ChatBar--------------------------------------------------function ChatBar_IsListeningForChatType(chatType, blockExtra)	local frame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME	local messageTypeList = frame.messageTypeList;	if ( messageTypeList ) then		for index, value in pairs(messageTypeList) do			if ( value == chatType ) then				return true;			end		end				if (blockExtra) then			for i, v in ipairs(blockExtra) do				for index, value in pairs(messageTypeList) do					if ( value == v ) then						return true;					end				end			end		end	end	return false;endfunction ChatBar_IsListeningForChannel(channel)	local frame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME	local channelList = frame.channelList;	local zoneChannelList = frame.zoneChannelList;	if ( channelList ) then		for index, value in pairs(channelList) do			if ( value == channel ) then				return true;			end		end	end	if ( zoneChannelList ) then		for index, value in pairs(zoneChannelList) do			if ( value == channel ) then				return true;			end		end	end	return false;endfunction ChatBar_ToggleChatMessageGroup(button, checked)	local frame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME	local color = button.color	if ( checked ) then		ChatFrame_AddMessageGroup(frame, button.TypeInfoKey)		button.text:SetTextColor(color.r, color.g, color.b, 1)		print(ENABLE .. CHANNEL .. "：" .. button.channelName)	else		ChatFrame_RemoveMessageGroup(frame, button.TypeInfoKey)		button.text:SetTextColor(color.r, color.g, color.b, 0.2)		print(CLOSE .. CHANNEL .. "：" .. button.channelName)	end	local blockExtra = button.blockExtra	if (blockExtra) then		for i, v in ipairs(blockExtra) do			if ( checked ) then				ChatFrame_AddMessageGroup(frame, v);			else				ChatFrame_RemoveMessageGroup(frame, v);			end		end	endendfunction ChatBar_ToggleChatChannel(button, checked)	local frame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME	local color = button.color	local channelName	if button.channelNameCommunity then		channelName = button.channelNameCommunity	else		channelName = button.channelName	end	if ( checked ) then		ChatFrame_AddChannel(frame, channelName)		button.text:SetTextColor(color.r, color.g, color.b, 1)		print(ENABLE .. CHANNEL .. "：" .. button.channelName)	else		ChatFrame_RemoveChannel(frame, channelName)		button.text:SetTextColor(color.r, color.g, color.b, 0.2)		print(CLOSE .. CHANNEL .. "：" .. button.channelName)	endendfunction ChatBar_GetFirstWord(s)	local firstWord, count = gsub(s, "%s.*", "")	return firstWordend