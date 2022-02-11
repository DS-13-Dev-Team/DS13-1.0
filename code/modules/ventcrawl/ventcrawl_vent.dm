#define SEALING_MATERIAL_AMOUNT 4
#define SEALING_TIME 	(40 SECONDS)	//Not a quick process
/obj/machinery/atmospherics/unary/vent
	var/cover_status = VENT_COVER_INTACT
	var/list/eyes
	var/sealing_progress = 0
	var/obj/item/stack/material/sealing_material	//A stack of material that is currently being used to seal this vent, if one exists

	max_health = 100
	resistance = 10

	var/false_positive = 0

/*
	when examining a vent from close by, you can see if there are any necromorphs lurking inside it

	However, you also have a chance to get a false positive result, seeing a necromorph when there isnt one
	If it triggers, a false positive result is locked in for 30 seconds, so you can't just quickly examine twice to know it was fake
*/
/obj/machinery/atmospherics/unary/vent/examine(mob/user)
	. = ..()

	switch (cover_status)
		if (VENT_COVER_SEALED)
			to_chat(user, SPAN_NOTICE("It's been sealed up tight with a metal cover, nothing is getting through there!"))
		if (VENT_COVER_BROKEN)
			to_chat(user, SPAN_NOTICE("It's been smashed open, the hole looks big enough for a human to fit through...."))
	if (get_dist(user, src) <= 4)
		var/message = FALSE
		for (var/mob/living/L in contents)
			if (L.stat != DEAD)	
				message = TRUE
				break
		
		if (!message && ((world.time < false_positive) || prob(2)))
			message = TRUE
			false_positive = world.time += rand(3 SECONDS, 60 SECONDS)//The false positive tag remains for a random amount of time

		if (message)
			to_chat(user, SPAN_DANGER("You saw something moving inside!"))
			for (var/mob/living/L in contents)
				if (L.stat != DEAD)	
					to_chat(L, SPAN_DANGER("You've been spotted by [user], this hiding place isn't safe anymore!"))
					break
	else
		to_chat(user, SPAN_NOTICE("You can't see inside it from here. Maybe if you got closer..."))

	


/obj/machinery/atmospherics/unary/vent/ventcrawl_enter(mob/living/user, atom/oldloc)
	
	//Did we just enter from within a vent network, or from without?
	var/external_entry = !(istype(oldloc, /obj/machinery/atmospherics))
	
	if (external_entry)
		break_cover(user)
		playsound(src, "vent_transfer", VOLUME_MID, TRUE)
	
	//If we entered from a pipe
	//OR if the mob entered through the cover without breaking it (tiny mobs only)
	//Then the mob will attempt to lurk inside this vent
	if (cover_status != VENT_COVER_BROKEN || !external_entry)
		lurk(user)


/obj/machinery/atmospherics/unary/vent/ventcrawl_exit(mob/living/user, atom/target_move)
	if (user && user.eyeobj && (LAZYISIN(user.eyeobj,eyes)))
		eyes -= user.eyeobj
		qdel(user.eyeobj)

	var/external_exit = !(istype(target_move, /obj/machinery/atmospherics))
	if (external_exit)
		playsound(src, "vent_transfer", VOLUME_MID, TRUE)

		//Okay we're flopping out of the vent if the cover is broken
		if (cover_status == VENT_COVER_BROKEN)
			//Mobs which can wallcrawl, and those smaller than medium, are immune
			if (user.mob_size > MOB_SMALL && !get_extension(user, /datum/extension/wallrun))
				user.airflow_stun()
				playsound(user.loc, "punch", VOLUME_MID, TRUE)
		remove_verb(user, /mob/living/carbon/human/proc/burst_out)
	.=..()
	

/*
	Called when something enters from outside, or busts out of this vent
*/
/obj/machinery/atmospherics/unary/vent/proc/break_cover(mob/living/user)

	//Already broken
	if (cover_status == VENT_COVER_BROKEN)
		return

	//Especially tiny mobs don't break the cover, they can slip through the grating
	if (user && user.mob_size <= MOB_TINY)
		return

	health = 1

	playsound(src, "vent_break", VOLUME_HIGH, TRUE)
	visible_message("The cover on the [src] breaks open")
	shake_animation()
	cover_status = VENT_COVER_BROKEN
	welded = FALSE
	update_icon()
	
/*
	Only used if you find some way to repair a broken vent, like a repair kit
*/
/obj/machinery/atmospherics/unary/vent/proc/fix_cover(mob/living/user)
	if (cover_status != VENT_COVER_BROKEN)
		return

	cover_status = VENT_COVER_INTACT
	update_icon()


/* 
	The user will attempt to lurk inside this vent
	If there's no cover, this will fail and they'll get ejected instead
	If the cover isnt sealed, they will have vision around the vent

	Note that the mob is already physically present in the vent when this is called, so we don't have to move them in, here
*/
/obj/machinery/atmospherics/unary/vent/proc/lurk(mob/living/user)   
	//Woops, no cover, you fall out
	if (cover_status == VENT_COVER_BROKEN)
		return ventcrawl_exit(user, get_turf(src))

	//They can hide inside the vent but also look out
	else if (cover_status == VENT_COVER_INTACT)
		create_vent_eye(user)
		



//Create an eye mob that allows the mob to see things outside the vent
/obj/machinery/atmospherics/unary/vent/proc/create_vent_eye(mob/living/user)
	if (!user || user.eyeobj)
		return

	var/mob/dead/observer/eye/vent/EV = new /mob/dead/observer/eye/vent(loc)
	EV.associated_vent = src
	EV.possess(user)

	user.set_fullscreen(FALSE, "vent", /atom/movable/screen/fullscreen/ventcrawl)
	user.set_sight(SEE_SELF)

	LAZYDISTINCTADD(eyes, EV)

//Doubleclicking the vent you're in bursts out of it
//Otherwise it tries to crawl in 
/obj/machinery/atmospherics/unary/vent/DblClick(var/location, var/control, var/params)
	if (ishuman(usr) && usr.loc == src)
		var/mob/living/carbon/human/H = usr
		H.burst_out()
	else if (isliving(usr) && get_dist(usr, src) < 2)
		var/mob/living/L = usr
		L.ventcrawl()
	.=..()







/obj/machinery/atmospherics/unary/vent/attackby(obj/item/A, mob/user)
	. = ..()
	if (isWelder(A) || istype(A, /obj/item/weapon/gun/projectile/rivet))
		attempt_seal(A, user)

/*
	Vent Sealing
	Requires metal sheets nearby, and the use of some tool, a welder or rivet gun
*/
/obj/machinery/atmospherics/unary/vent/proc/attempt_seal(obj/item/A, mob/user)
	if (cover_status == VENT_COVER_SEALED)
		to_chat(user, SPAN_WARNING("This vent is already sealed, there's nothing farther you can do here!"))
		return

	//Possible todo: Check user is in range?

	//Okay lets find metal
	if (!find_metal(user))
		to_chat(user, SPAN_WARNING("You'll need [SEALING_MATERIAL_AMOUNT] sheets of metal to seal this vent!"))
		return

	var/time_required = SEALING_TIME * (1 - sealing_progress)

	var/complete = FALSE
	if (isWelder(A))
		var/obj/item/weapon/tool/T = A
		if (T.use_tool_extended(user = user, target = src, base_time = time_required, required_quality = QUALITY_WELDING, fail_chance = 0, progress_proc = CALLBACK(src, /obj/machinery/atmospherics/unary/vent/proc/vent_work_tick, A)))
			complete = TRUE

	if (istype(A, /obj/item/weapon/gun/projectile/rivet))
		if (do_after(user = user, target = src, delay = time_required, proc_to_call = CALLBACK(src, /obj/machinery/atmospherics/unary/vent/proc/vent_work_tick, A)))
			complete = TRUE
	
	if (complete)
		seal()

/obj/machinery/atmospherics/unary/vent/proc/seal()
	cover_status = VENT_COVER_SEALED
	welded = TRUE
	health = max_health
	update_icon()

//Tick up the progress meter
/obj/machinery/atmospherics/unary/vent/proc/vent_work_tick(var/A)
	sealing_progress += (10 / SEALING_TIME) //Tick this up gradually

	if (istype(A, /obj/item/weapon/gun/projectile/rivet))
		
		//Need to make sure it has rivets left or we can't continue
		var/obj/item/weapon/gun/projectile/rivet/R = A
		var/obj/item/ammo_magazine/rivet/AMR = R.ammo_magazine
		if (!AMR || !length(AMR.stored_ammo))
			to_chat(usr, SPAN_DANGER("Your gun has run out of rivets!"))
			return CANCEL

		//Use up one rivet every 10 ticks or so
		if (prob(10))
			var/obj/item/ammo_casing/C = AMR.stored_ammo[AMR.stored_ammo.len]
			AMR.stored_ammo-=C
			QDEL_NULL(C)

		//Play a sound roughly every 2.5 seconds
		if (prob(40))
			playsound(src, pick(list('sound/weapons/guns/rivet1.ogg','sound/weapons/guns/rivet2.ogg','sound/weapons/guns/rivet3.ogg')), VOLUME_MID, TRUE)


/*
	This proc attempts to find some suitable metal sheets for sealing this vent.
	It can search anywhere on turfs within 1 radius, and also in the inventory of the specified user
*/
/obj/machinery/atmospherics/unary/vent/proc/find_metal(var/mob/user)
	if (sealing_material && sealing_material.loc == src && sealing_material.amount >= SEALING_MATERIAL_AMOUNT)
		//The metal is already inside us, we must be resuming a half-finished sealing operation
		return TRUE

	sealing_material = null
	//Okay lets get a list of all the stuff
	var/list/stuff = range(1, src)
	stuff += user.get_inventory()

	for (var/obj/item/stack/material/M in stuff)
		//Steel and plasteel are both useable
		if (istype(M, /obj/item/stack/material/steel) || istype(M, /obj/item/stack/material/plasteel))
			if (M.amount >= SEALING_MATERIAL_AMOUNT)
				//We have found a suitable stack, lets take some sheets off it
				sealing_material = M.split(SEALING_MATERIAL_AMOUNT)
				sealing_material.forceMove(src)
				return TRUE
	return FALSE








	/*
		Damage procs
	*/
	//Called when a structure takes damage
/obj/machinery/atmospherics/unary/vent/proc/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist = FALSE)
	if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
		return
	if (!bypass_resist)
		amount -= resistance

	if (amount <= 0)
		return 0

	health -= amount

	if (health <= 0)
		health = 0
		return zero_health(amount, damtype, user, used_weapon, bypass_resist)//Some zero health overrides do things with a return value
	else
		update_icon()
		return amount

/obj/machinery/atmospherics/unary/vent/proc/updatehealth()
	if (health <= 0)
		health = 0
		return zero_health()
	
	if (health >= max_health)
		fix_cover()

//Called when health drops to zero. Parameters are the params of the final hit that broke us, if this was called from take_damage
/obj/machinery/atmospherics/unary/vent/proc/zero_health(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist)
	break_cover()
	return TRUE

/obj/machinery/atmospherics/unary/vent/repair(var/repair_power, var/datum/repair_source, var/mob/user)
	health = clamp(health+repair_power, 0, max_health)
	updatehealth()
	update_icon()

/obj/machinery/atmospherics/unary/vent/repair_needed()
	return max_health - health
