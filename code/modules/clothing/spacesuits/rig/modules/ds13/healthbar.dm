/obj/item/rig_module/healthbar
	name = "vitals monitor"
	desc = "Shows an informative health readout on the user's spine."
	interface_name = "vitals monitor"
	interface_desc = "Shows an informative health readout on the user's spine."
	icon_state = "healthbar"
	use_power_cost = 0
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	suit_overlay_inactive = "healthbar_100"
	suit_overlay_active = "healthbar_100"
	suit_overlay_used = "healthbar_100"
	suit_overlay = "healthbar_100"
	var/mob/living/carbon/human/user
	process_with_rig = FALSE

	suit_overlay_layer = EYE_GLOW_LAYER
	suit_overlay_plane = EFFECTS_ABOVE_LIGHTING_PLANE
	suit_overlay_flags = KEEP_APART


	base_type = /obj/item/rig_module/healthbar

/obj/item/rig_module/healthbar/proc/register_user(var/mob/newuser)
	user = newuser
	GLOB.updatehealth_event.register(user, src, /obj/item/rig_module/healthbar/proc/update)
	GLOB.death_event.register(user, src, /obj/item/rig_module/healthbar/proc/death)

/obj/item/rig_module/healthbar/proc/unregister_user()
	GLOB.updatehealth_event.unregister(user, src, /obj/item/rig_module/healthbar/proc/update)
	GLOB.death_event.unregister(user, src, /obj/item/rig_module/healthbar/proc/death)
	user = null

/obj/item/rig_module/healthbar/rig_equipped(var/mob/user, var/slot)
	register_user(user)

/obj/item/rig_module/healthbar/rig_unequipped(var/mob/user, var/slot)
	unregister_user()


/obj/item/rig_module/healthbar/proc/update()
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

	suit_overlay = "healthbar_[percentage]"
	suit_overlay_inactive = "healthbar_[percentage]"
	suit_overlay_active = "healthbar_[percentage]"
	suit_overlay_used = "healthbar_[percentage]"
	holder.update_wear_icon()


/obj/item/rig_module/healthbar/proc/death()
	playsound(src, 'sound/effects/rig/modules/flatline.ogg', VOLUME_MAX, 0, 4)
	update()




/*
	Advanced Vital Monitor
	Has a built in death alarm
*/
/obj/item/rig_module/healthbar/advanced
	name = "Vitals Monitor: Advanced"
	desc = "Shows an informative health readout on the user's spine, and notifies local emergency services in the event of their untimely demise"
	interface_name = "Vitals Monitor: Advanced"
	interface_desc = "Shows an informative health readout on the user's spine, and notifies local emergency services in the event of their untimely demise"



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