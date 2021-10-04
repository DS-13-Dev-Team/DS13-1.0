//Access defines, one is applied to each distribution channel for obtaining the item. An item can have different access in different channels
#define ACCESS_PUBLIC	"public"
#define ACCESS_PATRONS	"patrons"
#define ACCESS_WHITELIST	"whitelist"
// Switch this out to use a database at some point. Each ckey is
// associated with a list of custom item datums. When the character
// spawns, the list is checked and all appropriate datums are spawned.
// See config/example/patron_items.txt for a more detailed overview
// of how the config system works.

// CUSTOM ITEM ICONS:
// Inventory icons must be in patron_item_OBJ with state name [item_icon].
// On-mob icons must be in patron_item_MOB with state name [item_icon].
// Inhands must be in patron_item_MOB as [icon_state]_l and [icon_state]_r.

// Kits must have mech icons in patron_item_OBJ under [kit_icon].
// Broken must be [kit_icon]-broken and open must be [kit_icon]-open.

// Kits must also have hardsuit icons in patron_item_MOB as [kit_icon]_suit
// and [kit_icon]_helmet, and in patron_item_OBJ as [kit_icon].

/var/list/patron_items = list()

/datum/patron_item
	var/name
	var/id	//Used to link whitelists to us and uniquely identify research designs. Mandatory for store listing
	var/inherit_inhands = 1 //if unset, and inhands are not provided, then the inhand overlays will be invisible.
	var/item_icon
	var/description

	var/category = "Misc"	//Used for store and loadout
	var/subcategory

	var/item_path = /obj/item
	var/item_path_as_string
	var/req_access = 0
	var/list/req_titles = list()
	var/kit_name
	var/kit_desc
	var/kit_icon
	var/additional_data




	/*
		New vars for DS13
	*/
	var/loadout_cost = null //If not null, this item can be purchased in the loadout for this many points
	var/loadout_access	=	null //One of the ACCESS_XXX defines above, determines who is allowed to buy this in loadout

	var/datum/gear/loadout_listing
	var/datum/design/store_listing

	var/store_cost = null //If not null, this item can be purchased in the store for this many credits
	var/store_access	=	null //One of the ACCESS_XXX defines above, determines who is allowed to buy this in store

	var/loadout_modkit_cost	=	null //If not null, a modkit to transform another item into this item can be purchased in the loadout for this many points
	var/modkit_access	=	null//One of the ACCESS_XXX defines above, determines who is allowed to buy this in store

	var/list/whitelist	=	null	//A list of ckeys who can use ACCESS_WHITELIST channels with this item



	/*
		This can be one of a few things:
			-A single typepath, or a list of typepaths, of items which the modkit can be applied to, to transform them into the desired item
			-A modkit typepath which is the exact type the modkit will be. This allows you to override procs and make more complex rules about application
	*/
	var/modkit_base	= null


/datum/patron_item/New()
	.=..()

	if (!isnull(loadout_cost) && !isnull(loadout_access))
		create_loadout_datum()

	if (!isnull(store_cost) && !isnull(store_access))
		create_store_datum()


/datum/patron_item/proc/set_whitelist(var/list/new_list)
	whitelist = new_list.Copy()

	if (loadout_listing)
		loadout_listing.key_whitelist = whitelist

	if (store_listing)
		store_listing.whitelist = whitelist

/datum/patron_item/proc/create_loadout_datum()
	var/datum/gear/G = new()
	G.display_name = src.name
	G.description = description
	G.path = item_path
	G.cost = loadout_cost
	G.category = src.category

	switch (loadout_access)
		if (ACCESS_PUBLIC)
			//do nothing
		if (ACCESS_PATRONS)
			G.patron_only = TRUE
		if (ACCESS_WHITELIST)
			G.key_whitelist = whitelist

	G.Initialize()

	GLOB.gear_datums[G.display_name] = G



/datum/patron_item/proc/create_store_datum()
	var/datum/design/D = new()

	D.name = name
	D.desc = description
	D.build_path = item_path
	D.price = store_cost
	D.build_type = STORE
	D.starts_unlocked = TRUE
	D.id = id
	D.category = src.category
	D.PI = src

	//TODO: Icons not working
	//TODO: Multiselection is happening
	//TODO: Set transfer setting if the item is a rig or module

	register_research_design(D)

	//If this has patron or whitelist access, put it in the limited store designs list
	if (store_access != ACCESS_PUBLIC)
		GLOB.limited_store_designs += D

	else
		GLOB.unlimited_store_designs += D


/*
	This proc loads whitelists for Patron items. It assumes that list is appropriately formatted according to the instructions in that file
*/
/proc/load_patron_item_whitelists()

	//The ID of the whitelist we are currently reading
	var/current_id

	//The list of keys in the whitelist
	var/list/current_list = list()

	for(var/line in splittext(file2text("config/custom_items.txt"), "\n"))

		line = trim(line)
		if(line == "" || !line || findtext(line, "#", 1, 2))
			continue



		var/list/split = splittext(line,regex(@"[ {},]"))
		if(!LAZYLEN(split))
			continue

		for (var/string in split)

			if (!length(string))
				continue

			//If we don't have an open list id yet, then this first word must be a new ID
			if (!current_id)
				current_id = string
				continue


			//Okay this string must be a ckey. Lets sanitise it with the ckey proc
			string = ckey(string)
			current_list += string

		//If there's a curly brace at the end of the line, it closes this list
		if (current_id && findtext(line, "}"))
			register_patron_whitelist(current_id, current_list)
			current_list = list()
			current_id = null


//Here we take an assembled whitelist and find which patron item it should attach to by matching the ID
/proc/register_patron_whitelist(current_id, list/current_list)


	for (var/datum/patron_item/PI in GLOB.patron_items)
		if (PI.id == current_id)
			PI.whitelist = current_list.Copy()

			//Lets add all these keys to the global list
			for (var/ckey in current_list)
				var/list/custom_item_lists_we_are_on	=	(GLOB.patron_item_whitelisted_ckeys[ckey] || list())
				custom_item_lists_we_are_on |= PI
				GLOB.patron_item_whitelisted_ckeys[ckey] = custom_item_lists_we_are_on
			return TRUE



	log_debug("ERROR: Patron whitelist ID [current_id] found no matching patron_item datum to assign to")
	return FALSE


/*
	This proc takes an input vaguely identifying a user. That could be a mob, ckey, mind, or player datum

	Returns true if they can do store access to this
*/
/datum/patron_item/proc/can_buy_in_store(var/user)
	to_chat(world, "canbuy 1 [user]")
	if (store_access == ACCESS_PUBLIC)
		return TRUE

	var/ckey
	var/is_patron
	to_chat(world, "canbuy 2")
	if (istext(user))
		ckey = user
		var/datum/player/P = get_player_from_key(ckey)
		is_patron = P.patron
	else if (istype(user, /datum))
		var/datum/D = user
		ckey = D.get_key()
		is_patron = D.is_patron()
		to_chat(world, "isdatum, [ckey]	[is_patron]")


	switch (store_access)
		if (ACCESS_PUBLIC)
			return TRUE
		if (ACCESS_PATRONS)
			to_chat(world, "PATRON ACCESS")
			return is_patron
		if (ACCESS_WHITELIST)
			return (ckey in whitelist)