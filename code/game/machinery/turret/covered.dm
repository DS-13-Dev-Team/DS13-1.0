/obj/machinery/turret/covered
	var/popdown_time = 1 MINUTE	//This long after our last shooting or target visibility, we will retract
	var/popdown_timer

	var/raised = 0			//if the turret cover is "open" and the turret is raised
	var/raising= 0			//if the turret is currently opening or closing its cover

	var/atom/movable/turret_cover/cover

	density = FALSE	//Can be walked over when its down

/obj/machinery/turret/covered/update_icon()
	if(raised || raising)
		.=..()
	else
		icon_state = "turretCover"

/obj/machinery/turret/covered/take_damage(var/force)
	if(!raised && !raising)
		force = force / 8

	.=..(force)

/obj/machinery/turret/covered/target_lost()
	.=..()
	set_popdown_timer()


/obj/machinery/turret/covered/select_target(var/mob/living/target)
	.=..()
	set_popdown_timer()


/obj/machinery/turret/covered/fire_at(var/mob/living/target)
	.=..()
	if (.)	//Only reset timer if we actually fired
		set_popdown_timer()

/obj/machinery/turret/covered/proc/set_popdown_timer()
	deltimer(popdown_timer)
	popdown_timer = addtimer(CALLBACK(src, /obj/machinery/turret/covered/proc/pop_down), popdown_time, TIMER_STOPPABLE)


/obj/machinery/turret/covered/proc/pop_up()	//pops the turret up
	density = TRUE
	if(disabled || !enabled)
		return
	if(raising || raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raising(raised, 1)
	update_icon()

	cover = new /atom/movable/turret_cover(loc)
	cover.layer = layer + 0.1//Cover goes over us initially
	flick("pop_up", cover)
	sleep(10)
	cover.layer = layer - 0.1 //Then under us once we're open

	set_raised_raising(1, 0)
	update_icon()

/obj/machinery/turret/covered/proc/pop_down()	//pops the turret down
	swivel_to_target(get_step(src, NORTH))	//Face north before we fold down
	sleep(10)
	last_target = null
	if(disabled)
		return
	if(raising || !raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raising(raised, 1)
	update_icon()
	cover.layer = layer + 0.1//Cover goes over us as it closes
	flick("pop_down", cover)
	sleep(10)
	density = FALSE

	set_raised_raising(0, 0)
	update_icon()
	qdel(cover)



/obj/machinery/turret/covered/proc/set_raised_raising(var/raised, var/raising)
	src.raised = raised
	src.raising = raising
	set_density(raised || raising)




/obj/machinery/turret/covered/can_fire()
	.=..()
	if (.)
		if (!raised || raising)
			return FALSE


/obj/machinery/turret/covered/select_target(var/atom/target)
	.=..()
	pop_up()


/obj/machinery/turret/covered/deactivate()
	.=..()
	pop_down()

/atom/movable/turret_cover
	anchored = TRUE
	icon = 'icons/obj/turrets.dmi'
	icon_state = "openTurretCover"

