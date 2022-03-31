/obj/structure/deity/trap
	density = 0
	health = 1
	var/triggered = 0

/obj/structure/deity/trap/attackby(obj/item/W as obj, mob/user as mob)
	trigger(user)
	return ..()

/obj/structure/deity/trap/bullet_act()
	return

/obj/structure/deity/trap/Crossed(atom/movable/object)
	.=..()
	trigger(object)

/obj/structure/deity/trap/proc/trigger(atom/movable/enterer)
	if(triggered > world.time || !isliving(enterer))
		return

	triggered = world.time + 30 SECONDS
