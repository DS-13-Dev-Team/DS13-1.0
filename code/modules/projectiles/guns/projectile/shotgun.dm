/obj/item/weapon/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "The mass-produced W-T Remmington 29x shotgun is a favourite of police and security forces on many worlds. Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	handle_casings = HOLD_CASINGS
	one_hand_penalty = -10
	var/recentpump = 0 // to prevent spammage
	wielded_item_state = "gun_wielded"
	load_sound = 'sound/weapons/guns/interaction/shotgun_instert.ogg'

/obj/item/weapon/gun/projectile/shotgun/pump/consume_next_projectile()
	if(chambered)
		return chambered.BB
	return null

/obj/item/weapon/gun/projectile/shotgun/pump/attack_self(mob/living/user as mob)
	if(world.time >= recentpump + 10)
		pump(user)
		recentpump = world.time

/obj/item/weapon/gun/projectile/shotgun/pump/proc/pump(mob/M as mob)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered.forceMove(get_turf(src))//Eject casing
		if(LAZYLEN(chambered.fall_sounds))
			playsound(loc, pick(chambered.fall_sounds), 50, 1)
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	update_icon()

/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders."
	icon_state = "cshotgun"
	item_state = "cshotgun"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	max_shells = 7 //match the ammo box capacity, also it can hold a round in the chamber anyways, for a total of 8.
	ammo_type = /obj/item/ammo_casing/shotgun
	one_hand_penalty = -15 //a little heavier than the regular shotgun

/obj/item/weapon/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "dshotgun"
	//SPEEDLOADER because rapid unloading.
	//In principle someone could make a speedloader for it, so it makes sense.
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = CYCLE_CASINGS
	max_shells = 2
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 1)
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	one_hand_penalty = -10
	wielded_item_state = "gun_wielded"

	burst_delay = 0
	firemodes = list(
		list(mode_name="fire one barrel at a time", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare
	name = "signal shotgun"
	desc = "A double-barreled shotgun meant to fire signal flash shells."
	ammo_type = /obj/item/ammo_casing/shotgun/flash

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/unload_ammo(user, allow_dump)
	..(user, allow_dump=1)

//this is largely hacky and bad :(	-Pete
/obj/item/weapon/gun/projectile/shotgun/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	if(w_class > 3 && (istype(A, /obj/item/weapon/tool/saw/circular) || istype(A, /obj/item/weapon/melee/energy)))
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(loaded.len)
			for(var/i in 1 to max_shells)
				Fire(user, user)	//will this work? //it will. we call it twice, for twice the FUN
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30, src))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			item_state = "sawnshotgun"
			w_class = ITEM_SIZE_NORMAL
			force = 5
			one_hand_penalty = 0
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= (SLOT_BELT|SLOT_HOLSTER) //but you can wear it on your belt (poorly concealed under a trenchcoat, ideally) - or in a holster, why not.
			SetName("sawn-off shotgun")
			desc = "Omar's coming!"
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
	else
		..()

/obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
	name = "sawn-off shotgun"
	desc = "Omar's coming!"
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	w_class = ITEM_SIZE_NORMAL
	force = 5
	one_hand_penalty = 0

/obj/item/weapon/gun/projectile/shotgun/bola_lancher
	name = "SCL Shotgun"
	desc = "The SCL Shotgun is a close to medium-ranged weapon developed by the Sovereign Colonies Armed Forces and utilized by SCAF Legionaries. \
	The shotgun has remained in use in private security and police departments as a riot-control tool, given its ability to fire bolas shells for capture and arrest, or lethal slugs in life-threatening situations. \
	The SCL Shotgun is magazine loaded and is effective at short range or for fugitive capture."
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "scl_shotgun"
	item_state = "scl_shotgun"
	wielded_item_state = "scl_shotgun-wielded"
	var/icon_loaded = "scl_shotgun_loaded"
	slot_flags = SLOT_BELT
	magazine_type = /obj/item/ammo_magazine/shotgun
	w_class = ITEM_SIZE_HUGE
	load_method = MAGAZINE
	caliber = "shotgun"
	force = 5
	one_hand_penalty = 0
	fire_delay = 20
	one_hand_penalty = 6 //It's a shotgun, brace yourself before firing.
	firemodes = list(
		list(mode_name = "shotgun", fire_delay = 1 SECONDS),
		list(mode_name = "bolas", projectile_type = /obj/item/projectile/bullet/shotgun/bola, fire_sound = 'sound/weapons/bolathrow.ogg', fire_delay = 1 SECONDS))

/obj/item/weapon/gun/projectile/shotgun/bola_lancher/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = icon_loaded
	else
		icon_state = initial(icon_state)


/obj/item/weapon/gun/projectile/shotgun/bola_lancher/MouseDrop(over_object)
	if(ammo_magazine)
		unload_ammo(usr)
		return
	return ..()
