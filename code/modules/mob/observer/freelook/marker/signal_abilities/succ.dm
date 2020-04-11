/datum/signal_ability/succ
	name = "Absorb	"
	id = "succ"
	desc = "Absorbs a piece of biological matter, claiming some biomass for the marker. The item to be absorbed must be located within corruption"
	target_string = "A severed organ, an organic stain, or a piece of food"
	energy_cost = 30
	cooldown = 20 SECONDS
	require_corruption = TRUE
	autotarget_range = 2

	target_types = list(/obj/item/organ, /obj/effect/decal/cleanable/blood,	/obj/item/weapon/reagent_containers/food/snacks)

	targeting_method	=	TARGET_CLICK

/datum/signal_ability/succ/special_check(var/atom/target)
	//Without this, it somehow eats organs from inside intact creatures, not good
	if (!isturf(target.loc))
		return FALSE
	return TRUE

/datum/signal_ability/succ/on_cast(var/mob/user, var/atom/target, var/list/data)
	var/biomass_gain = target.get_biomass()
	if (isnum(biomass_gain) && biomass_gain > 0)
		var/obj/machinery/marker/M	= get_marker()
		if (M)
			M.biomass += biomass_gain
			to_chat(user, SPAN_NOTICE("Gained [biomass_gain]kg biomass from absorbing [target]!"))
	else
		to_chat(user, SPAN_WARNING("[target] was worth no biomass, energy cost refunded"))
		refund(user)

	qdel(target)

