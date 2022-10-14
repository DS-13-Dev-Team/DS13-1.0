//Unitology Ritual Blade
//Available to all patrons, loadout only
/datum/patron_item/uni_knife
	name = "unitology ritual blade"
	item_path = /obj/item/material/knife/unitologist
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
	item_path = /obj/item/gun/projectile/rivet
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
	item_path = /obj/item/rig/advanced/maxstone
	id = "max_stone_rig"
	store_cost = 12000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)

//This is not my typo, his ckey is actually spelled like that
/datum/patron_item/plaugewalker
	name = "SCAF elite RIG"
	description = "A lightweight and flexible armoured rig suit, designed for riot control and shipboard disciplinary enforcement."
	item_path = /obj/item/rig/scaf/elite
	id = "plaugewalker_rig"
	store_cost = 6400
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 3
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/security)


/datum/patron_item/banditofdoom
	name = "Evangelion RIG"
	description = "A project many months in the works, created by an obsessive historical anime fan. Even incorporates a custom voice changer for impersonating TV characters."
	item_path = /obj/item/rig/advanced/banditofdoom
	id = "banditofdoom_rig"
	store_cost = 10000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)


/datum/patron_item/hacker_rig
	name = "digital infiltration RIG"
	item_path = /obj/item/rig/hacker
	id = "hacker_rig"

	loadout_cost = 4
	loadout_access = ACCESS_PATRONS

	loadout_subtype = /datum/gear/RIG/frame
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
	loadout_access = ACCESS_WHITELIST


/datum/patron_item/marshal_wrench
	name =  "Colossal Wrench"
	id = "marshal_wrench"
	item_path = /obj/item/material/twohanded/fireaxe/bigwrench

	store_cost = 6000
	store_access = ACCESS_WHITELIST

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/tool/wrench/big_wrench)


	category = CATEGORY_TOOLS
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS

//Made public by request of commissioner
/datum/patron_item/blackwolf
	name = "wasp RIG"
	description = "A lightweight and flexible armoured rig suit, offers good protection against light impacts"
	item_path = /obj/item/rig/wasp
	id = "blackwolf_rig"
	store_cost = 9000
	store_access = ACCESS_PUBLIC

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_PUBLIC
	modkit_typelist = list(/obj/item/rig/engineering)

/datum/patron_item/sea_rig
	name = "heavy CEC diving rig"
	description = "An extremely bulky, durable diving suit. Designed for deep diving in the icy seas of Europa, able to whitstand extreme undersea pressure. Use it on a vintage rig to convert, or buy it in the store directly!"
	item_path = /obj/item/rig/vintage/sea
	id = "sea_rig"
	store_cost = 14000
	store_access = ACCESS_PATRONS

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_PATRONS
	modkit_typelist = list(/obj/item/rig/vintage)

/datum/patron_item/carver
	name = "carver's RIG"
	description = "A heavily armoured rig suit, designed for military use. Especially effective against bullets. Use it on a vintage rig to convert, or buy it in the store directly!"
	item_path = /obj/item/rig/carver
	id = "carver_rig"
	store_cost = 14000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/vintage)

/datum/patron_item/dad_rig
	name = "Elite diving rig"
	description = "An extremely durable, bulky elite diving suit. Designed for combat and deep sea diving in the North Atlantic Ocean, able to withstand extreme undersea pressure. Use it on a vintage rig to convert, or buy it in the store directly!"
	item_path = /obj/item/rig/vintage/sea/dad
	id = "dad_rig"
	store_cost = 14000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/vintage)

/datum/patron_item/muramasa
	name =  "Experimental Ceremonial Sword"
	description = "Use on a rock saw to obtain! A blade passed down through generations of a dedicated unitologist family, the Higgins. Sam had it modified into a experimental ceremonial blade, enhancing the already astonishing properties of the original metal and giving it an ominous crimson glow that matches the Marker. An explosive charge housed in the scabbard enables a lightning-quick draw."
	id = "muramasa"
	item_path = /obj/item/material/twohanded/muramasa

	store_cost = 4000
	store_access = ACCESS_WHITELIST

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/tool/pickaxe/laser)


	category = CATEGORY_TOOLS
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS

/datum/patron_item/muramasa_sheath
	name =  "Ceremonial Sheath"
	id = "muramasa_sheath"
	item_path = /obj/item/storage/belt/holster/muramasa
	store_cost = 1500
	store_access = ACCESS_WHITELIST
	description = "A lavishly decorated ceremonial sheath, looks oddly gun-shaped."
	loadout_cost = 1
	loadout_access = ACCESS_WHITELIST

	category = CATEGORY_TOOLS
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS