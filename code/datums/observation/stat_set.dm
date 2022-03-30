/****************
* Stat Handling *
****************/
/mob/living/set_stat(var/new_stat)
	var/old_stat = stat
	. = ..()
	if(stat != old_stat)
		SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, old_stat, new_stat)