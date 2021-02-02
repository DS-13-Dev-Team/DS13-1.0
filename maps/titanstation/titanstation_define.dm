/datum/map/torch
	name = "Sprawl"
	full_name = "Titan Station"
	path = "titanstation"
//	flags = MAP_HAS_BRANCH | MAP_HAS_RANK -- TBD: Lion.

//	admin_levels = list(7,8) -- TBD
//	empty_levels = list(9) -- TBD
//	accessible_z_levels = list("1"=1,"2"=3,"3"=1,"4"=1,"5"=1,"6"=1,"9"=30) -- TBD
	overmap_size = 35
	overmap_event_areas = 34
//	usable_email_tlds = list("torch.ec.scg", "torch.fleet.mil", "freemail.net", "torch.scg") -- For rework.

	allowed_spawns = list("Cryogenic Storage")
	default_spawn = "Cryogenic Storage"

	station_name  = "The Sprawl"
	station_short = "Titan Station"
	dock_name     = "TBD"
	boss_name     = "Government Sector"
	boss_short    = "GovSec"
	company_name  = "Earth Government"
	company_short = "EarthGov"

//	map_admin_faxes = list(
//	) -- TBD

	//These should probably be moved into the evac controller...
	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	evac_controller_type = /datum/evacuation_controller/starship

//	default_law_type = /datum/ai_laws/solgov -- Candidate for removal.
	use_overmap = 0 // Candidate for removal.
	num_exoplanets = 0 // Candidate for removal.

	away_site_budget = 3
	id_hud_icons = 'maps/titanstation/icons/assignment_hud.dmi'
