/datum/technology
	var/name = "name"
	var/desc = "description"				// Not used because lazy
	var/id = "id"							// should be unique
	var/tech_type							// Which tech tree does this techology belongs to

	var/x = 0.5								// Position on the tech tree map, 0 - left, 1 - right
	var/y = 0.5								// 0 - down, 1 - top
	var/icon = "gun"						// css class of techology icon, defined in shared.css

	var/list/required_technologies = list()	// Ids of techologies that are required to be unlocked before this one. Should have same tech_type
	var/list/required_tech_levels = list()	// list("biotech" = 5, ...) Ids and required levels of tech
	var/cost = 100							// How much research points required to unlock this techology

	var/list/unlocks_designs = list()		// Ids of designs that this technology unlocks

// Engineering

/datum/technology/basic_engineering
	name = "Basic Engineering"
	desc = "Basic"
	id = "basic_engineering"
	tech_type = TECH_ENGINEERING

	x = 0.1
	y = 0.4
	icon = "wrench"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

/datum/technology/monitoring
	name = "Monitoring"
	desc = "Monitoring"
	id = "monitoring"
	tech_type = TECH_ENGINEERING

	x = 0.2
	y = 0.4
	icon = "monitoring"

	required_technologies = list("basic_engineering")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/adv_engineering
	name = "Advanced Engineering"
	desc = "Advanced Engineering"
	id = "adv_engineering"
	tech_type = TECH_ENGINEERING

	x = 0.3
	y = 0.4
	icon = "rd"

	required_technologies = list("monitoring")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/tesla
	name = "Tesla"
	desc = "Tesla"
	id = "tesla"
	tech_type = TECH_ENGINEERING

	x = 0.3
	y = 0.2
	icon = "tesla"

	required_technologies = list("adv_engineering")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/supplyanddemand
	name = "Supply And Demand"
	desc = "Supply And Demand"
	id = "supply_and_demand"
	tech_type = TECH_ENGINEERING

	x = 0.4
	y = 0.4
	icon = "advmop"

	required_technologies = list("adv_engineering")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/basic_mining
	name = "Basic Mining"
	desc = "Basic Mining"
	id = "basic_mining"
	tech_type = TECH_ENGINEERING

	x = 0.5
	y = 0.4
	icon = "drill"

	required_technologies = list("supply_and_demand")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/advanced_mining
	name = "Advanced Mining"
	desc = "Advanced Mining"
	id = "advanced_mining"
	tech_type = TECH_ENGINEERING

	x = 0.6
	y = 0.4
	icon = "jackhammer"

	required_technologies = list("basic_mining")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/basic_handheld
	name = "Basic Handheld"
	desc = "Basic Handheld"
	id = "basic_handheld"
	tech_type = TECH_ENGINEERING

	x = 0.3
	y = 0.6
	icon = "pda"

	required_technologies = list("adv_engineering")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/adv_handheld
	name = "Advanced Handheld"
	desc = "Advanced Handheld"
	id = "adv_handheld"
	tech_type = TECH_ENGINEERING

	x = 0.6
	y = 0.6
	icon = "goldpda"

	required_technologies = list("basic_handheld")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/adv_parts
	name = "Advanced Parts"
	desc = "Advanced Parts"
	id = "adv_parts"
	tech_type = TECH_ENGINEERING

	x = 0.1
	y = 0.5
	icon = "advmatterbin"

	required_technologies = list()
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list("adv_capacitor", "nano_mani", "adv_matter_bin", "high_micro_laser", "adv_sensor")

/datum/technology/super_parts
	name = "Super Parts"
	desc = "Super Parts"
	id = "super_parts"
	tech_type = TECH_ENGINEERING

	x = 0.2
	y = 0.5
	icon = "supermatterbin"

	required_technologies = list("adv_parts")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/ultra_parts
	name = "Ultra Parts"
	desc = "Ultra Parts"
	id = "ultra_parts"
	tech_type = TECH_ENGINEERING

	x = 0.3
	y = 0.5
	icon = "bluespacematterbin"

	required_technologies = list("super_parts")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/telescience
	name = "Telescience"
	desc = "telescience"
	id = "telescience"
	tech_type = TECH_ENGINEERING

	x = 0.8
	y = 0.3
	icon = "telescience"

	required_technologies = list()
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list()

/datum/technology/super_adv_engineering
	name = "Super Advanced Engineering"
	desc = "Super Advanced Engineering"
	id = "super_adv_engineering"
	tech_type = TECH_ENGINEERING

	x = 0.8
	y = 0.7
	icon = "rped"

	required_technologies = list()
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list()

/datum/technology/adv_tools
	name = "Advanced Tools"
	desc = "Advanced Tools"
	id = "adv_tools"
	tech_type = TECH_ENGINEERING

	x = 0.8
	y = 0.9
	icon = "jawsoflife"

	required_technologies = list("super_adv_engineering")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

// Biotech

/datum/technology/basic_biotech
	name = "Basic Biotech"
	desc = "Basic Biotech"
	id = "basic_biotech"
	tech_type = TECH_BIO

	x = 0.1
	y = 0.8
	icon = "healthanalyzer"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

/datum/technology/basic_med_machines
	name = "Basic Medical Machines"
	desc = "Basic Medical Machines"
	id = "basic_med_machines"
	tech_type = TECH_BIO

	x = 0.25
	y = 0.8
	icon = "operationcomputer"

	required_technologies = list("basic_biotech")
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list()

/datum/technology/virology
	name = "Virology"
	desc = "Virology"
	id = "virology"
	tech_type = TECH_BIO

	x = 0.4
	y = 0.8
	icon = "vialbox"

	required_technologies = list("basic_med_machines")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/adv_med_machines
	name = "Advanced Medical Machines"
	desc = "Advanced Medical Machines"
	id = "adv_med_machines"
	tech_type = TECH_BIO

	x = 0.25
	y = 0.6
	icon = "sleeper"

	required_technologies = list("basic_med_machines")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/cloning
	name = "Cloning"
	desc = "Cloning"
	id = "cloning"
	tech_type = TECH_BIO

	x = 0.25
	y = 0.4
	icon = "cloning"

	required_technologies = list("adv_med_machines")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/hydroponics
	name = "Hydroponics"
	desc = "Hydroponics"
	id = "hydroponics"
	tech_type = TECH_BIO

	x = 0.1
	y = 0.6
	icon = "hydroponics"

	required_technologies = list("basic_biotech")
	required_tech_levels = list()
	cost = 400

	unlocks_designs = list()

/datum/technology/basic_food_processing
	name = "Basic Food Processing"
	desc = "Basic Food Processing"
	id = "basic_food_processing"
	tech_type = TECH_BIO

	x = 0.1
	y = 0.4
	icon = "microwave"

	required_technologies = list("hydroponics")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/adv_food_processing
	name = "Advanced Food Processing"
	desc = "Advanced Food Processing"
	id = "adv_food_processing"
	tech_type = TECH_BIO

	x = 0.1
	y = 0.2
	icon = "candymachine"

	required_technologies = list("basic_food_processing")
	required_tech_levels = list()
	cost = 600

	unlocks_designs = list()

/datum/technology/basic_medical_tools
	name = "Basic Medical Tools"
	desc = "Basic Medical Tools"
	id = "basic_medical_tools"
	tech_type = TECH_BIO

	x = 0.4
	y = 0.6
	icon = "medhud"

	required_technologies = list("adv_med_machines")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/improved_biotech
	name = "Improved Biotech"
	desc = "Improved Biotech"
	id = "improved_biotech"
	tech_type = TECH_BIO

	x = 0.55
	y = 0.6
	icon = "handheldmonitor"

	required_technologies = list("basic_medical_tools")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/med_teleportation
	name = "Medical Teleportation"
	desc = "Medical Teleportation"
	id = "med_teleportation"
	tech_type = TECH_BIO

	x = 0.7
	y = 0.5
	icon = "medbeacon"

	required_technologies = list("improved_biotech")
	required_tech_levels = list()
	cost = 1200

	unlocks_designs = list()

/datum/technology/advanced_biotech
	name = "Advanced Biotech"
	desc = "Advanced Biotech"
	id = "advanced_biotech"
	tech_type = TECH_BIO

	x = 0.7
	y = 0.7
	icon = "rapidsyringegun"

	required_technologies = list("improved_biotech")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/portable_chemistry
	name = "Portable Chemistry"
	desc = "Portable Chemistry"
	id = "portable_chemistry"
	tech_type = TECH_BIO

	x = 0.7
	y = 0.9
	icon = "chemdisp"

	required_technologies = list("advanced_biotech")
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list()

/datum/technology/top_biotech
	name = "Top-tier Biotech"
	desc = "Top-tier Biotech"
	id = "top_biotech"
	tech_type = TECH_BIO

	x = 0.85
	y = 0.7
	icon = "scalpelmanager"

	required_technologies = list("advanced_biotech")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

// Combat

/datum/technology/basic_combat
	name = "Basic Combat Systems"
	desc = "Basic Combat Systems"
	id = "basic_combat"
	tech_type = TECH_COMBAT

	x = 0.1
	y = 0.5
	icon = "stunbaton"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

/datum/technology/basic_nonlethal
	name = "Basic Non-Lethal"
	desc = "Basic Non-Lethal"
	id = "basic_nonlethal"
	tech_type = TECH_COMBAT

	x = 0.3
	y = 0.5
	icon = "flash"

	required_technologies = list("basic_combat")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/advanced_nonlethal
	name = "Advanced Non-Lethal"
	desc = "Advanced Non-Lethal"
	id = "advanced_nonlethal"
	tech_type = TECH_COMBAT

	x = 0.3
	y = 0.3
	icon = "stunrevolver"

	required_technologies = list("basic_nonlethal")
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list()

/datum/technology/weapon_recharging
	name = "Weapon Recharging"
	desc = "Weapon Recharging"
	id = "weapon_recharging"
	tech_type = TECH_COMBAT

	x = 0.5
	y = 0.5
	icon = "recharger"

	required_technologies = list("basic_nonlethal")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/sec_computers
	name = "Security Computers"
	desc = "Security Computers"
	id = "sec_computers"
	tech_type = TECH_COMBAT

	x = 0.1
	y = 0.7
	icon = "seccomputer"

	required_technologies = list("basic_combat")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/basic_lethal
	name = "Basic Lethal Weapons"
	desc = "Basic Lethal Weapons"
	id = "basic_lethal"
	tech_type = TECH_COMBAT

	x = 0.7
	y = 0.5
	icon = "ammobox"

	required_technologies = list("weapon_recharging")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/exotic_weaponry
	name = "Exotic Weaponry"
	desc = "Exotic Weaponry"
	id = "exotic_weaponry"
	tech_type = TECH_COMBAT

	x = 0.7
	y = 0.3
	icon = "tempgun"

	required_technologies = list("basic_lethal")
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list()

/datum/technology/adv_exotic_weaponry
	name = "Advanced Exotic Weaponry"
	desc = "Advanced Exotic Weaponry"
	id = "adv_exotic_weaponry"
	tech_type = TECH_COMBAT

	x = 0.9
	y = 0.3
	icon = "teslagun"

	required_technologies = list("exotic_weaponry")
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list()

/datum/technology/adv_lethal
	name = "Advanced Lethal Weapons"
	desc = "Advanced Lethal Weapons"
	id = "adv_lethal"
	tech_type = TECH_COMBAT

	x = 0.7
	y = 0.7
	icon = "submachinegun"

	required_technologies = list("basic_lethal")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/laser_weaponry
	name = "Laser Weaponry"
	desc = "Laser Weaponry"
	id = "laser_weaponry"
	tech_type = TECH_COMBAT

	x = 0.9
	y = 0.7
	icon = "gun"

	required_technologies = list("adv_lethal", "adv_exotic_weaponry")
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list()

// Powerstorage

/datum/technology/basic_power
	name = "Basic Power"
	desc = "Basic Power"
	id = "basic_power"
	tech_type = TECH_POWER

	x = 0.5
	y = 0.8
	icon = "cell"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

/datum/technology/advanced_power
	name = "Advanced Power"
	desc = "Advanced Power"
	id = "advanced_power"
	tech_type = TECH_POWER

	x = 0.5
	y = 0.6
	icon = "supercell"

	required_technologies = list("basic_power")
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list()

/datum/technology/improved_power_generation
	name = "Improved Power Generation"
	desc = "Improved Power Generation"
	id = "improved_power_generation"
	tech_type = TECH_POWER

	x = 0.3
	y = 0.6
	icon = "generator"

	required_technologies = list("advanced_power")
	required_tech_levels = list()
	cost = 400

	unlocks_designs = list()

/datum/technology/advanced_power_storage
	name = "Advanced Power Storage"
	desc = "Advanced Power Storage"
	id = "advanced_power_storage"
	tech_type = TECH_POWER

	x = 0.1
	y = 0.6
	icon = "smes"

	required_technologies = list("improved_power_generation")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/solar_power
	name = "Solar Power"
	desc = "Solar Power"
	id = "solar_power"
	tech_type = TECH_POWER

	x = 0.7
	y = 0.6
	icon = "solarcontrol"

	required_technologies = list("advanced_power")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/super_power
	name = "Super Power"
	desc = "Super Power"
	id = "super_power"
	tech_type = TECH_POWER

	x = 0.5
	y = 0.4
	icon = "hypercell"

	required_technologies = list("advanced_power")
	required_tech_levels = list()
	cost = 1200

	unlocks_designs = list()

/datum/technology/advanced_power_generation
	name = "Advanced Power Generation"
	desc = "Advanced Power Generation"
	id = "advanced_power_generation"
	tech_type = TECH_POWER

	x = 0.3
	y = 0.4
	icon = "supergenerator"

	required_technologies = list("super_power", "improved_power_generation")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/fusion_power_generation
	name = "R-UST Mk. 8 Tokamak Generator"
	desc = "R-UST Mk. 8 Tokamak Generator"
	id = "fusion_power_generation"
	tech_type = TECH_POWER

	x = 0.1
	y = 0.4
	icon = "fusion"

	required_technologies = list("advanced_power_generation")
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list()

/datum/technology/bluespace_power
	name = "Bluespace Power"
	desc = "Bluespace Power"
	id = "bluespace_power"
	tech_type = TECH_POWER

	x = 0.5
	y = 0.2
	icon = "bluespacecell"

	required_technologies = list("super_power")
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list()

// Bluespace

/datum/technology/basic_bluespace
	name = "Basic 'Blue-space'"
	desc = "Basic 'Blue-space'"
	id = "basic_bluespace"
	tech_type = TECH_BLUESPACE

	x = 0.2
	y = 0.2
	icon = "gps"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

/datum/technology/radio_transmission
	name = "Radio Transmission"
	desc = "Radio Transmission"
	id = "radio_transmission"
	tech_type = TECH_BLUESPACE

	x = 0.2
	y = 0.4
	icon = "headset"

	required_technologies = list("basic_bluespace")
	required_tech_levels = list()
	cost = 200

	unlocks_designs = list()

/datum/technology/telecommunications
	name = "Telecommunications"
	desc = "Telecommunications"
	id = "telecommunications"
	tech_type = TECH_BLUESPACE

	x = 0.2
	y = 0.6
	icon = "communications"

	required_technologies = list("radio_transmission")
	required_tech_levels = list()
	cost = 600

	unlocks_designs = list()

/datum/technology/bluespace_telecommunications
	name = "Bluespace Telecommunications"
	desc = "Bluespace Telecommunications"
	id = "bluespace_telecommunications"
	tech_type = TECH_BLUESPACE

	x = 0.4
	y = 0.6
	icon = "bluespacething"

	required_technologies = list("telecommunications")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/bluespace_shield
	name = "Bluespace Shields"
	desc = "Bluespace Shields"
	id = "bluespace_shield"
	tech_type = TECH_BLUESPACE

	x = 0.4
	y = 0.4
	icon = "shield"

	required_technologies = list("bluespace_telecommunications")
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list()

/datum/technology/transmission_encryption
	name = "Transmission Encryption"
	desc = "Transmission Encryption"
	id = "transmission_encryption"
	tech_type = TECH_BLUESPACE

	x = 0.2
	y = 0.8
	icon = "radiogrid"

	required_technologies = list("telecommunications")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/teleportation
	name = "Teleportation"
	desc = "Teleportation"
	id = "teleportation"
	tech_type = TECH_BLUESPACE

	x = 0.6
	y = 0.6
	icon = "teleporter"

	required_technologies = list("bluespace_telecommunications")
	required_tech_levels = list()
	cost = 1500

	unlocks_designs = list()

/*/datum/technology/bluespace_tools
	name = "Bluespace Tools"
	desc = "Bluespace Tools"
	id = "bluespace_tools"
	tech_type = TECH_BLUESPACE

	x = 0.8
	y = 0.8
	icon = "bagofholding"

	required_technologies = list("teleportation")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()*/

/datum/technology/bluespace_rped
	name = "Bluespace RPED"
	desc = "Bluespace RPED"
	id = "bluespace_rped"
	tech_type = TECH_BLUESPACE

	x = 0.8
	y = 0.4
	icon = "bluespacerped"

	required_technologies = list("teleportation")
	required_tech_levels = list()
	cost = 3000

	unlocks_designs = list()

// Robotics

/datum/technology/basic_robotics
	name = "Basic Robotics"
	desc = "Basic Robotics"
	id = "basic_robotics"
	tech_type = TECH_ROBOT

	x = 0.5
	y = 0.2
	icon = "cyborganalyzer"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()

/datum/technology/mech_ripley
	name = "Ripley"
	desc = "Ripley"
	id = "mech_ripley"
	tech_type = TECH_ROBOT

	x = 0.4
	y = 0.3
	icon = "ripley"

	required_technologies = list("basic_robotics")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/mech_odysseus
	name = "Odyssey"
	desc = "Odyssey"
	id = "mech_odysseus"
	tech_type = TECH_ROBOT

	x = 0.6
	y = 0.3
	icon = "odyssey"

	required_technologies = list("basic_robotics")
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/advanced_robotics
	name = "Advanced Robotics"
	desc = "Advanced Robotics"
	id = "advanced_robotics"
	tech_type = TECH_ROBOT

	x = 0.5
	y = 0.5
	icon = "posbrain"

	required_technologies = list("mech_odysseus", "mech_ripley")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/artificial_intelligence
	name = "Artificial intelligence"
	desc = "Artificial intelligence"
	id = "artificial_intelligence"
	tech_type = TECH_ROBOT

	x = 0.5
	y = 0.65
	icon = "aicard"

	required_technologies = list("advanced_robotics")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/mech_gyrax
	name = "Gygax"
	desc = "Gygax"
	id = "mech_gyrax"
	tech_type = TECH_ROBOT

	x = 0.4
	y = 0.7
	icon = "gygax"

	required_technologies = list("advanced_robotics")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/mech_gyrax_ultra
	name = "Gygax Ultra"
	desc = "Gygax Ultra"
	id = "mech_gyrax_ultra"
	tech_type = TECH_ROBOT

	x = 0.4
	y = 0.9
	icon = "gygaxultra"

	required_technologies = list("mech_gyrax")
	required_tech_levels = list()
	cost = 4000

	unlocks_designs = list()

/datum/technology/mech_durand
	name = "Durand"
	desc = "Durand"
	id = "mech_durand"
	tech_type = TECH_ROBOT

	x = 0.6
	y = 0.7
	icon = "durand"

	required_technologies = list("advanced_robotics")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/mech_vindicator
	name = "Vindicator"
	desc = "Vindicator"
	id = "mech_vindicator"
	tech_type = TECH_ROBOT

	x = 0.6
	y = 0.9
	icon = "vindicator"

	required_technologies = list("mech_durand")
	required_tech_levels = list()
	cost = 4000

	unlocks_designs = list()

/datum/technology/mech_utility_modules
	name = "Exosuit Utility Modules"
	desc = "Exosuit Utility Modules"
	id = "mech_utility_modules"
	tech_type = TECH_ROBOT

	x = 0.25
	y = 0.5
	icon = "mechrcd"

	required_technologies = list("advanced_robotics")
	required_tech_levels = list()
	cost = 1000

	unlocks_designs = list()

/datum/technology/mech_teleporter_modules
	name = "Exosuit Teleporter Module"
	desc = "Exosuit Teleporter Module"
	id = "mech_teleporter_modules"
	tech_type = TECH_ROBOT

	x = 0.1
	y = 0.5
	icon = "mechteleporter"

	required_technologies = list("mech_utility_modules")
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list()

/datum/technology/mech_armor_modules
	name = "Exosuit Armor Modules"
	desc = "Exosuit Armor Modules"
	id = "mech_armor_modules"
	tech_type = TECH_ROBOT

	x = 0.25
	y = 0.8
	icon = "mecharmor"

	required_technologies = list("mech_utility_modules")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/mech_weaponry_modules
	name = "Exosuit Weaponry"
	desc = "Exosuit Weaponry"
	id = "mech_weaponry_modules"
	tech_type = TECH_ROBOT

	x = 0.75
	y = 0.5
	icon = "mechgrenadelauncher"

	required_technologies = list("advanced_robotics")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/mech_heavy_weaponry_modules
	name = "Exosuit Heavy Weaponry"
	desc = "Exosuit Heavy Weaponry"
	id = "mech_heavy_weaponry_modules"
	tech_type = TECH_ROBOT

	x = 0.75
	y = 0.8
	icon = "mechlaser"

	required_technologies = list("mech_weaponry_modules")
	required_tech_levels = list()
	cost = 4000

	unlocks_designs = list()

/datum/technology/basic_hardsuit_modules
	name = "Basic Hardsuit Modules"
	desc = "Basic Hardsuit Modules"
	id = "basic_hardsuit_modules"
	tech_type = TECH_ROBOT

	x = 0.35
	y = 0.1
	icon = "rigscanner"

	required_technologies = list()
	required_tech_levels = list()
	cost = 500

	unlocks_designs = list()

/datum/technology/advanced_hardsuit_modules
	name = "Advanced Hardsuit Modules"
	desc = "Basic Hardsuit Modules"
	id = "advanced_hardsuit_modules"
	tech_type = TECH_ROBOT

	x = 0.5
	y = 0.1
	icon = "rigtaser"

	required_technologies = list("basic_hardsuit_modules")
	required_tech_levels = list()
	cost = 2000

	unlocks_designs = list()

/datum/technology/toptier_hardsuit_modules
	name = "Top-Tier Hardsuit Modules"
	desc = "Top-Tier Hardsuit Modules"
	id = "toptier_hardsuit_modules"
	tech_type = TECH_ROBOT

	x = 0.65
	y = 0.1
	icon = "rignuclearreactor"

	required_technologies = list("advanced_hardsuit_modules")
	required_tech_levels = list()
	cost = 5000

	unlocks_designs = list()

// Illegal

/datum/technology/binary_encryption_key
	name = "Binary Encrpytion Key"
	desc = "Binary Encrpytion Key"
	id = "binary_encryption_key"
	tech_type = TECH_ILLEGAL

	x = 0.1
	y = 0.5
	icon = "headset"

	required_technologies = list()
	required_tech_levels = list(TECH_BLUESPACE = 5)
	cost = 2000

	unlocks_designs = list()

/datum/technology/chameleon_kit
	name = "Chameleon Kit"
	desc = "Chameleon Kit"
	id = "chameleon_kit"
	tech_type = TECH_ILLEGAL

	x = 0.3
	y = 0.5
	icon = "chamelion"

	required_technologies = list("binary_encryption_key")
	required_tech_levels = list(TECH_ENGINEERING = 10)
	cost = 3000

	unlocks_designs = list()

/datum/technology/freedom_implant
	name = "Glass Case- 'Freedom'"
	desc = "Glass Case- 'Freedom'"
	id = "freedom_implant"
	tech_type = TECH_ILLEGAL

	x = 0.5
	y = 0.5
	icon = "freedom"

	required_technologies = list("chameleon_kit")
	required_tech_levels = list(TECH_BIO = 5)
	cost = 3000

	unlocks_designs = list()

/datum/technology/tyrant_aimodule
	name = "AI Core Module (T.Y.R.A.N.T.)"
	desc = "AI Core Module (T.Y.R.A.N.T.)"
	id = "tyrant_aimodule"
	tech_type = TECH_ILLEGAL

	x = 0.7
	y = 0.5
	icon = "module"

	required_technologies = list("freedom_implant")
	required_tech_levels = list(TECH_ROBOT = 5)
	cost = 3000

	unlocks_designs = list()

/datum/technology/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Borg Illegal Weapons Upgrade"
	id = "borg_syndicate_module"
	tech_type = TECH_ILLEGAL

	x = 0.9
	y = 0.5
	icon = "borgmodule"

	required_technologies = list("tyrant_aimodule")
	required_tech_levels = list(TECH_ROBOT = 10)
	cost = 5000

	unlocks_designs = list()
