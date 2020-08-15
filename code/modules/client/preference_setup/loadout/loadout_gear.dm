/*


*/



/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/description        //Description of this gear. If left blank will default to the description of the pathed item.
	var/path               //Path to item.
	var/cost = 1           //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/list/allowed_branches //Service branches that can spawn with it.
	var/whitelisted        //Term to check the whitelist for..
	var/patron_only
	var/sort_category = "General"
	var/flags              //Special tweaks in new
	var/category
	var/list/gear_tweaks = list() //List of datums which will alter the item after it has been spawned.


	//Tag Handling
	var/list/tags	= list()	//Tags that this thing has
	var/list/exclusion_tags = list()	//List of tags which exclude this. If something with one of these tags already exists in the loadout, this cant be chosen
	var/list/required_tags = list()	//List of tags we need. The loadout must contain all tags in this list, or this cant be chosen

/datum/gear/New()
	if(FLAGS_EQUALS(flags, GEAR_HAS_TYPE_SELECTION|GEAR_HAS_SUBTYPE_SELECTION))
		CRASH("May not have both type and subtype selection tweaks")
	if(!description)
		var/obj/O = path
		description = initial(O.desc)

	//Initialize gear tweaks
	var/list/typepaths = gear_tweaks.Copy()
	gear_tweaks = list()
	for (var/thing in typepaths)
		if (ispath(thing))
			gear_tweaks += new thing()
		else
			gear_tweaks += thing	//Incase it did its own initializing

	if(flags & GEAR_HAS_COLOR_SELECTION)
		gear_tweaks += gear_tweak_free_color_choice()
	if(flags & GEAR_HAS_TYPE_SELECTION)
		gear_tweaks += new/datum/gear_tweak/path/type(path)
	if(flags & GEAR_HAS_SUBTYPE_SELECTION)
		gear_tweaks += new/datum/gear_tweak/path/subtype(path)

/datum/gear/proc/get_description(var/metadata)
	. = description
	for(var/datum/gear_tweak/gt in gear_tweaks)
		. = gt.tweak_description(., metadata["[gt]"])

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path, var/location)
	src.path = path
	src.location = location

/datum/gear/proc/spawn_item(var/location, var/metadata)
	var/datum/gear_data/gd = new(path, location)
	if (metadata)
		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_gear_data(metadata["[gt]"], gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(item, (metadata ? metadata["[gt]"] : null), location)
	return item

/datum/gear/proc/spawn_on_mob(var/mob/living/carbon/human/H, var/metadata)

	var/obj/item/item = spawn_item(H, metadata)

	//Slot is typically a single slot, but it may be a list of possible options
	var/list/slots = list()
	slots += slot
	var/result = FALSE
	for (var/slot_type in slots)
		result = H.equip_to_slot_if_possible(item, slot, del_on_fail = 1, force = 1)
		if (result)
			break
	if(result)
		to_chat(H, "<span class='notice'>Equipping you with \the [item]!</span>")

		for(var/datum/gear_tweak/gt in gear_tweaks)
			gt.tweak_postequip(H, item, slot)
		return TRUE

	return FALSE

/datum/gear/proc/spawn_in_storage_or_drop(var/mob/living/carbon/human/H, var/metadata)
	var/obj/item/item = spawn_item(H, metadata)

	var/atom/placed_in = H.equip_to_storage(item)
	if(placed_in)
		to_chat(H, "<span class='notice'>Placing \the [item] in your [placed_in.name]!</span>")
	else if(H.equip_to_appropriate_slot(item))
		to_chat(H, "<span class='notice'>Placing \the [item] in your inventory!</span>")
	else if(H.put_in_hands(item))
		to_chat(H, "<span class='notice'>Placing \the [item] in your hands!</span>")
	else
		to_chat(H, "<span class='danger'>Dropping \the [item] on the ground!</span>")
		item.forceMove(get_turf(H))
		item.add_fingerprint(H)
