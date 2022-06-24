/obj/machinery/camera
	var/list/motionTargets = list()
	var/detectTime = 0
	var/alarm_delay = 100 // Don't forget, there's another 10 seconds in queueAlarm()
	movable_flags = MOVABLE_FLAG_PROXMOVE

/obj/machinery/camera/proc/newTarget(var/mob/target)
	if (istype(target, /mob/living/silicon/ai)) return 0
	if (detectTime == 0)
		detectTime = world.time // start the clock
	if (!(target in motionTargets))
		motionTargets += target
	return 1

/obj/machinery/camera/proc/lostTarget(var/mob/target)
	if (target in motionTargets)
		motionTargets -= target
	if (motionTargets.len == 0)
		cancelAlarm()

/obj/machinery/camera/proc/cancelAlarm()
	if (!status || (stat & NOPOWER))
		return 0
	if (detectTime == -1)
		motion_alarm.clearAlarm(loc, src)
	detectTime = 0
	return 1

/obj/machinery/camera/proc/triggerAlarm()
	if (!status || (stat & NOPOWER))
		return 0
	if (!detectTime) return 0
	motion_alarm.triggerAlarm(loc, src)
	detectTime = -1
	return 1

/obj/machinery/camera/HasProximity(atom/movable/AM as mob|obj)
	if(isMotion() && isliving(AM))
		newTarget(AM)
