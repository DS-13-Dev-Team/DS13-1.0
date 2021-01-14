/*
	Extension statmod system:
	To prevent cumulative math errors, extensions must use this system to modify any commonly shared attributes on a mob. This currently includes:


	Mods need only call register statmod with their chosen type, Which must be one of the STATMOD_.. defines in __defines/skills_stats.dm

	Whenever the mob needs to recalculate its stats, it will call a proc on each extension which is registered for that kind of stat

	Name:								Define:								Proc:							Expected Return
	Movespeed (additive)				STATMOD_MOVESPEED_ADDITIVE			movespeed_mod()					A percentage value, 0=no change, 1 = +100%, etc. Negative allowed
	Movespeed (multiplicative)			STATMOD_MOVESPEED_MULTIPLICATIVE	movespeed_mod()					A multiplier. 1 = no change, 2 = double, etc. Must be > 0
	Incoming Damage						STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE	incoming_damage_mod()		A multiplier. 1 = no change, 2 = double, etc. Must be > 0
	Ranged Accuracy						STATMOD_RANGED_ACCURACY
*/


//This list is in the following format:
//Define = list (update_proc)
GLOBAL_LIST_INIT(statmods, list(
STATMOD_MOVESPEED_ADDITIVE = list(/datum/proc/update_movespeed_factor),
STATMOD_MOVESPEED_MULTIPLICATIVE = list(/datum/proc/update_movespeed_factor),
STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = list(/datum/proc/update_incoming_damage_factor),
STATMOD_RANGED_ACCURACY = list(/datum/proc/update_ranged_accuracy_factor),
STATMOD_ATTACK_SPEED = list(/datum/proc/update_attack_speed)
))

/datum/extension
	var/auto_register_statmods = TRUE
	var/list/statmods = null

/datum/extension/proc/register_statmods()
	for (var/modtype in statmods)
		register_statmod(modtype)

/datum/extension/proc/unregister_statmods()
	for (var/modtype in statmods)
		unregister_statmod(modtype)

//Trigger all relevant update procs without changing registration
/datum/extension/proc/update_statmods()
	var/mob/M = holder
	if (!istype(M))
		return
	for (var/modtype in statmods)
		var/list/data = GLOB.statmods[modtype]
		var/update_proc = data[1]
		call(M, update_proc)()

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

	//Now lets make them update
	var/list/data = GLOB.statmods[modtype]
	var/update_proc = data[1]
	call(M, update_proc)()//And call it

/datum/extension/proc/unregister_statmod(var/modtype)
	//Currently only supported for mobs
	var/mob/M = holder
	if (!istype(M))
		return

	//If it doesn't exist we dont need to do anything
	if (!LAZYACCESS(M.statmods, modtype))
		return



	LAZYAMINUS(M.statmods,modtype, src)
	//Now lets make them update
	var/list/data = GLOB.statmods[modtype]
	var/update_proc = data[1]
	call(M, update_proc)()//And call it


/datum/extension/proc/get_statmod(var/modtype)
	return src.statmods[modtype]

/*
	Movespeed
*/
/datum/proc/update_movespeed_factor()

/mob/update_movespeed_factor()
	move_speed_factor = 1

	//We add the result of each additive modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_MOVESPEED_ADDITIVE))
		move_speed_factor += E.get_statmod(STATMOD_MOVESPEED_ADDITIVE)

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_MOVESPEED_MULTIPLICATIVE))
		move_speed_factor *= E.get_statmod(STATMOD_MOVESPEED_MULTIPLICATIVE)



/*
	Incoming Damage
*/
//Additive modifiers first, then multiplicative
/datum/proc/update_incoming_damage_factor()

/mob/living/update_incoming_damage_factor()
	incoming_damage_mult = 1

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE))
		incoming_damage_mult *= E.get_statmod(STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE)



/*
	Ranged Accuracy
*/
/datum/proc/update_ranged_accuracy_factor()

/mob/living/update_ranged_accuracy_factor()
	ranged_accuracy_modifier = 0

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_RANGED_ACCURACY))
		ranged_accuracy_modifier += E.get_statmod(STATMOD_RANGED_ACCURACY)


/*
	attackspeed
*/
/datum/proc/update_attack_speed()

/mob/living/update_attack_speed()
	attack_speed_factor = 1

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_ATTACK_SPEED))
		attack_speed_factor += E.get_statmod(STATMOD_ATTACK_SPEED)