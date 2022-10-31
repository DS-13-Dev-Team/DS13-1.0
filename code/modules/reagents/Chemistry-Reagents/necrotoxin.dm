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
	overdose = 100 //Basically impossible to OD on, but turns into a worse toxin
	extension_type = /datum/extension/reagent/necrotoxin
	metabolism = REM * 0.125	//Slow acting poison, but really strong

/datum/reagent/toxin/necro/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	M.reagents.remove_reagent(/datum/reagent/dylovene, removed) // Requires the occasional extra dose of dylovene
	if(volume > 45) // Short lived effect, warns the player that they've taken too much necrotox in a short period of time.
		M.add_chemical_effect(CE_SLOWDOWN, 2)
		M.reagents.remove_reagent(/datum/reagent/toxin/necro, 50 * removed) //Rapidly converts necrotoxin into a worse variant
		M.reagents.add_reagent(/datum/reagent/toxin/necro_lethal, 25 * removed)
		if(prob(75))
			M.emote("scream");
			to_chat(M, "<span class='notice'>Your insides briefly twist and burn! Something's wrong!.</span>")

/datum/reagent/toxin/necro_lethal
	name = "Necrax toxin"
	description = "A much deadlier variant of the enigmatic, corrupting substance."
	taste_description = "corpse bile"
	reagent_state = LIQUID
	color = "#bd3c3c"
	strength = 10
	overdose = 6 //Technically it takes 62+ necrotox to get a deadly dose here! Difficult to cure without dialysis
	extension_type = /datum/extension/reagent/necrotoxin/lethal
	metabolism = REM * 0.125

/datum/reagent/toxin/necro_lethal/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_TOXIN, 1.5) // damages the liver directly, should the liver die, recovery is unlikely
	M.heal_organ_damage(0.25, 0.25) //heals you! This makes a necro conversion far more likely.
	M.adjustToxLoss(REM * 4) // 500% base strength, or 10x as strong as normal necrotoxin
	M.reagents.remove_reagent(/datum/reagent/dylovene, 0.25) // Purges dylovene slowly
	if (effect_extension)
		effect_extension.overdose()
	return

/datum/reagent/toxin/necro_monkey
	name = "Necrotoxin Simianis"
	description = "A malformed vile corruption, appears to struggle to survive in any body except that of a monkey."
	taste_description = "rotting flesh"
	reagent_state = LIQUID
	color = "#4c3b34"
	strength = 5
	overdose = 100
	extension_type = /datum/extension/reagent/necrotoxin/monkey
	metabolism = REM * 0.125

/datum/reagent/toxin/necro_monkey/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	if(volume < 4)
		M.reagents.remove_reagent(/datum/reagent/toxin/necro_monkey, 50 * removed) //doesn't work in low doses! No powergaming with blood extraction!
	if (!istype(M.species, /datum/species/monkey))
		M.reagents.del_reagent(/datum/reagent/toxin/necro_monkey) //doesn't work on humans, only monkeys!
	else
		M.adjustBrainLoss(REM * 10) //Absolutely murders monkeys
		M.adjustToxLoss(REM * 15)

/obj/item/reagent_containers/hypospray/autoinjector/necro // adminspawn only
	name = "Rugged Autoinjector"
	desc = "A special model autoinjector, what goodies does this contain?"
	icon_state = "unitologist"
	amount_per_transfer_from_this = 15
	volume = 15
	starts_with = list(/datum/reagent/toxin/necro = 15)

/obj/item/reagent_containers/hypospray/autoinjector/necro/lethal // adminspawn only
	starts_with = list(/datum/reagent/toxin/necro_lethal = 15)

/obj/item/reagent_containers/hypospray/autoinjector/necro/monkey
	desc = "A special model autoinjector, what goodies does this contain? It has a tiny sticker of a cartoony monkey head on the handle."
	starts_with = list(/datum/reagent/toxin/necro_monkey = 15)

/datum/extension/reagent/necrotoxin
	linger = 20 MINUTES

/datum/extension/reagent/necrotoxin/lethal
	linger = 2 MINUTES //Can be treated with dialysis. Note, this extends to the OD effect, hence it's so short.

/datum/extension/reagent/necrotoxin/monkey
	linger = 1 SECOND // Won't linger at all, pretty much. Mostly so you can't use it on humans at all.

/datum/extension/reagent/necrotoxin/Initialize()
	RegisterSignal(holder, COMSIG_LIVING_DEATH, .proc/victim_died)


/datum/extension/reagent/necrotoxin/proc/victim_died()
	SIGNAL_HANDLER
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
	var/violence = (L.getBruteLoss() + L.getFireLoss()) * 0.5 //It's actually pretty hard to trigger this, this will make it a bit easier
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



