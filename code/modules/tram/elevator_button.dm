/obj/machinery/computer/tramswitch
	name = "elevator control"
	desc = "Go back. Go back. Go back. Can you operate the elevator."
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0
	req_access = list()
	atom_flags = ATOM_FLAG_INDESTRUCTIBLE
	COOLDOWN_DECLARE(activation)
	///for finding the landmark initially - should be the exact same as the landmark's destination id.
	var/initial_id
	///ID to link to allow us to link to one specific tram in the world
	var/specific_lift_id = MAIN_STATION_TRAM
	///this is our destination's landmark, so we only have to find it the first time.
	var/datum/weakref/to_where

/obj/machinery/computer/tramswitch/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/tramswitch/LateInitialize()
	. = ..()
	//find where the tram needs to go to (our destination). only needs to happen the first time
	for(var/obj/effect/landmark/tram/our_destination as anything in GLOB.tram_landmarks[specific_lift_id])
		if(our_destination.destination_id == initial_id)
			to_where = WEAKREF(our_destination)
			break

/obj/machinery/computer/tramswitch/Destroy()
	to_where = null
	return ..()

/obj/machinery/computer/tramswitch/attack_hand(mob/user)
	if(..())
		return TRUE
	activate()

/obj/machinery/computer/tramswitch/proc/activate(mob/activator)
	if(!COOLDOWN_FINISHED(src, activation))
		return

	COOLDOWN_START(src, activation, 2 SECONDS)
	var/datum/lift_master/tram/tram
	for(var/datum/lift_master/tram/possible_match as anything in GLOB.active_lifts_by_type[TRAM_LIFT_ID])
		if(possible_match.specific_lift_id == specific_lift_id)
			tram = possible_match
			break

	if(!tram)
		to_chat(activator, SPAN_WARNING("The tram is not responding to call signals. Please send a technician to repair the internals of the tram."))
		return
	if(tram.travelling) //in use
		to_chat(activator, SPAN_NOTICE("The tram is already travelling to [tram.from_where]."))
		return
	if(!to_where)
		return
	var/obj/effect/landmark/tram/current_location = to_where.resolve()
	if(!current_location)
		return
	if(tram.from_where == current_location) //already here
		to_chat(activator, SPAN_NOTICE("The tram is already here. Please board the tram and select a destination."))
		return

	to_chat(activator, SPAN_NOTICE("The tram has been called to [current_location.name]. Please wait for its arrival."))
	tram.tram_travel(current_location)
