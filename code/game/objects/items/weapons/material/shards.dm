// Glass shards

/obj/item/weapon/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	randpixel = 8
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_SMALL
	force_divisor = 0.12 // 6 with hardness 30 (glass)
	thrown_force_divisor = 0.4 // 4 with weight 15 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = MATERIAL_GLASS
	unbreakable = 1 //It's already broken.
	drops_debris = 0

/obj/item/weapon/material/shard/set_material(var/new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	update_icon()

	if(material.shard_type)
		SetName("[material.display_name] [material.shard_type]")
		desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/weapon/material/shard/update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/weapon/material/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWelder(W) && material.shard_can_repair)
		if(W.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_WELDING, FAILCHANCE_NORMAL))
			material.place_sheet(loc)
			qdel(src)
			return
	return ..()

/obj/item/weapon/material/shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || (H.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			to_chat(M, "<span class='danger'>You step on \the [src]!</span>")

			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(BP_IS_ROBOTIC(affecting))
						return
					affecting.take_external_damage(5, 0)
					H.updatehealth()
					if(affecting.can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/weapon/material/shrapnel
	name = "shrapnel"
	default_material = MATERIAL_STEEL
	w_class = ITEM_SIZE_TINY	//it's real small

/obj/item/weapon/material/shard/shrapnel
	var/atom/launcher

/obj/item/weapon/material/shard/shrapnel/New(loc, obj/item/projectile/P)
	if(P)
		launcher = P.launcher
		launcher.register_sharpnel(src)
	..(loc, MATERIAL_STEEL)

/obj/item/weapon/material/shard/phoron/New(loc)
	..(loc, "phglass")

/obj/item/weapon/material/shard/shrapnel/javeling
	name = "javeling"
	icon_state = "SpearFlight"
	icon = 'icons/effects/wall.dmi'
	var/charged_icon = "SpearFlight_charged"
	var/obj/item/weapon/gun/projectile/javelin_gun/javelin_gun
	var/obj/effect/overload/tesla
	var/shock_count
	var/extension_type = /datum/extension/mount/self_delete

/obj/item/weapon/material/shard/shrapnel/javeling/New(loc, obj/item/projectile/P)
	..()
	javelin_gun = launcher
	update_icon()

/obj/item/weapon/material/shard/shrapnel/javeling/Destroy()
	if(launcher)
		remove_from_luncher_list()
	return ..()

/obj/item/weapon/material/shard/shrapnel/javeling/update_icon()
	if(launcher && !shock_count)
		icon_state = charged_icon
	else
		icon_state = initial(icon_state)

/obj/item/weapon/material/shard/shrapnel/javeling/examine(mob/user, distance)
	. = ..()
	if(launcher)
		if(shock_count)
			to_chat(user, SPAN_NOTICE("Its fully discharged."))
		else
			to_chat(user, SPAN_WARNING("Its charged with electricity."))

/obj/item/weapon/material/shard/shrapnel/javeling/proc/remove_from_luncher_list()
	launcher.unregister_sharpnel(src)
	QDEL_NULL(tesla)
	update_icon()

/obj/item/weapon/material/shard/shrapnel/javeling/proc/process_shock()
	if(!shock_count)
		var/datum/effect/effect/system/spark_spread/S = new
		S.set_up(3, 1, get_turf(src))
		S.start()
		tesla = new /obj/effect/overload(get_turf(src), 5)
		addtimer(CALLBACK(src, .proc/remove_from_luncher_list), 4 SECONDS)
	shock_count++

/obj/item/weapon/material/shard/shrapnel/javeling/proc/on_target_collision(mob/user, atom/obstacle)
	var/list/implants = user.get_visible_implants(0, TRUE)
	if(src in implants)
		var/mount_target = get_mount_target_at_direction(user, get_dir(obstacle, user))
		if(mount_target)
			src.forceMove(get_turf(user))
			mount_to_atom(src, mount_target, extension_type)
			src.buckle_mob(user)

	GLOB.bump_event.unregister(user, src, /obj/item/weapon/material/shard/shrapnel/javeling/proc/on_target_collision)
