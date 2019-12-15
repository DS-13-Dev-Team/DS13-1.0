//	Observer Pattern Implementation: View changed
//		Registration type: /mob
//
//		Raised when: A mob's view offset or view radius changes.
				//More specifically, when the life tick gets around to calling reset view
//
//		Arguments that the called proc should expect:
//			/mob/viewer:  The mob whose view changed


GLOBAL_DATUM_INIT(view_changed_event,/decl/observ/view_changed, new)

/decl/observ/view_changed
	name = "View Changed"
	expected_type = /mob


