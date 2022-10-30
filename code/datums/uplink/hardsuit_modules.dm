/*******************
* Hardsuit Modules *
*******************/
/datum/uplink_item/item/hardsuit_modules
	category = /datum/uplink_category/hardsuit_modules

/datum/uplink_item/item/hardsuit_modules/thermal
	name = "\improper Thermal Scanner"
	item_cost = 16
	path = /obj/item/rig_module/vision/thermal

/datum/uplink_item/item/hardsuit_modules/energy_net
	name = "\improper Net Projector"
	item_cost = 20
	path = /obj/item/rig_module/fabricator/energy_net

/datum/uplink_item/item/hardsuit_modules/ewar_voice
	name = "\improper Electrowarfare Suite and Voice Synthesiser"
	item_cost = 24
	path = /obj/item/storage/backpack/satchel/syndie_kit/ewar_voice

/datum/uplink_item/item/hardsuit_modules/ewar_voice/special
	is_special = TRUE
	item_cost = 6
	antag_roles = list(MODE_UNITOLOGIST, MODE_UNITOLOGIST_SHARD)

/datum/uplink_item/item/hardsuit_modules/zealot
	name = "Zealot RIG"
	path = /obj/item/rig/zealot
	item_cost = 23
	is_special = TRUE
	antag_roles = list(MODE_UNITOLOGIST, MODE_UNITOLOGIST_SHARD)

/datum/uplink_item/item/hardsuit_modules/earthgov
	name = "Earthgov RIG"
	path = /obj/item/rig/marine/specialist
	item_cost = 25
	is_special = TRUE
	antag_roles = list(MODE_EARTHGOV_AGENT)

/datum/uplink_item/item/hardsuit_modules/maneuvering_jets
	name = "\improper Maneuvering Jets"
	item_cost = 32
	path = /obj/item/rig_module/maneuvering_jets

/datum/uplink_item/item/hardsuit_modules/egun
	name = "\improper Mounted Energy Gun"
	item_cost = 48
	path = /obj/item/rig_module/mounted/egun

/datum/uplink_item/item/hardsuit_modules/power_sink
	name = "\improper Power Sink"
	item_cost = 48
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/hardsuit_modules/laser_canon
	name = "\improper Mounted Laser Cannon"
	item_cost = 64
	path = /obj/item/rig_module/mounted
