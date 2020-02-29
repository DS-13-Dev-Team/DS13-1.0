
/*
	The marker is the heart of the necromorph army
*/
/obj/machinery/marker
	name = "Marker"
	icon = 'icons/obj/marker_giant.dmi'
	icon_state = "marker_giant_dormant"
	pixel_x = -33
	plane = ABOVE_HUMAN_PLANE
	density = TRUE
	anchored = TRUE
	var/light_colour = "#FF4444"
	var/player	//Ckey of the player controlling the marker
	var/mob/observer/eye/signal/master/playermob	//Signal mob of the player controlling the marker
	var/corruption_plant

	//Biomass handling
	//--------------------------
	var/biomass	= 80//Current actual quantity of biomass we have stored. Start with enough to spawn a slasher
	var/biomass_tick = 0	//Current amount of mass we're gaining each second. This shouldn't be edited as it is regularly recalculated
	var/list/biomass_sources = list()	//A list of various sources (mostly necromorph corpses) from which we are gradually gaining biomass. These are finite

	var/datum/necroshop/shop

/obj/machinery/marker/New()
	SSnecromorph.marker = src	//Populate the global var with ourselves
	..()


/obj/machinery/marker/Initialize()
	.=..()
	shop = new(src)//Create necroshop datum
	GLOB.necrovision.add_source(src)	//Add it as the first source for necrovision
	add_biomass_source(null, 0, 1, /datum/biomass_source/baseline)	//Add the baseline income

	//Lets create a proximity tracker to detect corpses being dragged into our vicinity
	var/datum/proximity_trigger/view/PT = new (holder = src, on_turf_entered = /obj/machinery/marker/proc/nearby_movement, range = 10)
	PT.register_turfs()
	set_extension(src, /datum/extension/proximity_manager, PT)

	//Start spreading corruption
	start_corruption()

/obj/machinery/marker/proc/open_shop(var/mob/user)
	shop.ui_interact(user)

/obj/machinery/marker/attack_hand(var/mob/user)//Temporary
	open_shop(user)

/obj/machinery/marker/attack_ghost(var/mob/user)//Temporary
	open_shop(user)

/obj/machinery/marker/update_icon()
	if (player)
		icon_state = "marker_giant_active_anim"
		set_light(1, 1, 12, 2, light_colour)
	else
		icon_state = "marker_giant_dormant"
		set_light(0)


//Each process tick, we'll loop through all biomass sources and absorb their income
/obj/machinery/marker/Process()
	handle_biomass_tick()

/obj/machinery/marker/is_necromorph()
	return TRUE

/obj/machinery/marker/verb/shop_verb()
	set name = "Spawning Menu"
	set src in view()
	set category = null

	open_shop(usr)

//Biomass handling
//---------------------------------
//Rather than calculating and adding mass now, this proc calculates the mass to be added NEXT tick	(and also adds whatever we calculated last tick)
//This allows us to display an accurate preview of mass income in player-facing UIs
/obj/machinery/marker/proc/handle_biomass_tick()
	biomass += biomass_tick //Add the biomass we calculated last tick
	biomass_tick = 0	//Reset this before we recalculate it
	for (var/datum/biomass_source/S as anything in biomass_sources)

		var/check = S.can_absorb()
		if (check != MASS_READY)
			if (check == MASS_PAUSE)
				continue	//ITs paused, just keep going

			if (check == MASS_EXHAUST)
				S.mass_exhausted()	//It ran out, trigger a proc before we delete the source
			biomass_sources.Remove(S)
			qdel(S)
			continue

		//If we got here, it's ready.
		biomass_tick += S.absorb()

	//We will actually add this biomass next tick

/obj/machinery/marker/proc/add_biomass_source(var/datum/source = null, var/total_mass = 0, var/duration = 1 SECOND, var/sourcetype = /datum/biomass_source)
	//Adds a new biomass source, can specify type

	//First create it
	var/datum/biomass_source/BS = new sourcetype(source, src, total_mass, duration)

	//Don't add it if its a duplicate
	if (BS.is_duplicate(biomass_sources))
		qdel(BS)
		return
	biomass_sources.Add(BS)
	return BS	//Return the source



/obj/machinery/marker/proc/become_master_signal(var/mob/M)
	message_necromorphs(SPAN_NOTICE("[M.key] has taken charge of the marker."))
	var/mob/observer/eye/signal/master/S = new(M)
	player = S.key
	playermob = S
	qdel(M)
	update_icon()
	GLOB.unitologists.add_antagonist(playermob.mind)
	return S


/obj/machinery/marker/proc/vacate_master_signal()
	if (playermob)
		message_necromorphs(SPAN_NOTICE("[player] has stepped down, nobody is controlling the marker now."))
		var/mob/observer/eye/signal/S = new(playermob)
		GLOB.unitologists.remove_antagonist(playermob.mind)
		player = null
		QDEL_NULL(playermob)
		update_icon()
		return S

//This is defined at atom level to enable non-marker spawning systems in future
/atom/proc/get_available_biomass()
	return 0

/obj/machinery/marker/get_available_biomass()
	return biomass


//A mob was detected nearby, can we absorb it?
/obj/machinery/marker/proc/nearby_movement(var/atom/movable/AM, var/atom/old_loc)

	if (isliving(AM))
		var/mob/living/L = AM
		if (!L.is_necromorph())
			//Yes we can
			add_biomass_source(L, L.mass, 10 MINUTES, /datum/biomass_source/convergence)
			//We can only absorb dead mobs, but we don't check that here
			//We'll add a still-living mob to the list and it'll be checked each tick to see if it died yet

	//Organs and blood are succed up instantly but don't yield biomass
	if (istype(AM, /obj/item/organ) || istype(AM, /obj/effect/decal/cleanable/blood))
		spawn(1)
			if (!QDELETED(AM))
				qdel(AM)

/obj/machinery/marker/proc/pay_biomass(var/purpose, var/amount)
	if (biomass >= amount)
		biomass -= amount
		return TRUE
	return FALSE


//Corruption Handling

/obj/machinery/marker/proc/start_corruption()
	new /obj/effect/vine/corruption(get_turf(src),GLOB.corruption_seed, start_matured = 1)








//Necrovision

//The marker reveals an area around it, seeing through walls
/obj/machinery/marker/get_visualnet_tiles(var/datum/visualnet/network)
	return trange(10, src)



//Spawnpoints
/obj/machinery/marker/proc/add_spawnpoint(var/atom/source)
	if (shop)
		shop.possible_spawnpoints += new /datum/necrospawn(source, source.name)

/obj/machinery/marker/proc/remove_spawnpoint(var/atom/source)
	if (shop)
		for (var/datum/necrospawn/N in shop.possible_spawnpoints)
			if (N.spawnpoint == source)
				shop.possible_spawnpoints.Remove(N)