#define CHUNK_SIZE 16 // Only chunk sizes that are to the power of 2. E.g: 2, 4, 8, 16, etc..

// CAMERA CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Marker Eyes to stream these chunks and know what it can and cannot see.

/datum/markerchunk
	/// Visible turfs in this chunk
	var/list/visibleTurfs
	/// Assoc list of the form: list(source = list(turfs source can see in this chunk))
	/// Contains all vision sources
	var/list/visionSources
	/// Vision sources that don't update in hasChanged
	var/list/rangeVisionSources
	/// Vision sources that update in hasChanged
	var/list/viewVisionSources
	/// List of all turfs = image that masks static
	var/list/turfs
	/// List of active images, i.e list of masks for visible turfs
	var/list/active_masks
	/// Camera mobs that can see turfs in our chunk
	var/list/seenby
	/// Lazy list, In update() things in it will reculculate what turfs they can see
	var/list/queued_for_update

	var/x = 0
	var/y = 0
	var/z = 0

/// Create a new camera chunk, since the chunks are made as they are needed.
/datum/markerchunk/New(x, y, z, list/netVisionSources, image/example)
	visibleTurfs = list()
	visionSources = list()
	rangeVisionSources = list()
	viewVisionSources = list()
	turfs = list()
	active_masks = list()
	seenby = list()

	x &= ~(CHUNK_SIZE - 1)
	y &= ~(CHUNK_SIZE - 1)

	src.x = x
	src.y = y
	src.z = z

	for(var/turf/t as anything in block(locate(max(x, 1), max(y, 1), z), locate(min(x + CHUNK_SIZE - 1, world.maxx), min(y + CHUNK_SIZE - 1, world.maxy), z)))
		turfs[t] = image(example, t)

	var/turf/centre_turf = locate(x + (CHUNK_SIZE / 2), y + (CHUNK_SIZE / 2), z)
	for(var/atom/source as anything in netVisionSources)
		if(!IN_GIVEN_RANGE(source, centre_turf, CHUNK_SIZE))
			continue

		var/list/visible = list()
		visionSources[source] = visible
		for(var/turf/vis_turf as anything in (source.get_visualnet_tiles() & turfs))
			visible += vis_turf
			visibleTurfs |= vis_turf
			active_masks |= turfs[vis_turf]

		var/vision_type = netVisionSources[source]
		if(vision_type == VISION_SOURCE_RANGE)
			rangeVisionSources += source
		else if(vision_type == VISION_SOURCE_VIEW)
			viewVisionSources += source

/datum/markerchunk/Destroy(force, ...)
	remove(seenby)
	active_masks = null
	turfs = null
	return ..()

/// Add a Marker eye to the chunk
/datum/markerchunk/proc/add(list/eyes)
	if(!islist(eyes))
		eyes = list(eyes)
	for(var/mob/dead/observer/signal/eye as anything in eyes)
		eye.visibleChunks += src
		seenby += eye
		if(queued_for_update)
			update()
		eye.client?.images += active_masks

//The same as add(list/eyes) expect it also does the safety checks
/datum/markerchunk/proc/safeAdd(list/eyes)
	if(!islist(eyes))
		eyes = list(eyes)
	for(var/mob/dead/observer/signal/eye as anything in eyes)
		if(src.z != eye.z)
			continue
		var/static_range = eye.static_visibility_range
		if(x > (min(world.maxx, eye.x + static_range) & ~(CHUNK_SIZE - 1)))
			continue
		if(x < (max(0, eye.x - static_range) & ~(CHUNK_SIZE - 1)))
			continue
		if(y > (min(world.maxy, eye.y + static_range) & ~(CHUNK_SIZE - 1)))
			continue
		if(y < (max(0, eye.y - static_range) & ~(CHUNK_SIZE - 1)))
			continue

		eye.visibleChunks += src
		seenby += eye
		if(queued_for_update)
			update()
		eye.client?.images += active_masks

/// Remove a Marker eye from the chunk
/datum/markerchunk/proc/remove(list/eyes)
	if(!islist(eyes))
		eyes = list(eyes)
	for(var/mob/dead/observer/signal/eye as anything in eyes)
		eye.visibleChunks -= src
		seenby -= eye
		eye.client?.images -= active_masks

/*
 * Updates the chunk if it's watched, otherwise queued until Marker eye sees it
 */
/datum/markerchunk/proc/hasChanged(list/to_update)
	LAZYOR(queued_for_update, to_update)
	if(length(seenby))
		update()

/// The actual updating. It only updates vision sources in var/list/queued_for_update
/datum/markerchunk/proc/update()
	if(!queued_for_update)
		return

	for(var/mob/dead/observer/signal/client_eye as anything in seenby)
		client_eye.client?.images -= active_masks

	var/turf/point = locate(src.x + (CHUNK_SIZE / 2), src.y + (CHUNK_SIZE / 2), src.z)
	for(var/atom/source as anything in queued_for_update)
		if(!IN_GIVEN_RANGE(point, source, CHUNK_SIZE + (CHUNK_SIZE / 2)))
			visionSources -= source
			rangeVisionSources -= source
			viewVisionSources -= source
			continue
		var/list/visible = list()
		visionSources[source] = visible
		for(var/turf/vis_turf as anything in (source.get_visualnet_tiles() & turfs))
			visible += vis_turf

	visibleTurfs.Cut()
	active_masks.Cut()

	for(var/atom/source as anything in visionSources)
		visibleTurfs |= visionSources[source]

	for(var/turf/vis_turf as anything in visibleTurfs)
		active_masks += turfs[vis_turf]

	for(var/mob/dead/observer/signal/client_eye as anything in seenby)
		client_eye.client?.images += active_masks

	queued_for_update = null
