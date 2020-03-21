/obj/item/weapon/tool/pickaxe
	name = "pickaxe"
	desc = "The most basic of mining tools, for short excavations and small mineral extractions."
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = WEAPON_FORCE_DANGEROUS
	throwforce = WEAPON_FORCE_NORMAL
	icon_state = "pickaxe"
	item_state = "pickaxe"
	w_class = ITEM_SIZE_LARGE
	matter = list(MATERIAL_STEEL = 600)
	tool_qualities = list(QUALITY_DIGGING = 30, QUALITY_PRYING = 20, QUALITY_EXCAVATION = 10)
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	sharp = 1
	var/default_full_dig = TRUE
	//structure_damage_factor = 3 //Drills and picks are made for getting through hard materials
	//They are the best anti-structure melee weapons
	//embed_mult = 1.2 //Digs deep
	worksound = WORKSOUND_PICKAXE
	hitsound = WORKSOUND_PICKAXE

/obj/item/weapon/tool/pickaxe/jackhammer
	name = "jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	matter = list(MATERIAL_STEEL = 900, MATERIAL_PLASTIC = 600)
	tool_qualities = list(QUALITY_DIGGING = 35, QUALITY_EXCAVATION = 10)
	origin_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2)
	desc = "Cracks rocks with blasts, perfect for killing cave lizards."
	degradation = 0.07
	use_power_cost = 0.6
	suitable_cell = /obj/item/weapon/cell

/obj/item/weapon/tool/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	tool_qualities = list(QUALITY_DIGGING = 40, QUALITY_DRILLING = 10, QUALITY_EXCAVATION = 15)
	matter = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 800)
	origin_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	degradation = 0.07
	use_fuel_cost = 0.15
	max_fuel = 100

/obj/item/weapon/tool/pickaxe/diamonddrill
	name = "diamond-point mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	force = WEAPON_FORCE_DANGEROUS*1.15
	tool_qualities = list(QUALITY_DIGGING = 50, QUALITY_DRILLING = 20, QUALITY_EXCAVATION = 15)
	matter = list(MATERIAL_STEEL = 1600, MATERIAL_PLASTIC = 500, MATERIAL_DIAMOND = 800)
	origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	max_upgrades = 4
	degradation = 0.01
	use_fuel_cost = 0.15
	max_fuel = 120

/obj/item/weapon/tool/pickaxe/diamonddrill/rig
	use_fuel_cost = 0
	passive_fuel_cost = 0

/obj/item/weapon/tool/pickaxe/excavation
	name = "hand pickaxe"
	icon_state = "pick_hand"
	item_state = "syringe_0"
	throwforce = WEAPON_FORCE_NORMAL //It's smaller
	desc = "A smaller, more precise version of the pickaxe, used for archeology excavation."
	tool_qualities = list(QUALITY_DIGGING = 15, QUALITY_PRYING = 15)
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 800)
	precision = 20


/obj/item/weapon/tool/pickaxe/ds_rocksaw
	name = "rock saw"
	desc = "An energised mining tool for surveying and retrieval of objects embedded in otherwise dense material. Very dangerous, will cut through flesh and bone with ease."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "ds_rocksaw0"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	switched_on_force = WEAPON_FORCE_ROBUST
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	item_state = "ds_rocksaw0"
	w_class = ITEM_SIZE_HUGE
	matter = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 800)
	tool_qualities = list()
	switched_on_qualities = list(QUALITY_DIGGING = 50, QUALITY_DRILLING = 20, QUALITY_EXCAVATION = 15, QUALITY_SAWING = 60, QUALITY_CUTTING = 50)
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1
	max_upgrades = 4
	degradation = 0.10
	use_power_cost = 0.44
	passive_power_cost = 0.06
	suitable_cell = /obj/item/weapon/cell
	toggleable = TRUE

/obj/item/weapon/tool/pickaxe/ds_rocksaw/update_icon()
	if (switched_on)
		icon_state = "ds_rocksaw1"
		item_state = "ds_rocksaw1"
	else
		icon_state = "ds_rocksaw0"
		item_state = "ds_rocksaw0"


/obj/item/weapon/tool/pickaxe/ds_rocksaw/turn_on()
	.=..()
	playsound(get_turf(src), 'sound/weapons/saberon.ogg', 20, 1, -2)


/obj/item/weapon/tool/pickaxe/ds_rocksaw/turn_off()
	.=..()
	playsound(get_turf(src), 'sound/weapons/saberoff.ogg', 20, 1, -2)



/obj/item/weapon/tool/pickaxe/xeno
	name = "master xenoarch pickaxe"
	desc = "A miniature excavation tool for precise digging."
	icon = 'icons/obj/xenoarchaeology.dmi'
	item_state = "screwdriver_brown"
	force = WEAPON_FORCE_HARMLESS
	armor_penetration = 20	//For dealing guaranteed damage to tough rocks
	throwforce = 0
	attack_verb = list("stabbed", "jabbed", "spiked", "attacked")
	matter = list(MATERIAL_STEEL = 75)
	w_class = ITEM_SIZE_SMALL
	//drill_verb = "delicately picking"
	tool_qualities = list(QUALITY_DIGGING =  0)
	sharp = 1
	default_full_dig = FALSE
	precision = 100 //To prevent constant failing

/obj/item/weapon/tool/pickaxe/xeno/examine()
	..()
	to_chat(usr, "This tool has a [get_tool_quality(QUALITY_DIGGING)] centimetre excavation depth.")

/obj/item/weapon/tool/pickaxe/xeno/brush
	name = "wire brush"
	icon_state = "pick_brush"
	slot_flags = SLOT_EARS
	force = 1
	attack_verb = list("prodded", "attacked")
	desc = "A wood-handled brush with thick metallic wires for clearing away dust and loose scree."
	tool_qualities = list(QUALITY_DIGGING =  1)
	worksound = 'sound/weapons/thudswoosh.ogg'
	sharp = 0

/obj/item/weapon/tool/pickaxe/xeno/one_pick
	name = "2cm pick"
	icon_state = "pick1"
	tool_qualities = list(QUALITY_DIGGING =  2)
	worksound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/tool/pickaxe/xeno/two_pick
	name = "4cm pick"
	icon_state = "pick2"
	tool_qualities = list(QUALITY_DIGGING =  4)
	worksound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/tool/pickaxe/xeno/three_pick
	name = "6cm pick"
	icon_state = "pick3"
	tool_qualities = list(QUALITY_DIGGING =  6)
	worksound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/tool/pickaxe/xeno/four_pick
	name = "8cm pick"
	icon_state = "pick4"
	tool_qualities = list(QUALITY_DIGGING =  8)
	worksound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/tool/pickaxe/xeno/five_pick
	name = "10cm pick"
	icon_state = "pick5"
	tool_qualities = list(QUALITY_DIGGING =  10)
	worksound = 'sound/items/Screwdriver.ogg'

/obj/item/weapon/tool/pickaxe/xeno/six_pick
	name = "12cm pick"
	icon_state = "pick6"
	tool_qualities = list(QUALITY_DIGGING =  12)

