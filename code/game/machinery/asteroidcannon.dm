GLOBAL_VAR_INIT(asteroid_cannon, null)
GLOBAL_LIST_EMPTY(asteroids)

/obj/machinery/asteroidcannon
	name = "Asteroid Defense System"
	desc = "A huge machine that shoots down oncoming asteroids."
	icon = 'icons/obj/asteroidcannon.dmi'
	icon_state = "asteroidgun"
	bound_height = 128
	bound_width = 128
	density = TRUE
	anchored = TRUE
	dir = EAST //Ship faces east, so does big mega gun.
	var/lead_distance = 3 //How aggressively to lead each shot.
	var/firing_arc = 180
	var/fire_sound = 'sound/weapons/taser2.ogg'
	var/datum/extension/asteroidcannon/AC = null

/obj/machinery/asteroidcannon/ex_act(severity)
	return FALSE

/obj/item/projectile/bullet/asteroidcannon
	name = "Accelerated Tungsten Slug"
	icon_state = "asteroidcannon"
	damage = 100

/obj/item/projectile/bullet/asteroidcannon/Bump(atom/A, forced)
	. = ..()
	if(istype(A, /obj/effect/meteor))
		var/obj/effect/meteor/M = A
		M.visible_message("<span class='danger'>\The [M] breaks into dust!</span>")
		M.make_debris()
		qdel(M)
		qdel(src)

/obj/machinery/asteroidcannon/proc/fire_at(turf/T)
	if(Get_Angle(src, T) > firing_arc)
		return FALSE
	var/obj/item/projectile/bullet/asteroidcannon/bullet = new (get_turf(src))
	playsound(src, fire_sound, 100, 1)
	bullet.launch(T)

/obj/machinery/asteroidcannon/attack_hand(mob/user)
	start_gunning(user)

/obj/machinery/asteroidcannon/proc/start_gunning(mob/user)
	if(!isliving(user) || user.is_necromorph())
		return FALSE //No.
	AC.set_gunner(user)

/obj/machinery/asteroidcannon/Initialize(mapload, d)
	. = ..()
	if(GLOB.asteroid_cannon)
		message_admins("Duplicate asteroid cannon at [get_area(src)], [x], [y], [z] spawned!")
		return INITIALIZE_HINT_QDEL
	GLOB.asteroid_cannon = src
	//Sets up the overlay
	var/obj/asteroidover = new()
	asteroidover.forceMove(src)
	asteroidover.layer = layer + 0.1
	asteroidover.icon = icon
	asteroidover.icon_state = "asteroidgun_over"
	vis_contents += asteroidover
	//Give it the shooty bit
	set_extension(src, /datum/extension/asteroidcannon)
	AC = get_extension(src, /datum/extension/asteroidcannon) //Cached for later.

/datum/extension/asteroidcannon
	var/obj/machinery/asteroidcannon/gun = null
	var/mob/living/carbon/human/gunner = null
	var/mob/observer/eye/asteroidcannon/eyeobj = null

/mob/observer/eye/asteroidcannon
	var/obj/machinery/asteroidcannon/gun = null

/mob/observer/eye/asteroidcannon/EyeMove(direct)
	if((direct == WEST) && (src.x < gun.x)) //No looking behind you...
		setLoc(get_turf(locate(gun.x, y)))
		return FALSE
	. = ..()

/mob/observer/eye/asteroidcannon/Destroy()
	gun = null
	. = ..()

/datum/extension/asteroidcannon/Process()
	if(gunner) //We've got a gunner, don't fire.
		return
	if(!GLOB.asteroids || !GLOB.asteroids.len)
		return
	//Meteor targeting!
	var/obj/effect/meteor/ME = pick(GLOB.asteroids)
	//Lead your shots.
	var/turf/aim_at = get_turf(ME)
	if(ME.velocity)
		aim_at = get_turf(locate(ME.x - (ME.velocity.x * gun.lead_distance), ME.y - (ME.velocity.y * gun.lead_distance), ME.z))
	gun.fire_at(aim_at)

/mob/living/carbon/human/proc/stop_gunning()
	set name = "Stop Gunning"
	set category = "Asteroid Defense System"
	var/datum/extension/asteroidcannon/AC = get_extension(GLOB.asteroid_cannon, /datum/extension/asteroidcannon)
	AC.remove_gunner()

/mob/living/carbon/human/proc/recenter_gunning()
	set name = "Jump To Cannon"
	set category = "Asteroid Defense System"
	var/datum/extension/asteroidcannon/AC = get_extension(GLOB.asteroid_cannon, /datum/extension/asteroidcannon)
	AC.recenter()

/datum/extension/asteroidcannon/proc/target_click(var/mob/user, var/atom/target, var/params)
	gun.fire_at(get_turf(target))

/datum/click_handler/target/asteroidcannon/stop()
	var/mob/living/carbon/human/H = user
	H.stop_gunning()
	. = ..()

/**
	Sets up the cannon for manual aiming, removes the autofire ability.
*/
/datum/extension/asteroidcannon/proc/set_gunner(mob/living/carbon/human/gunner)
	if(src.gunner)
		remove_gunner()
	src.gunner = gunner
	gunner.verbs |= /mob/living/carbon/human/proc/stop_gunning
	gunner.verbs |= /mob/living/carbon/human/proc/recenter_gunning
	gunner.forceMove(gun)
	gunner.pixel_x = 32
	gunner.pixel_y = 32
	gunner.set_dir(8)
	gunner.PushClickHandler(/datum/click_handler/target/asteroidcannon, CALLBACK(src, /datum/extension/asteroidcannon/proc/target_click, gunner))
	gun.vis_contents += gunner
	eyeobj = new /mob/observer/eye/asteroidcannon(get_turf(gun))
	eyeobj.gun = gun
	eyeobj.acceleration = FALSE
	eyeobj.possess(gunner)

/datum/extension/asteroidcannon/proc/recenter()
	eyeobj?.setLoc(get_turf(gun))

/datum/extension/asteroidcannon/proc/remove_gunner()
	qdel(eyeobj)
	gunner.verbs -= /mob/living/carbon/human/proc/stop_gunning
	gunner.verbs -= /mob/living/carbon/human/proc/recenter_gunning
	gunner.eyeobj = null
	gunner.forceMove(get_turf(gun))
	gunner.pixel_x = 0
	gunner.pixel_y = 0
	gun.vis_contents -= gunner
	gunner = null

/datum/extension/asteroidcannon/New(datum/holder)
	if(!istype(holder, /obj/machinery/asteroidcannon))
		return FALSE
	gun = holder
	START_PROCESSING(SSfastprocess, src)