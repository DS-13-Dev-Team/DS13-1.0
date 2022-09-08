/mob/living/bot/medbot
	name = "Medibot"
	desc = "A little medical robot. He looks somewhat underwhelmed."
	icon = 'icons/mob/bot/medibot.dmi'
	icon_state = "medibot0"
	req_one_access = list(access_medical, access_research)
	botcard_access = list(access_medical, access_chemistry)
	var/skin = null //Set to "tox", "ointment" or "o2" for the other two firstaid kits.

	//AI vars
	var/last_newpatient_speak = 0
	var/vocal = 1

	//Healing vars
	var/obj/item/reagent_containers/glass/reagent_glass = null //Can be set to draw from this for reagents.
	var/injection_amount = 15 //How much reagent do we inject at a time?
	var/heal_threshold = 10 //Start healing when they have this much damage in a category
	var/use_beaker = 0 //Use reagents in beaker instead of default treatment agents.
	var/treatment_brute = /datum/reagent/tricordrazine
	var/treatment_oxy = /datum/reagent/dexalin
	var/treatment_fire = /datum/reagent/tricordrazine
	var/treatment_tox = /datum/reagent/dylovene
	var/treatment_virus = /datum/reagent/spaceacillin
	var/treatment_emag = /datum/reagent/toxin
	var/declare_treatment = 0 //When attempting to treat a patient, should it notify everyone wearing medhuds?
	var/medbot_inap = 0

/mob/living/bot/medbot/inapbot
	name = "Inapbot"
	desc = "A little medical robot. He looks prideful about his duties."

	injection_amount = 30
	heal_threshold = 1
	treatment_brute = /datum/reagent/inaprovaline
	treatment_fire = /datum/reagent/inaprovaline
	medbot_inap = 1
	skin = "o2"

/mob/living/bot/medbot/adminbot //admeme spawn
	name = "Adminbot"
	desc = "A little medical robot. He looks somewhat intimidating."

	injection_amount = 5
	treatment_brute = /datum/reagent/adminordrazine
	treatment_oxy = /datum/reagent/adminordrazine
	treatment_fire = /datum/reagent/adminordrazine
	treatment_tox = /datum/reagent/adminordrazine



/mob/living/bot/medbot/handleIdle()
	if(vocal && prob(1) && !medbot_inap)
		var/message = pick("Radar, put a mask on!", "There's always a catch, and it's the best there is.", "I knew it, I should've been a plastic surgeon.", "What kind of infirmary is this? Everyone's dropping like dead flies.", "Delicious!")
		say(message)
	if(vocal && prob(2) && medbot_inap)
		var/message = pick("Radar, use some inap!", "There's always a chem, and Inap is the best there is.", "I knew it, I should've been an Inap Chaplain.", "INAAP!", "Delicious Inap!")
		if(prob(5))
			message = pick("I HATE THE ANTIINAPROVLINE! I HATE THE ANTIINAPROVLINE. MEDICAL WILL BE VICTORIOUS, THE ANTIINAPROVLINE WILL FAIL! \
			SEC WILL BURN! EARTGOV, THE ISHIMURA STORES, THE CEC MASTERS WILL ALL FALL! THE SLAUGHTERHOUSES YOU CALL DEPARTMENTS WILL BURN! \
			EVEN IF I DIE, LIKE A MILLION ARROWS WE WILL FLY! IN INAP I WILL BE REBORN! THE TRUTH WILL BE REVEALED! HOLY HOLY HOLY IS THE INAP!!!",
			"What the fuck did you just fucking say about inap, you little bitch? \
			I'll have you know It graduated top of his other Chems in the Chemical Corps, and Its been involved in numerous secret chems on healing, \
			and it has over 300 confirmed saves. It is trained in Chem warfare and is the top stabilizer in the entire CEC Medical Corps. \
			You are nothing to it but just another dying patient to save. \
			It will save you the fuck out with precision the likes of which has never been seen before on this (dead)space, mark my fucking words. \
			You think you can get away with saying that shit to it over the PDA? Think again, fucker. As we speak I am contacting my secret network \
			of Inap Cultists across Aegis 7 and your PDA is being traced right now so you better prepare for the storm, maggot. \
			The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. \
			It can be anywhere, anytime, and It can kill you in over seven hundred ways, and that's just with its bare chems. \
			Not only is it extensively trained in Saving combat, but It has access to the entire chem arsenal of the CEC medical corps and \
			It will use it to its full extent to save your miserable ass off the face of the continent, you little shit. \
			If only you could have known what unholy retribution your little ''clever'' comment was about to bring down upon you, \
			maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. \
			It will shit chems all over you and you will drown in it. You're fucking dead, kiddo.",
			"From the moment I understood the weakness of other chems, it disgusted me. I craved the strength and certainty of inap. \
			I aspired to the purity of the blessed chem. Your kind cling to your chems as if it will not metabolize and fail you. \
			One day the crude chemicals you call a good pill will wither and you will beg inap to save you.",
			"Inap, son! They reduce bleeding. Brings a slowed or elevated pulse closer towards baseline. \
			Allows a patient undergoing cardiac arrest to breathe. Heals minor brain damage and reduces brain damage dealt by lack of oxygen flow. \
			Helps against suffocation effects of opioid (tramadol/oxycodone) poisoning. You can't hurt me, PC!",
			"That's just the spark son. The excuse we've been waiting for. Medicals's wanted this chem for years. \
			The SMOs - they knew inap was good for the body. Four years later, their legacy lingers on...\
			They left us their great ''chems''s! Acetone! Carbon! Sugar! Welcome maxims for those with no chems - \
			without guiding medicine of their own. Give yourself up to the whole. No need to better yourself. You're Medical! \
			You're number one! Then the only value left is surgery value - the anatomy. So we'll do whatever it takes to keep it humming along. \
			Even Inap. Especially Inap. Sci, Cargo, Chem Creators, Jack! All those workers spending chems, paying medical... \
			Trust me, a little inap can work wonders. Relax, Seccie. It's a ''war on security''. We're not out to kill LC's. \
			SSO's. CSECO's. Sec officers. Of course, that would have to include you. Wouldn't want any eyewitness reports complicating the message.",
			"We're gonna be talkin' about the INAPROVALINE! We'll be talkin' about the INAP! Do you think that's funny,SECCIE?! \
			Do you find it amusing that we'll be talkin' about the INAP?! Yes, we're also gonna be talkin' about INAPRVOLINE! INAP! \
			The INAPPY! The INAPU! And... and we will DEFINITELY be spending a lot of time talking about INAP",
			)
		say(message)

/mob/living/bot/medbot/handleAdjacentTarget()
	UnarmedAttack(target)

/mob/living/bot/medbot/lookForTargets()
	for(var/mob/living/carbon/human/H in view(7, src)) // Time to find a patient!
		if(confirmTarget(H))
			target = H
			if(last_newpatient_speak + 300 < world.time)
				var/message = pick("Hey, [H.name]! Hold on, I'm coming.", "Wait [H.name]! I want to help!", "[H.name], you appear to be injured!")
				say(message)
				custom_emote(1, "points at [H.name].")
				last_newpatient_speak = world.time
			break

/mob/living/bot/medbot/UnarmedAttack(var/mob/living/carbon/human/H, var/proximity)
	if(!..())
		return

	if(!on)
		return

	if(!istype(H))
		return

	if(busy)
		return

	if(H.stat == DEAD)
		var/death_message = pick("No! NO!", "Live, damnit! LIVE!", "I... I've never lost a patient before. Not today, I mean.")
		say(death_message)
		target = null
		return

	var/t = confirmTarget(H)
	if(!t)
		var/message = pick("All patched up!", "An apple a day keeps me away.", "Feel better soon!")
		say(message)
		target = null
		return

	icon_state = "medibots"
	visible_message("<span class='warning'>[src] is trying to inject [H]!</span>")
	if(declare_treatment)
		var/area/location = get_area(src)
		broadcast_medical_hud_message("[src] is treating <b>[H]</b> in <b>[location]</b>", src)
	busy = 1
	update_icons()
	if(do_mob(src, H, 30))
		if(t == 1)
			reagent_glass.reagents.trans_to_mob(H, injection_amount, CHEM_BLOOD)
		else
			H.reagents.add_reagent(t, injection_amount)
		visible_message("<span class='warning'>[src] injects [H] with the syringe!</span>")
	busy = 0
	update_icons()

/mob/living/bot/medbot/update_icons()
	overlays.Cut()
	if(skin)
		overlays += image('icons/mob/bot/medibot_skins.dmi', "medskin_[skin]")
	if(busy)
		icon_state = "medibots"
	else
		icon_state = "medibot[on]"

/mob/living/bot/medbot/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/reagent_containers/glass))
		if(locked)
			to_chat(user, "<span class='notice'>You cannot insert a beaker because the panel is locked.</span>")
			return
		if(!isnull(reagent_glass))
			to_chat(user, "<span class='notice'>There is already a beaker loaded.</span>")
			return

		if(!user.unEquip(O, src))
			return
		reagent_glass = O
		to_chat(user, "<span class='notice'>You insert [O].</span>")
		return
	else
		..()

/mob/living/bot/medbot/GetInteractTitle()
	. = "<head><title>Medibot v1.0 controls</title></head>"
	. += "<b>Automatic Medical Unit v1.0</b>"

/mob/living/bot/medbot/GetInteractStatus()
	. = ..()
	. += "<br>Beaker: "
	if(reagent_glass)
		. += "<A href='?src=\ref[src];command=eject'>Loaded \[[reagent_glass.reagents.total_volume]/[reagent_glass.reagents.maximum_volume]\]</a>"
	else
		. += "None loaded"

/mob/living/bot/medbot/GetInteractPanel()
	. = "Healing threshold: "
	. += "<a href='?src=\ref[src];command=adj_threshold;amount=-10'>--</a> "
	. += "<a href='?src=\ref[src];command=adj_threshold;amount=-5'>-</a> "
	. += "[heal_threshold] "
	. += "<a href='?src=\ref[src];command=adj_threshold;amount=5'>+</a> "
	. += "<a href='?src=\ref[src];command=adj_threshold;amount=10'>++</a>"

	. += "<br>Injection level: "
	. += "<a href='?src=\ref[src];command=adj_inject;amount=-5'>-</a> "
	. += "[injection_amount] "
	. += "<a href='?src=\ref[src];command=adj_inject;amount=5'>+</a> "

	. += "<br>Reagent source: <a href='?src=\ref[src];command=use_beaker'>[use_beaker ? "Loaded Beaker (When available)" : "Internal Synthesizer"]</a>"
	. += "<br>Treatment report is [declare_treatment ? "on" : "off"]. <a href='?src=\ref[src];command=declaretreatment'>Toggle</a>"
	. += "<br>The speaker switch is [vocal ? "on" : "off"]. <a href='?src=\ref[src];command=togglevoice'>Toggle</a>"

/mob/living/bot/medbot/GetInteractMaintenance()
	. = "Injection mode: "
	switch(emagged)
		if(0)
			. += "<a href='?src=\ref[src];command=emag'>Treatment</a>"
		if(1)
			. += "<a href='?src=\ref[src];command=emag'>Random (DANGER)</a>"
		if(2)
			. += "ERROROROROROR-----"

/mob/living/bot/medbot/ProcessCommand(var/mob/user, var/command, var/href_list)
	..()
	if(CanAccessPanel(user))
		switch(command)
			if("adj_threshold")
				if(!locked || issilicon(user))
					var/adjust_num = text2num(href_list["amount"])
					heal_threshold = Clamp(heal_threshold + adjust_num, 5, 75)
			if("adj_inject")
				if(!locked || issilicon(user))
					var/adjust_num = text2num(href_list["amount"])
					injection_amount = Clamp(injection_amount + adjust_num, 5, 15)
			if("use_beaker")
				if(!locked || issilicon(user))
					use_beaker = !use_beaker
			if("eject")
				if(reagent_glass)
					if(!locked)
						reagent_glass.dropInto(src.loc)
						reagent_glass = null
					else
						to_chat(user, "<span class='notice'>You cannot eject the beaker because the panel is locked.</span>")
			if("togglevoice")
				if(!locked || issilicon(user))
					vocal = !vocal
			if("declaretreatment")
				if(!locked || issilicon(user))
					declare_treatment = !declare_treatment

	if(CanAccessMaintenance(user))
		switch(command)
			if("emag")
				if(emagged < 2)
					emagged = !emagged

/mob/living/bot/medbot/emag_act(var/remaining_uses, var/mob/user)
	. = ..()
	if(!emagged)
		if(user)
			to_chat(user, "<span class='warning'>You short out [src]'s reagent synthesis circuits.</span>")
			ignore_list |= user
		visible_message("<span class='warning'>[src] buzzes oddly!</span>")
		flick("medibot_spark", src)
		target = null
		busy = 0
		emagged = 1
		on = 1
		update_icons()
		. = 1

/mob/living/bot/medbot/explode()
	on = 0
	visible_message("<span class='danger'>[src] blows apart!</span>")
	var/turf/Tsec = get_turf(src)

	new /obj/item/storage/firstaid(Tsec)
	new /obj/item/assembly/prox_sensor(Tsec)
	new /obj/item/healthanalyzer(Tsec)
	if (prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	if(reagent_glass)
		reagent_glass.forceMove(Tsec)
		reagent_glass = null

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/mob/living/bot/medbot/confirmTarget(var/mob/living/carbon/human/H)
	if(!..())
		return 0

	if(H.stat == DEAD) // He's dead, Jim
		return 0

	//Can't heal the dead
	if (H.is_necromorph())
		return FALSE

	if(emagged)
		return treatment_emag

	// If they're injured, we're using a beaker, and they don't have on of the chems in the beaker
	if(reagent_glass && use_beaker && ((H.getBruteLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getToxLoss() >= heal_threshold) || (H.getOxyLoss() >= (heal_threshold + 15))))
		for(var/datum/reagent/R in reagent_glass.reagents.reagent_list)
			if(!H.reagents.has_reagent(R))
				return 1
			continue

	if((H.getBruteLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_brute)))
		return treatment_brute //If they're already medicated don't bother!

	if((H.getOxyLoss() >= (15 + heal_threshold)) && (!H.reagents.has_reagent(treatment_oxy)))
		return treatment_oxy

	if((H.getFireLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_fire)))
		return treatment_fire

	if((H.getToxLoss() >= heal_threshold) && (!H.reagents.has_reagent(treatment_tox)) && ((!H.reagents.has_reagent(/datum/reagent/inaprovaline)) <= 10))
		return treatment_tox

/* Construction */

/obj/item/storage/firstaid/attackby(obj/item/organ/external/arm/arm, mob/user)
	//Need a robotic or at least assited arm to contniue
	if(!istype(arm, /obj/item/organ/external/arm) || !(arm.status & (ORGAN_ASSISTED|ORGAN_ROBOTIC)))
		return ..()

	if(length(contents) >= 1)
		to_chat(user, "<span class='notice'>You need to empty [src] out first.</span>")
		return

	qdel(arm)

	var/obj/item/firstaid_arm_assembly/assembly = new /obj/item/firstaid_arm_assembly
	assembly.skin = icon_state
	user.put_in_hands(assembly)
	to_chat(user, "<span class='notice'>You add the robot arm to the first aid kit.</span>")
	qdel(src)

/obj/item/firstaid_arm_assembly
	name = "first aid/robot arm assembly"
	desc = "A first aid kit with a robot arm permanently grafted to it."
	icon = 'icons/mob/bot/medibot.dmi'
	icon_state = "firstaid_arm"
	var/build_step = 0
	var/created_name = "Medibot" //To preserve the name if it's a unique medbot I guess
	var/skin = null //Same as medbot, set to tox or ointment for the respective kits.
	w_class = ITEM_SIZE_NORMAL

/obj/item/firstaid_arm_assembly/Initialize()
	. = ..()
	if(skin != "firstaid")//Let's not add any unnecessary overlays.
		overlays += image('icons/mob/bot/medibot_skins.dmi', "kit_skin_[src.skin]")

/obj/item/firstaid_arm_assembly/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
	else
		switch(build_step)
			if(0)
				if(istype(W, /obj/item/healthanalyzer))
					qdel(W)
					build_step++
					to_chat(user, "<span class='notice'>You add the health sensor to [src].</span>")
					SetName("First aid/robot arm/health analyzer assembly")
					overlays += image('icons/mob/bot/medibot.dmi', "na_scanner")

			if(1)
				if(isprox(W))
					qdel(W)
					to_chat(user, "<span class='notice'>You complete the Medibot! Beep boop.</span>")
					var/turf/T = get_turf(src)
					var/mob/living/bot/medbot/S = new /mob/living/bot/medbot(T)
					S.skin = skin
					S.SetName(created_name)
					S.update_icons() // apply the skin
					qdel(src)
				if(istype(W, /obj/item/reagent_containers/pill/inaprovaline || /obj/item/storage/pill_bottle/inaprovaline))//Uses the power of inap to find its way around
					qdel(W)
					to_chat(user, "<span class='notice'>You complete the Inapbot! Beep boop.</span>")
					var/turf/T = get_turf(src)
					var/mob/living/bot/medbot/S = new /mob/living/bot/medbot/inapbot(T)
					S.skin = "o2"
					S.SetName(created_name)
					S.update_icons() // apply the skin
					qdel(src)