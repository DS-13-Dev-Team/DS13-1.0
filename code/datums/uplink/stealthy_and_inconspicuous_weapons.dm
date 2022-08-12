/*************************************
* Stealthy and Inconspicuous Weapons *
*************************************/
/datum/uplink_item/item/stealthy_weapons
	category = /datum/uplink_category/stealthy_weapons

/datum/uplink_item/item/stealthy_weapons/soap
	name = "Subversive Soap"
	item_cost = 1
	path = /obj/item/soap/syndie

/datum/uplink_item/item/stealthy_weapons/cigarette_kit
	name = "Cigarette Kit"
	item_cost = 8
	path = /obj/item/storage/box/syndie_kit/cigarette

/datum/uplink_item/item/stealthy_weapons/concealed_cane
	name = "Concealed Cane Sword"
	item_cost = 8
	path = /obj/item/cane/concealed

/datum/uplink_item/item/stealthy_weapons/random_toxin
	name = "Random Toxin - Beaker"
	item_cost = 8
	path = /obj/item/storage/box/syndie_kit/toxin

/datum/uplink_item/item/stealthy_weapons/sleepy
	name = "Sleepy Pen"
	item_cost = 20
	path = /obj/item/pen/reagent/sleepy

/datum/uplink_item/item/stealthy_weapons/syringegun
	name = "Disguised Syringe Gun"
	item_cost = 10
	path = /obj/item/storage/box/syndie_kit/syringegun

/datum/uplink_item/item/stealthy_weapons/divet
	name = "Silenced Divet pistol"
	item_cost = 7
	path = /obj/item/gun/projectile/divet/silenced
	is_special = TRUE
	antag_roles = list(MODE_EARTHGOV_AGENT)