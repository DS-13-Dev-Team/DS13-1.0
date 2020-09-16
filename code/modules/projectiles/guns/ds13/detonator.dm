/obj/item/weapon/gun/projectile/detonator
    name = "detonator"
    desc = "A unique gun that can place tripmines from a distance."
    icon = 'icons/obj/detonator.dmi'
    icon_state = "unloaded"
    item_state = "unloaded"
    wielded_item_state = "detonator-wielded"
    slot_flags = SLOT_BELT | SLOT_BACK
    w_class = ITEM_SIZE_NORMAL
    max_shells = 1
    caliber = "tripmine"
    handle_casings = CLEAR_CASINGS
    fire_delay = 5
    fire_sound = ""
    load_sound = ""

    //list(mode_name="mine retrieval", mode_type = /datum/firemode/tripmine),

/obj/item/weapon/gun/projectile/detonator/loaded
    ammo_type = /obj/item/ammo_casing/tripmine

/obj/item/weapon/gun/projectile/detonator/update_icon()
    if(getAmmo())
        icon_state = "loaded"
    else
        icon_state = "unloaded"







//The deployed mine, explodes after some time
/obj/effect/mine/trip
	name = "Plasma Mine"
	icon = 'icons/obj/weapons/ds13_deployables.dmi'
	icon_state = "plasma_mine_base"
	var/setup_time = 1.35 SECONDS


/obj/effect/mine/trip/Initialize()
	spawn(setup_time)
	playsound(src, 'sound/weapons/guns/misc/plasma_mine.ogg', VOLUME_MAX, FALSE)//Max volume, no variation. This terrifying sound is an important warning
	.=..()

/obj/effect/mine/trip/explode(obj)
	explosion(loc, -1, 1, 2, 3)
	spawn(0)
		qdel(src)