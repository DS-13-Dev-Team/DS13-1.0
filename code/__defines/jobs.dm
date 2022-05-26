#define JOBS_SECURITY /datum/job/cseco, /datum/job/sso, /datum/job/security_officer
#define JOBS_COMMAND /datum/job/cap, /datum/job/fl, /datum/job/cscio, /datum/job/dom

#define ENG (1<<0)
#define SEC (1<<1)
#define MED (1<<2)
#define SCI (1<<3)
#define CIV (1<<4)
#define COM (1<<5)
#define MSC (1<<6)
#define SRV (1<<7)
#define SUP (1<<8)
#define SPT (1<<9)
#define MIN (1<<10)

GLOBAL_LIST_EMPTY(assistant_occupations)

GLOBAL_LIST_EMPTY(command_positions)

GLOBAL_LIST_EMPTY(engineering_positions)

GLOBAL_LIST_EMPTY(medical_positions)

GLOBAL_LIST_EMPTY(science_positions)

GLOBAL_LIST_EMPTY(civilian_positions)

GLOBAL_LIST_EMPTY(security_positions)

GLOBAL_LIST_INIT(nonhuman_positions, list("pAI"))

GLOBAL_LIST_EMPTY(service_positions)

GLOBAL_LIST_EMPTY(supply_positions)

GLOBAL_LIST_EMPTY(support_positions)

GLOBAL_LIST_EMPTY(mining_positions)

GLOBAL_LIST_EMPTY(unsorted_positions) // for nano manifest
