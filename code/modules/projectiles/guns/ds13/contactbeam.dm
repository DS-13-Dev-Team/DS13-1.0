/*
	Force Gun

	Fires a shortrange blast of gravity that repulses things. Light damage, but stuns and knocks down

	Secondary fire is a focused beam with a similar effect and marginally better damage
*/
#define EMPTY	0
#define CHARGING	1
#define CHARGE_READY	2


/obj/item/weapon/gun/energy/contact
	name = "C99 Supercollider Contact Beam"
	desc = "A heavy-duty energy pulse device, the Contact Beam is used for commercial destruction where a powerful but focused explosive force is needed. The alt-fire delivers a ground clearing-blast around the user."
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "forcegun"
	item_state = "forcegun"

	charge_cost = 1000 //Five shots per battery
	cell_type = /obj/item/weapon/cell/contact
	projectile_type = null
	charge_meter = FALSE	//if set, the icon state will be chosen based on the current charge
	mag_insert_sound = 'sound/weapons/guns/interaction/force_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/force_magout.ogg'
	removeable_cell = TRUE
	firemodes = list(
		list(mode_name = "charge beam", mode_type = /datum/firemode/contact_beam),
		list(mode_name = "repulse", mode_type = /datum/firemode/forcegun/focus, windup_time = 1.5 SECONDS, windup_sound = 'sound/weapons/guns/fire/force_windup.ogg', fire_sound = 'sound/weapons/guns/fire/force_focus.ogg',fire_delay = 1.5 SECONDS)
		)


	aiming_modes = list(/datum/extension/aim_mode/heavy)

	var/charge_status = EMPTY	//We're either doing nothing, charging a shot, or holding a charged shot and ready to fire it
	var/fire_when_charged	=	TRUE	//When we finish charging, do we fire immediately? If false, hold it
	var/fire_params
	var/datum/click_handler/contact/CHC

//Called to fire a charged beam
/obj/item/weapon/gun/energy/contact/fire_charged(atom/target, clickparams)
	fire_when_charged = TRUE
	var/datum/firemode/contact_beam/CB = current_firemode
	if (!istype(CB))
		cancel_charged()
		return





/obj/item/weapon/gun/energy/contact/update_click_handlers()
	.=..()
	var/mob/user = loc
	if (!CHC)
		CHC = user.PushClickHandler(/datum/click_handler/contact)

/obj/item/weapon/gun/energy/contact/update_click_handlers()
	.=..()
	if (CHC)
		QDEL_NULL(CHC)
/*
	Firemodes
*/
/*
	Contact beam charges up a shot which can be held at fully charged state
*/
/datum/firemode/contact_beam
	var/charge_time = 1 SECOND
	override_fire = TRUE

/datum/firemode/forcegun/blast
	firing_cone = 80
	firing_range = 4
	damage = 45	//Bear in mind that damage values are heavily affected by falloff. Even at pointblank range, they will never be as high as this number
	force	=	200
	falloff_factor = 0.7


/*
	Contact Beam
*/
/datum/click_handler/contact
	var/obj/item/weapon/gun/energy/contact/gun	//What gun are they aiming

/datum/click_handler/contact/MouseDown(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["left"])
		deltimer(interval_timer_handle)
		var/delta = world.time - last_change
		if (delta < min_interval)
			interval_timer_handle = addtimer(CALLBACK(src, .proc/start_aiming), min_interval - delta, TIMER_STOPPABLE)
		else
			start_aiming()
		return FALSE
	return TRUE

/datum/click_handler/contact/MouseUp(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["left"])
		deltimer(interval_timer_handle)
		var/delta = world.time - last_change
		if (delta < min_interval)
			interval_timer_handle = addtimer(CALLBACK(src, .proc/stop_aiming), min_interval - delta, TIMER_STOPPABLE)
		else
			stop_aiming()
		return FALSE
	return TRUE