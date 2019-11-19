/datum/species/necromorph/brute
	name = SPECIES_NECROMORPH_BRUTE
	name_plural =  "Brutes"
	blurb = "The Brute is a large Necromorph composed of multiple human corpses. It has heavy organic armor in its front and possesses extreme physical \
	strength, making it a deadly foe in combat. "
	total_health = 300

	icon_template = 'icons/mob/necromorph/64x64necros.dmi'
	icon_normal = "brute"
	icon_lying = "brute_lying"
	icon_dead = "brute_dead"

	pixel_offset_x = -16

	strength    = STR_VHIGH
	mob_size	= MOB_LARGE

	//Implacable
	stun_mod = 0.3
	weaken_mod = 0.3
	paralysis_mod = 0.3

	inherent_verbs = list(/atom/movable/proc/brute_charge, /atom/movable/proc/brute_slam)
	modifier_verbs = list(KEY_ALT = list(/atom/movable/proc/brute_charge),
	KEY_CTRLALT = list(/atom/movable/proc/brute_slam))
	unarmed_types = list(/datum/unarmed_attack/punch/brute) //Bite attack is a backup if blades are severed

	slowdown = 5 //Note, this is a terribly awful way to do speed, bay's entire speed code needs redesigned

/*
	Brute charge: Slower but more powerful due to mob size
*/
/atom/movable/proc/brute_charge(var/atom/A)
	set name = "Charge"
	set category = "Abilities"


	.= charge_attack(A, _delay = 2 SECONDS, _speed = 4, _lifespan = 4 SECONDS)
	if (.)
		var/mob/H = src
		if (istype(H))
			H.face_atom(A)
		//Do some audio cues here
		shake_animation(50)


/atom/movable/proc/brute_slam(var/A)
	set name = "Slam"
	set category = "Abilities"

	world << "Brute slam [A]"
	if (!A)
		A = get_step(src, dir)

	world << "Calling slam attack"
	return slam_attack(A, _damage = 35, _power = 2, _cooldown = 10 SECONDS)






/*
	Brute punch, heavy damage, slow
*/
/datum/unarmed_attack/punch/brute
	delay = 20
	damage = 30
	airlock_force_power = 5
	airlock_force_speed = 2.5
	shredding = TRUE //Better environment interactions, even if not sharp

//Brute punch causes knockback on any mob smaller than itself
/datum/unarmed_attack/punch/brute/apply_effects(var/mob/living/carbon/human/user,var/atom/target,var/armour,var/attack_damage,var/zone)
	world << "Brutepunch AE [target]"
	if (isliving(target))
		world << "Brutepunch living"
		var/mob/living/L = target
		if (user.mob_size > L.mob_size)
			world << "Brutepunch size"
			//Ok we will knock it back! Lets do some math

			//Get a vector representing the offset from us to target
			var/vector2/delta = new(L.x - user.x, L.y - user.y)
			delta = delta.ToMagnitude(5) //Rescale it to a length of 5 tiles. This is our approximate knockback distance, although it may end up shorter with rounding and diagonals

			var/turf/target_turf = locate(user.x + delta.x, user.y + delta.y, user.z) //Get the target turf to knock them towards
			world << "Brutepunch target_turf [jumplink(target_turf)]"
			if (target_turf)
				//Throw the victim towards the target
				world << "Brutepunch launching [L] at target"
				L.throw_at(target_turf, 5, 1, user)

				//Note, a speed of 1 here means travel 1 tile then sleep(1)
				//This is really awful, and throw_at badly needs redesigned. But for now we will make do
				return TRUE

	//Return parent as a fallback if something went wrong
	return ..()