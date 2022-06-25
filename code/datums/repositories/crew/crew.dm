GLOBAL_DATUM_INIT(crew_repository, /datum/repository/crew, new)

/datum/repository/crew
	var/list/cache_data
	var/list/cache_data_alert
	var/list/modifier_queues
	var/list/modifier_queues_by_type

/datum/repository/crew/New()
	cache_data = list()
	cache_data_alert = list()

	var/PriorityQueue/general_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/binary_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/vital_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)
	var/PriorityQueue/tracking_modifiers = new/PriorityQueue(/proc/cmp_crew_sensor_modifier)

	general_modifiers.Enqueue(new/crew_sensor_modifier/general())
	binary_modifiers.Enqueue(new/crew_sensor_modifier/binary())
	vital_modifiers.Enqueue(new/crew_sensor_modifier/vital())
	tracking_modifiers.Enqueue(new/crew_sensor_modifier/tracking())

	modifier_queues = list()
	modifier_queues[general_modifiers] = 0
	modifier_queues[binary_modifiers] = RIG_SENSOR_BINARY
	modifier_queues[vital_modifiers] = RIG_SENSOR_VITAL
	modifier_queues[tracking_modifiers] = RIG_SENSOR_TRACKING

	modifier_queues_by_type = list()
	modifier_queues_by_type[/crew_sensor_modifier/general] = general_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/binary] = binary_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/vital] = vital_modifiers
	modifier_queues_by_type[/crew_sensor_modifier/tracking] = tracking_modifiers

	..()

/datum/repository/crew/proc/health_data(var/z_level)
	var/list/crewmembers = list()
	if(!z_level)
		return crewmembers

	var/datum/cache_entry/cache_entry = cache_data[num2text(z_level)]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[num2text(z_level)] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

	cache_data_alert[num2text(z_level)] = FALSE
	var/tracked = scan()
	for(var/obj/item/rig_module/healthbar/HB as anything in tracked)
		var/turf/pos = get_turf(HB)
		if(HB.tracking_level != RIG_SENSOR_OFF && pos?.z == z_level && HB.holder?.active)
			if(istype(HB.holder?.wearer, /mob/living/carbon/human))
				var/list/crewmemberData = list("stat"=0, "oxy"=-1, "tox"=-1, "fire"=-1, "brute"=-1, "area"="", "x"=-1, "y"=-1, "ref" = "\ref[HB.holder.wearer]")

				crewmemberData["sensor_type"] = HB.tracking_level
				crewmemberData["name"] = HB.holder.wearer.get_authentification_name(if_no_id="Unknown")
				crewmemberData["rank"] = HB.holder.wearer.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
				crewmemberData["assignment"] = HB.holder.wearer.get_assignment(if_no_id="Unknown", if_no_job="No Job")

				if(HB.tracking_level >= RIG_SENSOR_BINARY)
					crewmemberData["stat"] = HB.holder.wearer.stat

				if(HB.tracking_level >= RIG_SENSOR_VITAL)
					crewmemberData["oxy"] = round(HB.holder.wearer.getOxyLoss(), 1)
					crewmemberData["tox"] = round(HB.holder.wearer.getToxLoss(), 1)
					crewmemberData["fire"] = round(HB.holder.wearer.getFireLoss(), 1)
					crewmemberData["brute"] = round(HB.holder.wearer.getBruteLoss(), 1)

				if(HB.tracking_level >= RIG_SENSOR_TRACKING)
					var/area/A = pos.loc
					crewmemberData["area"] = sanitize(A.name)
					crewmemberData["x"] = pos.x
					crewmemberData["y"] = pos.y
					crewmemberData["z"] = pos.z

				crewmembers[++crewmembers.len] = crewmemberData

	crewmembers = sortByKey(crewmembers, "name")
	cache_entry.timestamp = world.time + 5 SECONDS
	cache_entry.data = crewmembers

	cache_data[num2text(z_level)] = cache_entry

	return crewmembers

/datum/repository/crew/proc/has_health_alert(var/z_level)
	. = FALSE
	if(!z_level)
		return
	health_data(z_level) // Make sure cache doesn't get stale
	. = cache_data_alert[num2text(z_level)]

/datum/repository/crew/proc/scan()
	var/list/tracked = list()
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.wearing_rig?.healthbar)
			tracked |= H.wearing_rig.healthbar
	return tracked


/datum/repository/crew/proc/run_queues(H, HB, pos, crewmemberData)
	for(var/modifier_queue in modifier_queues)
		if(crewmemberData["sensor_type"] >= modifier_queues[modifier_queue])
			. = process_crew_data(modifier_queue, H, HB, pos, crewmemberData)
			if(. & MOD_SUIT_SENSORS_REJECTED)
				return

/datum/repository/crew/proc/process_crew_data(var/PriorityQueue/modifiers, var/mob/living/carbon/human/H, var/obj/item/rig_module/healthbar/HB, var/turf/pos, var/list/crew_data)
	var/current_priority = INFINITY
	var/list/modifiers_of_this_priority = list()

	for(var/crew_sensor_modifier/csm in modifiers.L)
		if(csm.priority < current_priority)
			. = check_queue(modifiers_of_this_priority, H, HB, pos, crew_data)
			if(. != MOD_SUIT_SENSORS_NONE)
				return
		current_priority = csm.priority
		modifiers_of_this_priority += csm
	return check_queue(modifiers_of_this_priority, H, HB, pos, crew_data)

/datum/repository/crew/proc/check_queue(var/list/modifiers_of_this_priority, H, HB, pos, crew_data)
	while(modifiers_of_this_priority.len)
		var/crew_sensor_modifier/pcsm = pick(modifiers_of_this_priority)
		modifiers_of_this_priority -= pcsm
		if(pcsm.may_process_crew_data(H, HB, pos))
			. = pcsm.process_crew_data(H, HB, pos, crew_data)
			if(. != MOD_SUIT_SENSORS_NONE)
				return
	return MOD_SUIT_SENSORS_NONE

/datum/repository/crew/proc/add_modifier(var/base_type, var/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor modifier was not of the given base type.")
	var/PriorityQueue/pq = modifier_queues_by_type[base_type]
	if(!pq)
		CRASH("The given base type was not a valid base type.")
	if(csm in pq.L)
		CRASH("This crew sensor modifier has already been supplied.")
	pq.Enqueue(csm)
	return TRUE

/datum/repository/crew/proc/remove_modifier(var/base_type, var/crew_sensor_modifier/csm)
	if(!istype(csm, base_type))
		CRASH("The given crew sensor modifier was not of the given base type.")
	var/PriorityQueue/pq = modifier_queues_by_type[base_type]
	if(!pq)
		CRASH("The given base type was not a valid base type.")
	return pq.Remove(csm)
