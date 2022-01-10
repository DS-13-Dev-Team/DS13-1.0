/obj/machinery/atmospherics/var/image/pipe_image

/obj/machinery/atmospherics/Destroy()
	for(var/mob/living/M in src) //ventcrawling is serious business
		M.remove_ventcrawl()
		M.forceMove(get_turf(src))
	if(pipe_image)
		for(var/mob/living/M in GLOB.player_list)
			if(M.client)
				M.client.images -= pipe_image
				M.pipes_shown -= pipe_image
		pipe_image = null
	. = ..()

/obj/machinery/atmospherics/ex_act(severity,var/atom/epicentre)
	for(var/atom/movable/A in src) //ventcrawling is serious business
		A.ex_act(severity, epicentre)
	. = ..()

/obj/machinery/atmospherics/relaymove(mob/living/user, direction)

	if(user.loc != src || !(direction & initialize_directions)) //can't go in a way we aren't connecting to
		return
	ventcrawl_to(user,findConnecting(direction),direction)

/obj/machinery/atmospherics/proc/ventcrawl_to(var/mob/living/user, var/obj/machinery/atmospherics/target_move, var/direction)
	to_chat(world,"[src] Ventcrawl to [target_move]")
	if(target_move)
		/*
		if(is_type_in_list(target_move, ventcrawl_machinery) && target_move.can_crawl_through())
			to_chat(world,"Crawling out of target")
			return ventcrawl_exit(user, get_turf(target_move))
		*/
		
		if(target_move.can_crawl_through())
			to_chat(world,"Crawling through target")
			if(target_move.return_network(target_move) != return_network(src))
				user.remove_ventcrawl()
				user.add_ventcrawl(target_move)

			//Exit from this and enter into that
			ventcrawl_exit(user, target_move)
			target_move.ventcrawl_enter(user, src)
			user.client.eye = target_move //if we don't do this, Byond only updates the eye every tick - required for smooth movement
			if(world.time > user.next_play_vent)
				user.next_play_vent = world.time+30
				playsound(src, 'sound/machines/ventcrawl.ogg', 50, 1, -3)
	else
		if((direction & initialize_directions) || is_type_in_list(src, ventcrawl_machinery) && src.can_crawl_through()) //if we move in a way the pipe can connect, but doesn't - or we're in a vent
			//Exit from this and enter into its turf instead
			return ventcrawl_exit(user, get_turf(src))
	user.set_move_cooldown(user.movement_delay())

//Method called for the user to try to leave this vent by moving out.
/obj/machinery/atmospherics/proc/ventcrawl_exit(mob/living/user, atom/target_move)

	/*
	if(istype(target_move, /obj/machinery/atmospherics/unary/vent/pump/wall))
		//Jumpscare time...
		to_chat(user, "<span class='warning'>You are now lurking inside of [target_move]. Use the break-out verb to burst out of it... </span>")
		user.forceMove(target_move)
		return FALSE
	*/
	if (!istype(target_move, /obj/machinery/atmospherics))
		user.remove_ventcrawl()
		user.visible_message("You hear something squeezing through the ducts.", "You climb out the ventilation system.")
	user.forceMove(target_move) //handles entering and so on
	
	return TRUE
	

/*
	Called when a user enters this thing

	Oldloc will be a /obj/machinery/atmospherics if we were already in the pipes. 
	If its null or a turf, we came from outside
*/
/obj/machinery/atmospherics/proc/ventcrawl_enter(mob/living/user, atom/oldloc)

/obj/machinery/atmospherics/proc/can_crawl_through()
	return 1

/obj/machinery/atmospherics/unary/vent/pump/can_crawl_through()
	return !welded

/obj/machinery/atmospherics/unary/vent/scrubber/can_crawl_through()
	return !welded

/obj/machinery/atmospherics/proc/findConnecting(var/direction)
	for(var/obj/machinery/atmospherics/target in get_step(src,direction))
		if(target.initialize_directions & get_dir(target,src))
			if(isConnectable(target) && target.isConnectable(src))
				return target

/obj/machinery/atmospherics/proc/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node1 || target == node2)

/obj/machinery/atmospherics/pipe/manifold/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node3 || ..())

obj/machinery/atmospherics/trinary/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node3 || ..())

/obj/machinery/atmospherics/pipe/manifold4w/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node3 || target == node4 || ..())

/obj/machinery/atmospherics/tvalve/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node3 || ..())

/obj/machinery/atmospherics/pipe/cap/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node || ..())

/obj/machinery/atmospherics/portables_connector/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node || ..())

/obj/machinery/atmospherics/unary/isConnectable(var/obj/machinery/atmospherics/target)
	return (target == node || ..())

/obj/machinery/atmospherics/valve/isConnectable()
	return (open && ..())

//Fetches all pipes and machinery that should be visible for ventcrawling, in networks connected to this machine.
//We only go one level deep, we're not currently looking at other networks connected to those networks
/obj/machinery/atmospherics/proc/get_ventcrawl_machines_in_network()
	var/list/networks = get_attached_pipe_networks()
	var/list/machines = list()

	//TODO: Fetch networks attached to us
	for (var/datum/pipe_network/network in networks)
		for(var/datum/pipeline/pipeline in network.line_members)
			for(var/obj/machinery/atmospherics/A in (pipeline.members || pipeline.edges))
				machines += A

	return machines


/obj/machinery/atmospherics/proc/get_attached_pipe_networks()
	var/list/networks = list()
	var/datum/pipe_network/our_network = return_network(src)
	if (our_network)
		networks += our_network

	return networks