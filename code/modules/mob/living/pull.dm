/*
	This file contains all functionality related to pulling, collated from across the codebase
*/

/*
	Mob Procs: Core
*/
/mob
	var/reach = 1

/mob/proc/pulling_moved()
	if(!pulling.mid_diag_move)
		update_pulling()



/mob/living/proc/handle_pulling_after_move(turf/old_loc)
	if(!pulling)
		return

	if(get_dist(src, pulling) > reach+1)
		stop_pulling()
		return

	if (isliving(pulling))
		var/mob/living/M = pulling
		if(M.grabbed_by.len)
			if (prob(75))
				var/obj/item/grab/G = pick(M.grabbed_by)
				if(istype(G))
					M.visible_message(SPAN_WARNING("[G.affecting] has been pulled from [G.assailant]'s grip by [src]!"), SPAN_WARNING("[G.affecting] has been pulled from your grip by [src]!"))
					qdel(G)
		if (!M.grabbed_by.len)
			M.handle_pull_damage(src)


	step(pulling, get_dir(pulling.loc, old_loc))



	if(!can_pull(pulling) || get_dist(src, pulling) > reach)
		stop_pulling()
		return

/mob/living/proc/handle_pull_damage(mob/living/puller)
	var/area/A = get_area(src)
	if(!A.has_gravity)
		return
	var/turf/location = get_turf(src)
	if(lying && prob(getBruteLoss() / 6))
		location.add_blood(src)
		if(prob(25))
			src.adjustBruteLoss(1)
			visible_message("<span class='danger'>\The [src]'s [src.isSynthetic() ? "state worsens": "wounds open more"] from being dragged!</span>")
			. = TRUE
	if(src.pull_damage())
		if(prob(25))
			src.adjustBruteLoss(2)
			visible_message("<span class='danger'>\The [src]'s [src.isSynthetic() ? "state" : "wounds"] worsen terribly from being dragged!</span>")
			location.add_blood(src)
			. = TRUE






/*
	Mob Procs: Checks
*/
/mob/proc/update_pulling()
	return TRUE

/mob/living/update_pulling()
	.=FALSE
	if(pulling)
		var/atom/movable/AM = pulling
		if(incapacitated(INCAPACITATION_NOINTERACT))
			stop_pulling()
			return

		else if (!istype(AM.loc, /turf))
			stop_pulling()
			return

		if (get_dist(src, pulling) > reach)
			stop_pulling()
			return

	return TRUE






/*
	Mob Procs: Start and Stop
*/
/mob/verb/stop_pulling()
	set name = "Stop Pulling"
	set category = "IC"
	if(pulling)
		GLOB.moved_event.unregister(pulling, src, /mob/proc/pulling_moved)
		pulling.pulledby = null
		pulling = null
		if(pullin)
			pullin.icon_state = "pull0"

/mob/proc/can_pull(var/atom/movable/AM)
	.=FALSE
	if ( !AM || src==AM || !isturf(src.loc) )	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if (AM.anchored)
		to_chat(src, "<span class='warning'>It won't budge!</span>")
		return

	var/mob/M = AM
	if(ismob(AM))

		if(!can_pull_mobs || !can_pull_size)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		if((mob_size < M.mob_size) && (can_pull_mobs != MOB_PULL_LARGER))
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		if((mob_size == M.mob_size) && (can_pull_mobs == MOB_PULL_SMALLER))
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

		// If your size is larger than theirs and you have some
		// kind of mob pull value AT ALL, you will be able to pull
		// them, so don't bother checking that explicitly.

		if(!iscarbon(src))
			M.LAssailant = null
		else
			M.LAssailant = usr

	else if(isobj(AM))
		var/obj/I = AM
		if(!can_pull_size || can_pull_size < I.w_class)
			to_chat(src, "<span class='warning'>It won't budge!</span>")
			return

	return TRUE


/mob/proc/start_pulling(var/atom/movable/AM)
	if (!usr || !can_pull(AM))	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return

	if(pulling)
		var/pulling_old = pulling
		stop_pulling()
		// Are we pulling the same thing twice? Just stop pulling.
		if(pulling_old == AM)
			return

	src.pulling = AM
	AM.pulledby = src

	if(pullin)
		pullin.icon_state = "pull1"

	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.pull_damage())
			to_chat(src, "<span class='danger'>Pulling \the [H] in their current condition would probably be a bad idea.</span>")

	GLOB.moved_event.register(AM, src, /mob/proc/pulling_moved)

	//Attempted fix for people flying away through space when cuffed and dragged.
	if(ismob(AM))
		var/mob/pulled = AM
		pulled.inertia_dir = 0





//mob verbs are faster than object verbs. See mob/verb/examine.
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = "Object"

	if(AM.Adjacent(src))
		src.start_pulling(AM)

	return


/*
	Interaction
*/
/turf/attack_hand(mob/user)
	user.set_click_cooldown(DEFAULT_QUICK_COOLDOWN)

	if(user.restrained())
		return 0
	if(isnull(user.pulling) || user.pulling.anchored || !isturf(user.pulling.loc))
		return 0
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > user.reach)
		return 0
	if(user.pulling)
		do_pull_click(user, src)
	return 1



/*
	Client Procs
*/
//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	set hidden = 1

	if(!usr.pulling)
		to_chat(usr, "<span class='notice'>You are not pulling anything.</span>")
		return
	usr.stop_pulling()