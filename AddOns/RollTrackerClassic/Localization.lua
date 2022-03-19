local RTC_TOCNAME,RTC = ...

-- Basic localizations

RTC.PassTags={}
function RTC.GetLocale()
	local ColRed="|cffff4040"
	
	local DefaultEnGB = {
			["MsgNbRolls"] = "%d Roll(s)",
			["MsgRollCleared"] = "All rolls have been cleared.",
			["MsgUndoRoll"]="Undo all rolls.",
			["MsgAnnounce"] = "%s won with a roll of %d.",
			["MsgAnnounceTie"] = "Tie, %s won with a roll of %d.",
			["MsgNotRolled"]="The following people still need to roll or say '%s'",
			["MsgCheat"]="Ignoring %s's roll of %s (%s-%s).",  -- (player, roll, max_roll, min_roll)
			["MsgStart"]="New roll starting now! Type '/rnd' or '%s'",
			["MsgStartGreenAndNeed"]="New roll starting now! Type '/rnd' for need, '/rnd 1-50' for greed or '%s'",
			["MsgNextItem"]="Next item: %s",
			["MsgTooltip"]="|cffff4040Left click|r to open RTC |n|cffff4040Shift+Left click|r to open 'Loot Rolls'|n|cffff4040Right click|r to open options",
			["MsgBar"]="==============================",
			["MsgLocalRestart"]="The setting is not transferred until after a restart (/reload)",
			["MsgNbLoots"]="%d stored loot(s).",
			["MsgLootLine"]="%s: %s receives loot: %s", -- date, name, item
			["MsgLootCleared"] = "All stored loots have been cleared.",
			["MsgUndoLoot"]="Undo all loots.",
			["MsgLTnotenabled"]="Loot Tracker is not enabled.",
			["MsgRaidRoll"] = "%s won. (%d)",
			["MsgForcedAnnounce"]="No rolls",
			["MsgStartCD"]="Start a countdown with right click on [Announce] or '/rtc cd'",
			["MsgPastLoots"]="Past loots:",
			["MsgAddNote"]="%s note",
			["MsgNotesCleared"]="All player notes cleared",
						
			["TxtGreed"]="Greed",
			["TxtNeed"]="Need",
			["TxtLine"]="------------------------------------------------------------------------------------------------------",
			["pass"] = "pass",		
			
			["BtnClear"]="Clear",
			["BtnUndo"]="Undo",
			["BtnNotRolled"]="Not rolled",
			["BtnRoll"]="Roll",
			["BtnAnnounce"]="Announce",
			["BtnGreed"]="Greed",
			["BtnPass"]="Pass",			
			["BtnOpen"]="Open",
			["BtnConfig"]="Settings",
			["BtnLootRolls"]="Loot Rolls",
			["BtnOpenLoot"]="Loot Tracker",
			["BtnCSVExport"]="CSV Export",
			["BtnCancel"]="Cancel",
			["BtnRaidRoll"]="Raid Roll",
			["BtnColorNormal"]="Colour text",
			["BtnColorCheat"]="Colour cheat",
			["BtnColorGuild"]="Colour guild",
			["BtnColorInfo"]="Colour info",		
			["BtnColorChat"]="Colour chat message",
			["BtnColorScroll"]="Colour list entry",
			
			["EdtWhiteList"]="Whitelist ItemIds",
			["EdtNbLoots"]="Maximum stored loot",
			["EdtCSVexport"]="CSV-Export-Format",
			["EdtCDRefresh"]="Refresh Countdown after roll (seconds)",
			["EdtDefaultCD"]="Default Countdown (seconds)",	
			["EdtAutoCloseDelay"]="Delayed closing in seconds",
			["EdtAnnounceList"]="Entries in the announcement list",
			
			["TxtCSVJokers"]="%% %name% %class% %timestamp% %dd% %mm% %yy% %HH% %MM% %SS%",
			["TxtCSVJokers2"]="%iname% %irarity% %iraritytxt% %ilevel% %iid% %iprice% %icount% %itype% %itypetxt%",
			["TxtCSVJokersTitle"]="For CSV-Export you can use this jokers:",
			["TxtItemType"]="Attention! ItemType is independent of the rarity!",
			
			["TabRoll"]="Rolls",
			["TabLoot"]="Loot",
			["TabCSV"]="CSV",
			
			["PanelLootTracker"]="Loot Tracker",
			["HeaderRarity"]="Track Rarity",
			["HeaderItemType"]="Track ItemType",
			["HeaderSettings"]="Settings",
			["HeaderCustomLocales"]="Localization",
			["HeaderCSV"]="CSV-Export",
			["PanelAbout"]="About",
			["HeaderSlashCommand"]="Slash Commands",
			["HeaderCredits"]="Credits",
			["HeaderInfo"]="Information",
			["HeaderUsage"]="Usage",
		
			["Cboxshowminimapbutton"]="Show minimap button",
			["CboxLockMinimapButton"]="Lock minimap button position",		
			["CboxLockMinimapButtonDistance"]="Minimize minimap button distance",
			["CboxCloseOnClear"]="Close window after [Clear]",
			["CboxClearOnAnnounce"]="Clear rolls after [Announce]",
			["CboxCloseOnAnnounce"]="Close window after [Announce]",
			["CboxClearOnClose"]="Clear rolls after [Close]",
			["CboxIgnoreDouble"]="Ignore double rolls",
			["CboxRejectOutBounds"]="Reject rolls with bounds other than (1-100)",
			["CboxAnnounceIgnoreDouble"]="Only with [Announce]: Ignore double rolls",
			["CboxAnnounceRejectOutBounds"]="Only with [Announce]: Reject rolls with bounds other than (1-100)",
			["CboxNeedAndGreed"]="Use Need '/rnd' and Greed '/rnd 1-50' system, ignores out of bounce",
			["CboxShowNotRolled"]="Show [Not rolled] button",
			["CboxAutoLootRolls"]="Open 'Loot Rolls' automatically",
			["CboxAutoCloseLootRolls"]="Automatic close 'Loot Rolls' when everyone has rolled",
			["CboxClearOnStart"]="Clear when somebody starts a new roll",
			["CboxOpenOnStart"]="Open when somebody starts a new roll",
			["CboxColorName"]="Colorize names by class",
			["CboxShowClassIcon"]="Show class icon",
			["CboxOnDebug"]="Show debug information",
			["CboxShowGuildRank"]="Show guild rank",
			["CboxAutmaticAnnounce"]="Automatic announce rolls",
			
			["CboxNotfiyInnone"]="Enable on overworld",
			["CboxNotfiyInpvp"]="Enable in battleground",
			["CboxNotfiyInparty"]="Enable in dungeon",
			["CboxNotfiyInraid"]="Enable in raid dungeon",
			
			
			["CboxLTShortMessage"]="Short Message",
			["CboxLTTrackSolo"]="Track solo",
			["CboxLTTrackGroup"]="Track party",
			["CboxLTTrackSRaid"]="Track raid with 10 or less members",
			["CboxLTTrackBRaid"]="Track raid with 11 or more members",
			["CboxLTEnable"]="Enable loot tracking",
			["CboxLTSmallFont"]="Small font",
			["CboxLTShowIcon"]="Show item icon",
			
			["SlashClearRolls"]="Clear rolls",
			["SlashClearLoot"]="Clear loot",
			["SlashClearLootRolls"]="Clear 'Loot Rolls'",
			["SlashUndoRolls"]="Recover last rolls",
			["SlashUndoLoot"]="Recover last loots",
			["SlashAnnounce"]="Announce winner of the last roll",
			["SlashNotRolled"]="Remind everyone who has not rolled",
			["SlashClose"]="Close main window",
			["SlashReset"]="Reset position of main window",
			["SlashConfig"]="Open Configuration",
			["SlashAbout"]="Open about",
			["SlashStart"]="Announce a new roll, <value> can be empty or itemlink",
			["SlashOpen"]="Open main window",
			["SlashRaidRoll"]="Roll a player name",
			["SlashRaidRollList"]="Output all player",
			["SlashCountdown"]="Countdown <value> in seconds",
			["SlashNotes"]="Print all notes",
			["SlashClearNotes"]="Clear all notes",
			
			["AboutInfo"]="Have you ever tried to roll the 'Onyxia Hide Backpack' in a raid? RTC collects all roll results and sorts them. Ever thought about whether you wanted something for your second-equip, but didn't know if somebody needed it? RTC can automatically open the Blizzard 'Loot rolls' window, where you can see immediately who needs or has greed.|nIn raid ever lost the overview, who got what? Again, RTC can help you. On request, it records all items, including a variable export function.",
			
			["AboutSlashCommand"]="<value> can be true, 1, enable, false, 0, disable. If <value> is omitted, the current status switches.",
			
			["AboutUsage"]="RTC will automatically open when someone rolls the dice. Double rolls or rolls outside the default range are ignored on request.|nBy default, the automatic opening of 'Loot Rolls' is disabled. Likewise, the 'Loot Tracker' must be turned on manually.",
			
			["RollTracker Classic"]="RollTracker Classic",
			["RollTracker"]="RollTracker",			
			

			
		}
		
	local locales = {
		zhCN = {
			["AboutInfo"] = "你有没有试过在一次Raid中roll一个 '奥妮克希亚皮袋' ? RTC收集所有Roll点并对其进行排序。有没有想过你是否想要第二套装备，但不知道是否有人需要？RTC可以自动打开暴雪的“战利品Roll点”窗口，在那里你可以立即看到谁需要或贪婪",
			["AboutSlashCommand"] = "<value>可以为true, 1, enable, false, 0, disable.",
			["AboutUsage"] = "当有人掷骰子时，RTC将自动打开. 根据要求忽略默认范围以外的重复Roll点.|n默认情况下，“战利品Roll点”的自动打开被禁用。同样，必须手动开启“战利品追踪器”.",
			["BtnAnnounce"] = "通告",
			["BtnCancel"] = "取消",
			["BtnClear"] = "清除",
			--[[Translation missing --]]
			--[[ ["BtnColorChat"] = "Colour chat message",--]] 
			--[[Translation missing --]]
			--[[ ["BtnColorCheat"] = "Colour cheat",--]] 
			--[[Translation missing --]]
			--[[ ["BtnColorGuild"] = "Colour guild",--]] 
			--[[Translation missing --]]
			--[[ ["BtnColorInfo"] = "Colour info",--]] 
			--[[Translation missing --]]
			--[[ ["BtnColorNormal"] = "Colour text",--]] 
			--[[Translation missing --]]
			--[[ ["BtnColorScroll"] = "Colour list entry",--]] 
			["BtnConfig"] = "设置",
			["BtnCSVExport"] = "CSV导出",
			["BtnGreed"] = "贪婪",
			["BtnLootRolls"] = "战利品Roll点",
			["BtnNotRolled"] = "未Roll过的",
			["BtnOpen"] = "打开",
			["BtnOpenLoot"] = "战利品监视器",
			["BtnPass"] = "放弃",
			["BtnRaidRoll"] = "Raid Roll点",
			["BtnRoll"] = "Roll",
			["BtnUndo"] = "撤销",
			["CboxAnnounceIgnoreDouble"] = "只[通告]: 忽略重复Roll点",
			["CboxAnnounceRejectOutBounds"] = "只[通告]: 拒绝不是(1-100)的Roll点",
			--[[Translation missing --]]
			--[[ ["CboxAutmaticAnnounce"] = "Automatic announce rolls",--]] 
			["CboxAutoCloseLootRolls"] = "当所有人都Roll之后自动关闭 '战利品Roll点'",
			["CboxAutoLootRolls"] = "自动打开 '战利品Roll点'",
			["CboxClearOnAnnounce"] = "[通告]后清除Roll点",
			["CboxClearOnClose"] = "[关闭]后清除Roll点",
			["CboxClearOnStart"] = "当有人开始新的Roll时清除",
			["CboxCloseOnAnnounce"] = "[通告]后关闭窗口",
			["CboxCloseOnClear"] = "[清除]后关闭窗口",
			["CboxColorName"] = "由职业着色名字",
			["CboxIgnoreDouble"] = "忽略重复Roll点",
			["CboxLockMinimapButton"] = "锁定小地图按钮位置",
			["CboxLockMinimapButtonDistance"] = "最小化最小地图按钮距离",
			["CboxLTEnable"] = "启用战利品监视",
			["CboxLTShortMessage"] = "短信息",
			["CboxLTShowIcon"] = "显示物品图标",
			["CboxLTSmallFont"] = "小字体",
			["CboxLTTrackBRaid"] = "10人以上时监视",
			["CboxLTTrackGroup"] = "小队时监视",
			["CboxLTTrackSolo"] = "单人时监视",
			["CboxLTTrackSRaid"] = "10人时监视",
			["CboxNeedAndGreed"] = "输入 '/rnd' 为需求,输入 '/rnd 1-50' 为贪婪系统",
			--[[Translation missing --]]
			--[[ ["CboxNotfiyInnone"] = "Enable on overworld",--]] 
			--[[Translation missing --]]
			--[[ ["CboxNotfiyInparty"] = "Enable in dungeon",--]] 
			--[[Translation missing --]]
			--[[ ["CboxNotfiyInpvp"] = "Enable in battleground",--]] 
			--[[Translation missing --]]
			--[[ ["CboxNotfiyInraid"] = "Enable in raid dungeon",--]] 
			["CboxOnDebug"] = "显示调试信息",
			["CboxOpenOnStart"] = "当有人开始新的Roll时打开",
			["CboxRejectOutBounds"] = "拒绝不是(1-100)的Roll点",
			["CboxShowClassIcon"] = "显示职业图标",
			["CboxShowGuildRank"] = "显示公会会阶",
			["Cboxshowminimapbutton"] = "显示小地图按钮",
			["CboxShowNotRolled"] = "显示 [未Roll过的] 按钮",
			--[[Translation missing --]]
			--[[ ["EdtAnnounceList"] = "Entries in the announcement list",--]] 
			["EdtAutoCloseDelay"] = "延迟关闭（秒）",
			["EdtCDRefresh"] = "Roll后刷新倒计时（秒）",
			["EdtCSVexport"] = "CSV-导出格式",
			["EdtDefaultCD"] = "默认倒计时（秒）",
			["EdtNbLoots"] = "最大库存",
			["EdtWhiteList"] = "白名单物品ID",
			--[[Translation missing --]]
			--[[ ["HeaderCredits"] = "Credits",--]] 
			["HeaderCSV"] = "CSV-导出",
			["HeaderCustomLocales"] = "本地化",
			--[[Translation missing --]]
			--[[ ["HeaderInfo"] = "Information",--]] 
			["HeaderItemType"] = "监视物品类型",
			["HeaderRarity"] = "监视品质",
			["HeaderSettings"] = "设置",
			["HeaderSlashCommand"] = "可用命令",
			--[[Translation missing --]]
			--[[ ["HeaderUsage"] = "Usage",--]] 
			["MsgAnnounce"] = "%s 赢得了Roll点, 为: %d",
			["MsgAnnounceTie"] = "%s 赢得了Roll点, 为: %d",
			["MsgBar"] = "==============================",
			["MsgCheat"] = "忽略 %s 的Roll点, %s (%s-%s)",
			["MsgForcedAnnounce"] = "无Roll点",
			["MsgLocalRestart"] = "需要重新启动（/reload）后才会传输设置",
			["MsgLootCleared"] = "所有储存的战利品都被清除了",
			["MsgLootLine"] = "%s: %s获得了物品: %s",
			["MsgLTnotenabled"] = "战利品监视器未激活",
			["MsgNbLoots"] = "%d 存储的战利品",
			["MsgNbRolls"] = "%d 个骰子",
			["MsgNextItem"] = "下一项: %s",
			["MsgNotRolled"] = "下面的人还需要Roll点,或说 '%s'",
			["MsgRaidRoll"] = "%s 胜利 (%d)",
			["MsgRollCleared"] = "所有Roll点已被清除",
			["MsgStart"] = "新的roll现在开始! 输入 '/rnd' 或 '%s'",
			["MsgStartCD"] = "右键[通告] 开始倒计时,或者输入 '/rtc cd'",
			["MsgStartGreenAndNeed"] = "新的roll现在开始! 输入 '/rnd' 为需求, '/rnd 1-50' 为贪婪或 '%s'",
			["MsgTooltip"] = "左键|r 打开Roll点监视 \\n\"..ColRed..\"Shift+左键|r 打开'战利品Roll点监视' \\n\"..ColRed..\"右键|r 打开设置",
			--[[Translation missing --]]
			--[[ ["MsgUndoLoot"] = "Undo all loots.",--]] 
			["MsgUndoRoll"] = "取消所有Roll点",
			["PanelAbout"] = "关于",
			["PanelLootTracker"] = "战利品监视器",
			["pass"] = "放弃",
			["SlashAbout"] = "打开关于",
			["SlashAnnounce"] = "通告最后一个胜利者",
			["SlashClearLoot"] = "清除战利品",
			["SlashClearLootRolls"] = "清除 '战利品Roll点'",
			["SlashClearRolls"] = "清除Roll点",
			["SlashClose"] = "关闭主窗口",
			["SlashConfig"] = "打开配置",
			["SlashCountdown"] = "倒计时<value>秒",
			["SlashNotRolled"] = "提醒所有未Roll过的人",
			--[[Translation missing --]]
			--[[ ["SlashOpen"] = "Open main window",--]] 
			["SlashRaidRoll"] = "随机Roll一个玩家",
			["SlashRaidRollList"] = "输出所有玩家",
			["SlashReset"] = "重置主窗口位置",
			["SlashStart"] = "通告新的Roll点, <value> 可以是空的也可以是物品链接",
			["SlashUndoLoot"] = "恢复最后一个战利品",
			["SlashUndoRolls"] = "恢复最后一个Roll",
			["TabCSV"] = "CSV",
			["TabLoot"] = "Loot",
			["TabRoll"] = "Rolls",
			["TxtCSVJokers"] = "%% %name% %class% %timestamp% %dd% %mm% %yy% %HH% %MM% %SS%",
			["TxtCSVJokers2"] = "%iname% %irarity% %iraritytxt% %ilevel% %iid% %iprice% %icount% %itype% %itypetxt%",
			["TxtCSVJokersTitle"] = "对于CSV导出，您可以使用此:",
			["TxtGreed"] = "贪婪",
			["TxtItemType"] = "注意！物品类型与品质无关!",
			--[[Translation missing --]]
			--[[ ["TxtLine"] = "------------------------------------------------------------------------------------------------------",--]] 
			["TxtNeed"] = "需求"
		},
		zhTW = {
			["MsgNbRolls"] = "共計 %d 個人擲骰",
			["MsgRollCleared"] = "所有擲骰記錄都已清空。",
			["MsgUndoRoll"]="還原所有擲骰。",
			["MsgAnnounce"] = "%s 贏了! 骰 %d。",
			["MsgAnnounceTie"] = "再來是 %s 贏了! 骰 %d。",
			["MsgNotRolled"]="下列玩家仍需擲骰，或說 '%s'",
			["MsgCheat"]="忽略 %s 骰的 %s (%s-%s)。",  -- (player, roll, max_roll, min_roll)
			["MsgStart"]="現在開始新的擲骰! 請輸入 '/rnd' 或 '%s'",
			["MsgStartGreenAndNeed"]="現在開始新的擲骰! 需求請輸入 '/rnd'，貪婪請輸入 '/rnd 1-50' 或 '%s'",
			["MsgNextItem"]="%s 要的骰",
			["MsgTooltip"]="|cffff4040左鍵:|r 打開骰子記錄|n|cffff4040Shift+左鍵:|r 打開 '拾取記錄'|n|cffff4040右鍵:|r 設定選項",
			["MsgBar"]="==============================",
			["MsgLocalRestart"]="需要重新載入介面 (/reload) 設定才會生效",
			["MsgNbLoots"]="%d 個已儲存的拾取物品。",
			["MsgLootLine"]="%s: %s 獲得物品: %s", -- date, name, item
			["MsgLootCleared"] = "所有已儲存的拾取物品都已清空。",
			["MsgUndoLoot"]="還原所有拾取物品。",
			["MsgLTnotenabled"]="尚未啟用拾取追蹤。",
			["MsgRaidRoll"] = "%s 贏了! (%d)",
			["MsgForcedAnnounce"]="沒骰",
			["MsgStartCD"]="右鍵點擊 [公佈] 或輸入 '/rtc cd' 開始倒數",
			["MsgPastLoots"]="過往拾取:",
			["MsgAddNote"]="%s備註",
			["MsgNotesCleared"]="所有的玩家備註都已清空",

			["TxtGreed"]="貪婪",
			["TxtNeed"]="需求",
			["TxtLine"]="------------------------------------------------------------------------------------------------------",
			["pass"] = "pass",		
			["BtnClear"]="清空",
			["BtnUndo"]="還原",
			["BtnNotRolled"]="沒骰",
			["BtnRoll"]="擲骰",
			["BtnAnnounce"]="公佈",
			["BtnGreed"]="貪婪",
			["BtnPass"]="跳過",
			
			["BtnOpen"]="打開",
			["BtnConfig"]="設定",
			["BtnLootRolls"]="拾取記錄",
			["BtnOpenLoot"]="拾取追蹤",
			["BtnCSVExport"]="匯出 CSV",
			["BtnCancel"]="取消",
			["BtnRaidRoll"]="團隊擲骰",
			["BtnColorNormal"]="文字顏色",
			["BtnColorCheat"]="作弊顏色",
			["BtnColorGuild"]="公會顏色",
			["BtnColorInfo"]="資訊顏色",		
			["BtnColorChat"]="聊天訊息顏色",
			["BtnColorScroll"]="清單項目顏色",
			
			["EdtWhiteList"]="白名單物品 ID",
			["EdtNbLoots"]="拾取物品最多儲存數量",
			["EdtCSVexport"]="CSV-Export-Format",
			["EdtCDRefresh"]="擲骰後重新倒數時間 (秒)",
			["EdtDefaultCD"]="預設倒數時間 (秒)",	
			["EdtAutoCloseDelay"]="延遲關閉時間 (秒)",
			["EdtAnnounceList"]="公佈清單中的項目",
			
			["TxtCSVJokers"]="%% %name% %class% %timestamp% %dd% %mm% %yy% %HH% %MM% %SS%",
			["TxtCSVJokers2"]="%iname% %irarity% %iraritytxt% %ilevel% %iid% %iprice% %icount% %itype% %itypetxt%",
			["TxtCSVJokersTitle"]="匯出 CSV 時可以使用這些文字標籤:",
			["TxtItemType"]="注意! 物品類型和稀有度是各自獨立分開的!",
			
			["TabRoll"]="骰子",
			["TabLoot"]="物品",
			["TabCSV"]="CSV",
			
			["PanelLootTracker"]="拾取追蹤",
			["HeaderRarity"]="追蹤稀有度",
			["HeaderItemType"]="追蹤物品類型",
						
			["HeaderSettings"]="設定",
			["HeaderCustomLocales"]="自訂文字",
			["HeaderCSV"]="匯出 CSV",
			["PanelAbout"]="關於",
			["HeaderSlashCommand"]="指令",
			["HeaderCredits"]="感謝",
			["HeaderInfo"]="資訊",
			["HeaderUsage"]="用法",

			["Cboxshowminimapbutton"]="顯示小地圖按鈕",
			["CboxLockMinimapButton"]="鎖定小地圖按鈕位置",		
			["CboxLockMinimapButtonDistance"]="最小化小地圖按鈕距離",
			["CboxCloseOnClear"]="[清空] 後關閉視窗",
			["CboxClearOnAnnounce"]="[公佈] 後清空擲骰記錄",
			["CboxCloseOnAnnounce"]="[公佈] 後關閉視窗",
			["CboxClearOnClose"]="[關閉] 後清空擲骰記錄",
			["CboxIgnoreDouble"]="忽略重複骰的",
			["CboxRejectOutBounds"]="拒絕骰子範圍不是 (1-100) 的",
			["CboxAnnounceIgnoreDouble"]="只有 [公佈] 時: 忽略重複骰的",
			["CboxAnnounceRejectOutBounds"]="只有 [公佈] 時: 拒絕骰子範圍不是 (1-100) 的",
			["CboxNeedAndGreed"]="使用需求 '/rnd' 和貪婪 '/rnd 1-50' 系統，其他方式一概忽略",
			["CboxShowNotRolled"]="顯示 [沒骰] 按鈕",
			["CboxAutoLootRolls"]="自動打開 '拾取記錄'",
			["CboxAutoCloseLootRolls"]="所有人都骰過後自動關閉 '拾取記錄'",
			["CboxClearOnStart"]="有人開始新的擲骰時清空",
			["CboxOpenOnStart"]="有人開始新的擲骰時打開",
			["CboxColorName"]="名字顯示職業顏色",
			["CboxShowClassIcon"]="顯示職業圖示",
			["CboxOnDebug"]="顯示除錯訊息",
			["CboxShowGuildRank"]="顯示公會等級",
			["CboxAutmaticAnnounce"]="自動公佈擲骰結果",

			["CboxNotfiyInnone"]="在野外啟用",
			["CboxNotfiyInpvp"]="戰場中啟用",
			["CboxNotfiyInparty"]="地城中啟用",
			["CboxNotfiyInraid"]="團本中啟用",

			["CboxLTShortMessage"]="簡短訊息",
			["CboxLTTrackSolo"]="追蹤單人",
			["CboxLTTrackGroup"]="追蹤隊伍",
			["CboxLTTrackSRaid"]="追蹤小於 10 人的團隊",
			["CboxLTTrackBRaid"]="追蹤大於 11 人的團隊",
			["CboxLTEnable"]="啟用拾取追蹤",
			["CboxLTSmallFont"]="文字較小",
			["CboxLTShowIcon"]="顯示物品圖示",
			
			["SlashClearRolls"]="清空骰子",
			["SlashClearLoot"]="清空拾取",
			["SlashClearLootRolls"]="清空 '拾取記錄'",
			["SlashUndoRolls"]="恢復上次骰子",
			["SlashUndoLoot"]="恢復上次拾取",
			["SlashAnnounce"]="公佈最後一輪骰的獲勝者",
			["SlashNotRolled"]="提醒所有未骰的人",
			["SlashClose"]="關閉主視窗",
			["SlashReset"]="重置主視窗的位置",
			["SlashConfig"]="打開設定選項",
			["SlashAbout"]="打開關於",
			["SlashStart"]="宣布開始新的一輪擲骰, <value> 可以是空的或物品連結",
			["SlashOpen"]="打開主視窗",
			["SlashRaidRoll"]="骰一個玩家名字",
			["SlashRaidRollList"]="輸出所有玩家",
			["SlashCountdown"]="倒數時間 <value> 秒",
			["SlashNotes"]="顯示所有備註",
			["SlashClearNotes"]="清空所有備註",
			
			["AboutInfo"]="Have you ever tried to roll the 'Onyxia Hide Backpack' in a raid? RTC collects all roll results and sorts them. Ever thought about whether you wanted something for your second-equip, but didn't know if somebody needed it? RTC can automatically open the Blizzard 'Loot rolls' window, where you can see immediately who needs or has greed.|nIn raid ever lost the overview, who got what? Again, RTC can help you. On request, it records all items, including a variable export function.",
			
			["AboutSlashCommand"]="<value> 可以是 true, 1, enable, false, 0, disable。省略 <value> 時會切換目前的狀態開/關。",
			
			["AboutUsage"]="RTC will automatically open when someone rolls the dice. Double rolls or rolls outside the default range are ignored on request.|nBy default, the automatic opening of 'Loot Rolls' is disabled. Likewise, the 'Loot Tracker' must be turned on manually.",

			["RollTracker Classic"]="骰子記錄",
			["RollTracker"]="副本-骰子記錄",
		},
	}
	

	
	
	
	
	
	locales.esES=locales.esMX
	
	for lkey,loc in pairs(locales) do
		if loc.pass then
			RTC.PassTags[loc.pass]=true
		end
	end
	RTC.PassTags[DefaultEnGB.pass]=true
	
	if RollTrackerClassicDB and RollTrackerClassicDB.OnDebug then
		for lkey,loc in pairs(locales) do
			if loc["MsgStart"] then
				for key,value in pairs(DefaultEnGB) do
					if loc[key]==nil then --or loc[key]==value then
						print ("RTC-Missing:"..lkey.."["..key.."]")
					end
				end
			end	
		end
	end
	
	
	local L = locales[GetLocale()] or {}
	
	if RollTrackerClassicDB and RollTrackerClassicDB.CustomLocales and type(RollTrackerClassicDB.CustomLocales) == "table" then
		for key,value in pairs(RollTrackerClassicDB.CustomLocales) do
			if value~=nil and value ~="" then
				L[key.."_org"]=L[key]
				L[key]=value
			end
		end
	end
	
	setmetatable(DefaultEnGB,{__index =function(t,k) return "["..k.."]" end})
	
	setmetatable(L, {
		__index = DefaultEnGB
	})
	L["AboutCredits"]="Russian translation by Arrogant_Dreamer, tierggg and Hubbotu|nKorean translation by BattleE, classe82|nSimplified Chinese translation by kokpk|nBaudzilla for the idea of the resize-code|nRollTracker Classic is an updated version of 'RollTracker Lite', originally by Jerry Chong - zanglang@gmail.com."
	
	
	return L
end