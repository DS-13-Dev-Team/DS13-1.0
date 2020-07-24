/*
	Applied to an object when gripping it with kinesis

	Handles visual effects
*/
/datum/extension/kinesis_gripped
	name = "Kinesis Grip"
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE

	var/cached_scale
	var/cached_alpha

	//The graphical filter we assigned to the held item
	var/dm_filter/ripple
	var/dm_filter/outline


	var/atom/movable/subject


/datum/extension/kinesis_gripped/New(var/holder)
	.=..()
	subject = holder

	ripple = filter(type = "ripple", radius = 0, size = 8)
	subject.filters.Add(ripple)
	ripple = subject.filters[subject.filters.len]
	animate(ripple, radius = 16, size = 1, time = 4, loop = -1, flags = ANIMATION_PARALLEL)

	outline = filter(type = "outline", size = 3, color = COLOR_PALE_BLUE_GRAY, alpha = 128)
	subject.filters.Add(outline)
	outline = subject.filters[subject.filters.len]

	cached_alpha = subject.default_alpha
	cached_scale = subject.default_scale
	subject.default_alpha *= 0.5
	subject.default_scale += 0.15

	subject.animate_to_default(3, FALSE)

/datum/extension/kinesis_gripped/Destroy()
	if (subject)
		subject.filters.Remove(ripple)
		subject.filters.Remove(outline)
		subject.default_alpha = cached_alpha
		subject.default_scale = cached_scale
		subject.animate_to_default(3, FALSE)
	.=..()