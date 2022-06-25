#define DETERMINANT(A_X,A_Y,B_X,B_Y) ((A_X)*(B_Y) - (A_Y)*(B_X))
// This is where the fun begins.
// These are the main datums that emit light.

/datum/light_source
	///The atom we're emitting light from (for example a mob if we're from a flashlight that's being held).
	var/atom/top_atom
	///The atom that we belong to.
	var/atom/source_atom

	///The turf under the source atom.
	var/turf/source_turf
	///The turf the top_atom appears to over.
	var/turf/pixel_turf
	///Intensity of the emitter light.
	var/light_power
	/// The range of the emitted light.
	var/light_range
	/// The colour of the light, string, decomposed by parse_light_color()
	var/light_color
	/// The light's emission angle, in degrees.
	var/light_angle

	// Variables for keeping track of the colour.
	var/lum_r
	var/lum_g
	var/lum_b

	// The lumcount values used to apply the light.
	var/tmp/applied_lum_r
	var/tmp/applied_lum_g
	var/tmp/applied_lum_b

	// The last known X coord of the origin.
	var/tmp/cached_origin_x
	// The last known Y coord of the origin.
	var/tmp/cached_origin_y
	// The last known direction of the origin.
	var/tmp/old_direction
	// How much the X coord should be offset due to direction.
	var/tmp/test_x_offset
	// How much the Y coord should be offset due to direction.
	var/tmp/test_y_offset

	// The first test point's X coord for the cone.
	var/tmp/limit_a_x
	// The first test point's Y coord for the cone.
	var/tmp/limit_a_y
	// The second test point's X coord for the cone.
	var/tmp/limit_b_x
	// The second test point's Y coord for the cone.
	var/tmp/limit_b_y

	/// List used to store how much we're affecting corners.
	var/list/datum/lighting_corner/effect_str

	/// Whether we have applied our light yet or not.
	var/applied = FALSE

	/// whether we are to be added to SSlighting's sources_queue list for an update
	var/needs_update = LIGHTING_NO_UPDATE

/datum/light_source/New(atom/owner, atom/top)
	source_atom = owner // Set our new owner.
	LAZYADD(source_atom.light_sources, src)
	top_atom = top
	if (top_atom != source_atom)
		LAZYADD(top_atom.light_sources, src)

	source_turf = top_atom
	pixel_turf = get_turf_pixel(top_atom) || source_turf

	light_power = source_atom.light_power
	light_range = source_atom.light_range
	light_color = source_atom.light_color
	light_angle = source_atom.light_wedge

	PARSE_LIGHT_COLOR(src)

	update()

/datum/light_source/Destroy(force)
	remove_lum()
	if (source_atom)
		LAZYREMOVE(source_atom.light_sources, src)

	if (top_atom)
		LAZYREMOVE(top_atom.light_sources, src)

	if (needs_update)
		SSlighting.sources_queue -= src

	top_atom = null
	source_atom = null
	source_turf = null
	pixel_turf = null

	return ..()

// Yes this doesn't align correctly on anything other than 4 width tabs.
// If you want it to go switch everybody to elastic tab stops.
// Actually that'd be great if you could!
#define EFFECT_UPDATE(level)                \
	if (needs_update == LIGHTING_NO_UPDATE) \
		SSlighting.sources_queue += src; \
	if (needs_update < level)               \
		needs_update = level;    \


// This proc will cause the light source to update the top atom, and add itself to the update queue.
/datum/light_source/proc/update(atom/new_top_atom)
	// This top atom is different.
	if (new_top_atom && new_top_atom != top_atom)
		if(top_atom != source_atom && top_atom.light_sources) // Remove ourselves from the light sources of that top atom.
			LAZYREMOVE(top_atom.light_sources, src)

		top_atom = new_top_atom

		if (top_atom != source_atom)
			LAZYADD(top_atom.light_sources, src) // Add ourselves to the light sources of our new top atom.

	EFFECT_UPDATE(LIGHTING_CHECK_UPDATE)

// Will force an update without checking if it's actually needed.
/datum/light_source/proc/force_update()
	EFFECT_UPDATE(LIGHTING_FORCE_UPDATE)

// Will cause the light source to recalculate turfs that were removed or added to visibility only.
/datum/light_source/proc/vis_update()
	EFFECT_UPDATE(LIGHTING_VIS_UPDATE)

// Macro that applies light to a new corner.
// It is a macro in the interest of speed, yet not having to copy paste it.
// If you're wondering what's with the backslashes, the backslashes cause BYOND to not automatically end the line.
// As such this all gets counted as a single line.
// The braces and semicolons are there to be able to do this on a single line.
#define LUM_FALLOFF(C, T) (1 - CLAMP01(sqrt((C.x - T.x) ** 2 + (C.y - T.y) ** 2) / max(1, light_range)))

#define APPLY_CORNER(C)                          \
	. = LUM_FALLOFF(C, pixel_turf);              \
	. *= light_power;                            \
	var/OLD = effect_str[C];                     \
	                                             \
	C.update_lumcount                            \
	(                                            \
		(. * lum_r) - (OLD * applied_lum_r),     \
		(. * lum_g) - (OLD * applied_lum_g),     \
		(. * lum_b) - (OLD * applied_lum_b)      \
	);                                           \

#define REMOVE_CORNER(C)                         \
	. = -effect_str[C];                          \
	C.update_lumcount                            \
	(                                            \
		. * applied_lum_r,                       \
		. * applied_lum_g,                       \
		. * applied_lum_b                        \
	);

/// This is the define used to calculate falloff.
/datum/light_source/proc/remove_lum()
	applied = FALSE
	for (var/datum/lighting_corner/corner as anything in effect_str)
		REMOVE_CORNER(corner)
		LAZYREMOVE(corner.affecting, src)

	effect_str = null

/datum/light_source/proc/recalc_corner(datum/lighting_corner/corner)
	LAZYINITLIST(effect_str)
	if (effect_str[corner]) // Already have one.
		REMOVE_CORNER(corner)
		effect_str[corner] = 0

	APPLY_CORNER(corner)
	effect_str[corner] = .

#define POLAR_TO_CART_X(R,T) ((R) * cos(T))
#define POLAR_TO_CART_Y(R,T) ((R) * sin(T))
#define MINMAX(NUM) ((NUM) < 0 ? -round(-(NUM)) : round(NUM))
#define ARBITRARY_NUMBER 10

/datum/light_source/proc/regenerate_angle(ndir)
	old_direction = ndir

	cached_origin_x = test_x_offset = source_turf.x
	cached_origin_y = test_y_offset = source_turf.y

	var/limit_a_t
	var/limit_b_t

	var/angle = light_angle * 0.5
	switch (old_direction)
		if (NORTH)
			limit_a_t = angle + 90
			limit_b_t = -(angle) + 90
			test_y_offset += 1

		if (SOUTH)
			limit_a_t = (angle) - 90
			limit_b_t = -(angle) - 90
			test_y_offset -= 1

		if (EAST)
			limit_a_t = angle
			limit_b_t = -(angle)
			test_x_offset += 1

		if (WEST)
			limit_a_t = angle + 180
			limit_b_t = -(angle) - 180
			test_x_offset -= 1

	// Convert our angle + range into a vector.
	limit_a_x = POLAR_TO_CART_X(light_range + ARBITRARY_NUMBER, limit_a_t)
	limit_a_x = MINMAX(limit_a_x)
	limit_a_y = POLAR_TO_CART_Y(light_range + ARBITRARY_NUMBER, limit_a_t)
	limit_a_y = MINMAX(limit_a_y)
	limit_b_x = POLAR_TO_CART_X(light_range + ARBITRARY_NUMBER, limit_b_t)
	limit_b_x = MINMAX(limit_b_x)
	limit_b_y = POLAR_TO_CART_Y(light_range + ARBITRARY_NUMBER, limit_b_t)
	limit_b_y = MINMAX(limit_b_y)

#undef ARBITRARY_NUMBER
#undef POLAR_TO_CART_X
#undef POLAR_TO_CART_Y
#undef MINMAX

/datum/light_source/proc/update_corners()
	var/update = FALSE
	var/atom/source_atom = src.source_atom

	if (QDELETED(source_atom))
		qdel(src)
		return

	if (source_atom.light_power != light_power)
		light_power = source_atom.light_power
		update = TRUE

	if (source_atom.light_range != light_range)
		light_range = source_atom.light_range
		update = TRUE

	if (!top_atom)
		top_atom = source_atom
		update = TRUE

	if (!light_range || !light_power)
		qdel(src)
		return

	if (isturf(top_atom))
		if (source_turf != top_atom)
			source_turf = top_atom
			pixel_turf = source_turf
			update = TRUE
	else if (top_atom.loc != source_turf)
		source_turf = top_atom.loc
		pixel_turf = get_turf_pixel(top_atom)
		update = TRUE
	else
		var/pixel_loc = get_turf_pixel(top_atom)
		if (pixel_loc != pixel_turf)
			pixel_turf = pixel_loc
			update = TRUE

	if (!isturf(source_turf))
		if (applied)
			remove_lum()
		return

	if (light_range && light_power && !applied)
		update = TRUE

	if (source_atom.light_color != light_color)
		light_color = source_atom.light_color
		PARSE_LIGHT_COLOR(src)
		update = TRUE

	else if (applied_lum_r != lum_r || applied_lum_g != lum_g || applied_lum_b != lum_b)
		update = TRUE

	if (source_atom.light_wedge != light_angle)
		light_angle = source_atom.light_wedge
		update = TRUE

	if (light_angle)
		var/ndir
		if (istype(top_atom, /mob) && top_atom:facing_dir)
			ndir = top_atom:facing_dir
		else
			ndir = top_atom.dir

		if (old_direction != ndir)	// If our direction has changed, we need to regenerate all the angle info.
			regenerate_angle(ndir)
			update = TRUE
		else // Check if it was just a x/y translation, and update our vars without an regenerate_angle() call if it is.
			if (source_turf.x != cached_origin_x)
				test_x_offset += source_turf.x - cached_origin_x
				cached_origin_x = source_turf.x

			if (source_turf.y != cached_origin_y)
				test_y_offset += source_turf.y - cached_origin_y
				cached_origin_y = source_turf.y

	if (update)
		needs_update = LIGHTING_CHECK_UPDATE
		applied = TRUE
	else if (needs_update == LIGHTING_CHECK_UPDATE)
		return //nothing's changed

	var/list/datum/lighting_corner/corners = list()
	if (source_turf)
		var/turf/T
		var/turf/T_origin
		var/test_x
		var/test_y
		FOR_DVIEW(T, CEILING(light_range, 1), source_turf, 0)
			T_origin = T
			do
				if (light_angle)	// Directional lighting coordinate filter.
					test_x = T.x - test_x_offset
					test_y = T.y - test_y_offset

					// If the signs of these are the same, then the point is within the cone.
					if ((DETERMINANT(limit_a_x, limit_a_y, test_x, test_y) > 0) || DETERMINANT(test_x, test_y, limit_b_x, limit_b_y) > 0)
						continue

				if (!IS_OPAQUE_TURF(T))
					if (!T.lighting_corners_initialised)
						T.generate_missing_corners()
					corners[T.lighting_corner_NE] = 0
					corners[T.lighting_corner_SE] = 0
					corners[T.lighting_corner_SW] = 0
					corners[T.lighting_corner_NW] = 0

			//  This is a do-while associated with the FOR_DVIEW above.
			while (T && isopenspace(T) && (T = GetBelow(T)))
			T = T_origin
			while ((T = GetAbove(T)) && T && isopenspace(T))
				if (light_angle)	// Directional lighting coordinate filter.
					test_x = T.x - test_x_offset
					test_y = T.y - test_y_offset

					// If the signs of these are the same, then the point is within the cone.
					if ((DETERMINANT(limit_a_x, limit_a_y, test_x, test_y) > 0) || DETERMINANT(test_x, test_y, limit_b_x, limit_b_y) > 0)
						continue

				if (!IS_OPAQUE_TURF(T))
					if (!T.lighting_corners_initialised)
						T.generate_missing_corners()
					corners[T.lighting_corner_NE] = 0
					corners[T.lighting_corner_SE] = 0
					corners[T.lighting_corner_SW] = 0
					corners[T.lighting_corner_NW] = 0
		END_FOR_DVIEW

	var/list/datum/lighting_corner/new_corners = (corners - effect_str)
	LAZYINITLIST(effect_str)
	if (needs_update == LIGHTING_VIS_UPDATE)
		for (var/datum/lighting_corner/corner as anything in new_corners)
			APPLY_CORNER(corner)
			if (. != 0)
				LAZYADD(corner.affecting, src)
				effect_str[corner] = .
	else
		for (var/datum/lighting_corner/corner as anything in new_corners)
			APPLY_CORNER(corner)
			if (. != 0)
				LAZYADD(corner.affecting, src)
				effect_str[corner] = .

		for (var/datum/lighting_corner/corner as anything in corners - new_corners) // Existing corners
			APPLY_CORNER(corner)
			if (. != 0)
				effect_str[corner] = .
			else
				LAZYREMOVE(corner.affecting, src)
				effect_str -= corner

	var/list/datum/lighting_corner/gone_corners = effect_str - corners
	for (var/datum/lighting_corner/corner as anything in gone_corners)
		REMOVE_CORNER(corner)
		LAZYREMOVE(corner.affecting, src)
	effect_str -= gone_corners

	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

	UNSETEMPTY(effect_str)

#undef EFFECT_UPDATE
#undef LUM_FALLOFF
#undef REMOVE_CORNER
#undef APPLY_CORNER
#undef DETERMINANT
