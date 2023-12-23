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
	description = "The 711-MarkCL Rivet Gun is the latest refinement from Timson Tools' long line of friendly tools. Useful for rapid repairs at a distance!"
	item_path = /obj/item/gun/projectile/rivet
	id = "rivetgun"
	store_cost = 2400
	store_access = ACCESS_PUBLIC

	loadout_cost = 4
	loadout_access = ACCESS_PATRONS

	category = CATEGORY_TOOLS
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS


/*
	RIG suits
*/
/datum/patron_item/max_stone_rig
	name = "Advanced Engineering RIG"
	description = "The latest in cutting-edge RIG technology, uses the standard engineering suit scheme. It has `Parker R.` engraved next to the monitor lights."
	item_path = /obj/item/rig/advanced/maxstone
	id = "max_stone_rig"
	store_cost = 17000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)

//This is not my typo, his ckey is actually spelled like that
/datum/patron_item/plaugewalker
	name = "SCAF Elite RIG"
	description = "A lightweight and flexible armoured rig suit, designed for riot control and shipboard disciplinary enforcement."
	item_path = /obj/item/rig/pcsi/elite
	id = "plaugewalker_rig"
	store_cost = 11000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/pcsi)


/datum/patron_item/banditofdoom
	name = "Evangelion RIG"
	description = "A project many months in the works, created by an obsessive historical anime fan. Even incorporates a custom voice changer for impersonating TV characters."
	item_path = /obj/item/rig/advanced/banditofdoom
	id = "banditofdoom_rig"
	store_cost = 17000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 2
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)


/datum/patron_item/hacker_rig
	name = "Digital Infiltration RIG"
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
	description = "If everything else failed - bring a bigger wrench."
	id = "marshal_wrench"
	item_path = /obj/item/material/twohanded/fireaxe/bigwrench
	store_cost = 6000
	store_access = ACCESS_PUBLIC

	category = CATEGORY_TOOLS
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS

	loadout_modkit_cost = 2
	modkit_access = ACCESS_PUBLIC
	modkit_typelist = list(/obj/item/tool/wrench/big_wrench)


//Made public by request of commissioner
/datum/patron_item/blackwolf
	name = "Wasp RIG"
	description = "A lightweight and flexible armoured rig suit, offers good protection against light impacts"
	id = "blackwolf_rig"
	item_path = /obj/item/rig/marksman/wasp
	store_cost = 11500
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/marksman)

/datum/patron_item/sea_rig
	name = "Hazard Diving RIG"
	description = "The heavy-duty vintage diving RIG is the standard among CEC deep sea mining operations. It's plating has been reinforced to withstand extreme undersea pressures and concussive forces."
	item_path = /obj/item/rig/vintage/sea
	id = "sea_rig"
	store_cost = 17000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/vintage)

/datum/patron_item/carver
	name = "Spec Ops RIG"
	description = "A heavily armoured rig suit, designed for military use. Especially effective against bullets."
	item_path = /obj/item/rig/pcsi/carver
	id = "carver_rig"
	store_cost = 11000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/pcsi)

/datum/patron_item/dad_rig
	name = "Elite Diving RIG"
	description = "The elite diving RIG is the next generation of diving RIGs used among CEC deep sea mining operations. It's flexible reinforcements allow it to withstand extreme undersea pressures while retaining mobility."
	item_path = /obj/item/rig/advanced/dad
	id = "dad_rig"
	store_cost = 17000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)

/datum/patron_item/sister_rig
	name = "Strange Diving RIG"
	description = "a strange diving RIG with a cage on the shoulder and symbols drawn upon the suit. It's flexible reinforcements allow it to withstand extreme undersea pressures while retaining mobility."
	item_path = /obj/item/rig/advanced/sister
	id = "sister_rig"
	store_cost = 17000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)

/datum/patron_item/muramasa
	name =  "Experimental Ceremonial Sword"
	description = "A blade passed down through generations of a dedicated unitologist family, the Higgins. Sam had it modified into a experimental ceremonial blade, enhancing the already astonishing properties of the original metal and giving it an ominous crimson glow that matches the Marker. An explosive charge housed in the scabbard enables a lightning-quick draw."
	id = "muramasa"
	item_path = /obj/item/material/twohanded/muramasa

	store_cost = 4000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_TOOLS
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS

	loadout_modkit_cost = 1
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/tool/pickaxe/laser)

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

/datum/patron_item/tarnished
	name = "Tarnished RIG"
	description = "A rig made from the reforged armor of his family that was passed from generation to generations for decades."
	item_path = /obj/item/rig/advanced/tarnished
	id = "tarnished"
	store_cost = 17000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)


/datum/patron_item/arctic_suit //public for all patrons
	name = "Arctic Survival RIG"
	description = "A standard-issue Sovereign Colonies RIG used for exploring and generally weathering harsh environments otherwise hostile to human life, from space to an icy alien tundra."
	item_path = /obj/item/rig/advanced/arctic
	id = "arctic"
	store_cost = 17000 //same as advanced rig
	store_access = ACCESS_PATRONS

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES


/datum/patron_item/witness
	name = "Witness RIG"
	description = "A Sovereign Colonies all-purpose survival RIG painted in a mesmerizing fashion as a tribute to the Church of Unitology and the general faith they hold."
	item_path = /obj/item/rig/advanced/arctic/witness
	id = "witness"
	store_cost = 17000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/advanced)


/datum/patron_item/survivor
	name = "PCSI Survivor RIG"
	description = "The RIG remains battered and beaten, dented and missing pieces. The blood remains permanently rusted to the frame. The will of the survivor remains unbroken."
	item_path = /obj/item/rig/pcsi/ruined
	id = "psci_survivor"
	store_cost = 11000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/pcsi)


/datum/patron_item/forged
	name = "Forged Engineering RIG"
	description = "A lightweight and flexible armoured rig suit, designed for mining and shipboard engineering."
	item_path = /obj/item/rig/engineering/forged
	id = "forged"
	store_cost = 6500
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/engineering)

/datum/patron_item/flesh
	name = "Fleshy Power Node"
	description = "Use on a zealot rig to obtain"
	item_path = /obj/item/stack/special_node/evil
	id = "flesh"
	store_cost = 1000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

/datum/patron_item/heavy
	name = "Antique Heavy-Duty CEC RIG"
	description = "The heavy-duty vintage CEC RIG is used in the most hazardous engineering operations aboard CEC vessels. Its heavier armor plating can withstand more blunt damage than most CEC suits, and can withstand radiation just as well. As working conditions on CEC ships have improved, this RIG has been discontinued, but some heavy variants can still be found on old planet crackers."
	item_path = /obj/item/rig/vintage/heavy
	id = "vintage_suit"
	store_cost = 17000
	store_access = ACCESS_PATRONS

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_PATRONS
	modkit_typelist = list(/obj/item/rig/vintage)

/datum/patron_item/forged_sta
	name = "Standard Forged Engineering RIG"
	description = "A lightweight and flexible armoured rig suit, designed for mining and shipboard engineering."
	item_path = /obj/item/rig/engineering/forged_new
	id = "engineer_standard_forged_rig"
	store_cost = 6500
	store_access = ACCESS_PATRONS

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_PATRONS
	modkit_typelist = list(/obj/item/rig/engineering)

/datum/patron_item/forged_int
	name = "Intermediate Forged Engineering RIG"
	description = "A lightweight and flexible armoured rig suit, designed for mining and shipboard engineering."
	item_path = /obj/item/rig/intermediate/forged
	id = "engineer_intermediate_forged_rig"
	store_cost = 10000
	store_access = ACCESS_PATRONS

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_PATRONS
	modkit_typelist = list(/obj/item/rig/intermediate)

/datum/patron_item/forged_adv
	name = "Advanced Forged Engineering RIG"
	description = "A lightweight and flexible armoured rig suit, designed for mining and shipboard engineering."
	item_path = /obj/item/rig/advanced/forged
	id = "engineer_advanced_forged_rig"
	store_cost = 17000
	store_access = ACCESS_PATRONS

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_PATRONS
	modkit_typelist = list(/obj/item/rig/advanced)

/datum/patron_item/intermediate/survivor
	name = "Intermediate Survivor Engineering RIG"
	description = "A lightweight and flexible armoured rig suit, designed for mining and shipboard engineering."
	item_path = /obj/item/rig/intermediate/survivor
	id = "intermediate_engineer_survivor_rig"
	store_cost = 10000
	store_access = ACCESS_WHITELIST

	category = CATEGORY_RIG
	subcategory = SUBCATEGORY_FRAMES

	loadout_modkit_cost = 0
	modkit_access = ACCESS_WHITELIST
	modkit_typelist = list(/obj/item/rig/intermediate)
