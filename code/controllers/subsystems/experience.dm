SUBSYSTEM_DEF(experience)
	name = "Experience"
	flags = SS_NO_INIT
	wait = 5 MINUTES
	runlevels = RUNLEVEL_GAME

/datum/controller/subsystem/experience/fire(resumed)
	if(!CONFIG_GET(flag/use_exp_tracking))
		return
	if(!SSdbcore.Connect())
		return
	var/wait_seconds = wait
	if(flags & SS_TICKER)
		wait_seconds = TICKS2DS(wait)

	var/minutes = (wait_seconds / 10) / 60 // Calculate minutes based on the SS wait time (How often this proc fires)

	var/list/exp_to_update = list()
	for(var/client/C as anything in GLOB.clients)
		if(C.mob.stat != DEAD)
			exp_to_update += list(list(
				"job" = EXP_TYPE_LIVING,
				"ckey" = C.ckey,
				"minutes" = minutes
			))
			C.exp[EXP_TYPE_LIVING] += minutes

			var/job_exp_type = C.mob.mind?.assigned_job?.exp_type
			if(job_exp_type)
				exp_to_update += list(list(
					"job" = job_exp_type,
					"ckey" = C.ckey,
					"minutes" = minutes
				))
				C.exp[job_exp_type] += minutes

			if(C.mob.mind.special_role)
				exp_to_update += list(list(
					"job" = EXP_TYPE_SPECIAL,
					"ckey" = C.ckey,
					"minutes" = minutes
				))
				C.exp[EXP_TYPE_SPECIAL] += minutes

		else if(C.mob.is_necromorph())
			exp_to_update += list(list(
				"job" = EXP_TYPE_SIGNAL,
				"ckey" = C.ckey,
				"minutes" = minutes
			))
			C.exp[EXP_TYPE_SIGNAL] += minutes

		else if(isghost(C.mob))
			exp_to_update += list(list(
				"job" = EXP_TYPE_GHOST,
				"ckey" = C.ckey,
				"minutes" = minutes
			))
			C.exp[EXP_TYPE_GHOST] += minutes

	SSdbcore.MassInsert("role_time", exp_to_update, duplicate_key = "ON DUPLICATE KEY UPDATE minutes = minutes + VALUES(minutes)")
