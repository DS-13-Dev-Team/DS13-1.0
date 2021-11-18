/mob
	datum_flags = DATUM_FLAG_WEAKREF_USE_TAG
	density = TRUE
	plane = DEFAULT_PLANE
	layer = MOB_LAYER

	appearance_flags = PIXEL_SCALE|LONG_GLIDE
	animate_movement = 2
	movable_flags = MOVABLE_FLAG_PROXMOVE

	virtual_mob = /mob/dead/observer/virtual/mob

	movement_handlers = list(
		/datum/movement_handler/move_relay,
		/datum/movement_handler/mob/delay,
		/datum/movement_handler/mob/physically_capable,
		/datum/movement_handler/mob/physically_restrained,	//TODO: Add this from various things it checks, should be removed otherwise
		/datum/movement_handler/mob/movement
	)

	var/mob_flags

	var/last_quick_move_time = 0
	var/list/client_images = list() // List of images applied to/removed from the client on login/logout
	var/datum/mind/mind

	var/lastKnownIP = null
	var/computer_id = null

	var/stat = 0 //Whether a mob is alive or dead. TODO: Move this to living - Nodrak

	var/use_me = 1 //Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/damageoverlaytemp = 0
	var/obj/machinery/machine = null
	var/poll_answer = 0.0
	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon

	var/atom/movable/pulling = null
	var/other_mobs = null
	var/next_move = null
	var/hand = null
	var/real_name = null

	var/bhunger = 0			//Carbon

	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon
	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/lying = 0
	var/lying_prev = 0

	var/unacidable = 0
	var/list/pinned = list()            // List of things pinning this creature to walls (see living_defense.dm)
	var/list/embedded = list()          // Embedded items, since simple mobs don't have organs.
	var/list/languages = list()         // For speaking/listening.
	var/species_language = null			// For species who want reset to use a specified default.
	var/only_species_language  = 0		// For species who can only speak their default and no other languages. Does not effect understanding.
	var/list/speak_emote = list("says") // Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/emote_type = 1		// Define emote default type, 1 for seen emotes, 2 for heard emotes
	var/facing_dir = null   // Used for the ancient art of moonwalking.

	var/name_archive //For admin things like possession

	var/timeofdeath = 0

	var/bodytemperature = 310.055	//98.7 F



	var/a_intent = I_HELP//Living

	var/decl/move_intent/move_intent = /decl/move_intent/walk
	var/list/move_intents = list(/decl/move_intent/walk)

	var/decl/move_intent/default_walk_intent
	var/decl/move_intent/default_run_intent

	var/obj/buckled = null//Living
	var/obj/item/l_hand = null//Living
	var/obj/item/r_hand = null//Living
	var/obj/item/weapon/back = null//Human/Monkey
	var/obj/item/weapon/storage/s_active = null//Carbon
	var/obj/item/clothing/mask/wear_mask = null//Carbon

	var/list/grabbed_by = list(  )

	var/in_throw_mode = 0

	var/inertia_dir = 0

//	var/job = null//Living

	var/can_pull_size = ITEM_SIZE_NO_CONTAINER // Maximum w_class the mob can pull.
	var/can_pull_mobs = MOB_PULL_SAME          // Whether or not the mob can pull other mobs.

	var/datum/dna/dna = null//Carbon
	var/list/active_genes=list()
	var/list/mutations = list() //Carbon -- Doohl
	//see: setup.dm for list of mutations

	var/radiation = 0.0//Carbon

	var/voice_name = "unidentifiable voice"

	var/faction = "neutral" //Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/blinded = null
	var/ear_deaf = null		//Carbon

//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/mob/living/carbon/LAssailant = null

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/update_icon = 1 //Set to 1 to trigger update_icons() at the next life() call

	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/area/lastarea = null

	var/digitalcamo = 0 // Can they be tracked by the AI?

	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone -- TLE
	var/universal_understand = 0 // Set to 1 to enable the mob to understand everyone, not necessarily speak

	//If set, indicates that the client "belonging" to this (clientless) mob is currently controlling some other mob
	//so don't treat them as being SSD even though their client var is null.
	var/mob/teleop = null

	var/turf/listed_turf = null  	//the current turf being examined in the stat panel
	var/list/shouldnt_see = list()	//list of objects that this mob shouldn't see in the stat panel. this silliness is needed because of AI alt+click and cult blood runes

	var/mob_size = MOB_MEDIUM
	var/throw_multiplier = 1

	var/paralysis = 0
	var/stunned = 0
	var/weakened = 0
	var/drowsyness = 0.0//Carbon

	var/memory = ""
	var/flavor_text = ""

	var/datum/skillset/skillset = /datum/skillset

	var/last_radio_sound = -INFINITY

	//Interaction
	var/limited_click_arc = 0	//If nonzero, the mob is limited to clicking on things in X degrees arc infront of it. Best combined with slow turning. Recommended values, 45 or 90

	//Movement
	var/slow_turning = FALSE //If true, mob goes on move+click cooldown when rotating in place, and can't turn+move in the same step
	var/move_speed_factor		=	1	//A multiplier on movespeed, and a divisor on move delays

	//Vision
	var/view_offset = 0
	var/view_range = WORLD_VIEW_RANGE
	var/lock_view = FALSE	//Used in mob/mob.dm, to tell reset_view not to do certain things


	//Combat
	var/evasion = 15	//A base percentage chance of avoiding attacks which would otherwise hit

	//Seciruty
	var/list/logging = list()
	var/static/next_mob_id = 0
