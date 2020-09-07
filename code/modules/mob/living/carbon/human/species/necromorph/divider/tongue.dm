/*
	Tongue Attack

	Fires a projectile which leads the tongue.
	The actual tongue is drawn as a tracer effect which follows the projectile

	If it hits a mob, wraps around their neck and begins an execution move. At this point, the tongue becomes a targetable object
*/
#define TONGUE_PROJECTILE_SPEED	3.5
#define	TONGUE_OFFSET	-8,40
#define TONGUE_RANGE	5
/*
	Ability
*/
/mob/living/carbon/human/proc/divider_tongue(var/atom/A)
	set name = "Tonguetacle"
	set category = "Abilities"
	set desc = "Launches out your tongue to grab a human and strangle them. HK: Ctrl+alt+click"

	face_atom(A)
	.= shoot_ability(/datum/extension/shoot/tongue, A , /obj/item/projectile/tongue, accuracy = 200, dispersion = 0, num = 1, windup_time = 0.5 SECONDS, fire_sound = null, nomove = 1 SECOND, cooldown = 10 SECONDS)
	if (.)
		play_species_audio(src, SOUND_ATTACK, VOLUME_MID, 1, 3)



/*
	Extension
*/
/datum/extension/shoot/tongue
	name = "Divider Tongue"
	base_type = /datum/extension/shoot/tongue


/*
	Lead Projectile
*/
/obj/item/projectile/tongue
	name = "tongue leader"
	icon_state = ""
	fire_sound = null
	damage = 0
	nodamage = TRUE
	step_delay = (10 / TONGUE_PROJECTILE_SPEED)
	kill_count = TONGUE_RANGE	//Short-ish range
	var/obj/effect/projectile/tether/tongue/tongue = null


/obj/item/projectile/tongue/expire()
	set waitfor = FALSE
	world << "Tongue leader expiring"
	//On expiring the tongue projectile flies back towards the host
	expired = TRUE
	var/vector2/return_loc = firer.get_global_pixel_offset(src)
	var/return_time = (return_loc.Magnitude() / WORLD_ICON_SIZE) * (step_delay* 0.75)

	sleep(1 SECOND)
	tongue.retract(return_time)
	sleep(return_time)

	.=..()

/obj/item/projectile/tongue/Destroy()
	world << "Tongue leader deleting"
	.=..()

/*
	The firer will be set just before this proc is called
*/
/obj/item/projectile/tongue/launch(atom/target, var/target_zone, var/x_offset=0, var/y_offset=0, var/angle_offset=0)
	tongue = new(get_turf(src))
	tongue.set_origin(firer)
	tongue.alpha = 0
	//update_tongue(FALSE)
	.=..()


/obj/item/projectile/tongue/Move(NewLoc,Dir=0)
	world << "Tongue moved to [jumplink(NewLoc)]"
	update_tongue()
	.=..()

/obj/item/projectile/tongue/proc/update_tongue(var/animate = TRUE)
	tongue.alpha = 255
	var/vector2/origin_pixels = firer.get_global_pixel_loc()
	var/vector2/current_pixels = get_global_pixel_loc()
	tongue.set_ends(origin_pixels, current_pixels, (animate ? step_delay : FALSE))
	release_vector(origin_pixels)
	release_vector(current_pixels)


/obj/item/projectile/tongue/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)

	//Are they a valid execution target?
	if (divider_tongue_start(firer, target_mob))
		//Yes, lets do this!
		tongue.set_target(target_mob)

		//Here we start the execution, and transfer ownership of the tongue tether
		firer.perform_execution(/datum/extension/execution/divider_tongue, target_mob)
		qdel(src)//Delete ourselves WITHOUT calling expire
		return
	.=..()


/*
	Tether
*/
/obj/effect/projectile/tether/tongue
	icon = 'icons/effects/tethers.dmi'
	icon_state = "tongue"
	base_length = WORLD_ICON_SIZE*2
	offset = new /vector2(TONGUE_OFFSET)
	plane = HUMAN_PLANE
	layer = BELOW_HUMAN_LAYER


/*
	Safety Checks

	Core checks. It is called as part of other check procson initial tongue contact, and periodically while performing the execution.
	If it returns false, the execution is denied or cancelled.
*/
/proc/divider_tongue_safety(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)

	//We only target humans
	if (!istype(user) || !istype(target))
		return FALSE

	//Abort if either mob is deleted
	if (QDELETED(user) || QDELETED(target))
		return FALSE

	//Don't target our allies
	if (target.is_necromorph())
		return FALSE

	//The divider needs its head to have a tongue
	if (!user.get_organ(BP_HEAD))
		return FALSE

	//The divider needs to be awake and able bodied. Needs a firm footing
	if (user.incapacitated(INCAPACITATION_FORCELYING))
		return FALSE

	return TRUE


/*
	Start check, called to see if we can grab the mob
*/
/proc/divider_tongue_start(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	//Core first
	.=divider_tongue_safety(user, target)
	if (!.)
		return

	//Now in addition

	//The target must be alive when we start.
	if (target.stat == DEAD)
		return FALSE

	//The target must have a head for us to rip off
	if (!target.get_organ(BP_HEAD))
		return FALSE

	//The target must be standing
	if (target.lying)
		return FALSE

	return TRUE


/*
	Continue check, called during the execution, this has three return values
	0 = FAIL, the execution is cancelled
	1 = continue, keep going
	2 = win, the execution ends successfully, the victim is killed and we skip to the final stage
*/
/proc/divider_tongue_continue(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	//Core first
	.=divider_tongue_safety(user, target)
	if (!.)
		return

	//Now in addition

	//If the target's head has been removed since we started, then we win! Decapitating them is our goal
	if (!target.get_organ(BP_HEAD))
		return 2

	//If the target died from anything other than losing their head, we have failed
	if (target.stat == DEAD)
		return FALSE


	return TRUE


/*
	Execution
*/
/datum/extension/execution/divider_tongue
	name = "Tonguetacle"
	base_type = /datum/extension/execution/divider_tongue
	cooldown = 0	//Cooldown isnt handled here
	require_grab = FALSE
	reward_biomass = 5
	reward_energy = 100
	reward_heal = 40
	range = TONGUE_RANGE
	all_stages = list(/datum/execution_stage/wrap,
	/datum/execution_stage/strangle/first,
	/datum/execution_stage/strangle/second,
	/datum/execution_stage/strangle/third,
	/datum/execution_stage/finisher/decapitate,
	/datum/execution_stage/tripod_bisect)


	vision_mod = -4


/datum/extension/execution/divider_tongue/interrupt()
	.=..()
	user.play_species_audio(src, SOUND_PAIN, VOLUME_MID, 1, 2)

/datum/extension/execution/divider_tongue/can_start()
	if (!divider_tongue_start(user, victim))
		return FALSE
	.=..()


/*
	Stages
*/
/datum/execution_stage/wrap/enter()
	//victim.Root()
	victim.losebreath += 4



/*
	Strangle stages are the meat of this attack.
	They keep hitting every 2 seconds until the total damage of the victim's head is at or above the specified percentage of max
*/
/datum/execution_stage/strangle
	var/head_damage_threshold = 0.33
	var/damage_per_hit = 6
	duration = 2 SECONDS

/datum/execution_stage/strangle/enter()

	//If we've already won, skip this and just return
	var/safety_result = divider_tongue_continue(user, victim)
	if (safety_result == 2)
		return

	var/done = FALSE
	while (!done)

		//First of all, safety check
		var/safety_result = divider_tongue_continue(user, victim)
		if (safety_result == 2)
			//TODO: Skip to the end immediately
				done = TRUE
			continue


		//Execution has failed and will be aborted now
		if (!safety_result)
			//The safety check will run again when it tries to advance, and abort at that point, we just return for now
			done = TRUE
			continue


		//Okay now lets check the victim's health. We know they still have a head
		var/obj/item/organ/external/E = victim.get_organ(BP_HEAD)
		var/dampercent = E.damage / E.max_damage
		if (dampercent >= head_damage_threshold)
			done = TRUE
			continue


		//The victim is weak enough to keep hitting, and they are still alive
		//They are being strangled, can't breathe. Even if they had an eva suit, the air supply hose is constricted
		victim.losebreath++

		//Do the actual damage. The functionally infinite difficulty means it cant be blocked, but armor may still help resist it
		user.launch_strike(victim, damage_per_hit, victim, DAM_EDGE, 0, BRUTE, armor_type = "melee", target_zone = BP_HEAD, difficulty = 999999)

		//The victim and their camera shake wildly as they struggle
		shake_camera(victim, 2, 3)
		victim.shake_animation(12)

		sleep(duration)


/datum/execution_stage/strangle/second
	head_damage_threshold = 0.66

/datum/execution_stage/strangle/third
	head_damage_threshold = 0.66