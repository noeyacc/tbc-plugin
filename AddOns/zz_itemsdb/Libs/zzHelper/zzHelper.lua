local lib = LibStub:NewLibrary("zzHelper", 3)
if not lib then return end
lib['targets'] = lib['targets'] or {}
local mixins = {'colorize', 'round', 'sortArray', 'IsTwink', 'classcolor', 'MoneyString', 'MoneyStringSetString', 'MoneyStringSetSize'}

--[[
	*** Stringfunctions ***
]]

function lib:colorize(text, color)
	return string.format("|cff%s%s|r",color and color or 'ffffff',text and text or '')
end

local iconbase = "\124TInterface\\MoneyFrame\\UI-%sIcon:%d:%d:1:0\124t"
local iconSize = 14
local moneyText = {
	gold = " G",
	silver = " S",
	copper = " C",
	goldColor = lib:colorize(" G", "ffd700"),
	silverColor = lib:colorize(" S", "bfc1c2"),
	copperColor = lib:colorize(" C", "b87333"),
}
function lib:MoneyStringSetString(coin, str, col)
	if(moneyText[coin]) then
		moneyText[coin] = str
		if(col) then
			moneyText[format("%sColor",coin)] = col
		end
	end
end
function lib:MoneyStringSetSize(size)
	if(size and size > 5 and size < 30) then
		iconSize = size
	end
end
function lib:MoneyString(money, color, abrevK, abrevM, noicon, noiconcolor, size)
	local iconSize =  size or iconSize
	local goldicon = noicon and (noiconcolor and moneyText['goldColor'] or moneyText['gold']) or format(iconbase, 'Gold', iconSize, iconSize)
	local silvericon = noicon and (noiconcolor and moneyText['silverColor'] or moneyText['silver']) or format(iconbase, 'Silver', iconSize, iconSize)
	local coppericon = noicon and (noiconcolor and moneyText['copperColor'] or moneyText['copper']) or format(iconbase, 'Copper', iconSize, iconSize)

	local moneystring = ''
	local g,s,c
	local neg = false
	local abrev = ""
	if(abrevM and money >= 10000000000) then
		abrev = abrevM
		money = lib:round(money / 10000000000,1) * 10000
	elseif(abrevK and money >= 10000000) then
		abrev = abrevK
		money = lib:round(money / 10000000,1) * 10000
	end
	if(money <0) then 
		neg = true
		money = money * -1
	end
	if(abrev=="") then
		g=floor(money/10000)
		s=floor((money-(g*10000))/100)
		c=money-s*100-g*10000
	else
		g = money/10000
		s = 0
		c = 0
	end
	if(money > 0) then
		if(g>0) then
			moneystring = format("%s%s%s", color and lib:colorize(g, neg and "ff0000" or "44dd44") or g,abrev, goldicon)
		end
		if(s>0) then
			moneystring = format("%s %s%s",moneystring, color and lib:colorize(s, neg and "ff0000" or "44dd44") or s, silvericon)
		end
		if(c>0) then
			moneystring = format("%s %s%s",moneystring, color and lib:colorize(c, neg and "ff0000" or "44dd44") or c, coppericon)
		end
	else
		moneystring = format("%s%s",color and '0' or '0', coppericon)
	end
	if(neg) then
		moneystring = format("%s%s", lib:colorize("-","ff0000"), moneystring)
	end
	return moneystring
end

--[[
	*** Mathfunctions ***
]]

function lib:round(num, idp)
	return math.floor(num * (10^(idp or 0)) + 0.5) / (10^(idp or 0))
end

--[[
	*** Arrayfunctions ***
]]

function lib:sortArray(tmp, dir)
	local newtmp = {}
	local n = 1
	local cnt = 0
	local maximum = 0
	local first
	for k, v in pairs(tmp) do
		cnt = cnt + 1
		if(v > maximum) then
			maximum = v + 1
		end
		first = first or k
	end
	while(cnt > 0) do
		local mx, mn = dir and maximum or 0, first
		for k, v in pairs(tmp) do
			if(dir) then
				if(tonumber(v) <= tonumber(mx)) then
					mx = v
					mn = k
				end
			else
				if(tonumber(v) >= tonumber(mx)) then
					mx = v
					mn = k
				end
			end
		end
		newtmp[n] = mn
		tmp[mn] = nil
		cnt = 0
		for _ in pairs(tmp) do
			cnt = cnt + 1
		end
		n = n + 1
		mn = 0
		mx = dir and mx or 0
	end
	return newtmp
end

--[[
	*** Charfunctions ***
]]

function lib:IsTwink(name)
	local at = self:GetAddOnTable()
	local db = at['db']
	local realm = GetRealmName()
	local _
	if(db['sv']['profileKeys']) then
		for k, _ in pairs(db['sv']['profileKeys']) do
			local n, m = strsplit(" - ", k, 2)
			_,m = strsplit(" ",m,2)
			if(n) then
				if(n == name and m == realm) then
					return true
				end
			end
		end
	end
	return false
end

function lib:classcolor(text,class)
	class = RAID_CLASS_COLORS[class] and class or "PRIEST"
	return string.format("|c%s%s|r",RAID_CLASS_COLORS[class]['colorStr'],text)
end

--[[
	*** End of functions ***
]]

function lib:Embed(target)
  for _,name in pairs(mixins) do
    target[name] = lib[name]
  end
  lib['targets'][target] = true
end
for target, _ in pairs(lib['targets']) do
  lib:Embed(target)
end