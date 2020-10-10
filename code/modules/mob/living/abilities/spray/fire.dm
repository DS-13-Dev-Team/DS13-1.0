/*-----------------------
	Fire Subtype

	Sprays a cone of flame, burning and igniting things it touches
-----------------------*/
/datum/extension/spray/fire
	var/temperature = T0C + 2600
	fx_type = /obj/effect/particle_system/spray/fire

/datum/extension/spray/fire/handle_extra_data(var/list/data)
	.=..()
	src.temperature = extra_data["temperature"]

/datum/extension/spray/fire/stop()
	.=..()
	QDEL_NULL(chem_holder)
	QDEL_NULL(chem_atom)


/datum/extension/spray/fire/Process()
	for (var/t in affected_turfs)
		var/turf/T = t

		for (var/atom/A in T)
			A.fire_act(null, temperature, null, 0.2)

		T.fire_act(null, temperature, null, 0.2)
	.=..()


/datum/extension/spray/fire/start()
	if (!started_at)
		chem_atom = new(source)
		chem_holder = new (2**24, chem_atom)
		var/datum/reagent/R = chem_holder.add_reagent(reagent_type, chem_holder.maximum_volume, safety = TRUE)
		particle_color = R.color
		.=..()



/***********************
	Spray visual effect
************************/
/*
	Particle System
	Sprays particles in a cone
*/
/obj/effect/particle_system/spray/fire
	particle_type = /obj/effect/particle/flame
	autostart = FALSE
	tick_delay = 0.15 SECONDS
	particles_per_tick = 2
	randpixel = 12




/obj/effect/particle/flame
	name = "spray"
	icon = 'icons/effects/effects64.dmi'
	icon_state = "flame_1"
	random_icons = list("flame_1", "flame_2", "flame_3")
	var/scale_x_start = 	0
	var/scale_y_start = 	0
	var/alpha_start	=	255

	var/scale_x_end = 	1
	var/scale_y_end = 	1
	var/alpha_end	=	255
	color = "#FFFFFF"
