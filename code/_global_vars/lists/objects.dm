GLOBAL_LIST_EMPTY(active_diseases)
GLOBAL_LIST_EMPTY(med_hud_users)          // List of all entities using a medical HUD.
GLOBAL_LIST_EMPTY(sec_hud_users)          // List of all entities using a security HUD.
GLOBAL_LIST_EMPTY(hud_icon_reference)

GLOBAL_LIST_EMPTY(listening_objects) // List of objects that need to be able to hear, used to avoid recursive searching through contents.

GLOBAL_LIST_EMPTY(global_mutations) // List of hidden mutation things.

GLOBAL_LIST_EMPTY(reg_dna)

GLOBAL_LIST_EMPTY(global_map)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it. Also headset, for things that should be affected by comms outages.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/radio/announcer, new)
GLOBAL_DATUM_INIT(global_headset, /obj/item/radio/announcer/subspace, new)

GLOBAL_DATUM_INIT(sun, /datum/sun, new)
GLOBAL_DATUM_INIT(universe, /datum/universal_state, new)

GLOBAL_LIST_INIT(full_alphabet, list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"))

//This list contains the iconic (ie default, baseline, most well-known) tool for each tool quality.
//It is primarily used to display icons for recipes
//GLOBAL_LIST_INIT(iconic_tools, list(QUALITY_BOLT_TURNING = /obj/item/tool/wrench,QUALITY_PULSING = /obj/item/tool/multitool,QUALITY_PRYING = /obj/item/tool/crowbar,QUALITY_WELDING = /obj/item/tool/weldingtool,QUALITY_SCREW_DRIVING = /obj/item/tool/screwdriver,QUALITY_WIRE_CUTTING =  /obj/item/tool/wirecutters,QUALITY_CLAMPING =  /obj/item/tool/hemostat,QUALITY_CAUTERIZING = /obj/item/tool/cautery,QUALITY_RETRACTING = /obj/item/tool/retractor,QUALITY_DRILLING = /obj/item/tool/surgicaldrill,QUALITY_SAWING = /obj/item/tool/saw,QUALITY_BONE_SETTING = /obj/item/tool/bonesetter,QUALITY_SHOVELING = /obj/item/tool/shovel,QUALITY_DIGGING = /obj/item/tool/pickaxe.QUALITY_EXCAVATION = /obj/item/tool/pickaxe/excavation,QUALITY_CUTTING = /obj/item/material/knife,QUALITY_LASER_CUTTING = /obj/item/tool/scalpel/laser,//laser scalpels and e-swords - bloodless cuttingQUALITY_ADHESIVE = /obj/item/tool/tape_roll,QUALITY_SEALING = /obj/item/tool/tape_roll,QUALITY_WORKBENCH = /obj/item/tool/tape_roll))
GLOBAL_LIST_INIT(iconic_tools, list(QUALITY_BOLT_TURNING = /obj/item/tool/wrench,
QUALITY_PULSING = /obj/item/tool/multitool,
QUALITY_PRYING = /obj/item/tool/crowbar,
QUALITY_WELDING = /obj/item/tool/weldingtool,
QUALITY_SCREW_DRIVING = /obj/item/tool/screwdriver,
QUALITY_WIRE_CUTTING =  /obj/item/tool/wirecutters,
QUALITY_CLAMPING =  /obj/item/tool/hemostat,
QUALITY_CAUTERIZING = /obj/item/tool/cautery,
QUALITY_RETRACTING = /obj/item/tool/retractor,
QUALITY_DRILLING = /obj/item/tool/surgicaldrill,
QUALITY_SAWING = /obj/item/tool/saw,
QUALITY_BONE_SETTING = /obj/item/tool/bonesetter,
QUALITY_SHOVELING = /obj/item/tool/shovel,
QUALITY_DIGGING = /obj/item/tool/pickaxe,
QUALITY_EXCAVATION = /obj/item/tool/pickaxe/excavation,
QUALITY_CUTTING = /obj/item/material/knife,
QUALITY_LASER_CUTTING = /obj/item/tool/scalpel/laser,//laser scalpels and e-swords - bloodless cutting
QUALITY_ADHESIVE = /obj/item/tool/tape_roll,
QUALITY_SEALING = /obj/item/tool/tape_roll,
QUALITY_WORKBENCH = /obj/structure/workbench))




//If a human has a species which doesn't let them pickup items, things in this list can be picked up anyway
GLOBAL_LIST_INIT(pickup_whitelist,list(/obj/item/grab))


//A list of limbs, and the inventory slot which is most often associated with them. Only one slot per limb.
//Not every slot or limb is represented here
GLOBAL_LIST_INIT(limb_to_slot, list(BP_L_HAND = slot_l_hand,
BP_L_ARM = slot_l_hand,
BP_R_HAND = slot_r_hand,
BP_R_ARM = slot_r_hand))

GLOBAL_LIST_INIT(bpl_growth_organs, list(
"Heart" = list("type" = /obj/item/organ/internal/heart, "icon" = "heart", "name" = "Heart", "stemcells"  = 5),
"Eyes" = list("type" = /obj/item/organ/internal/eyes, "icon" = "eyes", "name" = "Eyes", "stemcells"  = 5),
"Brain" = list("type" = /obj/item/organ/internal/brain, "icon" = "brain", "name" = "Brain", "stemcells"  = 5),
"Kidneys" = list("type" = /obj/item/organ/internal/kidneys, "icon" = "kidneys_shrunk", "name" = "Kidneys", "stemcells"  = 5),
"Lungs" = list("type" = /obj/item/organ/internal/lungs, "icon" = "lungs_shrunk", "name" = "Lungs", "stemcells"  = 5),
"Liver" = list("type" = /obj/item/organ/internal/liver, "icon" = "liver", "name" = "Liver", "stemcells"  = 5),
"Stem Cells" = list("type" = /obj/item/organ/fetus, "icon" = "thing", "name" = "Stem Cells", "stemcells"  = 0),
"Head" = list("type" = /obj/item/organ/external/head, "icon" = "head", "name" = "Head", "stemcells" = 15),
"Arm" = list("type" = list("Left Arm" = /obj/item/organ/external/arm/full, "Right Arm" = /obj/item/organ/external/arm/right/full), "icon" = "arm", "name" = "Arm", "stemcells"  = 10),
"Leg" = list("type" = list("Left Leg" = /obj/item/organ/external/leg/full, "Right Leg" = /obj/item/organ/external/leg/right/full), "icon" = "leg", "name" = "Leg", "stemcells"  = 10)
))


GLOBAL_LIST_INIT(click_catchers, list())

//Holds loadout gear datum singletons
GLOBAL_LIST_EMPTY(gear_datums)

GLOBAL_LIST_EMPTY(rnd_server_list)

// Used to update tracking level for all vitals monitors that are set to automatic mode when alert changes
GLOBAL_LIST_EMPTY(vitals_auto_update_tracking)

/// List of wire colors for each object type of that round. One for airlocks, one for vendors, etc.
GLOBAL_LIST_EMPTY(wire_color_directory) // This is an associative list with the `holder_type` as the key, and a list of colors as the value.
