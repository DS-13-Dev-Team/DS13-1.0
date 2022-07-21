/*
The /tg/ codebase allows mixing of hardcoded and dynamically-loaded Z-levels.
Z-levels can be reordered as desired and their properties are set by "traits".
See code/datums/map_config.dm for how a particular station's traits may be chosen.
The list DEFAULT_MAP_TRAITS at the bottom of this file should correspond to
the maps that are hardcoded. SSmapping is responsible for loading every non-hardcoded Z-level.

As of April 26th, 2022, the typical Z-levels for a single-level station are:
1: CentCom
2: Station
3-4: Randomized Space (Ruins)
5: Mining
6-11: Randomized Space (Ruins)
12: Transit/Reserved Space

However, if away missions are enabled:
12: Away Mission
13: Transit/Reserved Space

Multi-Z stations are supported and Multi-Z mining and away missions would
require only minor tweaks. They also handle their Z-Levels differently on their
own case by case basis.

This information will absolutely date quickly with how we handle Z-Levels, and will
continue to handle them in the future. Currently, you can go into the Debug tab
of your stat-panel (in game) and hit "Mapping verbs - Enable". You will then get a new tab
called "Mapping", as well as access to the verb "Debug-Z-Levels". Although the information
presented in this comment is factual for the time it was written for, it's ill-advised
to trust the words presented within.

We also provide this information to you so that you can have an at-a-glance look at how
Z-Levels are arranged. It is extremely ill-advised to ever use the location of a Z-Level
to assign traits to it or use it in coding. Use Z-Traits (ZTRAITs) for these.

If you want to start toying around with Z-Levels, do not take these words for fact.
Always compile, always use that verb, and always make sure that it works for what you want to do.
*/

// helpers for modifying jobs, used in various job_changes.dm files

#define MAP_CURRENT_VERSION 1

/// Distance from edge to move to another z-level
#define TRANSITIONEDGE 7

/// Path for the next_map.json file, if someone, for some messed up reason, wants to change it.
#define PATH_TO_NEXT_MAP_JSON "data/next_map.json"

/// List of directories we can load map .json files from
#define MAP_DIRECTORY_MAPS "maps"
#define MAP_DIRECTORY_DATA "data"
#define MAP_DIRECTORY_WHITELIST list(MAP_DIRECTORY_MAPS,MAP_DIRECTORY_DATA)

/// Special map path value for custom adminloaded stations.
#define CUSTOM_MAP_PATH "custom"

// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_MINING "Mining"
#define ZTRAIT_RESERVED "Transit/Reserved"

/// boolean - does this z prevent ghosts from observing it
#define ZTRAIT_SECRET "Secret"

// numeric offsets - e.g. {"Down": -1} means that chasms will fall to z - 1 rather than oblivion
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

// enum - how space transitions should affect this level
#define ZTRAIT_LINKAGE "Linkage"
	// UNAFFECTED if absent - no space transitions
	#define UNAFFECTED null
	// SELFLOOPING - space transitions always self-loop
	#define SELFLOOPING "Self"
	// CROSSLINKED - mixed in with the cross-linked space pool
	#define CROSSLINKED "Cross"

// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

// default trait definitions, used by SSmapping
///Z level traits for CentCom
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE, ZTRAIT_NOPHASE = TRUE)
///Z level traits for Space Station 13
#define ZTRAITS_STATION list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_STATION = TRUE)
///Z level traits for Deep Space
#define ZTRAITS_SPACE list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_SPACE_RUINS = TRUE)
///Z level traits for Lavaland
#define ZTRAITS_LAVALAND list(\
	ZTRAIT_MINING = TRUE, \
	ZTRAIT_NOPARALLAX = TRUE, \
	ZTRAIT_ASHSTORM = TRUE, \
	ZTRAIT_LAVA_RUINS = TRUE, \
	ZTRAIT_BOMBCAP_MULTIPLIER = 2, \
	ZTRAIT_BASETURF = /turf/open/lava/smooth/lava_land_surface)
///Z level traits for Away Missions
#define ZTRAITS_AWAY list(ZTRAIT_AWAY = TRUE)
///Z level traits for Secret Away Missions
#define ZTRAITS_AWAY_SECRET list(ZTRAIT_AWAY = TRUE, ZTRAIT_SECRET = TRUE, ZTRAIT_NOPHASE = TRUE)

#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

// must correspond to _basemap.dm for things to work correctly
#define DEFAULT_MAP_TRAITS list(\
	DECLARE_LEVEL("CentCom", ZTRAITS_CENTCOM),\
)

// Camera lock flags
#define CAMERA_LOCK_STATION 1
#define CAMERA_LOCK_MINING 2
#define CAMERA_LOCK_CENTCOM 4

//Reserved/Transit turf type
#define RESERVED_TURF_TYPE /turf/space //What the turf is when not being used

//Ruin Generation

#define PLACEMENT_TRIES 100 //How many times we try to fit the ruin somewhere until giving up (really should just swap to some packing algo)

#define PLACE_DEFAULT "random"
#define PLACE_SAME_Z "same" //On same z level as original ruin
#define PLACE_BELOW "below" //On z levl below - centered on same tile
#define PLACE_ISOLATED "isolated" //On isolated ruin z level

// Helpers for checking whether a z-level conforms to a specific requirement

// Basic levels
#define is_centcom_level(z) SSmapping.level_trait(z, ZTRAIT_CENTCOM)

#define is_station_level(z) SSmapping.level_trait(z, ZTRAIT_STATION)

#define is_mining_level(z) SSmapping.level_trait(z, ZTRAIT_MINING)

#define is_reserved_level(z) SSmapping.level_trait(z, ZTRAIT_RESERVED)

#define is_away_level(z) SSmapping.level_trait(z, ZTRAIT_AWAY)

#define is_secret_level(z) SSmapping.level_trait(z, ZTRAIT_SECRET)

