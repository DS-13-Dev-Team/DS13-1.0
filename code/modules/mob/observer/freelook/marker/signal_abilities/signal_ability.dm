/*
	Signal abilities are "spells" that can be used by signals, and the marker, while in their observer modes.
	They cost psi energy, which is passively gained over time while in the right modes.

	Almost all signal abilities can only be cast upon tiles visible to the necrovision network.
	Many, more restrictive ones, can only be cast upon corrupted tiles. And often only when not visible to humans
*/


/datum/signal_ability
	var/name = "Ability"

	var/id = "ability"	//ID should be unique and all lowercase

	var/desc = "Does stuff!"

	//Cost of casting it. Can be zero
	var/energy_cost = 60

	var/base_type = /datum/signal_ability	//Used to prevent abstract parent classes from showing up in autoverbs

	//If the user clicks something which isn't a valid target, we'll search in this radius around the clickpoint to find a valid target.
	//A value of zero still works, and will search only in the clicked turf. Set to null to disable autotargeting.
	//UNIMPLEMENTED//var/autotarget_range = 1

	//Many spells have cooldowns in addition to costs
	//UNIMPLEMENTED//var/cooldown = 10 SECONDS

	//What types of atom we are allowed to target with this ability. This will be used for autotargeting
	//Any number of valid types can be put in this list
	var/target_types = list(/turf)

	//If set to true or false, this requires the target to be an ally or not-ally of the user, respectively,
	//Only used when targeting mobs. Leave it null to disable this behaviour
	//UNIMPLEMENTED//var/allied_check = null


	//If true, can only be cast on turfs currently in the necrovision network.
	//When false, spells can be cast onto the blackspace outside it. Not very useful but has some potential applications
	//This setting is completely ignored if require_corruption is set true, they are exclusive
	var/require_necrovision = TRUE

	//When true, the turf which contains/is the target must have corruption on it.
	var/require_corruption = FALSE

	//When true, the turf which contains/is the target must not be visible to any conscious crewmember
	//UNIMPLEMENTED//var/LOS_blocked	=	TRUE

	//When set to a number, the spell must be cast at least this distance away from a conscious crewmember
	//UNIMPLEMENTED//var/distance_blocked = 1

	//If true, this spell can only be cast after the marker has activated
	//If false, it can be cast anytime from roundstart
	//UNIMPLEMENTED//var/marker_active_required = FALSE


	//How many targets this spell needs. This may allow casting on multiple things at once, or tracing a path. Default 1
	//UNIMPLEMENTED//var/num_targets


	//Targeting Handling:
	//--------------------------
	var/targeting_method	=	TARGET_CLICK

	//What type of click handler this uses to select a target, if any
	//Only used when targeting method is not self
	//If not specified, defaults will be used for click and placement
	var/click_handler_type =	null

	//Atom used for the preview image of placement handler, if we're using that
	var/placement_atom = null

	//Does placement handler snap-to-grid?
	var/placement_snap = TRUE







/*----------------------------------------------
	Overrides:
	Override these in subclasses to do things
-----------------------------------------------*/
//This does nothing in the base class, override it and put spell effects here
/datum/signal_ability/proc/on_cast(var/atom/target, var/mob/user, var/list/data)
	return



//Entrypoint to this code, called when user clicks the button to start a spell.
//This code creates the click handler
/datum/signal_ability/proc/start_casting(var/mob/user)
	switch(targeting_method)
		if (TARGET_CLICK)
			//We make a target clickhandler, this callback is sent through to the handler's /New. User will be maintained as the first argument
			//When the user clicks, it will call target_click, passing back the user, as well as the thing they clicked on, and clickparams
			var/datum/click_handler/CH = user.PushClickHandler((click_handler_type ? click_handler_type : /datum/click_handler/target), CALLBACK(src, /datum/signal_ability/proc/target_click, user))
			CH.id = "[src.type]"
		if (TARGET_PLACEMENT)
			//Make the placement handler, passing in atom to show. Callback is propagated through and will link its clicks back here
			var/datum/click_handler/CH = create_placement_handler(user, placement_atom, click_handler_type ? click_handler_type : /datum/click_handler/placement/ability, placement_snap, CALLBACK(src, /datum/signal_ability/proc/placement_click, user))
			CH.id = "[src.type]"
		if (TARGET_SELF)
			select_target(user, user)

//Path to the end of the cast
/datum/signal_ability/proc/finish_casting(var/atom/target, var/mob/user, var/list/data)

	//Pay the energy costs
	if (!pay_cost())
		//TODO: Abort casting, we failed
		return

	//And do the actual effect of the spell
	on_cast(target, user, data)

	//TODO 1: Call a cleanup/abort proc to finish
	stop_casting(user)

//This is called after finish, or at any point during casting if things fail.
//It deletes clickhandlers, cleans up, etc.
/datum/signal_ability/proc/stop_casting(var/mob/user)

	//Search the user's clickhandlers for any which have an id matching our type, indicating we put them there. And remove those
	for (var/datum/click_handler/CH in user.GetClickHandlers())
		if (CH.id == "[src.type]")
			user.RemoveClickHandler(CH)


//Called from the click handler when the user clicks a potential target.
//Data is an associative list of any miscellaneous data. It contains the direction for placement handlers
/datum/signal_ability/proc/select_target(var/candidate, var/mob/user, var/list/data)
	var/newtarget = candidate
	if (!is_valid_target(newtarget))	//If its not right, then find a better one
		newtarget = get_valid_target(candidate)

	if (!newtarget)
		return FALSE

	.=TRUE
	//TODO 2:	Add add a flag to not instacast here

	finish_casting(newtarget, user, data)














/*-----------------------------
	Click Handling
------------------------------*/

//Called from a click handler using the TARGET_CLICK method
/datum/signal_ability/proc/target_click(var/mob/user, var/atom/target, var/params)
	return select_target(target, user)


//Special clickhandler variant used to place ability items
/datum/click_handler/placement/ability/spawn_result(var/turf/site)
	//We should have done all necessary checks here, so we are clear to proceed
	call_on_place.Invoke(site, user, dir)

/datum/signal_ability/proc/placement_click(var/mob/user, var/atom/target, var/direction)
	return select_target(target, user, list("direction" = direction))








/*---------------------------
	Safety Checks
----------------------------*/

/*
	Checks whether the given user is currently able to cast this spell.
	This is called before casting starts, so no targeting data yet. It checks:
		-Available energy
		-Correct mob type

	This proc will either return TRUE if no problem, or an error message if there is a problem
*/
/datum/signal_ability/proc/can_cast_now(var/mob/user)
	.=TRUE
	if (!user)	//If there's no user, maybe we're casting it via script. Just let it through
		return

	var/datum/player/P = user.get_player()
	if (energy_cost)
		var/datum/extension/psi_energy/PE = get_extension(P, /datum/extension/psi_energy)
		if (!PE)
			return "You have no energy!"

		if (!(PE.can_afford_energy_cost(energy_cost, src)))
			return "Insufficient energy."


	//TODO 1: Check cooldown, mob type and marker activity requirement


//Does a lot of checking to see if the specified target is valid
/datum/signal_ability/proc/is_valid_target(var/atom/thing)
	var/correct_type = FALSE
	for (var/typepath in target_types)
		if (istype(thing, typepath))
			correct_type = TRUE
			break

	if (!correct_type)
		return FALSE


	var/turf/T = get_turf(thing)
	if (require_corruption)
		//Since corrupted tiles are always visible to necrovision, we dont check vision if corruption is required
		if (!turf_corrupted(T))
			return FALSE
	else if (require_necrovision)
		if (!T.is_in_visualnet(GLOB.necrovision))
			return FALSE
	//TODO 1: Check Necrovision requirement
	//TODO 1: Check allied status

	return TRUE

/*
	Actually deducts energy, sets cooldowns, and makes any other costs as a result of casting. Returns true if all succeed
*/
/datum/signal_ability/proc/pay_cost(var/mob/user)
	.= FALSE


	//TODO 1: Set cooldown here


	//Pay energy cost last
	var/datum/player/P = user.get_player()
	if (energy_cost)
		var/datum/extension/psi_energy/PE = get_extension(P, /datum/extension/psi_energy)
		if (!PE)
			return

		if (!(PE.can_afford_energy_cost(energy_cost, src)))
			return

		PE.change_energy(-energy_cost)


	return TRUE



/client/verb/cast_ability(var/aname as text)
	set name = "Cast Ability"
	set category = "Debug"

	aname = lowertext(aname)
	var/datum/signal_ability/SA = GLOB.signal_abilities[aname]
	if (SA)
		SA.start_casting(mob)