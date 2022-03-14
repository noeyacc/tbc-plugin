local addonName, addon = ...
local childName = addon['childName']
local child = addon[childName]
local db
local L = LibStub("AceLocale-3.0"):GetLocale(childName, true)
SlashCmdList[string.upper(childName)] = function(msg)
	local um = string.upper(msg)
	for id, itemname in pairs(db['names']) do
		local un = string.upper(itemname)
		if(string.find(un, um)) then
			local item = Item:CreateFromItemID(id)
			local itemlink = item:GetItemLink()
			local dout = {}
			if(id)then
				for oname, b in pairs(child:Search(id)) do
					local dname, drealm = strsplit(" - ", oname)
					local input, sum = child:output(b)
					if(sum > 0) then
						dout[#dout+1] = (format(L['cmd_main_string'], dname, sum, child:colorize(table.concat(input,', '), "ffffff")))
					end
					input = nil
				end
				dout = child:specialoutput2(id,dout)
			end
			if(#dout>0) then
				print(format(L['cmd_header_string'], child:getIcon(id), itemlink and itemlink or itemname))
				for _, v in pairs(dout) do
					print(v)
				end
			end
		end
	end
end
_G[format("SLASH_%s1", string.upper(childName))] = "/find"
local init = {
	Setup = function(self)
		db = child['db']
	end
}
addon.RegisterCallback(init, format("Init%s", childName), 'Setup')