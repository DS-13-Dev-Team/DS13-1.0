/*
	Opens a menu that allows admins to send messages on any channel, under a pseudonym
*/

#define ADMINCOMM_RADIO	"radio"
#define ADMINCOMM_COMMUNICATION	"communication"

//Reference:
//List of all radio channels is "radiochannels", it is an unmanaged global associative list containing name = frequency
/datum/extension/admin_communicate
	expected_type = /client
	flags = EXTENSION_FLAG_IMMEDIATE
	var/pseudonym = "Mysterious Voice"


	var/selected_channel_type = ADMINCOMM_RADIO
	var/selected_channel = "Common"	//In the case of a radio, this is the channel tag of that channel


/datum/extension/admin_communicate/proc/communicate(var/message)
	if (selected_channel_type == ADMINCOMM_RADIO)
		communicate_radio(message, radiochannels[selected_channel])	//We get the frequency of the channel from the global list

//Sends a message over a radio channel
/datum/extension/admin_communicate/proc/communicate_radio(var/message, var/channel)
	//Radio.dm, 298
	//#### Grab the connection datum ####//
	var/datum/radio_frequency/connection = radio_controller.return_frequency(channel)

	if (!istype(connection))
		return 0

	Broadcast_SimpleMessage(
	source = pseudonym, //Who is talking
	frequency = channel,	//Channel we're using
	text = message, 	//Message we send
	data = -1,		//Value -1 broadcasts to whole world
	M = null, //No mob, this is only used for understanding
	compression = 0,	//Nonzero values cause gibberish
	level = 0, 	//Ignored when using data = -1
	channel_tag = selected_channel,	//We already have it
	channel_color = null,	//Not used
	class = frequency_span_class(channel)
	)

/client/verb/send_test_message(var/message as text)
	set name = "Admin Communicate"
	set category = "Admin"
	var/datum/extension/admin_communicate/AC = set_extension(src, /datum/extension/admin_communicate)
	AC.communicate(message)