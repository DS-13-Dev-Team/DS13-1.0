/datum/design/item/rig
	build_type = STORE_ROUNDSTART
	category = "RIG"
	price = 8000


//Tier 0: civilian grade rigs (no modules/little to no armor)
/datum/design/item/rig/civ
	build_path = /obj/item/rig/civilian
	price = 100

/datum/design/item/rig/civ/slim
	build_path = /obj/item/rig/civilian/slim
	price = 100

/datum/design/item/rig/emergency/astro
	build_path = /obj/item/rig/emergency/astro
	price = 1000

/datum/design/item/rig/firesuit
	build_path = /obj/item/rig/firesuit
	price = 1000

/datum/design/item/rig/medical
	build_path = /obj/item/rig/medical
	price = 3000 //good against burns/toxins

/datum/design/item/rig/clown
	name = "ERROR_404_RIG_NOT_FOUND"
	desc = "//ERROR_404_DESCRIPTION_NOT_FOUND"
	build_path = /obj/item/rig/clown
	price = 42069

//Here, alternative civ rig visual styles would go, if we had some




//Tier I: standard protection and modules
/datum/design/item/rig/mining
	build_path = /obj/item/rig/mining
	price = 6000

/datum/design/item/rig/eng
	build_path = /obj/item/rig/engineering
	price = 6500 //moderate protection

/datum/design/item/rig/excavation
	build_path = /obj/item/rig/excavation
	price = 9000

/datum/design/item/rig/intermediate
	build_path = /obj/item/rig/intermediate
	price = 10000


//Tier II: high protection and advanced modules

/datum/design/item/rig/marksman
	build_path = /obj/item/rig/marksman
	price = 10500 //SSO

/datum/design/item/rig/pcsi
	build_path = /obj/item/rig/pcsi
	price = 11000 //armory rig

/datum/design/item/rig/sec
	build_path = /obj/item/rig/pcsi/security
	price = 11000 //standard security rig
/datum/design/item/rig/patrol
	build_path = /obj/item/rig/riot/patrol
	price = 12000 //standard security rig for patrol

/datum/design/item/rig/riot
	build_path = /obj/item/rig/riot
	price = 12000 //for melee combat, kinda worse at everything else

//Tier III: high protection and advanced modules

/datum/design/item/rig/vintage
	build_path = /obj/item/rig/vintage
	price = 17000	//tanky rig, slow

/datum/design/item/rig/advanced
	build_path = /obj/item/rig/advanced
	price = 17000 //good all-rounder, comes with great modules

/datum/design/item/rig/advanced/engineering
	build_path = /obj/item/rig/advanced/engineering
	price = 17000

/datum/design/item/rig/advanced/mining
	build_path = /obj/item/rig/advanced/mining
	price = 17000