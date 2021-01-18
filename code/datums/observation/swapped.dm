//	Observer Pattern Implementation: Swapped To
//		Registration type: /obj/item
//
//		Raised when: The obj/item instance has been swapped to by a mob.
//
//		Arguments that the called proc should expect:
//			/obj/item/swapped: The item being swapped to.
//			/mob/swapper: The mob who swapped to the item.
//

GLOBAL_DATUM_INIT(swapped_to_event, /decl/observ/swapped_to, new)

/decl/observ/swapped_to
	name = "Swapped To"
	expected_type = /obj/item

//	Observer Pattern Implementation: Swapped From
//		Registration type: /obj/item
//
//		Raised when: The obj/item instance has been swapped away from by a mob.
//
//		Arguments that the called proc should expect:
//			/obj/item/swapped: The item being swapped away from.
//			/mob/swapper: The mob who swapped away from the item.
//

GLOBAL_DATUM_INIT(swapped_from_event, /decl/observ/swapped_from, new)

/decl/observ/swapped_from
	name = "Swapped From"
	expected_type = /obj/item

