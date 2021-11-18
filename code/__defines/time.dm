///number of deciseconds in a day
#define MIDNIGHT_ROLLOVER 864000

///displays the current time into the round, with a lot of extra code just there for ensuring it looks okay after an entire day passes
#define ROUND_TIME ( "[world.time - SSticker.round_start_time > MIDNIGHT_ROLLOVER ? "[round((world.time - SSticker.round_start_time)/MIDNIGHT_ROLLOVER)]:[worldtime2text()]" : worldtime2text()]" )

#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define HOUR *36000
#define HOURS *36000

#define DAY *86400
#define DAYS *86400

#define YEAR	*31536000
#define YEARS	*31536000


//Number of seconds in four years, including the extra day in the leap year
#define LEAP_BLOCK	 ((4 YEARS) + (1 DAY))

//A date which is far enough in the future that we don't need to worry
#define FOREVER	"2100-01-01"

GLOBAL_LIST_INIT(month_seconds, list(
31 DAYS,//January
28 DAYS,//February
31 DAYS,//March
30 DAYS,//April
31 DAYS,//May
30 DAYS,//June
31 DAYS,//July
31 DAYS,//August
30 DAYS,//September
31 DAYS,//October
30 DAYS,//November
31 DAYS//December
))

GLOBAL_LIST_INIT(month_seconds_leap, list(
31 DAYS,//January
29 DAYS,//February
31 DAYS,//March
30 DAYS,//April
31 DAYS,//May
30 DAYS,//June
31 DAYS,//July
31 DAYS,//August
30 DAYS,//September
31 DAYS,//October
30 DAYS,//November
31 DAYS//December
))

//The time from the start of the year to the START of this month
GLOBAL_LIST_INIT(month_seconds_cumulative, list(
0,//January
31 DAYS,//February
59 DAYS,//March
90 DAYS,//April
120 DAYS,//May
151 DAYS,//June
181 DAYS,//July
212 DAYS,//August
243 DAYS,//September
273 DAYS,//October
304 DAYS,//November
334 DAYS//December
))


GLOBAL_LIST_INIT(month_seconds_cumulative_leap, list(
0,//January
31 DAYS,//February
60 DAYS,//March
91 DAYS,//April
121 DAYS,//May
152 DAYS,//June
182 DAYS,//July
213 DAYS,//August
244 DAYS,//September
274 DAYS,//October
305 DAYS,//November
335 DAYS//December
))


#define TICKS *world.tick_lag

#define DS2TICKS(DS) ((DS)/world.tick_lag)

#define TICKS2DS(T) ((T) TICKS)

/*
	Future TODO
*/
#define	COOLDOWN_ELECTROCUTION	"electrocution"
