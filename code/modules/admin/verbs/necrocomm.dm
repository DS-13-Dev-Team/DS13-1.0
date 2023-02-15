/client/proc/toggle_recieve_necrochat()
	set category = "Admin"
	set name = "Toggle Reciving Necrochat"

	holder.recieve_necro_comm = !holder.recieve_necro_comm
	if(holder.recieve_necro_comm)
		to_chat(src, "You will recive necromorph communications now.")
	else
		to_chat(src, "You will not recive necromorph communications now.")
