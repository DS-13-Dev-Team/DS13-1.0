/***********
* Implants *
***********/
/datum/uplink_item/item/implants
	category = /datum/uplink_category/implants

/datum/uplink_item/item/implants/imp_freedom
	name = "Freedom Implant"
	item_cost = 24
	path = /obj/item/weapon/storage/box/syndie_kit/imp_freedom

/datum/uplink_item/item/implants/imp_freedom/special
	item_cost = 12
	is_special = TRUE
	antag_roles = list(MODE_EARTHGOV_AGENT)

/datum/uplink_item/item/implants/imp_compress
	name = "Compressed Matter Implant"
	item_cost = 32
	path = /obj/item/weapon/storage/box/syndie_kit/imp_compress

/datum/uplink_item/item/implants/imp_explosive
	name = "Explosive Implant (DANGER!)"
	item_cost = 40
	path = /obj/item/weapon/storage/box/syndie_kit/imp_explosive

/datum/uplink_item/item/implants/imp_uplink
	name = "Uplink Implant"
	path = /obj/item/weapon/storage/box/syndie_kit/imp_uplink

/datum/uplink_item/item/implants/imp_uplink/New()
	..()
	item_cost = round(DEFAULT_TELECRYSTAL_AMOUNT / 2)
	desc = "Contains [IMPLANT_TELECRYSTAL_AMOUNT(DEFAULT_TELECRYSTAL_AMOUNT)] Telecrystal\s"

/datum/uplink_item/item/implants/imp_imprinting
	name = "Neural Imprinting Implant"
	desc = "Use on someone who is under influence of Mindbreaker to give them laws-like set of instructions. Kit comes with a dose of mindbreaker."
	item_cost = 20
	path = /obj/item/weapon/storage/box/syndie_kit/imp_imprinting

/datum/uplink_item/item/implants/imp_imprinting/special
	item_cost = 13
	is_special = TRUE
	antag_roles = list(MODE_UNITOLOGIST, MODE_UNITOLOGIST_SHARD)

/datum/uplink_item/item/implants/explosive
	name = "temp name1"
	desc = "temp desc1"
	item_cost = 13
	is_special = TRUE
	path = /obj/item/weapon/implantcase/explosive
	antag_roles = list(MODE_UNITOLOGIST, MODE_UNITOLOGIST_SHARD)
