// Here's the whole AREAS necessary for the Mining Colony (Aegis Colony) - Asi

// The "Aegis Surface" is what it says, also has unlimited power supply for the sake of lights

/area/mining_colony
	name = "\improper Aegis Surface"
	icon = 'maps/TheColony/ishimura_areas.dmi'
	icon_state = "aegis"
	sound_env = ASTEROID
	ship_area = TRUE

/area/mining_colony/surface
	name = "\improper Aegis Surface"
	icon_state = "aegis"
	sound_env = ASTEROID
	base_lighting_alpha = 90

// Abandoned areas of the colony outside

/area/mining_colony/abandoned
	name = "\improper Aegis Surface - Abandoned Areas"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/hydro
	name = "\improper Aegis Surface - Abandoned Areas"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/storage
	name = "\improper Aegis Surface - Abandoned Areas"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

// Mining Preparation area, there should be some data logs as for why the corpses are there, but its generally an area for Necros to spread further/bonus for them

/area/mining_colony/abandoned/mining_prep
	name = "\improper Aegis Surface - Mining Preparation Facility A-2"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/mining_prep/storage
	name = "\improper Mining Prep - Storage Zone"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/mining_prep/electronics
	name = "\improper Mining Prep - Computer Recylcing Room"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/mining_prep/reception
	name = "\improper Mining Prep - Reception Area"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/mining_prep/shower
	name = "\improper Mining Prep - Showers"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/mining_prep/hallway_zone
	name = "\improper Mining Prep - Hallway"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/mining_prep/locker_room
	name = "\improper Mining Prep - Locker Room"
	icon_state = "p_maintenance"
	sound_env = ASTEROID

/area/mining_colony/abandoned/mining_prep/dormitories
	name = "\improper Mining Prep - Dormitories"
	icon_state = "p_maintenance"
	sound_env = ASTEROID




/area/mining_colony/SCAF
	name = "\improper SCAF Crashed Shuttle remains"
	icon_state = "utfm"
	sound_env = ASTEROID

// Public Sector areas

/area/mining_colony/interior
	name = "\improper Colony Interior"
	icon_state = "crewbase"
	sound_env = ASTEROID

/area/mining_colony/interior/plaza
	name = "\improper Aegis Plaza"
	icon_state = "aegis"
	sound_env = ASTEROID

/area/mining_colony/interior/janitor
	name = "\improper Aegis Janitor Locker Room"
	icon_state = "maintbase"
	sound_env = ASTEROID

/area/mining_colony/interior/bathroom
	name = "\improper Aegis Bathrooms"
	icon_state = "maintbase"
	sound_env = ASTEROID

/area/mining_colony/interior/clean
	name = "\improper Aegis Clothing Washing Zone"
	icon_state = "maintbase"
	sound_env = ASTEROID

/area/mining_colony/interior/seccie_checkpoint_2
	name = "\improper Aegis Security Checkpoint #2"
	icon_state = "checkpoint"
	sound_env = ASTEROID

/area/mining_colony/interior/apartament
	name = "\improper Apartament Block"
	icon_state = "crewbase"
	sound_env = ASTEROID

/area/mining_colony/interior/uni_church
	name = "\improper Unitologist Church"
	icon_state = "aegis"
	sound_env = ASTEROID

/area/mining_colony/interior/kitchen_area
	name = "\improper Aegis Kitchen"
	icon_state = "crewbase"
	sound_env = ASTEROID

/area/mining_colony/interior/bartenderarea
	name = "\improper Aegis Bar"
	icon_state = "crewbase"
	sound_env = ASTEROID

/area/mining_colony/interior/messy_hall
	name = "\improper Aegis Service Mess Hall"
	icon_state = "crewbase"
	sound_env = ASTEROID

/area/mining_colony/interior/hydrophonics
	name = "\improper Aegis Hydrophonics Bay"
	icon_state = "crewbase"
	sound_env = ASTEROID

/area/mining_colony/interior/civ_hall
	name = "\improper Aegis Civilian Mess Hall"
	icon_state = "crewbase"
	sound_env = ASTEROID

// Aegis Maint Areas

/area/mining_colony/interior/maint
	name = "\improper Aegis Maintenance"
	icon_state = "f_c_maintenance"
	sound_env = ASTEROID
	is_maintenance = TRUE

/area/mining_colony/interior/maint/construction
	name = "\improper Aegis Construction Zone"
	icon_state = "f_c_maintenance"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/interior/maint/storage
	name = "\improper Aegis Civilian Storage"
	icon_state = "f_c_maintenance"
	sound_env = ASTEROID
	is_maintenance = TRUE


// Aegis Enginieering Departament, as in for short, the power rooms and such - Asi

/area/mining_colony/interior/enginieering
	name = "\improper Aegis Enginieering Departament"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/lobby
	name = "\improper Aegis Enginieering - Lobby"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/reception
	name = "\improper Aegis Enginieering - Reception"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/main_room
	name = "\improper Aegis Enginieering - Enginieering Bay"
	icon_state = "engi_bay"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/smes
	name = "\improper Aegis Enginieering - SMES Room"
	icon_state = "battery_storage"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/chief_engi
	name = "\improper Aegis Enginieering - Chief Enginieer's Office"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/engi_lockers
	name = "\improper Aegis Enginieering - Locker Room"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/storage
	name = "\improper Aegis Enginieering - Material Storage"
	icon_state = "storage"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/atmospherics
	name = "\improper Aegis Enginieering - Atmospherics"
	icon_state = "atmos"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/air_storage
	name = "\improper Aegis Enginieering - Auxiliary Air Storage"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/reactor
	name = "\improper Aegis Enginieering - Reactor Area"
	icon_state = "engine"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/reactor_control
	name = "\improper Aegis Enginieering - Reactor Control Room"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/reactor_storage
	name = "\improper Aegis Enginieering - Reactor Storage Room"
	icon_state = "engine_smes"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/lathe_room
	name = "\improper Aegis Enginieering - Autolathe Room"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/airlock
	name = "\improper Aegis Enginieering - Airlock"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/telecomms
	name = "\improper Aegis Enginieering - Telecommunications"
	icon_state = "t_comm"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/telecomms_control
	name = "\improper Aegis Enginieering - Telecommunications Control Room"
	icon_state = "t_comm"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/solars
	name = "\improper Aegis Enginieering - Solars"
	icon_state = "engibase"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/gas_storage1
	name = "\improper Aegis Enginieering - Canister Storage 1"
	icon_state = "atmos"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/gas_storage2
	name = "\improper Aegis Enginieering - Canister Storage 2"
	icon_state = "atmos"
	sound_env = ASTEROID

/area/mining_colony/interior/enginieering/supply_storage
	name = "\improper Aegic Enginieering - Supply Storage"
	icon_state = "engibase"
	sound_env = ASTEROID


//Shuttle Area for the unlucky Kellion, which should be more safe now i hope - Asi

/area/mining_colony/interior/kellion_arrival
	name = "\improper Aegis Emergency Hangar"
	icon_state = "m_shuttlebay_one"
	sound_env = ASTEROID

/area/mining_colony/interior/kellion_arrival/arrivals
	name = "\improper Aegis Emergency Hangar - Arrivals"
	icon_state = "m_shuttlebay_one"
	sound_env = ASTEROID


// The Evacuation site for the colony, pods rather but bigger and having the crew to co-operate to escape - Asi

/area/mining_colony/interior/shuttle_bay
	name = "\improper Aegis Shuttle Bay"
	icon_state = "tramstation"
	sound_env = ASTEROID

/area/mining_colony/interior/shuttle_bay/hangar
	name = "\improper Aegis  - Shuttle Bay Hangar"
	icon_state = "tramstation"
	sound_env = ASTEROID

/area/mining_colony/interior/shuttle_bay/control_room
	name = "\improper Aegis - Shuttle Bay Control Room"
	icon_state = "tramstation"
	sound_env = ASTEROID

/area/mining_colony/interior/shuttle_bay/sec_armor
	name = "\improper Aegis - Shuttle Bay Armory"
	icon_state = "checkpoint"
	sound_env = ASTEROID


/area/mining_colony/interior/shuttle_bay/shuttle_1
	name = "\improper Aegis - Civilian Evac Shuttle 1"
	icon_state = "m_shuttle_one"
	sound_env = ASTEROID
	requires_power = FALSE

/area/mining_colony/interior/shuttle_bay/shuttle_2
	name = "\improper Aegis - Civilian Evac Shuttle 2"
	icon_state = "m_shuttle_two"
	sound_env = ASTEROID
	requires_power = FALSE

/area/mining_colony/interior/shuttle_bay/shuttle_3
	name = "\improper Aegis - Scrapper Shuttle"
	icon_state = "m_shuttle_two"
	sound_env = ASTEROID
	requires_power = FALSE

// Replicated this area as best as i could from Chapter 12: Dead Space (From the first Dead Space game, hence the name) - Asi

/area/mining_colony/c12_deadspace
	name = "\improper Aegis Abandoned Landing Bay 2#"
	icon_state = "c_station"
	sound_env = ASTEROID

/area/mining_colony/c12_deadspace/interior
	name = "\improper Abandoned Landing Bay - Storage"
	icon_state = "c_station"
	sound_env = ASTEROID

/area/mining_colony/c12_deadspace/lockeroom
	name = "\improper Abandoned Landing Bay - Locker Room"
	icon_state = "c_station"
	sound_env = ASTEROID

/area/mining_colony/c12_deadspace/medicalroom
	name = "\improper Abandoned Landing Bay - Medical Room"
	icon_state = "c_station"
	sound_env = ASTEROID

/area/mining_colony/c12_deadspace/controlroom
	name = "\improper Abandoned Landing Bay Locker Room"
	icon_state = "c_station"
	sound_env = ASTEROID

// Medbay Area

/area/mining_colony/interior/medbay
	name = "\improper Aegis Clinic"
	icon_state = "medicalbase"
	sound_env = ASTEROID

/area/mining_colony/interior/medbay/surgery1
	name = "\improper Clinic Surgery Room #1"
	icon_state = "surgery_one"
	sound_env = ASTEROID

/area/mining_colony/interior/medbay/surgery2
	name = "\improper Clinic Surgery Room #2"
	icon_state = "surgery_two"
	sound_env = ASTEROID

/area/mining_colony/interior/medbay/doclockers
	name = "\improper Clinic Locker Room"
	icon_state = "med_storage"
	sound_env = ASTEROID

/area/mining_colony/interior/medbay/medstorage
	name = "\improper Clinic Storage Room"
	icon_state = "med_storage"
	sound_env = ASTEROID

/area/mining_colony/interior/medbay/CMOoffice
	name = "\improper Clinic Seinor Medical Officer's Office"
	icon_state = "medicalbase"
	sound_env = ASTEROID

/area/mining_colony/interior/medbay/chemestry
	name = "\improper Clinic Chemestry Room"
	icon_state = "medicalbase"
	sound_env = ASTEROID

/area/mining_colony/interior/medbay/med_ward
	name = "\improper Clinic Medical Ward"
	icon_state = "medicalbase"
	sound_env = ASTEROID

// Mining area of the colony

/area/mining_colony/interior/mining
	name = "\improper Aegis Mining Headquarters"
	icon_state = "miningbase"
	sound_env = ASTEROID

area/mining_colony/interior/mining/hallway
	name = "\improper Aegis Mining - Hallway"
	icon_state = "miningbase"
	sound_env = ASTEROID

/area/mining_colony/interior/mining/randr
	name = "\improper Aegis Mining - R&R Room"
	icon_state = "miningbase"
	sound_env = ASTEROID

/area/mining_colony/interior/mining/lockeroom
	name = "\improper Aegis Mining - Locker Room"
	icon_state = "m_lockroom"
	sound_env = ASTEROID

/area/mining_colony/interior/mining/toolstorage
	name = "\improper Aegis Mining - Tool Storage Room"
	icon_state = "miningbase"
	sound_env = ASTEROID

/area/mining_colony/interior/mining/foremanoffice
	name = "\improper Aegis Mining - Foreman's Office"
	icon_state = "foremanoffice"
	sound_env = ASTEROID

/area/mining_colony/interior/mining/directoroffice
	name = "\improper Aegis Mining - Director's Office"
	icon_state = "foremanoffice"
	sound_env = ASTEROID

/area/mining_colony/interior/mining/processing
	name = "\improper Aegis Mining - Ore Processing Area"
	icon_state = "processing"
	sound_env = ASTEROID

/area/mining_colony/interior/mining/airlock
	name = "\improper Aegis Mining - Airlock Area"
	icon_state = "miningbase"
	sound_env = ASTEROID


// The Marker Excavation area as featured in Dead Space 1, however its not as simmilar but eh

/area/mining_colony/interior/excavation
	name = "\improper Aegis Excavation Area"
	icon_state = "miscbase"
	sound_env = ASTEROID

/area/mining_colony/interior/excavation/interior
	name = "\improper Aegis Excavation Area - Interior"
	icon_state = "miscbase"
	sound_env = ASTEROID

/area/mining_colony/interior/excavation/restandrelax
	name = "\improper Aegis Excavation Area - R&R Room"
	icon_state = "miscbase"
	sound_env = ASTEROID

/area/mining_colony/interior/excavation/control_room
	name = "\improper Aegis Excavation Area - Hangar Control Room"
	icon_state = "miscbase"
	sound_env = ASTEROID


/area/mining_colony/interior/excavation/hangar
	name = "\improper Aegis Excavation Area - Hangar"
	icon_state = "miscbase"
	sound_env = ASTEROID

/area/mining_colony/interior/excavation/marker_excav
	name = "\improper Aegis Excavation Area - Marker Excavation Site A-7"
	icon_state = "miscbase"
	sound_env = ASTEROID
	base_lighting_alpha = 90


/area/mining_colony/interior/excavation/obs_room
	name = "\improper Aegis Excavation Area - Observation Room"
	icon_state = "miscbase"
	sound_env = ASTEROID


// Cargo Area from the colony

/area/mining_colony/interior/cargo
	name = "\improper Aegis Cargo - Lobby"
	icon_state = "cargolbby"
	sound_env = ASTEROID

/area/mining_colony/interior/cargo/logistics
	name = "\improper Aegis Cargo - Cargo Area"
	icon_state = "cargobay"
	sound_env = ASTEROID

/area/mining_colony/interior/cargo/restandcrap
	name = "\improper Aegis Cargo - Rest And Relaxation"
	icon_state = "cargobase"
	sound_env = ASTEROID

/area/mining_colony/interior/cargo/storage_upper
	name = "\improper Aegis Cargo - Lower Cargo Storage Access"
	icon_state = "cargostorage"
	sound_env = ASTEROID

/area/mining_colony/interior/cargo/officerarea
	name = "\improper Aegis Cargo - Supply Officer's Office"
	icon_state = "cargoffice"
	sound_env = ASTEROID

// Science Area of the Colony

/area/mining_colony/interior/science
	name = "\improper Aegis Science Labs - Lobby"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/scienceoffices
	name = "\improper Aegis Science Labs - Offices"
	icon_state = "researchbase"

/area/mining_colony/interior/science/researchandev
	name = "\improper Aegis Science Labs - Research and Development"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/lockeroom
	name = "\improper Aegis Science Labs - Locker Room"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/restandrelaxation
	name = "\improper Aegis Science Labs - R&R Room"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/researchwarcrime
	name = "\improper Aegis Science Labs - R&D Testing Room"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/virology
	name = "\improper Aegis Science Labs - Virology Laboratory"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/sciencechief
	name = "\improper Aegis Science Labs - Chief Science Officer"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/xenoarcheology
	name = "\improper Aegis Science Labs - Xenoarcheology Laboratory"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/xenostorage
	name = "\improper Aegis Science Labs - Anomaly Storage"
	icon_state = "researchbase"
	sound_env = ASTEROID

/area/mining_colony/interior/science/airlock
	name = "\improper Aegis Science Labs - Airlock"
	icon_state = "researchbase"
	sound_env = ASTEROID

// Security Areas of the colony (AKA P-Sec, as in Planetary Security, checkpoints & Such)

/area/mining_colony/security
	name = "\improper Planetary Security Headquarters"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/hallway
	name = "\improper P-Sec Hallway"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/interrogation_room
	name = "\improper P-Sec Interrogation room"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/sec_armory
	name = "\improper P-Sec Security Armory"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/sec_storage
	name = "\improper P-Sec Storage"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/sec_resting
	name = "\improper P-Sec R&R Area"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/sec_firingrange
	name = "\improper P-Sec Firing Range"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/infirmary
	name = "\improper P-Sec Infirmary"
	icon_state = "brig"
	sound_env = ASTEROID

// 2nd Floor Areas

/area/mining_colony/security/upper/
	name = "\improper P-Sec Headquarters - 2nd floor"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/sec_offices
	name = "\improper P-Sec Dept Offices"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/cryo_room
	name = "\improper P-Sec Security Cryo Room"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/forensics
	name = "\improper P-Sec Forensics"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/permacells1
	name = "\improper P-Sec Security Isolation Cell 1#"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/permacells2
	name = "\improper P-Sec Security Isolation Cell 2#"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/secstorage2
	name = "\improper P-Sec Upper Storage"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/sec_commander
	name = "\improper P-Sec Commander Office"
	icon_state = "brig"
	sound_env = ASTEROID

/area/mining_colony/security/upper/director
	name = "\improper Colony Director's Office"
	icon_state = "commandbase"
	sound_env = ASTEROID

/area/mining_colony/security/upper/commandofficers
	name = "\improper Command Office"
	icon_state = "commandbase"
	sound_env = ASTEROID

// Underground Levels of the colony, mining, morgue, maint tunnels and such

/area/mining_colony/lower
	name = "\improper Aegis Lower Level"
	icon_state = "aegis"
	sound_env = ASTEROID
	is_maintenance = TRUE

/area/mining_colony/lower/medical
	name = "\improper Aegis Lower Medical Level"
	icon_state = "medicalbase"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/biolab
	name = "\improper Aegis Bio-Lab"
	icon_state = "medicalbase"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/morgue
	name = "\improper Aegis Morgue"
	icon_state = "morgue"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/securitystation
	name = "\improper Aegis P-Sec Lower Level"
	icon_state = "brig"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/securityevidence1
	name = "\improper Aegis P-Sec Evidence Storage #1"
	icon_state = "brig"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/securityevidence2
	name = "\improper Aegis P-Sec Evidence Storage #2"
	icon_state = "brig"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/mining_caves
	name = "\improper Aegis Caves"
	icon_state = "maintbase"
	sound_env = ASTEROID
	is_maintenance = FALSE
	base_lighting_alpha = 90

/area/mining_colony/lower/mining_caves/shelter_1
	name = "\improper Aegis Caves - Cave-In Shelter 1"
	icon_state = "crewbase"
	sound_env = ASTEROID
	is_maintenance = FALSE
	base_lighting_alpha = 0

/area/mining_colony/lower/mining_caves/shelter_2
	name = "\improper Aegis Caves - Cave-In Shelter 2"
	icon_state = "crewbase"
	sound_env = ASTEROID
	is_maintenance = FALSE
	base_lighting_alpha = 0

/area/mining_colony/lower/mining_caves/shelter_3
	name = "\improper Aegis Caves - Cave-In Shelter 3"
	icon_state = "crewbase"
	sound_env = ASTEROID
	is_maintenance = FALSE
	base_lighting_alpha = 0

/area/mining_colony/lower/excav
	name = "\improper Aegis Lower Level - Excavation Storage Area"
	icon_state = "cargobay"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/excav/storage
	name = "\improper Aegis Lower Level - Large Storage"
	icon_state = "cargobay"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/excav/electronics
	name = "\improper Aegis Lower Level - Electronics Storage"
	icon_state = "cargobay"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/lower/excav/airlock
	name = "\improper Aegis Lower Level - Airlock Area"
	icon_state = "disposals"
	sound_env = ASTEROID
	is_maintenance = FALSE

/area/mining_colony/security/upper/fl_office
	name = "\improper First Lieutenant Office"
	icon_state = "commandbase"
	sound_env = ASTEROID

/area/mining_colony/security/upper/be_room1
	name = "\improper Bridge Ensign Room 1"
	icon_state = "commandbase"
	sound_env = ASTEROID

/area/mining_colony/security/upper/be_room2
	name = "\improper Bridge Ensign Room 2"
	icon_state = "commandbase"
	sound_env = ASTEROID

/area/mining_colony/security/upper/be_room3
	name = "\improper Bridge Ensign Room 3"
	icon_state = "commandbase"
	sound_env = ASTEROID

/area/mining_colony/security/upper/be_room4
	name = "\improper Bridge Ensign Room 4"
	icon_state = "commandbase"
	sound_env = ASTEROID

/area/mining_colony/security/upper/bridge_corridor
	name = "\improper Bridge Corridor"
	icon_state = "commandbase"
	sound_env = ASTEROID

/*
	LOWER DECK MAINTS! AAAAAAAAAAAAAAAAAAAAAAAAAA!
*/

/area/mining_colony/lower/maints
	name = "\improper Maintance Room"
	icon_state = "aegis"
	sound_env = ASTEROID
	is_maintenance = TRUE

/area/mining_colony/lower/maints/room1
/area/mining_colony/lower/maints/room2
/area/mining_colony/lower/maints/room3
/area/mining_colony/lower/maints/room4
/area/mining_colony/lower/maints/room5
/area/mining_colony/lower/maints/room6
/area/mining_colony/lower/maints/room7
/area/mining_colony/lower/maints/room8
/area/mining_colony/lower/maints/room9
/area/mining_colony/lower/maints/room10
/area/mining_colony/lower/maints/room11
/area/mining_colony/lower/maints/room12
/area/mining_colony/lower/maints/room13
/area/mining_colony/lower/maints/room14
/area/mining_colony/lower/maints/room15
/area/mining_colony/lower/maints/room16
/area/mining_colony/lower/maints/room17
/area/mining_colony/lower/maints/room18
/area/mining_colony/lower/maints/room19
/area/mining_colony/lower/maints/room20
/area/mining_colony/lower/maints/room21
/area/mining_colony/lower/maints/room22
/area/mining_colony/lower/maints/room23
/area/mining_colony/lower/maints/room24
/area/mining_colony/lower/maints/room25
/area/mining_colony/lower/maints/room26
/area/mining_colony/lower/maints/room27
/area/mining_colony/lower/maints/room28
/area/mining_colony/lower/maints/room29
/area/mining_colony/lower/maints/room30
/area/mining_colony/lower/maints/room31
/area/mining_colony/lower/maints/room32
/area/mining_colony/lower/maints/room33
/area/mining_colony/lower/maints/room34
/area/mining_colony/lower/maints/room35
/area/mining_colony/lower/maints/room36
/area/mining_colony/lower/maints/room37
/area/mining_colony/lower/maints/room38
/area/mining_colony/lower/maints/room39
/area/mining_colony/lower/maints/room40
/area/mining_colony/lower/maints/room41
/area/mining_colony/lower/maints/room42
/area/mining_colony/lower/maints/room43
/area/mining_colony/lower/maints/room44
/area/mining_colony/lower/maints/room45
/area/mining_colony/lower/maints/room46
/area/mining_colony/lower/maints/room47
/area/mining_colony/lower/maints/room48
/area/mining_colony/lower/maints/room49
/area/mining_colony/lower/maints/room50
/area/mining_colony/lower/maints/room51
/area/mining_colony/lower/maints/room52
/area/mining_colony/lower/maints/room53
/area/mining_colony/lower/maints/room54
/area/mining_colony/lower/maints/room55
/area/mining_colony/lower/maints/room56
/area/mining_colony/lower/maints/room57
/area/mining_colony/lower/maints/room58
/area/mining_colony/lower/maints/room59
/area/mining_colony/lower/maints/room60
/area/mining_colony/lower/maints/room61
/area/mining_colony/lower/maints/room62
/area/mining_colony/lower/maints/room63
/area/mining_colony/lower/maints/room64
/area/mining_colony/lower/maints/room65
/area/mining_colony/lower/maints/room66
/area/mining_colony/lower/maints/room67
/area/mining_colony/lower/maints/room68
/area/mining_colony/lower/maints/room69
