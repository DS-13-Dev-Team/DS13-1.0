/*
	Given a comms channel and a level, this returns a list of all possible radio devices which could hear a message sent with those
	parameters.

	The channel must be one of the plaintext keys from controllers/communications.dm, radiochannels list. For convenience this list is...
	var/list/radiochannels = list(
	"Common"		= PUB_FREQ,
	"Science"		= SCI_FREQ,
	"Command"		= COMM_FREQ,
	"Medical"		= MED_FREQ,
	"Engineering"	= ENG_FREQ,
	"Security" 		= SEC_FREQ,
	"Response Team" = ERT_FREQ,
	"Special Ops" 	= DTH_FREQ,
	"Mercenary" 	= SYND_FREQ,
	"Raider"		= RAID_FREQ,
	"Mining"		= MIN_FREQ,
	"Supply" 		= SUP_FREQ,
	"Service" 		= SRV_FREQ,
	"AI Private"	= AI_FREQ,
	"Entertainment" = ENT_FREQ,
	"Medical(I)"	= MED_I_FREQ,
	"Security(I)"	= SEC_I_FREQ)

*/
/proc/get_channel_radios(var/channel)
	channel = radiochannels[channel]
	var/datum/radio_frequency/connection = radio_controller.return_frequency(channel)

	var/list/radios = list()
	for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])
		radios += R


	return radios


/*
	Wrapper for the above, gets all of the mobs who can hear these radios
*/
/proc/get_channel_listeners(var/channel)
	var/list/radios = get_channel_radios(channel)

	channel = radiochannels[channel]
	var/datum/radio_frequency/connection = radio_controller.return_frequency(channel)
	var/display_freq = connection.frequency

	var/list/receive = list()
	for (var/obj/item/device/radio/R in radios)
		receive |= R.send_hear(display_freq)

	return receive

