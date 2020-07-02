//Very simple datum used for assessing targets in an efficient inheritance-based manner
/datum/targeting_profile
	var/name = "Target Anything"
	var/desc = ""
	var/id = ""
	var/base_type = /datum/targeting_profile

/datum/targeting_profile/proc/assess_target(var/atom/A)
	return PRIORITY_TARGET


/*
	Indiscriminate. Shoots anything that moves
*/
/datum/targeting_profile/turret
	name = "Indiscriminate"
	id = "indiscriminate"
	desc = "Indiscriminate firing mode will target any creature that moves, regardless of status."

/datum/targeting_profile/turret/assess_target(var/atom/A, var/obj/machinery/turret/source)
	.=..()
	var/mob/living/L = A
	if(!L || !istype(L))
		return NOT_TARGET

	//Stop shooting when they're dead please
	if (L.stat == DEAD)
		return NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return NOT_TARGET

	//We can't shoot at things on the same turf as us
	if (get_turf(A) == get_turf(source))
		return NOT_TARGET

	//TODO: Check how this works
	if(!check_trajectory(L, source, pass_flags=PASS_FLAG_TABLE|PASS_FLAG_FLYING))	//check if we have true line of sight
		return NOT_TARGET

	//Focus less on downed targets
	.= L.stat ? SECONDARY_TARGET : PRIORITY_TARGET



/*
	Crew: Shoots nonhuman stuff
*/
/datum/targeting_profile/turret/crew
	name = "Non Crew"
	id = "noncrew"
	desc = "Noncrew mode will target anything that cannot be conclusively identified as a member of the crew. This includes anything not human, and humans without ID cards."

/datum/targeting_profile/turret/crew/assess_target(var/atom/A, var/obj/machinery/turret/source)
	.=..()
	if (.)
		var/mob/living/L = A
		if(!source.emagged)
			if(issilicon(L))	// Don't target silica
				return NOT_TARGET


			if(iscuffed(L)) // If the target is handcuffed, leave it alone
				return NOT_TARGET


		if(isanimal(L) || issmall(L)) // Animals are not so dangerous
			return PRIORITY_TARGET

		if(L.is_necromorph() || isalien(L)) // Xenos are dangerous
			return PRIORITY_TARGET

		if(ishuman(L))	//if the target is a human, ignore them as long as they have an ID card
			var/list/target_access = A.GetAccess()
			if (LAZYLEN(target_access))
				return NOT_TARGET

		if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
			return source.lethal ? SECONDARY_TARGET : NOT_TARGET


/*
	Authorized: Shoots people who aren't security or command staff
*/
/datum/targeting_profile/turret/authorized
	name = "Unauthorized Personnel"
	id = "unauthorized"
	desc = "Unauthorized Personnel mode will target anyone who isn't carrying an ID with security or command access. To be used in cases of mutiny"

/datum/targeting_profile/turret/authorized/assess_target(var/atom/A, var/obj/machinery/turret/source)
	.=..()
	if (.)
		//If the target is carrying an ID that gives them security or command access, we will not fire
		var/list/target_access = A.GetAccess()
		if (LAZYLEN(target_access))
			if (has_access(list(), list(ACCESS_REGION_SECURITY, ACCESS_REGION_COMMAND), target_access))
				return NOT_TARGET

		var/mob/living/L = A
		if(!source.emagged)
			if(issilicon(L))	// Don't target silica
				return NOT_TARGET

			if(iscuffed(L)) // If the target is handcuffed, leave it alone
				return NOT_TARGET


		if(isanimal(L) || issmall(L))
			return PRIORITY_TARGET

		if(L.is_necromorph() || isalien(L)) // Xenos are dangerous
			return PRIORITY_TARGET

		if(ishuman(L))	//if the target is a human, analyze threat level
			if(source.assess_perp(L) < 4)
				return NOT_TARGET	//if threat level < 4, keep going

		if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
			return source.lethal ? SECONDARY_TARGET : NOT_TARGET





