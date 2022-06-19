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
+	Body Scanner
RnD:
+	R&D control console
+	destructive analyzer
+	protolathe
+	circuit imprinter
+	autolathe board
+	R&D server control console
+	R&D server
//	exosuit fabricator
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
	time = 20

/datum/design/circuit/arcademachine
	name = "battle arcade machine"
	id = "arcademachine"
	build_path = /obj/item/weapon/circuitboard/arcade/battle

/datum/design/circuit/oriontrail
	name = "orion trail arcade machine"
	id = "oriontrail"
	build_path = /obj/item/weapon/circuitboard/arcade/orion_trail

/datum/design/circuit/security
	category = "Security"

/datum/design/circuit/security/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner

/datum/design/circuit/medical
	category = "Medical"

/datum/design/circuit/medical/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating

/datum/design/circuit/medical/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	build_path = /obj/item/weapon/circuitboard/crew

/datum/design/circuit/medical/chemical_dispenser
	name = "chemical dispenser"
	id = "chemical_dispenser"
	build_path = /obj/item/weapon/circuitboard/chemical_dispenser

/datum/design/circuit/medical/chem_master
	name = "chem master"
	id = "chem_master"
	build_path = /obj/item/weapon/circuitboard/chem_master

/datum/design/circuit/medical/cryo_cell
	name = "Cryo Cell"
	id = "cryo_cell"
	build_path = /obj/item/weapon/circuitboard/cryo_cell

/datum/design/circuit/medical/sleeper
	name = "Sleeper"
	id = "sleeper"
	build_path = /obj/item/weapon/circuitboard/sleeper

/datum/design/circuit/medical/body_scanner
	name = "Body Scanner"
	id = "body_scanner"
	build_path = /obj/item/weapon/circuitboard/body_scanner

/datum/design/circuit/research
	category = "RnD"

/datum/design/circuit/research/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	build_path = /obj/item/weapon/circuitboard/rdconsole

/datum/design/circuit/research/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer

/datum/design/circuit/research/protolathe
	name = "protolathe"
	id = "protolathe"
	build_path = /obj/item/weapon/circuitboard/protolathe

/datum/design/circuit/research/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter

/datum/design/circuit/research/autolathe
	name = "autolathe board"
	id = "autolathe"
	build_path = /obj/item/weapon/circuitboard/autolathe

/datum/design/circuit/research/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	build_path = /obj/item/weapon/circuitboard/rdservercontrol

/datum/design/circuit/research/rdserver
	name = "R&D server"
	id = "rdserver"
	build_path = /obj/item/weapon/circuitboard/rdserver

/*Useless until someone will add robots
/datum/design/circuit/research/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	build_path = /obj/item/weapon/circuitboard/mechfab
*/

/datum/design/circuit/engineering
	category = "Engineering"

/datum/design/circuit/engineering/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert

/datum/design/circuit/engineering/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management

/datum/design/circuit/engineering/gas_heater
	name = "gas heating system"
	id = "gasheater"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater

/datum/design/circuit/engineering/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler

/datum/design/circuit/egnineering/shield_generator
	name = "Shield Generator"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_generator"
	build_path = /obj/item/weapon/circuitboard/shield_generator

/datum/design/circuit/egnineering/shield_diffuser
	name = "Shield Diffuser"
	desc = "Allows for the construction of a shield generator circuit board."
	id = "shield_diffuser"
	build_path = /obj/item/weapon/circuitboard/shield_diffuser

/datum/design/circuit/power
	category = "Power"

/datum/design/circuit/power/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	build_path = /obj/item/weapon/circuitboard/rcon_console

/datum/design/circuit/power/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor

/datum/design/circuit/power/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control

/datum/design/circuit/power/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	build_path = /obj/item/weapon/circuitboard/pacman

/datum/design/circuit/power/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	build_path = /obj/item/weapon/circuitboard/pacman/super

/datum/design/circuit/power/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	build_path = /obj/item/weapon/circuitboard/pacman/mrs

/datum/design/circuit/power/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	build_path = /obj/item/weapon/circuitboard/batteryrack

/datum/design/circuit/power/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	build_path = /obj/item/weapon/circuitboard/smes

/datum/design/circuit/power/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	build_path = /obj/item/weapon/circuitboard/biogenerator

/datum/design/circuit/power/recharger
	name = "Recharger"
	id = "recharger"
	build_path = /obj/item/weapon/circuitboard/recharger

/datum/design/circuit/mining
	category = "Mining"

/datum/design/circuit/mining/miningdrill
	name = "mining drill head"
	id = "mining drill head"
	build_path = /obj/item/weapon/circuitboard/miningdrill

/datum/design/circuit/mining/miningdrillbrace
	name = "mining drill brace"
	id = "mining drill brace"
	build_path = /obj/item/weapon/circuitboard/miningdrillbrace

/datum/design/circuit/tcom
	category = "Telecommuncations"

/datum/design/circuit/tcom/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	build_path = /obj/item/weapon/circuitboard/comm_monitor

/datum/design/circuit/tcom/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	build_path = /obj/item/weapon/circuitboard/comm_server

/datum/design/circuit/tcom/comm_traffic
	name = "telecommunications traffic control console"
	id = "comm_traffic"
	build_path = /obj/item/weapon/circuitboard/comm_traffic

/datum/design/circuit/tcom/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	build_path = /obj/item/weapon/circuitboard/message_monitor

/datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server

/datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	build_path = /obj/item/weapon/circuitboard/telecomms/relay

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver

/datum/design/circuit/tcom/ntnet_relay
	name = "SolNet Quantum Relay"
	id = "ntnet_relay"
	build_path = /obj/item/weapon/circuitboard/ntnet_relay

/datum/design/circuit/fusion
	name = "fusion core control console"
	id = "fusion_core_control"
	category = "Fusion"
	build_path = /obj/item/weapon/circuitboard/fusion_core_control

/datum/design/circuit/fusion/fuel_compressor
	name = "fusion fuel compressor"
	id = "fusion_fuel_compressor"
	build_path = /obj/item/weapon/circuitboard/fusion_fuel_compressor

/datum/design/circuit/fusion/fuel_control
	name = "fusion fuel control console"
	id = "fusion_fuel_control"
	build_path = /obj/item/weapon/circuitboard/fusion_fuel_control

/datum/design/circuit/fusion/gyrotron_control
	name = "gyrotron control console"
	id = "gyrotron_control"
	build_path = /obj/item/weapon/circuitboard/gyrotron_control

/datum/design/circuit/fusion/core
	name = "fusion core"
	id = "fusion_core"
	build_path = /obj/item/weapon/circuitboard/fusion_core

/datum/design/circuit/fusion/injector
	name = "fusion fuel injector"
	id = "fusion_injector"
	build_path = /obj/item/weapon/circuitboard/fusion_injector

/datum/design/circuit/food
	category = "Food"

/datum/design/circuit/food/hydro_tray
	name = "Hydroponic Tray"
	id = "hydro_tray"
	build_path = /obj/item/weapon/circuitboard/hydro_tray

/datum/design/circuit/food/seed_extractor
	name = "Seed Extractor"
	id = "seed_extractor"
	build_path = /obj/item/weapon/circuitboard/seed_extractor

/datum/design/circuit/food/smartfridge
	name = "Smartfridge"
	id = "smartfridge"
	build_path = /obj/item/weapon/circuitboard/smartfridge

/datum/design/circuit/food/deepfryer
	name = "Deep Fryer"
	id = "deepfryer"
	build_path = /obj/item/weapon/circuitboard/deepfryer

/datum/design/circuit/food/microwave
	name = "Microwave"
	id = "microwave"
	build_path = /obj/item/weapon/circuitboard/microwave

/datum/design/circuit/food/oven
	name = "Oven"
	id = "oven"
	build_path = /obj/item/weapon/circuitboard/oven

/datum/design/circuit/food/grill
	name = "Grill"
	id = "grill"
	build_path = /obj/item/weapon/circuitboard/grill

/datum/design/circuit/food/candymaker
	name = "Candy Machine"
	id = "candymaker"
	build_path = /obj/item/weapon/circuitboard/candymaker

/datum/design/circuit/food/cereal
	name = "Cereal"
	id = "cereal"
	build_path = /obj/item/weapon/circuitboard/cereal

/datum/design/circuit/food/gibber
	name = "Gibber"
	id = "gibber"
	build_path = /obj/item/weapon/circuitboard/gibber

/datum/design/circuit/food/extractor
	name = "Lysis-Isolation Centrifuge"
	id = "extractor"
	build_path = /obj/item/weapon/circuitboard/extractor

/datum/design/circuit/food/editor
	name = "Bioballistic Delivery System"
	id = "editor"
	build_path = /obj/item/weapon/circuitboard/editor
