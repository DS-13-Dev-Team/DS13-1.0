/datum/technology/illegal
	name = "Binary Encrpytion Key"
	desc = "Binary Encrpytion Key"
	id = "binary_encryption_key"
	tech_type = TECH_ILLEGAL

	x = 0.1
	y = 0.5
	icon = "headset"

	required_technologies = list()
	required_tech_levels = list(TECH_BLUESPACE = 5)
	cost = 2000

	unlocks_designs = list()

/datum/technology/illegal/chameleon_kit
	name = "Chameleon Kit"
	desc = "Chameleon Kit"
	id = "chameleon_kit"

	x = 0.3
	y = 0.5
	icon = "chamelion"

	required_technologies = list("binary_encryption_key")
	required_tech_levels = list(TECH_ENGINEERING = 10)
	cost = 3000

	unlocks_designs = list()

/datum/technology/illegal/freedom_implant
	name = "Glass Case- 'Freedom'"
	desc = "Glass Case- 'Freedom'"
	id = "freedom_implant"

	x = 0.5
	y = 0.5
	icon = "freedom"

	required_technologies = list("chameleon_kit")
	required_tech_levels = list(TECH_BIO = 5)
	cost = 3000

	unlocks_designs = list()

/datum/technology/illegal/tyrant_aimodule
	name = "AI Core Module (T.Y.R.A.N.T.)"
	desc = "AI Core Module (T.Y.R.A.N.T.)"
	id = "tyrant_aimodule"

	x = 0.7
	y = 0.5
	icon = "module"

	required_technologies = list("freedom_implant")
	required_tech_levels = list(TECH_ROBOT = 5)
	cost = 3000

	unlocks_designs = list()

/datum/technology/illegal/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Borg Illegal Weapons Upgrade"
	id = "borg_syndicate_module"

	x = 0.9
	y = 0.5
	icon = "borgmodule"

	required_technologies = list("tyrant_aimodule")
	required_tech_levels = list(TECH_ROBOT = 10)
	cost = 5000

	unlocks_designs = list()
