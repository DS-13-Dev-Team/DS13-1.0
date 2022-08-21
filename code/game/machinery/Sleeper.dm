/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = 1
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	atom_flags = ATOM_FLAG_NO_REACT
	var/mob/living/carbon/human/occupant = null
	var/list/available_chemicals = list(/datum/reagent/inaprovaline, /datum/reagent/dylovene, /datum/reagent/soporific, /datum/reagent/paracetamol, /datum/reagent/dexalin, /datum/reagent/iron)
	var/amounts = list(5, 10)
	var/obj/item/reagent_containers/glass/beaker = null
	var/filtering = 0
	var/pump
	var/max_chem = 20
	var/initial_bin_rating = 1
	var/min_health = -101
	var/stasis = 0
	var/controls_inside = FALSE
	var/auto_eject_dead = FALSE
	circuit = /obj/item/circuitboard/sleeper

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.

/obj/machinery/sleeper/Initialize(mapload)
	. = ..()
	if(mapload)
		beaker = new /obj/item/reagent_containers/glass/beaker/large(src)
	update_icon()

/obj/machinery/sleeper/Destroy()
	go_out()
	.=..()

/obj/machinery/sleeper/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.trans_to_obj(beaker, 3)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()
	if(pump > 0)
		if(beaker && istype(occupant))
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				for(var/datum/reagent/x in occupant.ingested.reagent_list)
					occupant.ingested.trans_to_obj(beaker, 3)
		else
			toggle_pump()

	if(iscarbon(occupant))
		if(auto_eject_dead && occupant.stat == DEAD)
			playsound(loc, 'sound/machines/buzz-sigh.ogg', 40)
			go_out()
			return
		if(stasis >= 1)
			occupant.SetStasis(stasis)

/obj/machinery/sleeper/update_icon()
	icon_state = "sleeper_[occupant ? "1" : "0"]"

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(..())
		return 1

	tgui_interact(user)

/obj/machinery/sleeper/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", "Sleeper")
		ui.open()

/obj/machinery/sleeper/ui_data(mob/user)
	var/data[0]
	data["amounts"] = amounts
	data["hasOccupant"] = occupant ? 1 : 0
	var/occupantData[0]
	// var/crisis = 0
	if(occupant)
		occupantData["name"] = occupant.name
		occupantData["stat"] = occupant.stat
		occupantData["health"] = occupant.health
		occupantData["maxHealth"] = occupant.max_health
		occupantData["minHealth"] = CONFIG_GET(number/health_threshold_dead)
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["oxyLoss"] = occupant.getOxyLoss()
		occupantData["toxLoss"] = occupant.getToxLoss()
		occupantData["fireLoss"] = occupant.getFireLoss()
		occupantData["paralysis"] = occupant.paralysis
		occupantData["hasBlood"] = 0
		occupantData["bodyTemperature"] = occupant.bodytemperature
		occupantData["maxTemp"] = 1000 // If you get a burning vox armalis into the sleeper, congratulations
		// Because we can put simple_animals in here, we need to do something tricky to get things working nice
		occupantData["temperatureSuitability"] = 0 // 0 is the baseline
		if(ishuman(occupant) && occupant.species)
			// I wanna do something where the bar gets bluer as the temperature gets lower
			// For now, I'll just use the standard format for the temperature status
			var/datum/species/sp = occupant.species
			if(occupant.bodytemperature < sp.cold_level_3)
				occupantData["temperatureSuitability"] = -3
			else if(occupant.bodytemperature < sp.cold_level_2)
				occupantData["temperatureSuitability"] = -2
			else if(occupant.bodytemperature < sp.cold_level_1)
				occupantData["temperatureSuitability"] = -1
			else if(occupant.bodytemperature > sp.heat_level_3)
				occupantData["temperatureSuitability"] = 3
			else if(occupant.bodytemperature > sp.heat_level_2)
				occupantData["temperatureSuitability"] = 2
			else if(occupant.bodytemperature > sp.heat_level_1)
				occupantData["temperatureSuitability"] = 1
		else if(isanimal(occupant))
			var/mob/living/simple_animal/silly = occupant
			if(silly.bodytemperature < silly.minbodytemp)
				occupantData["temperatureSuitability"] = -3
			else if(silly.bodytemperature > silly.maxbodytemp)
				occupantData["temperatureSuitability"] = 3
		// Blast you, imperial measurement system
		occupantData["btCelsius"] = occupant.bodytemperature - T0C
		occupantData["btFaren"] = ((occupant.bodytemperature - T0C) * (9.0/5.0))+ 32


		// crisis = (occupant.health < min_health)
		// I'm not sure WHY you'd want to put a simple_animal in a sleeper, but precedent is precedent
		// Runtime is aptly named, isn't she?
		if(ishuman(occupant) && occupant.vessel)
			occupantData["pulse"] = occupant.get_pulse(GETPULSE_TOOL)
			occupantData["hasBlood"] = 1
			occupantData["bloodLevel"] = occupant.vessel.get_reagent_amount(/datum/reagent/blood)
			occupantData["bloodMax"] = occupant.species.blood_volume
			occupantData["bloodPercent"] = occupant.get_blood_volume() //copy pasta ends here

			occupantData["bloodType"] = occupant.b_type

	data["occupant"] = occupantData
	data["maxchem"] = max_chem
	data["minhealth"] = min_health
	data["dialysis"] = filtering
	data["stomachpumping"] = pump
	data["auto_eject_dead"] = auto_eject_dead
	if(beaker)
		data["isBeakerLoaded"] = 1
		if(beaker.reagents)
			data["beakerMaxSpace"] = beaker.reagents.maximum_volume
			data["beakerFreeSpace"] = beaker.reagents.get_free_space()
		else
			data["beakerMaxSpace"] = 0
			data["beakerFreeSpace"] = 0
	else
		data["isBeakerLoaded"] = FALSE

	data["stasis"] = stasis

	var/chemicals[0]
	for(var/datum/reagent/R as anything in available_chemicals)
		var/reagent_amount = 0
		var/pretty_amount
		var/injectable = occupant ? 1 : 0
		var/overdosing = 0
		var/caution = 0 // To make things clear that you're coming close to an overdose

		if(occupant?.reagents)
			reagent_amount = occupant.reagents.get_reagent_amount(R)
			// If they're mashing the highest concentration, they get one war`ning
			if(initial(R.overdose) && reagent_amount + 10 > initial(R.overdose))
				caution = 1
			if(initial(R.overdose) && reagent_amount > initial(R.overdose))
				overdosing = 1

		pretty_amount = round(reagent_amount, 0.05)

		chemicals.Add(list(list("title" = initial(R.name), "id" = R, "occ_amount" = reagent_amount, "pretty_amount" = pretty_amount, "injectable" = injectable, "overdosing" = overdosing, "od_warning" = caution)))
	data["chemicals"] = chemicals
	return data


/obj/machinery/sleeper/ui_act(action, params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if(!controls_inside && usr == occupant)
		return
	if(panel_open)
		to_chat(usr, "<span class='notice'>Close the maintenance panel first.</span>")
		return

	. = TRUE
	switch(action)
		if("chemical")
			if(!occupant)
				return
			if(occupant.stat == DEAD)
				var/datum/gender/G = gender_datums[occupant.get_visible_gender()]
				to_chat(usr, "<span class='danger'>This person has no life to preserve anymore. Take [G.him] to a department capable of reanimating [G.him].</span>")
				return
			var/datum/reagent/R = text2path(params["chemid"])
			var/amount = text2num(params["amount"])
			if(!(R in available_chemicals) || amount <= 0)
				return
			if(occupant.health > min_health) //|| (chemical in emergency_chems))
				inject_chemical(usr, R, amount)
			else
				to_chat(usr, "<span class='danger'>This person is not in good enough condition for sleepers to be effective! Use another means of treatment, such as cryogenics!</span>")
		if("removebeaker")
			remove_beaker()
		if("togglefilter")
			toggle_filter()
		if("togglepump")
			toggle_pump()
		if("ejectify")
			go_out()
		if("changestasis")
			stasis = text2num(params["stasis_volume"])
		if("auto_eject_dead_on")
			auto_eject_dead = TRUE
		if("auto_eject_dead_off")
			auto_eject_dead = FALSE
		else
			return FALSE
	add_fingerprint(usr)
	SStgui.update_uis(src)

/obj/machinery/sleeper/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		add_fingerprint(user)
		if(!beaker)
			if(!user.unEquip(I, src))
				return
			beaker = I
			user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")
			SStgui.update_uis(src)
		else
			to_chat(user, "<span class='warning'>\The [src] has a beaker already.</span>")
		return
	if(!occupant)
		if(default_deconstruction_screwdriver(user, I))
			return
	if(default_deconstruction_crowbar(user, I))
		return
	else
		..()

/obj/machinery/sleeper/dismantle()
	remove_beaker()
	..()

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	go_in(target, user)
	SStgui.update_uis(src)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)
/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	to_chat(occupant, "<span class='warning'>You feel like your blood is being sucked away.</span>")
	filtering = !filtering

/obj/machinery/sleeper/proc/toggle_pump()
	if(!occupant || !beaker)
		pump = 0
		return
	to_chat(occupant, "<span class='warning'>You feel a tube jammed down your throat.</span>")
	pump = !pump

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_mob(user, M, 20))
		if(occupant)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		update_use_power(2)
		occupant = M
		update_icon()

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == beaker)
			continue
		A.dropInto(loc)
	update_use_power(1)
	update_icon()
	toggle_filter()
	SStgui.update_uis(src)

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.dropInto(loc)
		beaker = null
		toggle_filter()
		toggle_pump()

/obj/machinery/sleeper/proc/inject_chemical(mob/living/user, datum/reagent/chemical_type, amount)
	if(stat & (BROKEN|NOPOWER))
		return

	if(!(amount in amounts))
		return

	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical_type) + amount <= max_chem)
			use_power(amount * CHEM_SYNTH_ENERGY)
			occupant.reagents.add_reagent(chemical_type, amount)
			to_chat(user, "Occupant now has [occupant.reagents.get_reagent_amount(chemical_type)] unit\s of [initial(chemical_type.name)] in their bloodstream.")
		else
			to_chat(user, "The subject has too many chemicals.")
	else
		to_chat(user, "There's no suitable occupant in \the [src].")
