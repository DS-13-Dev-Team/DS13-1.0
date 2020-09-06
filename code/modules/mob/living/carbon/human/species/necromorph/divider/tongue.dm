/*
	Tongue Attack

	Fires a projectile which leads the tongue.
	The actual tongue is drawn as a tracer effect which follows the projectile

	If it hits a mob, wraps around their neck and begins an execution move. At this point, the tongue becomes a targetable object
*/
#define TONGUE_PROJECTILE_SPEED	3
/mob/living/proc/divider_tongue(var/atom/A)
	set name = "Tonguetacle"
	set category = "Abilities"
	set desc = "Launches out your tongue to grab a human and strangle them. HK: Middleclick"

	face_atom(A)
	.= shoot_ability(/datum/extension/shoot/tongue, A , /obj/item/projectile/tongue, accuracy = 200, dispersion = 0, num = 1, windup_time = 0.5 SECONDS, fire_sound = null, nomove = 1 SECOND, cooldown = 1 SECONDS)
	if (.)
		play_species_audio(src, SOUND_ATTACK, VOLUME_MID, 1, 3)



/datum/extension/shoot/tongue
	name = "Divider Tongue"
	base_type = /datum/extension/shoot/longshot



/obj/item/projectile/tongue
	name = "tongue leader"
	icon_state = ""
	fire_sound = null
	damage = 0
	nodamage = TRUE
	step_delay = (10 / TONGUE_PROJECTILE_SPEED)
	var/obj/effect/projectile/tether/tongue = null

/*
	The firer will be set just before this proc is called
*/
/obj/item/projectile/tongue/launch(atom/target, var/target_zone, var/x_offset=0, var/y_offset=0, var/angle_offset=0)
	tongue = new(get_turf(src))
	update_tongue()
	.=..()


/obj/item/projectile/tongue/Move(NewLoc,Dir=0)
	update_tongue()
	.=..()

/obj/item/projectile/tongue/proc/update_tongue()
	var/vector2/origin_pixels = firer.get_global_pixel_loc()
	var/vector2/current_pixels = get_global_pixel_loc()
	tongue.set_ends(origin_pixels, target)
	release_vector(origin_pixels)
	release_vector(current_pixels)
