/obj/effect/landmark
	name = "landmark"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = TURF_LAYER
	unacidable = 1
	simulated = 0
	invisibility = INVISIBILITY_ABSTRACT
	var/delete_me = 0

/obj/effect/landmark/New()
	..()
	tag = "landmark*[name]"

	//TODO clean up this mess
	switch(name)			//some of these are probably obsolete
		if("monkey")
			GLOB.monkeystart += loc
			delete_me = 1
			return
		if("start")
			GLOB.newplayer_start += loc
			delete_me = 1
			return
		if("JoinLate")
			GLOB.latejoin += loc
			delete_me = 1
			return
		if("JoinLateDorm")
			GLOB.latejoin_dorm += loc
			delete_me = 1
			return
		if("JoinLateGateway")
			GLOB.latejoin_gateway += loc
			delete_me = 1
			return
		if("JoinLateCryo")
			GLOB.latejoin_cryo += loc
			delete_me = 1
			return
		if("JoinLateCyborg")
			GLOB.latejoin_cyborg += loc
			delete_me = 1
			return
		if("prisonwarp")
			GLOB.prisonwarp += loc
			delete_me = 1
			return
		if("tdome1")
			GLOB.tdome1 += loc
		if("tdome2")
			GLOB.tdome2 += loc
		if("tdomeadmin")
			GLOB.tdomeadmin += loc
		if("tdomeobserve")
			GLOB.tdomeobserve += loc
		if("prisonsecuritywarp")
			GLOB.prisonsecuritywarp += loc
			delete_me = 1
			return
		if("endgame_exit")
			endgame_safespawns += loc
			delete_me = 1
			return
		if("bluespacerift")
			endgame_exits += loc
			delete_me = 1
			return
		if("ShuttleRepairPart")
			GLOB.shuttlerepairspawnlocs += loc
			delete_me = 1
			return

	landmarks_list += src
	return 1

/obj/effect/landmark/proc/delete()
	delete_me = 1

/obj/effect/landmark/Initialize()
	. = ..()
	if(delete_me)
		return INITIALIZE_HINT_QDEL

/obj/effect/landmark/Destroy()
	landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x"
	anchored = 1.0
	invisibility = 101

/obj/effect/landmark/start/New()
	..()
	tag = "start*[name]"
	return 1

//Costume spawner landmarks
/obj/effect/landmark/costume/New() //costume spawner, selects a random subclass and disappears
	.=..()
	var/list/options = typesof(/obj/effect/landmark/costume)
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	delete_me = 1

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chameleon/New()
	.=..()
	new /obj/item/clothing/mask/chameleon(src.loc)
	new /obj/item/clothing/under/chameleon(src.loc)
	new /obj/item/clothing/glasses/chameleon(src.loc)
	new /obj/item/clothing/shoes/chameleon(src.loc)
	new /obj/item/clothing/gloves/chameleon(src.loc)
	new /obj/item/clothing/suit/chameleon(src.loc)
	new /obj/item/clothing/head/chameleon(src.loc)
	new /obj/item/storage/backpack/chameleon(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/maid/New()
	.=..()
	new /obj/item/clothing/under/blackskirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/butler/New()
	.=..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/prig/New()
	.=..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/plaguedoctor/New()
	.=..()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/waiter/New()
	.=..()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/apron(src.loc)
	delete_me = 1

/obj/effect/landmark/costume/pirate/New()
	.=..()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/mask/bandana/red)
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	delete_me = 1

#define CORPSE_SPAWNER_RANDOM_NAME       0x0001
#define CORPSE_SPAWNER_CUT_SURVIVAL      0x0002
#define CORPSE_SPAWNER_CUT_ID_PDA        0x0003
#define CORPSE_SPAWNER_PLAIN_HEADSET     0x0004

#define CORPSE_SPAWNER_RANDOM_SKIN_TONE    0x0008
#define CORPSE_SPAWNER_RANDOM_SKIN_COLOR   0x0010
#define CORPSE_SPAWNER_RANDOM_HAIR_COLOR   0x0020
#define CORPSE_SPAWNER_RANDOM_HAIR_STYLE   0x0040
#define CORPSE_SPAWNER_RANDOM_FACIAL_STYLE 0x0080
#define CORPSE_SPAWNER_RANDOM_EYE_COLOR    0x0100
#define CORPSE_SPAWNER_RANDOM_GENDER       0x0200

#define CORPSE_SPAWNER_NO_RANDOMIZATION ~(CORPSE_SPAWNER_RANDOM_NAME|CORPSE_SPAWNER_RANDOM_SKIN_TONE|CORPSE_SPAWNER_RANDOM_SKIN_COLOR|CORPSE_SPAWNER_RANDOM_HAIR_COLOR|CORPSE_SPAWNER_RANDOM_HAIR_STYLE|CORPSE_SPAWNER_RANDOM_FACIAL_STYLE|CORPSE_SPAWNER_RANDOM_EYE_COLOR)

//Corpses
/obj/effect/landmark/corpse
	name = "Unknown"
	var/species = list(SPECIES_HUMAN)                 // List of species to pick from.
	var/corpse_outfits = list(/decl/hierarchy/outfit) // List of outfits to pick from. Uses pickweight()
	var/spawn_flags = (~0)

	var/skin_colors_per_species   = list() // Custom skin colors, per species -type-, if any. For example if you want dead Tajaran to always have brown fur, or similar
	var/skin_tones_per_species    = list() // Custom skin tones, per species -type-, if any. See above as to why.
	var/eye_colors_per_species    = list() // Custom eye colors, per species -type-, if any. See above as to why.
	var/hair_colors_per_species   = list() // Custom hair colors, per species -type-, if any. See above as to why.
	var/hair_styles_per_species   = list() // Custom hair styles, per species -type-, if any. For example if you want a punk gang with handlebars.
	var/facial_styles_per_species = list() // Custom facial hair styles, per species -type-, if any. See above as to why
	var/genders_per_species       = list() // For gender biases per species -type-

/obj/effect/landmark/corpse/Initialize()
	..()

	var/mob/living/carbon/human/M = new /mob/living/carbon/human(loc)

	randomize_appearance(M)
	equip_outfit(M)

	M.adjustOxyLoss(M.max_health)//cease life functions
	M.setBrainLoss(M.max_health)
	var/obj/item/organ/internal/heart/corpse_heart = M.internal_organs_by_name[BP_HEART]
	if (corpse_heart)
		corpse_heart.pulse = PULSE_NONE//actually stops heart to make worried explorers not care too much
	M.update_dna()
	M.update_icon()

	return INITIALIZE_HINT_QDEL

#define HEX_COLOR_TO_RGB_ARGS(X) arglist(GetHexColors(X))
/obj/effect/landmark/corpse/proc/randomize_appearance(var/mob/living/carbon/human/M)
	M.set_species(pickweight(species))

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_GENDER))
		if(M.species.type in genders_per_species)
			M.change_gender(pickweight(genders_per_species[M.species.type]))
		else
			M.randomize_gender()

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_SKIN_TONE))
		if(M.species.type in skin_tones_per_species)
			M.change_skin_tone(pickweight(skin_tones_per_species[M.species.type]))
		else
			M.randomize_skin_tone()

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_SKIN_COLOR))
		if(M.species.type in skin_colors_per_species)
			M.change_skin_color(HEX_COLOR_TO_RGB_ARGS(pickweight(skin_colors_per_species[M.species.type])))
		else
			M.s_tone = random_skin_tone(M.species)

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_HAIR_COLOR))
		if(M.species.type in hair_colors_per_species)
			M.change_hair_color(HEX_COLOR_TO_RGB_ARGS(pickweight(hair_colors_per_species[M.species.type])))
		else
			M.randomize_hair_color()
		M.change_facial_hair_color(M.r_hair, M.g_hair, M.b_hair)

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_HAIR_STYLE))
		if(M.species.type in hair_styles_per_species)
			M.change_hair(pickweight(hair_styles_per_species[M.species.type]))
		else
			M.randomize_hair_style()

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_FACIAL_STYLE))
		if(M.species.type in facial_styles_per_species)
			M.change_facial_hair(pickweight(facial_styles_per_species[M.species.type]))
		else
			M.randomize_facial_hair_style()

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_EYE_COLOR))
		if(M.species.type in eye_colors_per_species)
			M.change_eye_color(HEX_COLOR_TO_RGB_ARGS(pickweight(eye_colors_per_species[M.species.type])))
		else
			M.randomize_eye_color()

	M.SetName((CORPSE_SPAWNER_RANDOM_NAME & spawn_flags) ? M.species.get_random_name(M.gender) : name)
	M.real_name = M.name

#undef HEX_COLOR_TO_RGB_ARGS

/obj/effect/landmark/corpse/proc/equip_outfit(var/mob/living/carbon/human/M)
	var/adjustments = 0
	adjustments = (spawn_flags & CORPSE_SPAWNER_CUT_SURVIVAL)  ? (adjustments|OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR) : adjustments
	adjustments = (spawn_flags & CORPSE_SPAWNER_CUT_ID_PDA)    ? (adjustments|OUTFIT_ADJUSTMENT_SKIP_ID_PDA)        : adjustments
	adjustments = (spawn_flags & CORPSE_SPAWNER_PLAIN_HEADSET) ? (adjustments|OUTFIT_ADJUSTMENT_PLAIN_HEADSET)      : adjustments

	var/decl/hierarchy/outfit/corpse_outfit = outfit_by_type(pickweight(corpse_outfits))
	if(corpse_outfit)
		corpse_outfit.equip(M, equip_adjustments = adjustments)

//Subtypes

/obj/effect/landmark/corpse/pirate
	name = "Pirate"
	corpse_outfits = list(/decl/hierarchy/outfit/pirate/norm)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION

/obj/effect/landmark/corpse/pirate/ranged
	name = "Pirate Gunner"
	corpse_outfits = list(/decl/hierarchy/outfit/pirate/space)

/obj/effect/landmark/corpse/russian
	name = "Russian"
	corpse_outfits = list(/decl/hierarchy/outfit/soviet_soldier)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION

/obj/effect/landmark/corpse/russian/ranged
	corpse_outfits = list(/decl/hierarchy/outfit/soviet_soldier)

/obj/effect/landmark/corpse/syndicate
	name = "Syndicate Operative"
	corpse_outfits = list(/decl/hierarchy/outfit/mercenary/syndicate)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION

/obj/effect/landmark/corpse/syndicate/commando
	name = "Syndicate Commando"
	corpse_outfits = list(/decl/hierarchy/outfit/mercenary/syndicate/commando)

/obj/effect/landmark/corpse/miner
	name = "Miner"
	corpse_outfits = /decl/hierarchy/outfit/job/mining/planet_cracker

/obj/effect/landmark/corpse/marooned_officer
	name = "Horazy Warda"
	corpse_outfits = list(/decl/hierarchy/outfit/marooned_officer)
	spawn_flags = ~CORPSE_SPAWNER_RANDOM_NAME

/decl/hierarchy/outfit/marooned_officer
	name = "Dead Magnitka's fleet officer"
	uniform = /obj/item/clothing/under/magintka_uniform
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat
	shoes = /obj/item/clothing/shoes/jungleboots
	gloves = /obj/item/clothing/gloves/thick
	head = /obj/item/clothing/head/beret
	l_pocket = /obj/item/material/butterfly/switchblade

/obj/item/clothing/under/magintka_uniform
	name = "officer uniform"
	desc = "A dark uniform coat worn by Magnitka fleet officers."
	icon_state = "magnitka_officer"
	icon = 'icons/obj/clothing/marooned_icons.dmi'
	item_icons = list(slot_w_uniform_str = 'icons/obj/clothing/marooned_icons.dmi')

#undef CORPSE_SPAWNER_RANDOM_NAME
#undef CORPSE_SPAWNER_CUT_SURVIVAL
#undef CORPSE_SPAWNER_CUT_ID_PDA
#undef CORPSE_SPAWNER_PLAIN_HEADSET

#undef CORPSE_SPAWNER_RANDOM_SKIN_TONE
#undef CORPSE_SPAWNER_RANDOM_SKIN_COLOR
#undef CORPSE_SPAWNER_RANDOM_HAIR_COLOR
#undef CORPSE_SPAWNER_RANDOM_HAIR_STYLE
#undef CORPSE_SPAWNER_RANDOM_FACIAL_STYLE
#undef CORPSE_SPAWNER_RANDOM_EYE_COLOR
#undef CORPSE_SPAWNER_RANDOM_GENDER

#undef CORPSE_SPAWNER_NO_RANDOMIZATION
