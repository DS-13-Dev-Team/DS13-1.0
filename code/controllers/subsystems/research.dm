SUBSYSTEM_DEF(research)
	name = "Research"
	flags = SS_NO_FIRE
	priority = SS_PRIORITY_DEFAULT
	init_order = SS_INIT_RESEARCH

	var/list/designs_by_id = list()		// id = datum
	var/list/tech_trees = list()		// id = datum
	var/list/all_technologies = list()	// id = datum
	var/list/servers = list()			// obj list

	var/designs_initialized = FALSE
	var/list/late_designs_init = list()	// In case custom items system decides to add new design before SSresearch init
	var/list/design_files_to_init = list()
	var/list/research_files = list()

/datum/controller/subsystem/research/Initialize()
	for(var/A in subtypesof(/datum/design))
		var/datum/design/D = new A
		if(!D.build_path)
			qdel(D)
		else
			D.AssembleDesignInfo()
			designs_by_id[D.id] = D

	SSdatabase.update_store_designs()

	for(var/A in subtypesof(/datum/technology))
		var/datum/technology/T = new A
		all_technologies[T.id] = T

	for(var/A in subtypesof(/datum/tech))
		var/datum/tech/T = new A
		tech_trees[T.id] = T

		for(var/C in all_technologies)
			var/datum/technology/TC = all_technologies[C]
			if(TC.tech_type == T.id)
				T.maxlevel += 1

	designs_initialized = TRUE

	for(var/A in late_designs_init)
		register_research_design(A)

	late_designs_init = null

	for(var/A in design_files_to_init)
		initialize_design_file(A)

	design_files_to_init = null

	for(var/A in research_files)
		initialize_research_file(A)

	.=..()

/datum/controller/subsystem/research/stat_entry(msg)
	return "Research Files: [research_files.len]|Tech Trees: [tech_trees.len]|Technologies: [all_technologies.len]|Designs: [designs_by_id.len]"

/datum/controller/subsystem/research/proc/initialize_research_file(datum/research/R)
	// If designs are already generated, initialized right away.
	// If not, add them to the list to be initialized later.
	if(designs_initialized)

		for(var/I in SSresearch.designs_by_id)
			var/datum/design/D = SSresearch.designs_by_id[I]
			if(D.starts_unlocked)
				R.AddDesign2Known(D)

		for(var/I in SSresearch.tech_trees)
			var/datum/tech/T = SSresearch.tech_trees[I]
			if(T.shown)
				R.tech_trees_shown[I] = 0
			else
				R.tech_trees_hidden |= I

		for(var/I in SSresearch.all_technologies)
			var/datum/technology/T = SSresearch.all_technologies[I]
			R.all_technologies |= I
			if(T.cost <= 0 && !T.required_technologies.len)
				R.UnlockTechology(T, TRUE)

	research_files |= R

/datum/controller/subsystem/research/proc/initialize_design_file(datum/computer_file/binary/design/design_file)
	// If designs are already generated, initialized right away.
	// If not, add them to the list to be initialized later.
	if(designs_initialized)
		var/datum/design/design = designs_by_id[get_design_id_from_type(design_file.design)]
		if(design)
			design_file.design = design
			design_file.on_design_set()
		else
			CRASH("Incorrect design ID or path: [design_file.design]")

	else
		design_files_to_init |= design_file

/datum/controller/subsystem/research/proc/register_research_design(datum/design/D)
	if(designs_initialized)
		if(!D.build_path)
			CRASH("Tried to late register design with invalid build path!")
		else
			D.AssembleDesignInfo()
			designs_by_id[D.id] = D
			var/datum/asset/simple/research_designs/RD = get_asset_datum(/datum/asset/simple/research_designs)
			RD.register()

	else
		late_designs_init += D
