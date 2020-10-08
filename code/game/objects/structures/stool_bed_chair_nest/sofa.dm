/obj/structure/bed/sofa
	name = "Sofa"
	desc = "You need buns of steel to sit on these uncomfortable babies for more than 5 minutes!"
	icon = 'icons/obj/furniture.dmi'
	icon_state = "sofa" //use child icons
	anchored = 1 //can't rotate sofas
	can_buckle = 1 //Icons aren't setup for this to look right, so just disable it for now. Maybe when we fix the icons y'know?
// Above was enabled by me, Lion, because I won't be using any of the unorthodox sprites.

//South facing couches. To-do, replicate NicBoone icons and make north facing icons. Non-double vertical couches.

/obj/structure/bed/sofa/east/New(var/newloc, var/new_material)
	name = "Couch"
	icon_state = "sofaeast"
	..(newloc,"steel","plastic")

/obj/structure/bed/sofa/west
	name = "Couch"
	icon_state = "sofawest"

/obj/structure/bed/sofa/south/grey/New(var/newloc, var/new_material) //center
	name = "Couch"
	icon_state = "couch_hori2"
	..(newloc,"steel","plastic")

/obj/structure/bed/sofa/south/grey/left/New(var/newloc, var/new_material) //left
	name = "Couch edge"
	icon_state = "couch_hori1"
	..(newloc,"steel","plastic")

/obj/structure/bed/sofa/south/grey/right/New(var/newloc, var/new_material) //right
	name = "Couch edge"
	icon_state = "couch_hori3"
	..(newloc,"steel","plastic")

/obj/structure/bed/sofa/north/grey //center
    name = "Couch"
    icon_state = "couch_horinorth2"

/obj/structure/bed/sofa/north/grey/left //left
    name = "Couch edge"
    icon_state = "couch_horinorth1"

/obj/structure/bed/sofa/north/grey/right //right
    name = "Couch edge"
    icon_state = "couch_horinorth3"

/obj/structure/bed/sofa/south/white //center
    name = "Couch"
    icon_state = "bench_hor2"

/obj/structure/bed/sofa/south/white/left //left
    name = "Couch edge"
    icon_state = "bench_hor1"

/obj/structure/bed/sofa/south/white/right //right
    name = "Couch edge"
    icon_state = "bench_hor3"

//Vertical double sided couches. Think airport lounge.

/obj/structure/bed/sofa/vert/grey //center
    name = "Couch"
    icon_state = "couch_vet2"

/obj/structure/bed/sofa/vert/grey/bot //bottom
    name = "Couch edge"
    icon_state = "couch_vet1"

/obj/structure/bed/sofa/vert/grey/top //top
    name = "Couch edge"
    icon_state = "couch_vet3"

/obj/structure/bed/sofa/vert/white //center
    name = "Couch"
    icon_state = "bench_vet2"

/obj/structure/bed/sofa/vert/white/bot //bottom
    name = "Couch edge"
    icon_state = "bench_vet1"

/obj/structure/bed/sofa/vert/white/top //top
    name = "Couch edge"
    icon_state = "bench_vet3"
