/*
	Simple system for objects which draw over the skybox, to be expanded along with our needs

	These are singletons, initialised as needed. so they shouldn't modify themselves at runtime
*/
/datum/skybox_foreground_object
	var/icon
	var/list/icon_states

	var/scale = 1

	//The values here should be in the range 0 to 1, as they are a percentage of skybox side size
	var/vector2/offset

//Return the fixed offset
//FUTURE TODO: Allow generating a random offset
/datum/skybox_foreground_object/proc/get_offset()
	if (offset)
		return offset

	return null


//Future TODO: Random placement within the area
//Future TODO: Random rotation
//Future TODO: Variable quantities of an object
//Future TODO: Optionally taking on the background color
/datum/skybox_foreground_object/aegis_vii
	icon = 'icons/skybox/planet_large.dmi'
	icon_states = list("aegis_vii")

	offset = new /vector2(-0.25, -0.25)
	scale = 0.5

