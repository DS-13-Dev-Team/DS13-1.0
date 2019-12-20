/datum/species/necromorph/brute
	name = SPECIES_NECROMORPH_BRUTE
	name_plural =  "Brutes"
	blurb = "The Brute is a large Necromorph composed of multiple human corpses. It has heavy organic armor in its front and possesses extreme physical \
	strength, making it a deadly foe in combat. "
	total_health = 300
	torso_damage_mult = 1 //Hitting centre mass is fine for brute

	icon_template = 'icons/mob/necromorph/64x64necros.dmi'
	icon_normal = "brute"
	icon_lying = "brute"//Temporary icon so its not invisible lying down
	icon_dead = "brute"

	pixel_offset_x = -16
	plane = LARGE_MOB_PLANE
	layer = LARGE_MOB_LAYER


	//Collision and bulk
	strength    = STR_VHIGH
	mob_size	= MOB_LARGE
	bump_flag 	= HEAVY	// What are we considered to be when bumped?
	push_flags 	= ALLMOBS	// What can we push?
	swap_flags 	= ALLMOBS	// What can we swap place with?
	density_lying = TRUE	//Chunky boi
	evasion = -10	//Big target, easier to shoot

	//Implacable
	stun_mod = 0.5
	weaken_mod = 0.3
	paralysis_mod = 0.3

	inherent_verbs = list(/atom/movable/proc/brute_charge, /atom/movable/proc/brute_slam, /atom/movable/proc/curl_verb, /mob/proc/shout)
	modifier_verbs = list(KEY_ALT = list(/atom/movable/proc/brute_charge),
	KEY_CTRLALT = list(/atom/movable/proc/brute_slam),
	KEY_CTRLSHIFT = list(/atom/movable/proc/curl_verb))

	unarmed_types = list(/datum/unarmed_attack/punch/brute)

	slowdown = 5 //Note, this is a terribly awful way to do speed, bay's entire speed code needs redesigned
	slow_turning = TRUE		//Slow turning and limited clicks ensures he can't just 360quickscope someone who sneaked up behind
	limited_click_arc = 90

	//Vision
	view_range = 4
	view_offset = 3 * WORLD_ICON_SIZE

	//Brute Armor vars
	var/armor_front = 30	//Flat reduction applied to incoming damage within a 45 degree cone infront
	var/armor_flank = 20	//Flat reduction applied to incoming damage within a 90 degree cone infront. Doesnt stack with front
	var/curl_armor_mult = 1.5	//Multiplier applied to armor when we are curled up
	var/armor_coverage = 95 //What percentage of our body is covered by armor plating. 95 = 5% chance for hits to strike a weak spot


	has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest/giant),
	BP_GROIN =  list("path" = /obj/item/organ/external/groin/giant),
	BP_HEAD =   list("path" = /obj/item/organ/external/head/giant),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm/giant),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/giant),
	BP_L_LEG =  list("path" = /obj/item/organ/external/leg/giant),
	BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/giant),
	BP_L_HAND = list("path" = /obj/item/organ/external/hand/giant),
	BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/giant),
	BP_L_FOOT = list("path" = /obj/item/organ/external/foot/giant),
	BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/giant)
	)


	//Audio
	step_volume = 10 //Brute stomps are low pitched and resonant, don't want them loud
	step_range = 4
	step_priority = 5
	pain_audio_threshold = 0.03 //Gotta set this low to compensate for his high health
	species_audio = list(SOUND_FOOTSTEP = list('sound/effects/footstep/brute_step_1.ogg',
	'sound/effects/footstep/brute_step_2.ogg',
	'sound/effects/footstep/brute_step_3.ogg',
	'sound/effects/footstep/brute_step_4.ogg',
	'sound/effects/footstep/brute_step_5.ogg',
	'sound/effects/footstep/brute_step_6.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/brute/brute_pain_1.ogg',
	 'sound/effects/creatures/necromorph/brute/brute_pain_2.ogg',
	 'sound/effects/creatures/necromorph/brute/brute_pain_3.ogg',
	 'sound/effects/creatures/necromorph/brute/brute_pain_extreme.ogg' = 0.2),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/brute/brute_death.ogg'),
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/brute/brute_attack_1.ogg',
	'sound/effects/creatures/necromorph/brute/brute_attack_2.ogg',
	'sound/effects/creatures/necromorph/brute/brute_attack_3.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/brute/brute_shout_1.ogg',
	'sound/effects/creatures/necromorph/brute/brute_shout_2.ogg',
	'sound/effects/creatures/necromorph/brute/brute_shout_3.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/brute/brute_shout_long.ogg')
	)

/*
	Brute charge: Slower but more powerful due to mob size.
	Shorter windup time making it deadly at close range
	Inertia is enabled, it will keep going til it faceplants into a wall
*/
/atom/movable/proc/brute_charge(var/atom/A)
	set name = "Charge"
	set category = "Abilities"


	.= charge_attack(A, _delay = 1.5 SECONDS, _speed = 3, _lifespan = 8 SECONDS, _inertia = TRUE)
	if (.)
		var/mob/living/carbon/human/H = src
		if (istype(H))
			H.face_atom(A)
			if (isliving(A) && prob(40)) //When we're charging a mob, sometimes do the long shout
				H.play_species_audio(H, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 5)
			else
				H.play_species_audio(H, SOUND_SHOUT, VOLUME_HIGH, 1, 5)
		shake_animation(50)


/atom/movable/proc/brute_slam()
	set name = "Slam"
	set category = "Abilities"

	var/A = LAZYACCESS(args, 1)
	if (!A)
		A = get_step(src, dir)


	.=slam_attack(A, _damage = 35, _power = 1, _cooldown = 10 SECONDS)
	if (.)
		var/mob/living/carbon/human/H = src
		H.play_species_audio(H, SOUND_SHOUT, VOLUME_HIGH, 1, 3)





/*
	Brute punch, heavy damage, slow
*/
/datum/unarmed_attack/punch/brute
	delay = 25
	damage = 25
	airlock_force_power = 5
	airlock_force_speed = 2.5
	shredding = TRUE //Better environment interactions, even if not sharp

//Brute punch causes knockback on any mob smaller than itself
/datum/unarmed_attack/punch/brute/apply_effects(var/mob/living/carbon/human/user,var/atom/target,var/armour,var/attack_damage,var/zone)

	if (isliving(target))
		var/mob/living/L = target
		if (user.mob_size > L.mob_size)
			//Ok we will knock it back! Lets do some math

			//Get a vector representing the offset from us to target
			var/vector2/delta
			if (get_turf(user) == get_turf(target))
				var/turf/T = get_step(user, user.dir)
				delta = new(T.x - user.x, T.y - user.y)
			else
				delta = new(L.x - user.x, L.y - user.y)
			delta = delta.ToMagnitude(5) //Rescale it to a length of 5 tiles. This is our approximate knockback distance, although it may end up shorter with rounding and diagonals

			var/turf/target_turf = locate(user.x + delta.x, user.y + delta.y, user.z) //Get the target turf to knock them towards
			if (target_turf)
				//Throw the victim towards the target
				L.throw_at(target_turf, 5, 1, user)

				//Note, a speed of 1 here means travel 1 tile then sleep(1)
				//This is really awful, and throw_at badly needs redesigned. But for now we will make do
				return TRUE

	//Return parent as a fallback if something went wrong
	return ..()


/*
	Brute Armor
*/

//The brute takes less damage from front and side attacks.
/datum/species/necromorph/brute/handle_organ_external_damage(var/obj/item/organ/external/organ, brute, burn, damage_flags, used_weapon)
	//First of all, we need to figure out where the attack is coming from
	var/atom/source
	if (isatom(used_weapon))	//Its possible used weapon might be a string, useless to us

		source = get_turf(used_weapon)


	if (!source)
		return ..() //If we can't figure out where the attack came from, we'll just let it through

	//Now that we know where it came from, lets figure out who we are
	var/mob/living/L = organ.owner

	//If its a projectile inour turf, we'll check the turf it came from instead
	if (isprojectile(used_weapon))
		var/obj/item/projectile/P = used_weapon
		if (P.loc == L.loc)
			source = get_turf(P.last_loc)

	//Lastly, if the source is ourselves, or on the same tile as us, we'll let it through
	if (used_weapon == L || source == L.loc)
		return ..()

	//Now lets check if we're curled up
	var/curled = FALSE
	var/datum/extension/curl/E = get_extension(L, /datum/extension/curl)
	if(istype(E) && E.status == 2) //Status 2 is curled up
		curled = TRUE

	//Ok, how much can we take off this damage
	var/reduction = 0

	//First of all lets factor in the possibility of the hit striking a gap in our armor
	//Note: The gaps are covered up when curled
	if (curled || prob(armor_coverage))
		if (target_in_frontal_arc(L, source, 45)) //If its within 45 degrees, we use front armor
			reduction = armor_front
		else if (target_in_frontal_arc(L, source, 90)) //If its >45 but within 90, we use the weaker flank armor
			reduction = armor_flank

		if (curled)
			reduction *= curl_armor_mult

	if (!reduction)
		//The target must be behind us or hit a gap, the attack will go through unhindered
		if(!curled && L.curl_ability(_automatic = TRUE, _force_time = 5 SECONDS))
			to_chat(L, SPAN_DANGER("You reflexively curl up in panic"))
		return ..()

	//Ok lets reduce that damage!
	//Brute first
	if (brute > 0)
		var/minus = min(reduction, brute)
		brute -= minus
		reduction -= minus
	//Then burn if theres any
	if (burn > 0 && reduction > 0)
		var/minus = min(reduction, burn)
		burn -= minus
		reduction -= minus

	//Now lets see if we got it all
	if (burn <= 0 && brute <= 0)
		//We blocked it! Lets do any effects related to bouncing off
		handle_armor_bounceoff(L, used_weapon)

	return ..()

//Brute armor does various neat effects if it fully blocks a hit
/datum/species/necromorph/brute/proc/handle_armor_bounceoff(var/mob/user, var/atom/A)
	if (isprojectile(A))
		//Projectiles will ricochet off in a random direction
		var/obj/item/projectile/P = A
		P.last_result = PROJECTILE_DEFLECT
		return

	//Mobs striking the armor with melee attacks will be rattled
	var/mob/living/M
	if (ismob(A))
		M=A
	else
		M = A.get_holding_mob()

	if (M)
		//We found a mob
		M.Stun(3)
		M.shake_animation(40)
		shake_camera(M, duration = 4 SECONDS, strength = 5)
		return