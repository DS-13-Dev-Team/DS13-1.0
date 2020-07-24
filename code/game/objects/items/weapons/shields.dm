/*
	Shields are items held in hand which have tremendously high block chances and maximum block values, they are reliable protection until they break
*/

/obj/item/weapon/shield
	name = "shield"
	var/base_block_chance = 80
	var/max_block = 20

	max_health = 130
	resistance = 3





/obj/item/weapon/shield/handle_block(var/datum/strike/strike)
	var/blocked_damage = min(max_block, min(health+resistance, strike.damage))
	strike.blocked_damage += blocked_damage
	strike.blocker = src
	playsound(get_turf(src),blocksound, VOLUME_HIGH, 1)

	//We spawn off the damage taking so it'll happen after, that way the shield's name can be retrieved for stuff
	spawn()
		take_damage(blocked_damage, strike.damage_type, strike.user, strike.used_weapon, bypass_resist = FALSE)

/obj/item/weapon/shield/can_block(var/datum/strike/strike)
	return (health > 0)

/obj/item/weapon/shield/get_block_chance(var/datum/strike/strike)
	return base_block_chance







/obj/item/weapon/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(MATERIAL_GLASS = 7500, MATERIAL_STEEL = 1000)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time
	max_block = 25
	base_block_chance = 100
	max_health = 190
	blocksound = 'sound/effects/Glasshit.ogg'
	resistance = 4


/obj/item/weapon/shield/riot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/weapon/shield/riot/metal
	name = "plasteel combat shield"
	icon_state = "metal"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	force = 6.0
	throwforce = 7.0
	throw_range = 3
	w_class = ITEM_SIZE_HUGE
	matter = list(MATERIAL_PLASTEEL = 8500)
	max_block = 30
	max_health = 255
	slowdown_general = 1.5
	resistance = 6
	blocksound = 'sound/items/trayhit2.ogg'


/*
 * Handmade shield
 */

/obj/item/weapon/shield/buckler
	name = "round handmade shield"
	desc = "A handmade stout shield, but with a small size."
	icon_state = "buckler"
	
	throw_range = 6
	matter = list(MATERIAL_STEEL = 6)
	base_block_chance = 65
	max_health = 85
	max_block = 15
	resistance = 5



/obj/item/weapon/shield/tray
	name = "tray shield"
	desc = "A thin metal tray held on the arm, won't endure much punishment"
	icon_state = "tray_shield"
	
	throw_range = 4
	matter = list(MATERIAL_STEEL = 4)
	base_block_chance = 80
	max_health = 90
	max_block = 10
	resistance = 2
	blocksound = 'sound/items/trayhit2.ogg'



/*
 * Energy Shield
 */

/obj/item/weapon/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 3.0
	throwforce = 5.0
	
	throw_range = 4
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	base_block_chance = 90
	max_block = 45
	var/active = 0
	resistance = 8
	max_health = 340
	blocksound = 'sound/effects/impacts/shield_impact_1.ogg'

/obj/item/weapon/shield/energy/can_block()
	return active

/obj/item/weapon/shield/energy/handle_block(var/datum/strike/strike)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, get_turf(src))
		spark_system.start()
		playsound(get_turf(src), 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/weapon/shield/energy/attack_self(mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>You beat yourself in the head with [src].</span>")
		user.take_organ_damage(5)
	active = !active
	if (active)
		force = 10
		update_icon()
		w_class = ITEM_SIZE_HUGE
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now active.</span>")

	else
		force = 3
		update_icon()
		w_class = ITEM_SIZE_TINY
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/shield/energy/update_icon()
	icon_state = "eshield[active]"
	if(active)
		set_light(0.4, 0.1, 1, 2, "#006aff")
	else
		set_light(0)


