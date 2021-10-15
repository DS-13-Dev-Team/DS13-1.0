//Unitology Ritual Blade
//Available to all patrons, loadout only
/datum/patron_item/uni_knife
	name = "unitology ritual blade"
	item_path = /obj/item/weapon/material/knife/unitologist
	loadout_cost = 3
	loadout_access = ACCESS_PATRONS
	description = "A pristine blade used for religious ceremonies in the Church of Unitology.\
	  Mechanically, it has the same stats as an ordinary boot knife, but it has two important special features. <br>\
	  <br>\
	  1. While held in hand, the blade unlocks the unique Sacrifice execution move, allowing ritual murder of a human without head protection. <br>\
	  A human sacrificed in this manner is worth more biomass when the necromorphs get to them later.<br>\
	  Requires the victim to remain still, so best restrain them first. The ritual takes wquite a while, giving you ample opportunity for a short speech<br>\
	  Please note that simply owning this knife does not make you an antag, and you shouldn't be murdering humans if you aren't an antagonist.<br>\
	  <br>\
	  2. While equipped, both in your loadout at roundstart, and your inventory during the round, this blade gives an extra 15% chance to be picked for unitology antagonist roles.<br>\
	  This effect does not override your preferences, if you have unitologists set to never then you still won't be picked"


/*
	Guns
*/
/datum/patron_item/rivet
	name =  "711-MarkCL Rivet Gun"
	id = "rivetgun"
	item_path = /obj/item/weapon/gun/projectile/rivet
	store_cost = 2400
	store_access = ACCESS_PATRONS
	description = "The 711-MarkCL Rivet Gun is the latest refinement from Timson Tools' long line of friendly tools. Useful for rapid repairs at a distance!"
	loadout_cost = 4
	loadout_access = ACCESS_PATRONS

	category = CATEGORY_TOOLS
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS


/*
	RIG suits
*/
/datum/patron_item/max_stone_rig
	name = "modified advanced RIG"
	description = "The latest in cutting-edge RIG technology. This one is a slightly older model, still using the standard engineering suit scheme. It has `Max S.` engraved next to the monitor lights."
	item_path = /obj/item/weapon/rig/advanced/maxstone
	id = "max_stone_rig"
	store_cost = 12000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/weapon/rig/advanced)


/datum/patron_item/hacker_rig
	name = "digital infiltration RIG"
	item_path = /obj/item/weapon/rig/hacker
	id = "max_stone_rig"

	loadout_cost = 4
	loadout_access = ACCESS_PATRONS

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	tags = list(LOADOUT_TAG_RIG)
	exclusion_tags = list(LOADOUT_TAG_RIG)
	equip_adjustments = OUTFIT_ADJUSTMENT_SKIP_BACKPACK


/datum/patron_item/mouse
	name = "mouse"
	item_path = /mob/living/simple_animal/mouse
	id = "mouse"
	store_cost = 1000
	store_access = ACCESS_WHITELIST
