//This variant specifically deals with unarmed attacks. IE, a creature - often humanoid - using some part of its body to strike a target

/atom/proc/launch_unarmed_strike(var/atom/target, var/datum/unarmed_attack/method, var/_target_zone)
	if (!method)
		if (ishuman(src))
			var/mob/living/carbon/human/H = src
			var/hit_zone = get_zone_sel(H)
			method = H.get_unarmed_attack(src, hit_zone)
		if(!method)
			return 0
	else if (ispath(method))
		//We may be passed a typepath, if so initialise it
		method = new method()

	var/mob/living/carbon/human/H
	if (ishuman(src))
		H = src
		if(world.time < H.last_attack + method.get_delay(H))
			to_chat(H, "<span class='notice'>You can't attack again so soon.</span>")
			return null
		else
			H.last_attack = world.time

		H.set_click_cooldown(method.get_delay(H))

	var/datum/strike/unarmed/strike = new /datum/strike/unarmed(src, target, method, _target_zone)
	strike.start()

	//Here seems a good enough place for attack audio
	//Its not impact sounds, but screams of rage while swinging
	if (H && H.check_audio_cooldown(SOUND_ATTACK))
		H.play_species_audio(H, SOUND_ATTACK, VOLUME_MID, 1)
		H.set_audio_cooldown(SOUND_ATTACK, 3 SECONDS)

	return strike







/datum/strike/unarmed
	var/datum/unarmed_attack/attack

/datum/strike/unarmed/Destroy()
	attack = null
	.=..()


/datum/strike/unarmed/cache_data(var/atom/user, var/atom/target, var/datum/unarmed_attack/attack, var/_target_zone)

	src.user = user
	src.target = target
	src.attack = attack
	name = pick(attack.attack_noun)

	world << "Target zone 1 is [target_zone], param: [_target_zone]"

	src.damage = attack.get_unarmed_damage(user)
	if (attack.rand_damage)
		damage += rand_between(attack.rand_damage*-1, attack.rand_damage)

	if (!_target_zone)
		if (istype(user, /mob/living))
			target_zone = get_zone_sel(user)
			world << "Target zone 1a is [target_zone]"
	else
		src.target_zone = _target_zone
		world << "Target zone 1b is [target_zone]"


	world << "Target zone 2 is [target_zone]"

	CACHE_USER

	armor_penetration = attack.armor_penetration
	src.used_weapon = user
	damage_flags = attack.damage_flags()
	src.difficulty = attack.difficulty
	src.allow_dismemberment = attack.allow_dismemberment

	if (istype(target, /obj))
		src.damage *= attack.structure_damage_mult


/datum/strike/unarmed/impact_mob()

	.=..()
	// Apply additional unarmed effects, but only if we dealt damage. Completely blocked hits don't get any effects
	if (.)
		attack.apply_effects(src)

/datum/strike/unarmed/get_impact_sound()
	.=..()
	if (!.)
		if (islist(attack.attack_sound))
			return pick(attack.attack_sound)
		return attack.attack_sound

/datum/strike/unarmed/show_result()
	var/sound = get_impact_sound()
	if (blocker)
		if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
		target.shake_animation(3)
		user.shake_animation(3)
	else if (!damage_done)
		if (sound)	playsound(target, sound, VOLUME_QUIET, 1)
	else
		if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
		target.shake_animation(8)
	attack.show_attack(src)