/*
	Very simple click handler. Calls a proc when the user clicks something, or rightclicks to cancel
*/
/datum/click_handler/target
	var/datum/callback/call_on_click
	var/stopped = FALSE

/datum/click_handler/target/New(var/mob/user, var/datum/callback/C)
	.=..()
	call_on_click = C


/datum/click_handler/target/OnLeftClick(var/atom/A, var/params)
	call_on_click.Invoke(A, params)
	stop()

//Rightclick: Cancel placement without spawning anything
/datum/click_handler/target/OnRightClick(var/atom/A, var/params)
	stop()

/datum/click_handler/target/proc/start()
	user.client.show_popup_menus = FALSE	//We need to turn this off in order to recieve rightclicks

/datum/click_handler/target/proc/stop()
	if (!stopped)
		stopped = TRUE
		if (user && user.client)
			user.client.show_popup_menus = TRUE
		user.RemoveClickHandler(src)