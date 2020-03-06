/*
	Corruption is an extension of the bay spreading plants system.

	Corrupted tiles spread out gradually from the marker, and from any placed nodes, up to a certain radius
*/

GLOBAL_DATUM_INIT(corruption_seed, /datum/seed/corruption, new())

//We'll be using a subtype in addition to a seed, becuase there's a lot of special case behaviour here
/obj/effect/vine/corruption
	name = "corruption"
	icon = 'icons/effects/corruption.dmi'
	icon_state = ""

	max_health = 80
	max_growth = 1

	var/max_alpha = 215
	var/min_alpha = 20

	spread_chance = 100	//No randomness in this, spread as soon as its ready
	spread_distance = CORRUPTION_SPREAD_RANGE	//One node creates a screen-sized patch of corruption
	growth_type = 0
	var/vine_scale = 1.1


/obj/effect/vine/corruption/New(var/newloc, var/datum/seed/newseed, var/obj/effect/vine/newparent, var/start_matured = 0)
	alpha = min_alpha
	GLOB.necrovision.add_source(src)	//Corruption tiles add vision
	if (!GLOB.corruption_seed)
		GLOB.corruption_seed = new /datum/seed/corruption()
	seed = GLOB.corruption_seed
	.=..()

//Corruption tiles reveal their own tile, and surrounding dense obstacles. They will not reveal surrounding clear tiles
/obj/effect/vine/corruption/get_visualnet_tiles(var/datum/visualnet/network)
	var/list/visible_tiles = list(get_turf(src))
	for (var/turf/T in orange(1, src))
		if (!turf_clear(T))
			visible_tiles.Add(T)

	return visible_tiles


//No calculating, we'll input all these values in the variables above
/obj/effect/vine/corruption/calculate_growth()
	mature_time = rand_between(20 SECONDS, 30 SECONDS) //How long it takes for one tile to mature and be ready to spread into its neighbors.
	if (plant)
		mature_time *= 1 + (0.15 * get_dist(src, plant))//Expansion gets slower as you get farther out. Additively stacking 15% increase per tile
	growth_threshold = max_health
	var/sidelength = (spread_distance * 2)+1
	possible_children = (sidelength * sidelength)
	return

/obj/effect/vine/corruption/update_icon()
	icon_state = "corruption-[rand(1,3)]"


	var/matrix/M = matrix()
	M = M.Scale(vine_scale)	//We scale up the sprite so it slightly overlaps neighboring corruption tiles
	var/rotation = pick(list(0,90,180,270))	//Randomly rotate it
	transform = turn(M, rotation)

	//Lets add the edge sprites
	overlays.Cut()
	for(var/turf/simulated/floor/floor in get_neighbors(FALSE, FALSE))
		var/direction = get_dir(src, floor)
		var/vector2/offset = Vector2.FromDir(direction)
		offset *= (WORLD_ICON_SIZE * vine_scale)
		var/image/I = image(icon, src, "corruption-edge", layer+1, direction)
		I.pixel_x = offset.x
		I.pixel_y = offset.y
		I.appearance_flags = RESET_TRANSFORM	//We use reset transform to not carry over the rotation

		I.transform = I.transform.Scale(vine_scale)	//We must reapply the scale
		overlays.Add(I)


//Corruption gradually fades in/out as its health goes up/down
/obj/effect/vine/corruption/adjust_health(value)
	.=..()
	if (health > 0)
		var/healthpercent = health / max_health
		alpha = min_alpha + ((max_alpha - min_alpha) * healthpercent)


//Add the effect from being on corruption
/obj/effect/vine/corruption/Crossed(atom/movable/O)
	if (isliving(O))
		var/mob/living/L = O
		if (!has_extension(L, /datum/extension/corruption_effect) && L.stat != DEAD)
			set_extension(L, /datum/extension/corruption_effect)


//This proc finds something nearby to use as an origin point for this corruption tile.
//If none is found, we are orphaned and will start gradually dying
/obj/effect/vine/corruption/proc/find_corruption_host()
	var/min_dist = INFINITY
	var/closest = null
	for (var/a in range(spread_distance, src))
		if (istype(a, /obj/structure/corruption_node/growth) || istype(a, /obj/machinery/marker))
			var/distance = get_dist(src, a)
			if (distance < min_dist)
				min_dist = distance
				closest = a

	return closest



//Gradually dies off without a nearby host
/obj/effect/vine/corruption/Process()
	.=..()
	if (!plant)
		adjust_health(-(SSplants.wait*0.1))	//Plant subsystem has a 6 second delay oddly, so compensate for it here


/obj/effect/vine/corruption/can_regen()
	.=..()
	if (.)
		if (!plant)
			return FALSE

//In addition to normal checks, we need a place to put our plant
/obj/effect/vine/corruption/can_spawn_plant()
	if (!plant)
		if (find_corruption_host())
			return TRUE
	return FALSE

//We can only place plants under a marker or growth node
//And before placing, we should look for an existing one
/obj/effect/vine/corruption/spawn_plant()
	var/atom/A = find_corruption_host()
	if (!A)
		return
	var/turf/T = get_turf(A)
	for (var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/I in T)
		if (istype(I.seed, /datum/seed/corruption))
			plant = I
			calculate_growth()
			return


	//If there's no existing one, we'll create it on the host tile
	..(T)
	//And lets set the appropriate var on the corruption host, ensuring it will be deleted if host is destroyed
	A:corruption_plant = plant
	calculate_growth()


/obj/effect/vine/corruption/is_necromorph()
	return TRUE

/* The seed */
//-------------------
/datum/seed/corruption
	display_name = "Corruption"
	no_icon = TRUE
	growth_stages = 1


/datum/seed/corruption/New()
	set_trait(TRAIT_IMMUTABLE,            1)            // If set, plant will never mutate. If -1, plant is highly mutable.
	set_trait(TRAIT_SPREAD,               2)            // 0 limits plant to tray, 1 = creepers, 2 = vines.
	set_trait(TRAIT_MATURATION,           0)            // Time taken before the plant is mature.
	set_trait(TRAIT_PRODUCT_ICON,         0)            // Icon to use for fruit coming from this plant.
	set_trait(TRAIT_PLANT_ICON,           'icons/effects/corruption.dmi')            // Icon to use for the plant growing in the tray.
	set_trait(TRAIT_PRODUCT_COLOUR,       0)            // Colour to apply to product icon.
	set_trait(TRAIT_POTENCY,              1)            // General purpose plant strength value.
	set_trait(TRAIT_REQUIRES_NUTRIENTS,   0)            // The plant can starve.
	set_trait(TRAIT_REQUIRES_WATER,       0)            // The plant can become dehydrated.
	set_trait(TRAIT_WATER_CONSUMPTION,    0)            // Plant drinks this much per tick.
	set_trait(TRAIT_LIGHT_TOLERANCE,      INFINITY)            // Departure from ideal that is survivable.
	set_trait(TRAIT_TOXINS_TOLERANCE,     INFINITY)            // Resistance to poison.
	set_trait(TRAIT_HEAT_TOLERANCE,       20)           // Departure from ideal that is survivable.
	set_trait(TRAIT_LOWKPA_TOLERANCE,     0)           // Low pressure capacity.
	set_trait(TRAIT_ENDURANCE,            100)          // Maximum plant HP when growing.
	set_trait(TRAIT_HIGHKPA_TOLERANCE,    INFINITY)          // High pressure capacity.
	set_trait(TRAIT_IDEAL_HEAT,           293)          // Preferred temperature in Kelvin.
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0)         // Plant eats this much per tick.
	set_trait(TRAIT_PLANT_COLOUR,         "#ffffff")    // Colour of the plant icon.


/datum/seed/corruption/update_growth_stages()
	growth_stages = 1




/* Crossing Effect */
//-------------------
//Any mob that walks over a corrupted tile recieves this effect. It does varying things
	//On most mobs, it applies a slow to movespeed
	//On necromorphs, it applies a passive healing instead

/datum/extension/corruption_effect
	name = "Corruption Effect"
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	//Effects on necromorphs
	var/healing_per_tick = 1
	var/speedup = 1.15

	//Effects on non necros
	var/slowdown = 0.7	//Multiply speed by this


	var/speed_delta	//What absolute value we removed from the movespeed factor. This is cached so we can reverse it later

	var/necro = FALSE


/datum/extension/corruption_effect/New(var/datum/holder)
	.=..()
	var/mob/living/L = holder
	var/speed_factor = 0
	if (L.is_necromorph())
		necro = TRUE
		speed_factor = speedup //Necros are sped up
		to_chat(L, SPAN_DANGER("The corruption beneath speeds your passage and mends your vessel."))
	else
		to_chat(L, SPAN_DANGER("This growth underfoot is sticky and slows you down."))
		speed_factor = slowdown	//humans are slowed down

	var/newspeed = L.move_speed_factor * speed_factor
	speed_delta = L.move_speed_factor - newspeed
	L.move_speed_factor = newspeed

	START_PROCESSING(SSprocessing, src)


/datum/extension/corruption_effect/Process()
	var/mob/living/L = holder
	if (!L || !turf_corrupted(L) || L.stat == DEAD)
		//If the mob is no longer standing on a corrupted tile, we stop
		//Likewise if they're dead or gone
		remove_extension(holder, type)
		return PROCESS_KILL

	if (necro)
		L.heal_overall_damage(healing_per_tick)


/datum/extension/corruption_effect/Destroy()
	var/mob/living/L = holder
	if (istype(L))
		L.move_speed_factor += speed_delta	//Restore the movespeed to normal

	.=..()