GLOBAL_LIST_INIT(organ_parents, list(BP_L_FOOT = BP_L_LEG,
BP_R_FOOT = BP_R_LEG,
BP_R_LEG = BP_GROIN,
BP_L_LEG = BP_GROIN,
BP_TAIL = BP_GROIN,
BP_GROIN = BP_CHEST,
BP_HEAD = BP_CHEST,
BP_L_ARM = BP_CHEST,
BP_R_ARM = BP_CHEST,
BP_L_HAND = BP_L_ARM,
BP_R_HAND = BP_R_ARM,
BP_EYES = BP_HEAD,
BP_MOUTH = BP_HEAD))

//This list is used for firing guns when not targeting a human mob.
//The altitude of the projectile is chosen from this list, which represents average altitudes of a normal human
//When a specific human is targeted, the heights will be taken from that mob's species datum instead, so this list is only a fallback
//All heights are in metres
GLOBAL_LIST_INIT(organ_altitudes, list(BP_L_FOOT = 0.05,
BP_R_FOOT = 0.05,
BP_R_LEG = 0.75,
BP_L_LEG = 0.75,
BP_TAIL = 0.75,
BP_GROIN = 1.1,
BP_CHEST = 1.5,
BP_HEAD = 1.7,
BP_L_ARM = 1.35,
BP_R_ARM = 1.35,
BP_L_HAND = 0.85,
BP_R_HAND = 0.85,
BP_EYES = 1.7,
BP_MOUTH = 1.7,))

GLOBAL_LIST_INIT(key_to_mob, list())

GLOBAL_LIST_INIT(players, list())

GLOBAL_LIST_EMPTY(clients)   //all clients
GLOBAL_LIST_EMPTY(admins)    //all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(ckey_directory) //all ckeys with associated client


GLOBAL_LIST_EMPTY(player_list)      //List of all mobs **with clients attached**. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(human_mob_list)   //List of all human mobs and sub-types, including clientless
GLOBAL_LIST_EMPTY(silicon_mob_list) //List of all silicon mobs, including clientless
GLOBAL_LIST_EMPTY(living_mob_list) //List of all alive mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(dead_mob_list)   //List of all dead mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(ghost_mob_list)   //List of all ghosts, including clientless. Excludes /mob/new_player


GLOBAL_LIST_EMPTY(limb_masks)	//List of combined icon files for masking out sections of clothes where the wearer is missing that limb