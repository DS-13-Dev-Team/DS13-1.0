/obj/power_lock
	var/datum/node_room/NR
	var/nodes_collected = 0
	plane = ABOVE_OBJ_PLANE

	//Temporary
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"

/obj/power_lock/New(var/atom/location)
	.=..()

	set_light(1, 1, 3, 2.5, COLOR_DEEP_SKY_BLUE)


/obj/power_lock/attackby(obj/item/I, mob/user)
	if (istype(I, /obj/item/stack/power_node))

		if (already_completed(user))
			return

		var/obj/item/stack/power_node/PN = I
		PN.use(1)
		nodes_collected++
		update_icon()
		check_completion()



/obj/power_lock/proc/already_completed(var/mob/user)
	if (NR && !NR.opened)
		return FALSE

	else
		to_chat(user, "This lock is already open, no farther nodes are needed.")
		return TRUE


/obj/power_lock/proc/check_completion()
	if (nodes_collected >= NR.difficulty)
		NR.open()