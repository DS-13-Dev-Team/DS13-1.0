GLOBAL_DATUM_INIT(marker, /obj/machinery/marker, null)
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
	var/light_colour = "#FF9999"
	var/player

	//Biomass handling
	//--------------------------
	var/biomass	//Current actual quantity of biomass we have stored
	var/biomass_tick = 0	//Current amount of mass we're gaining each second. This shouldn't be edited as it is regularly recalculated
	var/list/biomass_sources = list()	//A list of various sources (mostly necromorph corpses) from which we are gradually gaining biomass. These are finite

/obj/machinery/marker/New()
	..()
	GLOB.marker = src	//Populate the global var with ourselves
	GLOB.necrovision.add_source(src)	//Add it as the first source for necrovision
	add_biomass_source(null, 0, 1, /datum/biomass_source/baseline)	//Add the baseline income



/obj/machinery/marker/update_icon()
	icon_state = "marker_giant_active_anim"
	set_light(1, 1, 12, 2, light_colour)


//Each process tick, we'll loop through all biomass sources and absorb their income
/obj/machinery/marker/Process()
	handle_biomass_tick()




//Biomass handling
//---------------------------------

//Rather than calculating and adding mass now, this proc calculates the mass to be added NEXT tick	(and also adds whatever we calculated last tick)
//This allows us to display an accurate preview of mass income in player-facing UIs
/obj/machinery/marker/proc/handle_biomass_tick()
	biomass += biomass_tick //Add the biomass we calculated last tick
	world << "Biomass gained: [biomass_tick]	Total:[biomass]"
	biomass_tick = 0	//Reset this before we recalculate it
	for (var/datum/biomass_source/S as anything in biomass_sources)
		var/check = S.can_absorb()
		if (check != MASS_READY)
			//Handle failure cases and continue
			continue

		//If we got here, it's ready.
		biomass_tick += S.absorb()

	//We will actually add this biomass next tick

/obj/machinery/marker/proc/add_biomass_source(var/datum/source = null, var/total_mass = 0, var/duration = 1 SECOND, var/sourcetype = /datum/biomass_source)
	//Adds a new biomass source, can specify type

	//First create it
	var/datum/biomass_source/BS = new sourcetype(source, total_mass, duration)

	//Don't add it if its a duplicate
	if (BS.is_duplicate(biomass_sources))
		qdel(BS)
		return
	biomass_sources.Add(BS)


/obj/machinery/marker/proc/posess(var/mob/M)
	player = M

/obj/machinery/marker/attack_ghost(var/mob/user)
	.=..()
	if (!player)
		posess(user)