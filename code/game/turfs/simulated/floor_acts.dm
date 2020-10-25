/*Rough floor health values:
	Tiles: 50
	Plating: 100
	Underplating: 200
	Hull: 700
*/

//EX act uses new damage type blast, which allows it to get burn AND damage overlays simultaneously
/turf/simulated/floor/ex_act(severity)

	//Eris shield handling removed, the dead space setting does not have energy shields

	switch(severity)
		if(1.0)
			take_damage(rand(150, 300), BLAST) //Breaks through 3 - 4 layers
		if(2.0)
			take_damage(rand(50, 200), BLAST) //Breaks through 2 - 3 layers
		if(3.0)
			take_damage(rand(20, 100), BLAST) //Breaks 1-2 layers


/turf/simulated/floor/fire_act(var/datum/gas_mixture/air, var/exposed_temperature, var/exposed_volume, var/multiplier = 1)

	var/burn_damage = get_fire_damage(exposed_temperature, 0.5*multiplier)
	if (burn_damage > 0)
		take_damage(damage = burn_damage, damage_type = BURN, ignore_resistance = TRUE)


//should be a little bit lower than the temperature required to destroy the material
/turf/simulated/floor/get_heat_limit()
	return flooring ? flooring.damage_temperature : T0C+1000

/turf/simulated/floor/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/dir_to = get_dir(src, adj_turf)

	for(var/obj/structure/window/W in src)
		if(W.dir == dir_to || W.is_fulltile()) //Same direction or diagonal (full tile)
			W.fire_act(adj_air, adj_temp, adj_volume)
