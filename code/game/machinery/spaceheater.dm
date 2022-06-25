/obj/machinery/space_heater
	anchored = 0
	density = 1
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater is guaranteed not to set the station on fire."
	circuit = /obj/item/weapon/circuitboard/spaceheater
	var/obj/item/weapon/cell/cell
	var/cell_type = /obj/item/weapon/cell/high
	var/on = 0
	var/targetTemperature = T0C + 20	//K
	var/active = 0
	var/heatingPower = 20000
	var/efficiency = 20000
	var/settableTemperatureMedian = 30 + T0C
	var/settableTemperatureRange = 30
	clicksound = "switch"
	interact_offline = TRUE
	light_range = 3
	light_power = 3

/obj/machinery/space_heater/Initialize()
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	update_icon()

/obj/machinery/space_heater/RefreshParts()
	var/laser = 0
	var/cap = 0
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts)
		laser += M.rating
	for(var/obj/item/weapon/stock_parts/capacitor/M in component_parts)
		cap += M.rating

	heatingPower = laser * 20000

	settableTemperatureRange = cap * 30
	efficiency = (cap + 1) * 10000

	targetTemperature = clamp(targetTemperature,
		max(settableTemperatureMedian - settableTemperatureRange, TCMB),
		settableTemperatureMedian + settableTemperatureRange)

/obj/machinery/space_heater/update_icon(var/rebuild_overlay = 0)
	if(!on)
		icon_state = "sheater-off"
		set_light_on(FALSE)
	else if(active > 0)
		icon_state = "sheater-heat"
		set_light_color(COLOR_SEDONA)
	else if(active < 0)
		icon_state = "sheater-cool"
		set_light_color(COLOR_DEEP_SKY_BLUE)
	else
		icon_state = "sheater-standby"
		set_light_on(FALSE)

	if(rebuild_overlay)
		cut_overlays()
		if(panel_open)
			add_overlay("sheater-open")

/obj/machinery/space_heater/examine(mob/user)
	.=..()
	to_chat(user, "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"].")
	if(panel_open)
		to_chat(user, "The power cell is [cell ? "installed" : "missing"].")
	else
		to_chat(user, "The charge meter reads [cell ? round(cell.percent(),1) : 0]%")
	if(in_range(user, src) || isobserver(user))
		to_chat(user, SPAN_NOTICE("The status display reads: Temperature range at <b>[settableTemperatureRange]°C</b>.<br>Heating power at <b>[heatingPower*0.001]kJ</b>.<br>Power consumption at <b>[(efficiency*-0.0025)+150]%</b>"))

/obj/machinery/space_heater/powered()
	if(cell && cell.charge)
		return 1
	return 0

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				var/obj/item/weapon/cell/C = usr.get_active_hand()
				if(istype(C))
					user.drop_item()
					cell = C
					C.forceMove(src)
					C.add_fingerprint(usr)

					user.visible_message("<span class='notice'>[user] inserts a power cell into [src].</span>", "<span class='notice'>You insert the power cell into [src].</span>")
					power_change()
		else
			to_chat(user, "The hatch must be open to insert a power cell.")
			return
	else if(isScrewdriver(I))
		default_deconstruction_screwdriver(user, I)
		update_icon(1)
	else if(isCrowbar(I))
		default_deconstruction_crowbar(user, I)
	else
		..()

/obj/machinery/space_heater/attack_hand(mob/user as mob)
	add_fingerprint(user)
	interact(user)

/obj/machinery/space_heater/interact(mob/user as mob)
	if(panel_open)
		tgui_interact(user)
	else
		on = !on
		user.visible_message("<span class='notice'>[user] switches [on ? "on" : "off"] the [src].</span>","<span class='notice'>You switch [on ? "on" : "off"] the [src].</span>")
		update_icon()

/obj/machinery/space_heater/ui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/machinery/space_heater/ui_status(mob/user)
	if(!panel_open)
		return UI_CLOSE
	return ..()

/obj/machinery/space_heater/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater", name)
		ui.open()

/obj/machinery/space_heater/ui_data(mob/user)
	var/list/data = list()

	data["cell"] = !!cell
	data["power"] = round(cell?.percent(), 1)
	data["temp"] = targetTemperature
	data["minTemp"] = max(settableTemperatureMedian - settableTemperatureRange - T0C, TCMB)
	data["maxTemp"] = settableTemperatureMedian + settableTemperatureRange - T0C

	return data

/obj/machinery/space_heater/ui_act(action, params)
	if(..())
		return TRUE

	if(!panel_open)
		return FALSE

	switch(action)
		if("temp")
			if(text2num(params["newtemp"]) != null)
				targetTemperature = clamp(round(text2num(params["newtemp"])),
					max(settableTemperatureMedian - settableTemperatureRange, TCMB),
					settableTemperatureMedian + settableTemperatureRange)
				. = TRUE

		if("cellremove")
			if(cell && !usr.get_active_hand())
				usr.visible_message("<span class='notice'>[usr] removes [cell] from [src].</span>", "<span class='notice'>You remove [cell] from [src].</span>")
				cell.update_icon()
				usr.put_in_hands(cell)
				cell.add_fingerprint(usr)
				cell = null
				power_change()
				. = TRUE

		if("cellinstall")
			if(!cell)
				var/obj/item/weapon/cell/C = usr.get_active_hand()
				if(istype(C))
					usr.drop_item()
					cell = C
					C.forceMove(src)
					C.add_fingerprint(usr)
					power_change()
					usr.visible_message("<span class='notice'>[usr] inserts \the [C] into \the [src].</span>", "<span class='notice'>You insert \the [C] into \the [src].</span>")
				. = TRUE

/obj/machinery/space_heater/Process()
	if(on)
		if(cell && cell.charge)
			var/datum/gas_mixture/env = loc.return_air()
			if(env && abs(env.temperature - targetTemperature) <= 0.1)
				active = 0
			else
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)

				if(removed)
					var/heat_transfer = removed.get_thermal_energy_change(targetTemperature)
					if(heat_transfer > 0)	//heating air
						heat_transfer = min(heat_transfer , heatingPower) //limit by the power rating of the heater

						removed.add_thermal_energy(heat_transfer)
						cell.use((heat_transfer*CELLRATE)/efficiency)
					else	//cooling air
						heat_transfer = abs(heat_transfer)

						//Assume the heat is being pumped into the hull which is fixed at 20 C
						var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
						heat_transfer = min(heat_transfer, cop * heatingPower)	//limit heat transfer by available power

						heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

						var/power_used = abs(heat_transfer)/cop
						cell.use((power_used*CELLRATE)/efficiency)
					active = heat_transfer

				env.merge(removed)
		else
			on = 0
			active = 0
			power_change()
		update_icon()
