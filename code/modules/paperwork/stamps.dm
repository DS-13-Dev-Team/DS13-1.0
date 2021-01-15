/obj/item/weapon/stamp
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

/obj/item/weapon/stamp/captain
	name = "captain's rubber stamp"
	icon_state = "stamp-cap"

/obj/item/weapon/stamp/fl
	name = "first lieutenant's rubber stamp"
	icon_state = "stamp-fl"

/obj/item/weapon/stamp/cseco
	name = "chief security officer's rubber stamp"
	icon_state = "stamp-cseco"

/obj/item/weapon/stamp/security
	name = "security's rubber stamp"
	icon_state = "stamp-sec"

/obj/item/weapon/stamp/ce
	name = "chief engineer's rubber stamp"
	icon_state = "stamp-ce"

/obj/item/weapon/stamp/engineering
	name = "engineering rubber stamp"
	icon_state = "stamp-engi"

/obj/item/weapon/stamp/cscio
	name = "chief science officer's rubber stamp"
	icon_state = "stamp-cscio"

/obj/item/weapon/stamp/science
	name = "science rubber stamp"
	icon_state = "stamp-sci"

/obj/item/weapon/stamp/smo
	name = "senior medical officer's rubber stamp"
	icon_state = "stamp-smo"

/obj/item/weapon/stamp/medical
	name = "medical rubber stamp"
	icon_state = "stamp-med"

/obj/item/weapon/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"

/obj/item/weapon/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"

/obj/item/weapon/stamp/internalaffairs
	name = "internal affairs rubber stamp"
	icon_state = "stamp-intaff"

/obj/item/weapon/stamp/centcomm
	name = "centcomm rubber stamp"
	icon_state = "stamp-cent"

/obj/item/weapon/stamp/dom
	name = "director of mining's rubber stamp"
	icon_state = "stamp-dom"

/obj/item/weapon/stamp/foreman
	name = "foreman's rubber stamp"
	icon_state = "stamp-fm"

/obj/item/weapon/stamp/mining
	name = "mining rubber stamp"
	icon_state = "stamp-mining"

/obj/item/weapon/stamp/so
	name = "supply officer's rubber stamp"
	icon_state = "stamp-so"

/obj/item/weapon/stamp/cargo
	name = "cargo rubber stamp"
	icon_state = "stamp-cargo"

// Syndicate stamp to forge documents.
/obj/item/weapon/stamp/chameleon/attack_self(mob/user as mob)

	var/list/stamp_types = typesof(/obj/item/weapon/stamp) - src.type // Get all stamp types except our own
	var/list/stamps = list()

	// Generate them into a list
	for(var/stamp_type in stamp_types)
		var/obj/item/weapon/stamp/S = new stamp_type
		stamps[capitalize(S.name)] = S

	var/list/show_stamps = list("EXIT" = null) + sortList(stamps) // the list that will be shown to the user to pick from

	var/input_stamp = input(user, "Choose a stamp to disguise as.", "Choose a stamp.") in show_stamps

	if(user && src in user.contents)

		var/obj/item/weapon/stamp/chosen_stamp = stamps[capitalize(input_stamp)]

		if(chosen_stamp)
			SetName(chosen_stamp.name)
			icon_state = chosen_stamp.icon_state
