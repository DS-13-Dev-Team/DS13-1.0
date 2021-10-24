//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/global/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
GLOBAL_LIST(chemical_reactions_list)				//list of all /datum/chemical_reaction datums. Used during chemical reactions
var/global/list/landmarks_list = list()				//list of all landmarks created
var/global/list/surgery_steps = list()				//list of all surgery steps  |BS12
var/global/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12
var/global/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.
var/global/list/joblist = list()					//list of all jobstypes, minus borg and AI

#define all_genders_define_list list(MALE,FEMALE,PLURAL,NEUTER)
#define all_genders_text_list list("Male","Female","Plural","Neuter")

//Languages/species/whitelist.
var/global/list/all_species[0]
GLOBAL_LIST_EMPTY(all_necromorph_species)
var/global/list/all_languages[0]
var/global/list/language_keys[0]					// Table of say codes for all languages
var/global/list/whitelisted_species = list(SPECIES_HUMAN) // Species that require a whitelist check.
var/global/list/playable_species = list(SPECIES_HUMAN)    // A list of ALL playable species, whitelisted, latejoin or otherwise.


//A list of IC characters in the format character_id = mind
GLOBAL_LIST_EMPTY(characters)

//Datum/patron_item instances
GLOBAL_LIST_EMPTY(patron_items)

//This list holds each unique ckey which appears on any whitelist for any number of patron items.area
//It is in the format ckey = list(item, item, item, etc)
//Each item is a /datum/patron_item singleton
GLOBAL_LIST_EMPTY(patron_item_whitelisted_ckeys)

GLOBAL_LIST_EMPTY(client_themes)

var/list/mannequins_

/*
	Antag/Objective stuff
*/
GLOBAL_LIST_EMPTY(all_crew_objectives)

// Grabs
var/global/list/all_grabstates[0]
var/global/list/all_grabobjects[0]

// Uplinks
var/list/obj/item/device/uplink/world_uplinks = list()


//HUD
GLOBAL_LIST_EMPTY(fullscreen_icons)	//Used to store fullscreen icons in nondefault sizes

//Preferences stuff
//Hairstyles
GLOBAL_LIST_EMPTY(hair_styles_list)        //stores /datum/sprite_accessory/hair indexed by name
GLOBAL_LIST_EMPTY(facial_hair_styles_list) //stores /datum/sprite_accessory/facial_hair indexed by name

var/global/list/skin_styles_female_list = list()		//unused
GLOBAL_LIST_EMPTY(body_marking_styles_list)		//stores /datum/sprite_accessory/marking indexed by name

GLOBAL_DATUM_INIT(underwear, /datum/category_collection/underwear, new())

var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg)



// Runes
var/global/list/rune_list = new()
var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()


//Targeting profiles, mainly for turrets
GLOBAL_LIST_EMPTY(targeting_profiles)

//Signal Abilities/spells
GLOBAL_LIST_EMPTY(signal_abilities)

var/global/list/syndicate_access = list(access_maint_tunnels, access_external_airlocks)//,access_syndicate)

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
var/global/list/string_part_flags = list(
	"head" = HEAD,
	"face" = FACE,
	"eyes" = EYES,
	"upper body" = UPPER_TORSO,
	"lower body" = LOWER_TORSO,
	"legs" = LEGS,
	"feet" = FEET,
	"arms" = ARMS,
	"hands" = HANDS
)

// Strings which corraspond to slot flags, useful for outputting what slot something is.
var/global/list/string_slot_flags = list(
	"back" = SLOT_BACK,
	"face" = SLOT_MASK,
	"waist" = SLOT_BELT,
	"ID slot" = SLOT_ID,
	"ears" = SLOT_EARS,
	"eyes" = SLOT_EYES,
	"hands" = SLOT_GLOVES,
	"head" = SLOT_HEAD,
	"feet" = SLOT_FEET,
	"exo slot" = SLOT_OCLOTHING,
	"body" = SLOT_ICLOTHING,
	"uniform" = SLOT_TIE,
	"holster" = SLOT_HOLSTER
)

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/get_mannequin(var/ckey)
	if(!mannequins_)
		mannequins_ = new()
	. = mannequins_[ckey]
	if(!.)
		. = new/mob/living/carbon/human/dummy/mannequin()
		mannequins_[ckey] = .

/proc/makeDatumRefLists()
	var/list/paths

	//Initialize data for mining
	ensure_ore_data_initialised()

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		GLOB.hair_styles_list[H.name] = H

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		GLOB.facial_hair_styles_list[H.name] = H

	//Body markings - Initialise all /datum/sprite_accessory/marking into an list indexed by marking name
	paths = typesof(/datum/sprite_accessory/marking) - /datum/sprite_accessory/marking
	for(var/path in paths)
		var/datum/sprite_accessory/marking/M = new path()
		GLOB.body_marking_styles_list[M.name] = M

	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = typesof(/datum/surgery_step)-/datum/surgery_step
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		surgery_steps += S
	sort_surgeries()

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = typesof(/datum/job)-/datum/job
	paths -= exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		joblist[J.title] = J

	//Languages and species.
	paths = typesof(/datum/language)-/datum/language
	for(var/T in paths)
		var/datum/language/L = new T
		all_languages[L.name] = L

	for (var/language_name in all_languages)
		var/datum/language/L = all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			language_keys[lowertext(L.key)] = L

	var/rkey = 0
	paths = typesof(/datum/species)
	for(var/T in paths)
		rkey++

		var/datum/species/S = T
		if(!initial(S.name))
			continue

		S = new T
		S.race_key = rkey //Used in mob icon caching.
		all_species[S.name] = S

		if (istype(S, /datum/species/necromorph))
			GLOB.all_necromorph_species[S.name] = S

		if(!(S.spawn_flags & SPECIES_IS_RESTRICTED))
			playable_species += S.name
		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			whitelisted_species += S.name

	//Grabs
	paths = typesof(/datum/grab) - /datum/grab
	for(var/T in paths)
		var/datum/grab/G = new T
		if(G.state_name)
			all_grabstates[G.state_name] = G

	paths = typesof(/obj/item/grab) - /obj/item/grab
	for(var/T in paths)
		var/obj/item/grab/G = T
		all_grabobjects[initial(G.type_name)] = T

	for(var/grabstate_name in all_grabstates)
		var/datum/grab/G = all_grabstates[grabstate_name]
		G.refresh_updown()


	//Signal Abilities
	for (var/subtype in subtypesof(/datum/signal_ability))
		var/datum/signal_ability/SA = subtype
		if (initial(SA.base_type) == subtype)
			continue	//If base type matches type, its an abstract parent class, do not instantiate

		SA = new subtype()
		GLOB.signal_abilities[SA.id] = SA

	//Targeting profiles
	for (var/subtype in subtypesof(/datum/targeting_profile))
		var/datum/targeting_profile/SA = subtype
		if (initial(SA.base_type) == subtype)
			continue	//If base type matches type, its an abstract parent class, do not instantiate

		SA = new subtype()
		GLOB.targeting_profiles[SA.id] = SA

	//Gradients - Initialise all /datum/sprite_accessory/hair_gradients into an list indexed by hairgradient-style name
	for(var/grad in subtypesof(/datum/sprite_accessory/hair_gradients))
		var/datum/sprite_accessory/hair_gradients/H = new grad()
		GLOB.hair_gradient_styles_list[H.name] = H

	sortTim(GLOB.hair_gradient_styles_list, /proc/cmp_text_asc)

	for (var/subtype in subtypesof(/datum/antagonist))
		var/datum/antagonist/SA = subtype
		if (initial(SA.base_type) == subtype)
			continue	//If base type matches type, its an abstract parent class, do not instantiate

		SA = new subtype()//antag datums add themselves to global lists in new, just creating it is enough
	initialize_emergency_calls()

	//Crew objectives
	for (var/subtype in subtypesof(/datum/crew_objective))
		var/datum/crew_objective/CO = new subtype()//antag datums add themselves to global lists in new, just creating it is enough
		GLOB.all_crew_objectives[subtype] = CO	//To complete the setup, Initialize needs to be called on them
		//We do NOT do that here. It is done in map post_setup, its a per-map thing
		//

	return 1

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	log_debug(.)

*/

//*** params cache

var/global/list/paramslist_cache = list()

#define cached_key_number_decode(key_number_data) cached_params_decode(key_number_data, /proc/key_number_decode)
#define cached_number_list_decode(number_list_data) cached_params_decode(number_list_data, /proc/number_list_decode)

/proc/cached_params_decode(var/params_data, var/decode_proc)
	. = paramslist_cache[params_data]
	if(!.)
		. = call(decode_proc)(params_data)
		paramslist_cache[params_data] = .

/proc/key_number_decode(var/key_number_data)
	var/list/L = params2list(key_number_data)
	for(var/key in L)
		L[key] = text2num(L[key])
	return L

/proc/number_list_decode(var/number_list_data)
	var/list/L = params2list(number_list_data)
	for(var/i in 1 to L.len)
		L[i] = text2num(L[i])
	return L

var/global/list/unworn_slots = list(slot_l_hand,slot_r_hand, slot_l_store, slot_r_store,slot_robot_equip_1,slot_robot_equip_2,slot_robot_equip_3)