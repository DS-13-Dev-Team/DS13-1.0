#define ORE_VALUE_FACTOR	5 //Change this number to modify mining bonus outputs globally
var/global/list/ore_data = list()
var/global/list/ores_by_type = list()

/proc/ensure_ore_data_initialised()
	if(ore_data && ore_data.len) return

	for(var/oretype in subtypesof(/ore))
		var/ore/O = new oretype()
		ore_data[O.name] = O
		ores_by_type[oretype] = O

/ore
	var/name              // Name of ore. Also used as a tag.
	var/display_name      // Visible name of ore.
	var/icon_tag          // Used for icon_state as "ore_[icon_tag]" and "rock_[icon_tag]"
	var/material          // Name of associated mineral, if any
	var/alloy             // Boolean, is this involved in any alloying recipes? Just for optimisation
	var/smelts_to         // Smelts to material; this is the name of the result material.
	var/compresses_to     // Compresses to material; this is the name of the result material.
	var/result_amount     // How much ore?
	var/spread = 1	      // Does this type of deposit spread?
	var/spread_chance     // Chance of spreading in any direction
	var/ore	              // Path to the ore produced when tile is mined.
	var/scan_icon         // Overlay for ore scanners.
	// Xenoarch stuff. No idea what it's for, just refactored it to be less awful.
	var/list/xarch_ages = list(
		"thousand" = 999,
		"million" = 999
		)
	var/xarch_source_mineral = "iron"
	var/list/origin_tech = list(TECH_MATERIAL = 1)
	var/value = 2.5	//Fallback value, only used if this is a non smeltable, non compressible ore


/ore/New()
	. = ..()
	if(!display_name)
		display_name = name
	if(!material)
		material = name
	if(!icon_tag)
		icon_tag = name

/ore/proc/Value()
	var/material/M
	if(smelts_to)
		M = get_material_by_name(smelts_to)
	else if (compresses_to)
		M = get_material_by_name(compresses_to)

	if(istype(M))
		return ORE_VALUE_FACTOR*M.value
	else
		return ORE_VALUE_FACTOR*value

/ore/uranium
	name = "uranium"
	display_name = "pitchblende"
	smelts_to = "uranium"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/uranium
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 704
		)
	xarch_source_mineral = "potassium"
	origin_tech = list(TECH_MATERIAL = 5)

/ore/hematite
	name = "iron"
	display_name = "hematite"
	smelts_to = "iron"
	alloy = 1
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/iron
	scan_icon = "mineral_common"

/ore/coal
	name = "carbon"
	display_name = "raw carbon"
	icon_tag = "coal"
	smelts_to = "plastic"
	alloy = 1
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/coal
	scan_icon = "mineral_common"

/ore/glass
	name = "sand"
	display_name = "sand"
	icon_tag = MATERIAL_GLASS
	smelts_to = MATERIAL_GLASS
	alloy = 1
	compresses_to = MATERIAL_SANDSTONE
	ore = /obj/item/weapon/ore/glass //Technically not needed since there's no glass ore vein, but consistency is nice

/ore/phoron
	name = MATERIAL_PHORON
	display_name = "phoron crystals"
	compresses_to = MATERIAL_PHORON
	//smelts_to = something that explodes violently on the conveyor, huhuhuhu
	result_amount = 5
	spread_chance = 25
	ore = /obj/item/weapon/ore/phoron
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = MATERIAL_PHORON
	origin_tech = list(TECH_MATERIAL = 2)

/ore/silver
	name = MATERIAL_SILVER
	display_name = "native silver"
	smelts_to = MATERIAL_SILVER
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/silver
	scan_icon = "mineral_uncommon"
	origin_tech = list(TECH_MATERIAL = 3)

/ore/gold
	smelts_to = MATERIAL_GOLD
	name = MATERIAL_GOLD
	display_name = "native gold"
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/gold
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 4,
		"billion_lower" = 3
		)
	origin_tech = list(TECH_MATERIAL = 4)

/ore/diamond
	name = MATERIAL_DIAMOND
	display_name = MATERIAL_DIAMOND
	compresses_to = MATERIAL_DIAMOND
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/diamond
	scan_icon = "mineral_rare"
	xarch_source_mineral = "nitrogen"
	origin_tech = list(TECH_MATERIAL = 6)

/ore/platinum
	name = "platinum"
	display_name = "raw platinum"
	smelts_to = "platinum"
	compresses_to = "osmium"
	alloy = 1
	result_amount = 5
	spread_chance = 10
	ore = /obj/item/weapon/ore/osmium
	scan_icon = "mineral_rare"

/ore/hydrogen
	name = "mhydrogen"
	display_name = "metallic hydrogen"
	smelts_to = "tritium"
	compresses_to = "mhydrogen"
	ore = /obj/item/weapon/ore/hydrogen //Technically not needed since there's no hydrogen ore vein, but consistency is nice
	scan_icon = "mineral_rare"
