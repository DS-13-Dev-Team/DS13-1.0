/*
	Minor Necromorph
*/
/mob/living/simple_animal/necromorph
	min_gas = null
	max_gas = null
	harm_intent_damage = 5
	mass = 1
	density = FALSE
	var/lifespan = 10 MINUTES	//Minor necromorphs don't last forever, their health gradually ticks down
	stompable = TRUE

	mob_size = MOB_SMALL

	response_help   = "curiously touches"
	response_disarm = "frantically tries to clear off"
	response_harm   = "flails wildly at"

/mob/living/simple_animal/necromorph/Initialize()
	.=..()
	if (lifespan)
		var/time_per_tick = lifespan / max_health
		addtimer(CALLBACK(src, /mob/living/simple_animal/necromorph/proc/decay), time_per_tick)

//Take 1 point of lasting damage and queue another timer
/mob/living/simple_animal/necromorph/proc/decay()
	if (stat == DEAD)
		return
	adjustLastingDamage(1)


	if (stat == DEAD)
		return

	var/time_per_tick = lifespan / max_health
	addtimer(CALLBACK(src, /mob/living/simple_animal/necromorph/proc/decay), time_per_tick)

/mob/living/simple_animal/necromorph/is_necromorph()
	return TRUE


/mob/living/simple_animal/necromorph
/*
	Component Species

	This is only used for creating a preference option to opt in/out of playing components
	its not actually assigned to anyone
*/
/datum/species/necromorph/divider_component
	name = SPECIES_NECROMORPH_DIVIDER_COMPONENT
	marker_spawnable = FALSE
	spawner_spawnable = FALSE
	preference_settable = TRUE




/*
	Component Mobs
*/
/mob/living/simple_animal/necromorph/divider_component
	max_health = 35
	icon = 'icons/mob/necromorph/divider/components.dmi'
	var/leap_windup_time = 0.8 SECOND
	var/leap_range = 6

	speed = 3

/mob/living/simple_animal/necromorph/divider_component/Initialize()
	.=..()
	add_modclick_verb(KEY_ALT, /mob/living/simple_animal/necromorph/divider_component/proc/leap)
	get_controlling_player()




/mob/living/simple_animal/necromorph/divider_component/proc/get_controlling_player()
	SSnecromorph.fill_vessel_from_queue(src, SPECIES_NECROMORPH_DIVIDER_COMPONENT)

/mob/living/simple_animal/necromorph/divider_component/proc/leap(var/atom/A)
	set name = "Leap Attack"
	set category = "Abilities"

	//Leap autotargets enemies within one tile of the clickpoint
	if (!isliving(A))
		A = autotarget_enemy_mob(A, 2, src, 999)


	if (!can_charge(A))
		return

	//Do a chargeup animation. Pulls back and then launches forwards
	//The time is equal to the windup time of the attack, plus 0.5 seconds to prevent a brief stop and ensure launching is a fluid motion
	var/vector2/pixel_offset = Vector2.DirectionBetween(src, A) * -16
	var/vector2/cached_pixels = get_new_vector(src.pixel_x, src.pixel_y)
	animate(src, pixel_x = src.pixel_x + pixel_offset.x, pixel_y = src.pixel_y + pixel_offset.y, time = (leap_windup_time - (0.3 SECONDS)), easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(pixel_x = cached_pixels.x, pixel_y = cached_pixels.y, time = 0.3 SECONDS)

	release_vector(pixel_offset)
	release_vector(cached_pixels)

	//Long shout when targeting mobs, normal when targeting objects
	/*
	if (ismob(A))
		H.play_species_audio(H, SOUND_SHOUT_LONG, 100, 1, 3)
	else
		H.play_species_audio(H, SOUND_SHOUT, 100, 1, 3)
	*/

	return leap_attack(A, _cooldown = 6 SECONDS, _delay = (leap_windup_time - (0.2 SECONDS)), _speed = 7, _maxrange = 6, _lifespan = 5 SECONDS)







/*
	Arm

	Leaps onto mobs and latches on. Can also wallrun
*/
/mob/living/simple_animal/necromorph/divider_component/arm
	name = "arm"
	icon_state = "arm"
	speed = 2.75
	melee_damage_lower = 2
	melee_damage_upper = 4
	attacktext = "scratched"
	attack_sound = 'sound/weapons/bite.ogg'
	leap_range = 5

/mob/living/simple_animal/necromorph/divider_component/arm/Initialize()
	.=..()
	set_extension(src, /datum/extension/wallrun)

/mob/living/simple_animal/necromorph/divider_component/arm/charge_impact(var/datum/extension/charge/leap/charge)
	shake_camera(charge.user,5,3)
	.=TRUE
	if (isliving(charge.last_obstacle))
		//Lets make mount parameters for posterity. We're just using the default settings at time of writing, but maybe they'll change in future
		var/datum/mount_parameters/WP = new()
		WP.attach_walls	=	FALSE	//Can this be attached to wall turfs?
		WP.attach_anchored	=	FALSE	//Can this be attached to anchored objects, eg heaving machinery
		WP.attach_unanchored	=	FALSE	//Can this be attached to unanchored objects, like janicarts?
		WP.dense_only = FALSE	//If true, only sticks to dense atoms
		WP.attach_mob_standing		=	TRUE		//Can this be attached to mobs, like brutes?
		WP.attach_mob_downed		=	TRUE	//Can this be/remain attached to mobs that are lying down?
		WP.attach_mob_dead	=	FALSE	//Can this be/remain attached to mobs that are dead?
		charge.do_winddown_animation = FALSE
		mount_to_atom(src, charge.last_obstacle, /datum/extension/mount/parasite/arm, WP)



//Parasite Extension: The mob latches onto another mob and periodically bites it for some constant damage
/datum/extension/mount/parasite
	var/damage = 5
	var/damage_chance = 30

/datum/extension/mount/parasite/on_mount()
	.=..()
	START_PROCESSING(SSprocessing, src)



	var/mob/living/biter = mountee
	spawn(0.5 SECONDS)
		if (!QDELETED(biter) && !QDELETED(src) && mountpoint && mountee)
			//Lets put the parasite somewhere nice looking on the mob
			var/new_rotation = rand(-90, 90)
			var/new_x = rand(-8, 8)
			var/new_y = rand(0, 12)
			var/matrix/M = matrix()
			M = M.Scale(0.75)
			M = M.Turn(new_rotation)

			animate(biter, transform = M, pixel_x = new_x, pixel_y = new_y, time = 5, flags = ANIMATION_END_NOW)



/datum/extension/mount/parasite/on_dismount()
	.=..()
	STOP_PROCESSING(SSprocessing, src)
	var/mob/living/biter = mountee
	if (biter)
		biter.animate_to_default()

/datum/extension/mount/parasite/proc/safety_check()
	var/mob/living/biter = mountee
	var/mob/living/victim = mountpoint

	if (!istype(biter) || QDELETED(biter))
		return FALSE

	if (!istype(victim) || QDELETED(victim))
		return FALSE

	//Biter must be able bodied and alive
	if (biter.incapacitated())
		return FALSE

	//Victim must not be dead yet
	if (victim.stat == DEAD)
		return FALSE

	//We must still be on them
	if (get_turf(victim) != get_turf(biter))
		return FALSE

	return TRUE

/datum/extension/mount/parasite/Process()
	if (!safety_check())
		dismount()
		return PROCESS_KILL

	var/mob/living/biter = mountee
	var/mob/living/victim = mountpoint

	//If the biter is being grabbed, it doesnt fall off, but it can't bite either
	if (biter.grabbed_by.len)
		return

	if(prob(damage_chance))


		biter.launch_strike(target = victim, damage = src.damage, used_weapon = biter, damage_flags = DAM_SHARP, armor_penetration = 5, damage_type = BRUTE, armor_type = "melee", target_zone = ran_zone(), difficulty = 100)
		playsound(biter, 'sound/weapons/bite.ogg', VOLUME_LOW, 1)
		biter.heal_overall_damage(damage*0.25)	//The biter heals itself by nomming
		victim.shake_animation(10)
		biter.set_click_cooldown(4 SECONDS) //It can't do normal attacks while attached
		return TRUE

	return FALSE


//The divider arm has an additional effect, the target is steered around randomly
/datum/extension/mount/parasite/arm/Process()
	.=..()
	if (.)
		var/mob/living/victim = mountpoint
		victim.lurch()



/*
	Leg
	Kicks mobs and bounces off
*/
/mob/living/simple_animal/necromorph/divider_component/leg
	name = "leg"
	icon_state = "leg"
	speed = 3.5
	melee_damage_lower = 3
	melee_damage_upper = 6
	attacktext = "kicked"
	attack_sound = 'sound/weapons/bite.ogg'



//The leg's leap impact is a dropkick, both victim and leg are propelled away from each other wildly
//The victim recieves a heavy blunt hit
/mob/living/simple_animal/necromorph/divider_component/leg/charge_impact(var/datum/extension/charge/leap/charge)
	shake_camera(charge.user,5,3)
	.=TRUE
	if (isliving(charge.last_obstacle))
		var/mob/living/L = charge.last_obstacle
		L.shake_animation(15)
		shake_camera(L,10,6) //Smack
		launch_strike(L, damage = 10, used_weapon = src, damage_flags = 0, armor_penetration = 10, damage_type = BRUTE, armor_type = "melee", target_zone = get_zone_sel(src), difficulty = 50)
		//We are briefly stunned
		Stun(1)

	//And we're gonna do some knockback
	var/turf/epicentre = get_turf(charge.last_obstacle)
	if (istype(charge.last_obstacle, /atom/movable))
		var/atom/movable/AM = charge.last_obstacle
		AM.apply_push_impulse_from(src, 20)

	spawn()
		//And we ourselves also get knocked back
		//We spawn it off to let the current stack finish first, otherwise we get hit twice
		apply_push_impulse_from(epicentre, 20)









/*
	Head

	The head does not autofill from queue normally, the mob controlling the divider will take over it
*/
//If the divider player is still connected, they transfer control to the head
/obj/item/organ/external/head/create_divider_component(var/mob/living/carbon/human/H, var/deletion_delay)
	.=..()
	var/mob/living/simple_animal/necromorph/divider_component/L = .
	if (H && H.mind && H.client)
		H.mind.transfer_to(L)

	else
		//If the player can't take control, then we'll fetch someone from necroqueue
		L.get_controlling_player(TRUE)

	//Removing the head kills the divider's main body
	//We do a spawn then some checks here to prevent infinite loops
	spawn(1 SECOND)
		if (!QDELETED(H) && H.stat != DEAD)
			H.death()



/mob/living/simple_animal/necromorph/divider_component/head
	name = "head"
	icon_state = "head"

	melee_damage_lower = 4
	melee_damage_upper = 6
	attacktext = "whipped"
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 2
	leap_range = 4

/mob/living/simple_animal/necromorph/divider_component/head/get_controlling_player(var/fetch = FALSE)
	if (!fetch)
		return
	.=..()