GLOBAL_VAR_INIT(asteroid_cannon, null)
GLOBAL_LIST_EMPTY(asteroids)
#define CANNON_FORWARD_DIR	EAST
#define CANNON_FIRING_ARC 45
#define CANNON_ROTATION_SPEED 75
/**

Asteroid cannon!

Links to a control console, can be sabotaged by hitting it a bunch of times.

If the cannon goes offline, you need to repair it with a welder to ensure it won't instantly offline again, then reboot its ADS systems with the console
You'll need two people to do this, one to man the gun while it goes down, one to do the actual repairs.


*/
/obj/structure/asteroidcannon
	name = "Asteroid Defense System"
	desc = "A huge machine that shoots down oncoming asteroids."
	icon = 'icons/obj/asteroidcannon_centred.dmi'
	icon_state = "asteroidgun"
	bound_height = 128
	bound_width = 128
	density = TRUE
	anchored = TRUE
	dir = EAST //Ship faces east, so does big mega gun.
	light_color="#ff0000" //Glows red when it's out of commission...
	health = 200
	max_health = 200 //Takes a lot of effort to take out.
	plane = ABOVE_OBJ_PLANE
	layer = ABOVE_OBJ_LAYER
	atom_flags = ATOM_FLAG_INDESTRUCTIBLE
	var/lead_distance = 0 //How aggressively to lead each shot. If set to 0 the bullets become hitscan.
	var/bullet_origin_offset = 3 //+/-x. Offsets the bullet so it can shoot "through the wall" to more closely mirror the source material's gun.

	var/fire_sound = 'sound/effects/asteroidcannon_fire.ogg'
	var/datum/extension/asteroidcannon/AC = null
	var/next_shot = 0
	var/fire_delay = 0.50 SECONDS
	var/operational = TRUE //Is it online?
	var/reboot_step = 0
	var/last_offline = 0 //When was it last taken offline? Used to spawn meteors when it's taken offline. Spite!
	var/firing = FALSE	//Set true when user is holding down fire button
	appearance_flags=KEEP_TOGETHER

	//Rotation handling
	var/datum/extension/rotate_facing/rotator
	var/atom/target
	var/firing_arc = CANNON_FIRING_ARC
	pixel_y = -64
	pixel_x = -144
	var/cached_plane
	var/deadzone = 10	//The angle towards the target must be <= this amount in order to fire at it
	var/vector2/forward_vector = CANNON_FORWARD_DIR
	var/vector2/offset_vector	//This is the offset we point towards when we return to neutral

/obj/structure/asteroidcannon/Initialize(mapload, d)
	. = ..()
	if(GLOB.asteroid_cannon)
		message_admins("Duplicate asteroid cannon at [get_area(src)], [x], [y], [z] spawned!")
		return INITIALIZE_HINT_QDEL
	GLOB.asteroid_cannon = src
	forward_vector = Vector2.FromDir(forward_vector)
	offset_vector = forward_vector * bullet_origin_offset
	offset_vector.SelfMultiply(WORLD_ICON_SIZE)

	//Sets up the overlay
	var/obj/asteroidover = new(loc)
	asteroidover.mouse_opacity = FALSE //Just a fluff overlay.
	asteroidover.plane = plane + 0.1
	asteroidover.layer = layer + 0.1
	asteroidover.icon = icon
	asteroidover.pixel_x = pixel_x
	asteroidover.pixel_y = pixel_y
	asteroidover.icon_state = "asteroidgun_over"

	//And the underlay
	var/obj/asteroidunder = new(loc)
	asteroidunder.mouse_opacity = FALSE //Just a fluff overlay.
	asteroidunder.plane = plane - 0.1
	asteroidunder.layer = layer - 0.1
	asteroidunder.icon = icon
	asteroidunder.pixel_x = pixel_x
	asteroidunder.pixel_y = pixel_y
	asteroidunder.icon_state = "asteroidgun_under"



	//Give it the shooty bit
	set_extension(src, /datum/extension/asteroidcannon)
	rotator = set_extension(src, /datum/extension/rotate_facing/asteroidcannon)
	AC = get_extension(src, /datum/extension/asteroidcannon) //Cached for later.


/obj/structure/asteroidcannon/attackby(obj/item/C, mob/user)
	. = ..()
	if(health < max_health)
		if(isWelder(C))
			if( C.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_NORMAL))
				to_chat(user, "<span class='notice'>You repair [src] with your welder...</span>")
				health = CLAMP(health, 0, max_health)

/obj/structure/asteroidcannon/take_damage(amount, damtype, user, used_weapon, bypass_resist)
	//The cannon can't be destroyed, but you can sure as hell knock it offline..
	if(health < amount)
		health = 10
		operational = FALSE
		visible_message("<span class='warning'>[src] sparks wildly!</span>")
		playsound(src, 'sound/effects/caution.ogg', 100, TRUE)
		//sparks
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, loc)
		spark_system.start()
		playsound(loc, "sparks", 50, 1)
		set_light(1)
		if(world.time >= last_offline + 5 MINUTES)
			var/datum/event/meteor_wave/E = new /datum/event/meteor_wave(new /datum/event_meta(pick(EVENT_LEVEL_MUNDANE, EVENT_LEVEL_MODERATE, EVENT_LEVEL_MAJOR))) //Don't let this thing get taken out.
			E.announce()
			last_offline = world.time
		return FALSE
	. = ..()

/obj/structure/asteroidcannon/proc/is_operational()
	return operational

/obj/structure/asteroidcannon/ex_act(severity)
	return FALSE

/obj/structure/asteroidcannon/proc/is_firing()
	return firing


/obj/structure/asteroidcannon/proc/fire_at(atom/T)
	if (!T)
		return

	var/delta = rotator.get_rotation_to_target(T)
	if (abs(delta) > deadzone)
		//We aren't pointed at the target yet, fail
		return

	var/turf/out = rotator.get_turf_infront(bullet_origin_offset)
	if(world.time < next_shot)
		return FALSE
	flick("asteroidgun_firing", src)
	next_shot = world.time + fire_delay
	var/obj/item/projectile/bullet/asteroidcannon/bullet = new(out)
	playsound(src, fire_sound, 100, 1)
	bullet.launch(T)

/obj/structure/asteroidcannon/attack_hand(mob/user)
	if (AC.gunner)
		stop_gunning()
	else
		start_gunning(user)


/obj/structure/asteroidcannon/proc/start_firing()
	firing = TRUE

/obj/structure/asteroidcannon/proc/stop_firing()
	firing = FALSE

/obj/structure/asteroidcannon/proc/start_gunning(mob/user)
	if(!isliving(user) || user.is_necromorph())
		return FALSE //No.
	if (AC.gunner)
		to_chat(user, SPAN_DANGER("The hotseat is occupied"))
		return
	AC.set_gunner(user)

/obj/structure/asteroidcannon/proc/stop_gunning(mob/user)
	AC.remove_gunner()
	unset_target()




/obj/structure/asteroidcannon/proc/set_target(var/atom/newtarget)
	if (target == newtarget || abs(rotator.get_total_rotation_to_target(newtarget)) > firing_arc || get_dist(src, newtarget) < bullet_origin_offset)
		//Too close or not in our angle
		return

	target = newtarget
	rotator.set_target(target)

/obj/structure/asteroidcannon/proc/unset_target()
	//This causes the gun to rotate back to neutral by aiming at a tile infront
	var/turf/T = get_turf_at_pixel_offset(offset_vector)
	set_target(T)

/*
	Projectile
*/
/obj/item/projectile/bullet/asteroidcannon
	name = "Accelerated Tungsten Slug"
	icon_state = "asteroidcannon"
	damage = 100
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/laser/xray/muzzle
	tracer_type = /obj/effect/projectile/laser/xray/tracer
	impact_type = /obj/effect/projectile/laser/xray/impact


/obj/item/projectile/bullet/asteroidcannon/Bump(atom/A, forced)
	. = ..()
	if(istype(A, /obj/effect/meteor))
		var/obj/effect/meteor/M = A
		M.visible_message("<span class='danger'>\The [M] breaks into dust!</span>")
		M.make_debris()
		qdel(M)
		qdel(src)




/datum/extension/rotate_facing/asteroidcannon
	max_rotation = CANNON_FIRING_ARC
	angular_speed = CANNON_ROTATION_SPEED
	active_track = TRUE
	forward_vector = CANNON_FORWARD_DIR	//The cannon faces right