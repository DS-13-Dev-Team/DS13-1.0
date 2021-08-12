// Quick and deliberate movements are not necessarily mutually exclusive
#define MOVE_INTENT_DELIBERATE 0x0001
#define MOVE_INTENT_EXERTIVE   0x0002
#define MOVE_INTENT_QUICK      0x0004
#define MOVE_INTENT_SILENT	   0x0008

/decl/move_intent
	var/name
	var/flags = 0
	var/move_delay = 1
	var/hud_icon_state
	var/step_value = 1

/decl/move_intent/proc/can_be_used_by(var/mob/user)
	if(flags & MOVE_INTENT_QUICK)
		return user.can_sprint()
	return TRUE

/decl/move_intent/stalk/can_be_used_by(var/mob/user)
	if(user.incapacitated(INCAPACITATION_ALL))
		return FALSE
	else
		return TRUE

/decl/move_intent/run/can_be_used_by(var/mob/user)
	if(user.incapacitated(INCAPACITATION_ALL) || user.get_extension(user, /datum/extension/stasis_effect))
		return FALSE
	else
		return user.can_sprint()

/decl/move_intent/stalk
	name = "Stalk"
	flags = MOVE_INTENT_DELIBERATE | MOVE_INTENT_SILENT
	hud_icon_state = "stalking"
	step_value = 0
	move_delay = STALK_DELAY


/decl/move_intent/walk
	name = "Walk"
	flags = MOVE_INTENT_DELIBERATE
	hud_icon_state = "walking"

/decl/move_intent/walk/Initialize()
	. = ..()
	move_delay = WALK_DELAY

/decl/move_intent/run
	name = "Run"
	flags = MOVE_INTENT_EXERTIVE | MOVE_INTENT_QUICK
	hud_icon_state = "running"
	step_value = 2
	move_delay = RUN_DELAY
