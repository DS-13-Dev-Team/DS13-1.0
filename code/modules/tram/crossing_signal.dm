#define XING_STATE_GREEN 0
#define XING_STATE_AMBER 1
#define XING_STATE_RED 2

/// Pedestrian crossing signal for tram
/obj/machinery/crossing_signal
	name = "crossing signal"
	desc = "Indicates to pedestrians if it's safe to cross the tracks."
	icon = 'icons/obj/machines/crossing_signal.dmi'
	icon_state = "crossing-base"
	max_health = 250
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.05
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.02
	anchored = TRUE
	density = FALSE

	light_range = 1.5
	light_power = 1
	light_color = COLOR_LIME
	luminosity = 1

	/// green, amber, or red.
	var/signal_state = XING_STATE_GREEN
	/// The ID of the tram we control
	var/tram_id = MAIN_STATION_TRAM
	/// Weakref to the tram piece we control
	var/datum/weakref/tram_ref
	/// Proximity threshold for amber warning (slow people may be in danger)
	var/amber_distance_threshold = 40
	/// Proximity threshold for red warning (running people will likely not be able to cross)
	var/red_distance_threshold = 20

/obj/machinery/crossing_signal/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/crossing_signal/LateInitialize()
	. = ..()
	find_tram()

	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(tram_part)
		RegisterSignal(tram_part, COMSIG_TRAM_SET_TRAVELLING, .proc/on_tram_travelling)

/obj/machinery/crossing_signal/Destroy()
	. = ..()

	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(tram_part)
		UnregisterSignal(tram_part, COMSIG_TRAM_SET_TRAVELLING)

/obj/machinery/crossing_signal/emag_act(mob/living/user)
	if(emagged)
		return
	to_chat(user, SPAN_NOTICE("Motion sensors were succesfully disabled!"))
	if(signal_state != XING_STATE_GREEN)
		set_signal_state(XING_STATE_GREEN)
	emagged = TRUE

/**
 * Finds the tram, just like the tram computer
 *
 * Locates tram parts in the lift global list after everything is done.
 */
/obj/machinery/crossing_signal/proc/find_tram()
	for(var/datum/lift_master/tram/tram as anything in GLOB.active_lifts_by_type[TRAM_LIFT_ID])
		if(tram.specific_lift_id != tram_id)
			continue
		tram_ref = WEAKREF(tram)
		break

/**
 * Only process if the tram is actually moving
 */
/obj/machinery/crossing_signal/proc/on_tram_travelling(datum/source, travelling)
	SIGNAL_HANDLER

	update_operating()

/obj/machinery/crossing_signal/power_change()
	. = ..()
	update_operating()

/**
 * Update processing state.
 *
 * Returns whether we are still processing.
 */
/obj/machinery/crossing_signal/proc/update_operating()
	//emagged crossing signals dont update
	if(emagged)
		return
	// Immediately process for snappy feedback
	var/should_process = Process() != PROCESS_KILL
	if(should_process)
		START_PROCESSING(SStramprocess, src)
		return
	STOP_PROCESSING(SStramprocess, src)

/obj/machinery/crossing_signal/Process()
	var/datum/lift_master/tram/tram = tram_ref?.resolve()

	// Check for stopped states.
	if(!tram || stat)
		// Tram missing, or we lost power.
		// Tram missing is always safe (green)
		set_signal_state(XING_STATE_GREEN, force = stat)
		return PROCESS_KILL

	use_power(active_power_usage)

	var/obj/structure/industrial_lift/tram/tram_part = tram.return_closest_platform_to(src)

	if(QDELETED(tram_part))
		set_signal_state(XING_STATE_GREEN, force = stat)
		return PROCESS_KILL

	// Everything will be based on position and travel direction
	var/signal_pos
	var/tram_pos
	var/tram_velocity_sign // 1 for positive axis movement, -1 for negative
	// Try to be agnostic about N-S vs E-W movement
	if(tram.travel_direction & (NORTH|SOUTH))
		signal_pos = y
		tram_pos = tram_part.y
		tram_velocity_sign = tram.travel_direction & NORTH ? 1 : -1
	else
		signal_pos = x
		tram_pos = tram_part.x
		tram_velocity_sign = tram.travel_direction & EAST ? 1 : -1

	// How far away are we? negative if already passed.
	var/approach_distance = tram_velocity_sign * (signal_pos - tram_pos)

	// Check for stopped state.
	// Will kill the process since tram starting up will restart process.
	if(!tram.travelling)
		// if super close, show red anyway since tram could suddenly start moving
		if(abs(approach_distance) < red_distance_threshold)
			set_signal_state(XING_STATE_RED)
			return PROCESS_KILL
		set_signal_state(XING_STATE_GREEN)
		return PROCESS_KILL

	// Check if tram is driving away from us.
	if(approach_distance < 0)
		// driving away. Green. In fact, in order to reverse, it'll have to stop, so let's go ahead and kill.
		set_signal_state(XING_STATE_GREEN)
		return PROCESS_KILL

	// OK so finally the interesting part where it's ACTUALLY approaching
	if(approach_distance <= red_distance_threshold)
		set_signal_state(XING_STATE_RED)
		return
	if(approach_distance <= amber_distance_threshold)
		set_signal_state(XING_STATE_AMBER)
		return
	set_signal_state(XING_STATE_GREEN)

/**
 * Set the signal state and update appearance.
 *
 * Arguments:
 * new_state - the new state (XING_STATE_RED, etc)
 * force_update - force appearance to update even if state didn't change.
 */
/obj/machinery/crossing_signal/proc/set_signal_state(new_state, force = FALSE)
	if(new_state == signal_state && !force)
		return

	signal_state = new_state
	update_icon()

/obj/machinery/crossing_signal/update_icon()
	if(stat)
		set_light(l_on = FALSE)
		return

	var/new_color
	switch(signal_state)
		if(XING_STATE_GREEN)
			new_color = COLOR_LIME
		if(XING_STATE_AMBER)
			new_color = COLOR_YELLOW
		else
			new_color = COLOR_RED

	set_light(l_on = TRUE, l_color = new_color)

	var/lights_overlay = "crossing-[signal_state]"

	. += mutable_appearance(icon, lights_overlay)
	. += emissive_appearance(icon, "[lights_overlay]e", alpha = src.alpha)

/// Shifted to NE corner for east side of southern passage.
/obj/machinery/crossing_signal/northeast
	pixel_x = 11
	pixel_y = 22

/// Shifted to NW corner for west side of southern passage.
/obj/machinery/crossing_signal/northwest
	pixel_x = -11
	pixel_y = 22

/// Shifted to SE corner for east side of northern passage.
/obj/machinery/crossing_signal/southeast
	pixel_x = 11
	pixel_y = 6

/// Shifted to SW corner for west side of northern passage.
/obj/machinery/crossing_signal/southwest
	pixel_x = -11
	pixel_y = 6

#undef XING_STATE_GREEN
#undef XING_STATE_AMBER
#undef XING_STATE_RED
