-- Contributors: BNS333@Curse, 彩虹の多多@Curse

local _, addonTable = ...
local L = addonTable.L

-- Lua
local _G = getfenv(0)

if GetLocale() ~= "zhTW" then return end

L["ANCHOR_FRAME_#"] = "面板對齊位置 #%d"
L["ANCHOR_FRAMES"] = "面板位置"
L["ANCHOR_RESET_DESC"] = "|cffffffffShift-左鍵點擊|r 重置位置。"
L["BORDER"] = "邊框"
L["COLORS"] = "顯示彩色的"
L["COORDS"] = "坐標"
L["COPPER_THRESHOLD"] = "銅最小值"
L["COPPER_THRESHOLD_DESC"] = "至少要多少銅才會顯示通知面板。"
L["DEFAULT_VALUE"] = "預設值: |cffffd200%s|r"
L["DND"] = "勿擾"
L["DND_TOOLTIP"] = "勿擾模式的通知不會在戰鬥中顯示，但仍會在系統中等候，脫離戰鬥之後就會開始彈出。"
L["FADE_OUT_DELAY"] = "淡出延遲時間"
L["FLUSH_QUEUE"] = "清空佇列"
L["FONTS"] = "字體"
L["GROWTH_DIR"] = "增長方向"
L["GROWTH_DIR_DOWN"] = "下"
L["GROWTH_DIR_LEFT"] = "左"
L["GROWTH_DIR_RIGHT"] = "右"
L["GROWTH_DIR_UP"] = "上"
L["ICON_BORDER"] = "圖示邊框"
L["NAME"] = "名稱"
L["RARITY_THRESHOLD"] = "最低物品品質"
L["SCALE"] = "縮放大小"
L["SHOW_ILVL"] = "顯示物品等級"
L["SHOW_ILVL_DESC"] = "在物品名稱旁顯示物品等級。"
L["SHOW_QUEST_ITEMS"] = "顯示任務物品"
L["SHOW_QUEST_ITEMS_DESC"] = "不論品質都要顯示任務物品。"
L["SIZE"] = "大小"
L["SKIN"] = "外觀風格"
L["STRATA"] = "框架層級"
L["TEST"] = "測試"
L["TEST_ALL"] = "全部測試"
L["TOAST_NUM"] = "通知數量"
L["TOAST_TYPES"] = "通知類型"
L["TOGGLE_ANCHORS"] = "鎖定/解鎖位置"
L["TRACK_LOSS"] = "追蹤損失"
L["TRACK_LOSS_DESC"] = "這個選項會忽略銅最小值。"
L["TYPE_LOOT_GOLD"] = "拾取 (金錢)"
L["X_OFFSET"] = "水平位移"
L["Y_OFFSET"] = "垂直位移"
L["YOU_LOST"] = "你失去了"
L["YOU_RECEIVED"] = "你獲得了"

-- Classic
L["TYPE_LOOT_ITEMS"] = "拾取 (物品)"

L["LS_TOASTS"] = "通知"
