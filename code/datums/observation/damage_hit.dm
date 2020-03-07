//	Observer Pattern Implementation: Damage Hit
//		Registration type: /mob/living
//
//		Raised when: The mob takes external damage from an external source. EG punched, struck with a weapon, bullet, explosion, etc
//			Does not trigger from internal organ damage, or DOT effects like poison
//
//		Arguments that the called proc should expect:
//			/obj/item/organ/external/organ: The bodypart taking the hit, if applicable. Will be null for nonhuman mobs
//			brute:	Brute damage taken
//			burn:	Burn damage taken
//			damage_flags:	Flags of the damage event
//			used_weapon:	What did the damage. Could be a weapon, a projectile, or the attacking mob if it was an unarmed attack
//

GLOBAL_DATUM_INIT(damage_hit_event, /decl/observ/damage_hit, new)

/decl/observ/damage_hit
	name = "Damage Hit"
	expected_type = /mob/living

