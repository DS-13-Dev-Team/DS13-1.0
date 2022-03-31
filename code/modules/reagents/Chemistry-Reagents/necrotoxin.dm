/*
	Necrotoxin is a powerful poison injected by the Infector necromorph.
	It is slow acting but very powerful if left untreated. Given enough time, 10-15 units of it will probably kill someone
*/
/datum/reagent/toxin/necro
	name = "Necrotoxin"
	description = "A vile substance that gradually corrupts the body."
	taste_description = "rotting flesh"
	reagent_state = LIQUID
	color = "#4c3b34"
	strength = 5
	extension_type = /datum/extension/reagent/necrotoxin
	metabolism = REM * 0.125	//Slow acting poison, but really strong





/datum/extension/reagent/necrotoxin
	linger = 20 MINUTES

/datum/extension/reagent/necrotoxin/Initialize()
	RegisterSignal(holder, COMSIG_LIVING_DEATH, .proc/victim_died)


/datum/extension/reagent/necrotoxin/proc/victim_died()
	if (is_toxin_victim())
		addtimer(CALLBACK(holder, /mob/living/proc/start_necromorph_conversion), 1 MINUTE, TIMER_STOPPABLE)
/*
	This proc attempts to determine if the victim was successfully corrupted by the toxin
	Toxin only converts people whose primary cause of death was itself. People who suffer violent deaths shouldn't count
*/
/datum/extension/reagent/necrotoxin/proc/is_toxin_victim()
	var/mob/living/L = holder

	//If they were gibbed, dusted, or deleted, then they sure didn't die from poison. And they're invalid if not a mob too
	if (!istype(L))
		return FALSE

	//They have to be already dead of course
	if (L.stat != DEAD)
		return

	//Alright now we want to figure out if the poison actually caused their death. This is a complicated problem
	//We're going to go with a simple solution which is not 100% foolproof, but will cover most use cases:
	//IF their toxloss is higher than their total violent damage (brute+burn) then they probably died of poison. If not, violence
	var/violence = L.getBruteLoss() + L.getFireLoss()
	if (L.getToxLoss()	<=	violence)
		return

	var/mob/living/carbon/human/H
	if (ishuman(L))
		H = L

	if (H)
		//And lets see if they have their head. Decapitated victims cannot be converted
		if (!H.has_organ(BP_HEAD))
			return FALSE



	//Alright we're done, return true
	return TRUE



