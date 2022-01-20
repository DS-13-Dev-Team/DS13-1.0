

//This dims the visible screen
//It renders above everything in the world, but below the pipe overlays from ventcrawling
/atom/movable/screen/fullscreen/ventcrawl
	icon_state = "black"
	layer = 0
	alpha = 140
	plane = BLACKNESS_PLANE
	no_animate = TRUE



//This simple extension handles the onscreen tracker to prevent duplication of it
/datum/extension/ventcrawl_tracker
	var/atom/movable/screen/movable/tracker/tracker

/datum/extension/ventcrawl_tracker/New(var/mob/newholder)
	.=..()
	tracker = new /atom/movable/screen/movable/tracker/ventcrawl(newholder, newholder)


/datum/extension/ventcrawl_tracker/Destroy()
	QDEL_NULL(tracker)
	.=..()

/atom/movable/screen/movable/tracker/ventcrawl	
	icon = 'icons/hud/old-noborder.dmi'
	icon_state =  "mask"
	layer = ABOVE_LIGHTING_LAYER
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	mouse_opacity = 2


/mob/living/carbon/human/proc/burst_out()
	set name = "Vent Ambush"
	set desc = "Break out and terrify nearby crew, buffing yourself, debuffing them, and granting free attacks on anyone within reach"
	set category = "Abilities"
	
	to_chat(world, "Burst out 1")

	var/obj/machinery/atmospherics/unary/vent/V = loc

	//Gotta be actually inside the vent and it needs to have the cover intact
	if (!istype(V) || V.cover_status != VENT_COVER_INTACT)
		to_chat(src, SPAN_DANGER("You can only use this when lurking inside an intact, unsealed vent cover"))
		return
	
	to_chat(world, "Burst out 2")


	var/turf/T = get_turf(V)
	//Exit out of the vent. We technically do this before the breaking to avoid being flopped out
	V.ventcrawl_exit(src, T)

	//Tiny mobs can't break the cover, they just slip through it
	if (mob_size < MOB_SMALL)
		return

	to_chat(world, "Burst out 3")

	//The vent breaks in the process, so nobody can use this same vent for an ambush again
	V.break_cover()

	/*
		Okay we are now outside of the vent system
		We apply a buff, do a scream and swing wildly at nearby crew
	*/
	set_extension(src, /datum/extension/effect/vent_ambush_buff)

	


	//Everyone in view of the bursting mob gets debuffed
	for (var/mob/living/carbon/human/H in view(7, T))
		set_extension(H, /datum/extension/effect/vent_ambush_debuff)
		//And some screenshake
		shake_camera(H, 30)


	//A free attack on everyone in arm's reach
	var/current_target_zone = get_zone_sel()
	for (var/mob/living/carbon/human/H in range(reach, T))
		
		if (!H.is_necromorph())
			last_attack = 0
			set_random_zone()
			UnarmedAttack(H)

	set_zone_sel(current_target_zone)

	//Scream to make lotsa noise and scare folk
	spawn()
		do_shout()


/*
	When jumping out of a vent, that necromorph gets significant buffs for a short duration
*/
/datum/extension/effect/vent_ambush_buff
	statmods = list(STATMOD_EVASION = 10,
	STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = 0.5,
	STATMOD_MOVESPEED_MULTIPLICATIVE = 1.5,
	STATMOD_ATTACK_SPEED = 1.5)

	duration = 6 SECONDS


/*
	All nearby crewmembers are afflicted with a debuff for the same duration
*/
/datum/extension/effect/vent_ambush_debuff
	statmods = list(STATMOD_EVASION = -10,
	STATMOD_RANGED_ACCURACY = -10,
	STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = 1.2,
	STATMOD_MOVESPEED_MULTIPLICATIVE = 0.5,
	STATMOD_ATTACK_SPEED = 0.75)

	duration = 6 SECONDS