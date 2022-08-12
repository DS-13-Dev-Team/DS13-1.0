
/**********************Ore box**************************/

/obj/structure/ore_box
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	name = "ore box"
	desc = "A heavy box used for storing ore."
	density = 1

/obj/structure/ore_box/Destroy()
	for(var/obj/item/stack/ore/ore as anything in contents)
		ore.forceMove(loc)
	.=..()

/obj/structure/ore_box/proc/pick_up_ore(obj/item/stack/ore/ore)
	for(var/obj/item/stack/ore/stored_ore in contents)
		if(!istype(ore, stored_ore.type) || stored_ore == ore)
			continue
		ore.transfer_to(stored_ore)
		break
	if(!QDELING(ore))
		ore.forceMove(src)

/obj/structure/ore_box/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/ore))
		//Move it to null instead of ore box to prevent bugs
		if(user.unEquip(W, null))
			pick_up_ore(W)
	else if (istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		S.hide_from(usr)
		var/list/new_ore = list()
		for(var/obj/item/stack/ore/O in S.contents)
			S.remove_from_storage(O, src, 1) //This will move the item to this item's contents
			new_ore += O
		S.finish_bulk_removal()
		//Merge new ores with our contents
		for(var/ore in new_ore)
			pick_up_ore(ore)
		to_chat(user, "<span class='notice'>You empty the satchel into the box.</span>")



//A debug type that contains a bunch of randomly generated ores
/obj/structure/ore_box/random/Initialize()
	.=..()
	for (var/i in 1 to 30)
		var/ore_name = pick(GLOB.ore_data)
		var/ore/ore_datum = GLOB.ore_data[ore_name]
		new ore_datum.ore(src)

//A debug type that contains one of each ore
/obj/structure/ore_box/all/Initialize()
	.=..()
	for (var/ore_name in GLOB.ore_data)
		var/ore/ore_datum = GLOB.ore_data[ore_name]
		new ore_datum.ore(src)

/obj/structure/ore_box/examine(mob/user)
	. = ..(user)

	// Borgs can now check contents too.
	if((!istype(user, /mob/living/carbon/human)) && (!istype(user, /mob/living/silicon/robot)))
		return

	if(!Adjacent(user)) //Can only check the contents of ore boxes if you can physically reach them.
		return

	add_fingerprint(user)

	if(!contents.len)
		to_chat(user, "It is empty.")
		return

	to_chat(user, "It holds:")
	var/list/ores = list()
	for(var/obj/item/stack/ore/ore in contents)
		ores[ore.type] += ore.amount
	for(var/obj/item/stack/ore/ore as anything in ores)
		to_chat(user, "- [ores[ore]] [initial(ore.name)]")

	return


/obj/structure/ore_box/verb/empty_box()
	set name = "Empty Ore Box"
	set category = "Object"
	set src in view(1)

	if(!istype(usr, /mob/living/carbon/human) && usr.is_advanced_tool_user()) //Only living, intelligent creatures with hands can empty ore boxes.
		to_chat(usr, "<span class='warning'>You are physically incapable of emptying the ore box.</span>")
		return

	if( usr.stat || usr.restrained() )
		return

	if(!Adjacent(usr)) //You can only empty the box if you can physically reach it
		to_chat(usr, "You cannot reach the ore box.")
		return

	add_fingerprint(usr)

	if(contents.len < 1)
		to_chat(usr, "<span class='warning'>The ore box is empty</span>")
		return

	for (var/obj/item/stack/ore/O in contents)
		O.forceMove(loc)
	to_chat(usr, "<span class='notice'>You empty the ore box</span>")

	return

/obj/structure/ore_box/ex_act(severity, var/atom/epicentre)
	if(atom_flags & ATOM_FLAG_INDESTRUCTIBLE)
		return
	if(severity == 1.0 || (severity < 3.0 && prob(50)))
		for (var/obj/item/stack/ore/O in contents)
			O.forceMove(loc)
			O.ex_act(severity++, epicentre)
		qdel(src)
		return