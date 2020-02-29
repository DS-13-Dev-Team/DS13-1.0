/obj/random/rare
	name = "random tool"
	icon_state = "tool-grey"
	spawn_nothing_percentage = 0
	has_postspawn = TRUE


/obj/random/rare/item_to_spawn()
	return pickweight(list(/obj/random/projectile  = 1))