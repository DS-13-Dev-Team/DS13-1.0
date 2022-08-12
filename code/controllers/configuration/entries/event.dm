//Event settings

/datum/config_entry/number/expected_round_length
    config_entry_value = 3 * 60 * 60 * 10 //3 hours

/datum/config_entry/flag/aliens_allowed

/datum/config_entry/flag/alien_eggs_allowed

/datum/config_entry/flag/ninjas_allowed

/datum/config_entry/flag/abandon_allowed

/datum/config_entry/flag/ooc_allowed

/datum/config_entry/flag/ooc_allowed/ValidateAndSet(str_val)
	. = ..()
	if(.)
		config.ooc_allowed = config_entry_value

/datum/config_entry/flag/looc_allowed

/datum/config_entry/flag/looc_allowed/ValidateAndSet(str_val)
	. = ..()
	if(.)
		config.looc_allowed = config_entry_value

/datum/config_entry/flag/dooc_allowed

/datum/config_entry/flag/dooc_allowed/ValidateAndSet(str_val)
	. = ..()
	if(.)
		config.dooc_allowed = config_entry_value

/datum/config_entry/flag/dsay_allowed

/datum/config_entry/flag/dsay_allowed/ValidateAndSet(str_val)
	. = ..()
	if(.)
		config.dsay_allowed = config_entry_value

/datum/config_entry/flag/aooc_allowed

/datum/config_entry/flag/aooc_allowed/ValidateAndSet(str_val)
	. = ..()
	if(.)
		config.aooc_allowed = config_entry_value

/datum/config_entry/number/starlight ///Whether space turfs have ambient light or not

/datum/config_entry/keyed_list/ert_species
	key_mode = KEY_MODE_TYPE
	value_mode = VALUE_MODE_TEXT
	config_entry_value = list(
		SPECIES_HUMAN
	)

/datum/config_entry/string/law_zero
	config_entry_value = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

/datum/config_entry/flag/aggressive_changelog

/datum/config_entry/flag/ghosts_can_possess_animals

/datum/config_entry/flag/delist_when_no_admins

/datum/config_entry/flag/allow_map_switching    //Whether map switching is allowed

/datum/config_entry/number/radiation_decay_rate   //How much radiation is reduced by each tick
    config_entry_value = 1

/datum/config_entry/number/radiation_resistance_multiplier
    config_entry_value = 125
    integer = FALSE

/datum/config_entry/number/radiation_material_resistance_divisor    //A turf's possible radiation resistance is divided by this number, to get the real value.
    config_entry_value = 2

/datum/config_entry/number/radiation_lower_limit    //If the radiation level for a turf would be below this, ignore it.
    config_entry_value = 0.15
    integer = FALSE

/datum/config_entry/number/autostealth    //Staff get automatic stealth after this many minutes

/datum/config_entry/number/error_cooldown   //The "cooldown" time for each occurrence of a unique error
    config_entry_value = 600

/datum/config_entry/number/error_limit  //How many occurrences before the next will silence them
    config_entry_value = 50

/datum/config_entry/number/error_silence_time   //How long a unique error will be silenced for
    config_entry_value = 6000

/datum/config_entry/number/error_msg_delay  //How long to wait between messaging admins about occurrences of a unique error
    config_entry_value = 50

/datum/config_entry/number/max_gear_cost    //Used in chargen for accessory loadout limit. 0 disables loadout, negative allows infinite points.
    config_entry_value = 10