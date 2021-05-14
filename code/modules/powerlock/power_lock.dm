/obj/power_lock
	var/datum/node_room/NR
	var/nodes_collected = 0
	desc = "A security system which requires power nodes to open."
	//Temporary
	icon = 'icons/obj/powerlock.dmi'
	icon_state = "powerlock1"
	pixel_y = 5

/obj/power_lock/New(var/atom/location)
	.=..()

	set_light(1, 1, 3, 2.5, COLOR_DEEP_SKY_BLUE)

/obj/power_lock/examine(var/mob/user)
	.=..()
	user << "This lock has [nodes_collected] / [NR ? NR.difficulty : "1"] power nodes slotted in."

/obj/power_lock/attackby(obj/item/I, mob/user)

	if (istype(I, /obj/item/stack/power_node))
		if (already_completed(user))
			return

		var/obj/item/stack/power_node/PN = I
		PN.use(1)
		playsound(src, "button", VOLUME_MID)
		nodes_collected++
		update_icon()
		check_completion()

/obj/power_lock/update_icon()
	icon_state = "powerlock[NR ? NR.difficulty : "1"]"
	if (nodes_collected)
		overlays = list()
		for (var/i in 1 to nodes_collected)
			overlays += "powerlock[i]_on"


/obj/power_lock/proc/already_completed(var/mob/user)
	if (NR && !NR.opened)
		return FALSE

	else
		to_chat(user, "This lock is already open, no farther nodes are needed.")
		return TRUE


/obj/power_lock/proc/check_completion()
	if (nodes_collected >= NR.difficulty)
		NR.open()