/obj/item/weapon/implanter/codex
	name = "implanter (codex)"
	imp = /obj/item/weapon/implant/codex

/obj/item/weapon/implant/codex
	name = "codex implant"
	desc = "It has 'DON'T PANIC' embossed on the casing in friendly letters."

/obj/item/weapon/implant/codex/implanted(mob/source)
	. = ..(source)
	to_chat(usr, "<span class='notice'>You feel the brief sensation of having an entire encyclopedia at the tip of your tongue as the codex implant meshes with your nervous system.</span>")
