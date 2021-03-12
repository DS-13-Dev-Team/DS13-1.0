/obj/item/proc/get_onmob_delay()
	return 0

/obj/item/weapon/legcuffs/get_onmob_delay()
	return move_delay

///obj/item/weapon/legcuffs is a debug item
/obj/item/weapon/legcuffs
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	item_state_slots = list(
		slot_legcuffed_str = "legcuff1",
		)
	var/move_delay = 6
	var/breakouttime = 600

/obj/item/weapon/legcuffs/Destroy()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.legcuffed == src)
			M.legcuffed = null
			M.update_inv_legcuffed()
	return ..()

/obj/item/weapon/legcuffs/bola
	name = "bola"
	desc = "A restraining device designed to be thrown at the target. Upon connecting with said target, it will wrap around their legs, making it difficult for them to move quickly."
	icon_state = "bola"
	breakouttime = 35//easy to apply, easy to break out of
	gender = NEUTER
	origin_tech = "engineering=3;combat=1"
	hitsound = 'sound/effects/snap.ogg'
	var/weaken = 0

/obj/item/weapon/legcuffs/bola/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force)
	playsound(loc,'sound/weapons/bolathrow.ogg', 50, TRUE)
	if(!..())
		return

/obj/item/weapon/legcuffs/bola/throw_impact(atom/hit_atom)
	if(..() || !ishuman(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	cacht(hit_atom)

/obj/item/weapon/legcuffs/bola/proc/cacht(var/mob/living/carbon/human/H)
	if(!H.legcuffed && H.has_organ_for_slot(slot_legcuffed))
		visible_message("<span class='danger'>[src] ensnares [H]!</span>")
		H.legcuffed = src
		forceMove(H)
		H.update_inv_legcuffed()
		to_chat(H, "<span class='userdanger'>[src] ensnares you!</span>")
		H.Weaken(weaken)
		playsound(loc, hitsound, 50, TRUE)

/obj/item/weapon/legcuffs/bola/tactical
	name = "reinforced bola"
	desc = "A strong bola, made with a long steel chain. It looks heavy, enough so that it could trip somebody."
	icon_state = "bola_r"
	breakouttime = 70
	origin_tech = "engineering=4;combat=3"
	weaken = 1
