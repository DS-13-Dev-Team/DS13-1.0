/obj/item/clothing/suit/armor
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = ITEM_FLAG_THICKMATERIAL

	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6


/obj/item/clothing/suit/armor/vest/old //just realized these had never been removed
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	//item_state = "armor"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	cold_protection = UPPER_TORSO|LOWER_TORSO
	heat_protection = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 50, energy = 20, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	//item_state = "armor"
	armor = list(melee = 45, bullet = 40, laser = 50, energy = 20, bomb = 25, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/armor/vest/handmade
	name = "handmade armor vest"
	desc = "An armored vest of uncertain quality. Provides a good protection against physical damage, for a piece of crap."
	icon_state = "hm_armorvest"
	item_state = "hm_armorvest"
	armor = list(melee = 35, bullet = 35, laser = 30, energy = 15, bomb = 15, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/swat
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon_state = "detective"
	//item_state = "det_suit"
	blood_overlay_type = "coat"
	armor = list(melee = 55, bullet = 50, laser = 0, energy = 0, bomb = 25, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	heat_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)


//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armor"
	desc = "Someone separated our Research Director from their own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/reactive/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1
/*
/obj/item/clothing/suit/armor/reactive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(prob(50))
		user.visible_message("<span class='danger'>The reactive teleport system flings [user] clear of the attack!</span>")
		var/list/turfs = new/list()
		for(var/turf/T in orange(6, user))
			if(istype(T,/turf/space)) continue
			if(T.density) continue
			if(T.x>world.maxx-6 || T.x<6)	continue
			if(T.y>world.maxy-6 || T.y<6)	continue
			turfs += T
		if(!turfs.len) turfs += pick(/turf in orange(6))
		var/turf/picked = pick(turfs)
		if(!isturf(picked)) return

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, "sparks", 50, 1)

		user.forceMove(picked)
		return PROJECTILE_FORCE_MISS
	return 0
*/

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		to_chat(user, "<span class='notice'>The reactive armor is now active.</span>")
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		to_chat(user, "<span class='notice'>The reactive armor is now inactive.</span>")
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()

/*
/obj/item/clothing/suit/armor/tactical
	name = "tactical armor"
	desc = "A suit of armor most often used by Special Weapons and Tactics squads. Includes padded vest with pockets along with shoulder and kneeguards."
	icon_state = "swatarmor"
	item_state = "armor"
	var/obj/item/gun/holstered = null
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	var/obj/item/clothing/accessory/storage/holster/holster

/obj/item/clothing/suit/armor/tactical/New()
	..()
	holster = new(src)
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/armor/tactical/attackby(obj/item/W as obj, mob/user as mob)
	..()
	holster.attackby(W, user)

/obj/item/clothing/suit/armor/tactical/verb/holster()
	set name = "holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	if(!holster.holstered)
		var/obj/item/W = usr.get_active_hand()
		if(!istype(W, /obj/item))
			to_chat(usr, "<span class='warning'>You need your gun equiped to holster it.</span>")
			return
		holster.holster(W, usr)
	else
		holster.unholster(usr)
*/

//Non-hardsuit ERT armor
//Kellion - Grunt
/obj/item/clothing/suit/armor/vest/kellion
	name = "C.E.C. armored vest"
	desc = "A set of armor issued to security teams assigned to guarding C.E.C. maintenance teams."
	icon_state = "kellion_grunt"
	item_state = "kellion_grunt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 55, bullet = 60, laser = 0, energy = 0, bomb = 20, bio = 0, rad = 0)

//New Vests
/obj/item/clothing/suit/armor/vest
	name = "armored vest"
	desc = "An armor vest made of synthetic fibers."
	icon_state = "kvest"
	item_state = "armor"
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0)
	//valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/suit/storage/vest
	name = "webbed armor vest"
	desc = "A synthetic armor vest. This one has added webbing and ballistic plates."
	icon_state = "webvest"
	armor = list(melee = 35, bullet = 40, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = ITEM_FLAG_THICKMATERIAL
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

/obj/item/clothing/suit/storage/vest/nt/hos
	name = "commander heavy armored vest"
	desc = "A synthetic armor vest with COMMANDER printed in gold lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "comwebvest"

/obj/item/clothing/suit/storage/vest/pcrc
	name = "contractor heavy armored vest"
	desc = "A synthetic armor vest with PRIVATE SECURITY printed in cyan lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "pcrcwebvest"

/obj/item/clothing/suit/storage/vest/tactical //crack at a more balanced mid-range armor, minor improvements over standard vests, with the idea "modern" combat armor would focus on energy weapon protection.
	name = "tactical armored vest"
	desc = "A heavy armored vest in a fetching tan. It is surprisingly flexible and light, even with the extra webbing and advanced ceramic plates."
	icon_state = "tacwebvest"
	item_state = "tacwebvest"
	armor = list(melee = 35, bullet = 40, laser = 60, energy = 35, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/hunk
	name = "HUNK armored vest"
	desc = "A heavy armored vest in a fetching black. Used to protect the wearer from dangerous, unknown biohazards. It is surprisingly flexible and light, even with the extra webbing and advanced ceramic plates."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/modular_armor.dmi')
	icon_state = "hunk_armor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 70, bullet = 45, laser = 60, energy = 35, bomb = 60, bio = 70, rad = 0)
	siemens_coefficient = 0.8
	blood_overlay_type = "armor"
	starting_accessories = list(/obj/item/clothing/accessory/armguards/merc, /obj/item/clothing/accessory/legguards/merc)

//Modular plate carriers
/obj/item/clothing/suit/armor/pcarrier
	name = "plate carrier"
	desc = "A lightweight black plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/modular_armor.dmi')
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_C, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	icon_state = "pcarrier"
	blood_overlay_type = "armor"

/obj/item/clothing/suit/armor/pcarrier/light
	starting_accessories = list(/obj/item/clothing/accessory/armorplate)

/obj/item/clothing/suit/armor/pcarrier/light/press
	starting_accessories = list(/obj/item/clothing/accessory/armorplate)

/obj/item/clothing/suit/armor/pcarrier/medium
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/medium, /obj/item/clothing/accessory/storage/pouches)

/obj/item/clothing/suit/armor/pcarrier/blue
	name = "blue plate carrier"
	desc = "A lightweight blue plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_blue"

/obj/item/clothing/suit/armor/pcarrier/green
	name = "green plate carrier"
	desc = "A lightweight green plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_green"

/obj/item/clothing/suit/armor/pcarrier/navy
	name = "navy plate carrier"
	desc = "A lightweight navy blue plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_navy"

/obj/item/clothing/suit/armor/pcarrier/tan
	name = "tan plate carrier"
	desc = "A lightweight tan plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_tan"

/obj/item/clothing/suit/armor/pcarrier/merc
	starting_accessories = list(/obj/item/clothing/accessory/armorplate/merc, /obj/item/clothing/accessory/armguards/merc, /obj/item/clothing/accessory/legguards/merc, /obj/item/clothing/accessory/storage/pouches/large)

//Modular specialty armor
/obj/item/clothing/suit/armor/riot
	name = "riot vest"
	desc = "An armored vest with heavy padding to protect against melee attacks."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/modular_armor.dmi')
	icon_state = "riot_armor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 75, bullet = 33, laser = 50, energy = 0, bomb = 35, bio = 0, rad = 0)
	siemens_coefficient = 0.5
	starting_accessories = list(/obj/item/clothing/accessory/armguards/riot, /obj/item/clothing/accessory/legguards/riot)

/obj/item/clothing/suit/armor/riot/vest
	starting_accessories = list()

/obj/item/clothing/suit/armor/ballistic
	name = "ballistic vest"
	desc = "An armored vest with heavy plates to protect against ballistic projectiles."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/modular_armor.dmi')
	icon_state = "ballistic"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 33, bullet = 75, laser = 42, energy = 0, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	starting_accessories = list(/obj/item/clothing/accessory/armguards/ballistic, /obj/item/clothing/accessory/legguards/ballistic)

/obj/item/clothing/suit/armor/bulletproof/vest //because apparently some map uses this somewhere and I'm too lazy to go looking for and replacing it.
	starting_accessories = null

/obj/item/clothing/suit/armor/laserproof
	name = "ablative vest"
	desc = "An armored vest with advanced shielding to protect against energy weapons."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/modular_armor.dmi')
	icon_state = "ablative"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 35, bullet = 35, laser = 65, energy = 50, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0
	starting_accessories = list(/obj/item/clothing/accessory/armguards/ablative, /obj/item/clothing/accessory/legguards/ablative)
/*
/obj/item/clothing/suit/armor/laserproof/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
		var/obj/item/projectile/P = damage_source

		var/reflectchance = 40 - round(damage/3)
		if(!(def_zone in list(BP_CHEST, BP_GROIN))) //not changing this so arm and leg shots reflect, gives some incentive to not aim center-mass
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation
*/

/obj/item/clothing/suit/armor/pcsi
	name = "P.C.S.I officer's vest"
	desc = "The Concordance Extraction Corporation's standard issue security armor, used on its larger vessels and colonial interests, outfitted with protective polymer plating and a lightweight kevlar web beneath those plates. Deployed in high-risk situations where CEC property and personnel are at risk, usually from piracy or looters."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/modular_armor.dmi')
	icon_state = "pcsi"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 54, bullet = 54, laser = 50, energy = 0, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0.5
	starting_accessories = list(/obj/item/clothing/accessory/armguards/pcsi, /obj/item/clothing/accessory/legguards/pcsi)

/obj/item/clothing/suit/armor/pcsi/vest
	starting_accessories = list()

/obj/item/clothing/suit/armor/pcsi/cec
	name = "CEC standard vest"
	desc = "The Concordance Extraction Corporation's standard issue vest."
	icon_state = "cecvest"
	armor = list(melee = 54, bullet = 54, laser = 50, energy = 0, bomb = 25, bio = 0, rad = 0)

/* - Plan on using this for something later - Snype
/obj/item/clothing/suit/armor/tactical
	name = "tactical vest"
	desc = "TEMP DESC"
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(slot_wear_suit_str = 'icons/mob/onmob/modular_armor.dmi')
	icon_state = "tactical"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_A, ACCESSORY_SLOT_ARMOR_L)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.5
	starting_accessories = list(/obj/item/clothing/accessory/armguards/tactical, /obj/item/clothing/accessory/legguards/tactical)

/obj/item/clothing/suit/armor/tactical/vest
	starting_accessories = list()*/

//All of the armor below is mostly unused
/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/heavy/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 3