/*
	A click catcher is an invisible object on the client screen which draws below pretty much everything else, including turfs.
	Because of this, it can only be clicked when the user clicks on blackspace, aka fog of war. Places they can't see.

	In default byond behaviour, clicks on blackspace are largely discarded. For baycode and ss13, this isn't desireable behaviour, so click catchers were
	added to intercept clicks on blackspace. This allows them to be used, for example to fire guns into the darkness
	Consolidating all this in one file

	Click catchers are implemented as single large object covering the screen. They are stored in a global list rather than being recreated


	When and where are click catchers made? :
		1. /mob/Login calls add_click_catcher, in mob/login.dm
		2. /client/set_view_range calls remake_click_catcher, in code/_helpers/client.dm
		3. click_handler.dm, resolve world target

Related Procs:


*/
/*
	Task List:
		1. Void is a single click catcher, but the proc creates a bunch of them, WHY. Void should not exist
		2. Is the assumption about number of click catchers correct? Yes but why so many
		3. Is there any possibility of existing click catchers remaining when new ones are added on login?
		4. Find out the ordering of click catcher setting when a mob is logged into and their view range is immediately set
		5. Confirm the draw order of clickcatcher plane
		6. click_handler.dm, resolve world target, calls the resolve proc on a click catcher, maybe replace this with macro
		7. The hand swap code doesn't belong here. Should it go in a click handler?
		8. Bay uses a global list of clickhandler objects, consider doing this too
*/

//The Generic Creation Proc
//-------------------------------
/proc/create_click_catcher(var/radius = 7)
	var/diameter = (radius*2) + 1
	///*
	var/obj/screen/click_catcher/CC = new()
	CC.transform = CC.transform.Scale(diameter)
	//We must position it in the centre of the screen
	//Note that by default it places its lowerleft corner where we point, so we need to add pixel offsets to accomodate that
	CC.screen_loc = "CENTER,CENTER"
	return CC
	//*/
	/*
	. = list()
	for(var/i = 0, i<diameter, i++)
		for(var/j = 0, j<diameter, j++)
			var/obj/screen/click_catcher/CC = new()
			CC.screen_loc = "NORTH-[i],EAST-[j]"
			. += CC
	*/


//Client vars
//------------------------------
/client
	var/obj/screen/click_catcher/void


//Client procs
//----------------------
/client/proc/setup_click_catcher()
	void = GLOB.click_catchers["[temp_view]"]
	if(!void)
		void = GLOB.click_catchers["[temp_view]"] = create_click_catcher(temp_view)
	if(!screen)
		screen = list()
	screen |= void

/client/proc/remove_click_catcher()
	screen -= void
	void = null

//This is a slightly bad thing to do but i want to make sure this problem is gone for good
//This is mildly inefficient and should only be called at places which aren't performance critical
/client/proc/thorough_remove_click_catcher()
	remove_click_catcher()
	for (var/obj/screen/click_catcher/C in screen)
		screen -= C

/client/proc/remake_click_catcher()
	remove_click_catcher()
	setup_click_catcher()



//Mob Procs
//-------------
/mob/proc/add_click_catcher()
	if (client)
		client.remake_click_catcher()

/mob/proc/remove_click_catcher()
	if (client)
		client.remove_click_catcher()

/mob/new_player/add_click_catcher()
	return



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
		var/turf/T = RESOLVE_CLICK_CATCHER(params, usr.client)
		if(T)
			usr.client.Click(T, location, control, params)
			//T.Click(location, control, params)
	. = 1


