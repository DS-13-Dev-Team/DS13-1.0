/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	hitsound = "swing_hit"
	base_parry_chance = 25	//Melee weapons can be used to parry, though they're far from a match for shields

	var/list/wielded_verbs


/obj/item/weapon/Bump(mob/M as mob)
	spawn(0)
		..()
	return


/obj/item/weapon/equipped(var/mob/user, var/slot)
	.=..()
	if (wielded_verbs)
		if (is_held())
			register_wielded_verbs(user)
		else
			unregister_wielded_verbs(user)


/obj/item/weapon/proc/register_wielded_verbs(var/mob/user)
	user.verbs |= wielded_verbs


/obj/item/weapon/proc/unregister_wielded_verbs(var/mob/user)
	user.verbs -= wielded_verbs