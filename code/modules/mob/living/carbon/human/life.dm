//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.

#define HUMAN_CRIT_TIME_CUSHION (10 MINUTES) //approximate time limit to stabilize someone in crit
#define HUMAN_CRIT_HEALTH_CUSHION (CONFIG_GET(number/health_threshold_crit) - CONFIG_GET(number/health_threshold_dead))

//The amount of damage you'll get when in critical condition. We want this to be a HUMAN_CRIT_TIME_CUSHION long deal.
//There are HUMAN_CRIT_HEALTH_CUSHION hp to get through, so (HUMAN_CRIT_HEALTH_CUSHION/HUMAN_CRIT_TIME_CUSHION) per tick.
//Breaths however only happen once every MOB_BREATH_DELAY life ticks. The delay between life ticks is set by the mob process.
#define HUMAN_CRIT_MAX_OXYLOSS ( MOB_BREATH_DELAY * process_schedule_interval("mob") * (HUMAN_CRIT_HEALTH_CUSHION/HUMAN_CRIT_TIME_CUSHION) )

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

#define RADIATION_SPEED_COEFFICIENT 0.025

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/phoron_alert = 0
	var/co2_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	var/temperature_alert = 0
	var/heartbeat = 0
	var/stamina = 100

/mob/living/carbon/human/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return

	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	..()

	if(life_tick%30==15)
		hud_updateflag = 1022

	voice = GetVoice()

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD && !InStasis())
		//Updates the number of stored chemicals for powers
		handle_changeling()

		//Organs and blood
		handle_organs()
		stabilize_body_temperature() //Body temperature adjusts itself (self-regulation)

		handle_shock()

		handle_pain()

		handle_stamina()

		handle_medical_side_effects()

		if(!client && !mind)
			species.handle_npc(src)


	if(!handle_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our name based on whether our face is obscured/disfigured
	SetName(get_visible_name())

/mob/living/carbon/human/get_stamina()
	return stamina

/mob/living/carbon/human/adjust_stamina(var/amt)
	var/last_stamina = stamina
	if(stat == DEAD)
		stamina = 0
	else
		stamina = Clamp(stamina + amt, 0, 100)
		if(stamina <= 0)
			to_chat(src, SPAN_WARNING("You are exhausted!"))
			if(MOVING_QUICKLY(src))
				set_moving_slowly()
	if(last_stamina != stamina && hud_used)
		hud_used.update_stamina()

/mob/living/carbon/human/proc/handle_stamina()
	if((world.time - last_quick_move_time) > 5 SECONDS)
		var/mod = (lying + (nutrition / initial(nutrition))) / 2
		adjust_stamina(max(MINIMUM_STAMINA_RECOVERY, MAXIMUM_STAMINA_RECOVERY * mod) * (1+chem_effects[CE_ENERGETIC]))

/mob/living/carbon/human/set_stat(var/new_stat)
	. = ..()
	if(stat)
		update_skin(1)

/mob/living/carbon/human/proc/handle_some_updates()
	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return FALSE
	return TRUE

/mob/living/carbon/human/breathe()
	var/species_organ = species.breathing_organ

	if(species_organ)
		var/active_breaths = 0
		var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species_organ]
		if(L)
			active_breaths = L.active_breathing
		..(active_breaths)

// Calculate how vulnerable the human is to under- and overpressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
/mob/living/carbon/human/proc/get_pressure_weakness()

	var/pressure_adjustment_coefficient = 1 // Assume no protection at first.

	if(wear_suit && (wear_suit.item_flags & ITEM_FLAG_STOPPRESSUREDAMAGE) && head && (head.item_flags & ITEM_FLAG_STOPPRESSUREDAMAGE)) // Complete set of pressure-proof suit worn, assume fully sealed.
		pressure_adjustment_coefficient = 0

		// Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure protection.
		if(istype(wear_suit,/obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				pressure_adjustment_coefficient += S.damage * 0.1

	pressure_adjustment_coefficient = min(1,max(pressure_adjustment_coefficient,0)) // So it isn't less than 0 or larger than 1.

	return pressure_adjustment_coefficient

// Calculate how much of the enviroment pressure-difference affects the human.
/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference

	// First get the absolute pressure difference.
	if(pressure < ONE_ATMOSPHERE) // We are in an underpressure.
		pressure_difference = ONE_ATMOSPHERE - pressure

	else //We are in an overpressure or standard atmosphere.
		pressure_difference = pressure - ONE_ATMOSPHERE

	if(pressure_difference < 5) // If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		// Otherwise calculate how much of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		// This is our relative difference.
		pressure_difference *= get_pressure_weakness()

	// The difference is always positive to avoid extra calculations.
	// Apply the relative difference on a standard atmosphere to get the final result.
	// The return value will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE - pressure_difference
	else
		return ONE_ATMOSPHERE + pressure_difference

/mob/living/carbon/human/handle_impaired_vision()
	..()
	//Vision
	var/obj/item/organ/vision
	if(species.vision_organ)
		vision = internal_organs_by_name[species.vision_organ]

	if(!species.vision_organ) // Presumably if a species has no vision organs, they see via some other means.
		eye_blind =  0
		blinded =    0
		eye_blurry = 0
	else if(!vision || (vision && !vision.is_usable()))   // Vision organs cut out or broken? Permablind.
		eye_blind =  1
		blinded =    1
		eye_blurry = 0	//No blur and blind at the same time, one or the other
	else
		//blindness
		if(!(sdisabilities & BLIND))
			if(equipment_tint_total >= TINT_BLIND)	// Covered eyes, heal faster
				eye_blurry = max(eye_blurry-2, 0)

/mob/living/carbon/human/handle_disabilities()
	..()
	if(stat != DEAD)
		if ((disabilities & COUGHING) && prob(5) && paralysis <= 1)
			unequip_item()
			spawn(0)
				emote("cough")

/mob/living/carbon/human/handle_mutations_and_radiation()
	if(getFireLoss())
		if((COLD_RESISTANCE in mutations) || (prob(1)))
			heal_organ_damage(0,1)

	// DNA2 - Gene processing.
	// The HULK stuff that was here is now in the hulk gene.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			gene.OnMobLife(src)

	radiation = Clamp(radiation,0,500)

	if(!radiation)
		if(species.appearance_flags & RADIATION_GLOWS)
			set_light(0)
	else
		if(species.appearance_flags & RADIATION_GLOWS)
			set_light(0.3, 0.1, max(1,min(20,radiation/20)), 2, species.get_flesh_colour(src))
		// END DOGSHIT SNOWFLAKE

		var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in internal_organs
		if (rad_organ && !rad_organ.is_broken())
			var/rads = radiation/25

			radiation -= rads
			nutrition += rads

			if (radiation < 2)
				radiation = 0

			nutrition = Clamp(nutrition, 0, 550)

			return

		var/damage = 0
		radiation -= 1 * RADIATION_SPEED_COEFFICIENT
		if(prob(25))
			damage = 2

		if (radiation > 50)
			damage = 2
			radiation -= 2 * RADIATION_SPEED_COEFFICIENT
			if(!isSynthetic())
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
					radiation -= 5 * RADIATION_SPEED_COEFFICIENT
					to_chat(src, "<span class='warning'>You feel weak.</span>")
					Weaken(3)
					if(!lying)
						emote("collapse")
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species.get_bodytype(src) == SPECIES_HUMAN) //apes go bald
					if((h_style != "Bald" || f_style != "Shaved" ))
						to_chat(src, "<span class='warning'>Your hair falls out.</span>")
						h_style = "Bald"
						f_style = "Shaved"
						update_hair()

		if (radiation > 75)
			damage = 3
			radiation -= 3 * RADIATION_SPEED_COEFFICIENT
			if(!isSynthetic())
				if(prob(5))
					take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
				if(prob(1))
					to_chat(src, "<span class='warning'>You feel strange!</span>")
					adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
					emote("gasp")
		if(radiation > 150)
			damage = 8
			radiation -= 4 * RADIATION_SPEED_COEFFICIENT

		damage = Floor(damage * (isSynthetic() ? 0.5 : species.radiation_mod))
		if(damage)
			adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
			//update health is called by adjustToxLoss
			if(!isSynthetic() && organs.len)
				var/obj/item/organ/external/O = pick(organs)
				if(istype(O)) O.add_autopsy_data("Radiation Poisoning", damage)

	/** breathing **/

/mob/living/carbon/human/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.item_flags & ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT))
		return
	if(glasses && (glasses.item_flags & ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT))
		return
	if(head && (head.item_flags & ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT))
		return
	..()

/mob/living/carbon/human/handle_post_breath(datum/gas_mixture/breath)
	..()
	//spread some viruses while we are at it
	if(breath && !internal && virus2.len > 0 && prob(10))
		for(var/mob/living/carbon/M in view(1,src))
			src.spread_disease_to(M)


/mob/living/carbon/human/get_breath_from_internal(volume_needed=STD_BREATH_VOLUME)
	if(internal)

		var/obj/item/weapon/tank/rig_supply
		if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = back
			if(!rig.offline && (rig.air_supply && internal == rig.air_supply))
				rig_supply = rig.air_supply

		if (!rig_supply && (!contents.Find(internal) || !((wear_mask && (wear_mask.item_flags & ITEM_FLAG_AIRTIGHT)) || (head && (head.item_flags & ITEM_FLAG_AIRTIGHT)))))
			internal = null

		if(internal)
			return internal.remove_air_volume(volume_needed)
		else if(hud_used.internals)
			hud_used.internals.icon_state = "internal0"
	return null

/mob/living/carbon/human/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return
	var/species_organ = species.breathing_organ
	if(!species_organ)
		return

	var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species_organ]
	if(!L || nervous_system_failure())
		failed_last_breath = 1
	else
		failed_last_breath = L.handle_breath(breath) //if breath is null or vacuum, the lungs will handle it for us
	return !failed_last_breath

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(!environment || (SPACERES in mutations))
		return

	//Stuff like the xenomorph's plasma regen happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure)

	//Check for contaminants before anything else because we don't want to skip it.
	for(var/g in environment.gas)
		if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && environment.gas[g] > gas_data.overlay_limit[g] + 1)
			pl_effects()
			break

	if(istype(src.loc, /turf/space)) //being in a closet will interfere with radiation, may not make sense but we don't model radiation for atoms in general so it will have to do for now.
		//Don't bother if the temperature drop is less than 0.1 anyways. Hopefully BYOND is smart enough to turn this constant expression into a constant
		if(bodytemperature > (0.1 * HUMAN_HEAT_CAPACITY/(HUMAN_EXPOSED_SURFACE_AREA*STEFAN_BOLTZMANN_CONSTANT))**(1/4) + COSMIC_RADIATION_TEMPERATURE)

			//Thermal radiation into space
			var/heat_gain = get_thermal_radiation(bodytemperature, HUMAN_EXPOSED_SURFACE_AREA, 0.5, SPACE_HEAT_TRANSFER_COEFFICIENT)

			var/temperature_gain = heat_gain/HUMAN_HEAT_CAPACITY
			bodytemperature += temperature_gain //temperature_gain will often be negative

	var/relative_density = (environment.total_moles/environment.volume) / (MOLES_CELLSTANDARD/CELL_VOLUME)
	if(relative_density > 0.02) //don't bother if we are in vacuum or near-vacuum
		var/loc_temp = environment.temperature

		if(adjusted_pressure < species.warning_high_pressure && adjusted_pressure > species.warning_low_pressure && abs(loc_temp - bodytemperature) < 20 && bodytemperature < species.heat_level_1 && bodytemperature > species.cold_level_1 && species.body_temperature)
			pressure_alert = 0
			return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
		var/temp_adj = 0
		if(loc_temp < bodytemperature)			//Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
		else if (loc_temp > bodytemperature)			//Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
		bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj*relative_density, BODYTEMP_HEATING_MAX)

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= getSpeciesOrSynthTemp(HEAT_LEVEL_1))
		//Body temperature is too hot.
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)	return TRUE	//godmode
		var/burn_dam = 0
		if(bodytemperature < getSpeciesOrSynthTemp(HEAT_LEVEL_2))
			burn_dam = HEAT_DAMAGE_LEVEL_1
		else if(bodytemperature < getSpeciesOrSynthTemp(HEAT_LEVEL_3))
			burn_dam = HEAT_DAMAGE_LEVEL_2
		else
			burn_dam = HEAT_DAMAGE_LEVEL_3
		take_overall_damage(burn=burn_dam, used_weapon = "High Body Temperature")
		fire_alert = max(fire_alert, 2)

	else if(bodytemperature <= getSpeciesOrSynthTemp(COLD_LEVEL_1))
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)	return TRUE	//godmode

		var/burn_dam = 0

		if(bodytemperature > getSpeciesOrSynthTemp(COLD_LEVEL_2))
			burn_dam = COLD_DAMAGE_LEVEL_1
		else if(bodytemperature > getSpeciesOrSynthTemp(COLD_LEVEL_3))
			burn_dam = COLD_DAMAGE_LEVEL_2
		else
			burn_dam = COLD_DAMAGE_LEVEL_3
		SetStasis(getCryogenicFactor(bodytemperature), STASIS_COLD)
		if(!chem_effects[CE_CRYO])
			take_overall_damage(burn=burn_dam, used_weapon = "Low Body Temperature")
			fire_alert = max(fire_alert, 1)

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)	return TRUE	//godmode

	if(adjusted_pressure >= species.hazard_high_pressure)
		var/pressure_damage = min( ( (adjusted_pressure / species.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(brute=pressure_damage, used_weapon = "High Pressure")
		pressure_alert = 2
	else if(adjusted_pressure >= species.warning_high_pressure)
		pressure_alert = 1
	else if(adjusted_pressure >= species.warning_low_pressure)
		pressure_alert = 0
	else if(adjusted_pressure >= species.hazard_low_pressure)
		pressure_alert = -1
	else
		take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
		if(getOxyLoss() < 55) // 11 OxyLoss per 4 ticks when wearing internals;    unconsciousness in 16 ticks, roughly half a minute
			adjustOxyLoss(4)  // 16 OxyLoss per 4 ticks when no internals present; unconsciousness in 13 ticks, roughly twenty seconds
		pressure_alert = -2

	return

/mob/living/carbon/human/proc/stabilize_body_temperature()
	// We produce heat naturally.
	if (species.passive_temp_gain)
		bodytemperature += species.passive_temp_gain

	// Robolimbs cause overheating too.
	if(robolimb_count)
		bodytemperature += round(robolimb_count/2)

	if (species.body_temperature == null || isSynthetic())
		return //this species doesn't have metabolic thermoregulation

	var/body_temperature_difference = species.body_temperature - bodytemperature

	if (abs(body_temperature_difference) < 0.5)
		return //fuck this precision

	if (on_fire)
		return //too busy for pesky metabolic regulation

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			nutrition -= 2
		var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
//		log_debug("Cold. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
//		log_debug("Norm. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt
	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		//We totally need a sweat system cause it totally makes sense...~
		var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
//		log_debug("Hot. Difference = [body_temperature_difference]. Recovering [recovery_amt]")
		bodytemperature += recovery_amt


/mob/living/carbon/human/handle_chemicals_in_body()

	chem_effects.Cut()

	if(status_flags & GODMODE)
		return FALSE

	if(isSynthetic())
		return

	if(reagents)
		if(touching) touching.metabolize()
		if(ingested) ingested.metabolize()
		if(bloodstr) bloodstr.metabolize()

	// Trace chemicals
	for(var/T in chem_doses)
		if(bloodstr.has_reagent(T) || ingested.has_reagent(T) || touching.has_reagent(T))
			continue
		var/datum/reagent/R = T
		chem_doses[T] -= initial(R.metabolism)*2
		if(chem_doses[T] <= 0)
			chem_doses -= T


	return //TODO: DEFERRED



//DO NOT CALL handle_statuses() from this proc, it's called from living/Life() as long as this returns a true value.
/mob/living/carbon/human/handle_regular_status_updates()
	if(!handle_some_updates())
		return FALSE

	if(status_flags & GODMODE)	return FALSE

	//SSD check, if a logged player is awake put them back to sleep!
	if(ssd_check() && species.get_ssd(src))
		Sleeping(2)
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		silent = 0
	else				//ALIVE. LIGHTS ARE ON

		if(hallucination_power)
			handle_hallucinations()

		if(get_shock() >= species.total_health)
			if(!stat)
				to_chat(src, "<span class='warning'>[species.halloss_message_self]</span>")
				src.visible_message("<B>[src]</B> [species.halloss_message]")
			Paralyse(10)

		if(paralysis || sleeping)
			blinded = 1
			set_stat(UNCONSCIOUS)
			animate_tail_reset()
			adjustHalLoss(-3)
			if(sleeping)
				handle_dreams()
				if (mind)
					//Are they SSD? If so we'll keep them asleep but work off some of that sleep var in case of stoxin or similar.
					if(client || sleeping > 3)
						AdjustSleeping(-1)
				if(prob(2) && !failed_last_breath && !isSynthetic())
					if(!paralysis)
						emote("snore")
					else
						emote("groan")
			if(prob(2) && is_asystole() && isSynthetic())
				visible_message(src, "<b>[src]</b> [pick("emits low pitched whirr","beeps urgently")]")
		//CONSCIOUS
		else
			set_stat(CONSCIOUS)

		// Check everything else.

		//Periodically double-check embedded_flag
		/*
		if(LAZYLEN(implants) && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = 0
		*/

		//Resting
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
			adjustHalLoss(-3)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			adjustHalLoss(-1)

		if (drowsyness > 0)
			drowsyness = max(0, drowsyness-1)
			eye_blurry = max(2, eye_blurry)
			if(drowsyness > 10)
				var/zzzchance = min(5, 5*drowsyness/30)
				if((prob(zzzchance) || drowsyness >= 60))
					if(stat == CONSCIOUS)
						to_chat(src, "<span class='notice'>You are about to fall asleep...</span>")
					Sleeping(5)

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

		//Note by nanako: Phoron contamination feature removed from here
		//Our setting doesnt have phoron, and this was terribly inefficient. it was also screwing up my debugging a seperate problem
		//If we need something like it, it can be reimplemented far better

		// nutrition decrease
		if (nutrition > 0)
			nutrition = max (0, nutrition - species.hunger_factor)

		if(stasis_value > 1 && drowsyness < stasis_value * 4)
			drowsyness += min(stasis_value, 3)
			if(!stat && prob(1))
				to_chat(src, "<span class='notice'>You feel slow and sluggish...</span>")

	return TRUE

/mob/living/carbon/human/handle_regular_hud_updates(var/update_vision = TRUE)
	if(hud_updateflag) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	// now handle what we see on our screen

	if(!..())
		return

	if(stat != DEAD)
		if(stat == UNCONSCIOUS && health < max_health/2)
			//Critical damage passage overlay
			var/severity = 0
			switch(health - max_health/2)
				if(-20 to -10)			severity = 1
				if(-30 to -20)			severity = 2
				if(-40 to -30)			severity = 3
				if(-50 to -40)			severity = 4
				if(-60 to -50)			severity = 5
				if(-70 to -60)			severity = 6
				if(-80 to -70)			severity = 7
				if(-90 to -80)			severity = 8
				if(-95 to -90)			severity = 9
				if(-INFINITY to -95)	severity = 10
			overlay_fullscreen("crit", /atom/movable/screen/fullscreen/crit, severity)
		else
			clear_fullscreen("crit")
			//Oxygen damage overlay
			if(getOxyLoss())
				var/severity = 0
				switch(getOxyLoss())
					if(10 to 20)		severity = 1
					if(20 to 25)		severity = 2
					if(25 to 30)		severity = 3
					if(30 to 35)		severity = 4
					if(35 to 40)		severity = 5
					if(40 to 45)		severity = 6
					if(45 to INFINITY)	severity = 7
				overlay_fullscreen("oxy", /atom/movable/screen/fullscreen/oxy, severity)
			else
				clear_fullscreen("oxy")

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + damageoverlaytemp
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/severity = 0
			switch(hurtdamage)
				if(10 to 25)		severity = 1
				if(25 to 40)		severity = 2
				if(40 to 55)		severity = 3
				if(55 to 70)		severity = 4
				if(70 to 85)		severity = 5
				if(85 to INFINITY)	severity = 6
			overlay_fullscreen("brute", /atom/movable/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")


		if(hud_used.nutrition_icon)
			switch(nutrition)
				if(450 to INFINITY)
					hud_used.nutrition_icon.icon_state = "nutrition0"
				if(350 to 450)
					hud_used.nutrition_icon.icon_state = "nutrition1"
				if(250 to 350)
					hud_used.nutrition_icon.icon_state = "nutrition2"
				if(150 to 250)
					hud_used.nutrition_icon.icon_state = "nutrition3"
				else
					hud_used.nutrition_icon.icon_state = "nutrition4"

		if(isSynthetic())
			var/obj/item/organ/internal/cell/C = internal_organs_by_name[BP_CELL]
			if (istype(C))
				var/chargeNum = Clamp(ceil(C.percent()/25), 0, 4)	//0-100 maps to 0-4, but give it a paranoid clamp just in case.
				cells.icon_state = "charge[chargeNum]"
			else
				cells.icon_state = "charge-empty"

		if(hud_used.pressure)
			hud_used.pressure.icon_state = "pressure[pressure_alert]"
		if(hud_used.toxin)
			if(phoron_alert)
				hud_used.toxin.icon_state = "tox1"
			else
				hud_used.toxin.icon_state = "tox0"
		if(hud_used.oxygen)
			if(oxygen_alert)
				hud_used.oxygen.icon_state = "oxy1"
			else
				hud_used.oxygen.icon_state = "oxy0"
		if(hud_used.fire)
			if(fire_alert)
				hud_used.fire.icon_state = "fire[fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
			else
				hud_used.fire.icon_state = "fire0"

		if(hud_used.bodytemp)
			if (!species)
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to INFINITY)
						hud_used.bodytemp.icon_state = "temp4"
					if(350 to 370)
						hud_used.bodytemp.icon_state = "temp3"
					if(335 to 350)
						hud_used.bodytemp.icon_state = "temp2"
					if(320 to 335)
						hud_used.bodytemp.icon_state = "temp1"
					if(300 to 320)
						hud_used.bodytemp.icon_state = "temp0"
					if(295 to 300)
						hud_used.bodytemp.icon_state = "temp-1"
					if(280 to 295)
						hud_used.bodytemp.icon_state = "temp-2"
					if(260 to 280)
						hud_used.bodytemp.icon_state = "temp-3"
					else
						hud_used.bodytemp.icon_state = "temp-4"
			else
				//TODO: precalculate all of this stuff when the species datum is created
				var/base_temperature = species.body_temperature
				if(base_temperature == null) //some species don't have a set metabolic temperature
					base_temperature = (getSpeciesOrSynthTemp(HEAT_LEVEL_1) + getSpeciesOrSynthTemp(COLD_LEVEL_1))/2

				var/temp_step
				if (bodytemperature >= base_temperature)
					temp_step = (getSpeciesOrSynthTemp(HEAT_LEVEL_1) - base_temperature)/4

					if (bodytemperature >= getSpeciesOrSynthTemp(HEAT_LEVEL_1))
						hud_used.bodytemp.icon_state = "temp4"
					else if (bodytemperature >= base_temperature + temp_step*3)
						hud_used.bodytemp.icon_state = "temp3"
					else if (bodytemperature >= base_temperature + temp_step*2)
						hud_used.bodytemp.icon_state = "temp2"
					else if (bodytemperature >= base_temperature + temp_step*1)
						hud_used.bodytemp.icon_state = "temp1"
					else
						hud_used.bodytemp.icon_state = "temp0"

				else if (bodytemperature < base_temperature)
					temp_step = (base_temperature - getSpeciesOrSynthTemp(COLD_LEVEL_1))/4

					if (bodytemperature <= getSpeciesOrSynthTemp(COLD_LEVEL_1))
						hud_used.bodytemp.icon_state = "temp-4"
					else if (bodytemperature <= base_temperature - temp_step*3)
						hud_used.bodytemp.icon_state = "temp-3"
					else if (bodytemperature <= base_temperature - temp_step*2)
						hud_used.bodytemp.icon_state = "temp-2"
					else if (bodytemperature <= base_temperature - temp_step*1)
						hud_used.bodytemp.icon_state = "temp-1"
					else
						hud_used.bodytemp.icon_state = "temp0"
	return TRUE

/mob/living/carbon/human/handle_random_events()
	// Puke if toxloss is too high
	if (species.can_vomit)
		var/vomit_score = 0
		for(var/tag in list(BP_LIVER,BP_KIDNEYS))
			var/obj/item/organ/internal/I = internal_organs_by_name[tag]
			if(I)
				vomit_score += I.damage
			else if (should_have_organ(tag))
				vomit_score += 45
		if(chem_effects[CE_TOXIN] || radiation)
			vomit_score += 0.5 * getToxLoss()
		if(chem_effects[CE_ALCOHOL_TOXIC])
			vomit_score += 10 * chem_effects[CE_ALCOHOL_TOXIC]
		if(chem_effects[CE_ALCOHOL])
			vomit_score += 10
		if(stat != DEAD && vomit_score > 25 && prob(10))
			spawn vomit(1, vomit_score, vomit_score/25)

	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == 1)
		var/turf/T = loc
		if(T.get_lumcount() <= LIGHTING_SOFT_THRESHOLD)
			playsound_local(src,pick(GLOB.scarySounds),50, 1, -1)

	var/area/A = get_area(src)
	if(client && world.time >= client.played + 600)
		A.play_ambience(src)
	if(stat == UNCONSCIOUS && world.time - l_move_time < 5 && prob(10))
		to_chat(src,"<span class='notice'>You feel like you're [pick("moving","flying","floating","falling","hovering")].</span>")

/mob/living/carbon/human/handle_stomach()
	spawn(0)
		for(var/a in stomach_contents)
			if(!(a in contents) || isnull(a))
				stomach_contents.Remove(a)
				continue
			if(iscarbon(a)|| isanimal(a))
				var/mob/living/M = a
				if(M.stat == DEAD)
					M.death(1)
					stomach_contents.Remove(M)
					qdel(M)
					continue
				if(life_tick % 3 == 1)
					if(!(M.status_flags & GODMODE))
						M.adjustBruteLoss(5)
					nutrition += 10

/mob/living/carbon/human/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()



/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/


/mob/living/carbon/human/proc/handle_hud_list()
	if (BITTEST(hud_updateflag, HEALTH_HUD))
		var/image/hud_overlay/holder = hud_list[HEALTH_HUD]
		if (!holder)
			holder = new /image/hud_overlay('icons/mob/hud_med.dmi', src, "100")

		if(stat == DEAD)
			holder.icon_state = "0" 	// X_X
		else if(is_asystole())
			holder.icon_state = "flatline"
		else
			holder.icon_state = "[pulse()]"
		hud_list[HEALTH_HUD] = holder

	if (BITTEST(hud_updateflag, LIFE_HUD) && hud_list[LIFE_HUD])


		var/image/hud_overlay/holder = hud_list[LIFE_HUD]
		if (!holder)
			holder = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")

		if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		hud_list[LIFE_HUD] = holder

	if (BITTEST(hud_updateflag, STATUS_HUD))


		var/foundVirus = 0
		for (var/ID in virus2)
			if (ID in virusDB)
				foundVirus = 1
				break

		var/image/hud_overlay/holder = hud_list[STATUS_HUD]
		if (!holder)
			holder = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")

		if(stat == DEAD)
			holder.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
		else if(foundVirus)
			holder.icon_state = "hudill"
		else if(has_brain_worms())
			var/mob/living/simple_animal/borer/B = has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"
		else
			holder.icon_state = "hudhealthy"

		var/image/hud_overlay/holder2 = hud_list[STATUS_HUD_OOC]
		if (!holder2)
			holder2 = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudhealthy")
		if(stat == DEAD)
			holder2.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder2.icon_state = "hudxeno"
		else if(has_brain_worms())
			holder2.icon_state = "hudbrainworm"
		else if(virus2.len)
			holder2.icon_state = "hudill"
		else
			holder2.icon_state = "hudhealthy"

		hud_list[STATUS_HUD] = holder
		hud_list[STATUS_HUD_OOC] = holder2

	if (BITTEST(hud_updateflag, ID_HUD))
		var/image/hud_overlay/holder = hud_list[ID_HUD]
		if (!holder)
			holder = new /image/hud_overlay(GLOB.using_map.id_hud_icons, src, "hudunknown")
		holder.icon_state = "hudunknown"
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetIdCard()
			if(I)
				var/datum/job/J = job_master.GetJob(I.GetJobName())
				if(J)
					holder.icon_state = J.hud_icon

		hud_list[ID_HUD] = holder

	if (BITTEST(hud_updateflag, WANTED_HUD))
		var/image/hud_overlay/holder = hud_list[WANTED_HUD]
		if (!holder)
			holder = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")

		holder.icon_state = "hudblank"
		var/perpname = name
		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetIdCard()
			if(I)
				perpname = I.registered_name

		var/datum/computer_file/report/crew_record/E = get_crewmember_record(perpname)
		if(E)
			switch(E.get_criminalStatus())
				if("Arrest")
					holder.icon_state = "hudwanted"
				if("Incarcerated")
					holder.icon_state = "hudprisoner"
				if("Parolled")
					holder.icon_state = "hudparolled"
				if("Released")
					holder.icon_state = "hudreleased"
		hud_list[WANTED_HUD] = holder

	if (  BITTEST(hud_updateflag, IMPLOYAL_HUD) \
	   || BITTEST(hud_updateflag,  IMPCHEM_HUD) \
	   || BITTEST(hud_updateflag, IMPTRACK_HUD))

		var/image/hud_overlay/holder1 = hud_list[IMPTRACK_HUD]
		if (!holder1)
			holder1 = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
		var/image/hud_overlay/holder2 = hud_list[IMPLOYAL_HUD]
		if (!holder2)
			holder2 = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
		var/image/hud_overlay/holder3 = hud_list[IMPCHEM_HUD]
		if (!holder3)
			holder3 = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")

		holder1.icon_state = "hudblank"

		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"

		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				if(istype(I,/obj/item/weapon/implant/loyalty))
					holder2.icon_state = "hud_imp_loyal"
				if(istype(I,/obj/item/weapon/implant/chem))
					holder3.icon_state = "hud_imp_chem"

		hud_list[IMPTRACK_HUD] = holder1
		hud_list[IMPLOYAL_HUD] = holder2
		hud_list[IMPCHEM_HUD]  = holder3

	if (BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/hud_overlay/holder = hud_list[SPECIALROLE_HUD]
		if (!holder)
			holder = new /image/hud_overlay('icons/mob/hud.dmi', src, "hudblank")
		holder.icon_state = "hudblank"
		if(mind && mind.special_role)
			if(GLOB.hud_icon_reference[mind.special_role])
				holder.icon_state = GLOB.hud_icon_reference[mind.special_role]
			else
				holder.icon_state = "hudsyndicate"
			hud_list[SPECIALROLE_HUD] = holder
	hud_updateflag = 0

/mob/living/carbon/human/handle_stunned()
	return ..()

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/burn_temperature = fire_burn_temperature()
	var/thermal_protection = get_heat_protection(burn_temperature)

	if (thermal_protection < 1 && bodytemperature < burn_temperature)
		bodytemperature += round(BODYTEMP_HEATING_MAX*(1-thermal_protection), 1)

	var/species_heat_mod = 1

	var/protected_limbs = get_heat_protection_flags(burn_temperature)


	if(species)
		if(burn_temperature < species.heat_level_2)
			species_heat_mod = 0.5
		else if(burn_temperature < species.heat_level_3)
			species_heat_mod = 0.75

	burn_temperature -= species.heat_level_1

	if(burn_temperature < 1)
		return

	for(var/obj/item/organ/external/E in organs)
		if(!(E.body_part & protected_limbs) && prob(20))
			E.take_external_damage(burn = round(species_heat_mod * log(10, (burn_temperature + 10)), 0.1), used_weapon = hud_used.fire)

/mob/living/carbon/human/rejuvenate()

	//If the mob was dead and is being rejuvenated, then an admin is probably undoing their death. In this case we'll undo the dead status in the database as well, set them back to living
	if (stat == DEAD && mind && mind.character_id)
		character_spawned(mind)
	restore_blood()
	full_prosthetic = null
	shock_stage = 0
	..()

/mob/living/carbon/human/reset_view(atom/A)
	..()
	if(machine_visual && machine_visual != A)
		machine_visual.remove_visual(src)

/mob/living/carbon/human/handle_vision()
	if(client)
		client.screen.Remove(GLOB.global_hud.nvg, GLOB.global_hud.thermal, GLOB.global_hud.meson, GLOB.global_hud.science)
	if(machine)
		var/viewflags = machine.check_eye(src)
		machine.apply_visual(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			set_sight(sight|viewflags)
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else
		var/isRemoteObserve = 0
		if(z_eye)
			isRemoteObserve = 1
		else if((mRemote in mutations) && remoteview_target)
			if(remoteview_target.stat == CONSCIOUS)
				isRemoteObserve = 1
		if(!isRemoteObserve && client && !client.adminobs)
			remoteview_target = null
			reset_view(null, 0)

	update_equipment_vision()

	//Stop doing this every tick
	//species.handle_vision(src)
