/turf/simulated/floor/proc/gets_drilled()
	return

/turf/simulated/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/simulated/floor/proc/break_tile(rust)
	if(!flooring || !(flooring.flags & TURF_CAN_BREAK) || !isnull(broken))
		return
	if(rust)
		broken = flooring.has_damage_range + 1
	else if(flooring.has_damage_range)
		broken = rand(1,flooring.has_damage_range)
	else
		broken = TRUE
	update_icon()

/turf/simulated/floor/proc/burn_tile()
	if(!flooring || !(flooring.flags & TURF_CAN_BURN) || !isnull(burnt))
		return
	if(flooring.has_burn_range)
		burnt = rand(1,flooring.has_burn_range)
	else
		burnt = TRUE
	update_icon()


/turf/simulated/floor/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist = FALSE)
	.=..()
	if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
		return

	//It is possible for a non floor turf to end up here after certain wierd turf changing operations
	if (!istype(src, /turf/simulated/floor))
		return

	if (is_hole)
		//This turf is space or an open space, it can't break, burn or be damaged
		broken = FALSE
		burnt = FALSE

		//But we could break lattices in this tile
		for (var/obj/structure/lattice/L in src)
			if (amount > 75)
				L.ex_act(1)
		return


	var/changed = FALSE
	//Breaking or burning overlays.
	//A tile can have one of each type
	if (health < (max_health * 0.9))
		if ((damtype == BRUTE || damtype == BLAST) )
			if (!broken)
				changed = TRUE
			broken = TRUE

		if ( (damtype == BURN || damtype == BLAST))
			if (!burnt)
				changed = TRUE
			burnt = TRUE

	if (changed)
		update_icon()

/turf/simulated/floor/zero_health()
	//The tile has broken!
	if (health <= 0)

		make_plating() //Destroy us and make the plating underneath

		/* Damage carryover feature disabled, it doesnt quite work here
		//Leftover damage will carry over to whatever tile replaces this one
		var/leftover = abs(health)

		spawn()
			//We'll spawn off a new stack in order to damage the next layer, incase it turns into a different turf object
			damage_floor_at(x,y,z,leftover, damage_type, ignore_resistance)
		*/
		return


	else



/proc/damage_floor_at(var/x, var/y, var/z, var/damage, var/damage_type, var/ignore_resistance)
	var/turf/simulated/floor/F = locate(x,y,z)
	if (istype(F))
		F.take_damage(damage, damage_type, ignore_resistance)