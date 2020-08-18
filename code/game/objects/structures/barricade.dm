//Barricades!
/obj/structure/barricade
	name = "barricade"
	desc = "This space is blocked off by a barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "barricade"
	anchored = 1.0
	density = 1
	max_health = 100
	var/material/material
	atom_flags = ATOM_FLAG_CLIMBABLE
	layer = ABOVE_WINDOW_LAYER
	var/spiky = FALSE

/obj/structure/barricade/New(var/location, var/material_name)
	if(!material_name)
		material_name = MATERIAL_WOOD
	material = get_material_by_name("[material_name]")
	.=..()

/obj/structure/barricade/Initialize(var/mapload)
	if(!material)
		qdel(src)
		return
	name = "[material.display_name] barricade"
	desc = "This space is blocked off by a barricade made of [material.display_name]."
	color = material.icon_colour
	max_health = material.integrity*1.35
	resistance = material.resistance
	health = max_health
	.=..()

/obj/structure/barricade/get_material()
	return material

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/rods) && !spiky)
		var/obj/item/stack/rods/R = W
		if(R.get_amount() < 4)
			to_chat(user, "<span class='warning'>You need more rods to build a cheval de frise.</span>")
			return
		visible_message("<span class='notice'>\The [user] begins to work on \the [src].</span>")
		if(do_after(user, 4 SECONDS, src))
			if(R.use(5))
				visible_message("<span class='notice'>\The [user] fastens \the [R] to \the [src].</span>")
				var/obj/structure/barricade/spike/CDF = new(loc, material.name)
				CDF.dir = user.dir
				qdel(src)
				return
		else
			to_chat(user, "<span class='warning'>You must remain still while building.</span>")
			return
	if (istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return 	TRUE
		if (health < max_health)
			if (D.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sheet of [material.display_name] to repair \the [src].</span>")
				return	TRUE
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user,20,src) && health < max_health)
				if (D.use(1))
					health = max_health
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return	TRUE
		return	TRUE
	else
		.=..()

/obj/structure/barricade/zero_health()
	dismantle()

/obj/structure/barricade/proc/dismantle()
	material.place_dismantled_product(get_turf(src))
	qdel(src)
	return


/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0




//spikey barriers
/obj/structure/barricade/spike
	name = "cheval-de-frise"
	icon_state = "cheval"
	spiky = TRUE

	var/spike_overlay = "cheval_spikes"
	var/material/rod_material
	var/damage //how badly it smarts when you run into this like a rube
	var/list/poke_description = list("gored", "spiked", "speared", "stuck", "stabbed")

/obj/structure/barricade/spike/Initialize(var/mapload)
	. = ..()
	rod_material = get_material_by_name(MATERIAL_STEEL)
	SetName("cheval-de-frise")
	desc = "A rather simple [material.display_name] barrier. It menaces with spikes of [rod_material.display_name]."
	damage = (rod_material.hardness * 0.45)
	overlays += overlay_image(icon, spike_overlay, color = rod_material.icon_colour, flags = RESET_COLOR)

/obj/structure/barricade/spike/Bumped(mob/living/victim)

	. = ..()	//Charging mobs will destroy us here without letting us fire bumped

	if (QDELETED(src))
		return

	var/damage_mult = 1

	if(MOVING_DELIBERATELY(victim)) //walking into this is less hurty than running
		damage_mult = 0.5

	if(isanimal(victim)) //simple animals have simple health, reduce our damage
		damage_mult = 0.5

	impale_victim(victim, damage_mult)

/obj/structure/barricade/spike/charge_act(var/atom/mover, var/power)
	impale_victim(mover, 3)	//Charging into this thing HURTS!
	.=..()	//The charge will probably still destroy us though


/obj/structure/barricade/spike/attack_hand(var/mob/user)
	impale_victim(user, 0.5)	//Touching it with your hands hurts, but less than walking into it
	.=..()

//Attempting to climb spiked barricades is a bad idea.
/obj/structure/barricade/spike/do_climb(var/mob/living/user)
	//First of all, we stab them once while mounting
	impale_victim(user, 1.5)
	.=..()	//Then call parent
	//If the parent returns false, it means they aborted their climbing. We'll let them go
	//If it returns true, they kept going and finished the climb, we will stab them again to punish this persistence
	if (.)
		impale_victim(user, 1.5)

/obj/structure/barricade/spike/proc/impale_victim(var/mob/living/victim, var/damage_mult = 1)

	if(!isliving(victim))
		return FALSE

	if ((world.time - victim.last_bumped) <= 15) //spam guard
		return FALSE

	victim.do_attack_animation(src)
	victim.last_bumped = world.time
	playsound(src, 'sound/weapons/slice.ogg', VOLUME_MID, 1, 1)
	var/damage_holder = damage * damage_mult
	var/target_zone = pick(BP_CHEST, BP_GROIN, BP_L_LEG, BP_R_LEG)



	victim.apply_damage(damage_holder, BRUTE, target_zone, damage_flags = DAM_SHARP, used_weapon = src)
	visible_message(SPAN_DANGER("\The [victim] is [pick(poke_description)] by \the [src]!"))


	return TRUE


//Special types
/obj/structure/barricade/wood/New(var/location)
	.=..(location, MATERIAL_WOOD)

/obj/structure/barricade/steel/New(var/location)
	.=..(location, MATERIAL_STEEL)