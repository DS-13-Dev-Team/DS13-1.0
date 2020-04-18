///This file is for procs which find atoms in the world near other atoms. View, range, etc
//I got sick of these being scattered far and wide

//Mob

/atom/proc/atoms_in_view(var/check_range = world.view)
	return dview(check_range, get_turf(src))

/mob/atoms_in_view(var/check_range = null)

	var/list/things
	if (!view_offset)
		things = hear((check_range? check_range : view_range), src)
	else
		//View offset makes things much more complex

		var/turf/origin = get_view_centre()
		things = dview((check_range? check_range : view_range), origin, see_invisible)

	return things

//Returns a list of all turfs this mob can see, accounting for view radius and offset
/atom/proc/turfs_in_view(var/check_range = world.view)
	var/list/things = atoms_in_view(check_range)
	for (var/a in things)
		if (!isturf(a))
			things.Remove(a)

	return things

//As above, but specifically finds turfs without dense objects blocking them
/atom/proc/clear_turfs_in_view(var/check_range = world.view)
	var/list/things = atoms_in_view(check_range)
	for (var/a in things)
		if (!isturf(a))
			things.Remove(a)
			continue

		if (!turf_clear(a))
			things.Remove(a)

	return things

/mob/turfs_in_view(var/check_range = null)
	.=..()

/mob/clear_turfs_in_view(var/check_range = null)

//Generic

// Returns a list of mobs and/or objects in range of R from source. Used in radio and say code.

/proc/get_mobs_or_objects_in_view(var/R, var/atom/source, var/include_mobs = 1, var/include_objects = 1)

	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/I in range)
		if(ismob(I))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_mobs)
				var/mob/M = I
				if(M.client)
					hear += M
		else if(istype(I,/obj/))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_objects)
				hear += I

	return hear


/proc/get_mobs_in_radio_ranges(var/list/obj/item/device/radio/radios)

	set background = 1

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/obj/item/device/radio/R in radios)
		if(R)
			//Cyborg checks. Receiving message uses a bit of cyborg's charge.
			var/obj/item/device/radio/borg/BR = R
			if(istype(BR) && BR.myborg)
				var/mob/living/silicon/robot/borg = BR.myborg
				var/datum/robot_component/CO = borg.get_component("radio")
				if(!CO)
					continue //No radio component (Shouldn't happen)
				if(!borg.is_component_functioning("radio") || !borg.cell_use_power(CO.active_usage))
					continue //No power.

			var/turf/speaker = get_turf(R)
			if(speaker)
				for(var/turf/T in hear(R.canhear_range,speaker))
					speaker_coverage[T] = T


	// Try to find all the players who can hear the message
	for(var/i = 1; i <= GLOB.player_list.len; i++)
		var/mob/M = GLOB.player_list[i]
		if(M)
			var/turf/ear = get_turf(M)
			if(ear)
				// Ghostship is magic: Ghosts can hear radio chatter from anywhere
				if(speaker_coverage[ear] || (isghost(M) && M.get_preference_value(/datum/client_preference/ghost_radio) == GLOB.PREF_ALL_CHATTER))
					. |= M		// Since we're already looping through mobs, why bother using |= ? This only slows things down.
	return .

/proc/get_mobs_and_objs_in_view_fast(var/turf/T, var/range, var/list/mobs, var/list/objs, var/checkghosts = null)

	var/list/hear = dview(range,T,INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()

	for(var/atom/movable/AM in hear)
		if(ismob(AM))
			mobs += AM
			hearturfs += get_turf(AM)
		else if(isobj(AM))
			objs += AM
			hearturfs += get_turf(AM)

	for(var/mob/M in GLOB.player_list)
		if(checkghosts && M.stat == DEAD && M.get_preference_value(checkghosts) != GLOB.PREF_NEARBY)
			mobs |= M
		else if(get_turf(M) in hearturfs)
			mobs |= M

	for(var/obj/O in GLOB.listening_objects)
		if(get_turf(O) in hearturfs)
			objs |= O





#define SIGN(X) ((X<0)?-1:1)

proc/isInSight(var/atom/A, var/atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfSight(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return 1

	else
		return 0

proc
	inLineOfSight(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
		var/turf/T
		if(X1==X2)
			if(Y1==Y2)
				return 1 //Light cannot be blocked on same tile
			else
				var/s = SIGN(Y2-Y1)
				Y1+=s
				while(Y1!=Y2)
					T=locate(X1,Y1,Z)
					if(T.opacity)
						return 0
					Y1+=s
		else
			var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
			var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
			var/signX = SIGN(X2-X1)
			var/signY = SIGN(Y2-Y1)
			if(X1<X2)
				b+=m
			while(X1!=X2 || Y1!=Y2)
				if(round(m*X1+b-Y1))
					Y1+=signY //Line exits tile vertically
				else
					X1+=signX //Line exits tile horizontally
				T=locate(X1,Y1,Z)
				if(T.opacity)
					return 0
		return 1
#undef SIGN


/proc/able_mobs_in_oview(var/origin)
	var/list/mobs = list()
	for(var/mob/living/M in oview(origin)) // Only living mobs are considered able.
		if(!M.is_physically_disabled())
			mobs += M
	return mobs



/proc/circlerange(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/atoms = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/A in view(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			atoms += A

	//turfs += centerturf
	return atoms

/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)

/proc/get_dist_euclidian(atom/Loc1 as turf|mob|obj,atom/Loc2 as turf|mob|obj)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx**2 + dy**2)


	return dist

/proc/get_dist_3D(var/atom/A, var/atom/B)
	var/dist = get_dist_euclidian(A, B)

	//If on different zlevels, we do some extra math
	if (A.z != B.z)
		dist = sqrt(dist**2 + ((A.z - B.z)*CELL_HEIGHT)**2)

	return dist

/proc/circlerangeturfs(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs

/proc/circleviewturfs(center=usr,radius=3)		//Is there even a diffrence between this proc and circlerangeturfs()?

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs


/*A complicated proc!
/This attempts to find something meeting a variety of conditions. Vars:
	Origin: Where we start looking. Search around origin
	Radius: How far out to look?
	Valid Types:	A list of various typepaths which are valid
	Allied:	A list. First value contains a mob to compare with, second value must be true or false. An atom is only considered valid if it gets a matching result for is_allied
	Visualnet:	If not null, a qualifying atom must be located on a turf which is seen by this visualnet
	Corruption:	If true, qualifying atom must be, or be on, a corrupted tile
	View:	If true, limit the searching to turfs in view of origin. When false, searches in a range
	LOS Block:	If true, blocked by live crew seeing
	Num:	How many targets to find? We'll keep searching til we get this many or have examined every turf's contents. Any false value counts as infinity, search everything
	Special Check: A callback for additional specific checks
	Error User:	A user to show failure messages to, if we fail
*/
/proc/get_valid_target(var/atom/origin, var/radius, var/list/valid_types = list(/turf), var/list/allied = null, var/datum/visualnet/visualnet = null, var/require_corruption = FALSE, var/view_limit = FALSE, var/LOS_block = FALSE, var/num_required = 1, var/datum/callback/special_check = null, var/mob/error_user)
	var/list/results = list()
	var/list/haystack
	if (view_limit)
		haystack = origin.atoms_in_view(radius)
	else
		haystack = range(radius, origin)

	//Possible future todo: Optimise haystack selection based on valid types

	//In the case of LOS block, a list of mobs that see us. used only to give messages to players
	var/list/viewers = list()


	//Okay now we have our list to search through

	for (var/atom/A as anything in haystack)

		//Check if it matches one of our required types
		var/typematch = FALSE
		for (var/v in valid_types)
			if (istype(A, v))
				typematch = TRUE
				break

		if (!typematch)
			continue	//If not, abort



		//Special check is a callback that can be passed in, to do fancy things
		if (special_check)
			if (special_check.Invoke(A) != TRUE)
				continue

		var/turf/T = get_turf(A)
		if (require_corruption)
			if (!turf_corrupted(T))
				continue

		if (visualnet)
			if (!T.is_in_visualnet(visualnet))
				continue

		if (allied)
			var/mob/user = allied[1]
			if ((user.is_allied(A) != allied[2]))
				continue

		if (LOS_block)
			var/mob/M = T.is_seen_by_crew()
			if (M)
				viewers |= M
				continue


		//If we get here, then the item is valid. Add it to our results list
		results += A

		//If we've set a defined target of results, and now meet or exceed that target, then break out and return
		if (num_required && results.len >= num_required)
			break


	//In the case we failed to find any/enough targets, lets try to explain to the user why
	if (error_user && results.len < num_required)
		if (viewers.len)
			to_chat(error_user, SPAN_WARNING("Casting here is blocked because the tile is seen by [english_list(viewers)]"))


	return results


/atom/proc/get_cardinal()
	.=list()
	for (var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		.+=T