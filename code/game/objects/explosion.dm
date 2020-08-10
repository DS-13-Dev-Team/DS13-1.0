//Explosion power thresholds.
//When the power applied to a tile is at or above this value, the appropriate degree of ex_act is called
#define POWER_DEV	8
#define POWER_HEAVY	4
#define POWER_LIGHT	0
//TODO: Flash range does nothing currently

proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = UP|DOWN, shaped)
	set waitfor = FALSE

	//var/multi_z_scalar = 0.35
	src = null	//so we don't abort once src is deleted

	epicenter = get_turf(epicenter)
	if(!epicenter) return

	// Handles recursive propagation of explosions.
	//Disabled for now, needs some more reworking
	/*
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

	*/



	//This calculates roughly how far our explosion will extend. This is more correctly defined as "minimum range over empty terrain"
	//It may be much shorter if obstacles are involved, or slightly longer if they aren't.
	//We dont want a approximate_range of 0 or bad things happen
	var/approximate_range = max(devastation_range, heavy_impact_range, light_impact_range, flash_range, 1)



	if(adminlog)
		message_admins("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
		log_game("Explosion with size ([devastation_range], [heavy_impact_range], [light_impact_range]) in area [epicenter.loc.name] ")


	//This system means that explosions are not precisely tiered as originally designed,
	//but it creates a rough approximate of the author's intent which preserves the important details
	//The most critical detail is the choice to have any or no tiles affected by a certain level of damage, controlling the maximum power of the epicentre
	//Secondly, it also preserves an approximate overall radius of effect
	//Aside from those two factors, everything else is organic and not really controllable
	var/approximate_intensity = 1

	//Note: A range of 0 for any of these values is perfectly valid, indicating a desire to target the current tile only
	if (isnum(devastation_range) && devastation_range >= 0)
		approximate_intensity = POWER_DEV + devastation_range	//For a range of 0 we apply the defined threshold, and we addd a flat 1 point for every range above that. Since explosions lose 1 intensity per tile
	else if (isnum(heavy_impact_range) && heavy_impact_range >= 0)
		approximate_intensity = POWER_HEAVY + heavy_impact_range
	else if (isnum(light_impact_range) && light_impact_range >= 0)
		approximate_intensity = POWER_LIGHT + light_impact_range

	var/falloff = 1
	if (approximate_intensity < approximate_range)
		falloff = approximate_intensity / approximate_range

	// Large enough explosion. For performance reasons, powernets will be rebuilt manually
	if(!defer_powernet_rebuild && (approximate_range > 10))
		defer_powernet_rebuild = 1


	CHECK_TICK


	explosion_rec(epicenter, approximate_intensity, falloff, shaped)



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
