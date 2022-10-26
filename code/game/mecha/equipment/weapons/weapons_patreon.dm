/obj/item/material/twohanded/muramasa
	icon = 'icons/obj/weapons.dmi'
	icon_state = "muramasa0"
	base_icon = "muramasa"
	name = "experimental ceremonial sword"
	desc = "A blade passed down through generations of a dedicated unitologist family, the Higgins. Sam had it modified into a experimental ceremonial blade, enhancing the already astonishing properties of the original metal and giving it an ominous crimson glow that matches the Marker. An explosive charge housed in the scabbard enables a lightning-quick draw."

	force_divisor = 0.60
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BELT
	force_wielded = WEAPON_FORCE_ROBUST*1.20 //can't be modified
	force_unwielded = WEAPON_FORCE_NORMAL //don't use this with a shield
	tool_qualities = list(QUALITY_SAWING = 25)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	attack_noun = list("attack", "slash", "chop", "slice", "tear", "rip", "dice", "cut")
	applies_material_colour = 0
	health = 325
	base_parry_chance = 33
	hitsound = 'sound/weapons/bladeslice.ogg'
