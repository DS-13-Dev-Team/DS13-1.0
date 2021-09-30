//	Observer Pattern Implementation: Sight Set
//		Registration type: /mob
//
//		Raised when: A mob's sight value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its sight set
//			/old_sight: sight before the change
//			/new_sight: sight after the change

GLOBAL_DATUM_INIT(sight_set_event, /decl/observ/sight_set, new)

/decl/observ/sight_set
	name = "Sight Set"
	expected_type = /mob

/*********************
* Sight Set Handling *
*********************/

/mob/proc/set_sight(var/new_sight)
	var/old_sight = sight
	if(old_sight != new_sight)
		sight = new_sight
		RAISE_EVENT(src, sight_set_event, old_sight, new_sight)
