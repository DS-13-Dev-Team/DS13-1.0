/obj/item/device/rig_remover
	name = "RIG Retraction Device"
	desc = "A hand held device for treatment of workers inside heavy RIG suits. Retracts the target's RIG through the Safe Retraction API,  as long as they don't object."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	item_state = "analyzer"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL

	throw_range = 10
	matter = list(MATERIAL_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/state = 0	//0 = ready, 1 = awaiting response, 2 = awaiting unsealing

	var/mob/living/carbon/human/current_target
	var/mob/living/carbon/human/last_user
	var/response = null

	var/timeout = 10 SECONDS

	var/timeout_end


/obj/item/device/rig_remover/afterattack(mob/living/carbon/human/target, mob/user, proximity)
	if (!is_valid_target(target,user, proximity))
		return

	start(target, user)


/obj/item/device/rig_remover/proc/is_valid_target(mob/living/carbon/human/target, mob/user, proximity)
	if (current_target)
		to_chat(user, SPAN_WARNING("Currently operating on [current_target], please wait!"))
		return

	if(!proximity)
		return

	if (!istype(target))
		return

	if (!target.wearing_rig)
		to_chat(user, SPAN_WARNING("[target] is not wearing a RIG"))
		return

	if (get_extension(target.wearing_rig, /datum/extension/rig_remover_cooldown))
		to_chat(user, SPAN_WARNING("[target] has recently refused a removal request, and cannot be asked again for a minute"))
		return

	var/obj/item/weapon/rig/R = target.wearing_rig

	//In process already
	if (R.sealing)
		return

	return TRUE



/obj/item/device/rig_remover/proc/start(target, user)
	current_target = target
	last_user = user
	response = null
	timeout_end = world.time + timeout
	state = 1
	spawn()
		response = alert(target, "[user] is requesting to disengage your RIG for medical treatment. To give consent, please either select yes, or do nothing.",
		"RIG Undeploy Request", "Yes", "No")

	START_PROCESSING(SSobj, src)

/obj/item/device/rig_remover/Process()

	if (state == 1)
		if (response)
			if (response == "Yes")
				finish()
			if (response == "No")
				fail()

		else if (world.time < timeout_end)
			return

		else
			//No response, but its timed out, lets finish
			finish()
	if (state == 2)
		finish()

/obj/item/device/rig_remover/proc/fail()

	//Here we just set target to null so that no toggling will be done, then call finish

	to_chat(last_user, SPAN_DANGER("[current_target] refused retract request, retraction cancelled"))
	if (current_target && current_target.wearing_rig)
		set_extension(current_target.wearing_rig, /datum/extension/rig_remover_cooldown)
	current_target = null
	finish()

/obj/item/device/rig_remover/proc/finish()
	if (current_target && current_target.wearing_rig)
		var/obj/item/weapon/rig/R = current_target.wearing_rig

		//Okay first up, if the rig is active, unseal it
		if (state == 1)
			if (R.active)
				R.toggle_seals(last_user, FALSE)
			state = 2
			return

		//In state 2, we're waiting for toggle seals to finish
		else if (state == 2)
			if (R.sealing)
				//Not finished yet, continue waiting
				return
			//Next, undeploy all the pieces
			R.retract()

	current_target = null
	last_user = null
	response = null
	timeout_end = null
	state = 0
	STOP_PROCESSING(SSobj, src)



/datum/extension/rig_remover_cooldown
	flags = EXTENSION_FLAG_IMMEDIATE
	base_type = /datum/extension/rig_remover_cooldown


/datum/extension/rig_remover_cooldown/New()
	.=..()
	addtimer(CALLBACK(src, /datum/extension/proc/remove_self), 1 MINUTE)