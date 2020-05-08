////////////////////////
//Turret Control Panel//
////////////////////////

/area
	// Turrets use this list to see if individual power/lethal settings are allowed
	var/list/turret_controls = list()

/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = 1
	density = 0
	var/enabled = 0
	var/lethal = 0
	var/locked = 1
	var/area/control_area //can be area name, path or nothing.
	var/mob/living/silicon/ai/master_ai

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 	//Silicons cannot use this

	req_access = list(access_security)

	//Which profiles can this control apply to turrets?
	//The first one in the list is automatically picked
	var/list/targeting_profiles = list(/datum/targeting_profile/turret/crew,
	/datum/targeting_profile/turret,
	/datum/targeting_profile/turret/authorized)
	var/selected_profile

	var/embedded = FALSE

/obj/machinery/turretid/embedded
	embedded = TRUE

/obj/machinery/turretid/stun
	enabled = 0
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = 0
	lethal = 1
	icon_state = "control_kill"


/obj/machinery/turretid/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	data["access"] = !isLocked(user)
	data["locked"] = locked
	data["enabled"] = enabled


	if(data["access"])
		var/list/profiles = list()
		for (var/id in targeting_profiles)
			var/datum/targeting_profile/TP = targeting_profiles[id]

			profiles += list(list("name" = TP.name, "id" = TP.id))

			if (TP.id == selected_profile)
				data["selected_desc"] = TP.desc

		data["profiles"] = profiles
		data["selected"] = selected_profile


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		if (embedded)
			ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300, state = GLOB.interactive_state)
		else
			ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(0)

/obj/machinery/turretid/Topic(href, href_list)
	if(..())
		return 1


	if(href_list["command"] && href_list["value"])
		var/log_action = null

		var/list/toggle = list("disabled","enabled")

		var/value = text2num(href_list["value"])
		if(href_list["command"] == "enable")
			enabled = value
			log_action = "[toggle[enabled+1]] the turrets"

		if(!isnull(log_action))
			log_admin("[key_name(usr)] has [log_action]")
			message_admins("[key_name_admin(usr)] has [log_action]", 1)

		update_turrets()
		SSnano.update_uis(src)
		return 1

	if(href_list["select_profile"])
		selected_profile = href_list["select_profile"]
		update_turrets()
		SSnano.update_uis(src)

/obj/machinery/turretid/CanUseTopic(user, state)
	if (embedded)
		return STATUS_INTERACTIVE
	.=..()


/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	. = ..()

/obj/machinery/turretid/Initialize()
	if(!control_area)
		control_area = get_area(src)
	else if(istext(control_area))
		for(var/area/A in world)
			if(A.name && (strip_improper(A.name)==control_area))
				control_area = A
				break



	if(control_area)
		var/area/A = control_area
		if(istype(A))
			A.turret_controls += src
		else
			control_area = null



	//Fill out the targeting profiles list
	var/templist = targeting_profiles.Copy()
	targeting_profiles = list()
	for (var/tptype in templist)
		var/datum/targeting_profile/TP = tptype
		TP = GLOB.targeting_profiles[initial(TP.id)]
		targeting_profiles[TP.id] = TP

	selected_profile = targeting_profiles[1]

	power_change() //Checks power and initial settings
	. = ..()
	update_turrets()

/obj/machinery/turretid/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>")
		return 1

	if(malf_upgraded && master_ai)
		if((user == master_ai) || (user in master_ai.connected_robots))
			return 0
		return 1

	if(locked && !issilicon(user))
		to_chat(user, "<span class='notice'>Access denied.</span>")
		return 1

	return 0

/obj/machinery/turretid/CanUseTopic(mob/user)
	if(isLocked(user))
		return STATUS_CLOSE

	return ..()

/obj/machinery/turretid/attackby(obj/item/weapon/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/modular_computer))
		if(src.allowed(usr))
			if(emagged)
				to_chat(user, "<span class='notice'>The turret control is unresponsive.</span>")
			else
				locked = !locked
				to_chat(user, "<span class='notice'>You [ locked ? "lock" : "unlock"] the panel.</span>")
		return
	return ..()

/obj/machinery/turretid/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='danger'>You short out the turret controls' access analysis module.</span>")
		emagged = 1
		locked = 0
		ailock = 0
		return 1

/obj/machinery/turretid/attack_ai(mob/user as mob)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	if(isLocked(user))
		return

	ui_interact(user)



/obj/machinery/turretid/proc/update_turrets()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
	TC.ailock = ailock

	if(istype(control_area))
		for (var/obj/machinery/turret/aTurret in control_area)
			aTurret.setState(TC)
			aTurret.targeting_profile = targeting_profiles[selected_profile]
			aTurret.handle_targets()

	update_icon()

/obj/machinery/turretid/power_change()
	. = ..()
	if(.)
		update_turrets()

/obj/machinery/turretid/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "control_off"
		set_light(0)
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
			set_light(1, 0.5, 2, 2, "#990000")
		else
			icon_state = "control_stun"
			set_light(1, 0.5, 2, 2, "#ff9900")
	else
		icon_state = "control_standby"
		set_light(1, 0.5, 2, 2, "#003300")

/obj/machinery/turretid/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = pick(0, 1)

		enabled=0
		update_turrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				update_turrets()

	..()


/obj/machinery/turretid/malf_upgrade(var/mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1
	locked = 1
	ailock = 0
	to_chat(user, "\The [src] has been upgraded. It has been locked and can not be tampered with by anyone but you and your cyborgs.")
	master_ai = user
	return 1