//	Observer Pattern Implementation: Bump
//		Registration type: /atom/movable
//
//		Raised when: The atom/movable instance has attempted to enter another turf but has been stopped by an atom
//
//		Arguments that the called proc should expect:
//			/atom/movable/mover: Who was blocked
//			/atom/obstacle: The atom that blocked us
//

GLOBAL_DATUM_INIT(bump_event, /decl/observ/bump, new)

/decl/observ/bump
	name = "Bump"
	expected_type = /atom/movable

