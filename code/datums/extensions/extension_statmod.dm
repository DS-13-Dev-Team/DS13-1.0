/*
	Extension statmod system:
	To prevent cumulative math errors, extensions must use this system to modify any commonly shared attributes on a mob. This currently includes:

	To set a mod, just add DEFINE = value to the statmods list on the extension.
	If you change the contents of that list during runtime, call unregister_statmods before the change, then register_statmods after

	Name:								Define:									Expected Value
	Movespeed (additive)				STATMOD_MOVESPEED_ADDITIVE				A percentage value, 0=no change, 1 = +100%, etc. Negative allowed
	Movespeed (multiplicative)			STATMOD_MOVESPEED_MULTIPLICATIVE		A multiplier. 1 = no change, 2 = double, etc. Must be > 0
	Incoming Damage						STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE	A multiplier. 1 = no change, 2 = double, etc. Must be > 0
	Ranged Accuracy						STATMOD_RANGED_ACCURACY					A flat number of percentage points
	Vision Range						STATMOD_VIEW_RANGE					An integer number of tiles to add/remove from vision range
	Evasion								STATMOD_EVASION							An number of percentage points which will be additively added to evasion, negative allowed
*/



//This list is in the following format:
//Define = list (update_proc)
GLOBAL_LIST_INIT(statmods, list(
STATMOD_MOVESPEED_ADDITIVE = list(/datum/proc/update_movespeed_factor),
STATMOD_MOVESPEED_MULTIPLICATIVE = list(/datum/proc/update_movespeed_factor),
STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = list(/datum/proc/update_incoming_damage_factor),
STATMOD_RANGED_ACCURACY = list(/datum/proc/update_ranged_accuracy_factor),
STATMOD_ATTACK_SPEED = list(/datum/proc/update_attack_speed),
STATMOD_EVASION = list(/datum/proc/update_evasion),
STATMOD_VIEW_RANGE = list(/datum/proc/update_vision_range)
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
	return LAZYACCESS(statmods, modtype)


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



/*
	Evasion
*/
/datum/proc/update_evasion()

/mob/living/update_evasion()
	evasion = get_base_evasion()

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_EVASION))
		evasion += E.get_statmod(STATMOD_EVASION)



/datum/proc/get_base_evasion()
	return 0

/mob/living/get_base_evasion()
	return initial(evasion)


/mob/living/carbon/human/get_base_evasion()
	return species.evasion





/*
	Vision Range
*/
/datum/proc/update_vision_range()

/datum/proc/get_base_view_range()
	return world.view

/mob/living/get_base_view_range()
	return initial(view_range)


/mob/living/carbon/human/get_base_view_range()
	return species.view_range


/mob/update_vision_range()
	var/range = get_base_view_range()

	//We multiply by the result of each multiplicative modifier
	for (var/datum/extension/E as anything in LAZYACCESS(statmods, STATMOD_VIEW_RANGE))
		range += E.get_statmod(STATMOD_VIEW_RANGE)

	//Vision range can't go below 1
	range = clamp(range, 1, INFINITY)

	view_range = range
	if (client)
		client.set_view_range(view_range, TRUE)



