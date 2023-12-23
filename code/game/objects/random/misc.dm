/obj/random/rare
	name = "random tool"
	icon_state = "tool-grey"
	spawn_nothing_percentage = 0
	has_postspawn = TRUE


/obj/random/rare/item_to_spawn()
	return pickweight(list(/obj/random/gun  = 1, /obj/item/stack/power_node = 1))



/obj/random/maintenance //Clutter and loot for maintenance and away missions
	name = "random maintenance item"
	desc = "This is a random maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/maintenance/item_to_spawn()
	return pickweight(list(/obj/random/junk = 3,
				/obj/random/trash = 3,
				/obj/random/maintenance/clean = 5))

/obj/random/maintenance/clean
/*Maintenance loot lists without the trash, for use inside things.
Individual items to add to the maintenance list should go here, if you add
something, make sure it's not in one of the other lists.*/
	name = "random clean maintenance item"
	desc = "This is a random clean maintenance item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"

/obj/random/maintenance/clean/item_to_spawn()
	return pickweight(list(/obj/random/tech_supply = 70,
				/obj/random/tool = 150,
				/obj/random/medical = 40,
				/obj/random/medical/lite = 80,
				/obj/random/firstaid = 20,
				/obj/random/powercell = 50,
				/obj/random/technology_scanner = 80,
				/obj/random/bomb_supply = 80,
				/obj/random/contraband = 1,
				/obj/random/action_figure = 2,
				/obj/random/plushie = 2,
				/obj/random/material = 40,
				/obj/random/coin = 5,
				/obj/random/toy = 20,
				/obj/random/tank = 20,
				/obj/random/soap = 5,
				/obj/random/drinkbottle = 5,
				/obj/random/loot = 1,
				/obj/random/advdevice = 50,
				/obj/random/smokes = 30,
				/obj/random/masks = 10,
				/obj/random/snack = 60,
				/obj/random/storage = 30,
				/obj/random/shoes = 20,
				/obj/random/gloves = 10,
				/obj/random/glasses = 20,
				/obj/random/hat = 10,
				/obj/random/suit = 20,
				/obj/random/clothing = 30,
				/obj/random/accessory = 20,
				/obj/random/cash = 10))



/obj/random/pouch
	name = "random pouch"
	icon_state = "box-green"

/obj/random/pouch/item_to_spawn()
	return pickweight(list(
	/obj/item/storage/pouch/small_generic = 10,
	/obj/item/storage/pouch/medium_generic = 5,
	/obj/item/storage/pouch/large_generic = 1,
	/obj/item/storage/pouch/medical_supply = 3,
	/obj/item/storage/pouch/engineering_supply = 3,
	/obj/item/storage/pouch/engineering_tools = 5,
	/obj/item/storage/pouch/tubular = 7,
	/obj/item/storage/pouch/ammo = 3,
	/obj/item/storage/pouch/pistol_holster = 3,
	/obj/item/storage/pouch/baton_holster = 3
	))

/obj/random/pouch/low_chance
	name = "low chance random pouch"
	icon_state = "box-green-low"
	spawn_nothing_percentage = 80

/obj/random/scaf
	name = "possible scaf equipment"
	spawn_nothing_percentage = 20

/obj/random/scaf/item_to_spawn() //total weight = 100
	return pickweight(list(
	/obj/item/rig/arctic = 4,
	/obj/item/rig/scaf/elite = 4,
	/obj/item/rig/scaf/legionnaire = 4,
	/obj/item/gun/projectile/automatic/bullpup = 10,
	/obj/item/ammo_magazine/bullpup = 18,
	/obj/random/medical = 15,
	/obj/random/tool = 15,
	/obj/random/trash = 15,
	/obj/random/junk = 15
	))

/obj/random/mines
	name = "possible mine deployments"
	spawn_nothing_percentage = 60

/obj/random/mines/item_to_spawn()
	return pickweight(list(
		/obj/effect/mine = 10,
		/obj/effect/mine/stun = 90
	))

/obj/random/antagrig
	name = "possible antag rig spawn"
	spawn_nothing_percentage = 90

/obj/random/zealotrig/item_to_spawn()
	return pickweight(list(
	/obj/item/rig/zealot = 50,
	/obj/item/rig/marine/earthgov = 50
	))

/obj/random/unihideoutbodies
	name = "possible preserved corpses"
	spawn_nothing_percentage = 75

/obj/random/unihideoutbodies/item_to_spawn()
	return pickweight(list(
		/obj/effect/landmark/corpse = 1
	))
