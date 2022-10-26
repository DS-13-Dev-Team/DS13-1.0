var/global/list/responsive_carriers = list(
	/datum/reagent/carbon,
	/datum/reagent/potassium,
	/datum/reagent/hydrazine,
	"nitrogen",
	/datum/reagent/mercury,
	/datum/reagent/iron,
	"chlorine",
	/datum/reagent/phosphorus,
	/datum/reagent/toxin/phoron)

var/global/list/finds_as_strings = list(
	"Trace organic cells",
	"Long exposure particles",
	"Trace water particles",
	"Crystalline structures",
	"Metallic derivative",
	"Metallic composite",
	"Metamorphic/igneous rock composite",
	"Metamorphic/sedimentary rock composite",
	"Anomalous material")

/proc/get_responsive_reagent(var/find_type)
	switch(find_type)
		if(ARCHAEO_BOWL, ARCHAEO_URN, ARCHAEO_CUTLERY, ARCHAEO_STATUETTE, ARCHAEO_INSTRUMENT, ARCHAEO_HANDCUFFS, ARCHAEO_BEARTRAP, ARCHAEO_BOX, ARCHAEO_GASTANK, ARCHAEO_UNKNOWN)
			return /datum/reagent/mercury
		if(ARCHAEO_COIN, ARCHAEO_KNIFE, ARCHAEO_TOOL, ARCHAEO_METAL, ARCHAEO_CLAYMORE, ARCHAEO_KATANA, ARCHAEO_LASER, ARCHAEO_GUN)
			return /datum/reagent/iron
		if(ARCHAEO_CRYSTAL, ARCHAEO_SOULSTONE)
			return "nitrogen"
		if(ARCHAEO_CULTBLADE, ARCHAEO_TELEBEACON, ARCHAEO_CULTROBES, ARCHAEO_STOCKPARTS)
			return /datum/reagent/potassium
		if(ARCHAEO_FOSSIL, ARCHAEO_SHELL, ARCHAEO_PLANT, ARCHAEO_REMAINS_HUMANOID, ARCHAEO_REMAINS_ROBOT, ARCHAEO_REMAINS_XENO, ARCHAEO_GASMASK)
			return /datum/reagent/carbon
	return /datum/reagent/toxin/phoron

/proc/get_random_digsite_type()
	return pick(100;DIGSITE_GARDEN, 95;DIGSITE_ANIMAL, 90;DIGSITE_HOUSE, 85;DIGSITE_TECHNICAL, 80;DIGSITE_TEMPLE, 75;DIGSITE_WAR)

/proc/get_random_find_type(var/digsite)
	. = 0
	switch(digsite)
		if(DIGSITE_GARDEN)
			. = pick(
			100;ARCHAEO_PLANT,
			25;ARCHAEO_SHELL,
			25;ARCHAEO_FOSSIL,
			5;ARCHAEO_BEARTRAP)
		if(DIGSITE_ANIMAL)
			. = pick(
			100;ARCHAEO_FOSSIL,
			50;ARCHAEO_SHELL,
			50;ARCHAEO_PLANT,
			25;ARCHAEO_BEARTRAP)
		if(DIGSITE_HOUSE)
			. = pick(
			100;ARCHAEO_BOWL,
			100;ARCHAEO_URN,
			100;ARCHAEO_CUTLERY,
			50;ARCHAEO_STATUETTE,
			100;ARCHAEO_INSTRUMENT,
			100;ARCHAEO_BOX,
			75;ARCHAEO_GASMASK,
			75;ARCHAEO_COIN,
			75;ARCHAEO_UNKNOWN,
			25;ARCHAEO_METAL)
		if(DIGSITE_TECHNICAL)
			. = pick(
			125;ARCHAEO_GASMASK,
			100;ARCHAEO_METAL,
			100;ARCHAEO_GASTANK,
			100;ARCHAEO_TELEBEACON,
			100;ARCHAEO_TOOL,
			100;ARCHAEO_STOCKPARTS,
			75;ARCHAEO_UNKNOWN,
			50;ARCHAEO_HANDCUFFS,
			50;ARCHAEO_BEARTRAP)
		if(DIGSITE_TEMPLE)
			. = pick(
			200;ARCHAEO_CULTROBES,
			200;ARCHAEO_STATUETTE,
			100;ARCHAEO_URN,
			100;ARCHAEO_BOWL,
			10;ARCHAEO_KNIFE,
			100;ARCHAEO_CRYSTAL,
			75;ARCHAEO_CULTBLADE,
			50;ARCHAEO_UNKNOWN,
			25;ARCHAEO_HANDCUFFS,
			25;ARCHAEO_BEARTRAP,
			2;ARCHAEO_KATANA,
			2;ARCHAEO_CLAYMORE,
			10;ARCHAEO_METAL,
			10;ARCHAEO_GASMASK)
		if(DIGSITE_WAR)
			. = pick(
			15;ARCHAEO_GUN,
			15;ARCHAEO_KNIFE,
			2;ARCHAEO_LASER,
			15;ARCHAEO_KATANA,
			15;ARCHAEO_CLAYMORE,
			50;ARCHAEO_UNKNOWN,
			50;ARCHAEO_CULTROBES,
			50;ARCHAEO_CULTBLADE,
			50;ARCHAEO_GASMASK,
			25;ARCHAEO_BEARTRAP,
			25;ARCHAEO_TOOL)
