// Asteroid cannon console.
/obj/machinery/computer/asteroidcannon
	name = "Asteroid Defense Mainframe"
	desc = "A console used to control the ship's automated asteroid defense systems."
	//circuit = /obj/item/weapon/circuitboard/asteroidcannon You know what. Gonna say no to this one. It'd be too easy to just decon the ADS console and dispose of the board.
	var/ui_template = "asteroidcannon.tmpl"
	var/obj/structure/asteroidcannon/gun = null
	var/time_per_step = 20 SECONDS

/obj/machinery/computer/asteroidcannon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if (!gun)
		to_chat(user,"<span class='warning'>Unable to establish link with the asteroid cannon.</span>")
		return

	var/list/data = get_ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, ui_template, "[name]", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/computer/asteroidcannon/attack_hand(user as mob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return TRUE

	ui_interact(user)

/obj/machinery/computer/asteroidcannon/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/asteroidcannon/LateInitialize()
	. = ..()
	gun = GLOB.asteroid_cannon

/obj/machinery/computer/asteroidcannon/proc/get_ui_data()
	var/list/data = list()
	data["can_magaccelerators"] = gun.reboot_step == 0
	data["can_fluxalignment"] = gun.reboot_step == 1
	data["can_targetingmatrix"] = gun.reboot_step == 2
	data["can_reboot"] = gun.reboot_step == 3
	data["is_operational"] = gun?.is_operational()
	data["cannon_status"] =  data["is_operational"] ? "ONLINE" : "OFFLINE"
	data["reboot_status"] = gun.reboot_step == -1 ? "REBOOTING...." : "IDLE" //It's set to -1 when it's "busy"
	return data

/obj/machinery/computer/asteroidcannon/OnTopic(user, href_list)
	if(!gun)
		return TOPIC_NOACTION

	if(href_list["magaccelerators"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/set_repair_step, 1), time_per_step)
		return TOPIC_REFRESH
	if(href_list["fluxalignment"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/set_repair_step, 2), time_per_step)
		return TOPIC_REFRESH
	if(href_list["targetingmatrix"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/set_repair_step, 3), time_per_step)
		return TOPIC_REFRESH
	if(href_list["reboot"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/reactivate_gun), time_per_step*2)
		return TOPIC_REFRESH

/obj/machinery/computer/asteroidcannon/proc/set_repair_step(step)
	gun?.reboot_step = step

/obj/machinery/computer/asteroidcannon/proc/reactivate_gun()
	gun?.operational = TRUE
	gun?.reboot_step = 0
	gun.set_light(0)
	playsound(src, 'sound/effects/compbeep5.ogg', 100, TRUE)
