/***************************************************************
**						Design Datums						  **
**				All the data for building stuff. 			  **
***************************************************************/

/*

Design Guidlines
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- If

*/
// Note: More then one of these can be added to a design.

// Datum for object designs, used in construction
/datum/design
	// Name of the created object. If null, it will be 'guessed' from build_path if possible.
	var/name
	// An item name before it is modified by various name-modifying procs.
	var/item_name
	// Description of the created object. If null, it'll generate pick build_path atom description.
	// Should be less then 100 characters.
	var/desc
	//
	var/full_desc
	// ID of the created object for easy refernece. If null, uses typepath instead.
	var/id

	// A list of ckeys who are the only ones that can buy this in stores. Not used in lathing.
	var/list/whitelist
	// If true, only patrons can buy this in stores.
	var/patron_only = FALSE
	// A patron item datum used to manage access.
	var/datum/patron_item/PI

	// List of materials. Format: "id" = amount.
	var/list/materials = list()
	// List of reagents. Format: "id" = amount.
	var/list/chemicals = list()
	// The path of the object that gets created.
	var/build_path
	// Flag as to what kind machine the design is built in. See defines.
	var/build_type = PROTOLATHE
	// Used to sort designs
	var/category = "Misc"
	// How many ticks it requires to build
	var/time

	// Pre-generated UI data, to be sent into NanoUI/TGUI interfaces.
	var/list/ui_data

	// An MPC file containing this design.
	// You can use it directly, but only if it doesn't interact with the rest of MPC system. If it does, use copies.
	var/datum/computer_file/binary/design/file

	// What does it cost to buy this from the store?
	var/price = 1000
	// How many times in the current round has this been bought from a store?
	var/store_purchases	= 0
	// The price of the item increases by this % every time it is purchased.
	var/demand_scaling = 0.02

	// If true does not require any technologies and unlocked from the start.
	var/starts_unlocked = FALSE

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo(atom/movable/temp_atom)
	if(!temp_atom)
		temp_atom = Fabricate()

	AssembleDesignName(temp_atom)
	AssembleDesignDesc(temp_atom)
	AssembleDesignId()
	AssembleDesignTime()
	AssembleDesignFile()
	AssembleDesignUIData(temp_atom)

	if (temp_atom)
		qdel(temp_atom)

/datum/design/autolathe/AssembleDesignInfo(atom/movable/temp_atom)
	temp_atom = Fabricate()
	if(istype(temp_atom, /obj))
		for(var/obj/O in temp_atom.GetAllContents(includeSelf = TRUE))
			AddObjectMaterials(O)
	return ..()

//Add materials and reagents from object to the recipe
/datum/design/proc/AddObjectMaterials(obj/O)
	var/multiplier = 1

	// If stackable, we want to multiply materials by amount
	if(istype(O, /obj/item/stack))
		var/obj/item/stack/stack = O
		multiplier = stack.get_amount()

	var/list/mats = O.matter
	if (mats && mats.len)

		for(var/a in mats)

			var/amount = mats[a] * multiplier
			if(amount)
				LAZYAPLUS(materials, a, amount)

	mats = O.matter_reagents
	if (mats && mats.len)
		for(var/a in mats)
			var/amount = mats[a] * multiplier
			if(amount)
				LAZYAPLUS(chemicals, a, amount)

/datum/design/proc/get_price(var/mob/user)
	.=price
	if (store_purchases && demand_scaling)
		. *= 1 + (demand_scaling * store_purchases)

	// TODO Future: Discounts based on user's job or skills?

// Get name from build path if possible
/datum/design/proc/AssembleDesignName(atom/temp_atom)
	if(!name && temp_atom)
		name = temp_atom.name

	item_name = name

	name = capitalize(name)

// Try to make up a nice description if we don't have one.
/datum/design/proc/AssembleDesignDesc(atom/temp_atom)
	if(!desc)
		desc = temp_atom.desc

	full_desc = desc
	if(length_char(desc) > 100)
		desc = copytext_char(desc, 1, 98)
		if(findtext_char(desc, " ", -1))
			desc = copytext_char(desc, 1, 97)

		desc += "..."

// Calculate design time from the amount of materials and chemicals used.
/datum/design/proc/AssembleDesignTime()
	if(time)
		return

	var/total_materials = 0
	var/total_reagents = 0

	for(var/m in materials)
		total_materials += (materials[m] / 250)

	for(var/c in chemicals)
		total_reagents += chemicals[c]

	time = 5 + total_materials + (total_reagents / 5)
	time = max(round(time), 5)

// By default, ID is just design's type.
/datum/design/proc/AssembleDesignId()
	if(id)
		return
	id = sanitizeSafe(input = sanitizeFileName("[type]", list("/"="-")), max_length = MAX_MESSAGE_LEN, encode = FALSE, trim = TRUE, extra = TRUE, allow_links = FALSE)

//Gets the default ID for a design from a typepath
/proc/get_design_id_from_type(var/design_type)
	var/datum/design/D = design_type
	if (initial(D.id))
		return initial(D.id)
	else
		return sanitizeSafe(input = sanitizeFileName("[design_type]", list("/"="-")), max_length = MAX_MESSAGE_LEN, encode = FALSE, trim = TRUE, extra = TRUE, allow_links = FALSE)

/datum/design/proc/AssembleDesignUIData(atom/temp)
	ui_data = list(
		"id" = id,
		"name" = name,
		"desc" = desc,
		"full_desc" = full_desc,
		"category" = category,
		"price" = price,
		"time" = time,
	)

	var/icon/I = icon(getFlatTypeIcon(temp.type))

	ui_data["icon_width"] = I.Width()*3
	ui_data["icon_height"] = I.Height()*3

/datum/design/proc/AssembleDesignFile()
	var/datum/computer_file/binary/design/design_file = new
	design_file.design = src
	design_file.on_design_set()
	file = design_file

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(newloc, mat_efficiency = 1, fabricator)
	if(!build_path)
		return

	var/atom/A = new build_path(newloc)
	A.Created()

	if(mat_efficiency != 1 && isobj(A))
		var/obj/O = A
		if(length(O.matter))
			for(var/i in O.matter)
				O.matter[i] = round(O.matter[i] * mat_efficiency, 0.01)

	return A

// Same as above but for store
/datum/design/proc/CreatedInStore(store_ref)
	. = build_path ? new build_path(store_ref) : null


/datum/design/autolathe
	build_type = AUTOLATHE

/datum/design/autolathe/corrupted
	name = "ERROR"
	build_path = /obj/item/material/shard/shrapnel

