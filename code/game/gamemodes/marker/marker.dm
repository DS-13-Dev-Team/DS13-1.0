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