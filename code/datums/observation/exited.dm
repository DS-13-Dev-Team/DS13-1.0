//	Observer Pattern Implementation: Exited
//		Registration type: /atom
//
//		Raised when: An /atom/movable instance has exited the event source.
//
//		Arguments that the called proc should expect:
//			/atom/exited: The atom that was exited from (this will be the event source)
//			/atom/movable/exiter: The instance that exited the atom
//			/atom/new_loc: The atom the exiter is now residing in
//	(var/atom/exited, var/atom/movable/exiter, var/atom/new_loc)

GLOBAL_DATUM_INIT(exited_event, /decl/observ/exited, new)

/decl/observ/exited
	name = "Exited"
	expected_type = /atom

/******************
* Exited Handling *
******************/

/atom/Exited(atom/movable/exiter, atom/new_loc)
	. = ..()
	RAISE_EVENT(src, exited_event, exiter, new_loc)
