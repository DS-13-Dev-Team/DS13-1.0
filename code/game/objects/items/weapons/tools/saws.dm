/obj/item/weapon/tool/saw
	name = "hacksaw"
	desc = "For cutting wood and other objects to pieces. Or sawing bones, in case of emergency."
	icon_state = "metal_saw"
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	worksound = WORKSOUND_SIMPLE_SAW
	obj_flags = OBJ_FLAG_CONDUCTIBLE

	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	attack_noun = list("attack", "slash", "saw", "cut")
	sharp = TRUE
	edge = TRUE
	tool_qualities = list(QUALITY_SAWING = 30, QUALITY_CUTTING = 20, QUALITY_WIRE_CUTTING = 20)
	//embed_mult = 1 //Serrated blades catch on bone more easily

	degradation = DEGRADATION_TOUGH_1

/obj/item/weapon/tool/saw/improvised
	name = "choppa"
	desc = "A wicked serrated blade made of whatever nasty sharp things you could find. It would make a pretty decent weapon."
	icon_state = "impro_saw"
	force = WEAPON_FORCE_PAINFUL
	tool_qualities = list(QUALITY_SAWING = 15, QUALITY_CUTTING = 10, QUALITY_WIRE_CUTTING = 10)


/obj/item/weapon/tool/saw/circular
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon_state = "saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_STEEL = 1000, MATERIAL_PLASTIC = 600)
	tool_qualities = list(QUALITY_SAWING = 40, QUALITY_CUTTING = 30, QUALITY_WIRE_CUTTING = 30)

	use_power_cost = 0.15
	suitable_cell = /obj/item/weapon/cell

/obj/item/weapon/tool/saw/advanced_circular
	name = "advanced circular saw"
	desc = "You think you can cut anything with it."
	icon_state = "advanced_saw"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_DANGEROUS
	matter = list(MATERIAL_STEEL = 1200, MATERIAL_PLASTIC = 800)
	tool_qualities = list(QUALITY_SAWING = 50, QUALITY_CUTTING = 40, QUALITY_WIRE_CUTTING = 40)
	degradation = 0.06
	use_power_cost = 0.22
	suitable_cell = /obj/item/weapon/cell
	max_modifications = 4

/obj/item/weapon/tool/saw/chain
	name = "chainsaw"
	desc = "You can cut trees, people walls and zombies with it, just watch out for fuel."
	icon_state = "chainsaw"
	hitsound = WORKSOUND_CHAINSAW
	worksound = WORKSOUND_CHAINSAW
	force = WEAPON_FORCE_DANGEROUS
	matter = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 3000)
	tool_qualities = list(QUALITY_SAWING = 60, QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20)
	max_modifications = 4
	use_fuel_cost = 0.1
	max_fuel = 80

/obj/item/weapon/tool/saw/plasma
	name = "SH-B1 Plasma Saw"
	desc = "The SH-B1 Plasma Saw is designed for dissection of heavy duty materials in both on and off-site locations. Users are advised to always wear protective clothing when the saw is in use."
	icon_state = "plasma_saw_off"
	item_state = "plasma_saw_off"
	hitsound = WORKSOUND_CIRCULAR_SAW
	worksound = WORKSOUND_CIRCULAR_SAW
	force = WEAPON_FORCE_HARMLESS
	switched_on_force = WEAPON_FORCE_DANGEROUS
	matter = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 3000)
	tool_qualities = list()
	switched_on_qualities = list(QUALITY_SAWING = 60, QUALITY_CUTTING = 50, QUALITY_WIRE_CUTTING = 20, QUALITY_DIGGING = 35)
	max_modifications = 4
	use_power_cost = 0.44
	passive_power_cost = 0.06
	passive_fuel_cost = 0
	suitable_cell = /obj/item/weapon/cell
	toggleable = TRUE
	atom_flags = ATOM_FLAG_NO_BLOOD
	item_flags = ITEM_FLAG_NO_EMBED
	armor_penetration = 4.5

/obj/item/weapon/tool/saw/plasma/update_icon()
	if (switched_on)
		icon_state = "plasma_saw_on"
		item_state = "plasma_saw_on"
	else
		icon_state = "plasma_saw_off"
		item_state = "plasma_saw_off"


/obj/item/weapon/tool/saw/plasma/turn_on()
	.=..()
	if(.)
		flick("plasma_saw_ignite", src)
		playsound(get_turf(src), 'sound/weapons/saberon.ogg', 20, 1, -2)

/obj/item/weapon/tool/saw/plasma/turn_off()
	.=..()
	playsound(get_turf(src), 'sound/weapons/saberoff.ogg', 20, 1, -2)
