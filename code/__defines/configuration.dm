//config files
#define CONFIG_GET(X) global.config.Get(/datum/config_entry/##X)
#define CONFIG_SET(X, Y) global.config.Set(/datum/config_entry/##X, ##Y)

#define CONFIG_MAPS_FILE "maps.txt"
#define CONFIG_MODES_FILE "modes.txt"

//flags
#define CONFIG_ENTRY_LOCKED (1<<0)	//can't edit
#define CONFIG_ENTRY_HIDDEN (1<<1)	//can't see value

#define EVENT_FIRST_RUN list(EVENT_LEVEL_MUNDANE = null, EVENT_LEVEL_MODERATE = null, EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000))
#define EVENT_DELAY_LOWER list(EVENT_LEVEL_MUNDANE = 6000, EVENT_LEVEL_MODERATE = 18000, EVENT_LEVEL_MAJOR = 30000)
#define EVENT_DELAY_UPPER list(EVENT_LEVEL_MUNDANE = 9000, EVENT_LEVEL_MODERATE = 27000, EVENT_LEVEL_MAJOR = 42000)