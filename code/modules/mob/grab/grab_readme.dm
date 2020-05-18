/*
There's two parts to the grab system. There's the grab object: /obj/item/grab
and there's the grab datum: /datum/grab.

Each grab datum is a singleton and the system interacts with the rest of the code
base through the grab object. Nothing but the grab object should be reading
from, writing to, or calling the procs of the grab datum. This helps to keep
everything neat and stops undesirable behaviours.

Each type of grab needs a child of the grab datum and a child of the grab
object. The child of each needs to be named with the name of the grab and
the two need the same naming scheme. For example, the main type of grab
used by human is called "normal" as it's the default vanilla grab. The normal
grab has a child of the grab object called /obj/item/grab/normal and it has a child
of the grab datum called /datum/grab/normal.

Each stage of the grab is a child of the grab datum for that grab type. For normal
there's /datum/grab/normal/passive, /datum/grab/normal/aggressive etc. and they
get their general behaviours from their parent /datum/grab/normal.




Codepath:
	When a human clicks another human in grab intent, it calls the grabber's species.attempt_grab. found in species_grab.dm
		This takes grabber, target, and a tag for a type of grab to make, the type is usually left null though
		this calls /mob/living/carbon/human/proc/make_grab()

	make_grab is found in grab_create.dm
	This long function does a ton of checks
		if a tag is passed, it grabs the appropriate grab type from a global list and creates a new instance of it.
		If no tag, then it spawns an instance of the attacker's current_grab_type var. This var is set during set_species at human spawning


	Either way, a grab object is created in the grabber, targeting the victim.
	The new grab sets its name, target organ, etc. but doesn't do much else on its own

	Now the safety checks. If any of these three return false, the grab fails and is qdel'd
	-----------------
	Next up, we run /obj/item/grab/proc/pre_check on the new grab.
	This checks that the target is valid and we have a free hand.

	Next, we run can_grab, This checks that the victim is the correct type, that neither attacker nor victim is anchored
	It checks if the assailant is adjacent to the victim (Possible future todo: Make this a less specific check to see if they're in reach, accounting for longer arms)
	Checks if the assailaint can pull the victim



	----
*/
