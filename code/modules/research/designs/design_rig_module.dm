//RIG Modules
//Sidenote; Try to keep a requirement of 5 engineering for each, but keep the rest as similiar to it's original as possible.
/datum/design/item/rig_module
	category = "Modules"
	materials = list(MATERIAL_STEEL = 4000, "plastic" = 2500, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	price = 2500
	build_type = STORE_SCHEMATICS
	store_transfer = TRUE

/datum/design/item/rig_module/meson
	name = "Meson Scanner"
	desc = "A layered, translucent visor system for a RIG."
	id = "rig_meson"
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200, "plastic" = 300)
	build_path = /obj/item/rig_module/vision/meson

/datum/design/item/rig_module/medhud
	name = "Medical HUD"
	desc = "A simple medical status indicator for a RIG."
	id = "rig_medhud"
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  "plastic" = 300)
	build_path = /obj/item/rig_module/vision/medhud

/datum/design/item/rig_module/sechud
	name = "Security HUD"
	desc = "A simple security status indicator for a RIG."
	id = "rig_sechud"
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  "plastic" = 300)
	build_path = /obj/item/rig_module/vision/sechud

/datum/design/item/rig_module/nvg
	name = "Night Vision"
	desc = "A night vision module, mountable on a RIG."
	id = "rig_nvg"
	materials = list("plastic" = 500, MATERIAL_STEEL = 300, MATERIAL_GLASS = 200, "uranium" = 200)
	build_path = /obj/item/rig_module/vision/nvg

/datum/design/item/rig_module/healthscanner
	name = "Medical Scanner"
	desc = "A device able to distinguish vital signs of the subject, mountable on a RIG."
	id = "rig_healthscanner"
	materials = list("plastic" = 1000, MATERIAL_STEEL = 700, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/healthscanner

/datum/design/item/rig_module/drill
	name = "Mining Drill"
	desc = "A diamond mining drill, mountable on a RIG."
	id = "rig_drill"
	materials = list(MATERIAL_STEEL = 3500, MATERIAL_GLASS = 1500, MATERIAL_DIAMOND = 2000, "plastic" = 1000)
	build_path = /obj/item/rig_module/device/drill

/datum/design/item/rig_module/orescanner
	name = "Ore Scanner"
	desc = "A sonar system for detecting large masses of ore, mountable on a RIG."
	id = "rig_orescanner"
	materials = list("plastic" = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/orescanner

/datum/design/item/rig_module/anomaly_scanner
	name = "Anomaly Scanner"
	desc = "An exotic particle detector commonly used by xenoarchaeologists, mountable on a RIG."
	id = "rig_anomaly_scanner"
	materials = list("plastic" = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/anomaly_scanner

/*	//Noncanon
/datum/design/item/rig_module/rcd
	name = "RCD"
	desc = "A Rapid Construction Device, mountable on a RIG."
	id = "rig_rcd"
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 1000, "plastic" = 1000,MATERIAL_GOLD = 700, MATERIAL_SILVER = 700)
	build_path = /obj/item/rig_module/device/rcd
	sort_string = "WCEAA"
*/
/datum/design/item/rig_module/jets
	name = "Maneuvering Jets"
	desc = "A compact gas thruster system, mountable on a RIG."
	id = "rig_jets"
	materials = list(MATERIAL_STEEL = 3000, "plastic" = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/rig_module/maneuvering_jets

//I think this is like a janitor thing but seems like it could be useful for engis
/datum/design/item/rig_module/decompiler
	name = "Matter Decompiler"
	desc = "A drone matter decompiler reconfigured to be mounted onto a RIG."
	id = "rig_decompiler"
	materials = list(MATERIAL_STEEL = 3000, "plastic" = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/rig_module/device/decompiler

/datum/design/item/rig_module/powersink
	name = "Power Sink"
	desc = "A RIG module that allows the user to recharge their RIG's power cell without removing it."
	id = "rig_powersink"
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000, "plastic" = 1000)
	build_path = /obj/item/rig_module/power_sink

/datum/design/item/rig_module/flash
	name = "Flash"
	desc = "A normal flash, mountable on a RIG."
	id = "rig_flash"
	build_type = PROTOLATHE | STORE_SCHEMATICS
	materials = list("plastic" = 1500, MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/flash

/datum/design/item/rig_module/taser
	name = "Taser"
	desc = "A taser, mountable on a RIG."
	id = "rig_taser"
	build_type = PROTOLATHE | STORE_SCHEMATICS
	materials = list(MATERIAL_STEEL = 4000, "plastic" = 2500, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/rig_module/mounted/taser

/*	//Noncanon
/datum/design/item/rig_module/egun
	name = "Energy Gun"
	desc = "An energy gun, mountable on a RIG."
	id = "rig_egun"
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, "plastic" = 2500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/rig_module/mounted/egun

/datum/design/item/rig_module/enet
	name = "Energy Net"
	desc = "An advanced energy-patterning projector used to capture targets, mountable on a RIG."
	id = "rig_enet"
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_DIAMOND = 2000, "plastic" = 2000)
	build_path = /obj/item/rig_module/fabricator/energy_net
*/
/datum/design/item/rig_module/cooling_unit
	name = "Cooling Unit"
	desc = "A suit cooling unit, mountable on a RIG."
	id = "rig_cooler"
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 3500, "plastic" = 2000)
	build_path = /obj/item/rig_module/cooling_unit

/datum/design/item/rig_module/kinesis
	name = "G.R.I.P kinesis module"
	build_type = STORE_SCHEMATICS
	build_path = /obj/item/rig_module/kinesis

/datum/design/item/rig_module/kinesis_adv
	price = 5000
	name = "G.R.I.P advanced kinesis module"
	build_path = /obj/item/rig_module/kinesis/advanced

/datum/design/item/rig_module/speedboost
	name = "Femoral Exoskeleton"
	build_path = /obj/item/rig_module/extension/speedboost

/datum/design/item/rig_module/speedboost_adv
	name = "Advanced Femoral Exoskeleton"
	price = 5000
	build_path = /obj/item/rig_module/extension/speedboost/advanced

/datum/design/item/rig_module/adv_healthbar
	name = "Vitals Monitor: Advanced"
	build_path = /obj/item/rig_module/healthbar/advanced
