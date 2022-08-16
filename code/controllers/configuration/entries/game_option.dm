
//game_options.txt configs

/datum/config_entry/number/health_threshold_crit
	config_entry_value = -50
	integer = FALSE

/datum/config_entry/number/health_threshold_dead
	config_entry_value = -100
	integer = FALSE

/datum/config_entry/number/organ_health_multiplier
	config_entry_value = 0.9
	integer = FALSE

/datum/config_entry/number/organ_regeneration_multiplier
	config_entry_value = 0.25
	integer = FALSE

//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
//so that it's similar to PAIN. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
/datum/config_entry/number/organ_damage_spillover_multiplier
	config_entry_value = 0.5
	integer = FALSE

/datum/config_entry/flag/bones_can_break

/datum/config_entry/flag/limbs_can_break

/datum/config_entry/flag/revival_pod_plants

/datum/config_entry/flag/revival_cloning

/datum/config_entry/number/revival_brain_life
    config_entry_value = -1
    integer = FALSE

/datum/config_entry/flag/use_loyalty_implants

/datum/config_entry/flag/welder_vision

/datum/config_entry/flag/generate_map

/datum/config_entry/flag/no_click_cooldown

//Used for modifying movement speed for mobs.
//Unversal modifiers

/datum/config_entry/number/run_speed
	config_entry_value = 2

/datum/config_entry/number/walk_speed
	config_entry_value = 1

//Mob specific modifiers. NOTE: These will affect different mob types in different ways

/datum/config_entry/number/human_delay

/datum/config_entry/number/robot_delay

/datum/config_entry/number/monkey_delay

/datum/config_entry/number/alien_delay

/datum/config_entry/number/slime_delay

/datum/config_entry/number/animal_delay

/datum/config_entry/number/maximum_mushrooms    //After this amount alive, mushrooms will not boom boom
	config_entry_value = 15

/datum/config_entry/flag/admin_legacy_system    //Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt

/datum/config_entry/flag/ban_legacy_system  //Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt

/datum/config_entry/flag/use_age_restriction_for_jobs   //Do jobs use account age restrictions?   --requires database

/datum/config_entry/flag/use_age_restriction_for_antags //Do antags use account age restrictions? --requires database

/datum/config_entry/number/simultaneous_pm_warning_timeout
    config_entry_value = 100

/datum/config_entry/flag/use_recursive_explosions    //Defines whether the server uses recursive or circular explosions.

/datum/config_entry/flag/assistant_maint    //Do assistants get maint access?

/datum/config_entry/number/gateway_delay    //How long the gateway takes before it activates. Default is half an hour.
	config_entry_value = 18000

/datum/config_entry/flag/ghost_interaction

/datum/config_entry/string/comms_password

/datum/config_entry/flag/ban_comms_password

/datum/config_entry/string/login_export_addr

/datum/config_entry/flag/enter_allowed
	config_entry_value = TRUE

/datum/config_entry/number/player_limit

/datum/config_entry/flag/always_admit_patrons   //Allow patrons to bypass player limit, if one is set

/datum/config_entry/flag/use_irc_bot

/datum/config_entry/string/irc_bot_host

/datum/config_entry/string/main_irc

/datum/config_entry/string/admin_irc

/datum/config_entry/flag/announce_shuttle_dock_to_irc