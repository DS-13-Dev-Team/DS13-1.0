/obj/effect/landmark/test/safe_turf
	name = "safe_turf" // At creation, landmark tags are set to: "landmark*[name]"
	desc = "A safe turf should be an as large block as possible of livable, passable turfs, preferably at least 3x3 with the marked turf as the center"

/obj/effect/landmark/test/space_turf
	name = "space_turf"
	desc = "A space turf should be an as large block as possible of space, preferably at least 3x3 with the marked turf as the center"

#ifdef UNIT_TESTS

/datum/fake_client

/mob/fake_mob
	var/datum/fake_client/fake_client

/mob/fake_mob/Destroy()
	QDEL_NULL(fake_client)
	. = ..()

/mob/fake_mob/get_client()
	if(!fake_client)
		fake_client = new()
	return fake_client


/obj/unit_test_light
	w_class = 1

/obj/unit_test_medium
	w_class = 3

/obj/unit_test_heavy
	w_class = 5
/*
/obj/random/unit_test/spawn_choices()
	return list(/obj/unit_test_light, /obj/unit_test_heavy, /obj/unit_test_medium)
*/

#endif
