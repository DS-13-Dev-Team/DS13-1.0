/obj/structure/reagent_dispensers/biomass
	name = "biomass storage"
	desc = "It is every citizen's final duty to go into the tanks, and to become one with all the people."
	icon = 'icons/obj/machines/ds13/bpl.dmi'
	icon_state = "tank"
	initial_capacity = 10000	//Approximately 100 litres capacity, based on 1u = 10ml = 0.01 litre
	initial_reagent_types = list(/datum/reagent/nutriment/biomass = 0.01)

	density = TRUE
	anchored = TRUE