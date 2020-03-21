/obj/random/gun
	name = "Random Gun"
	desc = "This is a random gun."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/gun/item_to_spawn()
	return pickweight(list(/obj/random/gun_tech = 1, /obj/random/gun_security = 1.5, /obj/random/gun_tool = 2))

/obj/random/gun_tech
	name = "Random Energy Weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "energykill100"

/obj/random/gun_tech/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/energy/contact = 1))


/obj/random/gun_security
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/gun_security/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/projectile/automatic/pulse_rifle = 1,
	/obj/item/weapon/gun/projectile/automatic/bullpup = 0.5,
	/obj/item/weapon/gun/projectile/divet = 2,
	/obj/item/weapon/gun/projectile/seeker = 1))

/obj/random/gun_tool
	name = "Random Projectile Weapon"
	desc = "This is a random projectile weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"

/obj/random/gun_tool/item_to_spawn()
	return pickweight(list(
	/obj/item/weapon/gun/projectile/ripper = 0.5,
	/obj/item/weapon/gun/energy/forcegun = 0.5,
	/obj/item/weapon/gun/energy/cutter = 1,
	/obj/item/weapon/gun/energy/cutter/plasma = 0.5))

/obj/random/handgun
	name = "Random Handgun"
	desc = "This is a random sidearm."
	icon = 'icons/obj/gun.dmi'
	icon_state = "secgundark"

/obj/random/handgun/item_to_spawn()
	return pickweight(list(/obj/item/weapon/gun/projectile/divet = 1))

/obj/random/ammo
	name = "Random Ammunition"
	desc = "This is random ammunition."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "45-10"

/obj/random/ammo/item_to_spawn()
	return pickweight(list(/obj/item/ammo_magazine/pulse = 1.5,
	/obj/item/weapon/cell/plasmacutter = 1.5,
	/obj/item/ammo_magazine/sawblades = 1,
	/obj/item/ammo_magazine/bullpup = 1,
	/obj/item/weapon/cell/force = 0.75,
	/obj/item/ammo_magazine/seeker = 1,
	/obj/item/weapon/cell/contact = 0.75,
	/obj/item/ammo_magazine/divet = 1.5))