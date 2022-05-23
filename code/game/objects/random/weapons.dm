/obj/random/gun
	name = "Random Gun"
	desc = "This is a random gun."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/gun/item_to_spawn()
	return pickweight(list(/obj/random/gun_tool = 1)) // Keep this in here for future diversification.

/obj/random/gun_tool
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/gun_tool/item_to_spawn()
	return pickweight(list(
	/obj/item/weapon/gun/projectile/ripper = 0.35,
	/obj/item/weapon/gun/energy/forcegun = 0.35,
	/obj/item/weapon/gun/energy/cutter = 0.9,
	/obj/item/weapon/gun/energy/cutter/plasma = 0.35,
	/obj/item/weapon/gun/projectile/linecutter = 0.35,
	/obj/item/weapon/gun/spray/hydrazine_torch = 0.9))

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"

/obj/random/ammo/item_to_spawn()
	return pickweight(list(/obj/item/ammo_magazine/pulse = 1.8,
	/obj/item/ammo_magazine/pulse/hv = 0.27,
	/obj/item/ammo_magazine/pulse/df = 0.27,
	/obj/item/weapon/cell/plasmacutter = 1.35,
	/obj/item/ammo_magazine/sawblades = 0.9,
	/obj/item/weapon/cell/force = 0.67,
	/obj/item/ammo_magazine/seeker = 0.9,
	/obj/item/weapon/cell/contact = 0.67,
	/obj/item/ammo_magazine/divet = 1.35,
	/obj/item/ammo_magazine/lineracks = 0.9,
	/obj/item/ammo_casing/tripmine = 0.9,
	/obj/item/weapon/reagent_containers/glass/fuel_tank/fuel = 0.9,
	/obj/item/weapon/reagent_containers/glass/fuel_tank/hydrazine = 0.4,
	/obj/item/ammo_magazine/shotgun = 0.9,
	/obj/item/ammo_magazine/javelin = 0.35))


//This subtype only spawns ammo for security/military-type weapons
/obj/random/ammo/security/item_to_spawn()
	return pickweight(list(/obj/item/ammo_magazine/pulse = 1.35,
	/obj/item/ammo_magazine/pulse/hv = 0.27,
	/obj/item/ammo_magazine/pulse/df = 0.27,
	/obj/item/ammo_magazine/seeker = 0.9,
	/obj/item/ammo_magazine/divet = 1.35,
	/obj/item/ammo_magazine/shotgun = 0.9))