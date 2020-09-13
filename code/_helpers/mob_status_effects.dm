//Causes a mob to step one tile in a direction, and their camera goes with them
/mob/proc/lurch(var/direction, var/camera_shift = 64, var/skip_cooldown = TRUE)
	if (!direction)
		direction = pick(GLOB.cardinal)

	if (skip_cooldown)
		reset_move_cooldown()

	if (!SelfMove(direction))
		return
	if (client)
		var/vector2/delta = Vector2.NewFromDir(direction)
		delta.SelfMultiply(camera_shift)
		animate(client, pixel_x = delta.x, pixel_y = delta.y, time = 3)
		animate(pixel_x = 0, pixel_y = 0, time = 10)


//Makes a mob unable to move under its own power. either for a limited duration or until the handler is removed
/mob/proc/root(var/duration = 0)
	return AddMovementHandler(/datum/movement_handler/root, null, duration)


/*
	Resurrection
	Brings a dead mob back to life.

	In the case of humans, this will require all vital organs (brain, heart, etc) to be present and in working condition,
	otherwise it will either instafail, or die shortly after
*/
/mob/proc/resurrect(var/external_healing = 100)
	if (stat != DEAD)
		return FALSE

	stat = CONSCIOUS
	return TRUE

/mob/living/resurrect(var/external_healing = 100)
	.=..()
	if (!.)
		return
	if (external_healing)
		heal_overall_damage(external_healing)
	adjustOxyLoss(-9999999)//Remove oxyloss


/mob/living/carbon/human/resurrect(var/external_healing = 100)
	.=..()
	if (!.)
		return
	shock_stage = 0
	for (var/obj/item/organ/O in internal_organs)
		O.rejuvenate()