/*
	Industrial nets have various detrimental effects on human-sized mobs
*/
/datum/extension/updating/net_entanglement
	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 0.6,
	STATMOD_EVASION = -10,
    STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = 1.15)

	/*
		Maximum penalty when all locomotion limbs are completely gone
		50% speed penalty may not seem like enough for missing both legs, but you'll be crawling, in pain, and in shock
		as well, and those add their own penalties
	*/
	var/total_max_slowdown = 0.5
	var/impairment	=	0

/datum/extension/updating/net_entanglement/Initialize()
    .=..()
    GLOB.moved_event.register(holder, src, /datum/extension/updating/net_entanglement)

/datum/extension/updating/net_entanglement/update()
	var/mob/living/H = holder
	if (!istype(H))
        remove_self()
        return

    if (!H.triggers_floor_traps())
        remove_self()
        return

    //Nets only affect human sized mobs
    //Anything larger tramples them unimpeded
    //Smaller things slither under or through gaps
    if (H.mob_size != MOB_MEDIUM)
        remove_self()
        return

	//If they've stepped off a net the effect ends instantly
	if (!(locate(/obj/structure/net) in get_turf(H)))
		remove_self()
        return


//A helper
/datum/proc/triggers_floor_traps()
    return FALSE

/mob/living/triggers_floor_traps()
     //Mobs that are flying are unaffected
    if (pass_flags & PASS_FLAG_FLYING|PASS_FLAG_TABLE)
        return

    //Things that don't exist won't trigger it
    if (atom_flags & ATOM_FLAG_INTANGIBLE)
        retirm

    //Crawling along walls will avoid floor traps
    if (is_mounted())
        return

    return TRUE