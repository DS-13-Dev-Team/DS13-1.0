

//Takes a date in the format YYYY-MM-DD
//Returns the number of seconds since midnight 2000
//Date must be after 2000 AD
/proc/date_to_byond(var/date)
	var/list/datelist = splittext(date, "-")

	var/total_seconds = 0

	//Alright we have a list of year, month date, lets deal with the year first
	var/years = text2num(datelist[1]) - 2000

	//Lets knock as many leap blocks off it as we can
	var/leap_blocks = Floor(years / 4)
	if (leap_blocks > 0)
		years -= 4 * leap_blocks
		total_seconds += LEAP_BLOCK * leap_blocks

	//Is the current year a leap year
	var/leap = FALSE
	//If theres any remaining years, add them on
	if (years)
		total_seconds += years YEARS
		total_seconds += 1 DAY	//The first of those remaining years is a leap one, so we add an extra day here too
	else
		//If there were no leftover years, then we are currently in a leap year
		leap = TRUE
	//We now have the time up to the start of the specified year



	//Lets handle months next
	var/month = text2num(datelist[2])
	if (leap)
		total_seconds += GLOB.month_seconds_cumulative_leap[month]
	else
		total_seconds += GLOB.month_seconds_cumulative[month]

	//Finally days
	var/days = text2num(datelist[3])
	total_seconds += days DAYS

	return total_seconds



/*
	Takes a BYOND time, a number of seconds since new year 2000 AD
	Converts it to a date in the format YYYY-MM-DD
	any leftover less than a full day is discarded
*/
/proc/byond_to_date(var/time)
	//Years first
	var/list/yearlist = time_to_years(time)

	var/year = yearlist[1]
	time = yearlist[2]
	var/leap = yearlist[3]



	var/list/monthlist = time_to_calendar_month(time, leap)
	var/month = monthlist[1]
	time = monthlist[2]

	//We've got the month

	//Lastly, Days
	var/list/daylist = time_to_days(time)
	var/day = daylist[1]

	//We are done! Lets return it

	return "[year]-[month]-[day]"


//Takes a byond time
//Returns a list in this format:
	//Whole years (integer)
	//Time remaining
	//Leap (true/false)
/proc/time_to_years(var/time)

	//First lets knock off as many leap blocks as we can. Each is 4 years
	var/leap_blocks = Floor(time / LEAP_BLOCK)

	var/years = (leap_blocks * 4)
	time -= leap_blocks * LEAP_BLOCK

	var/leap = FALSE
	//Are there any years left to take? We add a day because this first year will be a leap year if so
	if (time >= (1 YEAR + 1 DAY))
		time -= (1 YEAR + 1 DAY)
		years++
		//And any others?
		if (time >= 1 YEAR)
			var/extrayears = Floor(time / (1 YEAR))
			time -= extrayears YEARS
			years += extrayears
	else
		leap = TRUE


	return list(years, time, leap)


/*
	Takes a byond time, and a boolean indicating whether or not its a leap year.
	The time passed should be less than 1 YEAR, or the results will not be meaningful

	Returns the following list:
		-Month we reached the start of
		-Time remaining
*/
/proc/time_to_calendar_month(var/time, var/leap = FALSE)
	var/initial_time = time
	//We will iterate backwards through the list of cumulative monthlengths, until we find one that is <= remaining time
	var/list/monthlist
	if (leap)
		monthlist = GLOB.month_seconds_cumulative_leap
	else
		monthlist = GLOB.month_seconds_cumulative
	var/month
	for (month = 12; month >= 1; month--)
		var/monthtime = text2num(monthlist[month])
		if (time >= monthtime)
			time -= monthtime
			break


	return list(month, time)


/*
	Takes a byond time

	Returns the following list:
		-Whole days
		-Time remaining
*/
/proc/time_to_days(var/time)
	var/days = Floor(time / (1 DAY))
	time -= days DAYS

	return list(days, time)

/*
	Takes a date in the format "YYYY-MM-DD"
	returns true if the current date is past that
*/
/proc/is_past_date(var/input_date)
	var/list/current_date = current_date()
	var/list/target_date = splittext(time2text(input_date,"YYYY-MM-DD"), "-")

	//Compare year
	if (text2num(target_date[1]) > text2num(current_date[1]))
		return FALSE

	//Compare month
	if (text2num(target_date[2]) > text2num(current_date[2]))
		return FALSE

	//Finally when comparing day, we use <=
	if (text2num(target_date[1]) >= text2num(current_date[1]))
		return FALSE

	return TRUE


/*
	Returns today's date in the format "YYYY-MM-DD"
*/
/proc/current_date()
	return splittext(time2text(world.realtime,"YYYY-MM-DD"), "-")


/*
	Returns the byond time between two dates
*/
/proc/time_between_dates(var/date1, var/date2)
	var/time1 = date_to_byond(date1)
	var/time2 = date_to_byond(date2)

	return time2 - time1

/*
	Adds a certain amount of time to a date, returning it as a date
*/
/proc/add_time_to_date(var/date, var/timedelta)
	var/timedate = date_to_byond(date)
	timedate += timedelta
	return byond_to_date(timedate)


/*
	Returns the number of days time between two dates
*/
/proc/days_between_dates(var/date1, var/date2)
	var/time = abs(time_between_dates(date1, date2))
	return Floor(time / (1 DAY))

/client/verb/date_test(var/date as text)
	set name = "Date to time"



/client/verb/time_test(var/time as num)
	set name = "Time to Date"
