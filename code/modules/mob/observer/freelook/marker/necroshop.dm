/*
	This file has all the code for the necromorph and corruption spawning interface, AKA necroshop.

	The marker player uses this shop to spend their stored biomass to create new units and corruption nodes
*/




/datum/necroshop
	var/obj/machinery/marker/host	//Where do we draw our biomass from?
	var/datum/necroshop_item/current	//What do we currently have selected for spawning or more detailed viewing?
	var/list/spawnable_necromorphs = list()
	var/datum/necrospawn/selected_spawn = null
	var/list/content_data	=	list()	//No need to regenerate this every second

/datum/necroshop/New(var/newhost)
	host = newhost

	//Lets construct the shop inventory

	//First up, necromorph species
	for (var/spath in subtypesof(/datum/species/necromorph))
		var/datum/species/necromorph/N = spath	//This lets us use initial
		N = all_species[initial(N.name)]
		if (!initial(N.marker_spawnable))
			continue	//Check this one is spawnable

		//Ok lets create a shop datum for them
		var/datum/necroshop_item/I = new()
		I.name = initial(N.name)
		I.desc = N.get_long_description()
		I.price = initial(N.biomass)
		I.spawn_method = initial(N.spawn_method)
		I.spawn_path = N.mob_type

		//And add it to the list
		spawnable_necromorphs[I.name] = I

		selected_spawn = new(host, host.name)

	//TODO: Corruption nodes next

	//Now cache the display data for the above
	generate_content_data()




//Datum for spawnpoints
/datum/necrospawn
	var/atom/spawnpoint				//Where are we spawning things?
	var/name = "Marker"				//What do we call this spawn location?
	//TODO: Support for a preview image of the area

/datum/necrospawn/New(var/atom/origin, var/newname)
	.=..()
	spawnpoint = origin
	name = newname

/datum/necroshop/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if (!authorised_to_view(user))
		return
	var/list/data = content_data.Copy()
	if (current)
		data["current"] = list("name" = current.name, "desc" = current.desc, "price" = current.price)

	data["biomass"]	=	round(host.biomass, 0.1)
	data["income"] = round(host.biomass_tick, 0.01)

	data["spawn"] = list("name" = selected_spawn.name, "x" = selected_spawn.spawnpoint.x, "y" = selected_spawn.spawnpoint.y, "z" = selected_spawn.spawnpoint.z)
	if (authorised_to_spawn(user))
		data["authorised"] = TRUE
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "necroshop.tmpl", "Spawning Menu", 800, 700, state = GLOB.interactive_state)
		ui.set_initial_data(data)
		ui.set_auto_update(1)
		ui.open()

/datum/necroshop/Topic(href, href_list)
	if(..())
		return
	if (href_list["select"])
		current = spawnable_necromorphs[href_list["select"]]


	if (href_list["spawn"])
		start_spawn()
	SSnano.update_uis(src)



//Generate and cache the common data
/datum/necroshop/proc/generate_content_data()
	content_data = list()

	var/list/listed_necromorphs = list()

	for(var/a in spawnable_necromorphs)
		var/datum/necroshop_item/I = spawnable_necromorphs[a]

		listed_necromorphs.Add(list(list("name" = I.name,
			"price" = I.price)))

	content_data["necromorphs"] = listed_necromorphs



//Safety Checks
//------------------
//Is this mob allowed to browse through the shop?
/datum/necroshop/proc/authorised_to_view(var/mob/M)
	//Anyone on the necro team is allowed
	if (M.is_necromorph())
		return TRUE

	//Admins are allowed
	if(M.client && check_rights(R_ADMIN|R_DEBUG, M.client))
		return TRUE

	return FALSE

//Is this mob allowed to spend biomass and spawn objects?
/datum/necroshop/proc/authorised_to_spawn(var/mob/M)
	//Only the marker player is allowed
	if (istype(M, /mob/observer/eye/signal/master))
		return TRUE

	//Admins are allowed
	if(M.client && check_rights(R_ADMIN|R_DEBUG, M.client))
		return TRUE

	return FALSE




//Spawns the currently selected thing at the currently selected spawnpoint.
//This is an entry that calls a few more procs
/datum/necroshop/proc/start_spawn()
	var/list/spawn_params = current.get_spawn_params(src)	//Attempt to get an exact place to spawn
	if (!spawn_params)
		//For manual placement spawns, this will return null and call finalize later, after the user clicks where to place it
		return

	finalize_spawn(spawn_params)


//This proc takes a list of spawn parameters, which is either constructed through get_spawn_params, or via a placement datum.
//It takes the biomass and creates the atom
//No other safety checks are done here, we will assume the params contain only correct info
/datum/necroshop/proc/finalize_spawn(var/list/params)
	//First, ensure that the host can pay the biomass
	if (!host_pay_biomass(params["name"], params["price"]))
		to_chat(params["user"], SPAN_DANGER("ERROR: Not enough biomass to spawn [params["name"]]"))
		return
	var/spawnpath = params["path"]
	var/atom/targetloc = params["target"]
	var/atom/newthing = new spawnpath(targetloc)
	var/mob/user = params["user"]
	if (!QDELETED(newthing))
		newthing.set_dir(params["dir"])
		to_chat(user, SPAN_NOTICE("Successfully spawned [newthing] at [jumplink(targetloc)]"))


//Attempts to subtract the relevant quantity of biomass from the host marker or whatever else
//Make sure this is the last step before spawning, it can't be allowed to fail after this
/datum/necroshop/proc/host_pay_biomass(var/purpose, var/amount)
	if (host.pay_biomass(purpose, amount))
		return TRUE




//Item and spawning
//------------------------------
//These datums are created at runtime
/datum/necroshop_item
	var/name = "Thing"	//User facing
	var/desc = "stuff"
	var/price	=	1	//price in biomass
	var/spawn_method	= SPAWN_POINT	//Do we spawn around a point or manual placement?
	var/spawn_path		=	null		//What atom will we actually spawn?


//This function has two modes.
//For spawning at a point, it will find an exact location and return a list of parameters which will then be passed to finalise_spawn
//For manual placement spawning, it will immediately return null to terminate that process, and create a datum which will handle the placement and user input
	//That datum, once a spot is selected, will generate its own parameters and call finalize_spawn directly on its own
/datum/necroshop_item/proc/get_spawn_params(var/datum/necroshop/caller)
	.=null
	if (spawn_method == SPAWN_POINT)
		var/list/params = list()
		params["name"] = name
		params["origin"] = caller.selected_spawn.spawnpoint	//Where are we spawning from? This may be useful for visual effects
		var/list/turfs = params["origin"].clear_turfs_in_view(10)
		if (!turfs.len)
			return //Failed?

		params["target"] = pick(turfs)	//The exact turf we will spawn into
		params["price"] = price	//How much will it cost to do this spawn?
		params["dir"] = SOUTH	//Direction we face on spawning, not important for point spawn
		params["path"] = spawn_path
		params["user"] = usr	//Who is responsible for this ? Who shall we show error messages to

		return params