var/const/GHOST_IMAGE_NONE = 0
var/const/GHOST_IMAGE_DARKNESS = 1
var/const/GHOST_IMAGE_SIGHTLESS = 2
var/const/GHOST_IMAGE_ALL = ~GHOST_IMAGE_NONE

/mob/dead/observer
	density = 0
	alpha = 127
	plane = OBSERVER_PLANE
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER
	sight = SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
	atom_flags = ATOM_FLAG_INTANGIBLE
	simulated = FALSE
	stat = DEAD
	status_flags = GODMODE
	var/ghost_image_flag = GHOST_IMAGE_DARKNESS
	var/image/ghost_image = null //this mobs ghost image, for deleting and stuff
	can_block_movement = FALSE

/mob/dead/observer/New()
	..()
	ghost_image = image(src.icon,src)
	ghost_image.plane = plane
	ghost_image.layer = layer
	ghost_image.appearance = src
	ghost_image.appearance_flags = RESET_ALPHA
	if(ghost_image_flag & GHOST_IMAGE_DARKNESS)
		ghost_darkness_images |= ghost_image //so ghosts can see the eye when they disable darkness
	if(ghost_image_flag & GHOST_IMAGE_SIGHTLESS)
		ghost_sightless_images |= ghost_image //so ghosts can see the eye when they disable ghost sight
	updateallghostimages()

/mob/dead/observer/movement_delay()
	var/tally = WALK_DELAY
	if (move_speed_factor)
		tally /= move_speed_factor
	set_glide_size(DELAY2GLIDESIZE(tally))
	return tally

/mob/dead/observer/Destroy()
	if (ghost_image)
		ghost_darkness_images -= ghost_image
		ghost_sightless_images -= ghost_image
		qdel(ghost_image)
		ghost_image = null
		updateallghostimages()
	. = ..()

//Observers of all kinds can jump to things, since they have inherent teleporting and incorporeal movement
/mob/dead/observer/can_jump_to_link()
	return TRUE

/mob/dead/observer/check_airflow_movable()
	return FALSE

/mob/dead/observer/CanPass()
	return TRUE

/mob/dead/observer/dust()	//observers can't be vaporised.
	return

/mob/dead/observer/gib()		//observers can't be gibbed.
	return

/mob/dead/observer/is_blind()	//Not blind either.
	return

/mob/dead/observer/is_deaf() 	//Nor deaf.
	return

/mob/dead/observer/set_stat()
	stat = DEAD // They are also always dead

/proc/updateallghostimages()
	for (var/mob/dead/observer/ghost/O in GLOB.player_list)
		O.updateghostimages()

/mob/dead/observer/touch_map_edge()
	if(z in GLOB.using_map.sealed_levels)
		return

	var/new_x = x
	var/new_y = y

	if(x <= TRANSITIONEDGE)
		new_x = TRANSITIONEDGE + 1
	else if (x >= (world.maxx - TRANSITIONEDGE + 1))
		new_x = world.maxx - TRANSITIONEDGE
	else if (y <= TRANSITIONEDGE)
		new_y = TRANSITIONEDGE + 1
	else if (y >= (world.maxy - TRANSITIONEDGE + 1))
		new_y = world.maxy - TRANSITIONEDGE

	var/turf/T = locate(new_x, new_y, z)
	if(T)
		forceMove(T)
		inertia_dir = 0
		throwing = 0
		to_chat(src, "<span class='notice'>You cannot move further in this direction.</span>")



//Turns a mob into an observer, deleting their old mob
/proc/make_observer(var/mob/M)
	if(!M.client)
		return null

	deltimer(M.client.lobby_trackchange_timer) //Ensures that the client doesn't attempt to start another lobby music track

	var/mob/dead/new_player/N
	if (istype(M, /mob/dead/new_player))
		N = M
		if (N.spawning)
			return
		N.spawning = TRUE
		N.close_spawn_windows()
	var/mob/dead/observer/ghost/observer = new(M)


	SEND_SOUND(observer, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo


	observer.started_as_observer = 1

	var/obj/O = locate("landmark*Observer-Start")
	if(istype(O))
		to_chat(observer, "<span class='notice'>Now teleporting.</span>")
		observer.forceMove(O.loc)
	else
		to_chat(observer, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the map.</span>")
	observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

	if(isnull(observer.client.holder))
		announce_ghost_joinleave(observer)

	var/mob/living/carbon/human/dummy/mannequin = new()
	observer.client.prefs.dress_preview_mob(mannequin)
	observer.set_appearance(mannequin)
	qdel(mannequin)

	if(observer.client.prefs.be_random_name)
		observer.client.prefs.real_name = random_name(observer.client.prefs.gender)
	observer.real_name = observer.client.prefs.real_name
	observer.SetName(observer.real_name)
	if(!observer.client.holder && !CONFIG_GET(flag/antag_hud_allowed))           // For new ghosts we remove the verb from even showing up if it's not allowed.
		remove_verb(observer, /mob/dead/observer/ghost/verb/toggle_antagHUD)        // Poor guys, don't know what they are missing!
	qdel(M)

	return 1


/mob/dead/observer/Login()
	..()

	//Get rid of any view offsets from the last mob we inhabited
	if (client)
		client.pixel_x = 0
		client.pixel_y = 0