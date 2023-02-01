// MARKER NET
//
// The datum containing all the chunks.
/datum/markernet
	/// Name to show for VV and stat()
	var/name = "Camera Net"
	/// The chunks of the map, mapping the areas that the cameras can see.
	var/list/chunks
	/// The image cloned by all chunk static images put onto turfs cameras cant see
	var/image/alpha_mask
	/// An assoc list of all vision source. vision_source = vision_type
	var/list/visionSources
	/// List of all eyes in our markernet, used when creating a new chunk
	var/list/eyes

/datum/markernet/New()
	chunks = list()
	visionSources = list()
	eyes = list()
	alpha_mask = image('icons/hud/alpha_mask.dmi', null, "alpha_mask")
	alpha_mask.plane = OBSCURITY_MASKING_PLANE
	alpha_mask.appearance_flags = RESET_TRANSFORM|RESET_ALPHA|RESET_COLOR|KEEP_APART

// Used only in one place, if you want it to use somewhere else - do safety checks first. e.g. chunkGenerated()
/datum/markernet/proc/generateChunk(x, y, z)
	x &= ~(CHUNK_SIZE - 1)
	y &= ~(CHUNK_SIZE - 1)
	return chunks["[x],[y],[z]"] = new /datum/markerchunk(x, y, z, visionSources, alpha_mask)

/// Checks if a chunk has been Generated in x, y, z.
/datum/markernet/proc/chunkGenerated(x, y, z)
	x &= ~(CHUNK_SIZE - 1)
	y &= ~(CHUNK_SIZE - 1)
	return chunks["[x],[y],[z]"]

/// Updates what the aiEye can see. It is recommended you use this when the aiEye moves or it's location is set.
/datum/markernet/proc/visibility(mob/dead/observer/signal/eye)
	var/list/visibleChunks = list()
	if(eye.loc)
		var/static_range = eye.static_visibility_range
		var/x1 = max(0, eye.x - static_range) & ~(CHUNK_SIZE - 1)
		var/y1 = max(0, eye.y - static_range) & ~(CHUNK_SIZE - 1)
		var/x2 = min(world.maxx, eye.x + static_range) & ~(CHUNK_SIZE - 1)
		var/y2 = min(world.maxy, eye.y + static_range) & ~(CHUNK_SIZE - 1)

		for(var/x = x1 to x2 step CHUNK_SIZE)
			for(var/y = y1 to y2 step CHUNK_SIZE)
				var/datum/markerchunk/chunk = chunkGenerated(x, y, eye.z)
				if(chunk)
					visibleChunks |= chunk

	var/list/remove = eye.visibleChunks - visibleChunks
	var/list/add = visibleChunks - eye.visibleChunks

	for(var/datum/markerchunk/chunk as anything in remove)
		chunk.remove(eye)

	for(var/datum/markerchunk/chunk as anything in add)
		chunk.add(eye)

/// Updates the chunks that the turf is located in. Use this when obstacles are destroyed or when doors open.
/datum/markernet/proc/updateVisibility(atom/A, opacity_check = 1)
	if(!SSticker || (opacity_check && !A.opacity))
		return
	var/turf/T = get_turf(A)
	if(!T)
		return
	var/x1 = max(0, T.x - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
	var/y1 = max(0, T.y - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
	var/x2 = min(world.maxx, T.x + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
	var/y2 = min(world.maxy, T.y + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
	for(var/x = x1 to x2 step CHUNK_SIZE)
		for(var/y = y1 to y2 step CHUNK_SIZE)
			var/datum/markerchunk/chunk = chunkGenerated(x, y, T.z)
			if(length(chunk?.viewVisionSources))
				chunk.hasChanged(chunk.viewVisionSources)

/// Adds a vision source to the visual net
/datum/markernet/proc/addVisionSource(atom/A, vision_type = VISION_SOURCE_RANGE, movable)
	if(visionSources[A])
		return
	var/turf/T = get_turf(A)
	visionSources[A] = vision_type
	RegisterSignal(A, COMSIG_PARENT_QDELETING, .proc/onSourceDestroy)
	if(T)
		var/x1 = max(0, T.x - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y1 = max(0, T.y - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/x2 = min(world.maxx, T.x + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y2 = min(world.maxy, T.y + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		for(var/x = x1 to x2 step CHUNK_SIZE)
			for(var/y = y1 to y2 step CHUNK_SIZE)
				var/datum/markerchunk/chunk = chunkGenerated(x, y, T.z)
				if(chunk)
					// We don't queue here to spread the load between different ticks
					var/list/visible = list()
					chunk.visionSources[A] = visible
					for(var/turf/vis_turf as anything in (A.get_visualnet_tiles() & chunk.turfs))
						visible += vis_turf
						chunk.visibleTurfs |= vis_turf
						chunk.active_masks |= chunk.turfs[vis_turf]
					for(var/mob/dead/observer/signal/eye as anything in chunk.seenby)
						eye.client?.images |= chunk.active_masks
					if(vision_type == VISION_SOURCE_RANGE)
						chunk.rangeVisionSources += A
					else if(vision_type == VISION_SOURCE_VIEW)
						chunk.viewVisionSources += A
				else
					chunk = generateChunk(x, y, T.z)
					chunk.safeAdd(eyes)
	if(movable)
		RegisterSignal(A, COMSIG_MOVABLE_MOVED, .proc/onSourceMove)

/// Removes a vision source from the visual net
/datum/markernet/proc/removeVisionSource(atom/A)
	if(!visionSources[A])
		return
	UnregisterSignal(A, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))
	visionSources -= A
	var/turf/T = get_turf(A)
	if(T)
		var/x1 = max(0, T.x - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y1 = max(0, T.y - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/x2 = min(world.maxx, T.x + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y2 = min(world.maxy, T.y + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)

		for(var/x = x1 to x2 step CHUNK_SIZE)
			for(var/y = y1 to y2 step CHUNK_SIZE)
				var/datum/markerchunk/chunk = chunkGenerated(x, y, T.z)
				if(chunk)
					chunk.visionSources -= A
					chunk.rangeVisionSources -= A
					chunk.viewVisionSources -= A
					if(chunk.queued_for_update)
						chunk.queued_for_update -= A
					if(length(chunk.visionSources))
						LAZYINITLIST(chunk.queued_for_update)
						if(length(chunk.seenby))
							chunk.update()
					else
						// We don't need empty chunks
						chunks -= "[x],[y],[T.z]"
						qdel(chunk)

/// Perhaps just make sure everything that can be in our visualnet calls removeVisionSource(src) in it's Destroy
/// and remove this signal
/datum/markernet/proc/onSourceDestroy(atom/source)
	SIGNAL_HANDLER
	removeVisionSource(source)

/datum/markernet/proc/onSourceMove(atom/movable/source, turf/old_loc)
	SIGNAL_HANDLER
	var/turf/new_loc = get_turf(source)
	if(new_loc == old_loc)
		return

	var/list/old_chunks = list()
	if(old_loc)
		var/x1 = max(0, old_loc.x - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y1 = max(0, old_loc.y - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/x2 = min(world.maxx, old_loc.x + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y2 = min(world.maxy, old_loc.y + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		for(var/x = x1 to x2 step CHUNK_SIZE)
			for(var/y = y1 to y2 step CHUNK_SIZE)
				var/datum/markerchunk/chunk = chunkGenerated(x, y, old_loc.z)
				if(chunk)
					old_chunks |= chunk

	var/list/new_chunks = list()
	if(new_loc)
		var/x1 = max(0, new_loc.x - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y1 = max(0, new_loc.y - (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/x2 = min(world.maxx, new_loc.x + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		var/y2 = min(world.maxy, new_loc.y + (CHUNK_SIZE / 2)) & ~(CHUNK_SIZE - 1)
		for(var/x = x1 to x2 step CHUNK_SIZE)
			for(var/y = y1 to y2 step CHUNK_SIZE)
				var/datum/markerchunk/chunk = chunkGenerated(x, y, new_loc.z)
				if(chunk)
					new_chunks |= chunk
				else
					// New chunks will handle our movement
					chunk = generateChunk(x, y, new_loc.z)
					chunk.safeAdd(eyes)

	for(var/datum/markerchunk/chunk as anything in old_chunks-new_chunks)
		chunk.visionSources -= source
		chunk.rangeVisionSources -= source
		chunk.viewVisionSources -= source
		if(chunk.queued_for_update)
			chunk.queued_for_update -= source
		if(length(chunk.visionSources))
			LAZYINITLIST(chunk.queued_for_update)
			if(length(chunk.seenby))
				chunk.update()
		else
			// We don't need empty chunks
			old_chunks -= chunk
			chunks -= "[chunk.x],[chunk.y],[chunk.z]"
			qdel(chunk)

	for(var/datum/markerchunk/chunk as anything in new_chunks-old_chunks)
		chunk.visionSources[source] = list()
		if(visionSources[source] == VISION_SOURCE_RANGE)
			chunk.rangeVisionSources += source
		else if(visionSources[source] == VISION_SOURCE_VIEW)
			chunk.viewVisionSources += source
		chunk.hasChanged(source)

/datum/markernet/proc/checkTurfVis(turf/position)
	var/datum/markerchunk/chunk = chunkGenerated(position.x, position.y, position.z)
	if(chunk)
		if(chunk.queued_for_update)
			chunk.update()
		if(position in chunk.visibleTurfs)
			return TRUE
	return FALSE

#undef CHUNK_SIZE
