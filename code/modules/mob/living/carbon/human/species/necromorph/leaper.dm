/*
	Leaper

	Specialised ambush necromorph. Notable features:
		-Slow base movement speed and weak primary attacks
		-Very long vision radius
		-High evasion due to unusual posture
		-Leap attack allows rapid strike over long distances, flies over most intervening obstacles
		-Tail attack ability up close deals high damage
		-No legs. Uses arms and tail to move, can continue moving as long as at least one of the three remains
*/

/datum/species/necromorph/leaper
	name = SPECIES_NECROMORPH_LEAPER
	name_plural =  "Leapers"
	blurb = "Leapers appear to be made from a single human corpse, with the host body's modifications serving to give the Necromorph vastly increased mobility. he legs are completely re-shaped: the muscle and bone is flayed, fused together, and lengthened into a single limb tipped with a sharp blade of considerable weight and durability"
	unarmed_types = list(/datum/unarmed_attack/claws) //Bite attack is a backup if blades are severed
	total_health = 80

	icon_template = 'icons/mob/necromorph/64x64necros.dmi'
	icon_normal = "leaper"
	icon_lying = "leaper"
	icon_dead = "leaper"
	pixel_offset_x = -16
	pixel_offset_y = -20

	evasion = 30	//Harder to hit than usual

	view_range = 8
	view_offset = (WORLD_ICON_SIZE*3)	//Can see much farther than usual

	has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest),
	BP_GROIN =  list("path" = /obj/item/organ/external/groin),
	BP_HEAD =   list("path" = /obj/item/organ/external/head),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm/leaper),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/leaper),
	BP_TAIL =  list("path" = /obj/item/organ/external/tail/leaper)
	)

	inherent_verbs = list(/atom/movable/proc/leaper_leap, /atom/movable/proc/tailstrike_leaper)
	modifier_verbs = list(KEY_CTRLALT = list(/atom/movable/proc/leaper_leap),
	KEY_ALT = list(/atom/movable/proc/tailstrike_leaper))

	slowdown = 4

	//Leaper has no legs, it moves with arms and tail
	locomotion_limbs = list(BP_R_ARM, BP_L_ARM, BP_TAIL)

/datum/species/necromorph/leaper/enhanced
	name = SPECIES_NECROMORPH_LEAPER_ENHANCED
	unarmed_types = list(/datum/unarmed_attack/claws/strong)
	slowdown = 3
	total_health = 200
	evasion = 35

	inherent_verbs = list(/atom/movable/proc/leaper_leap_enhanced, /atom/movable/proc/tailstrike_leaper_enhanced)
	modifier_verbs = list(KEY_CTRLALT = list(/atom/movable/proc/leaper_leap_enhanced),
	KEY_ALT = list(/atom/movable/proc/tailstrike_leaper_enhanced))



//Light claw attack, not its main means of damage
/datum/unarmed_attack/claws/leaper
	damage = 7

/datum/unarmed_attack/claws/leaper/strong
	damage = 10.5 //Noninteger damage values are perfectly fine, contrary to popular belief


//The leaper has a tail instead of legs
/obj/item/organ/external/tail/leaper
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND | ORGAN_FLAG_CAN_GRASP


//The leaper's arms are used for locomotion so they get the stand flag too
/obj/item/organ/external/arm/leaper
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_GRASP | ORGAN_FLAG_CAN_STAND

/obj/item/organ/external/arm/right/leaper
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_GRASP | ORGAN_FLAG_CAN_STAND



//Leap attack
/atom/movable/proc/leaper_leap(var/atom/A)
	set name = "Leap"
	set category = "Abilities"

	//Do a chargeup animation. Pulls back and then launches forwards
	//The time is equal to the windup time of the attack, plus 0.5 seconds to prevent a brief stop and ensure launching is a fluid motion
	var/vector2/pixel_offset = Vector2.DirectionBetween(src, A) * -16
	var/vector2/cached_pixels = new /vector2(src.pixel_x, src.pixel_y)
	animate(src, pixel_x = src.pixel_x + pixel_offset.x, pixel_y = src.pixel_y + pixel_offset.y, time = 1.7 SECONDS, easing = BACK_EASING)
	animate(pixel_x = cached_pixels.x, pixel_y = cached_pixels.y, time = 0.3 SECONDS)

	return leap_attack(A, _cooldown = 6 SECONDS, _delay = 2 SECONDS, _speed = 5, _maxrange = 11,_lifespan = 8 SECONDS, _maxrange = 20)


/atom/movable/proc/leaper_leap_enhanced(var/atom/A)
	set name = "Leap"
	set category = "Abilities"


	//Do a chargeup animation
	var/vector2/pixel_offset = Vector2.DirectionBetween(src, A) * -16
	var/vector2/cached_pixels = new /vector2(src.pixel_x, src.pixel_y)
	animate(src, pixel_x = src.pixel_x + pixel_offset.x, pixel_y = src.pixel_y + pixel_offset.y, time = 0.7 SECONDS, easing = BACK_EASING)
	animate(pixel_x = cached_pixels.x, pixel_y = cached_pixels.y, time = 0.3 SECONDS)

	return leap_attack(A, _cooldown = 4 SECONDS, _delay = 1 SECONDS, _speed = 5, _maxrange = 11, _lifespan = 8 SECONDS, _maxrange = 20)


//Special effects for leaper impact, its pretty powerful if it lands on the primary target mob, but it backfires if it was blocked by anything else
/datum/species/necromorph/leaper/charge_impact(var/mob/living/user, var/atom/obstacle, var/power, var/target_type, var/distance_travelled)
	.=..()	//We call the parent charge impact too, all the following effects are in addition to the default behaviour

	shake_camera(user,5,3)

	//To be considered a success, we must leap onto a mob, and they must be the one we intended to hit
	if (isliving(obstacle) && target_type == CHARGE_TARGET_PRIMARY)
		var/mob/living/L = obstacle
		L.Weaken(5) //Down they go!
		L.apply_damage(3*(distance_travelled+1), used_weapon = user) //We apply damage based on the distance. We add 1 to the distance because we're moving into their tile too
		shake_camera(L,5,3)
		//And lets also land ontop of them
		spawn(2)
			user.Move(obstacle.loc)
	else if (obstacle.density)
	//If something else blocked our leap, or if we hit a dense object (even intentionally) we get pretty rattled
		user.Weaken(5)
		user.apply_damage(20, used_weapon = obstacle) //ow



//Tailstrike attack
/atom/movable/proc/tailstrike_leaper(var/atom/A)
	set name = "Tail Strike"
	set category = "Abilities"

	if (!A)
		A = get_step(src, dir)


	return tailstrike_attack(A, _damage = 25, _windup_time = 0.75 SECONDS, _winddown_time = 1.2 SECONDS, _cooldown = 0)


/atom/movable/proc/tailstrike_leaper_enhanced(var/atom/A)
	set name = "Tail Strike"
	set category = "Abilities"

	if (!A)
		A = get_step(src, dir)

	return tailstrike_attack(A, _damage = 28, _windup_time = 0.6 SECONDS, _winddown_time = 1 SECONDS, _cooldown = 0)