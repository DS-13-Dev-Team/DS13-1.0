/*
	Extension statmod system:
	To prevent cumulative math errors, extensions must use this system to modify any commonly shared attributes on a mob. This currently includes:


	Mods need only call register statmod with their chosen type, Which must be one of the STATMOD_.. defines in __defines/skills_stats.dm

	Whenever the mob needs to recalculate its stats, it will call a proc on each extension which is registered for that kind of stat

	Name:								Define:								Proc:							Expected Return
	Movespeed (additive)				STATMOD_MOVESPEED_ADDITIVE			movespeed_mod()					A percentage value, 0=no change, 1 = +100%, etc. Negative allowed
	Movespeed (multiplicative)			STATMOD_MOVESPEED_MULTIPLICATIVE	movespeed_mod()					A multiplier. 1 = no change, 2 = double, etc. Must be > 0
*/



/datum/extension/proc/register_statmod(var/modtype)
	//Currently only supported for mobs
	var/mob/M = holder
	if (!istype(M))
		return

	//Initialize the list
	if (!LAZYACCESS(M.statmods, modtype))
		//This will create the statmods list AND insert a key/value pair for modtype/list()
		LAZYASET(M.statmods, modtype, list())

	LAZYDISTINCTADD(M.statmods[modtype], src)


/datum/extension/proc/unregister_statmod(var/modtype)
	//Currently only supported for mobs
	var/mob/M = holder
	if (!istype(M))
		return

	//If it doesn't exist we dont need to do anything
	if (!LAZYACCESS(M.statmods, modtype))
		return


	LAZYAMINUS(M.statmods,modtype, src)




/*
	Movespeed
*/
/datum/extension/proc/register_movemod(var/modtype)
	register_statmod(modtype)
	holder.update_movespeed_factor()

/datum/extension/proc/unregister_movemod(var/modtype)
	unregister_statmod(modtype)
	holder.update_movespeed_factor()

/datum/extension/proc/movespeed_mod()
	return 0

//Additive modifiers first, then multiplicative
/datum/proc/update_movespeed_factor()

/mob/update_movespeed_factor()
	move_speed_factor = 1

	//We add the result of each additive modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_MOVESPEED_ADDITIVE))
		move_speed_factor += E.movespeed_mod()

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_MOVESPEED_MULTIPLICATIVE))
		move_speed_factor *= E.movespeed_mod()



/*
	Incoming Damage
*/
/datum/extension/proc/register_incoming_damage_mod()
	register_statmod(STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE)
	holder.update_incoming_damage_factor()

/datum/extension/proc/unregister_incoming_damage_mod()
	unregister_statmod(STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE)
	holder.update_incoming_damage_factor()

/datum/extension/proc/incoming_damage_mod()
	return 1

//Additive modifiers first, then multiplicative
/datum/proc/update_incoming_damage_factor()

/mob/living/update_incoming_damage_factor()
	incoming_damage_mult = 1

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE))
		incoming_damage_mult *= E.incoming_damage_mod()