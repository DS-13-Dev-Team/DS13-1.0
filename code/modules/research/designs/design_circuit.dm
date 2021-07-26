/*
List of circuit's designs:
+	battle arcade machine
+	orion trail arcade machine
Security:
+	prisoner management console
Medical:
+	patient monitoring console
+	crew monitoring console
+	chemical dispenser
+	chem master
+	Cryo Cell
+	Sleeper
RnD:
+	R&D control console
+	destructive analyzer
+	protolathe
+	circuit imprinter
+	autolathe board
+	R&D server control console
+	R&D server
	//exosuit fabricator
Engineering:
+	atmosphere alert console
+	atmosphere monitoring console
+	gas heating system
+	gas cooling system
+	Shield Generator
+	Shield Diffuser
Power:
+	RCON remote control console
+	power monitoring console
+	solar control console
+	PACMAN-type generator
+	SUPERPACMAN-type generator
+	MRSPACMAN-type generator
+	cell rack PSU
+	'SMES' superconductive magnetic energy storage
+	biogenerator
+	Recharger
Mining:
+	mining drill head
+	mining drill brace
Telecommuncations:
+	telecommunications monitoring console
+	telecommunications server monitoring console
+	telecommunications traffic control console
+	messaging monitor console
+	server mainframe
+	processor unit
+	bus mainframe
+	hub mainframe
+	relay mainframe
+	subspace broadcaster
+	subspace receiver
+	SolNet Quantum Relay
Fusion:
+	fusion core control console
+	fusion fuel compressor
+	fusion fuel control console
+	gyrotron control console
+	fusion core
+	fusion fuel injector
Food:
+	Hydroponic Tray
+	Seed Extractor
+	Smartfridge
+	Deep Fryer
+	Microwave
+	Oven
+	Grill
+	Candy Machine
+	Cereal
+	Gibber
+	Recharger
+	Lysis-Isolation Centrifuge
+	Bioballistic Delivery System
*/

/datum/design/circuit
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	time = 5

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	id = "arcademachine"
	build_path = /obj/item/weapon/circuitboard/arcade/battle
	sort_string = "MAAAA"

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	id = "oriontrail"
	build_path = /obj/item/weapon/circuitboard/arcade/orion_trail
	sort_string = "MABAA"

/datum/design/circuit/security
	category = "Security"

/datum/design/circuit/security/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner
	sort_string = "DACAA"

/datum/design/circuit/medical
	category = "Medical"

/datum/design/circuit/medical/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating
	sort_string = "FACAA"

/datum/design/circuit/medical/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	build_path = /obj/item/weapon/circuitboard/crew
	sort_string = "FAGAI"

/datum/design/circuit/medical/chemical_dispenser
	name = "chemical dispenser"
	id = "chemical_dispenser"
	build_path = /obj/item/weapon/circuitboard/chemical_dispenser
	sort_string = "LAAAK"

/datum/design/circuit/medical/chem_master
	name = "chem master"
	id = "chem_master"
	build_path = /obj/item/weapon/circuitboard/chem_master
	sort_string = "LAAAH"

/datum/design/circuit/medical/cryo_cell
	name = "Cryo Cell"
	id = "cryo_cell"
	build_path = /obj/item/weapon/circuitboard/cryo_cell
	sort_string = "LAAAH"

/datum/design/circuit/medical/sleeper
	name = "Sleeper"
	id = "sleeper"
	build_path = /obj/item/weapon/circuitboard/sleeper
	sort_string = "LAAAH"

/datum/design/circuit/research
	category = "RnD"

/datum/design/circuit/research/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	build_path = /obj/item/weapon/circuitboard/rdconsole
	sort_string = "HAAAA"

/datum/design/circuit/research/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/circuit/research/protolathe
	name = "protolathe"
	id = "protolathe"
	build_path = /obj/item/weapon/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/circuit/research/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/circuit/research/autolathe
	name = "autolathe board"
	id = "autolathe"
	build_path = /obj/item/weapon/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/circuit/research/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	build_path = /obj/item/weapon/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/circuit/research/rdserver
	name = "R&D server"
	id = "rdserver"
	build_path = /obj/item/weapon/circuitboard/rdserver
	sort_string = "HABBB"

/*Useless until someone will add robots
/datum/design/circuit/research/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	build_path = /obj/item/weapon/circuitboard/mechfab
	sort_string = "HABAE"
*/

/datum/design/circuit/engineering
	category = "Engineering"

/datum/design/circuit/engineering/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/circuit/engineering/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/circuit/engineering/gas_heater
	name = "gas heating system"
	id = "gasheater"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/circuit/engineering/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/circuit/egnineering/shield_generator
	name = "Shield Generator"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_generator"
	build_path = /obj/item/weapon/circuitboard/shield_generator
	sort_string = "VAAAC"

/datum/design/circuit/egnineering/shield_diffuser
	name = "Shield Diffuser"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_diffuser"
	build_path = /obj/item/weapon/circuitboard/shield_diffuser
	sort_string = "VAAAB"

/datum/design/circuit/power
	category = "Power"

/datum/design/circuit/power/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	build_path = /obj/item/weapon/circuitboard/rcon_console
	sort_string = "JAAAC"

/datum/design/circuit/power/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor
	sort_string = "JAAAD"

/datum/design/circuit/power/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control
	sort_string = "JAAAE"

/datum/design/circuit/power/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	build_path = /obj/item/weapon/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/circuit/power/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	build_path = /obj/item/weapon/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/circuit/power/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	build_path = /obj/item/weapon/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/circuit/power/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	build_path = /obj/item/weapon/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/circuit/power/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	build_path = /obj/item/weapon/circuitboard/smes
	sort_string = "JBABB"

/datum/design/circuit/power/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	build_path = /obj/item/weapon/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/circuit/power/recharger
	name = "Recharger"
	id = "recharger"
	build_path = /obj/item/weapon/circuitboard/recharger
	sort_string = "LAAAH"

/datum/design/circuit/mining
	category = "Mining"

/datum/design/circuit/mining/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	build_path = /obj/item/weapon/circuitboard/miningdrill
	sort_string = "KCAAA"

/datum/design/circuit/mining/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace
	sort_string = "KCAAB"

/datum/design/circuit/tcom
	category = "Telecommuncations"

/datum/design/circuit/tcom/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	build_path = /obj/item/weapon/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/circuit/tcom/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	build_path = /obj/item/weapon/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/circuit/tcom/comm_traffic
	name = "telecommunications traffic control console"
	id = "comm_traffic"
	build_path = /obj/item/weapon/circuitboard/comm_traffic
	sort_string = "HAACC"

/datum/design/circuit/tcom/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	build_path = /obj/item/weapon/circuitboard/message_monitor
	sort_string = "HAACD"

/datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server
	sort_string = "PAAAA"

/datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor
	sort_string = "PAAAB"

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus
	sort_string = "PAAAC"

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub
	sort_string = "PAAAD"

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	build_path = /obj/item/weapon/circuitboard/telecomms/relay
	sort_string = "PAAAE"

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster
	sort_string = "PAAAF"

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver
	sort_string = "PAAAG"

/datum/design/circuit/tcom/ntnet_relay
	name = "SolNet Quantum Relay"
	id = "ntnet_relay"
	build_path = /obj/item/weapon/circuitboard/ntnet_relay
	sort_string = "WAAAA"

/datum/design/circuit/fusion
	name = "fusion core control console"
	id = "fusion_core_control"
	category = "Fusion"
	build_path = /obj/item/weapon/circuitboard/fusion_core_control
	sort_string = "LAAAD"

/datum/design/circuit/fusion/fuel_compressor
	name = "fusion fuel compressor"
	id = "fusion_fuel_compressor"
	build_path = /obj/item/weapon/circuitboard/fusion_fuel_compressor
	sort_string = "LAAAE"

/datum/design/circuit/fusion/fuel_control
	name = "fusion fuel control console"
	id = "fusion_fuel_control"
	build_path = /obj/item/weapon/circuitboard/fusion_fuel_control
	sort_string = "LAAAF"

/datum/design/circuit/fusion/gyrotron_control
	name = "gyrotron control console"
	id = "gyrotron_control"
	build_path = /obj/item/weapon/circuitboard/gyrotron_control
	sort_string = "LAAAG"

/datum/design/circuit/fusion/core
	name = "fusion core"
	id = "fusion_core"
	build_path = /obj/item/weapon/circuitboard/fusion_core
	sort_string = "LAAAH"

/datum/design/circuit/fusion/injector
	name = "fusion fuel injector"
	id = "fusion_injector"
	build_path = /obj/item/weapon/circuitboard/fusion_injector
	sort_string = "LAAAI"

/datum/design/circuit/food
	category = "Food"

/datum/design/circuit/food/hydro_tray
	name = "Hydroponic Tray"
	id = "hydro_tray"
	build_path = /obj/item/weapon/circuitboard/hydro_tray
	sort_string = "LAAAH"

/datum/design/circuit/food/seed_extractor
	name = "Seed Extractor"
	id = "seed_extractor"
	build_path = /obj/item/weapon/circuitboard/seed_extractor
	sort_string = "LAAAH"

/datum/design/circuit/food/smartfridge
	name = "Smartfridge"
	id = "smartfridge"
	build_path = /obj/item/weapon/circuitboard/smartfridge
	sort_string = "LAAAH"

/datum/design/circuit/food/deepfryer
	name = "Deep Fryer"
	id = "deepfryer"
	build_path = /obj/item/weapon/circuitboard/deepfryer
	sort_string = "LAAAH"

/datum/design/circuit/food/microwave
	name = "Microwave"
	id = "microwave"
	build_path = /obj/item/weapon/circuitboard/microwave
	sort_string = "LAAAH"

/datum/design/circuit/food/oven
	name = "Oven"
	id = "oven"
	build_path = /obj/item/weapon/circuitboard/oven
	sort_string = "LAAAH"

/datum/design/circuit/food/grill
	name = "Grill"
	id = "grill"
	build_path = /obj/item/weapon/circuitboard/grill
	sort_string = "LAAAH"

/datum/design/circuit/food/candymaker
	name = "Candy Machine"
	id = "candymaker"
	build_path = /obj/item/weapon/circuitboard/candymaker
	sort_string = "LAAAH"

/datum/design/circuit/food/cereal
	name = "Cereal"
	id = "cereal"
	build_path = /obj/item/weapon/circuitboard/cereal
	sort_string = "LAAAH"

/datum/design/circuit/food/gibber
	name = "Gibber"
	id = "gibber"
	build_path = /obj/item/weapon/circuitboard/gibber
	sort_string = "LAAAH"

/datum/design/circuit/food/extractor
	name = "Lysis-Isolation Centrifuge"
	id = "extractor"
	build_path = /obj/item/weapon/circuitboard/extractor
	sort_string = "LAAAH"

/datum/design/circuit/food/editor
	name = "Bioballistic Delivery System"
	id = "editor"
	build_path = /obj/item/weapon/circuitboard/editor
	sort_string = "LAAAH"
