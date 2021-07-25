/*
List of circuit's designs:
+	battle arcade machine
+	orion trail arcade machine
+	prisoner management console
+	patient monitoring console
+	crew monitoring console
+	R&D control console
+	telecommunications monitoring console
+	telecommunications server monitoring console
+	telecommunications traffic control console
+	messaging monitor console
+	destructive analyzer
+	protolathe
+	circuit imprinter
+	autolathe board
+	R&D server control console
+	R&D server
	//exosuit fabricator
+	atmosphere alert console
+	atmosphere monitoring console
+	RCON remote control console
+	power monitoring console
+	solar control console
+	PACMAN-type generator
+	SUPERPACMAN-type generator
+	MRSPACMAN-type generator
+	cell rack PSU
+	'SMES' superconductive magnetic energy storage
+	gas heating system
+	gas cooling system
+	biogenerator
+	mining drill head
+	mining drill brace
+	server mainframe
+	processor unit
+	bus mainframe
+	hub mainframe
+	relay mainframe
+	subspace broadcaster
+	subspace receiver
+	Shield Generator
+	Shield Diffuser
+	SolNet Quantum Relay
+	fusion core control console
+	fusion fuel compressor
+	fusion fuel control console
+	gyrotron control console
+	fusion core
+	fusion fuel injector
+	chemical dispenser
+	chem master
*/

/datum/design/circuit
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	time = 5

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/circuitboard/C = build_path
		if(initial(C.board_type) == "machine")
			name = "Machine circuit design ([item_name])"
		else if(initial(C.board_type) == "computer")
			name = "Computer circuit design ([item_name])"
		else
			name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

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

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner
	sort_string = "DACAA"

/datum/design/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating
	sort_string = "FACAA"

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	build_path = /obj/item/weapon/circuitboard/crew
	sort_string = "FAGAI"

/datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	build_path = /obj/item/weapon/circuitboard/rdconsole
	sort_string = "HAAAA"

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	build_path = /obj/item/weapon/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	build_path = /obj/item/weapon/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/circuit/comm_traffic
	name = "telecommunications traffic control console"
	id = "comm_traffic"
	build_path = /obj/item/weapon/circuitboard/comm_traffic
	sort_string = "HAACC"

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	build_path = /obj/item/weapon/circuitboard/message_monitor
	sort_string = "HAACD"

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	build_path = /obj/item/weapon/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	build_path = /obj/item/weapon/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	build_path = /obj/item/weapon/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	build_path = /obj/item/weapon/circuitboard/rdserver
	sort_string = "HABBB"

/*Useless until someone will add robots
/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	build_path = /obj/item/weapon/circuitboard/mechfab
	sort_string = "HABAE"
*/

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	build_path = /obj/item/weapon/circuitboard/rcon_console
	sort_string = "JAAAC"

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor
	sort_string = "JAAAD"

/datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control
	sort_string = "JAAAE"

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	build_path = /obj/item/weapon/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	build_path = /obj/item/weapon/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	build_path = /obj/item/weapon/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	build_path = /obj/item/weapon/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	build_path = /obj/item/weapon/circuitboard/smes
	sort_string = "JBABB"

/datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	build_path = /obj/item/weapon/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/circuit/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	build_path = /obj/item/weapon/circuitboard/miningdrill
	sort_string = "KCAAA"

/datum/design/circuit/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace
	sort_string = "KCAAB"

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

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

/datum/design/circuit/shield_generator
	name = "Shield Generator"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_generator"
	build_path = /obj/item/weapon/circuitboard/shield_generator
	sort_string = "VAAAC"

/datum/design/circuit/shield_diffuser
	name = "Shield Diffuser"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_diffuser"
	build_path = /obj/item/weapon/circuitboard/shield_diffuser
	sort_string = "VAAAB"

/datum/design/circuit/ntnet_relay
	name = "SolNet Quantum Relay"
	id = "ntnet_relay"
	build_path = /obj/item/weapon/circuitboard/ntnet_relay
	sort_string = "WAAAA"

/datum/design/circuit/fusion
	name = "fusion core control console"
	id = "fusion_core_control"
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

/datum/design/circuit/chemical_dispenser
	name = "chemical dispenser"
	id = "chemical_dispenser"
	build_path = /obj/item/weapon/circuitboard/chemical_dispenser
	sort_string = "LAAAK"

/datum/design/circuit/chem_master
	name = "chem master"
	id = "chem_master"
	build_path = /obj/item/weapon/circuitboard/chem_master
	sort_string = "LAAAH"

/datum/design/circuit/hydro_tray
	name = "Hydroponic Tray"
	id = "hydro_tray"
	build_path = /obj/item/weapon/circuitboard/hydro_tray
	sort_string = "LAAAH"

/datum/design/circuit/seed_extractor
	name = "Seed Extractor"
	id = "seed_extractor"
	build_path = /obj/item/weapon/circuitboard/seed_extractor
	sort_string = "LAAAH"

/datum/design/circuit/smartfridge
	name = "Smartfridge"
	id = "smartfridge"
	build_path = /obj/item/weapon/circuitboard/smartfridge
	sort_string = "LAAAH"

/datum/design/circuit/deepfryer
	name = "Deep Fryer"
	id = "deepfryer"
	build_path = /obj/item/weapon/circuitboard/deepfryer
	sort_string = "LAAAH"

/datum/design/circuit/microwave
	name = "Microwave"
	id = "microwave"
	build_path = /obj/item/weapon/circuitboard/microwave
	sort_string = "LAAAH"

/datum/design/circuit/oven
	name = "Oven"
	id = "oven"
	build_path = /obj/item/weapon/circuitboard/oven
	sort_string = "LAAAH"

/datum/design/circuit/grill
	name = "Grill"
	id = "grill"
	build_path = /obj/item/weapon/circuitboard/grill
	sort_string = "LAAAH"

/datum/design/circuit/candymaker
	name = "Candy Machine"
	id = "candymaker"
	build_path = /obj/item/weapon/circuitboard/candymaker
	sort_string = "LAAAH"

/datum/design/circuit/cereal
	name = "Cereal"
	id = "cereal"
	build_path = /obj/item/weapon/circuitboard/cereal
	sort_string = "LAAAH"

/datum/design/circuit/gibber
	name = "Gibber"
	id = "gibber"
	build_path = /obj/item/weapon/circuitboard/gibber
	sort_string = "LAAAH"

/datum/design/circuit/cryo_cell
	name = "Cryo Cell"
	id = "cryo_cell"
	build_path = /obj/item/weapon/circuitboard/cryo_cell
	sort_string = "LAAAH"

/datum/design/circuit/sleeper
	name = "Sleeper"
	id = "sleeper"
	build_path = /obj/item/weapon/circuitboard/sleeper
	sort_string = "LAAAH"

/datum/design/circuit/recharger
	name = "Recharger"
	id = "recharger"
	build_path = /obj/item/weapon/circuitboard/recharger
	sort_string = "LAAAH"
