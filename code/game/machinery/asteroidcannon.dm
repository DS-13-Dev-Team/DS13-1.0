GLOBAL_VAR_INIT(asteroid_cannon, null)

/obj/machinery/asteroidcannon
	name = "Asteroid Defense System"
	desc = "A huge machine that shoots down oncoming asteroids."
	icon = 'icons/obj/asteroidcannon.dmi'
	icon_state = "asteroidgun"
	bound_height = 128
	bound_width = 128
	density = TRUE
	anchored = TRUE
	var/datum/extension/asteroidcannon/AC = null

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
	var/mob/observer/eye/eyeobj = null

/datum/extension/asteroidcannon/Process()
	if(gunner) //We've got a gunner, don't fire.
		return
	//Eye sanity checking.
	if(eyeobj && eyeobj.x < gun.x)
		to_chat(world, "snap")
		eyeobj.setLoc(gun.x, eyeobj.y)

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
	gun.vis_contents += gunner
	eyeobj = new /mob/observer/eye(get_turf(gun))
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
	START_PROCESSING(SSobj, src)