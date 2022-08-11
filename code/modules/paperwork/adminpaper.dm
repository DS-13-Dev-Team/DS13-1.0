//Adminpaper - it's like paper, but more adminny!
/obj/item/paper/admin
	name = "administrative paper"
	desc = "If you see this, something has gone horribly wrong."
	var/datum/admins/admindatum = null

	var/interactions = null
	var/isCrayon = 0
	var/origin = null
	var/mob/sender = null
	var/obj/machinery/photocopier/faxmachine/destination

	var/header = null
	var/headerOn = TRUE

	var/footer = null
	var/footerOn = FALSE

	var/logo_list = list("ceclogo.png")
	var/logo = ""

/obj/item/paper/admin/ui_data(mob/user)
	.=..()
	.["edit_mode"] = 1

/obj/item/paper/admin/ui_close(mob/user)
	if(tgui_alert(user, "Send Fax?", "Fax Paper", list("Yes", "No")) == "Yes")
		admindatum.faxCallback(src, destination)
	else
		if(admindatum.faxreply == src)
			admindatum.faxreply = null
		qdel(src)
