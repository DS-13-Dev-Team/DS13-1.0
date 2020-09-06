/*
	The healthbar is displayed along the top of the client's screen
*/
/mob/living/var/obj/screen/healthbar/hud_healthbar

/obj/screen/healthbar
	name = "healthbar"
	var/client/C
	var/mob/living/L
	var/obj/screen/healthbar_component/health/remaining_health_meter	//The actual remaining health, in red or green
	var/obj/screen/healthbar_component/delta/delta_meter	//A yellow section indicating recent loss
	var/obj/screen/healthbar_component/limit/limit_meter	//A solid grey block at the end, representing reduced maximum
	var/obj/screen/healthbar_component/text/textholder

	alpha = 200
	color = COLOR_DARK_GRAY

	screen_loc = "CENTER,TOP"
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	icon = 'icons/mob/screen_health.dmi'
	icon_state = "white"

	var/total_health = 0
	var/current_health = 0



	//The healthbar size is dynamic and scales with diminishing returns based on the user's health.
	//From 0 to 100, it is 2 pixels wide per health point, then from 100 to 200, 1 pixel for each additional health, and so on. The list below holds the data
	//This ensures that it gets bigger with more health, but never -toooo- big
	var/list/size_pixels = list("0" = 2,
	"100" = 1,
	"200" = 0.5,
	"400" = 0.3)

	mouse_opacity = 2


	//Measured in pixels
	var/length

	var/base_length = 50	//Minimum size which is added to with calculated sizes

	var/margin = 8//Extra length that isn't counted as part of our length for the purpose of components


/obj/screen/healthbar/Destroy()
	if (L)
		if (L.hud_healthbar == src)
			L.hud_healthbar = null
		L = null
	QDEL_NULL(remaining_health_meter)
	QDEL_NULL(delta_meter)
	QDEL_NULL(limit_meter)
	QDEL_NULL(textholder)
	if (C)
		C.screen -= src
		C = null
	.=..()

/obj/screen/healthbar/added_to_screen(var/client/newclient)
	if (newclient != C)
		if (C)
			C.screen -= remaining_health_meter
			C.screen -= delta_meter
			C.screen -= limit_meter
			C.screen -= textholder

		C = newclient

		set_mob(C.mob)

		QDEL_NULL(remaining_health_meter)
		QDEL_NULL(delta_meter)
		QDEL_NULL(limit_meter)
		QDEL_NULL(textholder)
		remaining_health_meter = new(src)
		delta_meter = new(src)
		limit_meter = new(src)
		textholder = new(src)


/obj/screen/healthbar/proc/set_mob(var/mob/living/newmob)
	L = newmob
	GLOB.updatehealth_event.register(L, src, /obj/screen/healthbar/proc/update)
	L.hud_healthbar = src
	set_health()

/obj/screen/healthbar/proc/set_health()

	if (total_health != L.max_health)
		total_health = L.max_health
		if (!total_health && ishuman(L))
			var/mob/living/carbon/human/H = L
			if (H.species)
				total_health = H.species.total_health

		set_size()

/obj/screen/healthbar/proc/set_size(var/update = TRUE)
	//Lets set the size


	length = base_length


	var/working_health = total_health
	var/index = 1
	var/current_key = size_pixels[1]
	var/current_multiplier = size_pixels[current_key]
	while (working_health > 0)
		//How much health we convert into pixels this step
		var/delta

		//At the end of the step we'll set current values to these. Cache current values for now, they will be edited if theres any list indices left
		var/next_key = current_key
		var/next_multiplier = current_multiplier

		//Is there a next entry after our current one?
		if (size_pixels.len >= index+1)
			//Cache next key and mult, we'll put them into the current values at the end
			next_key = size_pixels[index+1]
			next_multiplier = size_pixels[next_key]

			//Figure out how much health we'll convert this step
			delta = text2num(next_key) - text2num(current_key)
			delta = min(working_health, delta)
			//Subtract it from the working health
			working_health -= delta

		//If not, then we're at the final tier, convert all remaining health to pixels
		else
			delta = working_health
			working_health = 0


		//Add to our pixel length, and increment things for the next cycle, if there's gonna be one
		length += delta * current_multiplier

		index++
		current_key = next_key
		current_multiplier = next_multiplier

	//Lastly, lets round off that pixel length
	length = round(length)

	//We must make sure it can fit on the client's screen
	length = min(length, C.get_viewport_width() - margin)



	//Alright we have the length, now lets figure out a transform
	//We count the margin here without actually adding it to the length variable
	var/x_scale = (length + margin) / WORLD_ICON_SIZE
	var/matrix/M = matrix()
	M.Scale(x_scale, 1)
	animate(src, transform = M, time = 2 SECONDS)
	if (remaining_health_meter)
		remaining_health_meter.update_total()
	if (delta_meter)
		delta_meter.update_total()
	if (textholder)
		textholder.update_total()
	if (update)
		update()



/obj/screen/healthbar/proc/update()
	var/list/data = L.get_health_report()
	var/max = data["max"]

	//Uh oh, the max health has changed, this doesnt happen often. We gotta recalculate the size
	if (max != total_health)
		total_health = max
		set_size(FALSE)//Prevent infinite loop

	var/health_changed = 0	//1 for positive, -1 for negative
	var/new_health = total_health - data["damage"]
	new_health = max(new_health, 0)


	if (new_health > current_health)
		health_changed = 1
	if (new_health < current_health)
		health_changed = -1
	current_health = new_health

	if (textholder)
		textholder.maptext = "[Ceiling(current_health)]/[total_health]"
	var/blocked = data["blocked"]

	//Lets update the health display first
	if (remaining_health_meter && health_changed != 0)
		var/remaining_health_meter_pixels = (current_health / max) * length
		remaining_health_meter.set_size(remaining_health_meter_pixels)


	//And blocked
	if (limit_meter)
		limit_meter.set_size((blocked / max) * length)


	//Delta works differently, and only updates if health goes down, not up
	if (delta_meter && health_changed == -1)
		delta_meter.update()









/*
	The components
	Core:
*/
/obj/screen/healthbar_component
	var/obj/screen/healthbar/parent
	alpha = 200

	screen_loc = "CENTER,TOP"
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER
	icon = 'icons/mob/screen_health.dmi'
	icon_state = "white_slim"
	var/side = -1	//-1 = left, 1 = right

	var/animate_time = 1 SECOND
	var/matrix/M
	var/offset

	mouse_opacity = 2

/obj/screen/healthbar_component/New(var/obj/screen/healthbar/newparent)
	parent = newparent
	parent.C.screen += src
	update_total()
	.=..()

/obj/screen/healthbar_component/Destroy()
	if (parent && parent.C)
		parent.C.screen -= src
	.=..()


//Sets a new size in pixels
/obj/screen/healthbar_component/proc/set_size(var/newsize)
	if (!newsize)
		alpha = 0
		return
	alpha = initial(alpha)
	var/x_scale = newsize / WORLD_ICON_SIZE
	var/matrix/M = matrix()
	M.Scale(x_scale, 1)

	//Alright we have the matrix to make us the right size, but we also need to offset to the correct position
	var/offset = ((parent.length - newsize) * 0.5) * side
	M.Translate(offset, 0)

	animate(src, transform = M,  time = animate_time)


/obj/screen/healthbar_component/proc/update_total()
	if (parent)
		set_size(parent.length)


/*
	Health
*/

/obj/screen/healthbar_component/health
	layer = HUD_ABOVE_ITEM_LAYER	//This must draw above the delta
	color = COLOR_NT_RED
	animate_time = 0.3 SECOND


/*
	Limit
*/
/obj/screen/healthbar_component/limit
	color = COLOR_GRAY40
	side = 1


/*
	Delta
*/
/obj/screen/healthbar_component/delta
	color = COLOR_AMBER
	var/head_health = 0	//What health value is the tip of the delta meter currently showing
	var/ticks_per_second = 2
	animate_time = 0.5 SECOND

	var/windup_time = 1.5 SECOND	//When the user takes damage for the first time in a while, the delta willpause to show the extend of it before it starts animating down

	//When we're winding up, we won't start the animation until this time. It may be extended while we're waiting
	var/animate_continue_time = 0

	//delta has 3 states
	//0: Idle, not animating or visible
	//1: Waiting: About to start an animation
	//2: Currently animating
	var/animation_state = 0

	var/health_per_tick = 10

/obj/screen/healthbar_component/delta/New(var/obj/screen/healthbar/newparent)
	.=..()
	head_health = parent.total_health
	animate_time = (1 SECOND / ticks_per_second)
	health_per_tick = (parent.total_health * 0.065)/ticks_per_second


/obj/screen/healthbar_component/delta/update_total()
	head_health = parent.current_health
	animate_time = (1 SECOND / ticks_per_second)
	alpha = 0
	health_per_tick = (parent.total_health * 0.1)/ticks_per_second

//Delta works very differently
/obj/screen/healthbar_component/delta/proc/update()
	if (!parent)
		return


	//If the necromorph has suddenly been healed exactly to, or above the damage we're trying to show, we just abort all animation
	if (parent.current_health >= head_health)
		stop_animation()
		return


	animate_continue_time = world.time + windup_time
	//We will start a new animation only if no current one is ongoing
	if (animation_state == 0)
		start_animation()

/obj/screen/healthbar_component/delta/proc/start_animation()
	set waitfor = FALSE
	alpha = initial(alpha)
	//Gotta do this in the right order
	if (animation_state != 0)
		stop_animation()
		return

	animation_state = 1

	//Immediately update the bar to the current head
	set_size((head_health / parent.total_health) * parent.length)



	//And then we wait
	//We're doing this in a while loop because it's possible (and likely) that the continuation time will be extended while we wait
	//We'll continue waiting until the time stops getting extended
	while (animate_continue_time > world.time)
		sleep(animate_continue_time - world.time)




	//Now we check again to see if things have changed. If they have, we abort
	if (animation_state != 1)
		stop_animation()
		return

	ongoing_animation()

//Here we animate and move each tick until we
/obj/screen/healthbar_component/delta/proc/ongoing_animation()
	set waitfor = FALSE

	//Gotta do this in the right order
	if (animation_state != 1)
		stop_animation()
		return

	animation_state = 2

	//Here we will animate periodically towards a target value
	while (parent && head_health > parent.current_health && animation_state == 2)
		var/delta = min(health_per_tick, head_health - parent.current_health)
		head_health -= delta
		set_size((head_health / parent.total_health) * parent.length)
		sleep(animate_time)

	//Once we're done, reset animation state
	stop_animation()

//Terminates any ongoing animation
/obj/screen/healthbar_component/delta/proc/stop_animation()
	animation_state = 0
	head_health = parent.current_health

	set_size((head_health / parent.total_health) * parent.length)

	alpha = 0




/*
	Text
*/
/obj/screen/healthbar_component/text
	icon_state = ""
	layer = HUD_TEXT_LAYER

/obj/screen/healthbar_component/text/update_total()
	if (parent)
		set_size(parent.length)
		maptext_width = parent.length
		maptext_height = 16
		maptext_y = 17
		maptext = "[Ceiling(parent.current_health)]/[parent.total_health]"

/obj/screen/healthbar_component/text/set_size()
	return








/*
	This examines the mob and returns a report in this format:
	list("key" = numbervalue)

	The keys:
	"max": The mob's maximum health
	"damage": The total of damage taken
	"blocked": The total of health which is unrecoverable, limiting the max
*/
/mob/living/proc/get_health_report()
	return list ("max" = max_health, "damage" = 0, "blocked" = 0)

/mob/living/carbon/human/get_health_report()
	return species.get_health_report(src)


/datum/species/proc/get_health_report(var/mob/living/carbon/human/H)
	return list ("max" = total_health, "damage" = 0, "blocked" = 0)

/datum/species/necromorph/get_health_report(var/mob/living/carbon/human/H)
	var/list/things = get_weighted_total_limb_damage(H, TRUE)
	things["max"] = total_health
	return things


