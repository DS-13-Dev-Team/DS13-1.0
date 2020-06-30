/*
	A click catcher is an invisible object on the client screen which draws below pretty much everything else, including turfs.
	Because of this, it can only be clicked when the user clicks on blackspace, aka fog of war. Places they can't see.

	In default byond behaviour, clicks on blackspace are largely discarded. For baycode and ss13, this isn't desireable behaviour, so click catchers were
	added to intercept clicks on blackspace. This allows them to be used, for example to fire guns into the darkness
	Consolidating all this in one file

	Click catchers are implemented as a large grid, one catcher per tile visible onscreen, so an average human has 15x15 = 225 click catchers

	When and where are click catchers made? :
		1. /mob/Login calls add_click_catcher, in mob/login.dm
		2. /client/set_view_range calls remake_click_catcher, in code/_helpers/client.dm

Related Procs:


*/
/*
	Task List:
		1. Void is a single click catcher, but the proc creates a bunch of them, WHY
		2. Is the assumption about number of click catchers correct? Probably not??
		3. Is there any possibility of existing click catchers remaining when new ones are added on login?
		4. Find out the ordering of click catcher setting when a mob is logged into and their view range is immediately set
		5. Confirm the draw order of clickcatcher plane
		6. Do click catchers ever call resolve at all? If not, it should be removed
		7. The hand swap code doesn't belong here. Should it go in a click handler?

*/

//The Generic Creation Proc
//-------------------------------
/proc/create_click_catcher(var/radius = 7)
	var/diameter = (radius*2) + 1
	. = list()
	for(var/i = 0, i<diameter, i++)
		for(var/j = 0, j<diameter, j++)
			var/obj/screen/click_catcher/CC = new()
			CC.screen_loc = "NORTH-[i],EAST-[j]"
			. += CC



//Client vars
//------------------------------
/client
	var/static/obj/screen/click_catcher/void


//Client procs
//----------------------
/client/proc/setup_click_catcher()
	if(!void)
		void = create_click_catcher(temp_view)
	if(!screen)
		screen = list()
	screen |= void

/client/proc/remove_click_catcher()
	screen -= void
	void = null

/client/proc/remake_click_catcher()
	remove_click_catcher()
	setup_click_catcher()



//The click catcher object
//----------------------------
/obj/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = 2
	screen_loc = "CENTER-7,CENTER-7"


/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)

	//This should really not be here
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		//Why doesn't this call resolve?
		var/turf/T = screen_loc2turf(screen_loc, get_turf(usr))
		if(T)
			usr.client.Click(T, location, control, params)
			//T.Click(location, control, params)
	. = 1

/obj/screen/click_catcher/proc/resolve(var/mob/user)
	var/turf/T = screen_loc2turf(screen_loc, get_turf(user))
	return T