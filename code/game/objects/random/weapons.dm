/obj/random/gun
	name = "Random Gun"
	desc = "This is a random gun."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"
	spawn_nothing_percentage = USUALLY

/obj/random/gun/item_to_spawn()
	return pickweight(list(/obj/random/gun_tech = 1, /obj/random/gun_security = 1.5, /obj/random/gun_tool = 3))

/obj/random/gun_tech
	name = "Random Energy Weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/gun_tech/item_to_spawn()
	return pickweight(list(/obj/item/gun/energy/contact = 1))


/obj/random/gun_security
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/gun_security/item_to_spawn()
	return pickweight(list(/obj/item/gun/projectile/automatic/pulse_rifle = 1.5,
	///obj/item/gun/projectile/automatic/bullpup = 0.5,	//We dont want this to be used by security
	/obj/item/gun/projectile/divet = 2,
	/obj/item/gun/projectile/seeker = 0.8,
	/obj/item/gun/projectile/shotgun/bola_lancher = 1))

/obj/random/gun_tool
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/gun_tool/item_to_spawn()
	return pickweight(list(
	/obj/item/gun/projectile/ripper = 0.6,
	/obj/item/gun/energy/forcegun = 0.8,
	/obj/item/gun/energy/cutter = 1.2,
	/obj/item/gun/energy/cutter/plasma = 0.8,
	/obj/item/gun/projectile/linecutter = 0.5,
	/obj/item/gun/projectile/detonator/loaded = 1,
	/obj/item/gun/spray/hydrazine_torch = 0.5))

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"

/obj/random/handgun/item_to_spawn()
	return pickweight(list(/obj/item/gun/projectile/divet = 1))

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"

/obj/random/ammo/item_to_spawn()
	return pickweight(list(/obj/item/ammo_magazine/pulse = 2,
	/obj/item/ammo_magazine/pulse/hv = 0.3,
	/obj/item/ammo_magazine/pulse/df = 0.3,
	/obj/item/cell/plasmacutter = 1.5,
	/obj/item/ammo_magazine/sawblades = 1,
	///obj/item/ammo_magazine/bullpup = 1,
	/obj/item/cell/force = 0.75,
	/obj/item/ammo_magazine/seeker = 1,
	/obj/item/cell/contact = 0.75,
	/obj/item/ammo_magazine/divet = 1.5,
	/obj/item/ammo_magazine/lineracks = 1,
	/obj/item/ammo_casing/tripmine = 1,
	/obj/item/reagent_containers/glass/fuel_tank/fuel = 1,
	/obj/item/reagent_containers/glass/fuel_tank/hydrazine = 0.4,
	/obj/item/ammo_magazine/shotgun = 1,
	/obj/item/ammo_magazine/javelin = 0.5))


//This subtype only spawns ammo for security/military-type weapons
/obj/random/ammo/security/item_to_spawn()
	return pickweight(list(/obj/item/ammo_magazine/pulse = 1.5,
	/obj/item/ammo_magazine/pulse/hv = 0.3,
	/obj/item/ammo_magazine/pulse/df = 0.3,
	/obj/item/ammo_magazine/seeker = 1,
	/obj/item/ammo_magazine/divet = 1.5,
	/obj/item/ammo_magazine/shotgun = 1))