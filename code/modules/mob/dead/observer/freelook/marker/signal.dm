GLOBAL_LIST_INIT(signal_sprites, list("markersignal-1",
	"markersignal-2",
	"markersignal-3",
	"markersignal-4",
	"markersignal-5",
	"markersignal-6",
	"markersignal-7",
	"markersignal-8",
	"markersignal-9",
	"markersignal-10",
	"markersignal-11",
	"markersignal-12",
	"markersignal-13",
	"markersignal-14",
	"markersignal-15",
	"markersignal-16",
	"markersignal-17",
	"markersignal-18",
	"markersignal-19",
	"markersignal-20",
	"markersignal-21",
	"markersignal-22",
	"markersignal-23",
	"markersignal-24",
	"markersignal-25"
	))

/mob/dead/observer/signal
	name = "Signal"
	real_name = "Signal"
	icon = 'icons/mob/eye.dmi'
	icon_state = "markersignal"
	atom_flags = ATOM_FLAG_INTANGIBLE
	plane = ABOVE_OBSCURITY_PLANE
	invisibility = INVISIBILITY_MARKER
	see_invisible = SEE_INVISIBLE_MARKER
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	hud_type = /datum/hud/marker
	var/name_sufix = "Eye"
	var/sprint = 10
	var/cooldown = 0
	var/acceleration = 1
	var/owner_follows_eye = 0
	var/mob/owner = null
	var/energy_extension_type = /datum/extension/psi_energy/signal
	var/datum/extension/psi_energy/psi_energy

	var/datum/preferences/prefs

	var/list/variations

	movement_handlers = list(
		/datum/movement_handler/mob/delay,
		/datum/movement_handler/mob/incorporeal/eye,
	)

	var/list/visibleChunks = list()
	var/datum/markernet/visualnet
	var/static_visibility_range = 16

/mob/dead/observer/signal/pointed()
	set popup_menu = 0
	set src = usr.contents
	return 0

/mob/dead/observer/signal/examine(mob/user)
	return

/mob/dead/observer/signal/Move(n, direct)
	if(owner == src)
		return EyeMove(direct)
	return 0

/mob/dead/observer/signal/proc/possess(var/mob/user)
	if(owner && owner != user)
		return
	if(owner && owner.eyeobj != src)
		return
	owner = user
	owner.set_eyeobj(src)
	SetName("[owner.name] ([name_sufix])") // Update its name
	if(owner.client)
		owner.client.eye = src
		owner.update_vision_range()
	setLoc(owner)
	if (visualnet)
		visualnet.visibility(src)

/mob/dead/observer/signal/proc/release(var/mob/user)
	if(owner != user || !user)
		return
	if(owner.eyeobj != src)
		return
	if (visualnet)
		visualnet.eyes -= src
		visibleChunks.Cut()
	owner.eyeobj = null
	owner.update_vision_range()
	owner = null
	SetName(initial(name))

// Use this when setting the eye's location.
// It will also stream the chunk that the new loc is in.
/mob/dead/observer/signal/proc/setLoc(var/T)
	if(!owner)
		return FALSE

	T = get_turf(T)
	if(!T || T == loc)
		return FALSE

	forceMove(T)

	if(owner.client)
		owner.client.eye = src
	if(owner_follows_eye)
		owner.forceMove(loc)

	if (visualnet)
		visualnet.visibility(src)
	return TRUE

/mob/dead/observer/signal/proc/getLoc()
	if(owner)
		if(!isturf(owner.loc) || !owner.client)
			return
		return loc

/mob/dead/observer/signal/EyeMove(direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.time)
		sprint = initial

	for(var/i = 0; i < max(sprint, initial); i += 20)
		var/turf/step = get_step(src, direct)
		if(step)
			setLoc(step)

	cooldown = world.time + 5
	if(acceleration)
		sprint = min(sprint + 0.5, max_sprint)
	else
		sprint = initial
	return 1

/mob/dead/observer/signal/set_eyeobj(var/atom/new_eye)
	eyeobj = new_eye
	//No messing with movement handlers here


/mob/dead/observer/signal/is_necromorph()
	return TRUE

/mob/dead/observer/signal/apply_customisation(var/datum/preferences/prefs)
	var/list/custom
	if (prefs)
		custom = prefs.get_necro_custom_list()
	else
		//With blank prefs, we use the global default
		custom = get_default_necro_custom()
	var/list/things = custom[SIGNAL][SIGNAL_DEFAULT]
	if (length(things))
		variations = things.Copy()
	update_icon()

/mob/dead/observer/signal/update_icon()
	if (LAZYLEN(variations))
		icon_state = pick(variations)
	else
		icon_state = pick(GLOB.signal_sprites)

//This will have a mob passed in that we were created from
/mob/dead/observer/signal/Initialize(mapload)
	. = ..()
	visualnet = GLOB.necrovision	//Set the visualnet of course
	visualnet.eyes += src

	variations = GLOB.signal_sprites.Copy()	//All are enabled by default

	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/body = loc
		mind = body.mind
		key = body.key
		possess(src) //Possess thyself
		SetName("[initial(name)] ([key])")
		real_name = "[initial(name)] ([key])"

	add_verb(src, /mob/proc/prey_sightings)

	forceMove(T)

	PushClickHandler(/datum/click_handler/signal)

//Joining and leaving
//-------------------------------
/mob/dead/observer/ghost/verb/join_marker_verb()
	set name = "Join Necromorph Horde"
	set category = "Necromorph"
	set desc = "Joins the necromorph team, and allows you to control horrible creatures."

	var/response = tgui_alert(src, "Would you like to join the necromorph side?", "Make us whole again", list("Yes", "No"))
	if (response != "Yes")
		return

	var/mob/dead/observer/signal/S = join_marker()	//This cannot fail, do safety checks first
	S.jump_to_marker()

/mob/proc/join_marker()
	message_necromorphs(SPAN_NOTICE("[key] has joined the necromorph horde."))
	var/mob/dead/observer/signal/S = new(src)
	set_necromorph(TRUE)

	return S

/mob/dead/observer/signal/verb/leave_marker_verb()
	set name = "Leave Necromorph Horde"
	set category = "Necromorph"
	set desc = "Leaves the necromorph team, making you a normal ghost"

	//Lets not look like an eye after we become a ghost
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"


	if(key)
		message_necromorphs(SPAN_NOTICE("[key] has left the necromorph horde."))
		set_necromorph(FALSE)
	qdel(src)


//Signals don't leave behind ghosts if they are clientless
/mob/dead/observer/signal/ghostize(var/can_reenter_corpse = CORPSE_CAN_REENTER)
	//Lets not look like an eye after we become a ghost
	icon = 'icons/mob/mob.dmi'
	icon_state = "ghost"
	if(key)
		message_necromorphs(SPAN_NOTICE("[key] has left the necromorph horde."))
		set_necromorph(FALSE)
	return ..()


//Possession and evacuating
//-------------------------------
/mob/dead/observer/signal/verb/necro_posses_verb()
	set name = "Posses Necromorph"
	set category = "Necromorph"
	set desc = "Take control of a necromorph vessel"

	var/list/possible_hosts = list()
	for(var/mob/living/carbon/human/necromorph/necro in SSnecromorph.major_vessels)
		if(!necro.client && necro.stat != DEAD)
			possible_hosts += necro
	var/choice = tgui_input_list(usr, "Pick the necromorph from the current list", "Who you want to be?", possible_hosts)
	if(choice)
		necro_possess(choice)



/mob/dead/observer/signal/verb/necro_possess(var/mob/living/L)
	set name = "Possess"
	set category = null
	set desc = "Take control of a necromorph vessel"

	if (!istype(L))
		to_chat(src, SPAN_DANGER("That can't be possessed!"))
		return

	if (L.stat == DEAD)
		to_chat(src, SPAN_DANGER("That vessel is damaged beyond usefulness"))
		return

	if (!L.is_necromorph())
		to_chat(src, SPAN_DANGER("You can only possess necromorph units."))
		return

	if (L.client)
		to_chat(src, SPAN_DANGER("Error: [L.key] is already controlling [L]"))
		return

	//Seems clear
	message_necromorphs(SPAN_NOTICE("[key] has taken control of [L]."))
	L.mind = mind
	L.key = key
	L.client.init_verbs()

	L.set_stat(CONSCIOUS)
	L.SetSleeping(0)
	L.eye_blurry = 0
	L.eye_blind = 0

	qdel(src)

/mob/proc/necro_evacuate()
	set name = "Evacuate"
	set category = "Necromorph"
	set desc = "Depart your body and return to the marker. You can go back and forth with ease"

	return necro_ghost()


//Evacuates a mob from their body but makes them a marker signal instead of a normal ghost
/mob/proc/necro_ghost()
	if (is_marker_master(src))	//If they are the marker's player, lets be sure to put them into the correct signal type
		var/obj/machinery/marker/marker = get_marker()
		if (marker)
			marker.become_master_signal(src)
		return
	else
		var/mob/signal = new /mob/dead/observer/signal(src)
		signal.client?.init_verbs()
		if(isobserver(src) && !issignal(src))
			qdel(src)
		return signal


//Signals cant become signals, silly
/mob/dead/observer/signal/necro_ghost()
	return src





//Necroqueue Handling
//---------------------------


/mob/dead/observer/signal/Login()
	..()
	set_necromorph(TRUE)
	SSnecromorph.signals |= src
	start_energy_tick()

	//Lets load preferences if possible
	//This will set our icon to one of the players' chosen ones

	if (client)
		apply_customisation(client.prefs)

		for(var/datum/markerchunk/chunk as anything in visibleChunks)
			client.images += chunk.active_masks
		visualnet.visibility(src)

	spawn(1)	//Prevents issues when downgrading from master
		if (!istype(src, /mob/dead/observer/signal/master))	//The master doesn't queue
			add_verb(src, /mob/dead/observer/signal/proc/join_necroqueue)
			if (client && client.prefs && client.prefs.auto_necroqueue)
				SSnecromorph.join_necroqueue(src)

/mob/dead/observer/signal/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	..()
	if(client)
		visualnet.visibility(src)
		update_static(old_loc)
	return TRUE

/mob/dead/observer/signal/Logout()
	if (!istype(src, /mob/dead/observer/signal/master))
		SSnecromorph.remove_from_necroqueue(src)
	.=..()
	spawn()
		if(!QDELETED(src))
			qdel(src)	//A signal shouldn't exist with nobody in it

/mob/dead/observer/signal/Destroy()
	SSnecromorph.remove_from_necroqueue(src)
	SSnecromorph.signals -= src
	visualnet.eyes -= src
	visibleChunks.Cut()
	release(owner)
	owner = null
	visualnet = null
	return ..()

/mob/dead/observer/signal/proc/join_necroqueue()
	set name = "Join Necroqueue"
	set category = SPECIES_NECROMORPH

	SSnecromorph.join_necroqueue(src)


/mob/dead/observer/signal/proc/leave_necroqueue()
	set name = "Leave Necroqueue"
	set category = SPECIES_NECROMORPH

	SSnecromorph.remove_from_necroqueue(src)

//Misc Verbs
//--------------------------------
/mob/dead/observer/signal/verb/jump_to_marker()
	set name = "Jump to Marker"
	set category = SPECIES_NECROMORPH

	if (SSnecromorph.marker)
		forceMove(get_turf(SSnecromorph.marker))
		return

	to_chat(src, SPAN_DANGER("Error: No marker found!"))

/mob/dead/observer/signal/verb/jump_to_alive_necro()
	set name = "Jump to Necromorph"
	set category = SPECIES_NECROMORPH

	if(SSnecromorph.major_vessels.len <= 0)
		to_chat(src, SPAN_DANGER("No living necromorphs found!"))
		return

	var/necro = tgui_input_list(src, "Choose necromorph to jump", "Jumping menu", SSnecromorph.major_vessels)
	if(necro)
		forceMove(get_turf(necro))
		return

	to_chat(src, SPAN_DANGER("You didn't choose a necromorph to jump!"))






/*
	Interaction
*/
/datum/click_handler/signal

/datum/click_handler/signal/OnLeftClick(var/atom/A, var/params)
	return A.attack_signal(user)

/datum/click_handler/signal/OnShiftClick(var/atom/A, var/params)
	return user.examinate(A)

/atom/proc/attack_signal(var/mob/dead/observer/signal/user)
	return TRUE


/*
	Energy Handling
*/
/mob/dead/observer/signal/proc/start_energy_tick()
	if (!key)
		return	//Logged in players only
	var/datum/player/myself = get_or_create_player(key)
	psi_energy = get_or_create_extension(myself, energy_extension_type)
	psi_energy.start_ticking()






/mob/dead/observer/signal/verb/ability_menu()
	set name = "Ability Menu"
	set desc = "Opens the menu to cast abilities using your psi energy"
	set category = "Necromorph"


	var/datum/extension/psi_energy/PE	= get_energy_extension()
	PE.ui_interact(src)


/*
	Verb handling
*/
/mob/dead/observer/signal/update_verbs()
	.=..()
	update_verb(/mob/proc/jump_to_shard, (SSnecromorph.shards.len > 0))	//Give us the verb to jump to shards, if there are any

/*
	Helper
*/

//Called from new_player/New when a player disconnects and then reconnects while playing as signal/marker
//This proc recreates the appropriate mob type and puts them in it
/mob/proc/create_signal()
	if (is_marker_master(src))
		return SSnecromorph.marker.become_master_signal(src)
	else
		return join_marker()


/mob/dead/new_player/create_signal()
	spawning = TRUE
	if (!QDELETED(src))
		close_spawn_windows()
	.=..()



