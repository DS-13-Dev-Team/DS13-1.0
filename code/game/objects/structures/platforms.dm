/*
 * Platforms
 * These are like railings, except fancier. Ported from CM, and thanks to them! - Lion
 */
/obj/structure/platform/platform
	name = "platform"
	desc = "A square metal surface resting on four legs."
	icon = 'icons/obj/platforms.dmi'
	icon_state = "platform"
	anchored = 1
	density = 1
	throwpass = 1
	layer = 5.2 // Same layer as regular railing.
	atom_flags = ATOM_FLAG_CHECKS_BORDER | ATOM_FLAG_CLIMBABLE
	breakable = 0 // Cannot be breakable.

/obj/structure/platform/platform/New()
	var/image/I = image(icon, src, "platform_overlay", ABOVE_TURF_PLANE, dir)
	switch(dir)
		if(SOUTH)
			layer = ABOVE_TURF_PLANE+0.1
			I.pixel_y = -16
		if(NORTH)
			I.pixel_y = 16
		if(EAST)
			I.pixel_x = 16
			layer = ABOVE_TURF_PLANE+0.1
		if(WEST)
			I.pixel_x = -16
			layer = ABOVE_TURF_PLANE+0.1
	overlays += I
	..()

/obj/structure/platform/platform/ex_act()
	return

obj/structure/platform/platform_decoration
	name = "platform"
	desc = "A square metal surface resting on four legs."
	icon = 'icons/obj/platforms.dmi'
	icon_state = "platform_deco"
	anchored = 1
	density = 1
	throwpass = 1
	layer = 5.2 // Same layer as regular railing.
	atom_flags = ATOM_FLAG_CHECKS_BORDER
	breakable = 0 // Cannot be breakable.

/obj/structure/platform/platform_decoration/New()
	switch(dir)
		if (NORTH)
			layer = ABOVE_TURF_PLANE+0.1
		if (SOUTH)
			layer = ABOVE_TURF_PLANE+0.1
		if (SOUTHEAST)
			layer = ABOVE_TURF_PLANE+0.1
		if (SOUTHWEST)
			layer = ABOVE_TURF_PLANE+0.1
	.. ()

//Map variants//

//Strata purple ice//
/obj/structure/platform/platform_decoration/strata
	name = "ice rock corner"
	desc = "A solid chunk of desolate rocks and ice."
	icon_state = "strata_platform_deco"

/obj/structure/platform/platform/strata
	name = "ice rock edge"
	desc = "A solid chunk of desolate rocks and ice. Looks like you could climb it with some difficulty."
	icon_state = "strata_platform"

//Strata wall metal platforms
/obj/structure/platform/platform_decoration/strata/metal
	name = "raised metal corner"
	desc = "A raised level of metal, often used to elevate areas above others. This is the corner."
	icon_state = "strata_metalplatform_deco"

/obj/structure/platform/platform/strata/metal
	name = "raised metal edge"
	desc = "A raised level of metal, often used to elevate areas above others. You could probably climb it."
	icon_state = "strata_metalplatform"

//Kutjevo metal platforms

/obj/structure/platform/platform/kutjevo
	icon_state = "kutjevo_platform"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/platform_decoration/kutjevo
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_deco"


/obj/structure/platform/platform/kutjevo/smooth
	icon_state = "kutjevo_platform_sm"
	name = "raised metal edge"
	desc =  "A raised level of metal, often used to elevate areas above others, or construct bridges. You could probably climb it."

/obj/structure/platform/platform/kutjevo/smooth/stair_plate
	icon_state = "kutjevo_stair_plate"

/obj/structure/platform/platform/kutjevo/smooth/stair_cut
	icon_state = "kutjevo_stair_cm_stair"


/obj/structure/platform/platform_decoration/kutjevo/smooth
	name = "raised metal corner"
	desc = "The corner of what appears to be raised piece of metal, often used to imply the illusion of elevation in non-euclidean 2d spaces. But you don't know that, you're just a spaceman with a rifle."
	icon_state = "kutjevo_platform_sm_deco"

/obj/structure/platform/platform/kutjevo/rock
	icon_state = "kutjevo_rock"
	name = "raised rock edges"
	desc = "A collection of stones and rocks that provide ample grappling and vaulting opportunity. Indicates a change in elevation. You could probably climb it."

/obj/structure/platform/platform_decoration/kutjevo/rock
	icon_state = "kutjevo_rock_deco"
	name = "raised rock corner"
	desc = "A collection of stones and rocks that cap the edge of some conveniently 1 meter long lengths of perfectly climbable chest high walls."


/obj/structure/platform/do_climb(var/mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message("<span class='warning'>\The [user] starts climbing onto \the [src]!</span>")
	climbers |= user

	if(!do_after(user,(issmall(user) ? 20 : 34)))
		climbers -= user
		return

	if(!can_climb(user, post_climb_check=1))
		climbers -= user
		return

	if(!turf_is_crowded())
		to_chat(user, "<span class='warning'>You can't climb there, the way is blocked.</span>")
		climbers -= user
		return

	if(get_turf(user) == get_turf(src))
		user.forceMove(get_step(src, src.dir))
	else
		user.forceMove(get_turf(src))

	user.visible_message("<span class='danger'>\The [user] climbed over \the [src]!</span>")
	climbers -= user

