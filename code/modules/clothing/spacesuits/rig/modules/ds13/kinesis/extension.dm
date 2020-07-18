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
	var/dm_filter/filter


	var/atom/movable/subject


/datum/extension/kinesis_gripped/New(var/holder)
	.=..()
	subject = holder
	filter = filter(type = "ripple", radius = 0, size = 1)
	subject.filters.Add(filter)
	animate(filter, radius = 2, size = 0, time = 3, loop = -1)

	cached_alpha = subject.default_alpha
	cached_scale = subject.default_scale
	subject.default_alpha *= 0.5
	subject.default_scale += 0.15

/datum/extension/kinesis_gripped/Destroy()
	if (subject)
		subject.filters.Remove(filter)
		subject.default_alpha = cached_alpha
		subject.default_scale = cached_scale

	QDEL_NULL(filter)