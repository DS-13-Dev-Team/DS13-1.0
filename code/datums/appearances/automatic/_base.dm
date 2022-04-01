/decl/appearance_handler
	var/priority = 15
	var/list/appearance_sources

/decl/appearance_handler/New()
	..()
	appearance_sources = list()

/decl/appearance_handler/proc/AddAltAppearance(var/source, var/list/images, var/list/viewers = list())
	if(source in appearance_sources)
		return FALSE
	appearance_sources[source] = new/datum/appearance_data(images, viewers, priority)
	RegisterSignal(source, COMSIG_PARENT_QDELETING, .proc/RemoveAltAppearance)

/decl/appearance_handler/proc/RemoveAltAppearance(var/source)
	SIGNAL_HANDLER
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		UnregisterSignal(source, COMSIG_PARENT_QDELETING)
		appearance_sources -= source
		qdel(ad)

/decl/appearance_handler/proc/DisplayAltAppearanceTo(var/source, var/viewer)
	var/datum/appearance_data/ad = appearance_sources[source]
	if(ad)
		ad.AddViewer(viewer)

/decl/appearance_handler/proc/DisplayAllAltAppearancesTo(var/viewer)
	for(var/entry in appearance_sources)
		DisplayAltAppearanceTo(entry, viewer)
