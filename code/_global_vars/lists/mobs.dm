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