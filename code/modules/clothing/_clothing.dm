/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	var/flash_protection = FLASH_PROTECTION_NONE	// Sets the item's level of flash protection.
	var/tint = TINT_NONE							// Sets the item's level of visual impairment tint.
	var/list/species_restricted = STANDARD_CLOTHING_EXCLUDE_SPECIES //Only these species can wear this kit.


	//If set, species in this list can wear this thing, overriding the restricted list.
	//This is applied AFTER species_restricted to alter that list.
	//It is intended for specific subtypes to create specific exemptions to broad overarching rules set in a parent class
	var/list/species_allowed

	var/gunshot_residue //Used by forensics.

	var/list/accessories = list()
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories
	var/blood_overlay_type = "uniformblood"
	var/visible_name = "Unknown"
	var/ironed_state = WRINKLES_DEFAULT

	var/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // if this item covers the feet, the footprints it should leave
	var/permeability_threshold = 0.8	//As long as health is above this proportion of max health, reagent permeability is unaffected. Below that value it increases rapidly
	var/coverage = null	//Calculate this at runtime

	//If not null, this piece of clothing belongs to a rig frame
	var/obj/item/weapon/rig/rig
	acid_resistance = 1.2
	max_health = 150

// Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

// Updates the vision of the mob wearing the clothing item, if any
/obj/item/clothing/proc/update_vision()
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		L.handle_vision()

// Checked when equipped, returns true when the wearing mob's vision should be updated
/obj/item/clothing/proc/needs_vision_update()
	return flash_protection || tint

/obj/item/clothing/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()

	if(slot == slot_l_hand_str || slot == slot_r_hand_str)
		return ret

	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		if(blood_DNA && user_human.species.blood_mask)
			var/image/bloodsies	= overlay_image(user_human.species.blood_mask, blood_overlay_type, blood_color, RESET_COLOR)
			ret.overlays	+= bloodsies

		if (user_human.missing_limbs & body_parts_covered)
			ret.filters += user_human.limb_mask

	if(accessories.len)
		for(var/obj/item/clothing/accessory/A in accessories)
			ret.overlays |= A.get_mob_overlay(user_mob, slot)
	return ret

// Aurora forensics port.
/obj/item/clothing/clean_blood()
	. = ..()
	gunshot_residue = null

/obj/item/clothing/proc/get_fibers()
	. = "material from \a [name]"
	var/list/acc = list()
	for(var/obj/item/clothing/accessory/A in accessories)
		if(prob(40) && A.get_fibers())
			acc += A.get_fibers()
	if(acc.len)
		. += " with traces of [english_list(acc)]"

/obj/item/clothing/New()
	..()
	if(starting_accessories)
		for(var/T in starting_accessories)
			var/obj/item/clothing/accessory/tie = new T(src)
			src.attach_accessory(null, tie)

	coverage = get_coverage()

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(var/mob/M, var/slot, var/disable_warning = 0, var/force = 0)

	//if we can't equip the item anyway, don't bother with species_restricted (cuts down on spam)
	if (!..())
		return 0

	if(species_restricted && istype(M,/mob/living/carbon/human))
		var/exclusive = null
		var/wearable = null
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted)
			exclusive = 1

		var/list/restrictions = species_restricted.Copy()
		if (species_allowed)
			if(exclusive)
				restrictions -= species_allowed
			else
				restrictions += species_allowed

		if(H.species)
			if(exclusive)
				if(!(H.species.get_bodytype(H) in restrictions))
					wearable = 1
			else
				if(H.species.get_bodytype(H) in restrictions)
					wearable = 1

			if(!wearable && !(slot in list(slot_l_store, slot_r_store, slot_s_store)))
				if(!disable_warning)
					to_chat(H, "<span class='danger'>Your species cannot wear [src].</span>")
				return 0
	return 1

/obj/item/clothing/equipped(var/mob/user)
	if(needs_vision_update())
		update_vision()
	return ..()

/obj/item/clothing/proc/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if(SPECIES_HUMAN, SPECIES_SKRELL)	//humanoid bodytypes
			species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_IPC) //skrell/humans/machines can wear each other's suits
		else
			species_restricted = list(target_species)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

/obj/item/clothing/head/helmet/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if(SPECIES_SKRELL)
			species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_IPC) //skrell helmets fit humans too
		if(SPECIES_HUMAN)
			species_restricted = list(SPECIES_HUMAN, SPECIES_IPC) //human helmets fit IPCs too
		else
			species_restricted = list(target_species)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

/obj/item/clothing/get_examine_line()
	. = ..()
	var/list/ties = list()
	for(var/obj/item/clothing/accessory/accessory in accessories)
		if(accessory.high_visibility)
			ties += "\a [accessory.get_examine_line()]"
	if(ties.len)
		.+= " with [english_list(ties)] attached"
	if(accessories.len > ties.len)
		.+= ". <a href='?src=\ref[src];list_ungabunga=1'>\[See accessories\]</a>"

/obj/item/clothing/CanUseTopic(var/user)
	if(user in view(get_turf(src)))
		return STATUS_INTERACTIVE

/obj/item/clothing/OnTopic(var/user, var/list/href_list, var/datum/topic_state/state)
	if(href_list["list_ungabunga"])
		if(accessories.len)
			var/list/ties = list()
			for(var/accessory in accessories)
				ties += "[icon2html(accessory)] \a [accessory]"
			to_chat(user, "Attached to \the [src] are [english_list(ties)].")
		return TOPIC_HANDLED


//Clothing that is damaged is more permeable
/obj/item/clothing/proc/get_permeability()
	if (health >= (max_health * permeability_threshold))
		return permeability_coefficient

	if (health <= 0 || max_health <= 0 || permeability_threshold <= 0 || permeability_coefficient >= 1)
		return 1	//Safety check to prevent division by zero errors. If any of these numbers are bad, just let everything through

	//Alright, this piece of clothing is sufficiently damaged that it has holes and is letting liquids through. Lets see how much
	var/blockage = 1 - permeability_coefficient	//Invert this to get how much it blocks
	var/healthpercent = health / (max_health * permeability_threshold)	//Find our percentage between zero and threshold
	blockage *= healthpercent	//Apply to blockage
	return 1 - blockage	//And invert it once more for the return



//Returns a value in the range 0 to 1, representing how much of the wearer's body is covered by this piece of clothing
/obj/item/clothing/proc/get_coverage()
	. = 0
	//These defines represent how much of the body each segment is equal to. Add them together to get our total coverage
	if(!body_parts_covered)
		return
	if(body_parts_covered & HEAD)
		.+=THERMAL_PROTECTION_HEAD
	if(body_parts_covered & UPPER_TORSO)
		.+=THERMAL_PROTECTION_UPPER_TORSO
	if(body_parts_covered & LOWER_TORSO)
		.+=THERMAL_PROTECTION_LOWER_TORSO
	if(body_parts_covered & LEGS)
		.+=(THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT)
	if(body_parts_covered & FEET)
		.+=(THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT)
	if(body_parts_covered & ARMS)
		.+=(THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT)
	if(body_parts_covered & HANDS)
		.+=(THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT)



///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_EARS

/obj/item/clothing/ears/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_ears()

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earmuffs/headphones
	name = "headphones"
	desc = "It's probably not in accordance with corporate policy to listen to music on the job... but fuck it."
	var/headphones_on = 0
	icon_state = "headphones_off"
	item_state = "headphones_off"
	slot_flags = SLOT_EARS | SLOT_TWOEARS

/obj/item/clothing/ears/earmuffs/headphones/verb/togglemusic()
	set name = "Toggle Headphone Music"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.incapacitated()) return

	if(headphones_on)
		icon_state = "headphones_off"
		item_state = "headphones_off"
		headphones_on = 0
		to_chat(usr, "<span class='notice'>You turn the music off.</span>")
	else
		icon_state = "headphones_on"
		item_state = "headphones_on"
		headphones_on = 1
		to_chat(usr, "<span class='notice'>You turn the music on.</span>")

	update_clothing_icon()

///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
	      // in a lit area (via pixel_x, y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = EYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1
	var/light_protection = 0

/obj/item/clothing/glasses/get_icon_state(mob/user_mob, slot)
	if(item_state_slots && item_state_slots[slot])
		return item_state_slots[slot]
	else
		return icon_state

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.75
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	var/clipped = 0
	var/obj/item/clothing/ring/ring = null		//Covered ring
	var/mob/living/carbon/human/wearer = null	//Used for covered rings when dropping
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude",SPECIES_NABBER, SPECIES_UNATHI,SPECIES_VOX)
	blood_overlay_type = "bloodyhands"

/obj/item/clothing/gloves/Initialize()
	if(item_flags & ITEM_FLAG_PREMODIFIED)
		cut_fingertops()

	. = ..()

/obj/item/clothing/gloves/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
	..()

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [name]."

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/tool/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		if (clipped)
			to_chat(user, "<span class='notice'>\The [src] have already been modified!</span>")
			update_icon()
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("<span class='warning'>\The [user] modifies \the [src] with \the [W].</span>","<span class='warning'>You modify \the [src] with \the [W].</span>")

		cut_fingertops() // apply change, so relevant xenos can wear these
		return

// Applies "clipped" and removes relevant restricted species from the list,
// making them wearable by the specified species, does nothing if already cut
/obj/item/clothing/gloves/proc/cut_fingertops()
	if (clipped)
		return

	clipped = 1
	name = "modified [name]"
	desc = "[desc]<br>They have been modified to accommodate a different shape."
	if("exclude" in species_restricted)
		species_restricted -= SPECIES_UNATHI
	return

/obj/item/clothing/gloves/mob_can_equip(mob/M, var/slot, var/disable_warning = 0, var/force = 0)
	var/mob/living/carbon/human/H = M

	if(istype(H.gloves, /obj/item/clothing/ring))
		ring = H.gloves
		if(!ring.undergloves)
			to_chat(M, "You are unable to wear \the [src] as \the [H.gloves] are in the way.")
			ring = null
			return 0
		if(!H.unEquip(ring, src))//Remove the ring (or other under-glove item in the hand slot?) so you can put on the gloves.
			ring = null
			return 0

	if(!..())
		if(ring) //Put the ring back on if the check fails.
			if(H.equip_to_slot_if_possible(ring, slot_gloves))
				src.ring = null
		return 0

	if (ring)
		to_chat(M, "You slip \the [src] on over \the [ring].")
	wearer = H //TODO clean this when magboots are cleaned
	return 1

/obj/item/clothing/gloves/dropped()
	..()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	if(ring && istype(H))
		if(!H.equip_to_slot_if_possible(ring, slot_gloves))
			ring.forceMove(get_turf(src))
		src.ring = null
	wearer = null

///////////////////////////////////////////////////////////////////////
//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_hats.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_SMALL

	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

	blood_overlay_type = "helmetblood"

/obj/item/clothing/head/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	var/bodytype = "Default"
	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		bodytype = user_human.species.get_bodytype(user_human)
	var/cache_key = "[light_overlay]_[bodytype]"
	if(on && light_overlay_cache[cache_key] && slot == slot_head_str)
		ret.overlays |= light_overlay_cache[cache_key]
	return ret

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc]")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the helmet light.")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(0.5, 1, 3)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_generic(var/mob/user)
	if(!istype(user) || !mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return 0
	var/success
	if(istype(user, /mob/living/silicon/robot/drone))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1
	else if(istype(user, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1

	if(!success)
		return 0
	else if(success == 2)
		to_chat(user, "<span class='warning'>You are already wearing a hat.</span>")
	else if(success == 1)
		to_chat(user, "<span class='notice'>You crawl under \the [src].</span>")
	return 1

/obj/item/clothing/head/update_icon(var/mob/user)

	overlays.Cut()
	var/mob/living/carbon/human/H
	if(istype(user,/mob/living/carbon/human))
		H = user

	if(on)

		// Generate object icon.
		if(!light_overlay_cache["[light_overlay]_icon"])
			light_overlay_cache["[light_overlay]_icon"] = image("icon" = 'icons/obj/light_overlays.dmi', "icon_state" = "[light_overlay]")
		overlays |= light_overlay_cache["[light_overlay]_icon"]

		// Generate and cache the on-mob icon, which is used in update_inv_head().
		var/cache_key = "[light_overlay][H ? "_[H.species.get_bodytype(H)]" : ""]"
		if(!light_overlay_cache[cache_key])
			var/use_icon = 'icons/mob/light_overlays.dmi'
			if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
				use_icon = sprite_sheets[H.species.get_bodytype(H)]
			light_overlay_cache[cache_key] = image("icon" = use_icon, "icon_state" = "[light_overlay]")

	if(H)
		H.update_inv_head()

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()

///////////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs
	var/down_gas_transfer_coefficient = 0
	var/down_body_parts_covered = 0
	var/down_icon_state = 0
	var/down_item_flags = 0
	var/down_flags_inv = 0
	var/pull_mask = 0
	var/hanging = 0
	blood_overlay_type = "maskblood"

/obj/item/clothing/mask/New()
	if(pull_mask)
		action_button_name = "Adjust Mask"
		verbs += /obj/item/clothing/mask/proc/adjust_mask
	..()

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

/obj/item/clothing/mask/proc/adjust_mask(var/mob/user)
	set category = "Object"
	set name = "Adjust mask"
	set src in usr

	if(!user.incapacitated())
		if(!pull_mask)
			to_chat(usr, "<span class ='notice'>You cannot pull down your [src.name].</span>")
			return
		else
			src.hanging = !src.hanging
			if (src.hanging)
				gas_transfer_coefficient = down_gas_transfer_coefficient
				body_parts_covered = down_body_parts_covered
				icon_state = down_icon_state
				item_state = down_icon_state
				item_flags = down_item_flags
				flags_inv = down_flags_inv
				to_chat(usr, "You pull [src] below your chin.")
			else
				gas_transfer_coefficient = initial(gas_transfer_coefficient)
				body_parts_covered = initial(body_parts_covered)
				icon_state = initial(icon_state)
				item_state = initial(icon_state)
				item_flags = initial(item_flags)
				flags_inv = initial(flags_inv)
				to_chat(usr, "You pull [src] up to cover your face.")
			update_clothing_icon()
			user.update_action_buttons()

/obj/item/clothing/mask/attack_self(mob/user)
	if(pull_mask)
		adjust_mask(user)

///////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET

	var/can_hold_knife
	var/obj/item/holding
	var/step_volume = 40
	var/step_range = 1

	permeability_coefficient = 0.50
	force = 2
	var/overshoes = 0
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_UNATHI, SPECIES_TAJARA, SPECIES_VOX)
	blood_overlay_type = "shoeblood"

/obj/item/clothing/shoes/proc/draw_knife()
	set name = "Draw Boot Knife"
	set desc = "Pull out your boot knife."
	set category = "IC"
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	holding.forceMove(get_turf(usr))

	if(usr.put_in_hands(holding))
		usr.visible_message("<span class='warning'>\The [usr] pulls \the [holding] out of \the [src]!</span>", range = 1)
		holding = null
		playsound(get_turf(src), 'sound/effects/holster/sheathout.ogg', 25)
	else
		to_chat(usr, "<span class='warning'>Your need an empty, unbroken hand to do that.</span>")
		holding.forceMove(src)

	if(!holding)
		verbs -= /obj/item/clothing/shoes/proc/draw_knife

	update_icon()
	return

/obj/item/clothing/shoes/attack_hand(var/mob/living/M)
	if(can_hold_knife && holding && src.loc == M)
		draw_knife()
		return
	..()

/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if(can_hold_knife && is_type_in_list(I, list(/obj/item/weapon/material/shard, /obj/item/weapon/material/butterfly, /obj/item/weapon/material/kitchen/utensil, /obj/item/weapon/material/hatchet/tacknife)))
		if(holding)
			to_chat(user, "<span class='warning'>\The [src] is already holding \a [holding].</span>")
			return
		if(!user.unEquip(I, src))
			return
		holding = I
		user.visible_message("<span class='notice'>\The [user] shoves \the [I] into \the [src].</span>", range = 1)
		verbs |= /obj/item/clothing/shoes/proc/draw_knife
		update_icon()
	else
		return ..()

/obj/item/clothing/shoes/update_icon()
	overlays.Cut()
	if(holding)
		overlays += image(icon, "[icon_state]_knife")
	return ..()

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	return

/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_suits.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_suits.dmi',
		)
	name = "suit"
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	var/extra_allowed
	allowed = list(/obj/item/device,
	/obj/item/weapon/tank,
	/obj/item/weapon/storage/pouch,
	/obj/item/weapon/gun,
	/obj/item/weapon/tool,
	/obj/item/weapon/melee,
	/obj/item/ammo_magazine,
	/obj/item/ammo_casing,
	/obj/item/weapon/handcuffs,
	/obj/item/weapon/storage/ore)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/suit/Initialize()
	.=..()
	if (LAZYLEN(extra_allowed))
		allowed |= extra_allowed


/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/suit/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(item_state_slots && item_state_slots[slot])
		ret.icon_state = item_state_slots[slot]

	return ret

/obj/item/clothing/suit/proc/get_collar()
	var/icon/C = new('icons/mob/collar.dmi')
	if(icon_state in C.IconStates())
		var/image/I = image(C, icon_state)
		I.color = color
		return I
///////////////////////////////////////////////////////////////////////
//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_uniforms.dmi',
		)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	w_class = ITEM_SIZE_NORMAL
	force = 0
	var/displays_id = 1
	var/rolled_down = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_sleeves = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled

	//convenience var for defining the icon state for the overlay used when the clothing is worn.
	//Also used by rolling/unrolling.
	var/worn_state = null
	valid_accessory_slots = list(ACCESSORY_SLOT_UTILITY,ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT,ACCESSORY_SLOT_DECOR,ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_INSIGNIA)
	restricted_accessory_slots = list(ACCESSORY_SLOT_UTILITY,ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT)

/obj/item/clothing/under/New()
	..()
	update_rolldown_status()
	update_rollsleeves_status()
	if(rolled_down == -1)
		verbs -= /obj/item/clothing/under/verb/rollsuit
	if(rolled_sleeves == -1)
		verbs -= /obj/item/clothing/under/verb/rollsleeves

/obj/item/clothing/under/get_icon_state(mob/user_mob, slot)
	var/mob_state
	if(item_state_slots && item_state_slots[slot])
		mob_state = item_state_slots[slot]
	else
		mob_state = icon_state

	var/mob/living/carbon/human/user_human
	if(ishuman(user_mob))
		user_human = user_mob
		if (user_human.lying && user_human.species.icon_lying)
			mob_state = "[mob_state][user_human.species.icon_lying]"
	return "[mob_state]_s"

/obj/item/clothing/under/attack_hand(var/mob/user)
	if(accessories && accessories.len)
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/New()
	..()
	if(worn_state)
		if(!item_state_slots)
			item_state_slots = list()
		item_state_slots[slot_w_uniform_str] = worn_state
	else
		worn_state = icon_state

	//autodetect rollability
	if(rolled_down < 0)
		if((worn_state + "_d_s") in icon_states(default_onmob_icons[slot_w_uniform_str]))
			rolled_down = 0

/obj/item/clothing/under/proc/update_rolldown_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc


	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = default_onmob_icons[slot_w_uniform_str]

	// The _s is because the icon update procs append it.
	if(("[worn_state]_d_s") in icon_states(under_icon))
		if(rolled_down != 1)
			rolled_down = 0
	else
		rolled_down = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/proc/update_rollsleeves_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = default_onmob_icons[slot_w_uniform_str]

	// The _s is because the icon update procs append it.
	if(("[worn_state]_r_s") in icon_states(under_icon))
		if(rolled_sleeves != 1)
			rolled_sleeves = 0
	else
		rolled_sleeves = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform(0)
		M.update_inv_wear_id()

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rolldown_status()
	if(rolled_down == -1)
		to_chat(usr, "<span class='notice'>You cannot roll down [src]!</span>")
	if((rolled_sleeves == 1) && !(rolled_down))
		rolled_sleeves = 0
		return

	rolled_down = !rolled_down
	if(rolled_down)
		body_parts_covered &= LOWER_TORSO|LEGS|FEET
		item_state_slots[slot_w_uniform_str] = "[worn_state]_d"
	else
		body_parts_covered = initial(body_parts_covered)
		item_state_slots[slot_w_uniform_str] = "[worn_state]"
	update_clothing_icon()

/obj/item/clothing/under/verb/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rollsleeves_status()
	if(rolled_sleeves == -1)
		to_chat(usr, "<span class='notice'>You cannot roll up your [src]'s sleeves!</span>")
		return
	if(rolled_down == 1)
		to_chat(usr, "<span class='notice'>You must roll up your [src] first!</span>")
		return

	rolled_sleeves = !rolled_sleeves
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS|HANDS)
		item_state_slots[slot_w_uniform_str] = "[worn_state]_r"
		to_chat(usr, "<span class='notice'>You roll up your [src]'s sleeves.</span>")
	else
		body_parts_covered = initial(body_parts_covered)
		item_state_slots[slot_w_uniform_str] = "[worn_state]"
		to_chat(usr, "<span class='notice'>You roll down your [src]'s sleeves.</span>")
	update_clothing_icon()

///////////////////////////////////////////////////////////////////////
//Rings

/obj/item/clothing/ring
	name = "ring"
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/clothing/rings.dmi'
	slot_flags = SLOT_GLOVES
	gender = NEUTER
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_DIONA)
	var/undergloves = 1
