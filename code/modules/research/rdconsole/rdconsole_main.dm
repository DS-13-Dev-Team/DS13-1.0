/obj/machinery/computer/rdconsole
	name = "fabrication control console"
	desc = "Console controlling the various fabrication devices. Uses self-learning matrix to hold and optimize blueprints. Prone to corrupting said matrix, so back up often."
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/circuitboard/rdconsole
	var/datum/research/files							//Stores all the collected research data.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/id = 0				//ID of the computer (for server restrictions).
	var/sync = TRUE			//If sync = 0, it doesn't show up on Server Control Console
	var/can_research = TRUE	//Is this console capable of researching
	var/locked = FALSE
	var/list/cats = list("Misc", "Misc", TECH_ENGINEERING, 4, null)	//Stores protolathe, imprinter design category, tech tree tab, console tab and selected tech id

	req_access = list(access_research)	//Data and setting manipulation requires scientist access.

/obj/machinery/computer/rdconsole/Initialize()
	.=..()
	files = new /datum/research(src) //Setup the research data holder
	SyncRDevices()
	sync_tech()

/obj/machinery/computer/rdconsole/Destroy()
	sync_tech()
	QDEL_NULL(files)
	if(linked_destroy)
		linked_destroy.linked_console = null
		linked_destroy = null
	if(linked_lathe)
		linked_lathe.linked_console = null
		linked_destroy = null
	if(linked_imprinter)
		linked_imprinter.linked_console = null
		linked_destroy = null
	.=..()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/D as obj, var/mob/user as mob)
	if(istype(D, /obj/item/disk/research_points))
		var/obj/item/disk/research_points/disk = D
		to_chat(user, "<span class='notice'>[name] received [disk.stored_points] research points from [disk.name]</span>")
		files.research_points += disk.stored_points
		user.remove_from_mob(disk)
		qdel(disk)
	else
		.=..()

	SStgui.update_uis(src, TRUE)

/obj/machinery/computer/rdconsole/emp_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols.</span>")
		return 1

/obj/machinery/computer/rdconsole/proc/CallReagentName(var/reagent_type)
	var/datum/reagent/R = reagent_type
	return ispath(reagent_type, /datum/reagent) ? initial(R.name) : "Unknown"

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/D in range(4, src))
		if(D.linked_console != null || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/destructive_analyzer))
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/protolathe))
			if(linked_lathe == null)
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/circuit_imprinter))
			if(linked_imprinter == null)
				linked_imprinter = D
				D.linked_console = src
	return

/obj/machinery/computer/rdconsole/proc/sync_tech()
	for(var/obj/machinery/r_n_d/server/S in SSresearch.servers)
		var/server_processed = FALSE
		if((id in S.id_with_upload))
			S.files.download_from(files)
			server_processed = TRUE
		if(((id in S.id_with_download)))
			files.download_from(S.files)
			server_processed = TRUE
		if(server_processed)
			S.produce_heat(100)

/obj/machinery/computer/rdconsole/core
	name = "R&D Console"
	id = 1
	can_research = TRUE