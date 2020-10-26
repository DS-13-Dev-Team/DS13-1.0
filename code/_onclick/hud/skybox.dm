#define DEFAULT_SKYBOX_SIZE	736
#define BASE_BUFFER_TILES	15
/obj/skybox
	name = "skybox"
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	screen_loc = "CENTER:-224,CENTER:-224"
	plane = SKYBOX_PLANE
	blend_mode = BLEND_MULTIPLY

	var/side_motion
	var/slide_range = -224
	var/scalar = 1

	//Even at the map edge, a mob must always remain this-many tiles from the map edge.
	var/buffer_tiles = 15

	//By default the skybox positions its own lowerleft corner where we point to. So we must additionally offset it by this in both directions to centre it
	var/base_offset = -368

/client
	var/obj/skybox/skybox

/client/proc/update_skybox(var/rebuild = FALSE)
	if(!skybox)
		skybox = new()
		screen += skybox
		rebuild = 1

	var/turf/T = get_turf(eye)
	if(T)
		if(rebuild)
			skybox.overlays.Cut()
			skybox.overlays += SSskybox.get_skybox(T.z, max(world.view, temp_view))
			screen |= skybox
			skybox.scalar = view_scalar(temp_view)

			skybox.buffer_tiles = BASE_BUFFER_TILES + temp_view

			//Alright, time for some math. First of all, how big is the skybox image now, in pixels
			var/skybox_side_size = DEFAULT_SKYBOX_SIZE * skybox.scalar

			//Here's the minimum distance in pixels we need to be from the edge, to not-see whitespace
			var/buffer_pixels = (temp_view + 1) * WORLD_ICON_SIZE

			//And here's the farthest we're allowed to slide on both axes before we see whitespace. Inverting it makes math easier
			skybox.slide_range = ((skybox_side_size *0.5) - buffer_pixels)	*-1

			skybox.base_offset = skybox_side_size * -0.5


		//This gets a percentage of how far we are along the side of the map, in a range between 0 to 1
		//Buffer is added to our own position, because we're position+buffer away from the lower sides
		//Buffer is added TWICE to the world maxx/y values, because the percentage is measured as a whole along that line
		//Because of the buffer, neither of the values will ever be 0 or 1
		var/vector2/locpercent = get_new_vector(
		(skybox.buffer_tiles + T.x) / (world.maxx + skybox.buffer_tiles*2),
		(skybox.buffer_tiles + T.y) / (world.maxy + skybox.buffer_tiles*2)
		)

		//Now we double the values and then subtract 1. This rescales it to a value between -1 to 1
		locpercent.SelfMultiply(2)
		locpercent.x -= 1
		locpercent.y -= 1
		skybox.screen_loc = "CENTER:[round(skybox.base_offset + (skybox.slide_range * locpercent.x))],CENTER:[round(skybox.base_offset + (skybox.slide_range* locpercent.y))]"
		release_vector(locpercent)

/mob/Login()
	..()
	client.update_skybox(TRUE)

/mob/Move()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))

/mob/forceMove()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))



