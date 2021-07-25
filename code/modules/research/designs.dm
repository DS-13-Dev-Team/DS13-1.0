/***************************************************************
**						Design Datums						  **
**	All the data for building stuff. 						  **
***************************************************************/

/*

Design Guidlines
- Materials are automatically read from the result item. Any material/chemical requirements specified in these datums are extras added to that
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/datum/design						//Datum for object designs, used in construction
	var/name = null					//Name of the created object. If null, it will be 'guessed' from build_path if possible.
	var/item_name = null			//An item name before it is modified by various name-modifying procs
	var/name_category = null		//If set, name is modified into "[name_category] ([item_name])"
	var/desc = "No description set"	//Description of the created object. If null, it will use group_desc and name where applicable.
	var/id = null					//ID of the created object for easy refernece. If null, uses typepath instead.
	var/sort_string = "ZZZZZ"		//Sorting order

	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of reagents. Format: "id" = amount. DON'T USE IN PROTOLATHE DESIGNS!
	var/build_path = null			//The path of the object that gets created.
	var/build_type = PROTOLATHE		//Flag as to what kind machine the design is built in. See defines.
	var/category = "Misc"			//Used to sort designs
	var/time = 0					//How many ticks it requires to build. If 0, calculated from the amount of materials used.

	var/list/ui_data = null			//Pre-generated UI data, to be sent into NanoUI/TGUI interfaces.

	// An MPC file containing this design. You can use it directly, but only if it doesn't interact with the rest of MPC system. If it does, use copies.
	var/datum/computer_file/binary/design/file

	var/price = 1000	//What does it cost to buy this from the store?
	var/store_purchases	=	0	//How many times in the current round has this been bought from a store?
	var/demand_scaling = 0.02	//The price of the item increases by this % every time it is purchased

	//When this design is bought at the store, can we do a makeover/transfer to equip it?
	//Only true for RIGs and rig modules
	var/store_transfer	= FALSE
	var/starts_unlocked = FALSE     //If true does not require any technologies and unlocked from the start

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	var/atom/movable/temp_atom = Fabricate(null, 1, null)
	if(build_path)
		temp_atom = Fabricate(null, 1, null)

	AssembleDesignName(temp_atom)
	AssembleDesignMaterials(temp_atom)
	AssembleDesignTime(temp_atom)
	AssembleDesignDesc(temp_atom)
	AssembleDesignId(temp_atom)
	AssembleDesignUIData(temp_atom)

	if (temp_atom)
		qdel(temp_atom)

/datum/design/proc/get_price(var/mob/user)


	.=price
	if (store_purchases && demand_scaling)
		. *= 1 + (demand_scaling * store_purchases)

	//TODO Future: Discounts based on user's job or skills?


//Get name from build path if possible
/datum/design/proc/AssembleDesignName(atom/temp_atom)
	if(!name && temp_atom)
		name = temp_atom.name

	item_name = name

	if(name_category)
		name = "[name_category] ([item_name])"

	name = capitalize(name)

//Try to make up a nice description if we don't have one
/datum/design/proc/AssembleDesignDesc(atom/temp_atom)
	if(desc)
		return
	if(!desc && temp_atom)
		desc = temp_atom.desc

//Extract matter and reagent requirements from the target object and any objects inside it.
//Any materials specified in these designs are extras, added on top of what is extracted.
/datum/design/proc/AssembleDesignMaterials(atom/temp_atom)
	if(istype(temp_atom, /obj))
		for(var/obj/O in temp_atom.GetAllContents(includeSelf = TRUE))
			AddObjectMaterials(O)

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


//Calculate design time from the amount of materials and chemicals used.
/datum/design/proc/AssembleDesignTime()
	if(time)
		return

	var/total_materials = 0
	var/total_reagents = 0

	for(var/m in materials)
		total_materials += materials[m]

	for(var/c in chemicals)
		total_reagents += chemicals[c]

	time = 5 + total_materials + (total_reagents / 5)
	time = max(round(time), 5)

// By default, ID is just design's type.
/datum/design/proc/AssembleDesignId()
	if(id)
		return
	id = sanitizeSafe(input = "[type]", max_length = MAX_MESSAGE_LEN, encode = FALSE, trim = TRUE, extra = TRUE, allow_links = FALSE)

//Gets the default ID for a design from a typepath
/proc/get_design_id_from_type(var/design_type)
	var/datum/design/D = design_type
	if (initial(D.id))
		return initial(D.id)
	else
		return sanitizeSafe(input = "[design_type]", max_length = MAX_MESSAGE_LEN, encode = FALSE, trim = TRUE, extra = TRUE, allow_links = FALSE)


/datum/design/proc/AssembleDesignUIData()
	ui_data = list("id" = "[id]", "name" = name, "item_name" = (item_name ? item_name : name), "desc" = desc, "time" = time, "category" = category, "price" = price)

	// ui_data["icon"] is set in asset code.
	//"icon" = getAtomCacheFilename(CR.result),

	if(length(materials))
		var/list/RS = list()
		for(var/mat in materials)
			RS.Add(list(list("name" = mat, "req" = materials[mat])))
		ui_data["materials"] = RS

	if(length(chemicals))
		var/list/RS = list()

		for(var/reagent in chemicals)
			var/datum/reagent/RG = new reagent(TRUE)//Passing in true here prevents a runtime errror
			var/chemical_name = "UNKNOWN"
			if(RG)
				chemical_name = RG.name

			RS.Add(list(list("id" = reagent, "name" = chemical_name, "req" = chemicals[reagent])))

		ui_data["chemicals"] = RS


/datum/design/ui_data()
	return ui_data

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(newloc, mat_efficiency, fabricator)
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



/datum/design/autolathe
	build_type = AUTOLATHE

/datum/design/autolathe/corrupted
	name = "ERROR"
	build_path = /obj/item/weapon/material/shard/shrapnel


