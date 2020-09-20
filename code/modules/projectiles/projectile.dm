//Amount of time in deciseconds to wait before deleting all drawn segments of a projectile.
#define SEGMENT_DELETION_DELAY 5

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = 1
	can_block_movement = FALSE	//Projectiles don't recieve collisions usually, they move into other things
	unacidable = 1
	anchored = 1 //There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	pass_flags = PASS_FLAG_TABLE
	mouse_opacity = 0
	var/bumped = 0		//Prevents it from hitting more than one guy at once
	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/silenced = 0	//Attack message
	var/yo = null
	var/xo = null
	var/current = null
	var/shot_from = "" // name of the object which shot us
	var/atom/original = null // the target clicked (not necessarily where the projectile is headed). Should probably be renamed to 'target' or something.
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again
	var/list/segments = list() //For hitscan projectiles with tracers.

	var/atom/last_loc	//Last place we were. used for direction handling. This is set on Move, and any time our loc is set directly
	var/last_result = null	//A bit of a hack. Anything can set this on a projectile and it'll be checked at various stages while hitting a mob

	//var/p_x = 16
	//var/p_y = 16 // the pixel location of the tile that the player clicked. Default is the center
	var/vector2/pixel_click = new /vector2(16, 16)

	var/altitude = 1	//How high off the ground is this projectile?
	var/height = 0.02	//How tall is this projectile? Default 2cm, which seems about right for a bullet

	randpixel = 4	//Offset randomly on spawn by up to this much

	var/accuracy = 100	//Base chance to hit, before various modifiers are applied. This can be above 100
	var/distance_accuracy_falloff	=	1.75	//Amount subtracted from accuracy for each tile travelled
	var/dispersion = 0.0

	//When this projectile hits a dense object, chance to ricochet off it
	var/ricochet_chance	=	0

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE, PAIN are the only things that should be in here
	structure_damage_factor = 1
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/check_armour = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	var/projectile_type = /obj/item/projectile
	var/penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
	var/kill_count = 50 //This will de-increment every process(). When 0, it will delete the projectile.
		//Effects
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/embed = 0 // whether or not the projectile can embed itself in the mob
	var/penetration_modifier = 0.2 //How much internal damage this projectile can deal, as a multiplier.


	var/hitscan = 0		// whether the projectile should be hitscan
	var/step_delay = 1	// the delay between iterations if not a hitscan projectile

	// effect types to be used
	var/muzzle_type
	var/tracer_type
	var/impact_type

	//	Bullet Expiry
	var/expiry_method = EXPIRY_DELETE
	var/expiry_time = 0.2 SECONDS
	var/expired	=	FALSE	//If true, this bullet is being deleted. make it stop moving

	var/fire_sound
	var/miss_sounds

	var/vacuum_traversal = 1 //Determines if the projectile can exist in vacuum, if false, the projectile will be deleted if it enters vacuum.

	var/datum/plot_vector/trajectory	// used to plot the path of the projectile
	var/datum/vector_loc/location		// current location of the projectile in pixel space
	var/matrix/effect_transform			// matrix to rotate and scale projectile effects - putting it here so it doesn't
										//  have to be recreated multiple times


	var/flying = TRUE	//Set this false to make the projectile stop in midair
	var/grippable = FALSE	//This should be set true on any large, physical projectiles. Rockets, bombs, grenades, cannonballs, etc
	//It should be false for small things like normal bullets, spines
	//It should be false for non physical things, energy, lasers, etc

	var/shrapnel_type = /obj/item/weapon/material/shard/shrapnel	//When this projectile embeds in a mob, what kind of shrapnel does it turn into?	The actual projectile will be deleted


/obj/item/projectile/New(var/atom/location)
	//To prevent visual glitches, projectiles start off invisible
	default_alpha = alpha
	alpha = 0
	.=..()

/obj/item/projectile/Destroy()
	release_vector(pixel_click)
	.=..()

/obj/item/projectile/Initialize()
	damtype = damage_type //TODO unify these vars properly
	if(!hitscan)
		animate_movement = SLIDE_STEPS

	else
		animate_movement = NO_STEPS
	set_pixel_offset()
	. = ..()

/obj/item/projectile/proc/set_pixel_offset()
	var/vector2/newpixels = get_new_vector(0,0)
	//Future todo: Get toplevel atom of firer
	if (firer && isturf(firer.loc))
		newpixels.x = firer.pixel_x
		newpixels.y = firer.pixel_y

	if(randpixel) //hopefully this will prevent us from messing with mapper-set pixel_x/y
		newpixels.x += rand(-randpixel, randpixel)
		newpixels.y += rand(-randpixel, randpixel)

	pixel_x = newpixels.x
	pixel_y = newpixels.y
	release_vector(newpixels)

//Called when this projectile is to be deleted during normal gameplay, ie when it hits stuff
/obj/item/projectile/proc/expire()
	flying = FALSE
	set_density(0)
	expired = TRUE
	switch(expiry_method)
		if (EXPIRY_DELETE)
			set_invisibility(101)
			qdel(src)
			return
		if (EXPIRY_FADEOUT)
			animate(src, alpha = 0, time = expiry_time)
			QDEL_IN(src, expiry_time)



/obj/item/projectile/Move(NewLoc,Dir=0)
	last_loc = loc
	return ..()

/obj/item/projectile/forceMove()
	..()
	if(!vacuum_traversal && istype(loc, /turf/space/) && istype(loc.loc, /area/space))
		qdel(src)

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/item/projectile/proc/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked >= 100)		return 0//Full block
	if(!isliving(target))	return 0
	if(isanimal(target))	return 0

	var/mob/living/L = target

	L.apply_effects(0, weaken, paralyze, 0, stutter, eyeblur, drowsy, 0, blocked)
	L.stun_effect_act(stun, agony, def_zone, src)
	//radiation protection is handled separately from other armour types.
	L.apply_effect(irradiate, IRRADIATE, L.getarmor(null, "rad"))


	return 1

//called when the projectile stops flying because it collided with something
/obj/item/projectile/proc/on_impact(var/atom/A)
	if (effect_transform)	//May be null when shooting something in the same tile
		impact_effect(effect_transform)		// generate impact effect
	if(damage && damage_type == BURN)
		var/turf/T = get_turf(A)
		if(T)
			T.hotspot_expose(700, 5)

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(!embed || damage_type != BRUTE || (item_flags & ITEM_FLAG_NO_EMBED))
		return 0
	return 1

/obj/item/projectile/proc/get_structure_damage()
	if(damage_type == BRUTE || damage_type == BURN)
		return damage * structure_damage_factor
	return 0

//return 1 if the projectile should be allowed to pass through after all, 0 if not.
/obj/item/projectile/proc/check_penetrate(var/atom/A)
	return 1

/obj/item/projectile/proc/check_fire(atom/target as mob, var/mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, item_flags, obj_flags)

//sets the click point of the projectile using mouse input params
/obj/item/projectile/proc/set_clickpoint(var/params)
	var/list/mouse_control = params2list(params)
	if(mouse_control["icon-x"])
		pixel_click.x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		pixel_click.y = text2num(mouse_control["icon-y"])

	//randomize clickpoint a bit based on dispersion
	if(dispersion)
		var/radius = round((dispersion*0.443)*world.icon_size*0.8) //0.443 = sqrt(pi)/4 = 2a, where a is the side length of a square that shares the same area as a circle with diameter = dispersion
		pixel_click.x = between(0, pixel_click.x + rand(-radius, radius), world.icon_size)
		pixel_click.y = between(0, pixel_click.y + rand(-radius, radius), world.icon_size)



//called to launch a projectile
/obj/item/projectile/proc/launch(atom/target, var/target_zone, var/x_offset=0, var/y_offset=0, var/angle_offset=0)

	var/turf/curloc = get_turf(src)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return 1

	if(targloc == curloc) //Shooting something in the same turf
		target.bullet_act(src, target_zone)
		on_impact(target)
		qdel(src)	//Don't bother with expire here, since it never becomes visible
		return 0

	original = target
	def_zone = target_zone

	addtimer(CALLBACK(src, .proc/finalize_launch, curloc, targloc, x_offset, y_offset, angle_offset),0)
	return 0

/obj/item/projectile/proc/finalize_launch(var/turf/curloc, var/turf/targloc, var/x_offset, var/y_offset, var/angle_offset)

	setup_trajectory(curloc, targloc, x_offset, y_offset, angle_offset) //plot the initial trajectory
	alpha = default_alpha	//The projectile becomes visible now, when its ready to start moving
	Process()
	spawn(SEGMENT_DELETION_DELAY) //running this from a proc wasn't working.
		QDEL_NULL_LIST(segments)

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch_from_gun(atom/target, mob/user, obj/item/weapon/gun/launcher, var/target_zone, var/x_offset=0, var/y_offset=0)
	if(user == target) //Shooting yourself
		user.bullet_act(src, target_zone)
		qdel(src)	//Never visible, no expire
		return 0

	last_loc = loc
	loc = get_turf(user) //move the projectile out into the world
	altitude = get_aiming_height(user, target) //Set the height of the bullet

	firer = user
	shot_from = launcher.name

	silenced = launcher.silenced

	return launch(target, target_zone, x_offset, y_offset)

//Used to change the direction of the projectile in flight.
/obj/item/projectile/proc/redirect(var/new_x, var/new_y, var/atom/starting_loc, var/mob/new_firer=null)
	var/turf/new_target = locate(new_x, new_y, src.z)
	original = new_target
	if(new_firer)
		firer = src

	setup_trajectory(starting_loc, new_target)

/obj/item/projectile/proc/ricochet_from(var/atom/bounceoff, var/angle = 90)


	//Causes this projectile to bounce off of the atom in a random angle.
		//The angle is bidirectional, an input of 90 could go up to a right angle either side
	//For best results, this should be called from a tile adjacent to the target
	var/vector2/base_dir
	var/direction
	var/bounce_turf = get_turf(bounceoff)
	if (bounce_turf == get_turf(src))
		direction = get_dir(bounceoff, last_loc)
	else
		direction = get_dir(bounceoff, src)

	//We were unable to find a direction? We can't do anything then
	if (!direction)
		return

	base_dir = Vector2.NewFromDir(direction)
	base_dir.SelfTurn(rand_between(-angle, angle))

	base_dir.SelfToMagnitude(15) //Should be a long enough distance to get the angle right

	//Before we redirect, move us into the bounceoff turf
	last_loc = loc
	loc = bounce_turf

	redirect(bounceoff.x + base_dir.x, bounceoff.y + base_dir.y, bounce_turf)
	release_vector(base_dir)

#define CHECK_RESULT	if (last_result) { result = last_result; last_result = null}

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/item/projectile/proc/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	if(!istype(target_mob))
		return

	//roll to-hit
	//miss_modifier = max(15*(distance-2) - round(15*accuracy) + miss_modifier, 0)
	var/hit_chance = accuracy - miss_modifier	//The chance that this projectile will hit. Any projectile-specific modifiers should be applied here
	//Any mob-specific modifiers will be applied by that mob in the proc we're about to call
	hit_chance -= distance * distance_accuracy_falloff

	var/hit_zone = target_mob.get_zone_with_miss_chance(hit_chance, def_zone, src)

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		if(!target_mob.aura_check(AURA_TYPE_BULLET, src,def_zone))
			return 0
		result = target_mob.bullet_act(src, def_zone)

	//Incase that bullet act wanted to override something
	if (last_result)
		result = last_result
		last_result = null

	if (result == PROJECTILE_DEFLECT)
		if(!silenced)
			target_mob.visible_message("<span class='notice'>\The [src] deflects off [target_mob]!</span>")
			if(LAZYLEN(miss_sounds))
				playsound(target_mob.loc, pick(miss_sounds), 60, 1)
		return result

	if(result == PROJECTILE_FORCE_MISS)
		if(!silenced)
			target_mob.visible_message("<span class='notice'>\The [src] misses [target_mob] narrowly!</span>")
			if(LAZYLEN(miss_sounds))
				playsound(target_mob.loc, pick(miss_sounds), 60, 1)
		return 1

	//hit messages
	if(silenced)
		to_chat(target_mob, "<span class='danger'>You've been hit in the [parse_zone(def_zone)] by \the [src]!</span>")
	else
		target_mob.visible_message("<span class='danger'>\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!</span>")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob))

			var/attacker_message = "shot with \a [src.type]"
			var/victim_message = "shot with \a [src.type]"
			var/admin_message = "shot (\a [src.type])"

			admin_attack_log(firer, target_mob, attacker_message, victim_message, admin_message)
		else
			admin_victim_log(target_mob, "was shot by an <b>UNKNOWN SUBJECT (No longer exists)</b> using \a [src]")

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return 1

	return 0


/obj/item/projectile/proc/attack_atom(var/atom/A,  var/distance, var/miss_modifier=0)
	.= A.bullet_act(src, def_zone)

	//A return value of less than zero indicates the projectile missed or penetrated, we won't deflect it in that case
	if (. >= 0 && prob(ricochet_chance))
		return PROJECTILE_DEFLECT

/obj/item/projectile/Bump(atom/A as mob|obj|turf|area, forced=0)
	if(A == src)
		return 0 //no

	if(A == firer)
		last_loc = loc
		loc = A.loc
		return 0 //cannot shoot yourself

	if((bumped && !forced) || (A in permutated))
		return 0

	var/passthrough = 0 //if the projectile should continue flying
	var/distance = get_dist(starting,loc)

	bumped = 1
	if(ismob(A))
		var/mob/M = A
		if(istype(A, /mob/living))
			//if they have a neck grab on someone, that person gets hit instead
			var/obj/item/grab/G = locate() in M
			if(G && G.shield_assailant())
				visible_message("<span class='danger'>\The [M] uses [G.affecting] as a shield!</span>")
				if(Bump(G.affecting, forced=1))
					return //If Bump() returns 0 (keep going) then we continue on to attack M.

			passthrough = attack_mob(M, distance)
		else
			passthrough = 1 //so ghosts don't stop bullets
	else
		passthrough = attack_atom(A, distance)  //backwards compatibility
		if (passthrough == PROJECTILE_CONTINUE)
			if(isturf(A))
				for(var/obj/O in A)
					attack_atom(O, distance)
				for(var/mob/living/M in A)
					var/p = attack_mob(M, distance)
					if (passthrough == TRUE)
						passthrough = p	//A mob may block or deflect a projectile which was otherwise going to go through



	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && penetrating > 0)
		if(check_penetrate(A))
			passthrough = 1
		penetrating--

	if (passthrough == PROJECTILE_DEFLECT)
		bumped = 0
		permutated.Add(A)
		ricochet_from(A)
		ricochet_chance *= 0.66	//Ricochet chance is reduced with each bounce
		return	0//Return here so we dont get deleted

	//the bullet passes through a dense object!
	if(passthrough)
		//move ourselves onto A so we can continue on our way.
		if(A)
			if(istype(A, /turf))
				last_loc = loc
				loc = A
			else
				last_loc = loc
				loc = A.loc
			permutated.Add(A)

		bumped = 0 //reset bumped variable!
		return 0

	//stop flying
	on_impact(A)


	if (!expired)
		expire()
	return 1

/obj/item/projectile/ex_act()
	return //explosions probably shouldn't delete projectiles

/obj/item/projectile/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	return 1

/obj/item/projectile/Process()
	var/first_step = 1

	spawn while(src && src.loc && flying)
		if(kill_count-- < 1)
			on_impact(src.loc) //for any final impact behaviours
			if (!expired)
				expire()
			return
		if((!( current ) || loc == current))
			current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
		if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
			qdel(src)	//Instadelete if we leave map
			return

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data

		if(!location)
			qdel(src)	// if it's left the world... kill it
			return

		if (!vacuum_traversal && is_below_sound_pressure(get_turf(src))) //Deletes projectiles that aren't supposed to bein vacuum if they leave pressurised areas
			if (!expired)
				expire()
			return

		before_move()
		Move(location.return_turf())

		if(!bumped && !isturf(original))
			if(loc == get_turf(original))
				if(!(original in permutated))
					if(Bump(original))
						return


		if(first_step)
			muzzle_effect(effect_transform)
			first_step = 0
		else if(!bumped && kill_count > 0)
			tracer_effect(effect_transform)
		if(!hitscan)
			sleep(step_delay)	//add delay between movement iterations if it's not a hitscan weapon

/obj/item/projectile/proc/before_move()
	return 0

/obj/item/projectile/proc/setup_trajectory(turf/startloc, turf/targloc, var/x_offset = 0, var/y_offset = 0)
	// setup projectile state
	starting = startloc
	current = startloc
	yo = round(targloc.y - startloc.y + y_offset, 1)
	xo = round(targloc.x - startloc.x + x_offset, 1)

	// trajectory dispersion
	var/offset = 0
	if(dispersion)
		var/radius = round(dispersion*9, 1)
		offset = rand(-radius, radius)

	// plot the initial trajectory
	trajectory = new()
	trajectory.setup(starting, original, pixel_x, pixel_y, angle_offset=offset)

	location = trajectory.return_location(location)

	// generate this now since all visual effects the projectile makes can use it
	effect_transform = new()
	effect_transform.Scale(round(trajectory.return_hypotenuse() + 0.005, 0.001) , 1) //Seems like a weird spot to truncate, but it minimizes gaps.
	effect_transform.Turn(round(-trajectory.return_angle(), 0.1))		//no idea why this has to be inverted, but it works

	var/newrot = (-(trajectory.return_angle() + 90))
	transform = turn(transform, newrot - default_rotation) //Bullets are turned because their sprites are drawn side-facing
	default_rotation = newrot

/obj/item/projectile/proc/muzzle_effect(var/matrix/T)
	if(silenced)
		return

	if(ispath(muzzle_type))
		var/obj/effect/projectile/M = new muzzle_type(get_turf(src))

		if(istype(M))
			M.set_transform(T)
			M.pixel_x = round(location.pixel_x, 1)
			M.pixel_y = round(location.pixel_y, 1)
			if(hitscan) //Bullets don't hit their target instantly, so we can't link the deletion of the muzzle flash to the bullet's Destroy()
				segments += M

/obj/item/projectile/proc/tracer_effect(var/matrix/M)
	if(ispath(tracer_type))
		var/obj/effect/projectile/P = new tracer_type(location.loc)

		if(istype(P))
			P.set_transform(M)
			P.pixel_x = round(location.pixel_x, 1)
			P.pixel_y = round(location.pixel_y, 1)
			if(hitscan)
				segments += P

/obj/item/projectile/proc/impact_effect(var/matrix/M)
	if(ispath(impact_type))
		var/obj/effect/projectile/P = new impact_type(location.loc)

		if(istype(P))
			P.set_transform(M)
			P.pixel_x = round(location.pixel_x, 1)
			P.pixel_y = round(location.pixel_y, 1)
			segments += P

			//animate(P, alpha = 0, time = 2)
			//QDEL_IN(P,2)

/*
	Kinesis Code
*/
/obj/item/projectile/can_telegrip()
	if (grippable)
		//Normally its bad to set things in a checking function, but projectiles use anchored in an unintended manner. A hack for a hack.
		anchored = FALSE
		return TRUE
	return FALSE

/obj/item/projectile/telegripped()
	flying = FALSE	//Stop flying so it can be moved around


/obj/item/projectile/telegrip_released(var/obj/item/rig_module/kinesis/gripper)
	//Drop and hit the floor beneath us if we were dropped
	if (gripper.release_type == RELEASE_DROP)
		var/turf/T = get_turf(src)
		Bump(T)