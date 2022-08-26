/datum/technology/combat
	tech_type = TECH_COMBAT
	icon = 'icons/obj/ammo.dmi'

/datum/technology/combat/security
	name = "Security Equipment"
	desc = "Basic shitcurity kit"
	id = "sec_eq"

	x = 2
	y = 5
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stunbaton_active"

	required_technologies = list()
	cost = 0

	unlocks_designs = list("stunbaton", "handcuffs")

/datum/technology/combat/pris_man
	name = "Prisoner Managment"
	desc = "Make sure prisoners won't escape from Alcatraz"
	id = "pris_man"

	x = 2
	y = 3.5
	//special way to generate an icon

	required_technologies = list("sec_eq")
	cost = 250

	unlocks_designs = list("prisonmanage")

/datum/technology/combat/pris_man/generate_icon()
	var/icon/ret = icon('icons/obj/computer.dmi', "computer")
	ret.Blend(icon('icons/obj/computer.dmi', "explosive"), ICON_OVERLAY)
	ret.Blend(icon('icons/obj/computer.dmi', "security_key"), ICON_OVERLAY)
	return ret

/datum/technology/combat/add_eq
	name = "Additional Security Equipment"
	desc = "I am the law!"
	id = "add_eq"

	x = 4
	y = 5
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "securityhud"

	required_technologies = list("sec_eq")
	cost = 500

	unlocks_designs = list("security_hud", "megaphone")

/datum/technology/combat/nleth_eq
	name = "Non-lethal Eqiupment"
	desc = "Taser and flash for your RIG"
	id = "nleth_eq"

	x = 6
	y = 5
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "taser"

	required_technologies = list("add_eq")
	cost = 750

	unlocks_designs = list("rig_flash", "rig_taser")

/datum/technology/combat/recharger
	name = "Recharger"
	desc = "Finally a way to recharge your... Uh... RIG cell?"
	id = "recharger"

	x = 8
	y = 5
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "recharger0"

	required_technologies = list("nleth_eq", "sup_power")
	cost = 1250

	unlocks_designs = list("recharger")

/datum/technology/combat/shield
	name = "Advanced Combat"
	desc = "SWAT "
	id = "shield"

	x = 8
	y = 6.5
	icon = 'icons/obj/weapons.dmi'
	icon_state = "advanced"

	required_technologies = list("recharger")
	cost = 1000

	unlocks_designs = list("advancedcombatshield", "tactical_goggles")

/datum/technology/combat/divet
	name = "Winchester NK Divet Pistol"
	desc = "Winchester NK Divet Pistol"
	id = "divet"

	x = 10
	y = 5
	icon = 'icons/obj/gun.dmi'
	icon_state = "divet"

	required_technologies = list("recharger")
	cost = 1500

	unlocks_designs = list("divet", "divetslug")

/datum/technology/combat/speedloader
	name = "Speed Loader (.44 Magnum)"
	desc = "Speed Loader (.44 Magnum)"
	id = "speedloader"

	x = 10
	y = 3.5
	icon_state = "38"

	required_technologies = list("divet")
	cost = 750

	unlocks_designs = list("speedloader")

/datum/technology/combat/pulse
	name = "SWS Motorized Pulse Rifle"
	desc = "SWS Motorized Pulse Rifle"
	id = "pulse"

	x = 12
	y = 5
	icon_state = "pulse_rounds"

	required_technologies = list("divet")
	cost = 2500

	unlocks_designs = list("pulserifle", "pulseslug")

/datum/technology/combat/pulsehv
	name = "High Velocity Pulse Rounds"
	desc = "High Velocity Pulse Rounds"
	id = "pulsehv"

	x = 12
	y = 3.5
	icon_state = "pulse_rounds_hv"

	required_technologies = list("pulse")
	cost = 1500

	unlocks_designs = list("pulsehighvel")

/datum/technology/combat/ripper
	name = "RC-DS Remote Control Disc Ripper"
	desc = "RC-DS Remote Control Disc Ripper"
	id = "ripper"

	x = 12
	y = 6.5
	icon = 'icons/obj/gun.dmi'
	icon_state = "ripper"

	required_technologies = list("pulse")
	cost = 1500

	unlocks_designs = list("ripper", "ripper_blades")

/datum/technology/combat/dblades
	name = "Diamond Blades"
	desc = "Diamond Blades"
	id = "dblades"

	x = 14
	y = 6.5
	icon_state = "diamondblade"

	required_technologies = list("ripper")
	cost = 750

	unlocks_designs = list("diamond_blades")

/datum/technology/combat/javeline
	name = "T15 Javelin Gun"
	desc = "T15 Javelin Gun"
	id = "javeline"

	x = 14
	y = 3.5
	icon_state = "javelin-6"

	required_technologies = list("pulse")
	cost = 2000

	unlocks_designs = list("javgun", "javelin_rack")

/datum/technology/combat/seeker
	name = "Seeker Rifle"
	desc = "Seeker Rifle"
	id = "seeker"

	x = 16
	y = 5
	icon_state = "seekerclip"

	required_technologies = list("pulse")
	cost = 3500

	unlocks_designs = list("seeker", "seeker_ammo")

/datum/technology/combat/seeker/generate_icon()
	var/icon/ret = ..()
	ret.Blend(icon('icons/obj/ammo.dmi', "sc-5"), ICON_OVERLAY)
	return ret
