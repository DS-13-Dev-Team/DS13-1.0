/datum/nanoui/proc/update_open_uis(var/O)
	SSnano.update_uis(O)

/datum/nanoui/proc/try_update_ui(mob/user, src_object, ui_key, datum/nanoui/ui, data, force_open = 0)
	if (isnull(ui)) // no ui has been passed, so we'll search for one
	{
		ui = SSnano.get_open_ui(user, src_object, ui_key)
	}
	if (!isnull(ui))
		// The UI is already open
		if (!force_open)
			ui.push_data(data)
			return ui
		else
			//testing("nanomanager/try_update_ui mob [user.name] [src_object:name] [ui_key] [force_open] - forcing opening of ui")
			ui.close()
	return null

// nanomanager, the manager for Nano UIs
var/datum/nanoui/nanomanager = new()
