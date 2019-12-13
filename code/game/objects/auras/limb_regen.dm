/*
	Limb regen aura
	Used by ubermorph for the visual effect of regrowing a limb.
	Has no functional effects
*/
/obj/aura/limb_regen
	name = "limb regen"
	plane = MOB_PLANE
	layer = MOB_LAYER
	var/limb_icon
	var/limb_iconstate

/obj/aura/limb_regen/New(var/mob/living/carbon/human/H, var/_limb_icon, var/_limb_iconstate)
	plane = H.plane
	layer = H.layer -0.1
	..()
	world << "New limbbregen [_limb_icon], [_limb_iconstate]"
	limb_icon = _limb_icon
	limb_iconstate = _limb_iconstate
	icon = limb_icon

/obj/aura/limb_regen/Initialize()
	.=..()
	icon_state = limb_iconstate
	flick(limb_iconstate, src)

	QDEL_IN(src, 4 SECONDS)