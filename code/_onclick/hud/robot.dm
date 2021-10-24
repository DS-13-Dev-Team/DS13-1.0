var/obj/screen/robot_inventory

/mob/living/silicon/robot
	hud_type = /datum/hud/robot

/datum/hud/robot/New(mob/owner)
	..()

	var/obj/screen/using

//Radio
	using = new /obj/screen()
	using.SetName("radio")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/hud/screen1_robot.dmi'
	using.icon_state = "radio"
	using.screen_loc = ui_movi
	static_inventory += using

//Module select

	using = new /obj/screen()
	using.SetName("module1")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/hud/screen1_robot.dmi'
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	toggleable_inventory += using
	mymob:inv1 = using

	using = new /obj/screen()
	using.SetName("module2")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/hud/screen1_robot.dmi'
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	toggleable_inventory += using
	mymob:inv2 = using

	using = new /obj/screen()
	using.SetName("module3")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/hud/screen1_robot.dmi'
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	toggleable_inventory += using
	mymob:inv3 = using

//End of module select

//Intent
	using = new /obj/screen()
	using.SetName("act_intent")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/hud/screen1_robot.dmi'
	using.icon_state = mymob.a_intent
	using.screen_loc = ui_acti
	static_inventory += using
	action_intent = using

//Cell
	mymob:cells = new /obj/screen()
	mymob:cells:icon = 'icons/hud/screen1_robot.dmi'
	mymob:cells:icon_state = "charge-empty"
	mymob:cells:SetName("cell")
	mymob:cells:screen_loc = ui_toxin
	infodisplay += mymob:cells

//Health
	healths = new /obj/screen()
	healths.icon = 'icons/hud/screen1_robot.dmi'
	healths.icon_state = "health0"
	healths.SetName("health")
	healths.screen_loc = ui_borg_health
	infodisplay += healths

//Installed Module
	hands = new /obj/screen()
	hands.icon = 'icons/hud/screen1_robot.dmi'
	hands.icon_state = "nomod"
	hands.SetName("module")
	hands.screen_loc = ui_borg_module
	toggleable_inventory += hands

//Module Panel
	using = new /obj/screen()
	using.SetName("panel")
	using.icon = 'icons/hud/screen1_robot.dmi'
	using.icon_state = "panel"
	using.screen_loc = ui_borg_panel
	static_inventory += using

//Store
	throw_icon = new /obj/screen()
	throw_icon.icon = 'icons/hud/screen1_robot.dmi'
	throw_icon.icon_state = "store"
	throw_icon.SetName("store")
	throw_icon.screen_loc = ui_borg_store
	static_inventory += throw_icon

//Inventory
	robot_inventory = new /obj/screen()
	robot_inventory.SetName("inventory")
	robot_inventory.icon = 'icons/hud/screen1_robot.dmi'
	robot_inventory.icon_state = "inventory"
	robot_inventory.screen_loc = ui_borg_inventory
	toggleable_inventory += robot_inventory

//Temp
	bodytemp = new /obj/screen()
	bodytemp.icon_state = "temp0"
	bodytemp.SetName("body temperature")
	bodytemp.screen_loc = ui_temp
	infodisplay += bodytemp

	oxygen = new /obj/screen()
	oxygen.icon = 'icons/hud/screen1_robot.dmi'
	oxygen.icon_state = "oxy0"
	oxygen.SetName("oxygen")
	oxygen.screen_loc = ui_oxygen
	infodisplay += oxygen

	fire = new /obj/screen()
	fire.icon = 'icons/hud/screen1_robot.dmi'
	fire.icon_state = "fire0"
	fire.SetName("fire")
	fire.screen_loc = ui_fire
	infodisplay += fire

	pullin = new /obj/screen()
	pullin.icon = 'icons/hud/screen1_robot.dmi'
	pullin.icon_state = "pull0"
	pullin.SetName("pull")
	pullin.screen_loc = ui_borg_pull
	static_inventory += pullin

	zone_sel = new /obj/screen/zone_sel()
	zone_sel.icon = 'icons/hud/screen1_robot.dmi'
	zone_sel.overlays.Cut()
	zone_sel.overlays += image('icons/hud/zone_sel.dmi', "[zone_sel.selecting]")
	static_inventory += zone_sel

	//Handle the gun settings buttons
	gun_setting_icon = new /obj/screen/gun/mode(null)
	static_inventory += gun_setting_icon

	mymob.client.screen = list()

/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	if(r.shown_robot_modules)
		if(r.s_active)
			r.s_active.close(r) //Closes the inventory ui.
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			to_chat(usr, "<span class='danger'>No module selected</span>")
			return

		if(!r.module.modules)
			to_chat(usr, "<span class='danger'>Selected module has no modules to select</span>")
			return

		if(!r.robot_modules_background)
			return

		var/display_rows = -round(-(r.module.modules.len) / 8)
		r.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		r.client.screen += r.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(r.emagged)
			if(!(r.module.emag in r.module.modules))
				r.module.modules.Add(r.module.emag)
		else
			if(r.module.emag in r.module.modules)
				r.module.modules.Remove(r.module.emag)

		for(var/atom/movable/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:[WORLD_ICON_SIZE/2],SOUTH+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:[WORLD_ICON_SIZE/2],SOUTH+[y]:7"
				A.hud_layerise()

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		r.client.screen -= r.robot_modules_background
