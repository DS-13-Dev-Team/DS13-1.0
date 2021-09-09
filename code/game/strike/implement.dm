//Implement
//--------
//This variant specifically deals with humans swinging objects. Tools, knives, swords, etc
/datum/strike/implement
	var/obj/item/used_item

/datum/strike/implement/Destroy()
	used_item = null
	.=..()

/datum/strike/implement/cache_data(var/atom/user, var/atom/target, var/obj/item/used_weapon)
	src.user = user
	src.target = target
	damage = used_weapon.force
	CACHE_USER
	src.used_weapon = used_weapon
	used_item = used_weapon

	damage_flags = used_weapon.damage_flags()
	armor_penetration = used_item.armor_penetration

	//The item will modify the strike
	if (istype(used_item))
		used_item.get_strike_damage(src)


/datum/strike/implement/impact_mob()
	used_item.apply_hit_effect(target, user, target_zone)
	L.hit_with_weapon(src)

/datum/strike/implement/show_result()
	var/sound = get_impact_sound()
	if (L)
		if (blocker)
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(3)
			user.shake_animation(3)
			var/obj/item/organ/external/original = H.get_organ(original_target_zone)
			user.visible_message("<span class='minorwarning'>[user] tried to [pick(used_item.attack_noun)] [target] in the [original.name] but was blocked by [H.get_pronoun(POSESSIVE_ADJECTIVE)] [blocker.name]!</span>")


		else
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(8)
			user.visible_message("<span class='warning'>[user] [pick(used_item.attack_verb)] [target] [affecting ? "in the [affecting.name]":""]!</span>")
	else
		user.visible_message("<span class='warning'>[user] [pick(used_item.attack_verb)] [target] [affecting ? "in the [affecting.name]":""][damage_done?"":", to no effect"]!</span>")


/datum/strike/implement/setup_difficulty()
	difficulty += used_item.melee_accuracy_bonus


/datum/strike/implement/get_impact_sound()
	.=..()
	if (!.)
		return used_item.hitsound
