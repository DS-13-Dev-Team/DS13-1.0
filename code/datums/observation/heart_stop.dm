//	Observer Pattern Implementation: Heart Stop
//		Registration type: /mob/living/carbon/human
//
//		Raised when: Human heart stops
//
//		Arguments that the called proc should expect:
//			/mob/dead: The mob that was added to the dead_mob_list

GLOBAL_DATUM_INIT(heart_stop_event, /decl/observ/heart_stop, new)

/decl/observ/heart_stop
	name = "Heart Stop"
	expected_type = /mob/living/carbon/human
