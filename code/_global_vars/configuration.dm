GLOBAL_REAL(config, /datum/controller/configuration)

GLOBAL_DATUM(revdata, /datum/getrev)

// Bomb cap!
GLOBAL_VAR_INIT(max_explosion_range, 14)


var/href_logfile		= null
var/game_version		= "Baystation12"
GLOBAL_VAR_INIT(changelog_hash, "")
var/game_year		   = (text2num(time2text(world.realtime, "YYYY")) + 544)

GLOBAL_VAR_INIT(master_mode, "containment")// "extended"
var/secondary_mode	= "extended"
var/tertiary_mode	 = "extended"
var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/Debug2 = 0

var/gravity_is_on = 1
var/round_progressing = 1

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

GLOBAL_VAR_INIT(visibility_pref, FALSE)