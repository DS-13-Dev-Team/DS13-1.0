/mob/living/simple_animal/construct
	name = "Construct"
	real_name = "Construct"
	desc = ""
	speak = list("Hsssssssszsht.", "Hsssssssss...", "Tcshsssssssszht!")
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help  = "thinks better of touching"
	response_disarm = "flailed at"
	response_harm   = "punched"
	icon_dead = "shade_dead"
	speed = -1
	a_intent = I_HURT
	stop_automated_movement = 1
	status_flags = CANPUSH
	universal_speak = 0
	universal_understand = 1
	attack_sound = 'sound/weapons/spiderlunge.ogg'
	min_gas = null
	max_gas = null
	minbodytemp = 0
	show_stat_health = 1
	faction = "cult"
	supernatural = 1
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	var/nullblock = 0

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	var/list/construct_spells = list()

/mob/living/simple_animal/construct/cultify()
	return

/mob/living/simple_animal/construct/New()
	..()
	name = text("[initial(name)] ([random_id(/mob/living/simple_animal/construct, 1000, 9999)])")
	real_name = name
	add_language("Cult")
	add_language(LANGUAGE_GUTTER)
	for(var/spell in construct_spells)
		src.add_spell(new spell, "const_spell_ready")
	update_icon()

/mob/living/simple_animal/construct/death(gibbed, deathmessage, show_dead_message)
	new /obj/item/weapon/ectoplasm (src.loc)
	..(null,"collapses in a shattered heap.","The bonds tying you to this mortal plane have been severed.")
	ghostize()
	qdel(src)

/mob/living/simple_animal/construct/update_icon()
	overlays.Cut()
	..()
	add_glow()

/mob/living/simple_animal/construct/attack_generic(var/mob/user)
	if(istype(user, /mob/living/simple_animal/construct/builder))
		if(health < max_health)
			adjustBruteLoss(-5)
			user.visible_message("<span class='notice'>\The [user] mends some of \the [src]'s wounds.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] is undamaged.</span>")
		return
	return ..()

/mob/living/simple_animal/construct/examine(mob/user)
	. = ..(user)
	var/msg = "<span cass='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"
	if (src.health < src.max_health)
		msg += "<span class='warning'>"
		if (src.health >= src.max_health/2)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
		msg += "</span>"
	msg += "*---------*</span>"

	to_chat(user, msg)

/obj/item/weapon/ectoplasm
	name = "ectoplasm"
	desc = "Spooky."
	gender = PLURAL
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"

/////////////////Juggernaut///////////////



/mob/living/simple_animal/construct/armoured
	name = "Juggernaut"
	real_name = "Juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead"
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	max_health = 250
	health = 250
	speak_emote = list("rumbles")
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "smashed their armoured gauntlet into"
	mob_size = MOB_LARGE
	speed = 3
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)
	can_escape = 1

/mob/living/simple_animal/construct/armoured/Life()
	weakened = 0
	..()

/mob/living/simple_animal/construct/armoured/bullet_act(var/obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflectchance = 80 - round(P.damage/3)
		if(prob(reflectchance))
			adjustBruteLoss(P.damage * 0.5)
			visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
							"<span class='userdanger'>The [P.name] gets reflected by [src]'s shell!</span>")

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/turf/curloc = get_turf(src)

				// redirect the projectile
				P.redirect(new_x, new_y, curloc, src)

			return -1 // complete projectile permutation

	return (..(P))



////////////////////////Wraith/////////////////////////////////////////////



/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	icon_dead = "floating_dead"
	max_health = 75
	health = 75
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashed"
	speed = -1
	environment_smash = 1
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift)


/////////////////////////////Artificer/////////////////////////



/mob/living/simple_animal/construct/builder
	name = "Artificer"
	real_name = "Artificer"
	desc = "A bulbous construct dedicated to building and maintaining The Cult of Nar-Sie's armies"
	icon = 'icons/mob/mob.dmi'
	icon_state = "artificer"
	icon_living = "artificer"
	max_health = 50
	health = 50
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "rammed"
	speed = 0
	environment_smash = 1
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon
							)


/////////////////////////////Behemoth/////////////////////////


/mob/living/simple_animal/construct/behemoth
	name = "Behemoth"
	real_name = "Behemoth"
	desc = "The pinnacle of occult technology, Behemoths are the ultimate weapon in the Cult of Nar-Sie's arsenal."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	max_health = 750
	health = 750
	speak_emote = list("rumbles")
	response_harm   = "harmlessly punched"
	harm_intent_damage = 0
	melee_damage_lower = 50
	melee_damage_upper = 50
	attacktext = "brutally crushed"
	speed = 5
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	resistance = 10
	var/energy = 0
	var/max_energy = 1000
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)
	can_escape = 1

////////////////////////Harvester////////////////////////////////



/mob/living/simple_animal/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	desc = "The promised reward of the livings who follow Nar-Sie. Obtained by offering their bodies to the geometer of blood"
	icon = 'icons/mob/mob.dmi'
	icon_state = "harvester"
	icon_living = "harvester"
	icon_dead = "harvester_dead"
	max_health = 150
	health = 150
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "violently stabbed"
	speed = -1
	environment_smash = 1
	attack_sound = 'sound/weapons/pierce.ogg'

	construct_spells = list(
			/spell/targeted/harvest
		)

////////////////Glow//////////////////
/mob/living/simple_animal/construct/proc/add_glow()
	var/image/eye_glow = image(icon,"glow-[icon_state]")
	eye_glow.plane = ABOVE_LIGHTING_PLANE
	eye_glow.layer = LIGHTING_SECONDARY_LAYER
	overlays += eye_glow

////////////////HUD//////////////////////

/mob/living/simple_animal/construct/Life()
	. = ..()
	if(.)
		if(hud_used.fire)
			if(fire_alert)
				hud_used.fire.icon_state = "fire1"
			else
				hud_used.fire.icon_state = "fire0"
		if(hud_used.pullin)
			if(pulling)
				hud_used.pullin.icon_state = "pull1"
			else
				hud_used.pullin.icon_state = "pull0"

		if(hud_used.purged)
			if(purge > 0)
				hud_used.purged.icon_state = "purge1"
			else
				hud_used.purged.icon_state = "purge0"

		silence_spells(purge)

/mob/living/simple_animal/construct/armoured/Life()
	..()

	if(!client || !hud_used)
		return

	if(hud_used.healths)
		switch(health)
			if(250 to INFINITY)
				hud_used.healths.icon_state = "juggernaut_health0"
			if(208 to 249)
				hud_used.healths.icon_state = "juggernaut_health1"
			if(167 to 207)
				hud_used.healths.icon_state = "juggernaut_health2"
			if(125 to 166)
				hud_used.healths.icon_state = "juggernaut_health3"
			if(84 to 124)
				hud_used.healths.icon_state = "juggernaut_health4"
			if(42 to 83)
				hud_used.healths.icon_state = "juggernaut_health5"
			if(1 to 41)
				hud_used.healths.icon_state = "juggernaut_health6"
			else
				hud_used.healths.icon_state = "juggernaut_health7"


/mob/living/simple_animal/construct/behemoth/Life()
	..()

	if(!client || !hud_used)
		return

	if(hud_used.healths)
		switch(health)
			if(750 to INFINITY)
				hud_used.healths.icon_state = "juggernaut_health0"
			if(625 to 749)
				hud_used.healths.icon_state = "juggernaut_health1"
			if(500 to 624)
				hud_used.healths.icon_state = "juggernaut_health2"
			if(375 to 499)
				hud_used.healths.icon_state = "juggernaut_health3"
			if(250 to 374)
				hud_used.healths.icon_state = "juggernaut_health4"
			if(125 to 249)
				hud_used.healths.icon_state = "juggernaut_health5"
			if(1 to 124)
				hud_used.healths.icon_state = "juggernaut_health6"
			else
				hud_used.healths.icon_state = "juggernaut_health7"

/mob/living/simple_animal/construct/builder/Life()
	..()

	if(!client || !hud_used)
		return

	if(hud_used.healths)
		switch(health)
			if(50 to INFINITY)
				hud_used.healths.icon_state = "artificer_health0"
			if(42 to 49)
				hud_used.healths.icon_state = "artificer_health1"
			if(34 to 41)
				hud_used.healths.icon_state = "artificer_health2"
			if(26 to 33)
				hud_used.healths.icon_state = "artificer_health3"
			if(18 to 25)
				hud_used.healths.icon_state = "artificer_health4"
			if(10 to 17)
				hud_used.healths.icon_state = "artificer_health5"
			if(1 to 9)
				hud_used.healths.icon_state = "artificer_health6"
			else
				hud_used.healths.icon_state = "artificer_health7"



/mob/living/simple_animal/construct/wraith/Life()
	..()

	if(!client || !hud_used)
		return

	if(hud_used.healths)
		switch(health)
			if(75 to INFINITY)
				hud_used.healths.icon_state = "wraith_health0"
			if(62 to 74)
				hud_used.healths.icon_state = "wraith_health1"
			if(50 to 61)
				hud_used.healths.icon_state = "wraith_health2"
			if(37 to 49)
				hud_used.healths.icon_state = "wraith_health3"
			if(25 to 36)
				hud_used.healths.icon_state = "wraith_health4"
			if(12 to 24)
				hud_used.healths.icon_state = "wraith_health5"
			if(1 to 11)
				hud_used.healths.icon_state = "wraith_health6"
			else
				hud_used.healths.icon_state = "wraith_health7"


/mob/living/simple_animal/construct/harvester/Life()
	..()

	if(!client || !hud_used)
		return

	if(hud_used.healths)
		switch(health)
			if(150 to INFINITY)
				hud_used.healths.icon_state = "harvester_health0"
			if(125 to 149)
				hud_used.healths.icon_state = "harvester_health1"
			if(100 to 124)
				hud_used.healths.icon_state = "harvester_health2"
			if(75 to 99)
				hud_used.healths.icon_state = "harvester_health3"
			if(50 to 74)
				hud_used.healths.icon_state = "harvester_health4"
			if(25 to 49)
				hud_used.healths.icon_state = "harvester_health5"
			if(1 to 24)
				hud_used.healths.icon_state = "harvester_health6"
			else
				hud_used.healths.icon_state = "harvester_health7"
