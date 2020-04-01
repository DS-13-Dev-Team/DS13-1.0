/*
	This extension handles the storage and gain of psi energy, used by signals and markers for their abilities.

	It is attached to the player datum, so it persists between relogs and mob transitions
	Signal players gain energy while they're playing as a signal waiting to do things. Their energy gain is paused while controlling a necromorph. The stored energy persists though
*/
/datum/extension/psi_energy
	flags = EXTENSION_FLAG_IMMEDIATE
	base_type = /datum/extension/psi_energy
	var/datum/player/host
	var/energy = 0
	var/energy_per_tick = 1	//1 Per second
	var/max_energy = 900	//Stores 15 minutes worth of energy
	var/ticking = FALSE

/datum/extension/psi_energy/New()
	.=..()
	host = holder

/datum/extension/psi_energy/proc/is_valid_mob(var/mob/M)
	return TRUE

/datum/extension/psi_energy/proc/safety_check()
	.= FALSE
	var/client/C = host.get_client()
	if (C)//Check they're still connected
		var/mob/M = host.get_mob()
		if (is_valid_mob(M))	//And in the right mobtype
			.=TRUE

	//If we're about to return false, we may also wish to suspend ticking
	if (!. && can_stop_ticking())
		stop_ticking()

/datum/extension/psi_energy/Process()
	if (!safety_check())
		return FALSE

	energy = min(max_energy, energy+energy_per_tick)


/datum/extension/psi_energy/proc/start_ticking()
	if (!ticking)
		START_PROCESSING(SSprocessing, src)
		ticking = TRUE

/datum/extension/psi_energy/proc/stop_ticking()
	if (ticking)
		STOP_PROCESSING(SSprocessing, src)
		ticking = FALSE

/datum/extension/psi_energy/proc/can_stop_ticking()
	return TRUE


/*
	Signal Specific
*/
/datum/extension/psi_energy/signal
	base_type = /datum/extension/psi_energy/signal


/datum/extension/psi_energy/signal/is_valid_mob(var/mob/M)
	if (issignal(M))
		return TRUE

	return FALSE


/*
	Marker Specific
*/
/datum/extension/psi_energy/marker
	base_type = /datum/extension/psi_energy/marker
	energy_per_tick = 5	//5 Per second
	max_energy = 4500	//Stores 15 minutes worth of energy

/datum/extension/psi_energy/marker/is_valid_mob(var/mob/M)
	return TRUE	//Always gives energy regardless of mob


/*
	Helper procs
*/
