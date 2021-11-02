/client
	parent_type = /datum		// black magic
	preload_rsc = PRELOAD_RSC	// This is 0 so we can set it to an URL once the player logs in and have them download the resources from a different server.
	view = WORLD_VIEW
	var/view_radius = WORLD_VIEW_RANGE
	var/datum/tooltip/tooltips

		////////////////
		//ADMIN THINGS//
		////////////////
	var/datum/admins/holder = null
	var/datum/admins/deadmin_holder = null

		/////////
		//OTHER//
		/////////
	var/datum/preferences/prefs = null
	var/adminobs		= null

	var/adminhelped = 0

	var/staffwarn = null

		///////////////
		//SOUND STUFF//
		///////////////
	var/ambience_playing= null
	var/played			= 0
	var/list/played_lobby_tracks	//List of tracks we've already heard this session. Used to sort-of prevent a user from hearing the same track more than once per round
	var/lobby_trackchange_timer			//Timer handle for queued lobby track change. This must be deleted when the client leaves the lobby

		////////////
		//SECURITY//
		////////////
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1

	var/received_irc_pm = -99999
	var/irc_admin			//IRC admin that spoke with them last.
	var/mute_irc = 0
	var/warned_about_multikeying = 0	// Prevents people from being spammed about multikeying every time their mob changes.

	///Last ping of the client
	var/lastping = 0
	///Average ping of the client
	var/avgping = 0
	///world.time they connected
	var/connection_time
	///world.realtime they connected
	var/connection_realtime
	///world.timeofday they connected
	var/connection_timeofday

		////////////////////////////////////
		//things that require the database//
		////////////////////////////////////
	var/player_age = "Requires database"	//So admins know why it isn't working - Used to determine how old the account is - in days.
	var/related_accounts_ip = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this ip
	var/related_accounts_cid = "Requires database"	//So admins know why it isn't working - Used to determine what other accounts previously logged in from this computer id

	// List of all asset filenames sent to this client by the asset cache, along with their assoicated md5s
	var/list/sent_assets = list()
	/// List of all completed blocking send jobs awaiting acknowledgement by send_asset
	var/list/completed_asset_jobs = list()
	/// Last asset send job id.
	var/last_asset_job = 0
	var/last_completed_asset_job = 0


		////////////
		//MOUSE HANDLING//
		////////////
	var/last_click_atom	//The atom we last clicked, if it was on a turf

	/*-------------------------------
		View Handling
	--------------------------------*/
	var/view_offset_magnitude	//Cached when view offset is set

	var/atom/movable/screen/click_catcher/void = null

	//Static framerate
	fps = 50

	/// our current tab
	var/stat_tab

	/// whether our browser is ready or not yet
	var/statbrowser_ready = FALSE

	/// list of all tabs
	var/list/panel_tabs = list()
	/// list of tabs containing spells and abilities
	var/list/spell_tabs = list()
