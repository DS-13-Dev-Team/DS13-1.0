/*
	Slasher variant, the most common necromorph. Has an additional pair of arms with scything blades on the end
*/
/datum/species/necromorph/slasher
	name = "Slasher"
	name_plural =  "Slashers"
	blurb = "The Slasher is created from a single human corpse, and is one of the more common Necromorphs encountered in a typical outbreak\
	. The Slasher is named for its specialized arms, which sport sharp blade-like protrusions of bone."
	unarmed_types = list(/datum/unarmed_attack/blades)
	total_health = 80


/datum/species/necromorph/slasher/enhanced
	unarmed_types = list(/datum/unarmed_attack/blades/strong)
	total_health = 200

/datum/unarmed_attack/blades
	attack_verb = list("slashed", "scythed", "cleaved")
	attack_noun = list("blades")
	eye_attack_text = "impales"
	eye_attack_text_victim = "blade"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = TRUE
	edge = TRUE
	shredding = TRUE
	damage = 12
	delay = 10

/datum/unarmed_attack/blades/strong
	damage = 18
	delay = 8