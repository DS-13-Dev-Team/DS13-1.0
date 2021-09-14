/mob/dead/observer/eye/cult
	name = "Mask of God"
	desc = "A terrible fracture of reality coinciding into a mirror to another world."

/mob/dead/observer/eye/cult/New()
	..()
	visualnet = new /datum/visualnet/cultnet()

/mob/dead/observer/eye/cult/Destroy()
	QDEL_NULL(visualnet)
	return ..()

mob/dead/observer/eye/cult/EyeMove()
	if(owner && istype(owner, /mob/living/deity))
		var/mob/living/deity/D = owner
		if(D.following)
			D.stop_follow()
	return ..()
