/obj/item/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-so"
	item_state = "stamp"
	throwforce = 0
	w_class = ITEM_SIZE_TINY

	throw_range = 15
	matter = list(MATERIAL_STEEL = 60)
	attack_verb = list("stamped")

/obj/item/stamp/captain
	name = "captain's rubber stamp"
	icon_state = "stamp-cap"

/obj/item/stamp/fl
	name = "first lieutenant's rubber stamp"
	icon_state = "stamp-fl"

/obj/item/stamp/cseco
	name = "chief security officer's rubber stamp"
	icon_state = "stamp-cseco"

/obj/item/stamp/security
	name = "security's rubber stamp"
	icon_state = "stamp-sec"

/obj/item/stamp/ce
	name = "chief engineer's rubber stamp"
	icon_state = "stamp-ce"

/obj/item/stamp/engineering
	name = "engineering rubber stamp"
	icon_state = "stamp-engi"

/obj/item/stamp/cscio
	name = "chief science officer's rubber stamp"
	icon_state = "stamp-cscio"

/obj/item/stamp/science
	name = "science rubber stamp"
	icon_state = "stamp-sci"

/obj/item/stamp/smo
	name = "senior medical officer's rubber stamp"
	icon_state = "stamp-smo"

/obj/item/stamp/medical
	name = "medical rubber stamp"
	icon_state = "stamp-med"

/obj/item/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"

/obj/item/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"

/obj/item/stamp/internalaffairs
	name = "internal affairs rubber stamp"
	icon_state = "stamp-intaff"

/obj/item/stamp/centcomm
	name = "centcomm rubber stamp"
	icon_state = "stamp-cent"

/obj/item/stamp/dom
	name = "director of mining's rubber stamp"
	icon_state = "stamp-dom"

/obj/item/stamp/foreman
	name = "foreman's rubber stamp"
	icon_state = "stamp-fm"

/obj/item/stamp/mining
	name = "mining rubber stamp"
	icon_state = "stamp-mining"

/obj/item/stamp/so
	name = "supply officer's rubber stamp"
	icon_state = "stamp-so"

/obj/item/stamp/cargo
	name = "cargo rubber stamp"
	icon_state = "stamp-cargo"

// Syndicate stamp to forge documents.
/obj/item/stamp/chameleon/attack_self(mob/user as mob)

	var/list/stamp_types = typesof(/obj/item/stamp) - src.type // Get all stamp types except our own
	var/list/stamps = list()

	// Generate them into a list
	for(var/stamp_type in stamp_types)
		var/obj/item/stamp/S = new stamp_type
		stamps[capitalize(S.name)] = S

	var/list/show_stamps = list("EXIT" = null) + sortList(stamps) // the list that will be shown to the user to pick from

	var/input_stamp = input(user, "Choose a stamp to disguise as.", "Choose a stamp.") in show_stamps

	if(user && (src in user.contents))

		var/obj/item/stamp/chosen_stamp = stamps[capitalize(input_stamp)]

		if(chosen_stamp)
			SetName(chosen_stamp.name)
			icon_state = chosen_stamp.icon_state
