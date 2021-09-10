/var/const/meteor_wave_delay = 1 MINUTE //minimum wait between waves in tenths of seconds
//set to at least 100 unless you want evarr ruining every round

//Meteor groups, used for various random events and the Meteor gamemode.

// Dust, used by space dust event and during earliest stages of meteor mode.
/var/list/meteors_dust = list(/obj/effect/meteor/dust)



GLOBAL_LIST_EMPTY(asteroids)


///////////////////////
//The meteor effect
//////////////////////
/obj/effect/meteor
	name = "the concept of meteor"
	desc = "You should probably run instead of gawking at this."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small"
	density = 1
	anchored = 1
	var/hits = 4
	var/hitpwr = 2 //Level of ex_act to be called on hit.
	var/dest
	pass_flags = PASS_FLAG_TABLE
	var/heavy = 0
	var/z_original
	var/z_target
	var/meteordrop = /obj/item/weapon/ore/iron
	var/dropamt = 1
	var/vector2/velocity = null

	var/move_count = 0
	var/speed = 1.5
	var/registered = FALSE
	var/start_side = EAST //Where did we come from?
	default_scale = 3.5

	var/min_scale = 3
	var/max_scale = 6

	//Meteors are big objects
	bound_width = WORLD_ICON_SIZE*2
	bound_height = WORLD_ICON_SIZE*2
	pixel_x = 16
	pixel_y = 16

/obj/effect/meteor/proc/get_shield_damage()
	return max(((max(hits, 2)) * (heavy + 1) * rand(30, 60)) / hitpwr , 0)

/obj/effect/meteor/New()
	..()
	z_original = z
	z_target = pick(GLOB.using_map.station_levels)	//The meteor targets a random height
	if (isturf(loc))
		register_asteroid(src)

	default_scale = rand_between(min_scale, max_scale)
	animate_to_default()
	SpinAnimation(0.5 / (default_scale * rand_between(0.5, 1.5)))
	speed = rand_between(speed * 0.75, speed * 1.25)


/proc/register_asteroid(var/obj/effect/meteor/M)
	GLOB.asteroids += M
	if (GLOB.asteroidcannon)
		START_PROCESSING(SSfastprocess, GLOB.asteroidcannon.fire_handler)

/obj/effect/meteor/Destroy()
	GLOB.asteroids -= src
	velocity = null
	walk(src,0) //this cancels the walk_towards() proc
	. = ..()

/obj/effect/meteor/Move(turf/NewLoc, NewDir=0)
	move_count++

	//Turns out that NewLoc is actually our current location so we need to get the next step
	var/turf/next_loc = get_step(loc, NewDir)

	//When a meteor is about to move into a turf, we check if that turf is any kind of not-empty-space thing
	//That includes empty space with potential non empty space below
	var/impacting = FALSE
	if (istype(next_loc))
		if (istype(next_loc, /turf/space))
			var/turf/space/S = next_loc

			//Easy optimisation to see if this is empty space
			if (S.solid_below)
				//Lets see if there's anything to hit at our target zlevel
				var/turf/target = locate(next_loc.x, next_loc.y, z_target)
				if (!target?.is_hole)
					impacting = TRUE

				//If not we'll keep going as normal

		//We're about to enter a non space tile. Again lets check our destination
		else if (!(next_loc.is_hole))
			var/turf/target = locate(next_loc.x, next_loc.y, z_target)
			if (src.z == z_target || (target && !target.is_hole))
				impacting = TRUE	//If our target is solid we hit it
			else
				//Okay we have a problem, our target level has empty space but the zlevel we're on does not.
				//At this point we have officially moved under the ship, and out of line of sight of the deck we were on. This asteroid is no longer shootable

				loc = locate(x, y, z_target)	//We snap down to the deck we targeted and continue moving from there

				NewLoc = loc

				set_destination(dest, TRUE)	//Reset the destination, this will target a turf on our new z

	if (impacting)
		//Its solid enough to hit, lets do it!
		//We'll detonate next to it, not inside it
		detonate_at_turf(locate(x, y, z_target))
		return


	else
		//We're just moving into empty space
		.=..()

	if(loc == dest)
		qdel(src)



/obj/effect/meteor/touch_map_edge()
	if(move_count > TRANSITIONEDGE)
		qdel(src)




/obj/effect/meteor/Bump(atom/A)
	..()
	if(A && !QDELETED(src))	// Prevents explosions and other effects when we were deleted by whatever we Bumped() - currently used by shields.
		if (istype(A, /obj/effect/meteor))
			//We bounce off other meteors
			ricochet()
			return
		else
			ram_turf(get_turf(A))
			get_hit() //should only get hit once per move attempt


//We fly in a different direction
/obj/effect/meteor/proc/ricochet()
	walk(src, 0)

	set_destination(spaceDebrisFinishLoc(start_side, z))


/obj/effect/meteor/proc/set_destination(var/turf/T, var/z_adjust = TRUE)
	if (z_adjust && T.z != z)
		//Get the appropriate turf on our own zlevel
		T = locate(T.x, T.y, z)
	dest = T
	spawn(0)
		walk_towards(src, T, SPEED_TO_DELAY(speed))

/obj/effect/meteor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return istype(mover, /obj/effect/meteor) ? 1 : ..()

/obj/effect/meteor/proc/ram_turf(var/turf/T)
	//first bust whatever is in the turf
	for(var/atom/A in T)
		if(A != src && !A.CanPass(src, src.loc, 0.5, 0)) //only ram stuff that would actually block us
			A.ex_act(hitpwr, src)

	//then, ram the turf if it still exists
	if(T && !T.CanPass(src, src.loc, 0.5, 0))
		T.ex_act(hitpwr, src)

/obj/effect/meteor/proc/detonate_at_turf(var/turf/T)
	ram_turf(T)
	forceMove(T)
	hits = 0
	get_hit()

//process getting 'hit' by colliding with a dense object
//or randomly when ramming turfs
/obj/effect/meteor/proc/get_hit()
	hits--
	if(hits <= 0)
		make_debris()
		meteor_effect()
		qdel(src)

/obj/effect/meteor/ex_act()
	return


/*
	Called when a meteor is harmlessly destroyed by cannon fire
*/
/obj/effect/meteor/proc/break_apart()
	explosion_fx(src)
	//make_debris()	//No debris to prevent spam, because things will be miles away when shot down and we dont want ore floating in space forever, ignored
	if (!QDELETED(src))
		qdel(src)

/obj/effect/meteor/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/tool/pickaxe))
		qdel(src)
		return
	..()

/obj/effect/meteor/proc/make_debris()
	for(var/throws = dropamt, throws > 0, throws--)
		var/obj/item/O = new meteordrop(get_turf(src))
		O.throw_at(dest, 5, 10)

/obj/effect/meteor/proc/meteor_effect()
	if(heavy)
		for(var/mob/M in GLOB.player_list)
			var/turf/T = get_turf(M)
			if(!T || T.z != src.z)
				continue
			var/dist = get_dist(M.loc, src.loc)
			shake_camera(M, dist > 20 ? 3 : 5, dist > 20 ? 1 : 3)


///////////////////////
//Meteor types
///////////////////////

//Dust
/obj/effect/meteor/dust
	name = "space dust"
	icon_state = "dust"
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE
	hits = 1
	hitpwr = 3
	dropamt = 1
	meteordrop = /obj/item/weapon/ore/glass

//Medium-sized
/obj/effect/meteor/medium
	name = "meteor"
	dropamt = 2

/obj/effect/meteor/medium/meteor_effect()
	..()
	explosion(3, 2)

//Large-sized
/obj/effect/meteor/big
	name = "large meteor"
	icon_state = "large"
	hits = 6
	heavy = 1
	dropamt = 3

/obj/effect/meteor/big/meteor_effect()
	..()
	explosion(5, 2)

//Flaming meteor
/obj/effect/meteor/flaming
	name = "flaming meteor"
	icon_state = "flaming"
	hits = 5
	heavy = 1
	meteordrop = /obj/item/weapon/ore/phoron

/obj/effect/meteor/flaming/meteor_effect()
	explosion(2, 2)
	..()


//Radiation meteor
/obj/effect/meteor/irradiated
	name = "glowing meteor"
	icon_state = "glowing"
	heavy = 1
	meteordrop = /obj/item/weapon/ore/uranium

/obj/effect/meteor/irradiated/meteor_effect()
	explosion(2, 2)
	..()

	new /obj/effect/decal/cleanable/greenglow(get_turf(src))
	SSradiation.radiate(src, 50)

/obj/effect/meteor/golden
	name = "golden meteor"
	icon_state = "glowing"
	desc = "Shiny! But also deadly."
	meteordrop = /obj/item/weapon/ore/gold

/obj/effect/meteor/silver
	name = "silver meteor"
	icon_state = "glowing_blue"
	desc = "Shiny! But also deadly."
	meteordrop = /obj/item/weapon/ore/silver

/obj/effect/meteor/emp
	name = "conducting meteor"
	icon_state = "glowing_blue"
	desc = "Hide your floppies!"
	meteordrop = /obj/item/weapon/ore/osmium
	dropamt = 2

/obj/effect/meteor/emp/meteor_effect()
	..()
	// Best case scenario: Comparable to a low-yield EMP grenade.
	// Worst case scenario: Comparable to a standard yield EMP grenade.
	empulse(src, rand(2, 4), rand(4, 10))

/obj/effect/meteor/emp/get_shield_damage()
	return ..() * rand(2,4)

//Station buster Tunguska
/obj/effect/meteor/tunguska
	name = "tunguska meteor"
	icon_state = "flaming"
	desc = "Your life briefly passes before your eyes the moment you lay them on this monstrosity."
	hits = 10
	hitpwr = 1
	heavy = 1
	meteordrop = /obj/item/weapon/ore/diamond	// Probably means why it penetrates the hull so easily before exploding.

/obj/effect/meteor/tunguska/meteor_effect()
	explosion(8,3)
	..()


// This is the final solution against shields - a single impact can bring down most shield generators.
/obj/effect/meteor/supermatter
	name = "supermatter shard"
	desc = "Oh god, what will be next..?"
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter"

/obj/effect/meteor/supermatter/meteor_effect()
	..()
	explosion(3, 2)
	for(var/obj/machinery/power/apc/A in range(rand(12, 20), src))
		A.energy_fail(round(10 * rand(8, 12)))

/obj/effect/meteor/supermatter/get_shield_damage()
	return ..() * rand(80, 120)