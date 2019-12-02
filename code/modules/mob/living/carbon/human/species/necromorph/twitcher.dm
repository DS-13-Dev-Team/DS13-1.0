/*
	The Twitcher
	Subtype of slasher. A slasher created from someone who was wearing a stasis module
	They're slightly out of phase with time or something like that

	Fastest necro in the game.
	Same power as a slasher, but faster all around

	Unique Features:
		-Charge attack starts with shortrange blink
		-Defensive blink to dodge one attack, every 5 seconds
		-Random blink while walking

	Note: Blink = reallyfast movement that looks like teleporting
*/
/datum/species/necromorph/slasher/twitcher
	name = SPECIES_NECROMORPH_TWITCHER
	name_plural = "Twitchers"
	blurb = "The infection process is doing something strange to these soldiers. They all had built-in Stasis units in their body armor. The infection is merging the Stasis unit into their flesh or something... making them move fast... real fast. Be careful."
	icon_normal = "twitcher"
	icon_lying = "twitcher"
	icon_dead = "twitcher"

	slowdown = 1.5
	view_offset = 3 * WORLD_ICON_SIZE //Forward view offset allows longer-ranged charges

	inherent_verbs = list(/atom/movable/proc/twitcher_charge)
	modifier_verbs = list(KEY_ALT = list(/atom/movable/proc/twitcher_charge))

	var/blink_damage_mult = 0.5 	//When the twitcher dodges an attack, the incoming damage is multiplied by this value

//Setup the twitch extension which handles a lot of the special behaviour
/datum/species/necromorph/slasher/twitcher/add_inherent_verbs(var/mob/living/carbon/human/H)
	.=..()
	set_extension(H, /datum/extension/twitch, /datum/extension/twitch)



//Their own version of blade attack. Same damage, but lower delay
/datum/unarmed_attack/blades/fast
	delay = 8


//Twitcher charge
//Aside from being faster moving, it also kicks off with a shortrange teleport
/atom/movable/proc/twitcher_charge(var/atom/A)
	set name = "Charge"
	set category = "Abilities"


	.= charge_attack(A, _delay = 1.3 SECONDS, _speed = 6)
	if (.)
		var/mob/H = src
		if (istype(H))
			H.face_atom(A)
		//Do some audio cues here
		shake_animation(30)
		spawn(13)
			if (!(A && (isturf(A.loc) || isturf(A)) && src && isturf(src.loc) && can_continue_charge()))
				//Safety checks
				return

			//Lets teleport up to 3 spaces towards the target just as we start running, to scare them
			if (get_dist(src, A) <= 2)
				return	//Can't do this if we're too close

			var/vector2/delta = new /vector2(A.x - x, A.y - y)
			delta = delta.ToMagnitude(3)
			var/turf/blink_target = locate(x+delta.x, y+delta.y, z)
			if (blink_target)
				var/datum/extension/twitch/T = get_extension(src, /datum/extension/twitch)
				T.move_to(blink_target, speed = 12)



//Defensive blinking
//The twitcher will dodge one attack every 5 secs or so, greatly reducing its damage and moving to a nearby tile
/datum/species/necromorph/slasher/twitcher/handle_organ_external_damage(var/obj/item/organ/external/organ, brute, burn, damage_flags, used_weapon)
	var/mob/living/L = organ.owner
	var/datum/extension/twitch/T = get_extension(L, /datum/extension/twitch)
	if (T && T.displace(TRUE))
		//Displace will return false if its on cooldown
		brute *= blink_damage_mult
		burn *= blink_damage_mult

	return ..()