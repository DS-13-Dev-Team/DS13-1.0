//Exists to handle a few global variables that change enough to justify this. Technically a parallax, but it exhibits a skybox effect.
SUBSYSTEM_DEF(skybox)
	name = "Space skybox"
	init_order = SS_INIT_SKYBOX
	flags = SS_NO_FIRE
	var/background_color
	var/skybox_icon = 'icons/skybox/skybox.dmi' //Path to our background. Lets us use anything we damn well please. Skyboxes need to be 736x736
	var/background_icon = "dyable"
	var/use_stars = TRUE
	var/use_overmap_details = TRUE
	var/star_path = 'icons/skybox/skybox.dmi'
	var/star_state = "stars"
	var/list/skybox_cache = list()

	//A singleton datum ref list
	var/list/skybox_foreground_objects = list()


/datum/controller/subsystem/skybox/Initialize()
	. = ..()
	background_color = RANDOM_RGB

/datum/controller/subsystem/skybox/Recover()
	background_color = SSskybox.background_color
	skybox_cache = SSskybox.skybox_cache

/datum/controller/subsystem/skybox/proc/get_skybox(var/z, var/range = world.view)
	if(!skybox_cache["[z]_[range]"])
		skybox_cache["[z]_[range]"] = generate_skybox(z, range)
		/*
		if(GLOB.using_map.use_overmap)
			var/obj/effect/overmap/visitable/O = map_sectors["[z]_[range]"]
			if(istype(O))
				for(var/zlevel in O.map_z)
					skybox_cache["[zlevel]"] = skybox_cache["[z]_[range]"]
		*/
	return skybox_cache["[z]_[range]"]

/datum/controller/subsystem/skybox/proc/generate_skybox(var/z, var/range = world.view)
	var/icon/I = skybox_icon
	if (range > world.view)
		var/scalar = view_scalar(range)
		I = rescale_icon_scalar(skybox_icon, scalar,scalar)
	else
		I = icon(skybox_icon)

	var/image/res = image(I)
	res.appearance_flags = KEEP_TOGETHER

	var/image/base = overlay_image(I, background_icon, background_color)

	if(use_stars)
		var/image/stars = overlay_image(I, star_state, flags = RESET_COLOR)
		base.overlays += stars

	res.overlays += base

	/*
	if(GLOB.using_map.use_overmap && use_overmap_details)
		var/obj/effect/overmap/visitable/O = map_sectors["[z]"]
		if(istype(O))
			var/image/overmap = image(skybox_icon)
			overmap.overlays += O.generate_skybox()
			for(var/obj/effect/overmap/visitable/other in O.loc)
				if(other != O)
					overmap.overlays += other.get_skybox_representation()
			overmap.appearance_flags = RESET_COLOR
			res.overlays += overmap

	for(var/datum/event/E in SSevent.active_events)
		if(E.has_skybox_image && E.isRunning && (z in E.affecting_z))
			res.overlays += E.get_skybox_image()
	*/

	//Lets create and place foreground objects
	if(GLOB.using_map.skybox_foreground_objects)
		for (var/typepath in GLOB.using_map.skybox_foreground_objects)
			var/datum/skybox_foreground_object/SFO = get_foreground_datum(typepath)
			var/image/foreground_image = image(SFO.icon, pick(SFO.icon_states))
			foreground_image.appearance_flags = RESET_COLOR	//We do not want to inherit the background color tint of space
			foreground_image.transform *= SFO.scale

			var/vector2/offset = SFO.get_offset()
			if (offset)
				foreground_image.pixel_x = offset.x * DEFAULT_SKYBOX_SIZE
				foreground_image.pixel_y = offset.y * DEFAULT_SKYBOX_SIZE

			res.overlays += foreground_image



	return res


/datum/controller/subsystem/skybox/proc/get_foreground_datum(var/typepath)
	if (!skybox_foreground_objects[typepath])
		skybox_foreground_objects[typepath] = new typepath

	return skybox_foreground_objects[typepath]

/datum/controller/subsystem/skybox/proc/rebuild_skyboxes(var/list/zlevels)
	for(var/z in zlevels)
		skybox_cache["[z]_[world.view]"] = generate_skybox(z)

	for(var/client/C)
		C.update_skybox(1)

//Update skyboxes. Called by universes, for now.
/datum/controller/subsystem/skybox/proc/change_skybox(new_state, new_color, new_use_stars, new_use_overmap_details)
	var/need_rebuild = FALSE
	if(new_state != background_icon)
		background_icon = new_state
		need_rebuild = TRUE

	if(new_color != background_color)
		background_color = new_color
		need_rebuild = TRUE

	if(new_use_stars != use_stars)
		use_stars = new_use_stars
		need_rebuild = TRUE

	if(new_use_overmap_details != use_overmap_details)
		use_overmap_details = new_use_overmap_details
		need_rebuild = TRUE

	if(need_rebuild)
		skybox_cache.Cut()

		for(var/client/C)
			C.update_skybox(1)