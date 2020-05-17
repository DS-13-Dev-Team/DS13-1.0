/*
Contains helper procs for airflow, handled in /connection_group.
*/

mob/var/tmp/last_airflow_stun = 0
mob/proc/airflow_stun()
	if(stat == 2)
		return FALSE
	if(last_airflow_stun > world.time - vsc.airflow_stun_cooldown)	return FALSE

	if(!(status_flags & CANSTUN) && !(status_flags & CANWEAKEN))
		to_chat(src, "<span class='notice'>You stay upright as the air rushes past you.</span>")
		return FALSE
	if(buckled)
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return FALSE
	if(!lying)
		to_chat(src, "<span class='warning'>The sudden rush of air knocks you over!</span>")
	Weaken(4)
	last_airflow_stun = world.time

mob/living/silicon/airflow_stun()
	return

mob/living/carbon/slime/airflow_stun()
	return

mob/living/carbon/human/airflow_stun()
	if(!slip_chance())
		to_chat(src, "<span class='notice'>Air suddenly rushes past you!</span>")
		return FALSE
	..()

atom/movable/proc/check_airflow_movable(n)

	if(anchored && !ismob(src)) return FALSE

	if(!isobj(src) && n < vsc.airflow_dense_pressure) return FALSE

	return TRUE

mob/check_airflow_movable(n)
	if(n < vsc.airflow_heavy_pressure)
		return FALSE
	else if (mob_size >= MOB_LARGE && n < vsc.airflow_extreme_pressure)
		return FALSE

	return TRUE

mob/living/silicon/check_airflow_movable()
	return FALSE


obj/check_airflow_movable(n)
	if(isnull(w_class))
		if(n < vsc.airflow_dense_pressure) return FALSE //most non-item objs don't have a w_class yet
	else
		switch(w_class)
			if(1,2)
				if(n < vsc.airflow_lightest_pressure) return FALSE
			if(3)
				if(n < vsc.airflow_light_pressure) return FALSE
			if(4,5)
				if(n < vsc.airflow_medium_pressure) return FALSE
			if(6)
				if(n < vsc.airflow_heavy_pressure) return FALSE
			if(7 to INFINITY)
				if(n < vsc.airflow_dense_pressure) return FALSE
	return ..()


/atom/movable/var/tmp/turf/airflow_dest
/atom/movable/var/tmp/airflow_speed = 0
/atom/movable/var/tmp/airflow_time = 0
/atom/movable/var/tmp/last_airflow = 0
/atom/movable/var/tmp/airborne_acceleration = 0

/atom/movable/proc/AirflowCanMove(n)
	return TRUE

/mob/AirflowCanMove(n)
	if(status_flags & GODMODE)
		return FALSE
	if(buckled)
		return FALSE
	var/obj/item/shoes = get_equipped_item(slot_shoes)
	if(istype(shoes) && (shoes.item_flags & ITEM_FLAG_NOSLIP))
		return FALSE
	return TRUE

/atom/movable/Bump(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		if(airborne_acceleration > 1)
			airflow_hit(A)
		else if(istype(src, /mob/living/carbon/human))
			to_chat(src, "<span class='notice'>You are pinned against [A] by airflow!</span>")
			airborne_acceleration = 0
	else
		airflow_speed = 0
		airflow_time = 0
		airborne_acceleration = 0
		. = ..()

atom/movable/proc/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null
	airborne_acceleration = 0

mob/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message("<span class='danger'>\The [src] slams into \a [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "smash.ogg", 25, 1, -1)
	var/weak_amt = istype(A,/obj/item) ? A:w_class : rand(1,5) //Heheheh
	Weaken(weak_amt)
	. = ..()

obj/airflow_hit(atom/A)
	for(var/mob/M in hearers(src))
		M.show_message("<span class='danger'>\The [src] slams into \a [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "smash.ogg", 25, 1, -1)
	. = ..()

obj/item/airflow_hit(atom/A)
	airflow_speed = 0
	airflow_dest = null

mob/living/carbon/human/airflow_hit(atom/A)
//	for(var/mob/M in hearers(src))
//		M.show_message("<span class='danger'>[src] slams into [A]!</span>",1,"<span class='danger'>You hear a loud slam!</span>",2)
	playsound(src.loc, "punch", 25, 1, -1)
	if (prob(33))
		loc:add_blood(src)
		bloody_body(src)
	var/b_loss = min(airflow_speed, (airborne_acceleration*2)) * vsc.airflow_damage

	var/blocked = run_armor_check(BP_HEAD,"melee")
	apply_damage(b_loss/3, BRUTE, BP_HEAD, blocked, 0, "Airflow")

	blocked = run_armor_check(BP_CHEST,"melee")
	apply_damage(b_loss/3, BRUTE, BP_CHEST, blocked, 0, "Airflow")

	blocked = run_armor_check(BP_GROIN,"melee")
	apply_damage(b_loss/3, BRUTE, BP_GROIN, blocked, 0, "Airflow")

	if(airflow_speed > 10)
		Paralyse(round(airflow_speed * vsc.airflow_stun))
		Stun(paralysis + 3)
	else
		Stun(round(airflow_speed * vsc.airflow_stun/2))
	. = ..()

zone/proc/movables()
	. = list()
	for(var/turf/T in contents)
		for(var/atom/movable/A in T)
			if(!A.simulated || A.anchored || istype(A, /obj/effect) || isobserver(A))
				continue
			. += A
