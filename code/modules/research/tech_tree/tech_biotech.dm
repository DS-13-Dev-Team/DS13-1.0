/datum/technology/bio
	tech_type = TECH_BIO
	icon = 'icons/obj/items.dmi'

/datum/technology/bio/basic
	name = "Basic Biotech"
	desc = "First step into the bio technologies!"
	id = "basic_biotech"

	x = 2
	y = 5
	icon_state = "health"

	required_technologies = list()
	cost = 0

	unlocks_designs = list("health_analyzer", "beaker", "large_beaker")

/datum/technology/bio/basic_medical_machines
	name = "Basic Medical Machines"
	desc = "Patient and RIG monitoring consoles"
	id = "basic_medical_machines"

	x = 4
	y = 5
	//special way to generate an icon

	required_technologies = list("basic_biotech")
	cost = 250

	unlocks_designs = list("operating", "crewconsole")

/datum/technology/bio/basic_medical_machines/generate_icon()
	var/icon/ret = icon('icons/obj/computer.dmi', "computer")
	ret.Blend(icon('icons/obj/computer.dmi', "crew"), ICON_OVERLAY)
	ret.Blend(icon('icons/obj/computer.dmi', "med_key"), ICON_OVERLAY)
	return ret

/datum/technology/bio/hydroponics
	name = "Hydroponics"
	desc = "Basic hydroponic machinery"
	id = "hydroponics"

	x = 2
	y = 6.5
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "hydrotray3"

	required_technologies = list("basic_biotech")
	cost = 250

	unlocks_designs = list("biogenerator", "hydro_tray", "seed_extractor", "smartfridge")

/datum/technology/bio/adv_hydroponics
	name = "Advanced Hydroponics"
	desc = "Botany DNA manipulation machinery or how to grow bicaridine"
	id = "adv_hydroponics"

	x = 2
	y = 8
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "traitcopier"

	required_technologies = list("hydroponics")
	cost = 750

	unlocks_designs = list("disk_botany", "extractor", "editor")

/datum/technology/bio/food_process
	name = "Food Processing"
	desc = "Quick guide how to cook some delicious humans"
	id = "food_process"

	x = 4
	y = 6.5
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"

	required_technologies = list("hydroponics")
	cost = 500

	unlocks_designs = list("deepfryer", "microwave", "oven", "grill", "candymaker", "cereal", "gibber")

/datum/technology/bio/implants
	name = "Implants"
	desc = "Implanting someone without permission from department head or person you are implanting is forbidden!"
	id = "implants"

	x = 4
	y = 3.5
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-r"

	required_technologies = list("basic_medical_machines")
	cost = 1500

	unlocks_designs = list("implanter", "implant_death", "implant_tracking")

/datum/technology/bio/adv_med_machines
	name = "Advanced Medical Machines"
	desc = "Advanced health care machinery"
	id = "adv_med_machines"

	x = 6
	y = 5
	//special way to generate an icon

	required_technologies = list("basic_medical_machines")
	cost = 1500

	unlocks_designs = list("cryo_cell", "sleeper", "body_scanner")

/datum/technology/bio/adv_med_machines/generate_icon()
	return icon('icons/obj/Cryogenic2.dmi', "sleeper_0", 4)

/datum/technology/bio/add_med_tools
	name = "Additional Medical Tools"
	desc = "Some useful tools you can print in case you don't have enough in the storage"
	id = "add_med_tools"

	x = 8
	y = 5
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "healthhud"

	required_technologies = list("adv_med_machines")
	cost = 750

	unlocks_designs = list("mass_spectrometer", "reagent_scanner", "scalpel_laser1", "health_hud", "oxycandle", "defibrillators_back")

/datum/technology/bio/adv_add_med_tools
	name = "Additional Advanced Medical Tools"
	desc = "For those who prefer the best tools"
	id = "adv_add_med_tools"

	x = 10
	y = 5
	icon_state = "adv_spectrometer"

	required_technologies = list("add_med_tools")
	cost = 1250

	unlocks_designs = list("scalpel_laser2", "adv_reagent_scanner", "adv_mass_spectrometer", "defibrillators_compact")

/datum/technology/bio/track_dev
	name = "Tracking Devices"
	desc = "What's the point of using tracking implant if you can implant prisoner with beacon?"
	id = "track_dev"

	x = 8
	y = 6.5
	icon_state = "locator"

	required_technologies = list("add_med_tools")
	cost = 500

	unlocks_designs = list("beacon", "gps", "beacon_locator")

/datum/technology/bio/chemicals
	name = "Chemicals"
	desc = "Don't let the clown access it!"
	id = "chemicals"

	x = 12
	y = 5
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"

	required_technologies = list("adv_add_med_tools")
	cost = 2000

	unlocks_designs = list("chemical_dispenser", "chem_master", "scalpel_laser3")

/datum/technology/bio/hypospray
	name = "Hypospray"
	desc = "The fastest way to deliver chemicals in patient"
	id = "hypospray"

	x = 12
	y = 6.5
	icon = 'icons/obj/syringe.dmi'
	icon_state = "hypo"

	required_technologies = list("chemicals")
	cost = 2000

	unlocks_designs = list("hypospray")

/datum/technology/bio/chemical_guns
	name = "Fast Chemicals Delivery"
	desc = "The fastest way to deliver cyanide in someone you don't like"
	id = "chemical_guns"

	x = 14
	y = 6.5
	icon = 'icons/obj/gun.dmi'
	icon_state = "rapidsyringegun"

	required_technologies = list("hypospray", "nleth_eq")
	cost = 1500

	unlocks_designs = list("chemsprayer", "rapidsyringe", "large_grenade")

/datum/technology/bio/scalpelmanager
	name = "Incision Management System"
	desc = "5/6 surgeons recommend using IMS"
	id = "scalpelmanager"

	x = 12
	y = 3.5
	icon = 'icons/obj/tools.dmi'
	icon_state = "scalpel_manager_on"

	required_technologies = list("chemicals")
	cost = 2000

	unlocks_designs = list("scalpel_manager")

/datum/technology/bio/adv_health_scanner
	name = "Advanced Health Scanner"
	desc = "7/5 doctos recommend using advanced health scanner"
	id = "adv_health_scanner"

	x = 16
	y = 5
	icon_state = "health_adv"

	required_technologies = list("chemicals")
	cost = 3000

	unlocks_designs = list("adv_health_analyzer")

/datum/technology/bio/beakers
	name = "Special Beakers"
	desc = "How does it even work?"
	id = "beakers"

	x = 14
	y = 3.5
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beakerbluespace"

	required_technologies = list("chemicals")
	cost = 1500

	unlocks_designs = list("splitbeaker", "bluespacebeaker")
