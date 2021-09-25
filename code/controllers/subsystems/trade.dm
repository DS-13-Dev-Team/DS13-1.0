SUBSYSTEM_DEF(trade)
	name = "Trade"
	wait = 1 MINUTE
	priority = SS_PRIORITY_TRADE
	//Initializes at default time

	var/list/traders = list()
	var/tmp/list/current_traders
	var/next_salary_period	= SALARY_INTERVAL

	/*
		This briefly held list is populated with data about who the active crew members are, and how much they are owed
	*/
	var/list/payroll_list = list()
	var/list/department_shares = list()
	var/list/departmental_bonuses = list()

/datum/controller/subsystem/trade/Initialize()
	. = ..()
	for(var/i in 1 to rand(1,3))
		generate_trader(1)



/datum/controller/subsystem/trade/fire(resumed = FALSE)
	if (!resumed)
		current_traders = traders.Copy()

	if (world.time >= next_salary_period)
		payroll()

	while(current_traders.len)
		var/datum/trader/T = current_traders[current_traders.len]
		current_traders.len--

		if(!T.tick())
			traders -= T
			qdel(T)
		if (MC_TICK_CHECK)
			return

	if(prob(100-traders.len*10))
		generate_trader()

/datum/controller/subsystem/trade/stat_entry(msg)
	return "Traders: [traders.len]"

/datum/controller/subsystem/trade/proc/generate_trader(var/stations = 0)
	var/list/possible = list()
	if(stations)
		possible += subtypesof(/datum/trader) - typesof(/datum/trader/ship)
	else
		if(prob(5))
			possible += subtypesof(/datum/trader/ship/unique)
		else
			possible += subtypesof(/datum/trader/ship) - typesof(/datum/trader/ship/unique)

	for(var/i in 1 to 10)
		var/type = pick(possible)
		var/bad = 0
		for(var/trader in traders)
			if(istype(trader,type))
				bad = 1
				break
		if(bad)
			continue
		traders += new type
		return

/*
	This dispenses payment to all crewmembers
*/
/datum/controller/subsystem/trade/proc/payroll()

	//Track some stats
	var/people_paid = 0
	var/credits_paid = 0

	build_payroll_crew_list()

	next_salary_period	= world.time + SALARY_INTERVAL
	//We cycle through the records
	for(var/list/payee in payroll_list)

		var/datum/money_account/MA = payee["account"]
		var/pay_amount = payee["wage"]

		var/success = charge_to_account(MA.account_number, "CEC Payroll System", "Salary", "CEC Payroll System", pay_amount)
		if (success)
			people_paid++
			credits_paid += pay_amount

		var/department = payee["department"]
		var/bonus_total = departmental_bonuses[department]
		if (bonus_total)
			//The number of shares from the job divided by the total shares determines how much of the group bonus goes to this person
			var/my_shares = payee["shares"]
			var/total_shares = department_shares[department]
			var/my_percentage = my_shares / total_shares
			var/my_bonus = bonus_total * my_percentage
			success = charge_to_account(MA.account_number, "CEC Payroll System", "Group Performance Bonus", "CEC Payroll System", my_bonus)
			if (success)
				credits_paid += my_bonus


	//Alright we are out of the loop!
	if (credits_paid)
		var/announce_string = "CEC Employee salaries have been paid. A total of [credits_paid] was paid out to [people_paid] employees in this cycle. \n"


		if (length(departmental_bonuses))
			var/bonus_string = ""
			for (var/dep in departmental_bonuses)
				bonus_string += "[dep]: [departmental_bonuses[dep]]\n"
			announce_string += "In addition, the following shared performance bonuses have been paid out:\n\
		[bonus_string]\n"

		announce_string += "Please collect your wages at the nearest store kiosk"


		command_announcement.Announce(announce_string,"CEC Payroll System")


/datum/controller/subsystem/trade/proc/build_payroll_crew_list()
	payroll_list = list()
	department_shares = list()
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		//We need to check that the mob is in a condition to be paid
		var/mob/living/carbon/human/H = CR.get_mob()

		//Gotta exist and be alive
		if (!H || H.stat == DEAD)
			continue

		//Next, filter out NPCs and people who have ghosted
		if (!H.ckey || !H.mind)
			continue

		//Lastly, you gotta be online and active
		//Future TODO: Find some way to catch people who just crashed or relogged at the wrong time
			//Maybe find out when they logged out?
		if (!H.client || (H.client.inactivity > (SALARY_INTERVAL * 0.5)))
			continue

		//Get the job datum, tells us how much to pay
		var/rank = CR.get_job()
		if (!rank)
			continue

		var/datum/job/job_datum = job_master.GetJob(rank)
		if (!job_datum)
			continue


		var/pay_amount = job_datum.salary
		//Future TODO: Performance bonuses

		//Alright we have finally concluded that this person is eligible to be paid, and how much to pay them. Now we need to find their account
		var/datum/money_account/MA = H.mind.initial_account
		if (!MA)
			continue

		//Okay now we record all this data
		var/current_shares = isnum(department_shares[job_datum.department]) ? department_shares[job_datum.department] : 0
		department_shares[job_datum.department] = current_shares + job_datum.bonus_shares
		var/list/payee = list("mob" = H, "account" = MA, "wage" = pay_amount, "department" = job_datum.department, "shares" = job_datum.bonus_shares)
		payroll_list += list(payee)


/*
	Called from the mineral processor
	Used to put funds into the mining department performance bonus pool based on ore output
*/
/datum/controller/subsystem/trade/proc/ores_processed(var/list/ores)
	for (var/orename in ores)
		var/ore/ore_datum = ore_data[orename]
		var/value = ore_datum.Value()
		value *= ores[orename]
		LAZYAPLUS(departmental_bonuses, "Mining", value)