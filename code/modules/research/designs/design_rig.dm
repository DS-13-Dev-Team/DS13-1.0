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
	build_path = /obj/item/weapon/rig/mining
	price = 4000





//Tier II: Advanced rigs with fancy modules or armor
/datum/design/item/rig/patrol
	build_path = /obj/item/weapon/rig/patrol
	price = 12000

/datum/design/item/rig/riot
	build_path = /obj/item/weapon/rig/riot
	price = 15000

/datum/design/item/rig/vintage
	build_path = /obj/item/weapon/rig/vintage
	price = 10000	//Its outdated and has drawbacks

/datum/design/item/rig/advanced
	build_path = /obj/item/weapon/rig/advanced
	price = 15000