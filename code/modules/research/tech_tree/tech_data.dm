/datum/technology/data
	tech_type = TECH_DATA
	icon = 'icons/obj/modular_components.dmi'

/datum/technology/data/basic
	name = "Basic Modular Computers"
	desc = "Basic Modular Computers"
	id = "basic_modular"

	x = 12
	y = 7
	icon_state = "cpu_normal"

	required_technologies = list()
	cost = 0

	unlocks_designs = list("hdd_basic", "netcard_basic", "bat_normal", "portadrive_basic", "cpu_normal")

/datum/technology/data/frames
	name = "Modular Computers Frames"
	desc = "Modular Computers Frames"
	id = "frames"

	x = 12
	y = 8.5
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tabletsol"

	required_technologies = list("basic_modular")
	cost = 750

	unlocks_designs = list("pda_frame", "tablet_frame", "laptop_frame", "telescreen_frame")

/datum/technology/data/ms_hdd
	name = "Power effective HDD's"
	desc = "Power effective HDD's"
	id = "ms_hdd"

	x = 12
	y = 5.5
	icon_state = "hdd_small"

	required_technologies = list("basic_modular")
	cost = 250

	unlocks_designs = list("hdd_micro", "hdd_small")

/datum/technology/data/adv_hdd
	name = "Advanced HDD"
	desc = "Advanced HDD"
	id = "adv_hdd"

	x = 12
	y = 4
	icon_state = "hdd_advanced"

	required_technologies = list("ms_hdd")
	cost = 500

	unlocks_designs = list("hdd_advanced", "portadrive_advanced")

/datum/technology/data/sup_hdd
	name = "Super HDD"
	desc = "Super HDD"
	id = "sup_hdd"

	x = 12
	y = 2.5
	icon_state = "hdd_super"

	required_technologies = list("adv_hdd")
	cost = 750

	unlocks_designs = list("hdd_super", "portadrive_super")

/datum/technology/data/cls_hdd
	name = "Cluster HDD"
	desc = "Cluster HDD"
	id = "cls_hdd"

	x = 12
	y = 1
	icon_state = "hdd_cluster"

	required_technologies = list("sup_hdd")
	cost = 1250

	unlocks_designs = list("hdd_cluster")

/datum/technology/data/netcard_w
	name = "Wired Netcard"
	desc = "Wired Netcard"
	id = "netcard_w"

	x = 10.5
	y = 5.5
	icon_state = "netcard_ethernet"

	required_technologies = list("basic_modular")
	cost = 500

	unlocks_designs = list("netcard_wired")

/datum/technology/data/netcard_adv
	name = "Advanced Netcard"
	desc = "Advanced Netcard"
	id = "netcard_adv"

	x = 10.5
	y = 4
	icon_state = "netcard_advanced"

	required_technologies = list("netcard_w", "solnet_relay")
	cost = 1250

	unlocks_designs = list("netcard_advanced")

/datum/technology/data/cpu_small
	name = "Computer Microprocessor Unit"
	desc = "Computer Microprocessor Unit"
	id = "cpu_small"

	x = 15
	y = 5.5
	icon_state = "cpu_small"

	required_technologies = list("basic_modular")
	cost = 250

	unlocks_designs = list("cpu_small")

/datum/technology/data/pcpu_small
	name = "Computer Photonic Microprocessor Unit"
	desc = "Computer Photonic Microprocessor Unit"
	id = "pcpu_small"

	x = 15
	y = 4
	icon_state = "cpu_small_photonic"

	required_technologies = list("cpu_small")
	cost = 500

	unlocks_designs = list("pcpu_small")

/datum/technology/data/pcpu_normal
	name = "Computer Photonic Processor Unit"
	desc = "Computer Photonic Processor Unit"
	id = "pcpu_normal"

	x = 15
	y = 2.5
	icon_state = "cpu_normal_photonic"

	required_technologies = list("pcpu_small")
	cost = 100

	unlocks_designs = list("pcpu_normal")

/datum/technology/data/modular_bat_micro
	name = "Small Battery Module's"
	desc = "Small Battery Module's"
	id = "modular_bat_micro"

	x = 13.5
	y = 5.5
	icon_state = "battery_normal"

	required_technologies = list("basic_modular")
	cost = 250

	unlocks_designs = list("bat_nano", "bat_micro")

/datum/technology/data/modular_bat_advanced
	name = "Advanced Battery Module"
	desc = "Advanced Battery Module"
	id = "modular_bat_advanced"

	x = 13.5
	y = 4
	icon_state = "battery_advanced"

	required_technologies = list("modular_bat_micro", "adv_power")
	cost = 500

	unlocks_designs = list("bat_advanced")

/datum/technology/data/modular_bat_super
	name = "Super Battery Module"
	desc = "Super Battery Module"
	id = "modular_bat_super"

	x = 13.5
	y = 2.5
	icon_state = "battery_super"

	required_technologies = list("modular_bat_advanced", "sup_power")
	cost = 750

	unlocks_designs = list("bat_super")

/datum/technology/data/modular_bat_ultra
	name = "Ultra Battery Module"
	desc = "Ultra Battery Module"
	id = "modular_bat_ultra"

	x = 13.5
	y = 1
	icon_state = "battery_ultra"

	required_technologies = list("modular_bat_super", "hyp_power")
	cost = 1250

	unlocks_designs = list("bat_ultra")

/datum/technology/data/tesla_link
	name = "Tesla Link"
	desc = "Tesla Link"
	id = "tesla_link"

	x = 13.5
	y = 8.5
	icon_state = "teslalink"

	required_technologies = list("basic_modular")
	cost = 500

	unlocks_designs = list("teslalink")

/datum/technology/data/nanoprinter
	name = "Nanoprinter"
	desc = "Nanoprinter"
	id = "nanoprinter"

	x = 15
	y = 8.5
	icon_state = "printer"

	required_technologies = list("basic_modular")
	cost = 500

	unlocks_designs = list("nanoprinter", "scan_paper")

/datum/technology/data/rfid
	name = "RFID Card Slot"
	desc = "RFID Card Slot"
	id = "rfid"

	x = 10.5
	y = 8.5
	icon_state = "cardreader"

	required_technologies = list("basic_modular")
	cost = 750

	unlocks_designs = list("cardslot")

/datum/technology/data/med_scanners
	name = "Medical Scanning Modules"
	desc = "Medical Scanning Modules"
	id = "med_scanners"

	x = 9
	y = 7
	icon_state = "printer"

	required_technologies = list("basic_modular", "add_med_tools")
	cost = 750

	unlocks_designs = list("scan_reagent", "scan_medical")

/datum/technology/data/atmos_scanner
	name = "Atmos Scanning Module"
	desc = "Atmos Scanning Module"
	id = "atmos_scanners"

	x = 16.5
	y = 7
	icon_state = "printer"

	required_technologies = list("basic_modular", "gas_heat")
	cost = 750

	unlocks_designs = list("scan_atmos")
