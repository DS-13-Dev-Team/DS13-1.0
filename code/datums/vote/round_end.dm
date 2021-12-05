#define CHOICE_END "This is the end"
#define CHOICE_CONTINUE "A glimmer of hope remains"

/datum/vote/extinction
	name = "extinction"
	question = "It looks like the humans are almost all dead, escape seems unlikely. End the round and declare Necromorph Victory?\
	This poll will repeat every fifteen minutes."
	choices = list(CHOICE_END, CHOICE_CONTINUE)

/datum/vote/extinction/can_run(mob/creator, automatic)
	if(!automatic && !is_admin(creator))
		return FALSE // Admins and autovotes bypass the config setting.
	return ..()

/datum/vote/extinction/report_result()
	if(..())
		return 1
	if(result[1] == choices[1])
		SSticker.force_ending = TRUE

#undef CHOICE_END
#undef CHOICE_CONTINUE
