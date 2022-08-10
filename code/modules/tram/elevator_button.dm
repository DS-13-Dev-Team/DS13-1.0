/obj/machinery/computer/tramswitch
	name = "elevator control"
	desc = "Go back. Go back. Go back. Can you operate the elevator."
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0
	req_access = list()
	atom_flags = ATOM_FLAG_INDESTRUCTIBLE
	var/id = MAIN_STATION_TRAM
	/// A weakref to the lift_master datum we control
	var/datum/weakref/lift_weakref
	COOLDOWN_DECLARE(activation)

/obj/machinery/computer/tramswitch/Initialize(mapload)
	. = ..()

	if(mapload)
		return INITIALIZE_HINT_LATELOAD

	var/datum/lift_master/lift = get_lift()
	if(!lift)
		return

	lift_weakref = WEAKREF(lift)

/obj/machinery/computer/tramswitch/LateInitialize()
	var/datum/lift_master/lift = get_lift()
	if(!lift)
		log_mapping("Elevator call button at [AREACOORD(src)] found no associated lift to link with, this may be a mapping error.")
		return

	lift_weakref = WEAKREF(lift)

/obj/machinery/computer/tramswitch/attack_hand(mob/user)
	if(..())
		return TRUE
	activate()

// Emagging elevator buttons will disable safeties
/obj/machinery/computer/tramswitch/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(emagged)
		return

	var/datum/lift_master/lift = lift_weakref?.resolve()
	if(!lift)
		return

	for(var/obj/structure/industrial_lift/lift_platform as anything in lift.lift_platforms)
		lift_platform.violent_landing = TRUE
		lift_platform.warns_on_down_movement = FALSE
		lift_platform.elevator_vertical_speed = initial(lift_platform.elevator_vertical_speed) * 0.5

	to_chat(user, SPAN_NOTICE("Safeties succesfully overriden."))
	emagged = TRUE
	return TRUE

// Multitooling emagged elevator buttons will fix the safeties
/obj/machinery/computer/tramswitch/attackby(obj/item/I, mob/user)
	if(isMultitool(I))
		if(!emagged)
			return ..()

		var/datum/lift_master/lift = lift_weakref?.resolve()
		if(!lift)
			return ..()

		for(var/obj/structure/industrial_lift/lift_platform as anything in lift.lift_platforms)
			lift_platform.violent_landing = initial(lift_platform.violent_landing)
			lift_platform.warns_on_down_movement = initial(lift_platform.warns_on_down_movement)
			lift_platform.elevator_vertical_speed = initial(lift_platform.elevator_vertical_speed)

		// We can only be multitooled directly so just throw up the balloon alert
		to_chat(user, SPAN_NOTICE("Safeties succesfully reset."))
		emagged = FALSE
		return TRUE
	else
		.=..()

/obj/machinery/computer/tramswitch/proc/activate(mob/activator)
	if(COOLDOWN_FINISHED(src, activation))
		return

	COOLDOWN_START(src, activation, 2 SECONDS)
	// Actually try to call the elevator - this sleeps.
	// If we failed to call it, play a buzz sound.
	if(!call_elevator(activator))
		playsound(loc, 'sound/machines/buzz-two.ogg', 50, TRUE)

/// Actually calls the elevator.
/// Returns FALSE if we failed to setup the move.
/// Returns TRUE if the move setup was a success, EVEN IF the move itself fails afterwards
/obj/machinery/computer/tramswitch/proc/call_elevator(mob/activator)
	// We can't call an elevator that doesn't exist
	var/datum/lift_master/lift = lift_weakref?.resolve()
	if(!lift)
		to_chat(activator, SPAN_WARNING("There is no elevator connected!"))
		return FALSE

	// We can't call an elevator that's moving. You may say "you totally can do that", but that's not modelled
	if(lift.controls_locked == LIFT_PLATFORM_LOCKED)
		to_chat(activator, SPAN_WARNING("Elevator is moving!"))
		return FALSE

	// We can't call an elevator if it's already at this destination
	var/obj/structure/industrial_lift/prime_lift = lift.return_closest_platform_to_z(loc.z)
	if(prime_lift.z == loc.z)
		to_chat(activator, SPAN_WARNING("Elevator is already here!"))
		return FALSE

	// At this point, we can start moving.

	// Give the user, if supplied, a balloon alert.
	if(activator)
		to_chat(activator, SPAN_NOTICE("Succesfully called elevator."))

	// Actually try to move the lift. This will sleep.
	if(!lift.move_to_zlevel(loc.z))
		to_chat(activator, SPAN_WARNING("Elevator is out of service!"))
		return FALSE

	// From here on all returns are TRUE, as we successfully moved the lift, even if we maybe didn't reach our floor

	// Our lift platform survived, but it didn't reach our landing z.
	if(!QDELETED(prime_lift) && prime_lift.z != loc.z)
		if(!QDELETED(activator))
			to_chat(activator, SPAN_WARNING("Elevator is out of service!"))
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, TRUE)
		return TRUE

	// Everything went according to plan
	playsound(loc, 'sound/machines/ping.ogg', 50, TRUE)
	if(!QDELETED(activator))
		to_chat(activator, SPAN_NOTICE("Elevator arrived."))

	return TRUE

/// Gets the lift associated with our switch
/obj/machinery/computer/tramswitch/proc/get_lift()
	for(var/datum/lift_master/possible_match as anything in GLOB.active_lifts_by_type[BASIC_LIFT_ID])
		if(possible_match.specific_lift_id != id)
			continue

		return possible_match

	return null
