/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	clicksound = "button"
	clickvol = 20

	var/list/spawn_cartridges = null // Set to a list of types to spawn one of each on New()

	var/list/cartridges = list() // Associative, label -> cartridge
	var/obj/item/reagent_containers/container = null

	var/ui_title = "Chemical Dispenser"

	var/accept_drinking = 0
	var/amount = 30

	use_power = 1
	idle_power_usage = 100
	density = 1
	anchored = 1
	circuit = /obj/item/circuitboard/chemical_dispenser
	obj_flags = OBJ_FLAG_ANCHORABLE
	core_skill = SKILL_MEDICAL
	var/can_contaminate = TRUE

/obj/machinery/chemical_dispenser/Initialize(mapload, d)
	. = ..()

	if(spawn_cartridges)
		for(var/type in spawn_cartridges)
			add_cartridge(new type(src))

/obj/machinery/chemical_dispenser/examine(mob/user)
	. = ..()
	to_chat(user, "It has [cartridges.len] cartridges installed, and has space for [DISPENSER_MAX_CARTRIDGES - cartridges.len] more.")

/obj/machinery/chemical_dispenser/dismantle()
	for(var/obj/item/reagent_containers/chem_disp_cartridge/X in contents)
		X.forceMove(loc)
	if(container)
		container.forceMove(loc)
	..()

/obj/machinery/chemical_dispenser/proc/add_cartridge(obj/item/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, "<span class='warning'>\The [C] will not fit in \the [src]!</span>")
		return

	if(cartridges.len >= DISPENSER_MAX_CARTRIDGES)
		if(user)
			to_chat(user, "<span class='warning'>\The [src] does not have any slots open for \the [C] to fit into!</span>")
		return

	if(!C.label)
		if(user)
			to_chat(user, "<span class='warning'>\The [C] does not have a label!</span>")
		return

	if(cartridges[C.label])
		if(user)
			to_chat(user, "<span class='warning'>\The [src] already contains a cartridge with that label!</span>")
		return

	if(user)
		if(user.unEquip(C))
			to_chat(user, "<span class='notice'>You add \the [C] to \the [src].</span>")
		else
			return

	C.forceMove(src)
	cartridges[C.label] = C
	cartridges = sortAssoc(cartridges)
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_containers/chem_disp_cartridge))
		add_cartridge(W, user)

	else if(isScrewdriver(W))
		var/label = input(user, "Which cartridge would you like to remove?", "Chemical Dispenser") as null|anything in cartridges + "Deconstruct"
		if(!label) return
		if(label == "Deconstruct")
			default_deconstruction_screwdriver(user, W)
			return
		var/obj/item/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
		if(C)
			to_chat(user, "<span class='notice'>You remove \the [C] from \the [src].</span>")
			C.forceMove(loc)
	else if(default_deconstruction_crowbar(user, W))
		return
	else if(default_part_replacement(user, W))
		return

	else if(istype(W, /obj/item/reagent_containers/glass) || istype(W, /obj/item/reagent_containers/food))
		if(container)
			to_chat(user, "<span class='warning'>There is already \a [container] on \the [src]!</span>")
			return

		var/obj/item/reagent_containers/RC = W

		if(!accept_drinking && istype(RC,/obj/item/reagent_containers/food))
			to_chat(user, "<span class='warning'>This machine only accepts beakers!</span>")
			return

		if(!RC.is_open_container())
			to_chat(user, "<span class='warning'>You don't see how \the [src] could dispense reagents into \the [RC].</span>")
			return

		container =  RC
		user.drop_from_inventory(RC)
		RC.forceMove(src)
		update_icon()
		to_chat(user, "<span class='notice'>You set \the [RC] on \the [src].</span>")
		SStgui.update_uis(src) // update all UIs attached to src

	else
		..()
	return

/obj/machinery/chemical_dispenser/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemDispenser", ui_title) // 390, 655
		ui.open()

/obj/machinery/chemical_dispenser/ui_data(mob/user)
	var/data[0]
	data["amount"] = amount
	data["isBeakerLoaded"] = container ? 1 : 0
	data["glass"] = accept_drinking

	var/beakerContents[0]
	if(container && container.reagents && container.reagents.reagent_list.len)
		for(var/datum/reagent/R in container.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "id" = R.type, "volume" = R.volume))) // list in a list because Byond merges the first list...
	data["beakerContents"] = beakerContents

	if(container)
		data["beakerCurrentVolume"] = container.reagents.total_volume
		data["beakerMaxVolume"] = container.reagents.maximum_volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var/chemicals[0]
	for(var/label in cartridges)
		var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
		chemicals.Add(list(list("title" = label, "id" = label, "amount" = C.reagents.total_volume))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals
	return data

/obj/machinery/chemical_dispenser/ui_act(action, params)
	if(..())
		return TRUE

	. = TRUE
	switch(action)
		if("amount")
			amount = clamp(round(text2num(params["amount"]), 1), 0, 120) // round to nearest 1 and clamp 0 - 120
		if("dispense")
			var/label = params["reagent"]
			if(cartridges[label] && container && container.is_open_container())
				var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
				C.reagents.trans_to(container, amount)
		if("remove")
			var/amount = text2num(params["amount"])
			if(!container || !amount)
				return
			var/datum/reagents/R = container.reagents
			var/id = text2path(params["reagent"])
			if(amount > 0)
				R.remove_reagent(id, amount)
		if("ejectBeaker")
			if(container)
				container.forceMove(get_turf(src))

				if(Adjacent(usr)) // So the AI doesn't get a beaker somehow.
					usr.put_in_hands(container)

				container = null
				update_icon()
		else
			return FALSE

	add_fingerprint(usr)

/obj/machinery/chemical_dispenser/attack_ghost(mob/user)
	if(inoperable())
		return
	tgui_interact(user)

/obj/machinery/chemical_dispenser/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/chemical_dispenser/attack_hand(mob/user as mob)
	if(inoperable())
		return
	tgui_interact(user)

/obj/machinery/chemical_dispenser/update_icon()
	overlays.Cut()
	if(container)
		var/mutable_appearance/beaker_overlay
		beaker_overlay = image('icons/obj/chemical.dmi', src, "lil_beaker")
		beaker_overlay.pixel_x = rand(-10, 5)
		overlays += beaker_overlay
