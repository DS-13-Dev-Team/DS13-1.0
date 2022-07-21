// Areas.dm



// ===
/area
	layer = AREA_LAYER
	//Keeping this on the default plane, GAME_PLANE, will make area overlays fail to render on FLOOR_PLANE.
	plane = AREA_PLANE
	var/global/global_uid = 0
	var/uid
	var/area_flags

	//This is a list of all doors/airlocks which are in or on the border of this area.
	//On the border counts if there is a clear, unobstructed path from this area, to that door.
	//Note that windows counts as an obstruction
	var/list/bordering_doors = list()
	var/is_maintenance = FALSE
	var/ship_area = FALSE

/area/New()
	GLOB.areas_by_type[type] = src
	icon_state = ""
	uid = ++global_uid

	if(!requires_power)
		power_light = 0
		power_equip = 0
		power_environ = 0
	..()

/area/Destroy()
	if(GLOB.areas_by_type[type] == src)
		GLOB.areas_by_type[type] = null
	.=..()

/area/Initialize()
	. = ..()
	if(!requires_power || !apc)
		power_light = 0
		power_equip = 0
		power_environ = 0
	power_change()		// all machines set to current power level, also updates lighting icon
	if(ship_area)
		GLOB.ship_areas += src
	update_base_lighting()

/area/proc/register_door(var/obj/machinery/door/D)
	bordering_doors |= D

/area/proc/unregister_door(var/obj/machinery/door/D)
	bordering_doors -= D

/area/get_contents()
	return contents

/area/proc/get_cameras()
	var/list/cameras = list()
	for (var/obj/machinery/camera/C in src)
		cameras += C
	return cameras

/area/proc/is_shuttle_locked()
	return 0

/area/proc/atmosalert(danger_level, var/alarm_source)
	if (danger_level == 0)
		atmosphere_alarm.clearAlarm(src, alarm_source)
	else
		atmosphere_alarm.triggerAlarm(src, alarm_source, severity = danger_level)

	//Check all the alarms before lowering atmosalm. Raising is perfectly fine.
	for (var/obj/machinery/alarm/AA in src)
		if (!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted && AA.report_danger_level)
			danger_level = max(danger_level, AA.danger_level)

	if(danger_level != atmosalm)
		if (danger_level < 1 && atmosalm >= 1)
			//closing the doors on red and opening on green provides a bit of hysteresis that will hopefully prevent fire doors from opening and closing repeatedly due to noise
			air_doors_open()
		else if (danger_level >= 2 && atmosalm < 2)
			air_doors_close()

		atmosalm = danger_level
		for (var/obj/machinery/alarm/AA in src)
			AA.update_icon()

		return 1
	return 0

/area/proc/air_doors_close()
	if(!air_doors_activated)
		air_doors_activated = 1
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_CLOSED
				else if(!E.density)
					spawn(0)
						E.close()

/area/proc/air_doors_open()
	if(air_doors_activated)
		air_doors_activated = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/E in all_doors)
			if(!E.blocked)
				if(E.operating)
					E.nextstate = FIREDOOR_OPEN
				else if(E.density)
					spawn(0)
						if(E.can_safely_open())
							E.open()


/area/proc/fire_alert()
	if(!fire)
		fire = 1	//used for firedoor checks
		update_icon()
		mouse_opacity = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_CLOSED
				else if(!D.density)
					spawn()
						D.close()

/area/proc/fire_reset()
	if (fire)
		fire = 0	//used for firedoor checks
		update_icon()
		mouse_opacity = 0
		if(!all_doors)
			return
		for(var/obj/machinery/door/firedoor/D in all_doors)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					spawn(0)
					D.open()

/area/proc/readyalert()
	if(!eject)
		eject = 1
		update_icon()
	return

/area/proc/readyreset()
	if(eject)
		eject = 0
		update_icon()
	return

/area/proc/partyalert()
	if (!( party ))
		party = 1
		update_icon()
		mouse_opacity = 0
	return

/area/proc/partyreset()
	if (party)
		party = 0
		mouse_opacity = 0
		update_icon()
		for(var/obj/machinery/door/firedoor/D in src)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = FIREDOOR_OPEN
				else if(D.density)
					spawn(0)
					D.open()
	return

/area/update_icon()
	if ((fire || eject || party) && (!requires_power||power_environ))//If it doesn't require power, can still activate this proc.
		if(fire && !eject && !party)
			icon_state = "blue"
		/*else if(atmosalm && !fire && !eject && !party)
			icon_state = "bluenew"*/
		else if(!fire && eject && !party)
			icon_state = "red"
		else if(party && !fire && !eject)
			icon_state = "party"
		else
			icon_state = "blue-red"
	else
	//	new lighting behaviour with obj lights
		icon_state = null

/*
#define EQUIP 1
#define LIGHT 2
#define ENVIRON 3
*/

/area/proc/powered(var/chan)		// return true if the area has power to given channel

	if(!requires_power)
		return 1
	if(always_unpowered)
		return 0
	switch(chan)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return 0

// called when power status changes
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if (fire || eject || party)
		update_icon()

/area/proc/usage(var/chan)
	var/used = 0
	switch(chan)
		if(LIGHT)
			used += used_light
		if(EQUIP)
			used += used_equip
		if(ENVIRON)
			used += used_environ
		if(TOTAL)
			used += used_light + used_equip + used_environ
	return used

/area/proc/clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0

/area/proc/use_power(var/amount, var/chan)
	switch(chan)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount

/area/proc/set_lightswitch(var/new_switch)
	if(lightswitch != new_switch)
		lightswitch = new_switch
		for(var/obj/machinery/light_switch/L in src)
			L.sync_state()
		update_icon()
		power_change()

/area/proc/set_emergency_lighting(var/enable)
	for(var/obj/machinery/light/M in src)
		M.set_emergency_lighting(enable)


var/list/mob/living/forced_ambiance_list = new

/area/Entered(A)
	if(!istype(A,/mob/living))	return

	var/mob/living/L = A
	if(!L.ckey)	return

	if(!L.lastarea)
		L.lastarea = get_area(L.loc)
	var/area/newarea = get_area(L.loc)
	var/area/oldarea = L.lastarea
	if(oldarea.has_gravity != newarea.has_gravity)

		L.gravity_changed(newarea.has_gravity)

	play_ambience(L)
	L.lastarea = newarea

/area/proc/play_ambience(var/mob/living/L)
	// Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas adjacent to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
	if(!(L && L.client && L.get_preference_value(/datum/client_preference/play_ambiance) == GLOB.PREF_YES))	return

	var/turf/T = get_turf(L)
	var/hum = 0
	if(!L.ear_deaf && !always_unpowered && power_environ)
		for(var/obj/machinery/atmospherics/unary/vent_pump/vent in src)
			if(vent.can_pump())
				hum = 1
				break
	if(hum)
		if(!L.client.vent_ambience_playing)
			L.client.vent_ambience_playing = TRUE
			L.playsound_local(T,sound('sound/ambience/vents.ogg', repeat = 1, wait = 0, volume = 20, channel = GLOB.ambience_sound_channel))
	else
		if(L.client.vent_ambience_playing)
			L.client.vent_ambience_playing = FALSE
			SEND_SOUND(L, sound(null, channel = GLOB.ambience_sound_channel))

	if(L.lastarea != src)
		var/cancel_existing = TRUE
		var/selected_ambience
		if(LAZYLEN(forced_ambience))
			selected_ambience = pick(forced_ambience)

		//If the currently selected track is the same as whats already playing, we don't cancel it
		if (selected_ambience && selected_ambience == L.client.area_ambience_playing)
			cancel_existing = FALSE

		if (cancel_existing)
			if (selected_ambience)
				forced_ambiance_list |= L
				L.playsound_local(T,sound(selected_ambience, repeat = 1, wait = 0, volume = 25, channel = GLOB.lobby_sound_channel))
				L.client.area_ambience_playing = selected_ambience
			else	//stop any old area's forced ambience, and try to play our non-forced ones
				SEND_SOUND(L, sound(null, channel = GLOB.lobby_sound_channel))
				forced_ambiance_list -= L
				L.client.area_ambience_playing = null



	if(LAZYLEN(ambience) && prob(5) && (world.time >= L.client.played + 1.5 MINUTES))
		L.playsound_local(T, sound(pick(ambience), repeat = 0, wait = 0, volume = 15, channel = 1)) //channel 1 stops ambience clips cutting out when you enter a new area. that was an easier fix than the forced_ambience situation lol
		L.client.played = world.time


/area/proc/prison_break()
	var/obj/machinery/power/apc/theAPC = get_apc()
	if(theAPC && theAPC.operating)
		for(var/obj/machinery/power/apc/temp_apc in src)
			temp_apc.overload_lighting(70)
		for(var/obj/machinery/door/airlock/temp_airlock in src)
			temp_airlock.prison_open()
		for(var/obj/machinery/door/window/temp_windoor in src)
			temp_windoor.open()



/proc/has_gravity(atom/AT, turf/T)
	if(!T)
		T = get_turf(AT)
	var/area/A = get_area(T)
	if(A && A.has_gravity())
		return 1
	return 0

/area/proc/get_dimensions()
	var/list/res = list("x"=1,"y"=1)
	var/list/min = list("x"=world.maxx,"y"=world.maxy)
	for(var/turf/T in src)
		res["x"] = max(T.x, res["x"])
		res["y"] = max(T.y, res["y"])
		min["x"] = min(T.x, min["x"])
		min["y"] = min(T.y, min["y"])
	res["x"] = res["x"] - min["x"] + 1
	res["y"] = res["y"] - min["y"] + 1
	return res

/area/proc/has_turfs()
	return !!(locate(/turf) in src)

/**
 * Register this area as belonging to a z level
 *
 * Ensures the item is added to the SSmapping.areas_in_z list for this z
 */
/area/proc/reg_in_areas_in_z()
	if(!length(contents))
		return
	var/list/areas_in_z = SSmapping.areas_in_z
	if(!z)
		WARNING("No z found for [src]")
		return
	if(!areas_in_z["[z]"])
		areas_in_z["[z]"] = list()
	areas_in_z["[z]"] += src

