/*
	The extract objective is similar to Kidnap and Protect
	The designated person must be removed safely from the map
*/
datum/objective/extract
	//Which of the target's roles is used to display in the objective?
	//If true, shows their antag role
	//If false, shows their crew job
	var/role_type = FALSE

	set_text()
		explanation_text = "Safely extract [!role_type ? target.assigned_role : target.special_role] [target.current.real_name]"



	check_completion(var/silent = FALSE)
		.=..()
		if (completed != FALSE)
			return


		//If this happens it means
		if(!target || !target.current)
			return FALSE

		//The target is dead, fail
		if(!target || !target.current || target.current.stat == DEAD)
			fail(silent)
			return FALSE

		//Target has left the station alive
		var/area/A = get_area(target.current)
		if((A in GLOB.using_map.post_round_safe_areas))
			complete(silent)
			return TRUE
		return FALSE