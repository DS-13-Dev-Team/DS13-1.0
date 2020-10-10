/obj/item/weapon/gun/spray/hydrazine_torch



/*
	Spray guns

	The spray subtype is used for guns that project a constant cone of fire, acid, cold, lightning, etc
*/
/obj/item/weapon/gun/spray

	firemodes = list(
		list(mode_name="flamethrower",  mode_type = /datum/firemode/sustained/spray),
		list(mode_name="grenade launcher",  ammo_cost = 25, windup_time = 0.5 SECONDS, windup_sound = 'sound/weapons/guns/fire/pulse_grenade_windup.ogg', projectile_type = /obj/item/projectile/bullet/impact_grenade, fire_delay=20)
		)


/obj/item/weapon/gun/spray/Fire
spray_ability(var/subtype = /datum/extension/spray,  var/atom/target, var/angle, var/length, var/stun, var/duration, var/cooldown, var/windup, var/mob/override_user = null, var/list/extra_data)


/obj/item/weapon/gun/spray/Process()
	if (!can_fire())
		stop_firing()


//This proc creates particles and applies effects
/obj/item/weapon/gun/spray/proc/spray()

/obj/item/weapon/gun/spray/stop_firing()
	update_firemode()
	update_click_handlers()


/*
	Firemode
*/
/datum/firemode/sustained/spray/fire
	spray_type = /datum/extension/spray/fire
	angle = 45
	range = 4