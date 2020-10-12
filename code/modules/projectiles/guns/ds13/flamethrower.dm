/obj/item/weapon/gun/spray/hydrazine_torch
	var/obj/item/weapon/reagent_containers/glass/fuel_tank/tank

	var/fuel_per_second = 10

	firemodes = list(list(mode_name="flamethrower",mode_type = /datum/firemode/sustained/spray/flame))

	//These vars are read by firemode and set in update_fuel
	spray_type = /datum/extension/spray/flame
	var/range =	4
	var/temperature = T0C + 2600
	var/angle = 30

/obj/item/weapon/gun/spray/hydrazine_torch/load_ammo(A, var/mob/user)
	if (istype(A, /obj/item/weapon/reagent_containers/glass/fuel_tank))
		if (tank && tank.loc == src)
			to_chat(user, SPAN_WARNING("The [src] already has a tank installed, remove it first!"))
			return
		if(!user.unEquip(A, src))
			return
		user.visible_message("[user] inserts \a [A] into [src].", "<span class='notice'>You insert \a [A] into [src].</span>")
		playsound(loc, mag_insert_sound, 50, 1)

		update_fuel()
		update_firemode()

	.=..()

/obj/item/weapon/gun/projectile/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		unload_ammo(user, allow_dump=0)
	else
		return ..()

/obj/item/weapon/gun/spray/hydrazine_torch/Initialize()
	.=..()

	tank = new /obj/item/weapon/reagent_containers/glass/fuel_tank/hydrazine(src)
	update_fuel()
	update_firemode()


/obj/item/weapon/gun/spray/hydrazine_torch/consume_projectiles(var/number = 1)
	if (!tank)
		return FALSE

	var/required_fuel = fuel_per_second * number
	var/fuel_removed = tank.reagents.remove_reagent(tank.fueltype, required_fuel, TRUE)	//Passing true to safety prevents reactions and optimises a tiny bit


	if (fuel_removed < required_fuel)
		world << "Fuel Ran out"
		return FALSE

	return TRUE


/obj/item/weapon/gun/spray/hydrazine_torch/proc/update_fuel()
	if (!tank || tank.fueltype == /datum/reagent/fuel)
		spray_type = /datum/extension/spray/flame
		range =	4
		temperature = T0C + 2600
	else if (tank.fueltype == /datum/reagent/hydrazine)
		spray_type = /datum/extension/spray/flame/blue
		range =	5
		temperature = T0C + 4000




/*
	Fuel Tank
*/
/obj/item/weapon/reagent_containers/glass/fuel_tank
	name = "fuel tank"
	desc = "A tank designed to hold volatile fuels. A warning plate on the side instructs the user not to mix multiple types of fuel, and not to allow any non-fuel contaminants into the tank."
	volume = 400	//four litres

	//If nonzero, there is a small chance of a horrible explosion
	//The tank is considered contaminated if it contains anything other than pure fuel of one type. Normal or Hydrazine
	//It will be considered contaminated if you mix both, or if any nonfuel reagents get in
	var/contamination = 0

	var/fueltype = /datum/reagent/fuel

	can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/weapon/grenade/chem_grenade,
		/obj/item/weapon/storage/secure/safe,
		/obj/machinery/disposal,
		/obj/machinery/smartfridge/,
		/obj/item/weapon/gun/spray/hydrazine_torch
	)


/*
	Two purposes for this proc:
	1. Determines whether we are using normal or hydrazine fuel

	2. Determines how contaminated the tank is
*/
/obj/item/weapon/reagent_containers/glass/fuel_tank/proc/check_fuel_type_and_contamination()
	fueltype = /datum/reagent/fuel

	var/contaminants = reagents.total_volume

	var/quantity_fuel = reagents.get_reagent_amount(/datum/reagent/fuel)
	var/quantity_hydrazine = reagents.get_reagent_amount(/datum/reagent/hydrazine)

	if (quantity_hydrazine > quantity_fuel)
		fueltype = /datum/reagent/hydrazine
		contaminants -= quantity_hydrazine
	else
		contaminants -= quantity_fuel

	contamination = 0
	//Alright, we've determined what should be here, lets see what shouldn't
	if (contaminants > 0)
		contamination = (contaminants / reagents.maximum_volume) * 100

/obj/item/weapon/reagent_containers/glass/fuel_tank/fuel/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/fuel, 400)		//Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/weapon/reagent_containers/glass/fuel_tank/hydrazine
	fueltype = /datum/reagent/hydrazine

/obj/item/weapon/reagent_containers/glass/fuel_tank/hydrazine/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/hydrazine, 400)		//Intentionally low since it is so strong. Still enough to knock someone out.



/*
	Spray guns

	The spray subtype is used for guns that project a constant cone of fire, acid, cold, lightning, etc
*/
/obj/item/weapon/gun/spray
	var/spray_type = /datum/extension/spray

/obj/item/weapon/gun/spray/Process()
	if (firing)
		if (!consume_projectiles(0.2)) //0.2 is the delta of the fastprocess subsystem
			stop_firing()


//This proc creates particles and applies effects
/obj/item/weapon/gun/spray/started_firing()
	//TODO Here: prob check to explode if tank contaminated
	firing = TRUE
	world << "Flamethrower started firing"
	START_PROCESSING(SSfastprocess, src)


/obj/item/weapon/gun/spray/stop_firing()
	firing = FALSE
	world << "Flamethrower stopped firing"
	.=..()

	STOP_PROCESSING(SSfastprocess, src)

	//Just to be sure
	stop_spraying()


/*
	Firemode
*/
/datum/firemode/sustained/spray/flame
	spray_type = /datum/extension/spray/flame
	angle = 30
	range = 5

/datum/firemode/sustained/spray/flame/update(var/forced_state)
	var/obj/item/weapon/gun/spray/hydrazine_torch/HT = gun
	range = HT.range
	angle = HT.angle
	extra_data = list("temperature" = HT.temperature)
	.=..()
