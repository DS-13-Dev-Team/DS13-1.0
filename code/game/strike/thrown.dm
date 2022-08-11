//Thrown implement
//-----------------
/datum/strike/thrown
	melee = FALSE
	armor_type = "bullet"
	target_zone = RANDOM

	var/speed = 1	//How fast was the thrown object moving, in tiles per second

	//This is not guaranteed to be populated, any movable atom can be thrown
	var/obj/item/used_item


/datum/strike/thrown/get_impact_sound()
	.=..()
	if (!.)
		if (used_item)
			return used_item.hitsound

/datum/strike/thrown/calculate_accuracy()
	var/atom/movable/AM = used_weapon
	accuracy = 100

	if (AM.throw_source)
		var/distance = get_dist(AM.throw_source, get_turf(target))
		accuracy -= min(max(5*(distance-2), 0), 60)	//Distance makes things less accurate, but only to a point

/datum/strike/thrown/cache_data(var/atom/movable/self, var/atom/target, var/speed, var/target_zone)
	src.user = self.thrower
	src.target = target

	if (isliving(target))
		L = target
		if (ishuman(target))
			H = target

	src.used_weapon = self	//The weapon is itself
	if (!target_zone)
		if (istype(user, /mob/living))
			target_zone = get_zone_sel(user)
	else
		src.target_zone = target_zone

	src.speed = speed

	//If the thing isnt an item, all these values will be left at their quite-suitable defaults
	if (istype(self, /obj/item))
		used_item = self
		damage_type = used_item.damtype
		damage_flags = used_item.damage_flags()
		armor_penetration = used_item.armor_penetration
		damage = used_item.throwforce*(soft_cap(speed/BASE_THROW_SPEED, 1, 1, 0.95))//Damage depends on how fast it was going, with some falloff

	else if (istype(self, /atom/movable))
		var/atom/movable/A = self

		damage = A.get_mass()*(soft_cap(speed/BASE_THROW_SPEED, 1, 1, 0.95))



/datum/strike/thrown/impact_target()
	//it hit, so stop moving
	var/atom/movable/AM = used_weapon
	AM.throwing = FALSE
	.=..()

	//If our target is a mobile atom, we will impart our force upon it, assuming the whole hit hasn't been blocked
	if (!QDELETED(target) && !QDELETED(AM) && istype(target, /atom/movable) && get_final_damage())
		var/atom/movable/AM2 = target
		if (AM2.apply_push_impulse_from(AM, AM.get_mass()*speed, 0))
			AM2.visible_message("<span class='warning'>\The [AM2] staggers under the impact!</span>")

/datum/strike/thrown/impact_mob()
	.=..()
	if (used_item)
		used_item.apply_hit_effect(target, user, target_zone)
		L.hit_with_weapon(src)

/datum/strike/thrown/show_result()
	if (missed)
		used_weapon.visible_message("<span class='notice'>\The [used_weapon] misses [target] narrowly!</span>")
		return
	else
		var/sound = get_impact_sound()
		if (blocker)
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(3)
			target.visible_message("<span class='minorwarning'>[target] blocked the [used_weapon] with their [blocker]!</span>")


		else
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(8)
			if (H)
				var/obj/item/organ/external/affecting = H.find_target_organ(target_zone)
				H.visible_message("<span class='warning'>\The [H] has been hit [affecting ? "in the [affecting.name] " : ""]by \the [used_weapon].</span>")
		/*


		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = speed*mass

		if(O.throw_source && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(O.throw_source, src)

			visible_message("<span class='warning'>\The [src] staggers under the impact!</span>","<span class='warning'>You stagger under the impact!</span>")
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src) return

			if(O.loc == src && O.sharp) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)

				if(T)
					src.forceMove(T)
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					src.anchored = 1
					src.pinned += O
		*/