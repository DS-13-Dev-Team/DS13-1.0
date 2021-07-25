/datum/technology/combat
	name = "Security Equipment"
	desc = "Security Equipment"
	id = "sec_eq"
	tech_type = TECH_COMBAT

	x = 0.1
	y = 0.5
	icon = "stunbaton"

	required_technologies = list()
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("stunbaton", "handcuffs")

/datum/technology/combat/pris_man
	name = "Prisoner Managment"
	desc = "Prisoner Managment"
	id = "pris_man"

	x = 0.1
	y = 0.6
	icon = "seccomputer"

	required_technologies = list("sec_eq")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("prisonmanage")

/datum/technology/combat/add_eq
	name = "Additional Security Equipment"
	desc = "Additional Security Equipment"
	id = "add_eq"

	x = 0.2
	y = 0.5
	icon = "add_sec_eq"

	required_technologies = list("sec_eq")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("security_hud", "megaphone")

/datum/technology/combat/nleth_eq
	name = "Non-lethal Eqiupment"
	desc = "Additional Security Equipment"
	id = "nleth_eq"

	x = 0.3
	y = 0.5
	icon = "rigtaser"

	required_technologies = list("add_eq")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("rig_flash", "rig_taser")

/datum/technology/combat/recharger
	name = "Recharger"
	desc = "Recharger"
	id = "recharger"

	x = 0.4
	y = 0.5
	icon = "recharger"

	required_technologies = list("nleth_eq", "sup_power")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("recharger", "force_energy")

/datum/technology/combat/shield
	name = "Advanced Combat Shield"
	desc = "Advanced Combat Shield"
	id = "shield"

	x = 0.4
	y = 0.4
	icon = "shield"

	required_technologies = list("recharger")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("advancedcombatshield")

/datum/technology/combat/divet
	name = "Winchester NK Divet Pistol"
	desc = "Winchester NK Divet Pistol"
	id = "divet"

	x = 0.5
	y = 0.5
	icon = "divet"

	required_technologies = list("recharger")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("divet", "divetslug")

/datum/technology/combat/speedloader
	name = "Speed Loader (.44 Magnum)"
	desc = "Speed Loader (.44 Magnum)"
	id = "speedloader"

	x = 0.5
	y = 0.6
	icon = "speedloader"

	required_technologies = list("divet")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("44cal")

/datum/technology/combat/pulse
	name = "SWS Motorized Pulse Rifle"
	desc = "SWS Motorized Pulse Rifle"
	id = "pulse"

	x = 0.6
	y = 0.5
	icon = "pulse"

	required_technologies = list("divet")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("pulserifle", "pulseslug")

/datum/technology/combat/pulsehv
	name = "High Velocity Pulse Rounds"
	desc = "High Velocity Pulse Rounds"
	id = "pulsehv"

	x = 0.6
	y = 0.6
	icon = "pulsehv"

	required_technologies = list("pulse")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("pulsehighvel")

/datum/technology/combat/ripper
	name = "RC-DS Remote Control Disc Ripper"
	desc = "RC-DS Remote Control Disc Ripper"
	id = "ripper"

	x = 0.6
	y = 0.4
	icon = "ripper"

	required_technologies = list("pulse")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("ripper", "ripper_blades", "diamond_blades")

/datum/technology/combat/javeline
	name = "T15 Javelin Gun"
	desc = "T15 Javelin Gun"
	id = "javeline"

	x = 0.7
	y = 0.6
	icon = "javeline"

	required_technologies = list("pulse")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("javgun")

/datum/technology/combat/seeker
	name = "Seeker Rifle"
	desc = "Seeker Rifle"
	id = "seeker"

	x = 0.8
	y = 0.5
	icon = "seeker"

	required_technologies = list("pulse")
	required_tech_levels = list()
	cost = 0

	unlocks_designs = list("seeker", "seeker_ammo")
