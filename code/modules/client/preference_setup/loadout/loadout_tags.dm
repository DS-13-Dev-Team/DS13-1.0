/*
	Loadout tags are used to handle exclusions in equipment when mixing stuff
*/
GLOBAL_LIST_EMPTY(loadout_tag_cache)

//Takes a typepath of an item
/proc/get_loadout_tags_from_type(var/itempath)
	var/obj/item/I = itempath

	//If loadout tags is the special value, we do stuff
	if (initial(I.loadout_tags) == LOADOUT_TAG_SPECIAL)
		//See if its already cached
		if (GLOB.loadout_tag_cache[itempath])
			return GLOB.loadout_tag_cache[itempath]
		else
			I = new itempath
			GLOB.loadout_tag_cache[itempath] = I.get_loadout_tags()
			return GLOB.loadout_tag_cache[itempath]

	//If its a list we return that
	else if (LAZYLEN(initial(I.loadout_tags)))
		return initial(I.loadout_tags)
	return list()



/obj/item/

	//This is a list of the tags this object has. If set, these tags will be added to the loadout.
	//Alternatively, you can set this value to LOADOUT_TAG_SPECIAL. This will cause the item to be instanced and asked for its tags
	var/list/loadout_tags


//If an item has loadout_tags == LOADOUT_TAG_SPECIAL, it is instanced and this proc is called to ask it what tags it has.
//This is only done once per session, the result will be cached in a global list and used in future, so it isnt situational and accepts no outside data
//This proc is intended for things that modify themselves during initialisation, like rigs with preinstalled modules, or armor with preinstalled armor parts
/obj/item/proc/get_loadout_tags()
	return loadout_tags



/*
	RIGS
*/
/obj/item/weapon/rig
	loadout_tags = LOADOUT_TAG_SPECIAL

/*
	Rigs combine the tags of their modules
*/
/obj/item/weapon/rig/get_loadout_tags()
	var/list/tags = list(LOADOUT_TAG_RIG)
	for (var/obj/item/rig_module/RM in installed_modules)
		tags |= RM.get_loadout_tags()

	return tags