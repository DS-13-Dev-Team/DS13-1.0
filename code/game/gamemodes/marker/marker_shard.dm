/*
	A small chunk taken from the marker. When left alone (and active) for a while, it will begin spreading corruption

	It activates at the same time as the marker
*/

/obj/item/marker_shard
	name = "strange rock"
	desc = "It's covered in odd writing."
	icon = 'icons/obj/marker_shard.dmi'
	icon_state = "marker_shard_dormant"
	randpixel = 0

	var/active = FALSE
	plane = ABOVE_OBJ_PLANE

	//How long does the shard have to remain in one spot before it starts spreading corruption?
	var/deploy_time = 3// MINUTES
	var/deploy_timer

	//Thing we're usign to manage our corruption
	var/datum/extension/corruption_source/CS

	//Last place we were
	var/last_known_location

	var/corruption_range = 9
	var/corruption_speed = 0.8
	var/corruption_falloff = 0.8
	var/corruption_limit = 100

	visualnet_range = 3

/obj/item/marker_shard/Initialize()
	.=..()
	last_known_location = loc
	var/obj/machinery/marker/M = get_marker()
	if (M && M.active)
		activate()

	SSnecromorph.register_shard(src)
	GLOB.necrovision.add_source(src)


/obj/item/marker_shard/Destroy()
	SSnecromorph.unregister_shard(src)
	.=..()


/obj/item/marker_shard/update_icon()
	if (active)
		icon_state = "marker_shard_active"
		set_light(1, 1, 8, 2, COLOR_MARKER_RED)
	else
		icon_state = "marker_shard_dormant"
		set_light(0)


//The shard reveals an area around it, seeing through walls
/obj/item/marker_shard/get_visualnet_tiles(var/datum/visualnet/network)
	return trange(visualnet_range, get_turf(src))

/*
	Activation and timer
*/
/obj/item/marker_shard/proc/activate()
	active = TRUE

	GLOB.moved_event.register(src, src, /obj/item/marker_shard/moved)
	set_deploy_timer()
	update_icon()

/obj/item/marker_shard/proc/deactivate()
	active = FALSE

	GLOB.moved_event.unregister(src, src, /obj/item/marker_shard/moved)
	update_icon()

/obj/item/marker_shard/proc/set_deploy_timer()
	deltimer(deploy_timer)
	if (active)
		deploy_timer = addtimer(CALLBACK(src, /obj/item/marker_shard/proc/attempt_deploy),  deploy_time)

//Whenever we move, reset the timer
/obj/item/marker_shard/moved()
	undeploy()
	last_known_location = loc
	set_deploy_timer()



/*
	Deployment
*/
/obj/item/marker_shard/proc/undeploy()

	//Remove our source, this will cause any vines we spread to lose their source
	//They will attempt to connect to another source in range, and if that fails, will start dying off
	remove_extension(src, /datum/extension/corruption_source)


//This should never fail, do safety checks first
/obj/item/marker_shard/proc/deploy()
	CS = set_extension(src, /datum/extension/corruption_source, corruption_range, corruption_speed, corruption_falloff, corruption_limit)

//Here we check if we've stayed still since our location was last updated
/obj/item/marker_shard/proc/attempt_deploy()
	if (!active)
		return

	if (loc == last_known_location)
		//Yes!
		deploy()
	else
		last_known_location = loc
		set_deploy_timer()	//Nop, update the location and wait another 3 mins



/*
	Verb
*/
/mob/proc/jump_to_shard()
	set name = "Jump to Shard"
	set desc = "Cycles between marker shards active in the world"
	set category = "Necromorph"


	//This lets us use the verb repeatedly to cycle through shards
	SSnecromorph.last_shard_jumped_to = Wrap(SSnecromorph.last_shard_jumped_to+1, 1, SSnecromorph.shards.len)
	var/obj/item/marker_shard/MS = SSnecromorph.shards[SSnecromorph.last_shard_jumped_to]
	if (MS)
		jumpTo(get_turf(MS))