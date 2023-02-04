/mob/living/Logout()
	if(ckey)
		GLOB.pcap_graceperiod[ckey] = world.time + 10 MINUTES
	return ..()
