/*		Portable Turrets:
		Constructed from metal, a gun of choice, and a prox sensor.
		This code is slightly more documented than normal, as requested by XSI on IRC.
*/



/obj/machinery/turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = 1

	density = 0
	use_power = 1				//this turret uses and requires power
	idle_power_usage = 50		//when inactive, this turret takes up constant 50 Equipment power
	active_power_usage = 300	//when active, this turret takes up constant 300 Equipment power
	power_channel = EQUIP	//drains power from the EQUIPMENT channel


	var/health = 80			//the turret's health
	var/max_health = 80		//turrets maximal health.
	var/auto_repair = 0		//if 1 the turret slowly repairs itself.
	var/locked = 1			//if the turret's behaviour control access is locked
	var/controllock = 0		//if the turret responds to control panels

	var/installation = /obj/item/weapon/gun/energy/gun		//the type of weapon installed
	var/gun_charge = 0		//the charge of the gun inserted
	var/projectile = null	//holder for bullettype
	var/eprojectile = null	//holder for the shot when emagged
	var/reqpower = 500		//holder for power needed
	var/iconholder = null	//holder for the icon_state. 1 for orange sprite, null for blue.
	var/egun = null			//holder to handle certain guns switching bullettypes
	var/accuracy = -5		//Base accuracy of projectiles, added to what the projectile has naturally

	var/fire_pixel_recoil = 6	//Magnitude of the recoiling animation when firing
	var/rotating = FALSE		//Prevent multiple rotation animations from overlapping
	var/swivel_time	=	2 SECOND	//How long would the turret take to do a full revolution

	//Firing
	var/last_fired = 0		//1: if the turret is cooling down from a shot, 0: turret is ready to fire
	var/fire_delay = 15		//1.5 seconds between each shot
	var/datum/extension/shoot/repeat/shoot_extension	//The object that handles firing
	var/firing	 = FALSE//Briefly set true when we're in a code stack to fire
	var/fire_timer	//Timer handle used to schedule next shot

	var/dispersion = 1	//1 point of dispersion is roughly 9 degrees

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth	 = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 			// AI cannot use this

	var/attacked = 0		//if set to 1, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	var/enabled = 1				//determines if the turret is on
	var/lethal = 0			//whether in lethal or stun mode
	var/disabled = 0

	var/shot_sound 			//what sound should play when the turret fires
	var/eshot_sound			//what sound should play when the emagged turret fires

	var/datum/effect/effect/system/spark_spread/spark_system	//the spark system, used for generating... sparks?

	var/wrenching = 0

	//Targeting cache
	var/last_target			//last target fired at, prevents turrets from erratically firing at all valid targets in range
	var/last_target_status	//This is either PRIORITY_TARGET or SECONDARY_TARGET
	var/last_target_check	=	0	//when did we last check the target we're focusing on, to see if they're still in line of sight, not dead, etc.
	var/target_check_delay = 1 SECOND	//We won't re-check the target every shot, only if this much time has passed since last check
	//This is partly for performance, and also partly for immersion. It'd be silly for the turret to instantly know when its target is dead.
	//It will keep firing at a dead or moved-away target for a brief period


	//Initialized at runtime. Default targeting mode
	var/datum/targeting_profile/targeting_profile = /datum/targeting_profile/turret/crew

	//Manually editing the control params
	var/obj/machinery/turretid/embedded/embedded_controller

	//Handles the proximity triggers
	var/datum/extension/proximity_manager/PM

/obj/machinery/turret/crescent
	enabled = 0
	ailock = 1
	check_synth	 = 0
	check_access = 1
	check_arrest = 1
	check_records = 1
	check_weapons = 1
	check_anomalies = 1

/obj/machinery/turret/stationary
	ailock = 1
	lethal = 1
	installation = /obj/item/weapon/gun/energy/laser

/obj/machinery/turret/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	ailock = 0
	malf_upgraded = 1
	to_chat(user, "\The [src] has been upgraded. It's damage and rate of fire has been increased. Auto-regeneration system has been enabled. Power usage has increased.")
	max_health = round(initial(max_health) * 1.5)
	fire_delay = round(initial(fire_delay) / 2)
	auto_repair = 1
	active_power_usage = round(initial(active_power_usage) * 5)
	return 1

/obj/machinery/turret/New()
	..()
	//We are created in nullspace for a crafting recipe
	if (isturf(loc))
		if (!istype(targeting_profile))
			targeting_profile = new targeting_profile(src)
		req_access.Cut()
		req_one_access = list(access_security, access_bridge)

		//Sets up a spark system
		spark_system = new /datum/effect/effect/system/spark_spread
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)

		if (enabled)
			activate()

		setup()

/obj/machinery/turret/crescent/New()
	..()
	req_one_access.Cut()

/obj/machinery/turret/Destroy()
	qdel(spark_system)
	spark_system = null
	. = ..()

/obj/machinery/turret/proc/setup()
	shoot_extension = set_extension(src, /datum/extension/shoot/repeat, null,//no initial target
	projectile, //projectile type
	accuracy,
	dispersion,
	1,	//Num shots per firing
	0, //Windup time
	shot_sound,
	FALSE,
	fire_delay)





var/list/turret_icons

/obj/machinery/turret/update_icon()


	if(stat & BROKEN)
		icon_state = "turret_broken"
	else if(powered() && enabled)
		icon_state = "turret_active"
	else
		icon_state = "turret_inactive"

/obj/machinery/turret/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>")
		return 1

	if(locked && !issilicon(user))
		to_chat(user, "<span class='notice'>Access denied.</span>")
		return 1

	return 0

/obj/machinery/turret/attack_ai(mob/user)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turret/attack_hand(mob/user)

	if (!embedded_controller)
		embedded_controller = new(src)
	embedded_controller.ui_interact(user)


/obj/machinery/turret/power_change()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()


/obj/machinery/turret/attackby(obj/item/I, mob/user)
	if(stat & BROKEN)
		if(isCrowbar(I))
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			to_chat(user, "<span class='notice'>You begin prying the metal coverings off.</span>")
			if(do_after(user, 200, src))
				new /obj/item/stack/power_node(loc, 2)
				if(prob(70))
					to_chat(user, "<span class='notice'>You remove the turret and salvage some components.</span>")
					if(installation)
						var/obj/item/weapon/gun/energy/Gun = new installation(loc)
						Gun.power_supply.charge = gun_charge
						Gun.update_icon()
					if(prob(50))
						new /obj/item/stack/material/steel(loc, rand(1,4))
					if(prob(50))
						new /obj/item/device/assembly/prox_sensor(loc)
				else
					to_chat(user, "<span class='notice'>You remove the turret but did not manage to salvage anything.</span>")
				qdel(src) // qdel

	else if(isWrench(I))
		if(wrenching)
			to_chat(user, "<span class='warning'>Someone is already [anchored ? "un" : ""]securing the turret!</span>")
			return
		if(!anchored && isinspace())
			to_chat(user, "<span class='warning'>Cannot secure turrets in space!</span>")
			return

		user.visible_message( \
				"<span class='warning'>[user] begins [anchored ? "un" : ""]securing the turret.</span>", \
				"<span class='notice'>You begin [anchored ? "un" : ""]securing the turret.</span>" \
			)

		wrenching = 1
		if(do_after(user, 50, src))
			//This code handles moving the turret around. After all, it's a portable turret!
			if(!anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = 1
				update_icon()
				to_chat(user, "<span class='notice'>You secure the exterior bolts on the turret.</span>")
			else if(anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = 0
				to_chat(user, "<span class='notice'>You unsecure the exterior bolts on the turret.</span>")
				update_icon()
		wrenching = 0

	else if(istype(I, /obj/item/weapon/card/id)||istype(I, /obj/item/modular_computer))
		//Behavior lock/unlock mangement
		if(!embedded_controller)
			embedded_controller = new(src)
		embedded_controller.attackby(I, user)

	else
		//if the turret was attacked with the intention of harming it:
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		take_damage(I.force * 0.5)
		if(I.force * 0.5 > 1) //if the force of impact dealt at least 1 damage, the turret gets pissed off
			if(!attacked && !emagged)
				attacked = 1
				spawn()
					sleep(60)
					attacked = 0
		..()

/obj/machinery/turret/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		//Emagging the turret makes it go bonkers and stun everyone. It also makes
		//the turret shoot much, much faster.
		to_chat(user, "<span class='warning'>You short out [src]'s threat assessment circuits.</span>")
		visible_message("[src] hums oddly...")
		emagged = 1
		iconholder = 1
		controllock = 1
		enabled = 0 //turns off the turret temporarily
		sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
		enabled = 1 //turns it back on. The cover
		return 1

/obj/machinery/turret/proc/take_damage(var/force)
	health -= force
	spark_system.start()
	if(health <= 0)
		die()	//the death process :(


/obj/machinery/turret/bullet_act(obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()

	if(!damage)
		return

	if(enabled)
		if(!attacked && !emagged)
			attacked = 1
			spawn()
				sleep(60)
				attacked = 0

	..()

	take_damage(damage)

/obj/machinery/turret/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		check_arrest = prob(50)
		check_records = prob(50)
		check_weapons = prob(50)
		check_access = prob(20)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = prob(50)
		if(prob(5))
			emagged = 1

		enabled=0
		spawn(rand(60,600))
			if(!enabled)
				enabled=1

	..()



/obj/machinery/turret/ex_act(severity)
	switch (severity)
		if (1)
			take_damage(300)
		if (2)
			take_damage(80)
		if (3)
			take_damage(40)

/obj/machinery/turret/proc/die()	//called when the turret dies, ie, health <= 0
	health = 0
	stat |= BROKEN	//enables the BROKEN bit
	spark_system.start()	//creates some sparks because they look cool
	last_target_check = 0	//This will force a check on the next attempt to fire
	update_icon()
	atom_flags |= ATOM_FLAG_CLIMBABLE // they're now climbable







/datum/turret_checks
	var/enabled
	var/lethal
	var/check_synth
	var/check_access
	var/check_records
	var/check_arrest
	var/check_weapons
	var/check_anomalies
	var/ailock

/obj/machinery/turret/proc/setState(var/datum/turret_checks/TC)
	if(controllock)
		return

	src.lethal = TC.lethal
	src.iconholder = TC.lethal

	check_synth = TC.check_synth
	check_access = TC.check_access
	check_records = TC.check_records
	check_arrest = TC.check_arrest
	check_weapons = TC.check_weapons
	check_anomalies = TC.check_anomalies
	ailock = TC.ailock

	if (TC.enabled)
		activate()
	else
		deactivate()

	src.power_change()




/*
		Portable turret constructions
		Known as "turret frame"s
		Deprecated
*/

/obj/machinery/turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density=1
	var/target_type = /obj/machinery/turret	// The type we intend to build
	var/build_step = 0			//the current step in the building process
	var/finish_name="turret"	//the name applied to the product turret
	var/installation = null		//the gun type installed
	var/gun_charge = 0			//the gun charge of the gun type installed


/obj/machinery/turret_construct/attackby(obj/item/I, mob/user)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(0)	//first step
			if(isWrench(I) && !anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You secure the external bolts.</span>")
				anchored = 1
				build_step = 1
				return

			else if(isCrowbar(I) && !anchored)
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				to_chat(user, "<span class='notice'>You dismantle the turret construction.</span>")
				new /obj/item/stack/material/steel( loc, 5)
				qdel(src)
				return

		if(1)
			if(istype(I, /obj/item/stack/material) && I.get_material_name() == MATERIAL_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, "<span class='notice'>You add some metal armor to the interior frame.</span>")
					build_step = 2
					icon_state = "turret_frame2"
				else
					to_chat(user, "<span class='warning'>You need two sheets of metal to continue construction.</span>")
				return

			else if(istype(I, /obj/item/weapon/tool/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				to_chat(user, "<span class='notice'>You unfasten the external bolts.</span>")
				anchored = 0
				build_step = 0
				return


		if(2)
			if(istype(I, /obj/item/weapon/tool/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You bolt the metal armor into place.</span>")
				build_step = 3
				return

			else if(isWelder(I))
				if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_NORMAL))
					build_step = 1
					to_chat(user, "You remove the turret's interior metal armor.")
					new /obj/item/stack/material/steel( loc, 2)
					return


		if(3)
			if(istype(I, /obj/item/weapon/gun/energy)) //the gun installation part

				if(isrobot(user))
					return
				var/obj/item/weapon/gun/energy/E = I //typecasts the item to an energy gun
				if(!user.unEquip(I))
					to_chat(user, "<span class='notice'>\the [I] is stuck to your hand, you cannot put it in \the [src]</span>")
					return
				installation = I.type //installation becomes I.type
				gun_charge = E.power_supply.charge //the gun's charge is stored in gun_charge
				to_chat(user, "<span class='notice'>You add [I] to the turret.</span>")
				target_type = /obj/machinery/turret

				build_step = 4
				qdel(I) //delete the gun :(
				return

			else if(istype(I, /obj/item/weapon/tool/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				to_chat(user, "<span class='notice'>You remove the turret's metal armor bolts.</span>")
				build_step = 2
				return

		if(4)
			if(isprox(I))
				build_step = 5
				if(!user.unEquip(I))
					to_chat(user, "<span class='notice'>\the [I] is stuck to your hand, you cannot put it in \the [src]</span>")
					return
				to_chat(user, "<span class='notice'>You add the prox sensor to the turret.</span>")
				qdel(I)
				return

			//attack_hand() removes the gun

		if(5)
			if(isScrewdriver(I))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 6
				to_chat(user, "<span class='notice'>You close the internal access hatch.</span>")
				return

			//attack_hand() removes the prox sensor

		if(6)
			if(istype(I, /obj/item/stack/material) && I.get_material_name() == MATERIAL_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, "<span class='notice'>You add some metal armor to the exterior frame.</span>")
					build_step = 7
				else
					to_chat(user, "<span class='warning'>You need two sheets of metal to continue construction.</span>")
				return

			else if(istype(I, /obj/item/weapon/tool/screwdriver))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 5
				to_chat(user, "<span class='notice'>You open the internal access hatch.</span>")
				return

		if(7)
			if(isWelder(I))
				if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_NORMAL))
					build_step = 8
					to_chat(user, "<span class='notice'>You weld the turret's armor down.</span>")

					//The final step: create a full turret
					var/obj/machinery/turret/Turret = new target_type(loc)
					Turret.SetName(finish_name)
					Turret.installation = installation
					Turret.gun_charge = gun_charge
					Turret.enabled = 0
					Turret.setup()

					qdel(src) // qdel

			else if(isCrowbar(I))
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				to_chat(user, "<span class='notice'>You pry off the turret's exterior armor.</span>")
				new /obj/item/stack/material/steel(loc, 2)
				build_step = 6
				return

	if(istype(I, /obj/item/weapon/pen))	//you can rename turrets like bots!
		var/t = sanitizeSafe(input(user, "Enter new turret name", name, finish_name) as text, MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		finish_name = t
		return

	..()


/obj/machinery/turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3

			var/obj/item/weapon/gun/energy/Gun = new installation(loc)
			Gun.power_supply.charge = gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			to_chat(user, "<span class='notice'>You remove [Gun] from the turret frame.</span>")

		if(5)
			to_chat(user, "<span class='notice'>You remove the prox sensor from the turret frame.</span>")
			new /obj/item/device/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/turret_construct/attack_ai()
	return









/*
	Improved logic by nanako
*/




/*
	Activation and Deactivation
*/
/obj/machinery/turret/proc/activate()

	enabled = TRUE

	if (!PM)
		//Lets create a proximity tracker to detect people entering the vicinity
		var/datum/proximity_trigger/view/PT = new (holder = src, on_turf_entered = /obj/machinery/turret/proc/nearby_movement, range = 10)
		PT.register_turfs()
		PM = set_extension(src, /datum/extension/proximity_manager, PT)


/obj/machinery/turret/proc/deactivate()
	enabled = FALSE

	//Lets create a proximity tracker to detect people entering the vicinity
	remove_extension(src, /datum/extension/proximity_manager)
	PM = null







/*
	Target Handling
*/

//Called when we sense something moving nearby
/obj/machinery/turret/proc/nearby_movement(var/atom/movable/AM, var/atom/old_loc)
	if (!enabled || disabled)
		return
	if (!istype(AM, /obj/item/projectile))
		handle_targets()


/obj/machinery/turret/proc/handle_targets()
	var/list/targets = list()			//list of primary targets
	var/list/secondarytargets = list()	//targets that are least important


	for(var/mob/M in mobs_in_view(world.view, src))
		assess_and_assign(M, targets, secondarytargets)

	if(!targets.len && !secondarytargets.len)
		//TODO: Nothing to shoot at, start popdown timer?
		return

	//Select a priority target if possible
	if (targets.len)
		select_target(pick(targets))

	else if (secondarytargets.len)
		//If theres no primary targets, we may pick a second target, but we won't swap one valid secondary target for another
		if (last_target && last_target_status == SECONDARY_TARGET)
			return	//Without picking anything

		select_target(pick(secondarytargets))





/obj/machinery/turret/proc/assess_and_assign(var/mob/living/L, var/list/targets, var/list/secondarytargets)
	switch(targeting_profile.assess_target(L, src))
		if(PRIORITY_TARGET)
			targets += L
		if(SECONDARY_TARGET)
			secondarytargets += L



/obj/machinery/turret/proc/assess_perp(var/mob/living/carbon/human/H)
	if(!H || !istype(H))
		return 0

	if(emagged)
		return 10

	return H.assess_perp(src, check_access, check_weapons, check_records, check_arrest)


//Called when we lose sight of our last target, or we kill them
//Either way, when we enter a state where there are no farther targets to fire at
/obj/machinery/turret/proc/target_lost()
	return





/obj/machinery/turret/proc/select_target(var/mob/living/target)
	if (target == last_target)
		return
	if(disabled)
		return
	if(target)
		last_target_check = world.time	//We just selected it so we can assume it is checked
		last_target = target
		if (!firing)	//Don't try to fire if we're already in the middle of a firing cycle, that would create an infinite loop
		//The caller will handle continued firing
			set_fire_timer()
		return 1
	return


//This proc checks if our current target is still valid. Returns true if so
//If not, it immediately tries to find a new one, and returns true if it succeeds
//Returns false if a new target is needed but not found
/obj/machinery/turret/proc/recheck_current_target()
	.=FALSE
	if (last_target)
		last_target_status = targeting_profile.assess_target(last_target, src)
		last_target_check = world.time	//This is the check, set the time to now

		//Alright we've done a check, what was the result?
		if (last_target_status == PRIORITY_TARGET)
			return TRUE	//Its still a priority target, we're done here. return true. We'll keep shooting at it
		else
			//If we're here, its either secondary or not valid, so we're going to attempt to locate a better target
			if (last_target_status == NOT_TARGET)
				//Our current target is no longer valid, clear it immediately
				last_target = null

				//Lets try to find a priority target
				handle_targets()


			//If we now have a target we can continue shooting
			if (last_target)
				.=TRUE
			else
				target_lost()	//Target lost calls handle targets

/*
	Firing code
*/
/obj/machinery/turret/proc/fire_at_last_target()
	firing = TRUE

	//Is it time for another check
	if ((world.time - last_target_check) > target_check_delay)
		if (!recheck_current_target())
			firing = FALSE
			return FALSE


	.=fire_at(last_target)
	firing = FALSE

	if (!.)
		//If we did not successfully fire, lets check if we'll be able to fire again soon
		//If not, we don't want to endlessly keep attempting to fire, so we won't schedule another shot
		if (!can_ever_fire())
			return
	set_fire_timer()


//Returns false if the turret has any problems that will not go away on their own. Like being turned off/broken. In future, being out of ammo too
/obj/machinery/turret/proc/can_ever_fire()
	if (disabled || stat & BROKEN)
		return FALSE
	return TRUE

//Can we fire right now? Calls can_ever_fire, but also checks for transient problems that will resolve themselves in time like shot cooldown
/obj/machinery/turret/proc/can_fire()
	.=can_ever_fire()
	if (.)
		var/fire_when = last_fired + fire_delay
		if (world.time < fire_when)
			return FALSE

/obj/machinery/turret/proc/fire_at(var/mob/living/target)
	if (!can_fire())
		return FALSE
	swivel_to_target(target)
	.= shoot_extension.fire(target)	//Returns true if firing is successful
	if (.)
		last_fired = world.time
		fire_animation(target)



/obj/machinery/turret/proc/set_fire_timer()
	deltimer(fire_timer)
	//Lets setup the next fire time
	var/fire_when = last_fired + fire_delay	//If we just fired, last_fired will be set to now. Otherwise
	var/fire_delta = max(fire_when - world.time, 0)	//If its been longer than fire delay since our last shot, the next one will be queued up immediately
	fire_timer = addtimer(CALLBACK(src, /obj/machinery/turret/proc/fire_at_last_target), fire_delta)



//Rotate the turret to face the target
/obj/machinery/turret/proc/swivel_to_target(var/atom/A)
	set waitfor = FALSE

	if (rotating)
		return
	var/target_rot = rotation_to_target(src, A, NORTH)//Get the target rotation we'll set to
	var/delta = target_rot - default_rotation



	if (delta != 0)
		rotating = TRUE
		delta = (delta - round(delta, 360))
		var/turntime = swivel_time * (delta / 360)
		default_rotation = target_rot
		if (abs(delta) < 179)
			animate(src, transform = transform.Turn(delta), time = turntime, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
		else
			animate(src, transform = transform.Turn(delta*0.5), time = turntime*0.5, flags = ANIMATION_PARALLEL, easing = SINE_EASING)
			animate(transform = transform.Turn(delta*0.5), time = turntime*0.5)
		sleep(turntime)
		rotating = FALSE


/obj/machinery/turret/proc/fire_animation(var/atom/A)
	//Lets get a direction between us, inverted by putting target first
	var/vector2/direction = Vector2.DirectionBetween(A, src)
	direction = direction*fire_pixel_recoil

	//Alright now the pullback, happens in 1/3rd of our firing delay
	animate(src, pixel_x = default_pixel_x + direction.x, pixel_y = default_pixel_y + direction.y, time = fire_delay * 0.33, easing = BACK_EASING, flags = ANIMATION_PARALLEL)

	//And the reset takes twice as much time
	animate(pixel_x = default_pixel_x, pixel_y = default_pixel_y , time = fire_delay * 0.66)