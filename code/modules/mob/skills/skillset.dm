//Holder for skill information for mobs.

/datum/skillset
	var/skill_list = list()
	var/mob/owner
	var/default_value = SKILL_DEFAULT
	var/skills_transferable = TRUE
	var/list/skill_buffs                                            // A list of /datum/skill_buff being applied to the skillset.
	var/list/skill_verbs                                            // A list of skill-related verb datums.
	var/nm_type = /datum/nano_module/skill_ui
	var/datum/nano_module/skill_ui/NM
	var/list/nm_viewing

/datum/skillset/New(mob/mob)
	owner = mob
	for(var/datum/skill_verb/SV in GLOB.skill_verbs)
		if(SV.should_have_verb(src))
			SV.give_to_skillset(src)
	..()

/datum/skillset/Destroy()
	owner = null
	QDEL_NULL_LIST(skill_buffs)
	QDEL_NULL_LIST(skill_verbs)
	QDEL_NULL_LIST(nm_viewing)
	QDEL_NULL(NM)
	. = ..()

/datum/skillset/proc/get_value(skill_path)
	. = skill_list[skill_path] || default_value
	for(var/datum/skill_buff/SB in skill_buffs)
		. += SB.buffs[skill_path]

/datum/skillset/proc/obtain_from_mob(mob/mob)
	if(!istype(mob) || !skills_transferable || !mob.skillset?.skills_transferable)
		return
	skill_list = mob.skillset.skill_list
	default_value = mob.skillset.default_value
	skill_buffs = mob.skillset.skill_buffs
	nm_type = mob.skillset.nm_type
	QDEL_NULL(NM) //Clean all nano_modules for simplicity.
	QDEL_NULL(mob.skillset.NM)
	QDEL_NULL_LIST(nm_viewing)
	QDEL_NULL_LIST(mob.skillset.nm_viewing)

	update_verbs()

//Called when a player is added as an antag and the antag datum processes the skillset.
/datum/skillset/proc/on_antag_initialize()
	update_verbs()
	refresh_uis()

/datum/skillset/proc/obtain_from_client(datum/job/job, client/given_client, override = 0)
	if(!skills_transferable)
		return
	if(!override && owner.mind && player_is_antag(owner.mind))		//Antags are dealt with at a different time. Note that this may be called before or after antag roles are assigned.
		return
	if(!given_client)
		return

	skill_list = list()

	for(var/decl/hierarchy/skill/S in GLOB.skills)
		var/min = job.min_skill[S.type]
		skill_list[S.type] = min(max(min+background_value(given_client, S.ID),SKILL_MIN), SKILL_MAX)

	update_verbs()
	refresh_uis()

/datum/skillset/bst
	skill_list = list(
		SKILL_EVA			= SKILL_MAX,
		SKILL_HAULING		= SKILL_MAX,
		SKILL_ATHLETICS		= SKILL_MAX,
		SKILL_COMPUTER		= SKILL_MAX,
		SKILL_COOKING		= SKILL_MAX,
		SKILL_COMBAT		= SKILL_MAX,
		SKILL_WEAPONS		= SKILL_MAX,
		SKILL_CONSTRUCTION	= SKILL_MAX,
		SKILL_ELECTRICAL	= SKILL_MAX,
		SKILL_MEDICAL		= SKILL_MAX,
		SKILL_ANATOMY		= SKILL_MAX,
		SKILL_DEVICES		= SKILL_MAX,
		SKILL_BOTANY		= SKILL_MAX,
		SKILL_FORENSICS		= SKILL_MAX
	)
	default_value = SKILL_MAX
	skills_transferable = FALSE


// Show skills verb

mob/living/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	skillset.open_ui()

datum/skillset/proc/open_ui()
	if(!owner)
		return
	if(!NM)
		NM = new nm_type(owner)
	NM.ui_interact(owner)

datum/skillset/proc/refresh_uis()
	for(var/nano_module in nm_viewing)
		SSnano.update_uis(nano_module)