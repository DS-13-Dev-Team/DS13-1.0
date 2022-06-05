/**
 * allow players to easily use items such as iron rods, rcds on open space without
 * having to pixelhunt for portions not occupied by object or mob visuals.
 */
/datum/element/openspace_item_click_handler
	element_flags = ELEMENT_DETACH

/datum/element/openspace_item_click_handler/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ITEM_AFTERATTACK, .proc/on_afterattack)

/datum/element/openspace_item_click_handler/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ITEM_AFTERATTACK)
	return ..()

//Invokes the proctype with a turf above as target.
/datum/element/openspace_item_click_handler/proc/on_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	SIGNAL_HANDLER
	if(target.z == user.z)
		return
	var/turf/turf_above = GetAbove(target)
	if(turf_above?.z == user.z)
		INVOKE_ASYNC(source, /obj/item.proc/handle_openspace_click, turf_above, user, user.CanReach(turf_above, source), click_parameters)

/// Called on [/datum/element/openspace_item_click_handler/proc/on_afterattack]. Check the relative file for information.
/obj/item/proc/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	crash_with("Undefined handle_openspace_click() behaviour. Ascertain the openspace_item_click_handler element has been attached to the right item and that its proc override doesn't call parent.")

/obj/item/stack/material/rods/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, target)
		if(L)
			return L.attackby(src, user)
		if(use(1))
			to_chat(user, SPAN_NOTICE("You lay down the support lattice."))
			playsound(target, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(target, material.name)

/obj/item/stack/tile/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag)
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, target)
		if(L)
			if (!use(1))
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			target.ChangeTurf(/turf/simulated/floor, keep_air = TRUE)
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))

/obj/item/stack/cable_coil/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	if(proximity_flag)
		turf_place(target, user)

/atom/movable/proc/DirectAccess()
	return list(src, loc)

/mob/DirectAccess(atom/target)
	return ..() + contents

/mob/living/DirectAccess(atom/target)
	return ..() + get_all_contents()

///Returns the src and all recursive contents as a list.
/atom/proc/get_all_contents()
	. = list(src)
	var/i = 0
	while(i < length(.))
		var/atom/checked_atom = .[++i]
		. += checked_atom.contents

/atom/movable/proc/CanReach(atom/ultimate_target, obj/item/tool, view_only = FALSE)
	var/list/direct_access = DirectAccess()
	var/depth = 3

	var/list/closed = list()
	var/list/checking = list(ultimate_target)
	while (checking.len && depth > 0)
		var/list/next = list()
		--depth

		for(var/atom/target in checking)  // will filter out nulls
			if(closed[target] || isarea(target))  // avoid infinity situations
				continue
			closed[target] = TRUE
			if(isturf(target) || isturf(target.loc) || (target in direct_access) || (ismovable(target))) //Directly accessible atoms
				if(Adjacent(target) || (tool && CheckToolReach(src, target, 1))) //Adjacent or reaching attacks
					return TRUE

			if (!target.loc)
				continue

		checking = next
	return FALSE

/proc/CheckToolReach(atom/movable/here, atom/movable/there, reach)
	if(!here || !there)
		return
	switch(reach)
		if(0)
			return FALSE
		if(1)
			return FALSE //here.Adjacent(there)
		if(2 to INFINITY)
			var/obj/dummy = new(get_turf(here))
			dummy.pass_flags |= PASS_FLAG_TABLE
			dummy.invisibility = INVISIBILITY_ABSTRACT
			for(var/i in 1 to reach) //Limit it to that many tries
				var/turf/T = get_step(dummy, get_dir(dummy, there))
				if(dummy.CanReach(there))
					qdel(dummy)
					return TRUE
				if(!dummy.Move(T)) //we're blocked!
					qdel(dummy)
					return
			qdel(dummy)
