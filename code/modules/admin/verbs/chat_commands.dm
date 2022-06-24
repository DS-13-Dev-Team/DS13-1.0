/datum/tgs_chat_command/tgscheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"

/datum/tgs_chat_command/tgscheck/Run(datum/tgs_chat_user/sender, params)
	var/server = CONFIG_GET(string/server)
	return "Round Time: [gameTimestamp("hh:mm")] | Players: [length(GLOB.clients)] | Map: USG Ishimura | Round Status: [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active | Mode: [SSticker.mode.name]" : "Finishing | Mode: [SSticker.mode.name]") : "Starting"] | Link: [server ? server : "<byond://[world.internet_address]:[world.port]>"]"

