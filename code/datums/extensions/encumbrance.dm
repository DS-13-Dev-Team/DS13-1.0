#define ENCUMBRANCE_TO_MOVESPEED	0.1	//10% slowdown per point
#define ENCUMBRANCE_TO_ATTACKSPEED	0.05	//5% slowdown per point
#define ENCUMBRANCE_REDUCTION_FACTOR	0.3	//Each point of hauling skill reduces encumbrance by this much

/datum/extension/encumbrance
	flags = EXTENSION_FLAG_IMMEDIATE
	expected_type = /mob/living

	var/encumbrance = 0
	var/speed_factor	=	0

	var/update_timer

	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 1,
	STATMOD_ATTACK_SPEED = 0,
	STATMOD_EVASION = 0)

/datum/extension/encumbrance/proc/update()
	var/mob/living/L = holder
	var/encumbrance_before = encumbrance
	encumbrance = 0
	deltimer(update_timer)
	update_timer = null
	for(var/slot = slot_first to slot_last)
		var/obj/item/I = L.get_equipped_item(slot)
		if(I)
			var/item_slowdown = 0
			item_slowdown += I.slowdown_general
			item_slowdown += I.slowdown_per_slot[slot]
			item_slowdown += I.slowdown_accessory

			encumbrance += max(item_slowdown, 0)



	//If we have no encumbrance we don't need this
	if (encumbrance <= 0)
		remove_self()
		return

	//Being in 0G makes everything weightless, although mass is still a thing. Movement is still easier
	if (!L.has_gravity())
		encumbrance *= 0.66

	encumbrance = max(0, encumbrance - ((L.get_skill_value(SKILL_HAULING)-1) * ENCUMBRANCE_REDUCTION_FACTOR))
	if (encumbrance == encumbrance_before)
		//If its unchanged, do nothing
		return


	statmods[STATMOD_MOVESPEED_MULTIPLICATIVE] = (1 / (1 + (encumbrance * ENCUMBRANCE_TO_MOVESPEED)))
	statmods[STATMOD_ATTACK_SPEED] = (1 - (1 / (1 + (encumbrance * ENCUMBRANCE_TO_ATTACKSPEED)))) *-1
	statmods[STATMOD_EVASION] = -encumbrance
	update_statmods()




/datum/extension/encumbrance/proc/schedule_update()
	if (update_timer)
		return

	update_timer = addtimer(CALLBACK(src,/datum/extension/encumbrance/proc/update),1,TIMER_STOPPABLE)

/datum/proc/update_encumbrance(var/instant = FALSE)
	var/datum/extension/encumbrance/E = get_or_create_extension(src, /datum/extension/encumbrance)
	if (instant)
		E.update()
	else
		E.schedule_update()