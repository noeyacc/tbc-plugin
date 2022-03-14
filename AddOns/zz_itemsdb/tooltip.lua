local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local db
local events, curHooks, curTT, curID = {}, {}
local L = LibStub("AceLocale-3.0"):GetLocale(childName, true)
local function checkID(itemID)
	if(C_TradeSkillUI and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible()) then
		local tab = GetMouseFocus()
		local par2 = tab:GetParent()
		local par = par2:GetParent()
		local tooltip = par2.tooltipFrame
		for i = 1, C_TradeSkillUI.GetRecipeNumReagents(par.selectedRecipeID) do
			if(tab.reagentIndex and i==tab.reagentIndex) then
				local recipeItemLink = C_TradeSkillUI.GetRecipeReagentItemLink(par.selectedRecipeID, i)
				itemID = GetItemInfoInstant(recipeItemLink)
				break
			end
		end
		return tonumber(itemID),tooltip
	end
end
local function hookIt(self)
	self.zzTT = nil
end
function child:setTT(id,tooltip)
	if(not tooltip.zzTT and not curHooks[tooltip]) then
		curHooks[tooltip] = true
		tooltip:HookScript("OnHide", hookIt)
	end
	tooltip.zzTT = true
	curTT = tooltip
	curID = id
end
function child:getTT()
	return curID, curTT
end
function child:updateTT()
	local id,tip = child:getTT()
	if(tip and tip.zzTT) then
		if(id) then
			tip:SetItemByID(id)
		end
	end
end
local function GameTooltip_OnTooltipSetItem(tooltip)
	local _, link = tooltip:GetItem()
	if(not link) then
		return
	end
	local id = GetItemInfoInstant(link)
	if(not id) then
		local tip
		id,tip = checkID(id)
		if(id and tip) then
			tooltip = tip
		end
	end
	if(id)then
		child:setTT(id,tooltip)
		tooltip:AddLine()
		for name,b in pairs(child:Search(id)) do
			local dname, drealm = strsplit(" - ",name)
			local input,sum = child:output(b)
			if(sum>0) then
				tooltip:AddLine(format(L['tooltip_main_string'],child:getIcon(id),dname,sum,child:colorize(table.concat(input,', '),"ffffff")))
			end
			input = nil
		end
		child:specialoutput(tooltip, id)
		if(db['showID']) then
			tooltip:AddLine(format(L['tooltip_id_string'],id))
		end
	end
	tooltip:Show()
end
child.GameTooltip_OnTooltipSetItem = GameTooltip_OnTooltipSetItem
GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem)
function events:TRADE_SKILL_LIST_UPDATE(event)
	child:updateTT()
end
child:AddEvent(events)
local init = {
	Setup = function(self)
		db = child['db']
	end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')