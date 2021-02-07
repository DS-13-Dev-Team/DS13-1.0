/obj/item/modular_computer/pda
	name = "\improper PDA"
	desc = "A very compact computer designed to keep its user always connected."
	icon = 'icons/obj/modular_pda.dmi'
	icon_state = "pda"
	icon_state_unpowered = "pda"
	hardware_flag = PROGRAM_PDA
	max_hardware_size = 1
	w_class = ITEM_SIZE_SMALL
	light_strength = 2
	slot_flags = SLOT_ID | SLOT_BELT
	stores_pen = TRUE
	stored_pen = /obj/item/weapon/pen

/obj/item/modular_computer/pda/Initialize()
	. = ..()
	enable_computer()

/obj/item/modular_computer/pda/AltClick(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	if(card_slot && istype(card_slot.stored_card))
		eject_id()
	else
		..()




// PDA box
/obj/item/weapon/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/weapon/storage/box/PDAs/Initialize()
	. = ..()

	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)

// PDA types
/obj/item/modular_computer/pda/medical
	icon_state = "pda-m"
	icon_state_unpowered = "pda-m"

/obj/item/modular_computer/pda/engineering
	icon_state = "pda-e"
	icon_state_unpowered = "pda-e"

/obj/item/modular_computer/pda/security
	icon_state = "pda-s"
	icon_state_unpowered = "pda-s"

/obj/item/modular_computer/pda/science
	icon_state = "pda-sci"
	icon_state_unpowered = "pda-sci"

/obj/item/modular_computer/pda/heads
	name = "command PDA"
	icon_state = "pda-h"
	icon_state_unpowered = "pda-h"

/obj/item/modular_computer/pda/heads/paperpusher
	stored_pen = /obj/item/weapon/pen/fancy

/obj/item/modular_computer/pda/heads/fl
	icon_state = "pda-fl"
	icon_state_unpowered = "pda-fl"

/obj/item/modular_computer/pda/heads/cseco
	icon_state = "pda-cseco"
	icon_state_unpowered = "pda-cseco"

/obj/item/modular_computer/pda/heads/ce
	icon_state = "pda-ce"
	icon_state_unpowered = "pda-ce"

/obj/item/modular_computer/pda/heads/smo
	icon_state = "pda-smo"
	icon_state_unpowered = "pda-smo"

/obj/item/modular_computer/pda/heads/cscio
	icon_state = "pda-cscio"
	icon_state_unpowered = "pda-cscio"

/obj/item/modular_computer/pda/heads/so
	icon_state = "pda-so"
	icon_state_unpowered = "pda-so"

/obj/item/modular_computer/pda/heads/dom
	icon_state = "pda-dom"
	icon_state_unpowered = "pda-dom"

/obj/item/modular_computer/pda/captain
	icon_state = "pda-c"
	icon_state_unpowered = "pda-c"

/obj/item/modular_computer/pda/ert
	icon_state = "pda-h"
	icon_state_unpowered = "pda-h"

/obj/item/modular_computer/pda/cargo
	icon_state = "pda-sup"
	icon_state_unpowered = "pda-sup"

/obj/item/modular_computer/pda/mining
	icon_state = "pda-mine"
	icon_state_unpowered = "pda-mine"