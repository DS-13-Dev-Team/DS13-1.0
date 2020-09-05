/obj/machinery/mech_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "mechatronic sensor"
	desc = "Regulates mech movement."
	anchored = 1
	density = 1
	throwpass = 1
	use_power = 1
	layer = ABOVE_WINDOW_LAYER
	power_channel = EQUIP
	var/on = 0
	var/id_tag = null

	var/frequency = 1379
	var/datum/radio_frequency/radio_connection