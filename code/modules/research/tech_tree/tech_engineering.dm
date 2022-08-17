/datum/technology/engineering
	tech_type = TECH_ENGINEERING

/datum/technology/engineering/basic
	name = "Basic Engineering"
	desc = "Basic"
	id = "basic_engineering"


	x = 2
	y = 5
	icon = 'icons/obj/tools.dmi'
	icon_state = "wrench"

	required_technologies = list()
	cost = 0

	unlocks_designs = list("light_replacer", "weldingmask", "autolathe", "arcademachine", "oriontrail", "boombox")

/datum/technology/engineering/basic_parts
	name = "Basic Parts"
	desc = "First step into making your own machinery"
	id = "basic_parts"


	x = 2
	y = 3.5
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "matter_bin"

	required_technologies = list("basic_engineering")
	cost = 150

	unlocks_designs = list("micro_mani", "basic_matter_bin", "basic_micro_laser", "console_screen")

/datum/technology/engineering/monitoring
	name = "Monitoring"
	desc = "Monitoring"
	id = "monitoring"

	x = 4.5
	y = 5
	//special way to generate an icon

	required_technologies = list("basic_engineering")
	cost = 500

	unlocks_designs = list("atmosalerts", "air_management")

/datum/technology/engineering/monitoring/generate_icon()
	var/icon/ret = icon('icons/obj/computer.dmi', "computer")
	ret.Blend(icon('icons/obj/computer.dmi', "alert:0"), ICON_OVERLAY)
	ret.Blend(icon('icons/obj/computer.dmi', "atmos_key"), ICON_OVERLAY)
	return ret

/datum/technology/engineering/gas_heat
	name = "Gas Heating and Cooling"
	desc = "Gas Heating and Cooling"
	id = "gas_heat"

	x = 4.5
	y = 3.5
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-heat"

	required_technologies = list("monitoring")
	cost = 500

	unlocks_designs = list("gasheater", "gascooler", "stasis_clamp")

/datum/technology/engineering/flamethrower
	name = "PFM-100 Industrial Torch"
	desc = "Hans... Get ze flammenwerfer!"
	id = "flamethrower"

	x = 4.5
	y = 2
	icon = 'icons/obj/ammo.dmi'
	icon_state = "hydecanister_e"

	required_technologies = list("gas_heat", "divet")
	cost = 1500

	unlocks_designs = list("flamethrower")

/datum/technology/engineering/res_tech
	name = "Research Technologies"
	desc = "Make sure sec won't find your illegal researches!"
	id = "res_tech"

	x = 7
	y = 5
	//special way to generate an icon

	required_technologies = list("monitoring")
	cost = 750

	unlocks_designs = list("destructive_analyzer", "protolathe", "circuit_imprinter", "rdservercontrol", "rdserver", "rdconsole")

/datum/technology/engineering/res_tech/generate_icon()
	var/icon/ret = icon('icons/obj/computer.dmi', "computer")
	ret.Blend(icon('icons/obj/computer.dmi', "rdcomp"), ICON_OVERLAY)
	ret.Blend(icon('icons/obj/computer.dmi', "rd_key"), ICON_OVERLAY)
	return ret

/datum/technology/engineering/xenoarch
	name = "Xenoarcheology"
	desc = "Xenoarcheology"
	id = "xenoarch"

	x = 7
	y = 3.5
	icon = 'icons/obj/pda.dmi'
	icon_state = "crap"

	required_technologies = list("res_tech")
	cost = 500

	unlocks_designs = list("depth_scanner", "ano_scanner")

/datum/technology/engineering/excavation_drill
	name = "Excavation Drill"
	desc = "Excavation Drill"
	id = "excavation_drill"

	x = 13.5
	y = 3.5
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "excavationdrill7"

	required_technologies = list("xenoarch")
	cost = 1000

	unlocks_designs = list("excavation_drill")

/datum/technology/engineering/excavation_drill_diamond
	name = "Diamond Excavation Drill"
	desc = "Diamond Excavation Drill"
	id = "excavation_drill_diamond"

	x = 13.5
	y = 2
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "Dexcavationdrill7"

	required_technologies = list("excavation_drill")
	cost = 1500

	unlocks_designs = list("excavation_drill_diamond")

/datum/technology/engineering/basic_mining
	name = "Basic Mining"
	desc = "Basic Mining"
	id = "basic_mining"

	x = 7
	y = 6.5
	icon = 'icons/obj/weapons.dmi'
	icon_state = "ds_rocksaw1"

	required_technologies = list("res_tech")
	cost = 1000

	unlocks_designs = list("miningcutter", "rock_saw", "plasma_energy")

/*
Add ore smelting machines here. They should be connected to consoles so I decided to left this tech undone
/datum/technology/engineering/ore_proc
	name = "Ore Processing"
	desc = "Ore Processing"
	id = "ore_proc"

	x = 3
	y = 3
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"

	required_technologies = list("basic_mining")
	cost = 1000

	unlocks_designs = list()
*/

/datum/technology/engineering/advanced_mining
	name = "Advanced Mining"
	desc = "Advanced Mining"
	id = "adv_mining"

	x = 13.5
	y = 6.5
	icon = 'icons/obj/tools.dmi'
	icon_state = "plasmacutter"

	required_technologies = list("basic_mining", "recharger")
	cost = 2000

	unlocks_designs = list("mining drill head", "mining drill brace", "linecutter", "contactbeam", "forcegun")

/datum/technology/engineering/mining_ammo
	name = "Mining Ammuntion"
	desc = "Mining Ammuntion"
	id = "mining_ammo"

	x = 13.5
	y = 8
	icon = 'icons/obj/ammo.dmi'
	icon_state = "contact_energy"

	required_technologies = list("adv_mining")
	cost = 1250

	unlocks_designs = list("line_rack", "contact_energy", "force_energy")

/datum/technology/engineering/adv_mining
	name = "Advanced Engineering"
	desc = "Advanced Engineering"
	id = "adv_eng"

	x = 15.5
	y = 5
	icon = 'icons/obj/storage.dmi'
	icon_state = "RPED"

	required_technologies = list("adv_mining", "excavation_drill")
	cost = 2000

	unlocks_designs = list("rped", "mesons", "mesons_material", "nanopaste", "rivet_bolts")

/datum/technology/engineering/adv_parts
	name = "Advanced Parts"
	desc = "Advanced Parts"
	id = "adv_parts"

	x = 13.5
	y = 5
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "advanced_matter_bin"

	required_technologies = list("adv_eng")
	cost = 1000

	unlocks_designs = list("nano_mani", "adv_matter_bin", "high_micro_laser", "adv_sensor")

/datum/technology/engineering/super_parts
	name = "Super Parts"
	desc = "Super Parts"
	id = "super_parts"

	x = 11.5
	y = 5
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "super_matter_bin"

	required_technologies = list("adv_parts")
	cost = 2000

	unlocks_designs = list("pico_mani", "super_matter_bin", "ultra_micro_laser", "phasic_sensor")

/datum/technology/engineering/adv_tools
	name = "Advanced Tools"
	desc = "Advanced Tools"
	id = "adv_tools"

	x = 17.5
	y = 5
	icon = 'icons/obj/tools.dmi'
	icon_state = "pneumo_crowbar"

	required_technologies = list("adv_eng")
	cost = 2000

	unlocks_designs = list("plasma_saw", "pneum_crow", "combi_driver", "experimental_welder", "price_scanner")

/datum/technology/engineering/airlock_brace
	name = "Airlock Brace"
	desc = "Airlock Brace"
	id = "airlock_brace"

	x = 9
	y = 5
	icon = 'icons/obj/tools.dmi'
	icon_state = "maintenance_jack"

	required_technologies = list("res_tech")
	cost = 500

	unlocks_designs = list("brace", "bracejack")

/datum/technology/engineering/icprinter
	name = "Integrated Circuit Printer"
	desc = "Integrated Circuit Printer"
	id = "icprinter"

	x = 15.5
	y = 8
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "circuit_printer"

	required_technologies = list("adv_eng")
	cost = 750

	unlocks_designs = list("icprinter")

/datum/technology/engineering/icupgradv
	name = "Integrated Circuit Printer Upgrade Disk"
	desc = "Integrated Circuit Printer Upgrade Disk"
	id = "icupgradv"

	x = 15.5
	y = 9.5
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "upgrade_disk"

	required_technologies = list("icprinter")
	cost = 1500

	unlocks_designs = list("icupgradv")

/datum/technology/engineering/icupclo
	name = "Integrated Circuit Printer Clone Disk"
	desc = "Integrated Circuit Printer Clone Disk"
	id = "icupclo"

	x = 17
	y = 8
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "upgrade_disk_clone"

	required_technologies = list("icprinter")
	cost = 1000

	unlocks_designs = list("icupclo")

/datum/technology/engineering/node
	name = "Power Node"
	desc = "Power Node"
	id = "node"

	x = 20.5
	y = 5
	icon = 'icons/obj/tools.dmi'
	no_lines = TRUE
	icon_state = "powernode"

	required_technologies = list("adv_tools", "adv_power_storage", "hyp_power")
	cost = 4000

	unlocks_designs = list("powernode")
