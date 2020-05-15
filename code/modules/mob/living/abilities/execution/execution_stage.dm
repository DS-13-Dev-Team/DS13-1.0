/*
	execution stage datum

	vars
		duration: attempt to exit the stage when this much time has passed after starting it

	contains procs:
		enter:	Called to start this stage. After a stage is started, it is added to the started_stages list on the execution
		safety:	Called whenever the parent execution does a safety check. This can be useful if this stage adds extra safety conditions
		cancel: Called when the parent execution is interrupted/cancelled/etc. Can be useful to undo any temporary effects we set
		completed: Called when the parent execution successfully finishes all stages and is done
		can_advance: called once duration expires, checking if we can advance yet
		exit: called just before we exit this stage and start the next one
*/

/datum/execution_stage


/datum/execution_stage/proc/can_advance()
	//Here, do safety checks to see if everything is in order for being able to advance to the next stage. Return true/false appropriately
	return TRUE
