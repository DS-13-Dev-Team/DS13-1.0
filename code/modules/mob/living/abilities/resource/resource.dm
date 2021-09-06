/*
	Holders for generic resources which regnerate over time, get consumed to use abilities, etc
*/
#define RESOURCE_ESSENCE	/datum/extension/resource/essence
/datum/extension/resource
	expected_type = /mob
	name = "Resource"
	flags = EXTENSION_FLAG_IMMEDIATE
	var/min_value = 0
	var/current_value = 0
	var/max_value = 100
	var/regen = 1	//Per second



	var/meter_type = /obj/screen/meter/resource
	var/obj/screen/meter/resource/meter

/datum/extension/resource/New(var/mob/holder)
	.=..()
	start_processing()
	if (meter_type && ismob(holder))
		setup_meter()	//Onscreen resource meter

		GLOB.logged_in_event.register(holder, src, /datum/extension/resource/proc/holder_login)
		GLOB.logged_out_event.register(holder, src, /datum/extension/resource/proc/holder_logout)

/datum/extension/resource/Destroy()
	remove_meter()
	.=..()
/*
	HUD meter handling
*/
/datum/extension/resource/proc/holder_login()
	remove_meter()
	setup_meter()


/datum/extension/resource/proc/holder_logout()
	remove_meter()


/datum/extension/resource/proc/setup_meter()
	var/mob/M = holder
	if (M.client)
		meter = M.add_meter(meter_type,src)
		meter.resource_holder = src
		meter.update()

/datum/extension/resource/proc/remove_meter()
	QDEL_NULL(meter)

/datum/extension/resource/Process()

	regenerate()

	if (can_stop_processing())
		return PROCESS_KILL



/datum/extension/resource/proc/get_report()
	return list("current"	=	current_value, "max"	=	max_value, 	"regen"	=	(current_value < max_value ? get_regen_amount() : 0))

//Called whenever we might want to start
/datum/extension/resource/proc/start_processing()
	if (!is_processing)
		START_PROCESSING(SSprocessing, src)

/datum/extension/resource/proc/stop_processing()
	if (is_processing)
		STOP_PROCESSING(SSprocessing, src)


/datum/extension/resource/can_stop_processing()
	.=TRUE
	if (current_value < max_value)
		return FALSE

/datum/extension/resource/proc/regenerate()
	current_value = clamp(current_value+get_regen_amount(), min_value, max_value)
	if (meter)
		meter.update()


/datum/extension/resource/proc/get_regen_amount()
	return regen

/datum/extension/resource/proc/consume(var/quantity)
	if (current_value >= quantity)
		current_value -= quantity
		start_processing()
		if (meter)
			meter.update()
		return TRUE

	return FALSE


/datum/extension/resource/proc/modify(var/quantity)
	var/old_value = current_value
	current_value += quantity
	current_value = clamp(current_value, min_value, max_value)
	if (old_value != current_value)
		start_processing()
		if (meter)
			meter.update()
		return TRUE

	return FALSE

/datum/extension/resource/proc/can_afford(var/quantity)
	return (current_value >= quantity)


/*
	Helpers:
*/
/datum/proc/consume_resource(var/type, var/quantity)
	.=FALSE
	var/datum/extension/resource/R = get_extension(src, type)
	if (istype(R) && R.consume(quantity))
		return TRUE


/datum/proc/modify_resource(var/type, var/quantity)
	.=FALSE
	var/datum/extension/resource/R = get_extension(src, type)
	if (istype(R) && R.modify(quantity))
		return TRUE

/datum/proc/can_afford_resource(var/type, var/quantity, var/error_message = FALSE)
	.=FALSE
	var/datum/extension/resource/R = get_extension(src, type)
	if (istype(R) && R.can_afford(quantity))
		return TRUE

	else if (error_message)
		to_chat(src, "You don't have enough [R.name]!")


//Getters
/datum/proc/get_resource(var/type)
	.=0
	var/datum/extension/resource/R = get_extension(src, type)
	if (istype(R))
		return R.current_value


/datum/proc/get_resource_max(var/type)
	.=0
	var/datum/extension/resource/R = get_extension(src, type)
	if (istype(R))
		return R.max_value


//Returns a string, used for UIs
/datum/proc/get_resource_curmax(var/type)
	.=0
	var/datum/extension/resource/R = get_extension(src, type)
	if (istype(R))
		return "[R.current_value]/[R.max_value]"