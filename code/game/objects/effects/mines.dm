/obj/effect/mine
	name = "Mine"
	desc = "I Better stay away from that thing."
	density = 1
	anchored = 1
	plane = OBJ_PLANE
	layer = OBJ_LAYER
	icon = 'icons/obj/weapons.dmi'
	icon_state = "uglyminearmed"
	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = 0
	var/step_detonate = TRUE
	var/fuse_timer = 0

/obj/effect/mine/Initialize()
	.=..()

	if (fuse_timer)
		addtimer(CALLBACK(src, /obj/effect/mine/proc/detonate), fuse_timer, TIMER_STOPPABLE)

/obj/effect/mine/proc/is_valid_target(var/atom/movable/enterer)
	//Leapers can leap over
	if (enterer.pass_flags & PASS_FLAG_FLYING)
		return FALSE

	var/trigger = FALSE

	if (enterer.density)
		trigger = TRUE

	else if (isliving(enterer))
		var/mob/living/L = enterer
		if (L.mob_size >= MOB_MEDIUM)
			trigger = TRUE


	//if (trigger)

	return trigger

/obj/effect/mine/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/effect/mine/Bumped(mob/M as mob|obj)

	if(triggered)
		return

	if (!step_detonate)
		return

	if (!is_valid_target(M))
		return
	detonate(M)


/obj/effect/mine/proc/detonate(var/tripper)
	if (triggered)
		return

	if (tripper)
		visible_message(SPAN_DANGER("[tripper] triggers the [src]!"))
	triggered = 1
	call(src,triggerproc)(tripper)

/obj/effect/mine/proc/triggerrad(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	obj:radiation += 50
	randmutb(obj)
	domutcheck(obj,null)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerstun(obj)
	if(ismob(obj))
		var/mob/M = obj
		M.Stun(30)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggern2o(obj)
	//example: n2o triggerproc
	//note: im lazy

	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerphoron(obj)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas(MATERIAL_PHORON, 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	spawn(0)
		qdel(src)

/obj/effect/mine/proc/triggerkick(obj)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	qdel(obj:client)
	spawn(0)
		qdel(src)

/obj/effect/mine/proc/explode(obj)
	explosion(4, 2)
	spawn(0)
		qdel(src)

/obj/effect/mine/dnascramble
	name = "Radiation Mine"
	icon_state = "uglymine"
	triggerproc = "triggerrad"

/obj/effect/mine/phoron
	name = "Phoron Mine"
	icon_state = "uglymine"
	triggerproc = "triggerphoron"

/obj/effect/mine/kick
	name = "Kick Mine"
	icon_state = "uglymine"
	triggerproc = "triggerkick"

/obj/effect/mine/n2o
	name = "N2O Mine"
	icon_state = "uglymine"
	triggerproc = "triggern2o"

/obj/effect/mine/stun
	name = "Stun Mine"
	icon_state = "uglymine"
	triggerproc = "triggerstun"


/*
	A mine projectile does not deal direct damage to mobs. Its goal is to impact with a wall or floor, whereupon it will deploy itself there
	Deployment involves creating another object and deleting ourselves
*/
/obj/item/projectile/deploy
	kill_count = 10	//These are generally short ranged
	var/deploy_type = /obj/effect/mine
	var/deployed = FALSE	//Set true when we are deployed
	damage = 0
	grippable = TRUE
	var/sticky = TRUE
	var/datum/mount_parameters/MP
	var/mount_type = /datum/extension/mount/sticky

/obj/item/projectile/deploy/Initialize()
	if (sticky)
		create_mount_parameters()


/obj/item/projectile/deploy/proc/create_mount_parameters()
	MP = new()
	MP.attach_walls	=	TRUE	//Can this be attached to wall turfs?
	MP.attach_anchored	=	TRUE	//Can this be attached to anchored objects, eg heaving machinery
	MP.attach_unanchored	=	TRUE	//Can this be attached to unanchored objects, like janicarts?
	MP.dense_only = TRUE	//If true, only sticks to dense atoms
	MP.attach_mob_standing		=	FALSE		//Can this be attached to mobs, like brutes?
	MP.attach_mob_downed		=	FALSE	//Can this be/remain attached to mobs that are lying down?
	MP.attach_mob_dead	=	FALSE	//Can this be/remain attached to mobs that are dead?

//Mines can be aimed at the floor, they will deploy when they enter the target tile
/obj/item/projectile/deploy/Move(var/atom/new_loc,var/direction)
	.=..()
	if (!expired && get_turf(new_loc) == get_turf(original))
		expire()

/obj/item/projectile/deploy/on_impact(var/atom/A)
	//We have hit something, maybe we can stick to it!
	if (sticky && !deployed)
		if (is_valid_mount_target(A, MP))
			//Yes we can!
			deploy_to_atom(A, get_turf(src))

/obj/item/projectile/deploy/expire()
	deploy_to_floor(get_turf(src))

	.=..()


/obj/item/projectile/deploy/proc/deploy_to_floor(var/turf/T)
	set waitfor = FALSE
	if (deployed)
		return
	deployed = TRUE
	sleep()
	new deploy_type(T, src)


/obj/item/projectile/deploy/proc/deploy_to_atom(var/atom/A, var/turf/origin)

	set waitfor = FALSE
	if (deployed)
		return
	deployed = TRUE
	sleep()
	var/atom/movable/deployable = new deploy_type(origin, src)
	mount_to_atom(deployable, A, mount_type = src.mount_type, WP = MP)
