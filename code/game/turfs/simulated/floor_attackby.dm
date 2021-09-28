/turf/simulated/floor/attackby(obj/item/I, mob/user)

	if(!I || !user)
		return 0

	if(istype(src, /turf/simulated/floor/plating/under) && istype(I, /obj/item/stack/material/cyborg/steel))
		if(do_after(user, 5, src))
			if(I:use(2))
				ChangeTurf(/turf/simulated/floor/plating)

	//Eris shield handling removed, the dead space setting does not have energy shields

	//Flooring attackby may intercept the proc.
	//If it has a nonzero return value, then we return too
	if (flooring && flooring.attackby(I, user, src))
		return TRUE

/* disabled until further notice. This isn't intended, use tools instead.
	//Attempting to damage floors with things
	//This has a lot of potential to break things, so it's limited to harm intent.
	//This supercedes all construction, deconstruction and similar actions. So change your intent out of harm if you don't want to smack the floor
	if (usr.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.item_flags & ITEM_FLAG_NO_BLUDGEON))
			user.do_attack_animation(src)
			var/calc_damage = (I.force*I.structure_damage_factor) - flooring.resistance
			var/volume = (calc_damage)*3.5
			volume = min(volume, 15)
			if (flooring.hit_sound)
				playsound(src, flooring.hit_sound, volume, 1, -1)
			else if (I.hitsound)
				playsound(src, I.hitsound, volume, 1, -1)

			if (calc_damage > 0)
				visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
				take_damage(I.force*I.structure_damage_factor, I.damtype)
			else
				visible_message(SPAN_DANGER("[user] ineffectually hits [src] with [I]"))
			user.set_click_cooldown(DEFAULT_ATTACK_COOLDOWN*1.5) //This longer cooldown helps promote skill in melee combat by punishing misclicks a bit
			return TRUE
*/

	for(var/atom/movable/A in src)
		if(A.preventsTurfInteractions())
			to_chat(user, SPAN_NOTICE("[A] is in the way."))
			A.attackby(I, user)
			if(A.preventsTurfInteractions())
				return


	if(istype(I, /obj/item/stack/cable_coil) || (flooring && istype(I, /obj/item/stack/rods)))
		return ..(I, user)

	/*	//Eris frame building code, probably unused
	if(istype(I,/obj/item/frame))
		var/obj/item/frame/F = I
		F.try_floorbuild(src)
		return
	*/

	if (is_plating())
		if(istype(I, /obj/item/stack))
			if(is_damaged())
				to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
				return
			var/obj/item/stack/S = I
			var/decl/flooring/use_flooring
			for(var/flooring_type in flooring_types)
				var/decl/flooring/F = flooring_types[flooring_type]
				if(!F.build_type)
					continue
				if((ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type)) && ((S.type == F.build_type) || (S.build_type == F.build_type)))
					if (flooring && flooring.can_build_floor(F))
						use_flooring = F
						break
				else if (istype(S, /obj/item/stack/material))//Handling for material stacks
					var/obj/item/stack/material/M = S
					if (F.build_type == M.material.name)
						if (flooring && flooring.can_build_floor(F))
							use_flooring = F
							break

			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				to_chat(user, SPAN_WARNING("You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor]."))
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
				return
			if(	!S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return

	if(flooring)

		var/list/usable_qualities = list()
		if(is_damaged() || (flooring.flags & TURF_IS_FRAGILE) || (flooring.flags & TURF_REMOVE_CROWBAR))
			usable_qualities.Add(QUALITY_PRYING)
		if(!(is_damaged()) || flooring.flags & TURF_REMOVE_SCREWDRIVER)
			usable_qualities.Add(QUALITY_SCREW_DRIVING)
		if(flooring.flags & TURF_REMOVE_WRENCH)
			usable_qualities.Add(QUALITY_BOLT_TURNING)
		if(flooring.flags & TURF_REMOVE_SHOVEL)
			usable_qualities.Add(QUALITY_SHOVELING)
		if(is_damaged() || flooring.flags & TURF_REMOVE_WELDER)
			usable_qualities.Add(QUALITY_WELDING)
		if(is_damaged())
			usable_qualities.Add(QUALITY_SEALING)
		var/tool_type = I.get_tool_type(user, usable_qualities, src)
		switch(tool_type)
			if(QUALITY_SEALING)
				user.visible_message("[user] starts sealing up cracks in [src] with the [I]", "You start sealing up cracks in [src] with the [I]")
				if (I.use_tool(user, src, 50 + ((max_health - health)*2), QUALITY_SEALING, FAILCHANCE_NORMAL))
					to_chat(user, SPAN_NOTICE("The [src] looks pretty solid now!"))
					health = max_health
					broken = FALSE
					burnt = FALSE
					update_icon()
				return
			if(QUALITY_PRYING)
				if(is_damaged())
					if(I.use_tool(user, src, flooring.removal_time, tool_type, FAILCHANCE_VERY_EASY))
						to_chat(user, SPAN_NOTICE("You remove the broken [flooring.descriptor]."))
						make_plating()
						remove_runes()
					return
				else if(flooring.flags & TURF_IS_FRAGILE)
					if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
						return
					if(I.use_tool(user, src, flooring.removal_time, tool_type, FAILCHANCE_VERY_EASY))
						to_chat(user, SPAN_DANGER("You forcefully pry off the [flooring.descriptor], destroying them in the process."))
						make_plating()
						remove_runes()
					return
				else if(flooring.flags & TURF_REMOVE_CROWBAR)
					if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
						return
					if(I.use_tool(user, src, flooring.removal_time, tool_type, FAILCHANCE_VERY_EASY))
						to_chat(user, SPAN_NOTICE("You lever off the [flooring.descriptor]."))
						make_plating(1)
						remove_runes()
					return
				return

			if(QUALITY_SCREW_DRIVING)
				if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
					return
				if((!(is_damaged()) && !is_plating()) || flooring.flags & TURF_REMOVE_SCREWDRIVER)
					if(I.use_tool(user, src, flooring.removal_time*1.5, tool_type, FAILCHANCE_VERY_EASY))
						to_chat(user, SPAN_NOTICE("You unscrew and remove the [flooring.descriptor]."))
						make_plating(1)
						remove_runes()
				return

			if(QUALITY_BOLT_TURNING)
				if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
					return
				if(flooring.flags & TURF_REMOVE_WRENCH)
					if(I.use_tool(user, src, flooring.removal_time, tool_type, FAILCHANCE_NORMAL))
						to_chat(user, SPAN_NOTICE("You unwrench and remove the [flooring.descriptor]."))
						make_plating(1)
						remove_runes()
				return

			if(QUALITY_SHOVELING)
				if(flooring.flags & TURF_REMOVE_SHOVEL)
					if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
						return
					if(I.use_tool(user, src, flooring.removal_time, tool_type, FAILCHANCE_VERY_EASY))
						to_chat(user, SPAN_NOTICE("You shovel off the [flooring.descriptor]."))
						make_plating(1)
						remove_runes()
				return

			if(QUALITY_WELDING)
				if(is_damaged())
					if(I.use_tool(user, src, max_health - health, QUALITY_WELDING, FAILCHANCE_NORMAL))
						to_chat(user, SPAN_NOTICE("You fix some dents on the broken plating."))
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						health = max_health
						burnt = null
						broken = null
						update_icon()
						return

				if(flooring.flags & TURF_REMOVE_WELDER)
					if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
						return
					to_chat(user, SPAN_NOTICE("You start cutting through the [flooring.descriptor]."))
					if(I.use_tool(user, src, flooring.removal_time, tool_type, FAILCHANCE_NORMAL))
						to_chat(user, SPAN_NOTICE("You cut through and remove the [flooring.descriptor]."))
						make_plating(1)
						remove_runes()

			if(ABORT_CHECK)
				return

		if(istype(I, /obj/item/stack/cable_coil) && (flooring.flags & TURF_HIDES_THINGS))
			to_chat(user, SPAN_WARNING("You must remove the [flooring.descriptor] first."))
			return
		/*
		else if (istype(I, /obj/item/frame))
			var/obj/item/frame/F = I
			F.try_floorbuild(src)
			return
		*/

	return ..()

/turf/simulated/floor/proc/remove_runes()
	for(var/obj/effect/rune/R in src)
		qdel(R)

/turf/simulated/floor/can_build_cable(var/mob/user)
	if(flooring && (flooring.flags & TURF_HIDES_THINGS))
		to_chat(user, SPAN_WARNING("You must remove the [flooring.descriptor] first."))
		return 0
	if(is_damaged())
		to_chat(user, SPAN_WARNING("This section is too damaged to support anything. Use a welder to fix the damage."))
		return 0
	return 1
