GLOBAL_LIST_EMPTY(marker_spawns)

/datum/game_mode/marker
	name = "The marker"
	round_description = "The USG Ishimura has unearthed a strange artifact and is tasked with discovering what its purpose is."
	extended_round_description = "The crew must survive the marker's onslaught, or destroy the marker."
	config_tag = "marker"
//	required_players = 10 Commented out so I can test it.
//	required_enemies = 3 //1 marker, 2 unitologists.
	required_players = 0
	required_enemies = 0
	end_on_antag_death = 0
	auto_recall_shuttle = 1
	antag_tags = list(MODE_MARKER, MODE_UNITOLOGIST)
	latejoin_antag_tags = list(MODE_UNITOLOGIST)
	auto_recall_shuttle = TRUE //No escape
	var/evac_points = 0
	var/evac_threshold = 85 //2 hours until you get to evac.
	var/mob/living/simple_animal/marker/themarker = null

/obj/effect/landmark/marker_spawn //Landmark to keep track of marker spawns
	name = "Marker spawn point"

/obj/effect/landmark/marker_spawn/New()
	. = ..()
	GLOB.marker_spawns += src

/mob/living/simple_animal/marker
	name = "Spooky alien thing"
	desc = "RUN!"
	icon_state = "spacewormhead1"
	dir = 1
	anchored = TRUE
//	icon_living = "spacewormhead1"
	//psychosis_immune = TRUE



/datum/game_mode/marker/post_setup() //Mr Gaeta. Start the clock.
	. = ..()
	if(!GLOB.marker_spawns.len)
		message_admins("There are no marker spawns on this map!")
		return
	var/turf/T = get_turf(pick(GLOB.marker_spawns))
	themarker = new /mob/living/simple_animal/marker(T)
	command_announcement.Announce("We shipped you a spooky looking alien thing, our delivery intern left it at [get_area(themarker)].","Exposition machine") //Placeholder
	addtimer(CALLBACK(src, .proc/activate_marker), rand(20 MINUTES, 35 MINUTES)) //We have to spawn the marker quite late, so guess we'd best wait :)


/datum/game_mode/marker/proc/activate_marker()
	charge_evac_points()
	if(themarker.mind)
		GLOB.unitologists.add_antagonist(themarker.mind)

/datum/game_mode/marker/proc/charge_evac_points()
	addtimer(CALLBACK(src, .proc/charge_evac_points), 1 MINUTE) //Recursive function that will slowly tick down the clock until the valour comes to rescue the ishimura's crew.
	evac_points ++
	if(evac_points >= evac_threshold)
		return
		//Call shuttle