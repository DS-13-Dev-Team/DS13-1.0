/*
General Explination:
The research datum is the "folder" where all the research information is stored in a R&D console. It's also a holder for all the
various procs used to manipulate it. It has four variables and seven procs:
Variables:
- tech_trees is a list of all /datum/tech that can potentially be researched by the player.
- all_technologies is a list of all /datum/technology that can potentially be researched by the player.
- researched_tech contains all researched technologies
- design_by_id contains all existing /datum/design.
- known_designs contains all researched /datum/design.
- experiments contains data related to earning research points, more info in experiment.dm
- research_points is an ammount of points that can be spend on researching technologies
- design_categories_protolathe stores all unlocked categories for protolathe designs
- design_categories_imprinter stores all unlocked categories for circuit imprinter designs
Procs:
- AddDesign2Known: Adds a /datum/design to known_designs.
- IsResearched
- CanResearch
- UnlockTechology
- download_from: Unlocks all technologies from a different /datum/research and syncs experiment data
- forget_techology
- forget_random_technology
- forget_all
The tech datums are the actual "tech trees" that you improve through researching. Each one has five variables:
- Name:		Pretty obvious. This is often viewable to the players.
- Desc:		Pretty obvious. Also player viewable.
- ID:		This is the unique ID of the tech that is used by the various procs to find and/or maniuplate it.
- Level:	This is the current level of the tech. Based on the ammount of researched technologies
- MaxLevel: Maxium level possible for this tech. Based on the ammount of technologies of that tech
*/
/***************************************************************
**						Master Types						  **
**	Includes all the helper procs and basic tech processing.  **
***************************************************************/

/datum/research								//Holder for all the existing, archived, and known tech. Individual to console.
	var/list/known_designs = list()			//List of available designs (at base reliability).
	var/list/design_categories_protolathe = list()
	var/list/design_categories_imprinter = list()

	var/list/tech_trees_shown = list()
	var/list/tech_trees_hidden = list()
	var/list/all_technologies = list()
	var/list/researched_tech = list()

	var/atom/linked_atom
	var/obj/machinery/r_n_d/server/server
	var/datum/experiment_data/experiments

	var/research_points = 0

/datum/research/New(atom/A)
	linked_atom = A
	experiments = new /datum/experiment_data()
	SSresearch.initialize_research_file(src)

/datum/research/Destroy()
	SSresearch.research_files -= src
	.=..()

/datum/research/proc/IsResearched(datum/technology/T)
	return !!(T.id in researched_tech)

/datum/research/proc/CanResearch(datum/technology/T)
	if(T.cost > research_points)
		return FALSE

	for(var/t in T.required_technologies)
		var/datum/technology/OTech = SSresearch.all_technologies[t]

		if(!IsResearched(OTech))
			return FALSE

	return TRUE

/datum/research/proc/UnlockTechology(datum/technology/T, force = FALSE)
	if(IsResearched(T))
		return
	if(!CanResearch(T) && !force)
		return

	researched_tech |= T.id
	if(!force)
		research_points -= T.cost
	tech_trees_shown[T.tech_type] += 1

	for(var/t in T.unlocks_designs)
		var/datum/design/D = SSresearch.design_by_id[t]

		AddDesign2Known(D)

/datum/research/proc/download_from(datum/research/O)
	tech_trees_shown |= O.tech_trees_shown
	tech_trees_hidden -= O.tech_trees_shown

	for(var/tech_id in O.researched_tech)
		var/datum/technology/T = SSresearch.all_technologies[tech_id]
		UnlockTechology(T, force = TRUE)
	experiments.merge_with(O.experiments)

/datum/research/proc/forget_techology(datum/technology/T)
	if(!IsResearched(T))
		return
	tech_trees_shown[T.tech_type] -= 1
	researched_tech -= T.id

	for(var/t in T.unlocks_designs)
		var/datum/design/D = SSresearch.design_by_id[t]
		known_designs -= D.id

/datum/research/proc/forget_random_technology()
	if(researched_tech.len > 0)
		var/random_tech = pick(researched_tech)
		var/datum/technology/T = SSresearch.all_technologies[random_tech]

		forget_techology(T)

/datum/research/proc/forget_all(tech_type)
	tech_trees_shown[tech_type] -= 1
	for(var/tech_id in researched_tech)
		var/datum/technology/T = SSresearch.all_technologies[tech_id]
		if(T.tech_type == tech_type)
			researched_tech -= tech_id

			for(var/t in T.unlocks_designs)
				var/datum/design/D = SSresearch.design_by_id[t]
				known_designs -= D.id

/datum/research/proc/AddDesign2Known(datum/design/D)
	if(D.id in known_designs)
		return

	known_designs |= D.id
	var/cat = D.category ? D.category : "Unspecified"
	if(D.build_type & PROTOLATHE)
		design_categories_protolathe |= cat
	if(D.build_type & IMPRINTER)
		design_categories_imprinter |= cat

// Unlocks hidden tech trees
/datum/research/proc/check_item_for_tech(obj/item/I)
	if(!I.origin_tech.len)
		return

	for(var/tech_tree_id in tech_trees_hidden)
		var/datum/tech/T = SSresearch.tech_trees[tech_tree_id]
		if(!T.item_tech_req)
			continue

		for(var/item_tech in I.origin_tech)
			if(item_tech == T.item_tech_req)
				tech_trees_hidden -= T.id
				tech_trees_shown |= T.id
				return

// A simple helper proc to find the name of a tech with a given ID.
/proc/CallTechName(var/ID)
	for(var/T in subtypesof(/datum/tech))
		var/datum/tech/check_tech = T
		if(initial(check_tech.id) == ID)
			return  initial(check_tech.name)

/***************************************************************
**						Technology Datums					  **
**	Includes all the various technoliges and what they make.  **
***************************************************************/

/obj/item/weapon/disk/tech_disk
	name = "Empty Disk"
	desc = "Wow. Is that a save icon?"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)
	var/datum/tech/stored

/obj/item/weapon/disk/tech_disk/Initialize()
	. = ..()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)

/datum/tech	//Datum of individual technologies.
	var/name = "name"          //Name of the technology.
	var/shortname = "name"
	var/desc = "description"   //General description of what it does and what it makes.
	var/id = "id"              //An easily referenced ID. Must be alphanumeric, lower-case, and no symbols.
	var/level = 0              //A simple number scale of the research level. Level 0 = Secret tech.
	var/rare = 1               //How much CentCom wants to get that tech. Used in supply shuttle tech cost calculation.
	var/maxlevel               //Calculated based on the ammount of technologies
	var/shown = TRUE           //Used to hide tech that is not supposed to be shown from the start
	var/item_tech_req          //Deconstructing items with this tech will unlock this tech tree

// CEC Basic Technologies
/datum/tech/engineering
	name = "Engineering Research"
	shortname = "Engineering"
	desc = "Development of new and improved engineering parts."
	id = TECH_ENGINEERING

/datum/tech/biotech
	name = "Biological Technology"
	shortname = "Biological"
	desc = "Research into the deeper mysteries of life and organic substances."
	id = TECH_BIO

/datum/tech/combat
	name = "Combat Systems Research"
	shortname = "Combat Systems"
	desc = "The development of offensive and defensive systems."
	id = TECH_COMBAT

/datum/tech/powerstorage
	name = "Power Manipulation Technology"
	shortname = "Power Manipulation"
	desc = "The various technologies behind the storage and generation of electicity."
	id = TECH_POWER

/datum/tech/bluespace
	name = "Telecommunication Research"
	shortname = "Telecomm"
	desc = "Research into the Telecommuncation"
	id = TECH_BLUESPACE
	rare = 2

/datum/tech/data
	name = "Computer Technology"
	shortname = "Computer"
	desc = "Research into the modular computers."
	id = TECH_DATA

// Secret technologies
/datum/tech/illegal
	name = "Illegal Technologies Research"
	shortname = "Illegal Tech"
	desc = "The study of technologies that violate standard Nanotrasen regulations."
	id = TECH_ILLEGAL
	rare = 3
	shown = FALSE
	item_tech_req = TECH_ILLEGAL

/datum/tech/necro
	name = "Marker Research"
	shortname = "Marker Tech"
	desc = "Technologies that are connnected with Marker"
	id = TECH_NECRO
	rare = 3
	shown = FALSE
	item_tech_req = TECH_NECRO

/datum/technology
	var/name = "name"
	var/desc = "description"
	var/id = "id"							// should be unique
	var/tech_type							// Which tech tree does this techology belongs to

	var/x = 0.5								// Position on the tech tree map, 0 - left, 1 - right
	var/y = 0.5								// 0 - down, 1 - top
	var/no_lines = FALSE					// Prevents rendering any lines that leads to this tech
	var/icon = "gun"						// css class of techology icon, defined in shared.css

	var/list/required_technologies = list()	// Ids of techologies that are required to be unlocked before this one. Should have same tech_type
	var/cost = 100							// How much research points required to unlock this techology

	var/list/unlocks_designs = list()		// Ids of designs that this technology unlocks
