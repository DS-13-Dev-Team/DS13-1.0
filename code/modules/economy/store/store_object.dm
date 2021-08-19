#define STORE_OPEN	2
#define STORE_OPENING	1
#define STORE_CLOSED	-1
#define STORE_CLOSING	0

GLOBAL_VAR_INIT(number_of_store_kiosks, 0)

/obj/machinery/store
	name = "Store Kiosk"
	icon = 'icons/obj/machines/store.dmi'
	icon_state = "kiosk_on"

	layer = ABOVE_WINDOW_LAYER	//Above windows but below humans
	anchored = TRUE

	var/door_state = STORE_OPEN

	//Only one person can step into the store at once
	var/mob/living/carbon/human/occupant

	var/busy = FALSE
	var/open_time = 1.4 SECONDS
	var/close_time = 1.4 SECONDS
	var/light_time = 7 SECONDS
	var/bolt_time = 1 SECONDS
	buckle_pixel_shift = "x=0;y=8"

	//Sounds
	var/sound_open = 'sound/machines/store/store_door_open.ogg'
	var/sound_close = 'sound/machines/store/store_door_close.ogg'
	var/sound_bolt = 'sound/machines/store/store_bolt.ogg'
	var/sound_vend = 'sound/machines/store/store_vend.ogg'
	var/stall_time = 1 SECOND
	//
	var/obj/item/weapon/storage/internal/deposit/deposit_box

	var/datum/callback/transfer_callback

	var/machine_id

/obj/machinery/store/Initialize()
	.=..()
	deposit_box = new(src)
	machine_id = "[station_name()] Store #[GLOB.number_of_store_kiosks++]"



/obj/machinery/store/update_icon()
	var/light = TRUE
	if (operable())
		icon_state = "kiosk_on"
	else
		icon_state = "kiosk_off"
		light = FALSE

	cut_overlays()
	if (door_state == -1)
		var/image/I = image(icon, src, "door_closed",ABOVE_HUMAN_LAYER )
		add_overlay(I)
		light = FALSE

	//The store emits light as long as its powered on and the door is open
	if (light)
		set_light(l_max_bright = 0.8, l_inner_range = 1, l_outer_range = 4, l_color = COLOR_DEEP_SKY_BLUE)
	else
		set_light(0)


/*
	The store has enough room for one person. No others can enter it while someone is inside
*/
/obj/machinery/store/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (air_group)
		return TRUE

	if (occupant && isliving(mover) && mover != occupant && occupant.loc == get_turf(src))
		return FALSE

	.=..()


/obj/machinery/store/Crossed(atom/movable/O)
	if (!occupant && isliving(O))
		take_occupant(O)

	.=..()

/obj/machinery/store/Uncrossed(atom/movable/O)
	if (occupant == O)
		remove_occupant()

	.=..()


/obj/machinery/store/proc/take_occupant(var/mob/living/O)
	if (occupant)
		if (occupant == O)
			return
		remove_occupant()
	occupant = O


/obj/machinery/store/proc/remove_occupant()
	occupant = null


/obj/machinery/store/attackby(var/obj/item/I, var/mob/user)
	if (user == occupant)
		playsound(src, 'sound/machines/deadspace/menu_neutral.ogg', VOLUME_MID, TRUE)
		if (istype(I, /obj/item/weapon/spacecash/ewallet))
			return insert_chip(I, user)

		if (istype(I, /obj/item/store_schematic))
			return handle_schematic(I, user)

		if (istype(I, /obj/item/weapon/peng))
			return handle_peng(I, user)

		//Items used on the store go into the deposit box

		deposit_box.store_item(I, user)
		return TRUE
	else
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		.=..()


/obj/machinery/store/proc/insert_chip(var/obj/item/weapon/spacecash/ewallet/newchip, var/mob/user)
	if (!user && ismob(newchip.loc))
		user = newchip.loc
	if (chip)
		to_chat(user, "There is already a credit chip inserted!")
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		return TRUE

	if (user)
		user.unEquip(newchip)
	newchip.forceMove(src)
	chip = newchip

	update_open_uis()

/obj/machinery/store/proc/eject_chip()
	chip.forceMove(loc)
	if (occupant)
		occupant.equip_to_storage_or_hands(chip)
	chip = null

/obj/machinery/store/proc/close()
	//Must be open
	if (door_state != STORE_OPEN)
		return

	door_state = STORE_CLOSING
	flick_overlay_icon(close_time, icon(src.icon, "door_closing"), override_layer = ABOVE_HUMAN_LAYER)
	playsound(src, sound_close, VOLUME_MID, TRUE)
	spawn(close_time)
		door_state = STORE_CLOSED
		update_icon()


/obj/machinery/store/proc/open()
	//Must be closed
	if (door_state != STORE_CLOSED)
		return

	door_state = STORE_OPENING
	update_icon()
	flick_overlay_icon(open_time, icon(src.icon, "door_opening"), override_layer = ABOVE_HUMAN_LAYER)
	playsound(src, sound_open, VOLUME_MID, TRUE)
	spawn(open_time)
		door_state = STORE_OPEN


/obj/machinery/store/proc/vertical_light_effect()
	playsound(src, 'sound/machines/store/makeover.ogg', VOLUME_HIGH, FALSE, 5)
	flick_overlay_icon(light_time, icon(src.icon, "light_overlay"), override_layer = ABOVE_HUMAN_LAYER)


/obj/machinery/store/proc/makeover_animation()
	set waitfor = FALSE
	if (!occupant)
		return //We need an occupant to do this


	busy = TRUE
	bolt_occupant()
	sleep(bolt_time + stall_time)
	close()
	sleep(close_time + stall_time)
	vertical_light_effect()
	sleep(light_time + stall_time)
	transfer_callback.Invoke()

	//Things may have just been removed from the deposit box
	deposit_box.update_ui_data()
	update_open_uis()

	sleep(stall_time*2)
	open()
	sleep(open_time)
	sleep(stall_time*2)
	unbolt_occupant()
	busy = FALSE

/obj/machinery/store/proc/bolt_occupant(var/delay = TRUE)
	set waitfor = FALSE
	playsound(src, sound_bolt, VOLUME_HIGH, TRUE)
	if (delay)
		sleep(bolt_time+2)

	occupant.facedir(SOUTH)
	buckle_mob(occupant)

/obj/machinery/store/proc/unbolt_occupant()
	unbuckle_mob()


/*
	This proc is a gateway to the makeover function, it works in several situations
	1. The player clicks buy & transfer on a rig purchase. It will be called with a passed in rig.
		They may or may not be wearing a rig already, the new rig will be the target, currently worn is source

	2. The player clicks transfer with a rig in the deposit box
		That rig will be passed as target. If there are multiple the user will be asked to pick one

	3. The player clicks transfer with one or more modules (but no rig) in the deposit box
		They must be already wearing a rig for this, or it will fail with an error message to them
		Their current rig will be used as target, no source. The modules in the box will be taken as
*/
/obj/machinery/store/proc/start_transfer(var/obj/item/weapon/rig/target)
	if (!occupant)
		return
	var/obj/item/weapon/rig/source
	if (!target)
		if (!occupant.wearing_rig)
			to_chat(occupant, "No rig found! You need to purchase or be wearing a rig to use this feature.")
			return
		else
			target = occupant.wearing_rig

	else
		source = occupant.wearing_rig

	var/list/extra_modules = get_box_modules()


	//Do we have extra modules to feed in?
	//If not, we require both a target and a source to do anything
	if (!extra_modules.len && (!target))
		to_chat(occupant, "Nothing to transfer. Please purchase or deposit a new rig or module in order to perform a transfer.")
		return


	//Create a callback which we will trigger in the middle of the animation
	transfer_callback = CALLBACK(null, /proc/transfer_rig, target, source, extra_modules, deposit_box, occupant)

	//Time to start animating!
	makeover_animation()



/obj/machinery/store/proc/get_box_modules()
	.=list()
	for (var/obj/item/rig_module/RM in deposit_box)
		.+= RM