local addonname, addon = ...
local childName = addon['childName']
local L = LibStub("AceLocale-3.0"):NewLocale(childName, "deDE", false)
if L then
	L['tooltip_main_string'] = "%s %s: %s [ %s ]"
	L['tooltip_id_string'] = "Id: %i"
	L['cmd_main_string'] = " %s: %s [ %s ]"
	L['cmd_header_string'] = "%s %s"
	L['pref_modul_toggle'] = function(namespace) return format("Ein/Aus %s",namespace) end
	L['pref_tooltip_toggle'] = function(namespace) return format("Ein/Aus Tooltip %s",namespace) end
	L['pref_modul_header'] = "Module ein-/ausschalten"
	L['pref_modul_desc'] = "Abgeschaltete Module updaten die gespeicherten Daten nicht mehr!"
	L['pref_tooltip_header'] = "Tooltip ein-/ausschalten"
	L['pref_tooltip_desc'] = "Abgeschaltete Module werden nicht im Tooltip angezeigt!"
	L['pref_itemid_header'] = "ItemID anzeigen"
	L['pref_itemid_desc'] = "Zeige ItemID in Tooltips"
	L['pref_maint_char_header'] = "Characterauswahl"
	L['pref_maint_char_desc'] = "W\195\164hle einen Character aus"
	L['pref_maint_char_del_header'] = "L\195\182schen"
	L['pref_maint_char_del_desc'] = "L\195\182sche den ausgew\195\164hlten Character"
	L['pref_maint_guild_header'] = "Gildenauswahl"
	L['pref_maint_guild_desc'] = "W\195\164hle eine Gilde aus"
	L['pref_maint_guild_del_header'] = "L\195\182schen"
	L['pref_maint_guild_del_desc'] = "L\195\182sche die ausgew\195\164hlte Gilde"
	L['pref_maint_names_del_header'] = "L\195\182sche Namensspeicher"
	L['pref_maint_names_del_desc'] = "L\195\182sche die gespeicherten Itemnamen. Sie werden f\195\188r die Suche ben\195\182tigt."
	L['pref_maint_icons_del_header'] = "L\195\182sche Iconspeicher"
	L['pref_maint_icons_del_desc'] = "L\195\182sche die gespeicherten Icons. Sie werden f\195\188r die Suche/Tooltip ben\195\182tigt."
	L['pref_donthookCraftFrame_header'] = "Deaktiviere Verzaubertooltip"
	L['pref_donthookCraftFrame_desc'] = "Falls der Tooltip im Verzauberfenster Probleme macht bitte mit dieser Einstellung deaktivieren. Braucht einen UI Reload um wirksam zu werden."
	L['pref_crafttip_header'] = "Einstellungen zum Enchanting Tooltip"
 	L['pref_crafttip_desc'] = "Ersetzt den Standardtooltip f\195\188r den Verzaubererberuf zz_itemsdb."
	L['pref_crafttipscale_header'] = "Skalierung"
	L['pref_crafttipscale_desc'] = "Setzt die Skalierung f\195\188r den Tooltip. Voreinstellung ist 0.9."
	L['Character'] = "Charakter"
	L['Database'] = "Datenbank"
	L['Guild'] = "Gilde"
end