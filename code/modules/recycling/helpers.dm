//Called when the user attempts to put this atom into disposal D
//Return false to prevent it from going in
/atom/proc/attempt_dispose(var/obj/machinery/disposal/D, var/mob/user)
	return TRUE


//Trashbag is emptied in, but doesnt go in itself
/obj/item/weapon/storage/bag/trash/attempt_dispose(var/obj/machinery/disposal/D, var/mob/user)
	to_chat(user, "<span class='notice'>You empty the bag.</span>")
	for(var/obj/item/O in contents)
		if (O.attempt_dispose(D, user))
			remove_from_storage(O,D)
	D.update_icon()
	return FALSE