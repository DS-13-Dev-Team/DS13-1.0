/datum/signal_ability/assault_wave
	name = "Assault Wave"
	id = "assault"
	desc	=	"This powerful spell applies a long-lasting buff to all necromorphs in existence, boosting their movement and attackspeeds by 15%, and their evasion by 5%\
	The energy cost is relatively cheap, and the effect lasts for 3 minutes. It's extremely useful!\
	\
	The downside however, is the extremely long cooldown, of 15 minutes. Once used, it'll be quite a while before the next time. So you should strive to make the most of it,\
	 by spawning lots of necromorphs and having them wait until you're ready to launch an assault with a large group all at once."
	energy_cost = 500
	cooldown = 15 MINUTES
	targeting_method	=	TARGET_SELF
	base_type = /datum/signal_ability/assault_wave
	autotarget_range = 0
	require_corruption = FALSE



/* Crossing Effect */
//-------------------
//Any mob that walks over a corrupted tile recieves this effect. It does varying things
	//On most mobs, it applies a slow to movespeed
	//On necromorphs, it applies a passive healing instead

/datum/extension/assault_wave
	name = "Corruption Effect"
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	//Effects on necromorphs
	var/speed_factor = 1.15
	var/attackspeed_factor	=	1.15
	var/evasion_bonus = 	5
	var/health_factor	=	1.1


	var/speed_delta	//What absolute value we removed from the movespeed factor. This is cached so we can reverse it later
	var/attackspeed_delta
	var/health_delta

	var/necro = FALSE


/datum/extension/assault_wave/New(var/datum/holder)
	.=..()
	var/mob/living/L = holder

	var/newval = L.move_speed_factor * speed_factor
	speed_delta = L.move_speed_factor - newval
	L.move_speed_factor = newval

	newval = L.attack_speed_factor * attackspeed_factor
	attackspeed_delta = L.attack_speed_factor - newval
	L.attack_speed_factor = newval

	newval = L.max_health * health_factor
	health_delta = L.max_health - newval
	L.max_health = newval

	L.evasion += evasion_bonus


	addtimer(CALLBACK

/datum/extension/assault_wave/stop()
	remove_extension(holder, src)

/datum/extension/assault_wave/Destroy()
	var/mob/living/L = holder
	if (istype(L))
		L.move_speed_factor += speed_delta	//Restore the movespeed to normal
		L.attack_speed_factor += attackspeed_delta
		L.max_health += health_delta
		L.evasion -= evasion_bonus
		L.updatehealth()

	.=..()