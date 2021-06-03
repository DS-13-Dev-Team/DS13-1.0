/*
CONTAINS:

Deployable items
Barricades

for reference:

	access_security = 1
	access_security = 2
	access_armory = 3
	access_security= 4
	access_medical = 5
	access_morgue = 6
	access_research = 7
	access_research_storage = 8
	access_genetics = 9
	access_engineering = 10
	access_engineering= 11
	access_maint_tunnels = 12
	access_external_airlocks = 13
	access_emergency_storage = 14
	access_change_ids = 15
	access_bridge = 16
	access_teleporter = 17
	access_eva = 18
	access_bridge = 19
	access_captain = 20
	access_all_personal_lockers = 21
	access_chapel_office = 22
	access_tech_storage = 23
	access_engineering = 24
	access_service = 25
	access_janitor = 26
	access_crematorium = 27
	access_service = 28
	access_research = 29
	access_rd = 30
	access_cargo = 31
	access_engineering = 32
	access_chemistry = 33
	access_cargo_bot = 34
	access_service = 35
	access_manufacturing = 36
	access_library = 37
	access_security = 38
	access_medical = 39
	access_cmo = 40
	access_cargo = 41
	access_court = 42
	access_clown = 43
	access_mime = 44

*/



//Actual Deployable machinery stuff
/obj/machinery/deployable
	name = "deployable"
	desc = "Deployable."
	icon = 'icons/obj/objects.dmi'
	req_access = list(access_security)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = 0.0
	density = 1
	icon_state = "barrier0"
	max_health = 100
	health = 100
	resistance = 5
	var/locked = 0.0
//	req_access = list(access_maint_tunnels)

	New()
		..()

		src.icon_state = "barrier[src.locked]"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/card/id/))
			if (src.allowed(user))
				if	(src.emagged < 2.0)
					src.locked = !src.locked
					src.anchored = !src.anchored
					src.icon_state = "barrier[src.locked]"
					if ((src.locked == 1.0) && (src.emagged < 2.0))
						to_chat(user, "Barrier lock toggled on.")
						return
					else if ((src.locked == 0.0) && (src.emagged < 2.0))
						to_chat(user, "Barrier lock toggled off.")
						return
				else
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(2, 1, src)
					s.start()
					visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
					return
			return
		else if(isWrench(W))
			if (src.health < src.max_health)
				src.health = src.max_health
				src.emagged = 0
				src.req_access = list(access_security)
				visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
				return
			else if (src.emagged > 0)
				src.emagged = 0
				src.req_access = list(access_security)
				visible_message("<span class='warning'>[user] repairs \the [src]!</span>")
				return
			return
		else
			take_damage(W.force * 0.75)
			..()

	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			return
		if(prob(50/severity))
			locked = !locked
			anchored = !anchored
			icon_state = "barrier[src.locked]"

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
		if(air_group || (height==0))
			return 1
		if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
			return 1
		else
			return 0

	proc/explode()

		visible_message("<span class='danger'>[src] blows apart!</span>")
		var/turf/Tsec = get_turf(src)
		new /obj/item/stack/rods(Tsec)

		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

		explosion(4, 2)
		if(src)
			qdel(src)


/obj/machinery/deployable/barrier/emag_act(var/remaining_charges, var/mob/user)
	if (src.emagged == 0)
		src.emagged = 1
		src.req_access.Cut()
		src.req_one_access.Cut()
		to_chat(user, "You break the ID authentication lock on \the [src].")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1
	else if (src.emagged == 1)
		src.emagged = 2
		to_chat(user, "You short out the anchoring mechanism on \the [src].")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		visible_message("<span class='warning'>BZZzZZzZZzZT</span>")
		return 1








/*
	Damage Mechanics

	One day we will extend these to all machinery, then all objects, then all atoms
	But the unintended consequences of that are, for now, too much to deal with
*/
/obj/machinery/deployable/proc/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist = FALSE)
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

/obj/machinery/deployable/proc/updatehealth()
	if (health <= 0)
		health = 0
		return zero_health()

//Called when health drops to zero. Parameters are the params of the final hit that broke us, if this was called from take_damage
/obj/machinery/deployable/barrier/zero_health(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist)
	explode()
	return TRUE


/obj/machinery/deployable/proc/zero_health(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist)
	qdel(src)
	return TRUE

/obj/machinery/deployable/repair(var/repair_power, var/datum/repair_source, var/mob/user)
	health = clamp(health+repair_power, 0, max_health)
	updatehealth()
	update_icon()

/obj/machinery/deployable/repair_needed()
	return max_health - health


/obj/machinery/deployable/attack_hand(mob/user)
	if(user.a_intent == I_HURT)
		user.strike_structure(src)
		return 1
	return ..()

//Future TODO: Make this generic atom behaviour
/obj/machinery/deployable/fire_act(var/datum/gas_mixture/air, var/exposed_temperature, var/exposed_volume, var/multiplier = 1)
	var/damage = get_fire_damage(exposed_temperature, multiplier)
	if (damage > 0)
		take_damage(damage, BURN,bypass_resist = TRUE)


//Most structures are stee
/obj/machinery/deployable/get_heat_limit()
	return 1370
