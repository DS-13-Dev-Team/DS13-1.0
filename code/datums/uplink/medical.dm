/**********
* Medical *
**********/
/datum/uplink_item/item/medical
	category = /datum/uplink_category/medical

/datum/uplink_item/item/medical/surgery
	name = "Surgery kit"
	item_cost = 40
	path = /obj/item/weapon/storage/firstaid/surgery

/datum/uplink_item/item/medical/combat
	name = "Combat medical kit"
	item_cost = 48
	path = /obj/item/weapon/storage/firstaid/combat

/datum/uplink_item/item/medical/medigel
	name = "medical gel injector"
	item_cost = 8
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/ds_medigel
	is_special = TRUE
	antag_roles = list(MODE_EARTHGOV_AGENT, MODE_UNITOLOGIST, MODE_UNITOLOGIST_SHARD)
