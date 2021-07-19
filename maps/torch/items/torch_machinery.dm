//Shouldn't be a lot in here, only torch versions of existing machines that need a different access req or something along those lines.
//telecommunications gubbins for torch-specific networks

/obj/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "relay", "c_relay", "s_relay", "m_relay", "r_relay", "b_relay", "1_relay", "2_relay", "3_relay", "4_relay", "5_relay", "s_relay", "science", "medical",
	"supply", "service", "common", "command", "engineering", "security", "mining", "unused",
 	"receiverA", "broadcasterA")

/obj/machinery/telecomms/receiver/preset_right
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, MIN_FREQ)

/obj/machinery/telecomms/bus/preset_two
	freq_listening = list(SUP_FREQ, SRV_FREQ, MIN_FREQ)
	autolinkers = list("processor2", "supply", "service", "mining", "unused")

/obj/machinery/telecomms/server/presets/service
	id = "Service and Mining Server"
	freq_listening = list(SRV_FREQ, MIN_FREQ)
	channel_tags = list(
		list(SRV_FREQ, "Service", COMMS_COLOR_SERVICE),
		list(MIN_FREQ, "Mining", COMMS_COLOR_MINING)
	)
	autolinkers = list("service", "mining")

/obj/machinery/telecomms/server/presets/mining
	id = "Utility Server"
	freq_listening = list(MIN_FREQ)
	channel_tags = list(list(MIN_FREQ, "Mining", COMMS_COLOR_MINING))
	autolinkers = list("Mining")