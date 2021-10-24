/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = list(access_security)
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	icon_off ="base"
	icon_broken ="base"
	icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"

/obj/structure/closet/secure_closet/guncabinet/WillContain()
	return list(
		/obj/item/weapon/gun/projectile/automatic/pulse_rifle,
		/obj/item/weapon/gun/projectile/shotgun/bola_lancher,
		/obj/item/ammo_magazine/pulse = 2,
		/obj/item/ammo_magazine/shotgun = 2,
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot
	)

/obj/structure/closet/secure_closet/guncabinet/sec_support
	name = "support weapon cabinet"
	req_access = list(access_security)
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	icon_off ="base"
	icon_broken ="base"
	icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"

/obj/structure/closet/secure_closet/guncabinet/sec_support/WillContain()
	var/list/things = list(
		/obj/item/clothing/suit/armor/riot,
		/obj/item/clothing/head/helmet/riot)
	if(prob(75))
		things += /obj/item/weapon/gun/projectile/seeker/empty
		things[/obj/item/ammo_magazine/seeker] = 4
	else
		things += /obj/item/weapon/gun/projectile/automatic/pulse_heavy
	return things

/obj/structure/closet/secure_closet/guncabinet/military
	name = "military gun cabinet"
	req_access = list(access_security)
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	icon_off ="base"
	icon_broken ="base"
	icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"

/obj/structure/closet/secure_closet/guncabinet/military/WillContain()
	var/list/things = list(
		/obj/item/weapon/gun/projectile/automatic/pulse_rifle/empty,
		/obj/item/ammo_magazine/pulse/hv = 6,
		/obj/item/weapon/storage/belt/holster/security
	)
	//Contains either an HPR or a seeker rifle
	if (prob(50))
		things += /obj/item/weapon/gun/projectile/automatic/pulse_heavy
	else
		things += /obj/item/weapon/gun/projectile/seeker
		things[/obj/item/ammo_magazine/seeker] = 4

	return things

/obj/structure/closet/secure_closet/guncabinet/LateInitialize()
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/open() //There are plenty of things that can open it that don't use toggle
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	overlays.Cut()
	if(opened)
		overlays += icon(icon,"door_open")
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/weapon/gun/G in contents)
			if (istype(G, /obj/item/weapon/gun/energy))
				lazors++
			if (istype(G, /obj/item/weapon/gun/projectile/))
				shottas++
		for (var/i = 0 to 2)
			if(lazors || shottas) // only make icons if we have one of the two types.
				var/image/gun = image(icon(src.icon))
				if (lazors > shottas)
					lazors--
					gun.icon_state = "laser"
				else if (shottas)
					shottas--
					gun.icon_state = "projectile"
				gun.pixel_x = i*4
				overlays += gun

		overlays += icon(src.icon, "door")

		if(welded)
			overlays += icon(src.icon,"welded")

		if(broken)
			overlays += icon(src.icon,"broken")
		else if (locked)
			overlays += icon(src.icon,"locked")
		else
			overlays += icon(src.icon,"open")

