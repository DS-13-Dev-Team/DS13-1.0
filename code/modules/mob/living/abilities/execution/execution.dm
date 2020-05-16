/*
	An execution is a multistage finishing ability that typically ends in the death and/or dismemberment of one helpless victim

	Executions can be interrupted by the user taking damage, or the victim escaping out of reach

	Executions happen in a few distinct stages:
		Aquisition:
			a victim is chosen and checked for validity
			The victim and attacker are moved closer together, if needed
			Often, the attacker will grab the victim

			Can be interrupted during this stage

		Process:
			The attacker starts doing stuff, makes noise, winds up big attacks, etc.
			This is generally the longest period and may involve lesser damage being inflicted
			In this stage we will do frequent polling to ensure its still valid to continue. Victim still held, we haven't taken damage, etc#

			Can be interrupted during this stage

		The Cut:
			Point of no return. The victim is now dead
			Regardless of whatever else happens, the execution is considered to be successful. Rewards are distributed

		Wind down:
			The attacker mutilates the corpse a bit more, dances on the body, draws back its tentacles, whatever. Generally lasts a few seconds
			At this point the attacker is still unable to move or do things until this stage ends.
			This is a vulnerable opportunity for revenge from the victim's friends if any were around. Though its not like they can un-kill the victim


	Rewards:
		Since they are high risk and flashy, performing executions is generally rewarded. The reward may be any (usually several) of the following:

		-Some bonus biomass is added to the marker
		-Signals watching the kill recieve some energy
		-The attacker is healed to some degree
		-The attacker gains some buff
		-Attacker's cooldowns are refreshed
		-Nearby crew take major sanity damage (in future)

*/

//Safety check flags
#define EXECUTION_CANCEL	-1	//The whole move has gone wrong, abort
#define EXECUTION_RETRY		0	//Its not right yet but will probably fix itself, delay and keep trying
#define EXECUTION_CONTINUE	1	//Its fine, keep going
#define EXECUTION_SAFETY	{var/result = safety();\
if (result != EXECUTION_CONTINUE)\
	return}
/datum/extension/execution
	name = "Execution"
	base_type = /datum/extension/execution
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE

	var/status
	var/mob/living/user
	var/mob/living/victim
	var/power = 1
	var/cooldown = 1 SECOND
	var/duration = 1 SECOND

	var/started_at
	var/stopped_at

	var/ongoing_timer

	//All the stages that we will eventually execute
	//This should be a list of typepaths
	var/list/all_stages = list()


	//List of execution stage datums that have been started
	//We'll consult these for safety checks, cancelling, completing, etc
	var/list/entered_stages = list()

	//What entry in the all stages list we're currently working on
	var/current_stage_index = 0

	//The datum of the current stage
	var/datum/execution_stage/current_stage


/datum/extension/execution/New(var/atom/user, var/duration, var/cooldown)
	.=..()
	if (isliving(user))
		src.user = user
	src.duration = duration
	src.cooldown = cooldown

	//Lets compile the list of stages
	for (var/i in 1 to all_stages.len)
		var/stagetype = all_stages[i]
		all_stages[i] = new stagetype(src)

	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/execution/proc/start), 0, TIMER_STOPPABLE)


/datum/extension/execution/proc/start()
	started_at	=	world.time

/datum/extension/execution/proc/try_advance_stage()
	EXECUTION_SAFETY

	if (current_stage && current_stage_index)
		//If there's a current stage, ask it whether its ready to advance

	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/execution/proc/stop), duration, TIMER_STOPPABLE)


/datum/extension/execution/proc/stop()
	deltimer(ongoing_timer)
	stopped_at = world.time
	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/execution/proc/finish_cooldown), cooldown, TIMER_STOPPABLE)


/datum/extension/execution/proc/finish_cooldown()
	deltimer(ongoing_timer)
	remove_extension(holder, base_type)


/datum/extension/execution/proc/get_cooldown_time()
	var/elapsed = world.time - stopped_at
	return cooldown - elapsed





/***********************
	Safety Checks
************************/
//Access Proc
/atom/proc/can_execution(var/error_messages = TRUE)
	if (incapacitated())
		return FALSE

	var/datum/extension/execution/E = get_extension(src, /datum/extension/execution)
	if(istype(E))
		if (error_messages)
			if (E.stopped_at)
				to_chat(src, SPAN_NOTICE("[E.name] is cooling down. You can use it again in [E.get_cooldown_time() /10] seconds"))
			else
				to_chat(src, SPAN_NOTICE("You're already Executing"))
		return FALSE

	return TRUE