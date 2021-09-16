/mob/proc/set_selected_zone(var/newzone)
	if (hud_used.zone_sel)
		//Possible future todo: Raise an event here
		hud_used.zone_sel.set_selected_zone(newzone)



//When passed a mob, returns the bodypart this mob is aiming its attacks at
//This is a generic proc to allow it to handle null users
/proc/get_zone_sel(var/mob/user, var/precise = FALSE)
	.= BP_CHEST
	if (istype(user) && user.hud_used.zone_sel && get_zone_sel(user))
		.=get_zone_sel(user)
		if (!precise && (. in list(BP_MOUTH,BP_EYES)))
			. = BP_HEAD

/obj/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_CHEST

/obj/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])

	var/newselect

	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					newselect = BP_R_FOOT
				if(17 to 22)
					newselect = BP_L_FOOT
				else
					return 1
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					newselect = BP_R_LEG
				if(17 to 22)
					newselect = BP_L_LEG
				else
					return 1
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					newselect = BP_R_HAND
				if(12 to 20)
					newselect = BP_GROIN
				if(21 to 24)
					newselect = BP_L_HAND
				else
					return 1
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					newselect = BP_R_ARM
				if(12 to 20)
					newselect = BP_CHEST
				if(21 to 24)
					newselect = BP_L_ARM
				else
					return 1
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				newselect = BP_HEAD
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							newselect = BP_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							newselect = BP_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							newselect = BP_EYES

	set_selected_zone(newselect)
	return 1

/obj/screen/zone_sel/proc/set_selected_zone(bodypart)
	var/old_selecting = selecting
	selecting = bodypart
	if(old_selecting != selecting)
		update_icon()

/obj/screen/zone_sel/update_icon()
	overlays.Cut()
	overlays += image('icons/mob/zone_sel.dmi', "[selecting]")