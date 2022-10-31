/datum/design/item/rig
	build_type = STORE_ROUNDSTART
	category = "RIG"
	price = 8000


//Tier 0: civilian grade rigs (no modules/little to no armor)
/datum/design/item/rig/civ
	build_path = /obj/item/rig/civilian
	price = 500

/datum/design/item/rig/clown
	name = "ERROR_404_RIG_NOT_FOUND"
	desc = "//ERROR_404_DESCRIPTION_NOT_FOUND"
	build_path = /obj/item/rig/clown
	price = 42069

//Here, alternative civ rig visual styles would go, if we had some




//Tier I: standard protection and modules
/datum/design/item/rig/fire
	build_path = /obj/item/rig/firesuit
	price = 4000 //weak, good against burns

/datum/design/item/rig/mining
	build_path = /obj/item/rig/mining
	price = 6000

/datum/design/item/rig/medical
	build_path = /obj/item/rig/medical
	price = 6500 //good against burns/toxins

/datum/design/item/rig/excavation
	build_path = /obj/item/rig/excavation
	price = 7000

/datum/design/item/rig/eng
	build_path = /obj/item/rig/engineering
	price = 8000 //moderate protection




//Tier II: high protection and advanced modules
/datum/design/item/rig/patrol
	build_path = /obj/item/rig/patrol
	price = 11000 //standard security rig for patrol

/datum/design/item/rig/sec
	build_path = /obj/item/rig/security
	price = 11000 //standard security rig

/datum/design/item/rig/pcsi
	build_path = /obj/item/rig/security/pcsi
	price = 12000 //armory rig

/datum/design/item/rig/marksman
	build_path = /obj/item/rig/marksman
	price = 13000 //SSO

/datum/design/item/rig/riot
	build_path = /obj/item/rig/riot
	price = 14000 //for melee combat, kinda worse at everything else

/datum/design/item/rig/vintage
	build_path = /obj/item/rig/vintage
	price = 15000	//tanky rig, slow

/datum/design/item/rig/advanced
	build_path = /obj/item/rig/advanced
	price = 15000 //good all-rounder, comes with great modules
