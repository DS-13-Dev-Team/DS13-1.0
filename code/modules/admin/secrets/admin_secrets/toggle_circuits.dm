/datum/admin_secret_item/admin_secret/toggle_circuits
	name = "Toggle Circuits"

/datum/admin_secret_item/admin_secret/toggle_circuits/execute()
	if(!(. = ..()))
		return
	var/choice = tgui_alert(usr, "Circuits are currently [SScircuit_components.can_fire ? "enabled" : "disabled"].","Toggle Circuits", list(SScircuit_components.can_fire ? "Disable" : "Enable","Cancel"))
	if(choice == "Disable")
		SScircuit_components.disable()
	else if(choice == "Enable")
		SScircuit_components.enable()