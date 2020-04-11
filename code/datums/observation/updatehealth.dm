//	Observer Pattern Implementation: Update Health
//		Registration type: /mob/living
//
//		Raised when: The mob calls updatehealth. Note that this has been carefully designed to only call when health changes,
//	so you can reasonably assume that health has increased or decreased. Which and how much is for you to determine
//
//		Arguments that the called proc should expect:
//			/mob/living/user:	Whose health was updated
//

GLOBAL_DATUM_INIT(updatehealth_event, /decl/observ/updatehealth, new)

/decl/observ/updatehealth
	name = "Update Health"
	expected_type = /mob/living

