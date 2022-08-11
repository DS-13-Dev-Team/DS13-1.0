/obj/machinery/disease2/biodestroyer
	name = "Biohazard destroyer"
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposalbio"
	var/list/accepts = list(/obj/item/clothing,/obj/item/virusdish/,/obj/item/cureimplanter,/obj/item/diseasedisk,/obj/item/reagent_containers)
	density = 1
	anchored = 1

/obj/machinery/disease2/biodestroyer/attackby(var/obj/I as obj, var/mob/user as mob)
	for(var/path in accepts)
		if(I.type in typesof(path))
			qdel(I)
			overlays += image('icons/obj/pipes/disposal.dmi', "dispover-handle")
			return
	if(!user.unEquip(I, get_turf(src)))
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] <span class='notice'>\The [src] beeps</span>", 2)