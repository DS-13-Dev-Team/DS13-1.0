/obj/item/modular_computer/console
	name = "console"
	desc = "A stationary computer."
	icon = 'icons/obj/modular_console.dmi'
	icon_state = "console"
	icon_state_unpowered = "console"
	icon_state_menu = "menu"
	hardware_flag = PROGRAM_CONSOLE
	anchored = TRUE
	density = 1
	base_idle_power_usage = 100
	base_active_power_usage = 500
	max_hardware_size = 3
	steel_sheet_cost = 20
	light_strength = 4
	max_damage = 300
	broken_damage = 150
	atom_flags = ATOM_FLAG_CLIMBABLE

	//A rare case of a dense item
	can_block_movement = TRUE

/obj/item/modular_computer/console/CouldUseTopic(var/mob/user)
	..()
	if(istype(user, /mob/living/carbon))
		if(prob(50))
			playsound(src, "keyboard", 40)
		else
			playsound(src, "keystroke", 40)


/obj/item/modular_computer/console/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return ..()
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	return .=..()