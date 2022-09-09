/obj/random/hardsuit
	name = "Random Rig"
	desc = "This is a random rig control module."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"

/obj/random/hardsuit/item_to_spawn()
	return pickweight(list(/obj/item/rig/security,
				/obj/item/rig/engineering,
				/obj/item/rig/mining,
				/obj/item/rig/excavation,
				/obj/item/rig/vintage = 0.2,
				/obj/item/rig/advanced = 0.1, //At 0.5, they are still very common, shouldn't even be "misplaced" anyway.
				/obj/item/rig/patrol = 0.1,
				/obj/item/rig/industrial,
				/obj/item/rig/eva,
				/obj/item/rig/civilian,
				/obj/item/rig/medical = 0.8,
				/obj/item/rig/light/internalaffairs = 0.01,
				/obj/item/rig/ce = 0.01,
				/obj/item/rig/hazmat = 0.01,
				/obj/item/rig/hazard = 0.01
				/obj/item/rig/clown = 0.01))


/obj/random/rig_module
	name = "Random Rig module"
	desc = "This is a random rig control module."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "generic"

/obj/random/rig_module
	possible_spawns = list(/obj/item/rig_module/kinesis = 2,
	/obj/item/rig_module/kinesis/advanced = 0.5,
	/obj/item/rig_module/healthbar/advanced = 1,
	/obj/item/rig_module/storage = 0.75,
	/obj/item/rig_module/storage/heavy = 0.5,
	/obj/item/rig_module/vision = 0.2,
	/obj/item/rig_module/vision/multi = 0.1,
	/obj/item/rig_module/vision/nvg = 0.5,
	/obj/item/rig_module/vision/thermal = 0.2,
	/obj/item/rig_module/chem_dispenser/inaprovaline = 0.5,
	/obj/item/rig_module/chem_dispenser/ninja = 0.2,
	/obj/item/rig_module/voice = 0.5,
	/obj/item/rig_module/maneuvering_jets = 1,
	/obj/item/rig_module/self_destruct = 0.2,
	/obj/item/rig_module/power_sink = 0.5,
	/obj/item/rig_module/grenade_launcher = 0.2,
	/obj/item/rig_module/grenade_launcher/cleaner = 0.5,
	/obj/item/rig_module/grenade_launcher/smoke = 0.5,
	/obj/item/rig_module/grenade_launcher/mfoam = 0.5,
	/obj/item/rig_module/grenade_launcher/light = 0.5,
	/obj/item/rig_module/hotswap = 0.5,
	/obj/item/rig_module/power_sink = 1,
	/obj/item/rig_module/extension/speedboost = 1,
	/obj/item/rig_module/extension/speedboost/advanced = 0.5
	)

/*
	Only contains the good stuff
*/
/obj/random/rig_module/rare
	possible_spawns = list(/obj/item/rig_module/kinesis/advanced = 0.5,
	/obj/item/rig_module/healthbar/advanced = 1,
	/obj/item/rig_module/storage/heavy = 0.5,
	/obj/item/rig_module/vision/thermal = 0.2,
	/obj/item/rig_module/chem_dispenser/inaprovaline = 0.1,
	/obj/item/rig_module/chem_dispenser/ninja = 0.2,
	/obj/item/rig_module/self_destruct = 0.2,
	/obj/item/rig_module/power_sink = 0.5,
	/obj/item/rig_module/grenade_launcher = 0.2,
	/obj/item/rig_module/grenade_launcher/smoke = 0.5,
	/obj/item/rig_module/grenade_launcher/mfoam = 0.5,
	/obj/item/rig_module/extension/speedboost = 1,
	/obj/item/rig_module/extension/speedboost/advanced = 0.5
	)