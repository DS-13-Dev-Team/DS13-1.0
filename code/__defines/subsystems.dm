//! ## DB defines
/**
 * DB major schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MAJOR_VERSION 5

/**
 * DB minor schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MINOR_VERSION 22

//Timing subsystem
//Don't run if there is an identical unique timer active
//if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer, and returns the id of the existing timer
#define TIMER_UNIQUE		0x1

//For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE		0x2

//Timing should be based on how timing progresses on clients, not the sever.
//	tracking this is more expensive,
//	should only be used in conjuction with things that have to progress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME   0x4

//Timer can be stopped using deltimer()
#define TIMER_STOPPABLE     0x8
//To be used with TIMER_UNIQUE
//prevents distinguishing identical timers with the wait variable
#define TIMER_NO_HASH_WAIT 0x10
//Loops the timer repeatedly until qdeleted
//In most cases you want a subsystem instead
#define TIMER_LOOP			0x20

#define TIMER_ID_NULL -1

//For servers that can't do with any additional lag, set this to none in flightpacks.dm in subsystem/processing.
#define FLIGHTSUIT_PROCESSING_NONE 0
#define FLIGHTSUIT_PROCESSING_FULL 1

#define INITIALIZATION_INSSATOMS      0	//New should not call Initialize
#define INITIALIZATION_INSSATOMS_LATE 1	//New should not call Initialize; after the first pass is complete (handled differently)
#define INITIALIZATION_INNEW_MAPLOAD  2	//New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_REGULAR  3	//New should call Initialize(FALSE)

#define INITIALIZE_HINT_NORMAL   0  //Nothing happens
#define INITIALIZE_HINT_LATELOAD 1  //Call LateInitialize
#define INITIALIZE_HINT_QDEL     2  //Call qdel on the atom

//type and all subtypes should always call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(atom_flags & ATOM_FLAG_INITIALIZED)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.


#define SS_INIT_FAIL2TOPIC			102
#define SS_INIT_PROFILER			101
#define SS_INIT_GARBAGE				99
#define SS_INIT_DBCORE				95
#define SS_INIT_SERVER_MAINT		93
#define SS_INIT_SOUNDS				80
#define SS_INIT_TIMETRACK			46
#define SS_INIT_JOBS				30
#define SS_INIT_ANTAGS				18
#define SS_INIT_CHAR_SETUP			17
#define SS_INIT_PLANTS				16
#define SS_INIT_SKYBOX				14
#define SS_INIT_TICKER				10
#define SS_INIT_MAPPING				8
#define SS_INIT_RESEARCH			7
#define SS_INIT_ATOMS				6
#define SS_INIT_CIRCUIT				4
#define SS_INIT_NECROMORPH			2
#define SS_INIT_ICON_UPDATE			0
#define SS_INIT_MACHINES			-2
#define SS_INIT_DEFAULT				-4
#define SS_INIT_AIR					-6
#define SS_INIT_CRAFT				-2
#define SS_INIT_ASSET				-4
#define SS_INIT_MISC_LATE			-6
#define SS_INIT_ALARM				-8
#define SS_INIT_MISC_CODEX			-10
#define SS_INIT_SHUTTLE				-12
#define SS_INIT_LIGHTING			-14
#define SS_INIT_OVERLAYS			-16
#define SS_INIT_INSTRUMENTS			-20
#define SS_INIT_XENOARCH			-50
#define SS_INIT_BAY_LEGACY			-200
#define SS_INIT_UNIT_TESTS			-250
#define SS_INIT_STATPANEL			-499
#define SS_INIT_CHAT				-500
#define SS_INIT_SLOW				-999	//Make this subsystem last, even after other things that think they should be last.
											//It starts work that is intended to continue running after roundstart

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)



//Process times
#define MOB_PROCESS_INTERVAL	2 SECONDS
#define FAST_PROCESS_INTERVAL	0.2 SECONDS
#define SLOW_PROCESS_INTERVAL	1 MINUTE
#define MACHINE_PROCESS_INTERVAL	2 SECONDS
#define EVENT_PROCESS_INTERVAL	2 SECONDS

//! ## Overlays subsystem

///Compile all the overlays for an atom from the cache lists
// |= on overlays is not actually guaranteed to not add same appearances but we're optimistically using it anyway.
#define COMPILE_OVERLAYS(A) \
	do {\
		if(LAZYLEN(A.remove_overlays)){\
			A.overlays -= A.remove_overlays;\
		}\
		if(LAZYLEN(A.add_overlays)){\
			A.overlays |= A.add_overlays;\
		}\
		A.atom_flags &= ~ATOM_FLAG_OVERLAY_QUEUED;\
	} while (FALSE)
