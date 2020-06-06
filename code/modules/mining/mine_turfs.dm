var/list/mining_walls = list()
var/list/mining_floors = list()

/**********************Mineral deposits**************************/
/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = 1
	opacity = 1

/turf/simulated/mineral //wall piece
	name = "rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock"
	initial_gas = null
	opacity = 1
	density = 1
	blocks_air = 1
	temperature = T0C
	var/mined_turf = /turf/simulated/floor/asteroid
	var/ore/mineral
	var/mined_ore = 0
	var/last_act = 0
	var/emitter_blasts_taken = 0 // EMITTER MINING! Muhehe.

	var/datum/geosample/geologic_data
	//var/excavation_level = 0
	var/list/finds
	var/next_rock = 0

	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find


	has_resources = 1

	//Defense and damage
	//FUTURE TODO: MAke these apply to all turfs. and eventually, all atoms
	var/health
	var/max_health = 200
	var/resistance	=	5

	//Overlays
	var/image/ore_overlay		//Handled in update_mineral, never needs to be touched again. Only disappears when the turf is changed
	var/image/archaeo_overlay	//Handled in update_archaeo_overlay, updated whenever a find is dug out
	var/image/excav_overlay		//Handled in update_excavation_overlay, updated every time dig is called

/turf/simulated/mineral/New()
	health = max_health

/turf/simulated/mineral/Initialize()

	if (!mining_walls["[src.z]"])
		mining_walls["[src.z]"] = list()
	mining_walls["[src.z]"] += src
	MineralSpread()
	update_archaeo_overlay()
	spawn()
		update_icon(1)
	.=..()

/turf/simulated/mineral/Destroy()
	if (mining_walls["[src.z]"])
		mining_walls["[src.z]"] -= src
	return ..()

/turf/simulated/mineral/can_build_cable()
	return !density

/turf/simulated/mineral/is_plating()
	return 1

/turf/simulated/mineral/update_icon(var/update_neighbors)
	if(!mineral)
		SetName(initial(name))
		icon_state = "rock"
	else
		SetName("[mineral.display_name] deposit")

	overlays.Cut()

	for(var/direction in GLOB.cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(update_neighbors && istype(turf_to_check,/turf/simulated/floor/asteroid))
			var/turf/simulated/floor/asteroid/T = turf_to_check
			T.updateMineralOverlays()
		else if(istype(turf_to_check,/turf/space) || istype(turf_to_check,/turf/simulated/floor))
			var/image/rock_side = image(icon, "rock_side", dir = turn(direction, 180))
			rock_side.turf_decal_layerise()
			switch(direction)
				if(NORTH)
					rock_side.pixel_y += world.icon_size
				if(SOUTH)
					rock_side.pixel_y -= world.icon_size
				if(EAST)
					rock_side.pixel_x += world.icon_size
				if(WEST)
					rock_side.pixel_x -= world.icon_size
			overlays += rock_side

	if(ore_overlay)
		overlays += ore_overlay

	if(excav_overlay)
		overlays += excav_overlay

	if(archaeo_overlay)
		overlays += archaeo_overlay

/turf/simulated/mineral/ex_act(severity)
	switch(severity)
		if(2.0)
			dig(rand(150,400))
		if(1.0)
			dig(rand(50,300))

/turf/simulated/mineral/apply_impulse(var/direction, var/strength)

	var/dig_power = (rand_between(0.85,1.15)*strength)*1.5
	dig(dig_power)

/turf/simulated/mineral/bullet_act(var/obj/item/projectile/proj)
	dig(proj.damage)
	if (health <= 0)
		return PROJECTILE_CONTINUE
	.=..()

/turf/simulated/mineral/Bumped(AM)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.l_hand,/obj/item/weapon/tool/pickaxe)) && (!H.hand))
			attackby(H.l_hand,H)
		else if((istype(H.r_hand,/obj/item/weapon/tool/pickaxe)) && H.hand)
			attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/weapon/tool/pickaxe))
			attackby(R.module_active,R)

	else if(istype(AM,/obj/mecha))
		var/obj/mecha/M = AM
		if(istype(M.selected,/obj/item/mecha_parts/mecha_equipment/tool/drill))
			M.selected.action(src)

/turf/simulated/mineral/proc/MineralSpread()
	if(mineral && mineral.spread)
		for(var/trydir in GLOB.cardinal)
			if(prob(mineral.spread_chance))
				var/turf/simulated/mineral/target_turf = get_step(src, trydir)
				if(istype(target_turf) && !target_turf.mineral)
					target_turf.mineral = mineral
					target_turf.UpdateMineral()
					target_turf.MineralSpread()

/turf/simulated/mineral/proc/excavation_level()
	return (max_health - health)


/turf/simulated/mineral/proc/UpdateMineral()
	clear_ore_effects()
	ore_overlay = image('icons/obj/mining.dmi', "rock_[mineral.icon_tag]")
	ore_overlay.appearance_flags = RESET_COLOR
	ore_overlay.turf_decal_layerise()
	ore_overlay.rotate_random()
	update_icon()



//Completely remaking this pile of spaghetti	~Nanako
/turf/simulated/mineral/attackby(var/obj/item/I, var/mob/living/user)
	if (istype(I))
		var/list/valid_qualities = I.has_qualities(list(QUALITY_DIGGING, QUALITY_EXCAVATION))
		if (QUALITY_DIGGING in valid_qualities)
			//We got a digging tool here!
			dig_with_tool(I, user)
			return TRUE

	//Archeology tools
	if (istype(I, /obj/item/device/core_sampler))
		geologic_data.UpdateNearbyArtifactInfo(src)
		var/obj/item/device/core_sampler/C = I
		C.sample_item(src, user)
		return

	if (istype(I, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = I
		C.scan_atom(user, src)
		return

	if (istype(I, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = I
		user.visible_message("<span class='notice'>\The [user] extends [P] towards [src].</span>","<span class='notice'>You extend [P] towards [src].</span>")
		if(do_after(user,10, src))
			to_chat(user, "<span class='notice'>\The [src] has been excavated to a depth of [excavation_level()]cm.</span>")
		return


//Alt-clicking a mining turf does the opposite of what your tool normally does.
	//If it defaults full dig, altclick does a single strike
	//And if it defaults single strike, altclick does a full dig
/turf/simulated/mineral/AltClick(var/mob/user)
	var/obj/item/I = user.get_active_hand()
	if (istype(I,/obj/item/weapon/tool/pickaxe))
		var/obj/item/weapon/tool/pickaxe/P = I
		return dig_with_tool(P, user, (!P.default_full_dig))
	else
		return .=..()


/turf/simulated/mineral/proc/clear_ore_effects()
	overlays -= ore_overlay
	ore_overlay = null

/turf/simulated/mineral/proc/DropMineral()
	if(!mineral)
		return

	clear_ore_effects()
	var/obj/item/weapon/ore/O = new mineral.ore (src)
	if(geologic_data && istype(O))
		geologic_data.UpdateNearbyArtifactInfo(src)
		O.geologic_data = geologic_data
	return O

//The full dig var determines whether we're digging out the whole turf or just hitting it once
/turf/simulated/mineral/proc/dig_with_tool(var/obj/item/I, var/mob/living/user, var/full_dig = null)
	if (isnull(full_dig))
		full_dig = TRUE
		if (istype(I, /obj/item/weapon/tool/pickaxe))
			var/obj/item/weapon/tool/pickaxe/P = I
			full_dig = P.default_full_dig


	var/dig_power = 0
	dig_power = I.get_tool_quality(QUALITY_DIGGING)
	var/effective_resistance = max(0, resistance - I.armor_penetration)

	if (dig_power <= effective_resistance)
		to_chat(user, SPAN_WARNING("[src] is too tough for this tool to dig through! You need a better tool."))
		return

	var/dig_time = (health / (dig_power - effective_resistance)) SECONDS
	if (!full_dig)
		dig_time = min(dig_time, 1 SECOND)

	var/start_time = world.time
	if (I.use_tool(user, src, dig_time, QUALITY_DIGGING, FAILCHANCE_EASY, sound_repeat = 1 SECONDS))
		if (full_dig)	//If its a full dig, take all of our health
			dig(health, user, I, TRUE)
		else
			dig(dig_power, user, I, FALSE)
	else
		//If the user aborts or fails the digging, the rock is still partially dug out, equal to 75% of the time spent digging
		var/seconds_spent_digging = (0.75 * (world.time - start_time))*0.1
		dig(dig_power * seconds_spent_digging)

/turf/simulated/mineral/proc/dig(var/power, var/user, var/used_weapon, var/ignore_resistance = FALSE)
	take_damage(power, BRUTE, user, used_weapon, ignore_resistance)
	update_icon()

	//The type of the turf will change if it is completely dug out
	if (istype(src, /turf/simulated/mineral))
		handle_finds(user)
		update_excavation_overlay()
		update_icon()

/turf/simulated/mineral/proc/update_excavation_overlay()
	//update overlays displaying excavation level
	if( excavation_level() > 0)
		var/excav_quadrant = round(excavation_level() / 50) + 1
		excav_overlay = image('icons/turf/walls.dmi', "overlay_excv[excav_quadrant]_[rand(1,3)]")
		excav_overlay.appearance_flags = RESET_COLOR
		excav_overlay.turf_decal_layerise()
		excav_overlay.rotate_random()

/turf/simulated/mineral/proc/update_archaeo_overlay()
	if (!LAZYLEN(finds))
		archaeo_overlay = null
	else
		archaeo_overlay = image('icons/turf/walls.dmi', "overlay_archaeo[rand(1,3)]")
		archaeo_overlay.appearance_flags = RESET_COLOR
		archaeo_overlay.turf_decal_layerise()
		archaeo_overlay.rotate_random()


/turf/simulated/mineral/proc/handle_finds(var/mob/user)
	if (!LAZYLEN(finds))
		return

	var/depth = excavation_level()
	for (var/datum/find/F in finds)
		if(depth > F.excavation_required) // Digging too deep can break the item. At least you won't summon a Balrog (probably)
			var/fail_message = ". <b>[pick("There is a crunching noise","Part of the rock face crumbles away","Something breaks under your assault", "That didn't feel right")]</b>"

			to_chat(user, SPAN_WARNING(fail_message))
			if(prob(90))
				if(prob(25))
					excavate_find(prob(5), F)
				else if(prob(50))
					finds.Remove(F)
					if(prob(50))
						artifact_debris()
		else if (depth == F.excavation_required)
			excavate_find(TRUE, F)


/turf/simulated/mineral/proc/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/ignore_resistance = FALSE)
	if (!ignore_resistance)
		var/AP = 0
		if (istype(used_weapon, /obj))
			var/obj/O = used_weapon
			AP = O.armor_penetration
		var/effective_resistance = max(0, resistance - AP)
		amount -= effective_resistance
	if (amount <= 0)
		return FALSE

	health -= amount

	if (health <= 0)
		health = 0
		return zero_health(amount, damtype, user, used_weapon, ignore_resistance)//Some zero health overrides do things with a return value
	else
		update_icon()
		return TRUE

/turf/simulated/mineral/proc/zero_health(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/ignore_resistance)
	finish_mining()

/turf/simulated/mineral/proc/finish_mining()
	//var/destroyed = 0 //used for breaking strange rocks
	if (mineral && mineral.result_amount)

		//if the turf has already been excavated, some of it's ore has been removed
		for (var/i = 1 to mineral.result_amount - mined_ore)
			DropMineral()

	var/obj/structure/boulder/B
	if(artifact_find)
		if(prob(15))
			//boulder with an artifact inside
			B = new(src)
			if(artifact_find)
				B.artifact_find = artifact_find
		else
			artifact_debris(1)
	else if(prob(5))
		//empty boulder
		B = new(src)

	density = FALSE
	opacity = FALSE

	spawn()
		if (!QDELETED(src) && istype(src, /turf/simulated/mineral))
			var/turf/simulated/floor/asteroid/N = ChangeTurf(mined_turf)

			if(istype(N))
				N.overlay_detail = "asteroid[rand(0,9)]"
				N.updateMineralOverlays(1)



/turf/simulated/mineral/proc/excavate_find(var/prob_clean = 0, var/datum/find/F)

	//many finds are ancient and thus very delicate - luckily there is a specialised energy suspension field which protects them when they're being extracted
	if(prob(F.prob_delicate))
		var/obj/effect/suspension_field/S = locate() in src
		if(!S)
			visible_message("<span class='danger'>[pick("An object in the rock crumbles away into dust.","Something falls out of the rock and shatters onto the ground.")]</span>")
			finds.Remove(F)
			update_archaeo_overlay()
			return

	//with skill and luck, players can cleanly extract finds
	//otherwise, they come out inside a chunk of rock
	if(prob_clean)
		var/find = get_archeological_find_by_findtype(F.find_type)
		new find(src)
	else
		var/obj/item/weapon/ore/strangerock/rock = new(src, inside_item_type = F.find_type)
		geologic_data.UpdateNearbyArtifactInfo(src)
		rock.geologic_data = geologic_data

	finds.Remove(F)
	update_archaeo_overlay()


/turf/simulated/mineral/proc/artifact_debris(var/severity = 0)
	//cael's patented random limited drop componentized loot system!
	//sky's patented not-fucking-retarded overhaul!

	//Give a random amount of loot from 1 to 3 or 5, varying on severity.
	for(var/j in 1 to rand(1, 3 + max(min(severity, 1), 0) * 2))
		switch(rand(1,7))
			if(1)
				var/obj/item/stack/rods/R = new(src)
				R.amount = rand(5,25)

			if(2)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5,25)

			if(3)
				var/obj/item/stack/material/steel/R = new(src)
				R.amount = rand(5,25)

			if(4)
				var/obj/item/stack/material/plasteel/R = new(src)
				R.amount = rand(5,25)

			if(5)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/weapon/material/shard(src)

			if(6)
				var/quantity = rand(1,3)
				for(var/i=0, i<quantity, i++)
					new /obj/item/weapon/material/shard/phoron(src)

			if(7)
				var/obj/item/stack/material/uranium/R = new(src)
				R.amount = rand(5,25)



/turf/simulated/mineral/random
	name = "Mineral deposit"
	var/mineralSpawnChanceList = list("Uranium" = 5, "Platinum" = 5, "Iron" = 35, "Carbon" = 35, MATERIAL_DIAMOND = 1, MATERIAL_GOLD = 5, MATERIAL_SILVER = 5, MATERIAL_PHORON = 10)
	var/mineralChance = 1.5 //means 1% chance of this plot changing to a mineral deposit

/turf/simulated/mineral/random/Initialize()
	pick_mineral()
	.=..()

/turf/simulated/mineral/random/proc/pick_mineral()
	if (prob(mineralChance) && !mineral)
		var/mineral_name = pickweight(mineralSpawnChanceList) //temp mineral name
		mineral_name = lowertext(mineral_name)
		if (mineral_name && (mineral_name in ore_data))
			mineral = ore_data[mineral_name]
			UpdateMineral()

/turf/simulated/mineral/random/high_chance
	mineralChance = 25
	mineralSpawnChanceList = list("Uranium" = 10, "Platinum" = 10, "Iron" = 20, "Carbon" = 20, MATERIAL_DIAMOND = 2, MATERIAL_GOLD = 10, MATERIAL_SILVER = 10, MATERIAL_PHORON = 20)


/**********************Asteroid**************************/

// Setting icon/icon_state initially will use these values when the turf is built on/replaced.
// This means you can put grass on the asteroid etc.
/turf/simulated/floor/asteroid
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	base_name = "sand"
	base_desc = "Gritty and unpleasant."
	base_icon = 'icons/turf/flooring/asteroid.dmi'
	base_icon_state = "asteroid"

	initial_flooring = null
	initial_gas = null
	temperature = TCMB
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug
	var/overlay_detail
	has_resources = 1

/turf/simulated/floor/asteroid/New()
	if (!mining_floors["[src.z]"])
		mining_floors["[src.z]"] = list()
	mining_floors["[src.z]"] += src
	if(prob(20))
		overlay_detail = "asteroid[rand(0,9)]"

/turf/simulated/floor/asteroid/Destroy()
	if (mining_floors["[src.z]"])
		mining_floors["[src.z]"] -= src
	return ..()

/turf/simulated/floor/asteroid/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if (prob(70))
				gets_dug()
		if(1.0)
			gets_dug()
	return

/turf/simulated/floor/asteroid/is_plating()
	return !density

/turf/simulated/floor/asteroid/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!W || !user)
		return 0

	var/list/usable_tools = list(
		/obj/item/weapon/tool/shovel,
		/obj/item/weapon/tool/pickaxe
		)

	var/valid_tool
	for(var/valid_type in usable_tools)
		if(istype(W,valid_type))
			valid_tool = 1
			break

	if(valid_tool)
		if (dug)
			to_chat(user, "<span class='warning'>This area has already been dug</span>")
			return

		var/turf/T = user.loc
		if (!(istype(T)))
			return

		to_chat(user, "<span class='warning'>You start digging.</span>")
		playsound(user.loc, 'sound/effects/rustle1.ogg', 50, 1)

		if(!do_after(user,40, src)) return

		to_chat(user, "<span class='notice'>You dug a hole.</span>")
		gets_dug()

	else if(istype(W,/obj/item/weapon/storage/ore))
		var/obj/item/weapon/storage/ore/S = W
		if(S.collection_mode)
			for(var/obj/item/weapon/ore/O in contents)
				O.attackby(W,user)
				return
	else if(istype(W,/obj/item/weapon/storage/bag/fossils))
		var/obj/item/weapon/storage/bag/fossils/S = W
		if(S.collection_mode)
			for(var/obj/item/weapon/fossil/F in contents)
				F.attackby(W,user)
				return

	else
		..(W,user)
	return

/turf/simulated/floor/asteroid/proc/gets_dug()

	if(dug)
		return

	for(var/i=0;i<(rand(3)+2);i++)
		new/obj/item/weapon/ore/glass(src)

	dug = 1
	icon_state = "asteroid_dug"
	return

/turf/simulated/floor/asteroid/proc/updateMineralOverlays(var/update_neighbors)

	overlays.Cut()

	var/list/step_overlays = list("n" = NORTH, "s" = SOUTH, "e" = EAST, "w" = WEST)
	for(var/direction in step_overlays)

		if(istype(get_step(src, step_overlays[direction]), /turf/space))
			var/image/aster_edge = image('icons/turf/flooring/asteroid.dmi', "asteroid_edges", dir = step_overlays[direction])
			aster_edge.turf_decal_layerise()
			overlays += aster_edge

		if(istype(get_step(src, step_overlays[direction]), /turf/simulated/mineral))
			var/image/rock_wall = image('icons/turf/walls.dmi', "rock_side", dir = step_overlays[direction])
			rock_wall.turf_decal_layerise()
			overlays += rock_wall

	//todo cache
	if(overlay_detail)
		var/image/floor_decal = image(icon = 'icons/turf/flooring/decals.dmi', icon_state = overlay_detail)
		floor_decal.turf_decal_layerise()
		overlays |= floor_decal

	if(update_neighbors)
		var/list/all_step_directions = list(NORTH,NORTHEAST,EAST,SOUTHEAST,SOUTH,SOUTHWEST,WEST,NORTHWEST)
		for(var/direction in all_step_directions)
			var/turf/simulated/floor/asteroid/A
			if(istype(get_step(src, direction), /turf/simulated/floor/asteroid))
				A = get_step(src, direction)
				A.updateMineralOverlays()

/turf/simulated/floor/asteroid/Entered(atom/movable/M as mob|obj)
	..()
	if(istype(M,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		if(R.module)
			if(istype(R.module_state_1,/obj/item/weapon/storage/ore))
				attackby(R.module_state_1,R)
			else if(istype(R.module_state_2,/obj/item/weapon/storage/ore))
				attackby(R.module_state_2,R)
			else if(istype(R.module_state_3,/obj/item/weapon/storage/ore))
				attackby(R.module_state_3,R)
			else
				return
