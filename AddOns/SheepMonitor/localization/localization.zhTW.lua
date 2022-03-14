
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale('SheepMonitor', 'zhTW', false);


if L then

	L['WARNING_APPLIED'] = '%s 已施放在 %s'
	L['WARNING_BROKEN'] = '%s 已被破控'
	L['WARNING_BROKEN_BY'] = '%s 被 %s (%s) 破控'
	L['WARNING_BREAK_INCOMING'] = '%s 將在 %d 秒後解除'

	-- used for options
	L['DESCRIPTION'] = 'SheepMonitor 提供了多種通知方法，幫忙監控你的控場。'
	L['MONITOR_RAID'] = '監視隊伍/戰場/團隊群體控場'
	L['ENABLE_NOTIFIER'] = '啟用視覺通知'
	L['GROW_UPWARDS'] = '清單向上延伸'
	L['ENABLE_OMNICC'] = '啟用整合冷卻時間插件 OmniCC (實驗性)'
	L['ENABLE_QUARTZ'] = '啟用整合施法條增強插件 Quartz'
	L['WARNINGS_HEADER'] = '警告訊息'
	L['ENABLE_PARTY'] = '發送警告給隊伍/戰場/團隊成員'
	L['ENABLE_RAID'] = '在畫面上顯示警告'
	L['ENABLE_CHAT'] = '在聊天視窗顯示警告'
	L['ENABLE_PARTY_TOOLTIP'] = '請謹慎使用，此功能有可能會惹惱人。'
	L['ENABLE_POLYMORPH_MESSAGES'] = '目標被變形時'
	L['ENABLE_BREAK_MESSAGES'] = '羊解除變形時'
	L['ENABLE_BREAK_WARNING_MESSAGE'] = '羊解除變形前 5 秒倒數'
	L['AUDIBLE_BREAK_SOUND'] = '羊解除變形時播放音效'
	L['AUDIBLE_BREAK_WARNING_SOUND'] = '羊解除變形前 5 秒播放音效'
	
	L['SheepMonitor'] = '法師變羊監控'

end
