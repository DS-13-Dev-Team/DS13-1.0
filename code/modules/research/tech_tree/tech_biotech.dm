/datum/technology/bio
	name = "Basic Biotech"
	desc = "Basic Biotech"
	id = "basic_biotech"
	tech_type = TECH_BIO

	x = 0.1
	y = 0.5
	icon = "healthanalyzer"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("health_analyzer", "beaker", "large beaker")

/datum/technology/bio/basic_medical_machines
	name = "Basic Medical Machines"
	desc = "Basic Medical Machines"
	id = "basic_medical_machines"

	x = 0.2
	y = 0.5
	icon = "operationcomputer"

	required_technologies = list("basic_biotech")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("operating", "crewconsole")

/datum/technology/bio/hydroponics
	name = "Hydroponics"
	desc = "Hydroponics"
	id = "hydroponics"

	x = 0.1
	y = 0.4
	icon = "hydroponics"

	required_technologies = list("basic_biotech")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("biogenerator", "hydro_tray", "seed_extractor", "smartfridge")

/datum/technology/bio/adv_hydroponics
	name = "Advanced Hydroponics"
	desc = "Advanced Hydroponics"
	id = "adv_hydroponics"

	x = 0.1
	y = 0.3
	icon = "hydroponics"

	required_technologies = list("hydroponics")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list()		//Everything for gene work

/datum/technology/bio/food_process
	name = "Food Processing"
	desc = "Food Processing"
	id = "food_process"

	x = 0.2
	y = 0.4
	icon = "microwave"

	required_technologies = list("hydroponics")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("deepfryer", "microwave", "oven", "grill", "candymaker", "cereal", "gibber")

/datum/technology/bio/implants
	name = "Implants"
	desc = "Implants"
	id = "implants"

	x = 0.2
	y = 0.6
	icon = "implant"

	required_technologies = list("basic_medical_machines")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("implanter", "implant_death", "implant_tracking")

/datum/technology/bio/adv_med_machines
	name = "Advanced Medical Machines"
	desc = "Advanced Medical Machines"
	id = "adv_med_machines"

	x = 0.3
	y = 0.5
	icon = "sleeper"

	required_technologies = list("basic_medical_machines")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("cryo_cell", "sleeper")

/datum/technology/bio/add_med_tools
	name = "Additional Medical Tools"
	desc = "Additional Medical Tools"
	id = "add_med_tools"

	x = 0.4
	y = 0.5
	icon = "medhud"

	required_technologies = list("adv_med_machines")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("mass_spectrometer", "reagent_scanner", "scalpel_laser1", "health_hud", "oxycandle", "defibrillators_back")

/datum/technology/bio/adv_add_med_tools
	name = "Advanced Additional Medical Tools"
	desc = "Advanced Additional Medical Tools"
	id = "adv_add_med_tools"

	x = 0.5
	y = 0.5
	icon = "adv_mass_spec"

	required_technologies = list("add_med_tools")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("scalpel_laser2", "adv_reagent_scanner", "adv_mass_spectrometer", "defibrillators_compact")

/datum/technology/bio/track_dev
	name = "Tracking Devices"
	desc = "Tracking Devices"
	id = "track_dev"

	x = 0.4
	y = 0.4
	icon = "gps"

	required_technologies = list("add_med_tools")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("beacon", "gps", "beacon_locator")

/datum/technology/bio/chemicals
	name = "Chemicals"
	desc = "Chemicals"
	id = "chemicals"

	x = 0.6
	y = 0.5
	icon = "chemdisp"

	required_technologies = list("adv_add_med_tools")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("chemical_dispenser", "chem_master", "scalpel_laser3")

/datum/technology/bio/chemical_guns
	name = "Fast Chemicals Delivery"
	desc = "Fast Chemicals Delivery"
	id = "chemical_guns"

	x = 0.6
	y = 0.4
	icon = "rapidsyringegun"

	required_technologies = list("chemicals")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("hypospray", "chemsprayer", "rapidsyringe", "large_grenade")

/datum/technology/bio/scalpelmanager
	name = "Incision Management System"
	desc = "Incision Management System"
	id = "scalpelmanager"

	x = 0.7
	y = 0.5
	icon = "scalpelmanager"

	required_technologies = list("chemicals")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("scalpel_manager")

/datum/technology/bio/beakers
	name = "Special Beakers"
	desc = "Special Beakers"
	id = "beakers"

	x = 0.6
	y = 0.6
	icon = "blue_beaker"

	required_technologies = list("chemicals")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("splitbeaker", "bluespacebeaker")
