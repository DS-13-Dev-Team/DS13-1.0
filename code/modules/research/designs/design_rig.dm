/datum/design/item/rig
	build_type = STORE
	category = "RIG"
	price = 8000
	store_transfer = TRUE



//Tier 0, unarmored/empty rigs
/datum/design/item/rig/civ
	build_path = /obj/item/weapon/rig/civilian
	price = 500

//Here, alternative civ rig visual styles would go, if we had some




//Tier I
/datum/design/item/rig/sec
	build_path = /obj/item/weapon/rig/security

/datum/design/item/rig/eng
	build_path = /obj/item/weapon/rig/engineering

/datum/design/item/rig/fire
	build_path = /obj/item/weapon/rig/firesuit

//This one is cheap and shoddy
/datum/design/item/rig/mining
	build_path = /obj/item/weapon/rig/mining/store
	price = 4400





//Tier II: Advanced rigs with fancy modules or armor
/datum/design/item/rig/patrol/store
	build_path = /obj/item/weapon/rig/patrol
	price = 16500

/datum/design/item/rig/riot
	build_path = /obj/item/weapon/rig/riot/store
	price = 20000 // Currently the beefiest thing we've got. Veeeery expensive.

/datum/design/item/rig/vintage
	build_path = /obj/item/weapon/rig/vintage/store
	price = 11000	//Its outdated and has drawbacks (But still QUITE Good, so 10% increase on May 24th, 2022)

/datum/design/item/rig/vintageheavy
	build_path = /obj/item/weapon/rig/vintage/heavy/store
	price = 19000

/datum/design/item/rig/advanced
	build_path = /obj/item/weapon/rig/advanced/store
	price = 16500

/datum/design/item/rig/marksman
	build_path = /obj/item/weapon/rig/marksman/store
	price = 10350
