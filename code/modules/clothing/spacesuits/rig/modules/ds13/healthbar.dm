/obj/item/rig_module/healthbar
	name = "vitals monitor"
	desc = "Shows an informative health readout on the user's spine."
	interface_name = "vitals monitor"
	interface_desc = "Shows an informative health readout on the user's spine."
	icon_state = "healthbar"
	use_power_cost = 0
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	suit_overlay_active = "healthbar_100"
	suit_overlay_inactive = "healthbar_100"
	suit_overlay_used = "healthbar_100"
	suit_overlay_flags = KEEP_APART

	var/mob/living/carbon/human/user
	process_with_rig = FALSE
	module_tags = list(LOADOUT_TAG_RIG_HEALTHBAR = 1)

	base_type = /obj/item/rig_module/healthbar

	var/tracking_level = RIG_SENSOR_OFF
	var/tracking_mode = RIG_SENSOR_MANUAL

/obj/item/rig_module/healthbar/Initialize()
	. = ..()
	var/mutable_appearance/emissive = emissive_appearance('icons/mob/onmob/rig_modules.dmi', "healthbar_100", MOB_LAYER)
	suit_overlay_active.overlays += emissive
	suit_overlay_inactive.overlays += emissive
	suit_overlay_used.overlays += emissive
	emissive = null
	tracking_mode = pick(RIG_SENSOR_MANUAL, RIG_SENSOR_AUTOMATIC)

	if(tracking_mode == RIG_SENSOR_AUTOMATIC)
		GLOB.vitals_auto_update_tracking += src
		automatic_tracking_update()

	else
		tracking_level = pick(RIG_SENSOR_OFF, RIG_SENSOR_BINARY, RIG_SENSOR_VITAL, RIG_SENSOR_TRACKING)

/obj/item/rig_module/healthbar/Destroy()
	unregister_user()
	GLOB.vitals_auto_update_tracking -= src
	.=..()

/obj/item/rig_module/healthbar/rig_equipped(var/mob/user, var/slot)
	register_user(user)

/obj/item/rig_module/healthbar/rig_unequipped(var/mob/user, var/slot)
	unregister_user()

/obj/item/rig_module/healthbar/installed(obj/item/rig/new_holder)
	. = ..()
	if(new_holder.wearer)
		register_user(new_holder.wearer)

/obj/item/rig_module/healthbar/uninstalled(obj/item/rig/former, mob/living/user)
	unregister_user()
	.=..()

/obj/item/rig_module/healthbar/proc/register_user(var/mob/newuser)
	user = newuser
	RegisterSignal(user, COMSIG_MOB_HEALTH_CHANGED, .proc/update)
	RegisterSignal(user, COMSIG_LIVING_DEATH, .proc/death)
	RegisterSignal(user, COMSIG_CARBON_HEART_STOPPED, .proc/heart_stop)
	holder.healthbar = src

/obj/item/rig_module/healthbar/proc/unregister_user()
	if(user)
		UnregisterSignal(user, list(COMSIG_CARBON_HEART_STOPPED, COMSIG_MOB_HEALTH_CHANGED, COMSIG_LIVING_DEATH))
		user = null
		holder.healthbar = null

/obj/item/rig_module/healthbar/proc/update()
	SIGNAL_HANDLER
	if (QDELETED(user) || QDELETED(holder) || holder.loc != user)
		//Something broked
		unregister_user()
		return

	var/percentage = user.healthpercent()

	//Just in case
	percentage = clamp(percentage, 0, 100)

	if (user.stat == DEAD)
		percentage = 0

	//95% health is good enough, lets not make people obsess about getting it to blue
	if (percentage > 95)
		percentage = 100
	else
		percentage = round(percentage, 10)

	suit_overlay.icon_state = "healthbar_[percentage]"
	suit_overlay_inactive.icon_state = "healthbar_[percentage]"
	suit_overlay_active.icon_state = "healthbar_[percentage]"
	suit_overlay_used.icon_state = "healthbar_[percentage]"
	holder.update_wear_icon()


/obj/item/rig_module/healthbar/proc/death()
	SIGNAL_HANDLER
	playsound(src, 'sound/effects/rig/modules/flatline.ogg', VOLUME_MAX, 0, 4)
	update()

/obj/item/rig_module/healthbar/proc/heart_stop()
	SIGNAL_HANDLER
	playsound(src, 'sound/effects/caution.ogg', VOLUME_MAX, 0, 4)
	update()

// Automatically updates tracking level depending on current station alert
// Should be called only if person is currently using automatic mode (GLOB.rig_update_tracking)
/obj/item/rig_module/healthbar/proc/automatic_tracking_update()
	var/decl/security_state/SecState = decls_repository.get_decl(GLOB.using_map.security_state)
// If you have better idea how to make this without refactoring security state then tell me
	if(SecState.current_security_level.name == STATION_ALERT_GREEN)
		tracking_level = RIG_SENSOR_BINARY

	else if(SecState.current_security_level.name == STATION_ALERT_BLUE)
		tracking_level = RIG_SENSOR_VITAL

	else if(SecState.current_security_level.name == STATION_ALERT_RED)
		tracking_level = RIG_SENSOR_TRACKING

	else if(SecState.current_security_level.name == STATION_ALERT_DELTA)
		tracking_level = RIG_SENSOR_TRACKING

/*
	Advanced Vital Monitor
	Has a built in death alarm
*/
/obj/item/rig_module/healthbar/advanced
	name = "Vitals Monitor: Advanced"
	desc = "Shows an informative health readout on the user's spine, and notifies local emergency services in the event of their untimely demise"
	interface_name = "Vitals Monitor: Advanced"
	interface_desc = "Shows an informative health readout on the user's spine, and notifies local emergency services in the event of their untimely demise"

	module_tags = list(LOADOUT_TAG_RIG_HEALTHBAR = 2)

/obj/item/rig_module/healthbar/advanced/death()
	.=..()

	//First of all, sending a message on emergency channels

	var/mobname = user.real_name
	var/area/t = get_area(user)
	var/location = t.name
	if(!t.requires_power) // We assume areas that don't use power are some sort of special zones
		var/area/default = world.area
		location = initial(default.name)
	var/death_message = "[mobname] has died in [location]!"

	//Send a message to these radio channels
	for(var/channel in list("Security", "Medical", "Command"))
		var/frequency = radiochannels[channel]
		var/datum/radio_frequency/connection = radio_controller.return_frequency(frequency)

		if (!istype(connection))
			return 0

		Broadcast_SimpleMessage(
		source = "[mobname]'s Vital Monitor", //Who is talking
		frequency = frequency,	//Channel we're using
		text = death_message, 	//Message we send
		data = -1,		//Value -1 broadcasts to every kind of radio
		M = null, //No mob, this is only used for understanding
		compression = 0,	//Nonzero values cause gibberish
		level = 0, 	//Ignored when using data = -1
		channel_tag = channel,	//We already have it
		channel_color = null,	//Not used
		class = frequency_span_class(frequency)
		)





	//And, lets also send AUDIO THROUGH THE RADIO!!
	var/list/hearer_mobs = list()
	for(var/channel in list("Security", "Medical", "Command"))
		hearer_mobs |= get_channel_listeners(channel) //This gets a list of mobs that can hear this channel
		//We use |= to prevent duplicates


	for (var/mob/M in hearer_mobs)
		if (!M.client)
			continue //Disconnected people cant hear sounds
		//Send the sound to them. playsound_local does a sound that's only heard by this mob
		M.playsound_local(get_turf(M), 'sound/effects/rig/modules/flatline.ogg', VOLUME_HIGH, TRUE)