/*
	Opens a menu that allows admins to send messages on any channel, under a pseudonym
*/


//Ingame radio channels. Engineering, security, etc. Generally in-character
#define ADMINCOMM_RADIO	"radio"

//Meta channels. OOC, LOOC, AOOC, deadchat, necrochat, praying. These things are variably IC or not
//What they all share is using the decl/communication_channel system, hence the odd grouping
#define ADMINCOMM_META	"meta"

//Reference:
//List of all radio channels is "radiochannels", it is an unmanaged global associative list containing name = frequency
/datum/extension/admin_communicate
	expected_type = /client
	flags = EXTENSION_FLAG_IMMEDIATE
	var/pseudonym = "Mysterious Voice"


	var/selected_channel_type = ADMINCOMM_RADIO
	var/selected_channel = "Common"	//In the case of a radio, this is the channel tag of that channel

	var/draft_message = ""	//Holds an unsent message. Cleared when message is sent

	var/content_data	//Things that don't change


	//This is an assoc list of name = type, used for the decl/communication_channels
	var/list/meta_names_and_types = list()



/datum/extension/admin_communicate/proc/communicate()
	var/message = draft_message

	if (selected_channel_type == ADMINCOMM_RADIO)
		communicate_radio(message, radiochannels[selected_channel])	//We get the frequency of the channel from the global list
	else if (selected_channel_type == ADMINCOMM_META)
		communicate_meta()
	draft_message = ""

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


/datum/extension/admin_communicate/proc/communicate_meta(var/message, var/channel)
	var/channel_type = meta_names_and_types[selected_channel]
	sanitize_and_communicate(channel_type, src, draft_message, pseudonym)

/datum/extension/admin_communicate/proc/get_content_data()
	if (!content_data)
		content_data = list()

		var/list/radios = list()
		for (var/channel in radiochannels)
			radios += channel

		content_data["radio"] = radios

		//These are OOC comm channels, like necrochat, ooc itself, LOOC, praying, antag ooc. deadchat

		//This is an assoc list of type = object
		var/list/channels = decls_repository.get_decls_of_subtype(/decl/communication_channel)

		var/list/meta_names = list()
		for (var/ctype in channels)
			var/decl/communication_channel/C = channels[ctype]	//Get the object
			if (C.allow_admincomm)
				meta_names += C.name
				meta_names_and_types[C.name] = ctype	//Store name and type pairs

		content_data["channels"] = meta_names


	return content_data

/datum/extension/admin_communicate/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = get_content_data()
	data["src"] = "\ref[src]"
	data["pseudonym"]	=	pseudonym
	data["selected"] = selected_channel
	data["message"] = draft_message


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "admin_communicate.tmpl", "Communication Menu", 800, 700, state = GLOB.interactive_state)
		ui.set_initial_data(data)
		ui.set_auto_update(FALSE)
		ui.open()


/datum/extension/admin_communicate/Topic(href, href_list)
	if(..())
		return

	if (href_list["name"])
		pseudonym = href_list["name"]
	if (href_list["message"])
		draft_message = href_list["message"]
	if (href_list["select"])
		selected_channel = href_list["select"]
		selected_channel_type = href_list["select_type"]
	if (href_list["send"])
		if (draft_message)
			communicate()
	SSnano.update_uis(src)










/client/proc/admin_communicate()
	set name = "Admin Communicate"
	set category = "Admin"
	var/datum/extension/admin_communicate/AC = get_or_create_extension(src, /datum/extension/admin_communicate)
	AC.ui_interact(mob)