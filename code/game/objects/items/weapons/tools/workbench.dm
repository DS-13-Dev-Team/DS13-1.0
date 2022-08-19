//A workbench for upgrading things
/obj/structure/workbench
	name = "Nanocircuit Repair Bench"
	desc = "For repairing and upgrading devices and tools."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "deadspace_workbench"
	resistance = 10
	max_health = 200 //Hard to break
	density = TRUE
	anchored = TRUE

//Quick ways to open crafting menu at this workbench
/obj/structure/workbench/attack_hand(mob/user)
	if(..())
		return
	if(isliving(user))
		var/mob/living/L = user
		L.open_craft_menu()
