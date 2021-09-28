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
	var/id	//Used to link whitelists to us
	var/inherit_inhands = 1 //if unset, and inhands are not provided, then the inhand overlays will be invisible.
	var/item_icon
	var/description

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

	var/store_cost = null //If not null, this item can be purchased in the store for this many credits
	var/store_access	=	null //One of the ACCESS_XXX defines above, determines who is allowed to buy this in store

	var/loadout_modkit_cost	=	null //If not null, a modkit to transform another item into this item can be purchased in the loadout for this many points
	var/modkit_access	=	null//One of the ACCESS_XXX defines above, determines who is allowed to buy this in store

	var/list/whitelist	=	null	//A list of ckeys who can use ACCESS_WHITELIST channels with this item

	var/category = "Misc"	//Used for store and loadout

	/*
		This can be one of a few things:
			-A single typepath, or a list of typepaths, of items which the modkit can be applied to, to transform them into the desired item
			-A modkit typepath which is the exact type the modkit will be. This allows you to override procs and make more complex rules about application
	*/
	var/modkit_base	= null


/datum/patron_item/New()


	if (!isnull(loadout_cost) && !isnull(loadout_access))
		create_loadout_datum()

	if (!isnull(store_cost) && !isnull(store_access))
		create_store_datum()

/datum/patron_item/proc/create_loadout_datum()
	var/datum/gear/G = new()
	G.display_name = src.name
	G.description = description
	G.path = item_path
	G.cost = loadout_cost

	switch (loadout_access)
		if (ACCESS_PUBLIC)
			//do nothing
		if (ACCESS_PATRONS)
			G.patron_only = TRUE
		//if (ACCESS_WHITELIST)
			//TODO: Code gear whitelists

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

	//TODO: PAtron functionality for store listings
	//TODO: Whitelist functionality for store listings
	//TODO: Set transfer setting if the item is a rig or module

	register_research_design(D)


/hook/startup/proc/load_patron_item_whitelists()
