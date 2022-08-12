/// An info button that, when clicked, puts some text in the user's chat
/obj/effect/abstract/info
	name = "info"
	icon = 'icons/effects/effects.dmi'
	icon_state = "info"

	/// What should the info button display when clicked?
	var/info_text

/obj/effect/abstract/info/Initialize(mapload, info_text)
	. = ..()

	if (!isnull(info_text))
		src.info_text = info_text

/obj/effect/abstract/info/Click()
	. = ..()
	to_chat(usr, info_text)

/obj/effect/abstract/info/MouseEntered(location, control, params)
	. = ..()
	icon_state = "info_hovered"

/obj/effect/abstract/info/MouseExited()
	. = ..()
	icon_state = initial(icon_state)

///The abstract effect ignores even more effects and is often typechecked for atoms that should truly not be fucked with.
/obj/effect/abstract

/obj/effect/abstract/singularity_pull()
	return

/obj/effect/abstract/singularity_act()
	return

/obj/effect/dummy/singularity_pull()
	return

/obj/effect/dummy/singularity_act()
	return

