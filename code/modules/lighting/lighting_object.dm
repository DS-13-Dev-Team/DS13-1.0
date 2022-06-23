/datum/lighting_object
	///the underlay we are currently applying to our turf to apply light
	var/mutable_appearance/current_underlay

	///whether we are already in the SSlighting.objects_queue list
	var/needs_update = FALSE

	///the turf that our light is applied to
	var/turf/affected_turf

/datum/lighting_object/New(turf/source)
	if(!isturf(source))
		qdel(src, force=TRUE)
		crash_with("a lighting object was assigned to [source], a non turf! ")
		return
	. = ..()

	current_underlay = mutable_appearance(LIGHTING_ICON, LIGHTING_BASE_ICON_STATE, source.z, LIGHTING_PLANE, 255, RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)

	affected_turf = source
	if (affected_turf.lighting_object)
		qdel(affected_turf.lighting_object, force = TRUE)
		crash_with("a lighting object was assigned to a turf that already had a lighting object!")

	affected_turf.lighting_object = src
	affected_turf.luminosity = 0

	for(var/turf/space/space_tile in RANGE_TURFS(affected_turf, 1))
		space_tile.update_starlight()

	needs_update = TRUE
	SSlighting.objects_queue += src

/datum/lighting_object/Destroy(force)
	if (!force)
		return QDEL_HINT_LETMELIVE
	SSlighting.objects_queue -= src
	if (isturf(affected_turf))
		affected_turf.lighting_object = null
		affected_turf.luminosity = 1
		affected_turf.underlays -= current_underlay
	affected_turf = null
	return ..()

// This is a macro PURELY so that the if below is actually readable.
#define ALL_EQUAL ((rr == gr && gr == br && br == ar) && (rg == gg && gg == bg && bg == ag) && (rb == gb && gb == bb && bb == ab))

/datum/lighting_object/proc/update()

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new

	var/datum/lighting_corner/red_corner = affected_turf.lighting_corner_SW || dummy_lighting_corner
	var/datum/lighting_corner/green_corner = affected_turf.lighting_corner_SE || dummy_lighting_corner
	var/datum/lighting_corner/blue_corner = affected_turf.lighting_corner_NW || dummy_lighting_corner
	var/datum/lighting_corner/alpha_corner = affected_turf.lighting_corner_NE || dummy_lighting_corner

	var/max = max(red_corner.largest_color_luminosity, green_corner.largest_color_luminosity, blue_corner.largest_color_luminosity, alpha_corner.largest_color_luminosity)

	var/rr = red_corner.cache_r
	var/rg = red_corner.cache_g
	var/rb = red_corner.cache_b

	var/gr = green_corner.cache_r
	var/gg = green_corner.cache_g
	var/gb = green_corner.cache_b

	var/br = blue_corner.cache_r
	var/bg = blue_corner.cache_g
	var/bb = blue_corner.cache_b

	var/ar = alpha_corner.cache_r
	var/ag = alpha_corner.cache_g
	var/ab = alpha_corner.cache_b

	#if LIGHTING_SOFT_THRESHOLD != 0
	var/set_luminosity = max > LIGHTING_SOFT_THRESHOLD
	#else
	// Because of floating points™?, it won't even be a flat 0.
	// This number is mostly arbitrary.
	var/set_luminosity = max > 1e-6
	#endif

	affected_turf.underlays -= current_underlay
	if(rr + rg + rb + gr + gg + gb + br + bg + bb + ar + ag + ab >= 12)
		current_underlay.icon_state = LIGHTING_TRANSPARENT_ICON_STATE
		current_underlay.color = null
	else if(!set_luminosity)
		current_underlay.icon_state = LIGHTING_DARKNESS_ICON_STATE
		current_underlay.color = null
	else if (rr == LIGHTING_DEFAULT_TUBE_R && rg == LIGHTING_DEFAULT_TUBE_G && rb == LIGHTING_DEFAULT_TUBE_B && ALL_EQUAL)
		current_underlay.icon_state = LIGHTING_STATION_ICON_STATE
		current_underlay.color = null
	else
		current_underlay.icon_state = LIGHTING_BASE_ICON_STATE
		current_underlay.color = list(
			rr, rg, rb, 00,
			gr, gg, gb, 00,
			br, bg, bb, 00,
			ar, ag, ab, 00,
			00, 00, 00, 01
		)
	affected_turf.underlays += current_underlay
	affected_turf.luminosity = set_luminosity

#undef ALL_EQUAL
