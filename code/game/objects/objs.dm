/obj
	layer = OBJ_LAYER

	var/obj_flags

	//Defense
	var/max_health = 10	//This is autocalculated based on size
	var/health = 10
	var/resistance = 0
	var/acid_resistance = 1	//Incoming acid damage is divided by this value

	//Used to store information about the contents of the object.
	var/list/matter
	var/list/matter_reagents
	var/w_class  = ITEM_SIZE_LARGE// Size of the object.
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 1
	var/sharp = 0		// whether this object cuts
	var/edge = 0		// whether this object is more likely to dismember
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = "brute"
	var/armor_penetration = 0
	var/anchor_fall = FALSE
	var/holographic = 0 //if the obj is a holographic object spawned by the holodeck
	var/list/tool_qualities = null// List of item qualities for tools system. See tools_and_qualities.dm.
	var/heat = 0 //Temperature of this object, mostly used to see if it can set other things on fire
	var/worksound = null	//Sound played when this object is used as a tool in tool operations


/obj/Destroy()
	STOP_PROCESSING(is_processing, src)
	.=..()

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if (istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)

		// check for TK users

		if (istype(usr, /mob/living/carbon/human))
			if(istype(usr.l_hand, /obj/item/tk_grab) || istype(usr.r_hand, /obj/item/tk_grab/))
				if(!(usr in nearby))
					if(usr.client && usr.machine==src)
						is_in_use = 1
						src.attack_hand(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	tgui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(var/hide)
	set_invisibility(hide ? INVISIBILITY_MAXIMUM : initial(invisibility))

/obj/proc/hides_under_flooring()
	return level == 1

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/obj/proc/damage_flags()
	. = 0
	if(has_edge(src))
		. |= DAM_EDGE
	if(is_sharp(src))
		. |= DAM_SHARP
		if(damtype == BURN)
			. |= DAM_LASER

/obj/attackby(obj/item/O as obj, mob/user as mob)
	if(obj_flags & OBJ_FLAG_ANCHORABLE)
		if(isWrench(O))
			wrench_floor_bolts(user)
			update_icon()
			return
	return ..()

/obj/proc/wrench_floor_bolts(mob/user, delay=20)
	playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
	if(anchored)
		user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
	else
		user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
	if(do_after(user, delay, src))
		if(!src) return
		to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
		anchored = !anchored
	return 1

/obj/attack_hand(mob/living/user)
	if(Adjacent(user))
		add_fingerprint(user)
	..()

/obj/proc/get_cell()
	return

/obj/proc/get_matter()
	return matter

/obj/proc/eject_item(var/obj/item/I, var/mob/living/M)
	if(!I || !M.is_advanced_tool_user())
		return FALSE
	M.put_in_hands(I)
	playsound(src.loc, 'sound/weapons/guns/interact/pistol_magin.ogg', 75, 1)
	M.visible_message(
		"[M] remove [I] from [src].",
		SPAN_NOTICE("You remove [I] from [src].")
	)
	return TRUE

/obj/proc/insert_item(var/obj/item/I, var/mob/living/M)
	if(!I || !M.unEquip(I))
		return FALSE
	I.forceMove(src)
	playsound(src.loc, 'sound/weapons/guns/interact/pistol_magout.ogg', 75, 1)
	to_chat(M, SPAN_NOTICE("You insert [I] into [src]."))
	return TRUE


//Object specific version of the generic proc, for overriding
/obj/proc/is_hot()
	return heat


//Return true if this is a flat surface which people could work on
/obj/proc/is_surface()
	return FALSE


//To be called from things that spill objects on the floor.
//Makes an object move around randomly for a couple of tiles
//Emerge var tells whether or not to remove the item from objects its currently inside
/obj/proc/tumble(var/dist = 2, var/emerge = TRUE)
	set waitfor = FALSE
	if (anchored)
		return

	if (!isturf(loc))
		if (emerge)
			forceMove(get_turf(src))
		else
			return

	if (dist >= 1)
		dist += rand(0,1)
		for(var/i = 1, i <= dist, i++)
			if(src)
				step(src, pick(NORTH,SOUTH,EAST,WEST))
				sleep(rand(2,4))