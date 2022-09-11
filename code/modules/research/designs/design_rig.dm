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
/datum/design/item/rig/sec
	build_path = /obj/item/rig/security

/datum/design/item/rig/eng
	build_path = /obj/item/rig/engineering

/datum/design/item/rig/fire
	build_path = /obj/item/rig/firesuit

/datum/design/item/rig/medical
	build_path = /obj/item/rig/medical

/datum/design/item/rig/excavation
	build_path = /obj/item/rig/excavation

/datum/design/item/rig/mining
	build_path = /obj/item/rig/mining
	price = 4000 //cheaper, lower stats





//Tier II: high protection and advanced modules
/datum/design/item/rig/patrol
	build_path = /obj/item/rig/patrol
	price = 12000

/datum/design/item/rig/riot
	build_path = /obj/item/rig/riot
	price = 15000

/datum/design/item/rig/vintage
	build_path = /obj/item/rig/vintage
	price = 12000	//Its outdated and has drawbacks

/datum/design/item/rig/advanced
	build_path = /obj/item/rig/advanced
	price = 15000

/datum/design/item/rig/marksman
	build_path = /obj/item/rig/marksman
	price = 9000

/datum/design/item/rig/pcsi
	build_path = /obj/item/rig/security/pcsi
	price = 9000