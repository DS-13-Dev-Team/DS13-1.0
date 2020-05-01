//TODO: Flash range does nothing currently

proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, shaped)
	set waitfor = FALSE

	var/multi_z_scalar = 0.35
	src = null	//so we don't abort once src is deleted

	var/start = world.timeofday
	epicenter = get_turf(epicenter)
	if(!epicenter) return

	// Handles recursive propagation of explosions.
	if(z_transfer)
		var/adj_dev   = max(0, (multi_z_scalar * devastation_range) - (shaped ? 2 : 0) )
		var/adj_heavy = max(0, (multi_z_scalar * heavy_impact_range) - (shaped ? 2 : 0) )
		var/adj_light = max(0, (multi_z_scalar * light_impact_range) - (shaped ? 2 : 0) )
		var/adj_flash = max(0, (multi_z_scalar * flash_range) - (shaped ? 2 : 0) )


		if(adj_dev > 0 || adj_heavy > 0)
			if(HasAbove(epicenter.z) && z_transfer & UP)
				explosion(GetAbove(epicenter), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, UP, shaped)
			if(HasBelow(epicenter.z) && z_transfer & DOWN)
				explosion(GetBelow(epicenter), round(adj_dev), round(adj_heavy), round(adj_light), round(adj_flash), 0, DOWN, shaped)

	var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range)


	if(adminlog)
		message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
		log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")

	var/approximate_intensity = (devastation_range * 3) + (heavy_impact_range * 2) + light_impact_range
	// Large enough explosion. For performance reasons, powernets will be rebuilt manually
	if(!defer_powernet_rebuild && (approximate_intensity > 25))
		defer_powernet_rebuild = 1


	CHECK_TICK


	//Recursive explosions are now mandatory
	var/power = devastation_range * 2 + heavy_impact_range + light_impact_range //The ranges add up, ie light 14 includes both heavy 7 and devestation 3. So this calculation means devestation counts for 4, heavy for 2 and light for 1 power, giving us a cap of 27 power.
	explosion_rec(epicenter, power, shaped)



	return 1

proc/explosion_FX(var/turf/epicenter, var/max_range)

	max_range += world.view
	var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
	E.set_up(epicenter)
	E.start()


	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= max_range)
				M.playsound_local(epicenter, get_sfx("explosion"), VOLUME_MAX, 1) // get_sfx() is so that everyone gets the same sound
			else
				var/volume = VOLUME_HIGH
				if (dist >= max_range * 2)
					volume = VOLUME_MID
				if (dist >= max_range * 3)
					volume = VOLUME_LOW
				M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', volume, 1)
		CHECK_TICK

proc/secondaryexplosion(turf/epicenter, range)
	for(var/turf/tile in range(range, epicenter))
		tile.ex_act(2, epicenter)
