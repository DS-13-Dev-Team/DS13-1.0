//Very simple datum used for assessing targets in an efficient inheritance-based manner
/datum/targeting_profile

/datum/targeting_profile/proc/assess_target(var/atom/A)
	return PRIORITY_TARGET


/*
	For lethal turrets, far fewer safety checks
*/
/datum/targeting_profile/turret/assess_target(var/atom/A, var/obj/machinery/porta_turret/source)
	.=..()
	var/mob/living/L = A
	if(!L || !istype(L))
		return NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return NOT_TARGET

	//TODO: Check how this works
	if(!check_trajectory(L, source))	//check if we have true line of sight
		return NOT_TARGET

	//Focus less on downed targets
	.= L.stat ? SECONDARY_TARGET : PRIORITY_TARGET


/*
	For nonlethal turrets
*/
/datum/targeting_profile/turret/crew/assess_target(var/atom/A, var/obj/machinery/porta_turret/source)
	.=..()
	if (.)
		var/mob/living/L = A
		if(!source.emagged)
			if(issilicon(L))	// Don't target silica
				return NOT_TARGET

			if(L.stat)		//if the perp is dead/dying, no need to bother really
				return NOT_TARGET	//move onto next potential victim!



			if(iscuffed(L)) // If the target is handcuffed, leave it alone
				return NOT_TARGET


		if(isanimal(L) || issmall(L)) // Animals are not so dangerous
			return source.check_anomalies ? SECONDARY_TARGET : NOT_TARGET

		if(isxenomorph(L) || isalien(L)) // Xenos are dangerous
			return source.check_anomalies ? PRIORITY_TARGET	: NOT_TARGET

		if(ishuman(L))	//if the target is a human, analyze threat level
			if(source.assess_perp(L) < 4)
				return NOT_TARGET	//if threat level < 4, keep going

		if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
			return source.lethal ? SECONDARY_TARGET : NOT_TARGET
