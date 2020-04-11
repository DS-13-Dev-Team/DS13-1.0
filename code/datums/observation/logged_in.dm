//	Observer Pattern Implementation: Logged in
//		Registration type: /datum
//
//		Raised when: A mob, or player logs in
//
//		Arguments that the called proc should expect:
//			/datum/joiner: The thing that has logged in

GLOBAL_DATUM_INIT(logged_in_event, /decl/observ/logged_in, new)

/decl/observ/logged_in
	name = "Logged In"
	expected_type = /mob

/*****************
* Login Handling *
*****************/

/mob/Login()
	..()
	GLOB.logged_in_event.raise_event(src)
