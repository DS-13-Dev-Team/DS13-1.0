/*
	Detonator Gun
*/
/obj/item/weapon/gun/projectile/detonator
    name = "detonator"
    desc = "A unique gun that can place tripmines from a distance."
    icon = 'icons/obj/weapons/ds13guns48x32.dmi'
    icon_state = "detonator_unloaded"
    item_state = "detonator_unloaded"
    wielded_item_state = "detonator-wielded"
    slot_flags = SLOT_BELT | SLOT_BACK
    w_class = ITEM_SIZE_HUGE
    max_shells = 6
    caliber = "tripmine"
    handle_casings = CLEAR_CASINGS
    fire_delay = 5
    fire_sound = ""
    load_sound = ""
    projectile_type = /obj/item/projectile/deploy/detonator

    var/list/deployed_mines = list()
    firemodes = list(
	list(mode_name = "minelayer", mode_type = /datum/firemode),
	list(mode_name = "mine retrieval", mode_type = /datum/firemode/tripmine)
	)



/*
	Firemode
	Detonates all rivets
*/
/datum/firemode/tripmine
	override_fire = TRUE

/datum/firemode/tripmine/fire(var/atom/target, var/mob/living/user, var/clickparams, var/pointblank=0, var/reflex=0)
	var/obj/item/weapon/gun/projectile/detonator/R = gun
	if (R.deployed_mines.len)
		var/obj/effect/mine/trip/M = R.deployed_mines[R.deployed_mines.len]
		R.deployed_mines -= M
		M.disarm()
	else
		to_chat(user, "There are no active mines.")


/obj/item/weapon/gun/projectile/detonator/loaded
    ammo_type = /obj/item/ammo_casing/tripmine

/obj/item/weapon/gun/projectile/detonator/update_icon()
    if(getAmmo())
        icon_state = "detonator_loaded"
    else
        icon_state = "detonator"


/*
	Unfired mine
*/
/obj/item/ammo_casing/tripmine
	caliber = "tripmine"
	icon = 'icons/obj/weapons/ds13_deployables.dmi'
	icon_state = "detonator_mine"
	randpixel = 12

/obj/item/ammo_casing/tripmine/Initialize()
	.=..()
	transform = transform.Turn(rand(0, 360))

/*
	Deployment projectile
*/
/datum/extension/mount/sticky/mine
	pixel_offset_magnitude = -16

/obj/item/projectile/deploy/detonator
	mount_type = /datum/extension/mount/sticky/mine
	deploy_type = /obj/effect/mine/trip


/*
	Laser effect
*/
/obj/effect/projectile/tether/triplaser
	icon = 'icons/effects/tethers.dmi'
	icon_state = "triplaser"
	base_length = WORLD_ICON_SIZE*2
	start_offset = new /vector2(-16,0)
/*
	Deployed mine
*/
/obj/effect/mine/trip
	name = "Laser Tripmine"
	icon = 'icons/obj/weapons/ds13_deployables.dmi'
	icon_state = "detonator_mine"
	var/setup_time = 1.35 SECONDS
	var/obj/effect/projectile/tether/triplaser/laser
	var/max_laser_range = 20	//How far the laser extends, in tiles
	var/gunref	//We'll save a weak link to our launcher
	var/disarmed_type = /obj/item/ammo_casing/tripmine

/obj/effect/mine/trip/New(var/atom/newloc, var/obj/item/projectile/deploy/projectile)

	.=..()
	var/obj/item/weapon/gun/projectile/detonator/D = projectile.launcher
	D.deployed_mines += src
	gunref = "\ref[D]"

/obj/effect/mine/trip/explode(var/atom/victim)
	if (triggered)
		return
	triggered = TRUE
	shoot_ability(target = victim, projectile_type = /obj/item/projectile/bullet/detonator_round, accuracy = 140, cooldown = 0)
	shoot_ability(target = victim, projectile_type = /obj/item/projectile/bullet/detonator_round, accuracy = 140, cooldown = 0)
	shoot_ability(target = victim, projectile_type = /obj/item/projectile/bullet/detonator_round, accuracy = 140, cooldown = 0)
	explosion(loc, -1, 1, 2, 2)
	spawn(0)
		qdel(src)

/obj/effect/mine/trip/proc/disarm()
	if (triggered || QDELETED(src))
		return
	triggered = TRUE
	new disarmed_type(get_turf(src))
	qdel(src)

/obj/effect/mine/trip/Destroy()
	var/obj/item/weapon/gun/projectile/detonator/D 	= locate(gunref)
	if (D)
		D.deployed_mines -= src
	gunref = null
	QDEL_NULL(laser)
	.=..()

/obj/effect/mine/trip/on_mount(var/datum/extension/mount/ME)
	icon_state = "detonator_mine_deployed"

	spawn(setup_time)
		laser = new (loc)
		//Which way are we pointing our laser?
		var/vector2/laser_direction = Vector2.SmartDirectionBetween(ME.mountpoint, src)
		var/vector2/tile_offset = laser_direction * max_laser_range

		var/turf/target_turf = locate(x + tile_offset.x, y+tile_offset.y, z)
		world << "Detonator mine targeting [target_turf]"

		if (!target_turf)
			return

		var/list/results = check_trajectory_verbose(target_turf, src)

		target_turf = results[2]	//This contains the turf that the projectile managed to reach, its where we will aim
		world << "Detonator laser reached [target_turf]"

		var/vector2/start = get_global_pixel_loc()
		var/vector2/start_offset = get_new_vector(0, -12)
		start_offset.SelfTurn(ME.mount_angle)

		var/vector2/end = target_turf.get_global_pixel_loc()

		laser.set_ends(start, end)


		//Setup a trigger to track nearby mobs
		var/datum/proximity_trigger/solidline/PT = new (holder = src, on_turf_entered = /obj/effect/mine/trip/proc/tripped, range = max_laser_range, extra_args = list(target_turf))
		PT.register_turfs()
		set_extension(src, /datum/extension/proximity_manager, PT)

		release_vector(start)
		release_vector(start_offset)
		release_vector(end)
		release_vector(laser_direction)
		release_vector(tile_offset)


/obj/effect/mine/trip/proc/tripped(var/atom/movable/enterer)
	var/trigger = FALSE
	if (enterer.density)
		trigger = TRUE

	else if (isliving(enterer))
		var/mob/living/L = enterer
		if (L.mob_size >= MOB_MEDIUM)
			trigger = TRUE

	if (trigger)
		explode(enterer)


/*
	Hypersonic Rounds
	On detonation, the mine fires three bullets along the laser, which do most of the damage
*/
/obj/item/projectile/bullet/detonator_round
	icon_state = "seeker"
	damage = 30
	embed = 1
	structure_damage_factor = 3
	penetration_modifier = 1.25
	penetrating = TRUE
	step_delay = 0.5	//veryyyy fast
	expiry_method = EXPIRY_FADEOUT
	fire_sound = ""
	stun = 2
	weaken = 2
	penetrating = 5
	armor_penetration = 15