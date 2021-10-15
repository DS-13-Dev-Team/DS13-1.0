/datum/technology/engineering
	name = "Basic Engineering"
	desc = "Basic"
	id = "basic_engineering"
	tech_type = TECH_ENGINEERING

	x = 0.1
	y = 0.5
	icon = "wrench"

	required_technologies = list()
	cost = 0

	unlocks_designs = list("micro_mani", "basic_matter_bin", "basic_micro_laser", "light_replacer", "weldingmask", "autolathe", "arcademachine", "oriontrail", "boombox")

/datum/technology/engineering/gas_heat
	name = "Gas Heating and Cooling"
	desc = "Gas Heating and Cooling"
	id = "gas_heat"

	x = 0.2
	y = 0.6
	icon = "spaceheater"

	required_technologies = list("monitoring")
	cost = 500

	unlocks_designs = list("gasheater", "gascooler", "stasis_clamp")

/datum/technology/engineering/flamethrower
	name = "PFM-100 Industrial Torch"
	desc = "PFM-100 Industrial Torch"
	id = "flamethrower"

	x = 0.2
	y = 0.7
	icon = "flamethrower"

	required_technologies = list("gas_heat", "divet")
	cost = 1500

	unlocks_designs = list("flamethrower")

/datum/technology/engineering/adv_parts
	name = "Advanced Parts"
	desc = "Advanced Parts"
	id = "adv_parts"

	x = 0.6
	y = 0.5
	icon = "advmatterbin"

	required_technologies = list("adv_eng")
	cost = 1000

	unlocks_designs = list("nano_mani", "adv_matter_bin", "high_micro_laser", "adv_sensor")

/datum/technology/engineering/super_parts
	name = "Super Parts"
	desc = "Super Parts"
	id = "super_parts"

	x = 0.5
	y = 0.5
	icon = "supermatterbin"

	required_technologies = list("adv_parts")
	cost = 2000

	unlocks_designs = list("pico_mani", "super_matter_bin", "ultra_micro_laser", "phasic_sensor")

/datum/technology/engineering/monitoring
	name = "Monitoring"
	desc = "Monitoring"
	id = "monitoring"

	x = 0.2
	y = 0.5
	icon = "monitoring"

	required_technologies = list("basic_engineering")
	cost = 500

	unlocks_designs = list("atmosalerts", "air_management")

/datum/technology/engineering/res_tech
	name = "Research Technologies"
	desc = "Research Technologies"
	id = "res_tech"

	x = 0.3
	y = 0.5
	icon = "rd"

	required_technologies = list("monitoring")
	cost = 750

	unlocks_designs = list("destructive_analyzer", "protolathe", "circuit_imprinter", "rdservercontrol", "rdserver", "rdconsole")

/datum/technology/engineering/xenoarch
	name = "Xenoarcheology"
	desc = "Xenoarcheology"
	id = "xenoarch"

	x = 0.3
	y = 0.6
	icon = "anom"

	required_technologies = list("res_tech")
	cost = 500

	unlocks_designs = list("depth_scanner", "ano_scanner")

/datum/technology/engineering/excavation_drill
	name = "Excavation Drill"
	desc = "Excavation Drill"
	id = "excavation_drill"

	x = 0.6
	y = 0.6
	icon = "drill"

	required_technologies = list("xenoarch")
	cost = 1000

	unlocks_designs = list("excavation_drill")

/datum/technology/engineering/excavation_drill_diamond
	name = "Diamond Excavation Drill"
	desc = "Diamond Excavation Drill"
	id = "excavation_drill_diamond"

	x = 0.6
	y = 0.7
	icon = "diamond_drill"

	required_technologies = list("excavation_drill")
	cost = 1500

	unlocks_designs = list("excavation_drill_diamond")

/datum/technology/engineering/basic_mining
	name = "Basic Mining"
	desc = "Basic Mining"
	id = "basic_mining"

	x = 0.3
	y = 0.4
	icon = "pickaxe"

	required_technologies = list("res_tech")
	cost = 1000

	unlocks_designs = list("miningcutter", "Rock Saw", "plasma_energy")

/*/datum/technology/engineering/ore_proc
	name = "Ore Processing"
	desc = "Ore Processing"
	id = "ore_proc"

	x = 0.3
	y = 0.3
	icon = "furnace"

	required_technologies = list("basic_mining")
	cost = 1000

	unlocks_designs = list()	Add ore smelting machines here. They should be connected to consoles so I decided to left this tech undone*/

/datum/technology/engineering/advanced_mining
	name = "Advanced Mining"
	desc = "Advanced Mining"
	id = "adv_mining"

	x = 0.6
	y = 0.4
	icon = "cutter"

	required_technologies = list("basic_mining", "recharger")
	cost = 2000

	unlocks_designs = list("mining drill head", "mining drill brace", "plasmacutter", "linecutter", "contactbeam", "forcegun")

/datum/technology/engineering/mining_ammo
	name = "Mining Ammuntion"
	desc = "Mining Ammuntion"
	id = "mining_ammo"

	x = 0.6
	y = 0.3
	icon = "contact"

	required_technologies = list("adv_mining")
	cost = 1250

	unlocks_designs = list("line_rack", "contact_energy", "force_energy")

/datum/technology/engineering/adv_mining
	name = "Advanced Engineering"
	desc = "Advanced Engineering"
	id = "adv_eng"

	x = 0.7
	y = 0.5
	icon = "rped"

	required_technologies = list("adv_mining", "excavation_drill")
	cost = 2000

	unlocks_designs = list("rped", "mesons", "mesons_material", "nanopaste", "rivet_bolts")

/datum/technology/engineering/adv_tools
	name = "Advanced Tools"
	desc = "Advanced Tools"
	id = "adv_tools"

	x = 0.8
	y = 0.5
	icon = "jawsoflife"

	required_technologies = list("adv_eng")
	cost = 2000

	unlocks_designs = list("SH-B1 Plasma Saw", "pneum_crow", "combi_driver", "experimental_welder", "price_scanner")

/datum/technology/engineering/airlock_brace
	name = "Airlock Brace"
	desc = "Airlock Brace"
	id = "airlock_brace"

	x = 0.4
	y = 0.5
	icon = "brace"

	required_technologies = list("res_tech")
	cost = 500

	unlocks_designs = list("brace", "bracejack")

/datum/technology/engineering/icprinter
	name = "Integrated Circuit Printer"
	desc = "Integrated Circuit Printer"
	id = "icprinter"

	x = 0.7
	y = 0.3
	icon = "icprinter"

	required_technologies = list("adv_eng")
	cost = 750

	unlocks_designs = list("icprinter")

/datum/technology/engineering/icupgradv
	name = "Integrated Circuit Printer Upgrade Disk"
	desc = "Integrated Circuit Printer Upgrade Disk"
	id = "icupgradv"

	x = 0.7
	y = 0.2
	icon = "icupgradv"

	required_technologies = list("icprinter")
	cost = 1500

	unlocks_designs = list("icupgradv")

/datum/technology/engineering/icupclo
	name = "Integrated Circuit Printer Clone Disk"
	desc = "Integrated Circuit Printer Clone Disk"
	id = "icupclo"

	x = 0.8
	y = 0.3
	icon = "icupclo"

	required_technologies = list("icprinter")
	cost = 1000

	unlocks_designs = list("icupclo")

/datum/technology/engineering/node
	name = "Power Node"
	desc = "Power Node"
	id = "node"

	x = 0.9
	y = 0.5
	no_lines = TRUE
	icon = "power_node"

	required_technologies = list("adv_tools", "adv_power_storage", "hyp_power")
	cost = 4000

	unlocks_designs = list("powernode")
