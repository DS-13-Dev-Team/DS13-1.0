/proc/valid_deity_structure_spot(var/type, var/turf/target, var/mob/living/deity/deity, var/mob/living/user)
	var/obj/structure/deity/D = type
	var/flags = initial(D.deity_flags)

	if(flags & DEITY_STRUCTURE_NEAR_IMPORTANT && !deity.near_structure(target))
		if(user)
			to_chat(user, "<span class='warning'>You need to be near \a [deity.get_type_name(/obj/structure/deity/altar)] to build this!</span>")
		return 0

	if(flags & DEITY_STRUCTURE_ALONE)
		for(var/structure in deity.structures)
			if(istype(structure,type) && get_dist(target,structure) <= 3)
				if(user)
					to_chat(user, "<span class='warning'>You are too close to another [deity.get_type_name(type)]!</span>")
				return 0
	return 1

/obj/structure/deity
	icon = 'icons/obj/cult.dmi'
	var/mob/living/deity/linked_god
	health = 10
	hitsound = 'sound/effects/Glasshit.ogg'
	var/power_adjustment = 1 //How much power we get/lose
	var/build_cost = 0 //How much it costs to build this item.
	var/deity_flags = DEITY_STRUCTURE_NEAR_IMPORTANT
	density = 1
	anchored = 1
	icon_state = "tomealtar"
	resistance = 0

/obj/structure/deity/New(var/newloc, var/god)
	..(newloc)
	if(god)
		linked_god = god
		linked_god.form.sync_structure(src)
		linked_god.adjust_source(power_adjustment, src)

/obj/structure/deity/Destroy()
	if(linked_god)
		linked_god.adjust_source(-power_adjustment, src)
		linked_god = null
	return ..()


/obj/structure/deity/zero_health()
	src.visible_message("\The [src] crumbles!")
	qdel(src)



/obj/structure/deity/proc/attack_deity(var/mob/living/deity/deity)
	return