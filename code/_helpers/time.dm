//Returns the world time in english
/proc/worldtime2text()
	return gameTimestamp("hh:mm:ss", world.time)

/proc/time_stamp(format = "hh:mm:ss", show_ds)
	var/time_string = time2text(world.timeofday, format)
	return show_ds ? "[time_string]:[world.timeofday % 10]" : time_string

/proc/gameTimestamp(format = "hh:mm:ss", wtime=null)
	if(!wtime)
		wtime = world.time
	return time2text(wtime - GLOB.timezoneOffset, format)

/proc/stationTimestamp(format = "hh:mm:ss", wtime = null)
	if(!wtime)
		wtime = world.time
	return time2text(wtime - GLOB.timezoneOffset + (12 * 36000), format)

#define TimeOfGame (get_game_time())
#define TimeOfTick (world.tick_usage*0.01*world.tick_lag)
/proc/get_game_time()
	var/global/time_offset = 0
	var/global/last_time = 0
	var/global/last_usage = 0

	var/wtime = world.time
	var/wusage = world.tick_usage * 0.01

	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1

	last_time = wtime
	last_usage = wusage

	return wtime + (time_offset + wusage) * world.tick_lag

var/roundstart_hour
var/station_date = ""
var/next_station_date_change = 1 DAY

#define duration2stationtime(time) time2text(station_time_in_ticks + time, "hh:mm")
#define worldtime2stationtime(time) time2text(roundstart_hour HOURS + time, "hh:mm")
#define round_duration_in_ticks (round_start_time ? world.time - round_start_time : 0)
#define station_time_in_ticks (roundstart_hour HOURS + round_duration_in_ticks)

/proc/stationtime2text()
	return time2text(station_time_in_ticks, "hh:mm")

/proc/stationdate2text()
	var/update_time = FALSE
	if(station_time_in_ticks > next_station_date_change)
		next_station_date_change += 1 DAY
		update_time = TRUE
	if(!station_date || update_time)
		var/extra_days = round(station_time_in_ticks / (1 DAY)) DAYS
		var/timeofday = world.timeofday + extra_days
		station_date = num2text((text2num(time2text(timeofday, "YYYY"))+544)) + "-" + time2text(timeofday, "MM-DD")
	return station_date


/* Returns 1 if it is the selected month and day */
proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

var/next_duration_update = 0
var/last_round_duration = 0
var/round_start_time = 0

/hook/roundstart/proc/start_timer()
	round_start_time = world.time
	return 1

/proc/roundduration2text()
	if(!round_start_time)
		return "00:00"
	if(last_round_duration && world.time < next_duration_update)
		return last_round_duration

	var/mills = round_duration_in_ticks // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	mins = mins < 10 ? add_zero(mins, 1) : mins
	hours = hours < 10 ? add_zero(hours, 1) : hours

	last_round_duration = "[hours]:[mins]"
	next_duration_update = world.time + 1 MINUTES
	return last_round_duration

/hook/startup/proc/set_roundstart_hour()
	roundstart_hour = pick(2,7,12,17)
	return 1

GLOBAL_VAR_INIT(midnight_rollovers, 0)
GLOBAL_VAR_INIT(rollovercheck_last_timeofday, 0)
/proc/update_midnight_rollover()
	if (world.timeofday < GLOB.rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		return GLOB.midnight_rollovers++
	return GLOB.midnight_rollovers

//Increases delay as the server gets more overloaded,
//as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful
#define DELTA_CALC max(((max(world.tick_usage, world.cpu) / 100) * max(Master.sleep_delta,1)), 1)

/proc/stoplag()
	if (!Master || !(Master.current_runlevel & RUNLEVELS_DEFAULT))
		sleep(world.tick_lag)
		return 1
	. = 0
	var/i = 1
	do
		. += round(i*DELTA_CALC)
		sleep(i*world.tick_lag*DELTA_CALC)
		i *= 2
	while (world.tick_usage > min(TICK_LIMIT_TO_RUN, Master.current_ticklimit))

#undef DELTA_CALC


/proc/descriptive_time(var/time, var/divider = ", ")
	var/list/components = list()
	if (time >= 1 HOUR)
		var/hours = Floor(time / 36000)
		components += "[hours] [hours > 1 ? "hours" : "hour"]"
		time -= hours HOURS
	if (time >= 1 MINUTE)
		var/minutes = Floor(time / 600)
		components += "[minutes] [minutes > 1 ? "minutes" : "minute"]"
		time -= minutes MINUTES
	if (time > 0)
		var/seconds = time / 10	//No floor, we will show decimals for seconds
		components += "[seconds] [seconds > 1 ? "seconds" : "second"]"
		time -= seconds SECONDS

	var/finalstring = ""
	for (var/component in components)
		if (finalstring)
			finalstring += divider

		finalstring += component

	return finalstring

//Takes a value of time in deciseconds.
//Returns a text value of that number in hours, minutes, or seconds.
/proc/DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = FLOOR(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = FLOOR(second / 60, 1)
	second = FLOOR(MODULUS(second, 60), round_seconds_to)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = FLOOR(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = FLOOR(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"
