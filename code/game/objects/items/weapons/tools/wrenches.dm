/obj/item/weapon/tool/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon_state = "wrench"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = WEAPON_FORCE_NORMAL
	worksound = WORKSOUND_WRENCHING
	throwforce = WEAPON_FORCE_NORMAL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 1000)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")
	tool_qualities = list(QUALITY_BOLT_TURNING = 30)

/obj/item/weapon/tool/wrench/improvised
	name = "sheet spanner"
	desc = "A flat bit of metal with some usefully shaped holes cut into it."
	icon_state = "impro_wrench"
	degradation = DEGRADATION_FRAGILE
	force = WEAPON_FORCE_HARMLESS
	tool_qualities = list(QUALITY_BOLT_TURNING = 15)
	matter = list(MATERIAL_STEEL = 1000)

/obj/item/weapon/tool/wrench/big_wrench
	name = "big wrench"
	desc = "If everything else failed - bring a bigger wrench."
	icon_state = "big-wrench"
	tool_qualities = list(QUALITY_BOLT_TURNING = 40)
	matter = list(MATERIAL_STEEL = 4000)
	force = WEAPON_FORCE_NORMAL
	throwforce = WEAPON_FORCE_NORMAL
	degradation = DEGRADATION_TOUGH_2
	max_modifications = 4


//Even bigger wrench, custom item for marshal red
//Is not a tool subtype and can't be modified
/obj/item/weapon/material/twohanded/fireaxe/bigwrench
	icon_state = "big_wrench0"
	base_icon = "big_wrench"
	name = "colossal wrench"
	desc = "A vast, two-handed tool, often operated with mechanical assistance"

	tool_qualities = list(QUALITY_BOLT_TURNING = 80)
	matter = list(MATERIAL_STEEL = 8000)

	sharp = FALSE
	edge = FALSE
	attack_verb = list("attacked", "crushed", "smashed", "slammed", "wrenched")
	attack_noun = list("attack", "swing", "smash", "slam", "tear", "rip", "dice", "cut")