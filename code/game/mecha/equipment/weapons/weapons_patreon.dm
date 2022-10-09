/obj/item/material/sword/muramasa // Since this thing requires you to give up a belt slot, and it can't be used to cut open stuff like a pickaxe, it can be a little better than one.
	name = "experimental ceremonial sword"
	desc = "A blade passed down through generations of a dedicated unitologist family, the Higgins. Sam had it modified into a experimental ceremonial blade, enhancing the already astonishing properties of the original metal and giving it an ominous crimson glow that matches the Marker. An explosive charge housed in the scabbard enables a lightning-quick draw."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "muramasa"

	item_flags = ITEM_FLAG_NO_EMBED
	slot_flags = null
	force = WEAPON_FORCE_ROBUST
	force_divisor = 0.75 //Dislikes being one handed!
	throwforce = WEAPON_FORCE_ROBUST
	item_state = "muramasa"
	w_class = ITEM_SIZE_HUGE

	tool_qualities = list(QUALITY_CUTTING = 50, QUALITY_SAWING = 25)

	max_modifications = 4
	degradation = DEGRADATION_DIAMOND
	armor_penetration = 8

    health = 300
    base_parry_chance = 30
	melee_accuracy_bonus = 0