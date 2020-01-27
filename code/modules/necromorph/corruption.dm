/*
	Corruption is an extension of the bay spreading plants system.

	Corrupted tiles spread out gradually from the marker, and from any placed nodes, up to a certain radius
*/


//We'll be using a subtype in addition to a seed, becuase there's a lot of special case behaviour here
/obj/effect/vine/corruption
	name = "corruption"
	icon = 'icons/effects/corruption.dmi'
	icon_state = ""

	max_health = 80
	max_growth = 1

	var/max_alpha = 225
	var/min_alpha = 20

	spread_chance = 100	//No randomness in this, spread as soon as its ready
	spread_distance = 7	//One node creates a screen-sized patch of corruption
	growth_type = 0
	var/vine_scale = 1.1


/obj/effect/vine/corruption/New(var/newloc, var/datum/seed/newseed, var/obj/effect/vine/newparent, var/start_matured = 0)
	alpha = min_alpha
	GLOB.necrovision.add_source(src)	//Corruption tiles add vision
	if (!newseed)
		seed = new /datum/seed/corruption()
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
	mature_time = rand_between(15 SECONDS, 30 SECONDS)	//How long it takes for one tile to mature and be ready to spread into its neighbors.
	if (parent != src)
		mature_time *= 1 + (0.2 * get_dist(src, parent))//Expansion gets slower as you get farther out. Additively stacking 20% increase per tile
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


/* The seed */
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