/*
	The repair kit is a consumable tool used to repair other tools, weapons, suits, clothing, doors, etc.
	It'll work on anything that can be repaired, by using the unified repair proc
*/
/obj/item/weapon/tool/repairkit
	name = "repair kit"
	desc = "An engineer's buddy, the repair kit can repair structural damage on almost anything. Tools, suits, barricades, weapons, shields, etc.\
	Using a repair kit will also resolve any lasting damage caused by prior improper repairs, such as with duct tape."
	icon = 'icons/obj/tools.dmi'
	icon_state = "repairkit"
	w_class = ITEM_SIZE_NORMAL
	tool_qualities = list(QUALITY_REPAIR = 30)
	matter = list(MATERIAL_PLASTIC = 2000, MATERIAL_STEEL = 2000)
	worksound = WORKSOUND_WRENCHING
	use_stock_cost = 0.4	//This is the stock used per decisecond of working
	max_stock = 600
	degradation = 0 //its consumable anyway
	item_flags = ITEM_FLAG_NO_BLUDGEON //Its not a weapon
	max_modifications = 0 //These are consumable, so no wasting modifications on them

	//How many points of stock does it take to do one point of repair power on a target?
	var/repair_cost = 1

/obj/item/weapon/tool/repairkit/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	//Attempt to repair first, call parent only if we fail to do any fixing
	.=attempt_repair(target, user)
	if (. || QDELETED(src))
		return

	.=..()



//Try to repair a thing. Return true if we did any repairing on it
/obj/item/weapon/tool/repairkit/proc/attempt_repair(var/atom/target, var/mob/user)
	if (!target)
		return FALSE

	var/needed = target.repair_needed()
	if (!needed || !isnum(needed))
		to_chat(user, SPAN_NOTICE("[target] is not in need of repair!"))
		return FALSE



	//Okay the target needs repaired, lets do this! After this point we'll return true no matter what, so
	.=TRUE


	//First of all, lets work out how long this could take. A few steps

	//This is how many deciseconds it will take, assuming we had infinite stock available
	var/repairtime = needed / use_stock_cost

	//But we dont have infinite stock. So we need to clamp that to the stock we have remaining, factoring in repair cost
	repairtime = clamp(repairtime, 0, (stock / get_repair_cost(user, target)) / use_stock_cost)



	//Alright we are ready to start
	var/result = use_tool_extended(user = user,
	target = target,
	base_time = repairtime,
	required_quality = null, //The required quality is null because we've already precalculated a modified time
	fail_chance = 0, //No failchance, user skills are factored into the worktime instead.
	required_stat = null, //The required stat is null because we've already precalculated a modified time
	progress_proc_interval = 0.5 SECONDS)

	//This kit might have been deleted during that repair work. If its gone, nothing we can do
	if (QDELETED(src))
		return

	//Most of the actual repairing comes in the progress proc, every half second
	//But there will be a small gap at the end of the operation where some time was spent but not enough to fire a progress proc
	//We will account for that here

	//First make sure the operation completed successfully
	if (result == TOOL_USE_SUCCESS)
		//How much time has passed since we last spent resources. This will be < half a second
		var/unaccounted_time = world.time - last_resource_consumption

		//Do some repairs
		repair_tick(user, target, unaccounted_time)

		//We do NOT consume resources here, because the use tool operation already consumed them for this remaining time

/obj/item/weapon/tool/repairkit/proc/get_repair_cost(var/mob/user, var/atom/target)
	var/cost_multiplier = repair_cost
	//TODO Here: Factor character skills into this cost multiplier

	return cost_multiplier

//This routes to repair_tick. We consume the resources here to prevent a double consumption from the finishing
/obj/item/weapon/tool/repairkit/work_in_progress(var/mob/user, var/atom/target, var/delta)
	.=..()
	var/timespent = repair_tick(user, target, delta)
	if (timespent)
		consume_resources(timespent)

//Here we actually do repairing on the thing
//Timespent is in deciseconds
/obj/item/weapon/tool/repairkit/proc/repair_tick(var/mob/user, var/atom/target, var/timespent)
	//First of all, we don't want to overspend, so lets see how much repairing is still needed

	var/repair_needed = target.repair_needed()
	if (!repair_needed || !isnum(repair_needed))
		return 0

	//Lets get our multiplier right now
	var/current_repair_cost = get_repair_cost(user, target)

	//How much stock will it take to repair that much?
	var/stock_needed = repair_needed * current_repair_cost

	//The amount of stock we're actually going to spend is the smallest of these three:
		//The amount of stock needed to finish all repairs
		//The amount of stock we have remaining
		//The amount of stock we are allowed to spend this tick, based on timespent
	var/stock_spent = min(stock_needed, stock, timespent*use_stock_cost)

	//Okay good, now lets back-convert that to get the repair power we'll apply
	var/repair_power = stock_spent / current_repair_cost

	//And one more conversion, because consume_resources takes a time value
	//This is in deciseconds
	var/stock_time = stock_spent / use_stock_cost

	//Finally we are ready to go.
	//Do the repairs
	target.repair(repair_power, src, user)

	//If the tool has been damaged by duct tape repairs, a proper repair kit fixes that
	if (istool(target))
		var/obj/item/weapon/tool/T = target
		T.repair_frequency = clamp(T.repair_frequency-1, 0, INFINITY)

	//We return the stock time, the caller will handle spending the resources
	return stock_time
