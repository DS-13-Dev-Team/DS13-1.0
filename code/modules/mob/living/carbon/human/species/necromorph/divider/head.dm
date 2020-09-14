


/*
	Special head subtype, used only on puppets

*/
/obj/item/organ/external/head/simple/divider
	base_miss_chance = 45

/obj/item/organ/external/head/simple/divider/human
	icon_name = "head_human"


/obj/item/organ/external/head/simple/divider/New(var/mob/living/carbon/holder, var/datum/dna/given_dna)
	.=..()
	GLOB.death_event.register(holder, src, /obj/item/organ/external/head/simple/divider/proc/holder_death)



//It becomes a head mob again if severed
/obj/item/organ/external/head/simple/divider/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children, var/silent, var/atom/cutter)
	if (!QDELETED(src) && owner)
		create_divider_component(owner, 0)
		qdel(src)
		return
	.=..()

//Called when the holder dies. This is intended for death by methods other than decapitation
//It will be called in a decapitation case too, but one or more of the three vars below will prevent an infinite loop
/obj/item/organ/external/head/simple/divider/proc/holder_death()
	if (!QDELETED(src) && owner && divider_component_type)
		create_divider_component(owner, 0)
		qdel(src)
		return


/*
	Base Organ Code
*/

//If the divider player is still connected, they transfer control to the head
/obj/item/organ/external/head/create_divider_component(var/mob/living/carbon/human/H, var/deletion_delay)
	.=..()
	if (.)
		var/mob/living/simple_animal/necromorph/divider_component/L = .
		if (H && H.mind && H.client)
			H.mind.transfer_to(L)

		else
			//If the player can't take control, then we'll fetch someone from necroqueue
			L.get_controlling_player(TRUE)

		//Removing the head kills the divider's main body
		//We do a spawn then some checks here to prevent infinite loops
		spawn(1 SECOND)
			if (!QDELETED(H) && H.stat != DEAD)
				H.death()


/*
	Head Component mob

	The head does not autofill from queue normally, the mob controlling the divider will take over it
*/
/mob/living/simple_animal/necromorph/divider_component/head
	name = "head"
	icon_state = "head"

	melee_damage_lower = 4
	melee_damage_upper = 6
	attacktext = "whipped"
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 2
	leap_range = 4

	pain_sounds = list('sound/effects/creatures/necromorph/divider/component/head_pain_1.ogg',
	'sound/effects/creatures/necromorph/divider/component/head_pain_2.ogg')

	attack_sounds = list('sound/effects/creatures/necromorph/divider/component/head_attack_1.ogg',
	'sound/effects/creatures/necromorph/divider/component/head_attack_2.ogg')

/mob/living/simple_animal/necromorph/divider_component/head/Initialize()
	.=..()
	add_modclick_verb(KEY_CTRLALT, /mob/living/simple_animal/necromorph/divider_component/head/proc/takeover_verb)

/mob/living/simple_animal/necromorph/divider_component/head/get_controlling_player(var/fetch = FALSE)
	if (!fetch)
		return
	.=..()


//Inhabits the corpse of a headless human
/mob/living/simple_animal/necromorph/divider_component/head/proc/takeover_verb(var/mob/living/carbon/human/H)
	if (QDELETED(src) || !isturf(loc) || incapacitated(INCAPACITATION_FORCELYING))
		return //Prevent some edge cases

	if (H.get_organ(BP_HEAD))
		var/obj/item/organ/external/E = H.get_organ(BP_HEAD)
		if (!E.is_stump())
			to_chat(src, SPAN_DANGER("You can only take over a headless corpse."))
			return FALSE

	if (get_dist(src, H) > 1)
		to_chat(src, SPAN_DANGER("You must be within one tile"))
		return FALSE

	takeover(H)



/mob/living/simple_animal/necromorph/divider_component/head/proc/takeover(var/mob/living/carbon/human/H)
	//Safety checks done, we are past the point of no return


	//Remove any leftover head stump
	var/obj/item/organ/external/E = H.get_organ(BP_HEAD)
	if (E)
		E.removed()
		qdel(E)

	//TODO: Slithering sound

	//Create the head and pass in our dna
	var/list/new_organs = list()
	var/obj/item/organ/head = new /obj/item/organ/external/head/simple/divider/human(H, dna)
	head.owner = H
	head.replaced(H)
	new_organs += head

	//We must also create brain and eyes, and put them into the head
	var/obj/item/organ/brain = new /obj/item/organ/internal/brain/undead(H, dna)
	brain.owner = H
	brain.replaced(H, head)
	new_organs += brain

	var/obj/item/organ/eyes = new /obj/item/organ/internal/eyes(H, dna)
	eyes.owner = H
	eyes.replaced(H, head)
	new_organs += eyes

	var/datum/species/necromorph/divider/D = all_species[SPECIES_NECROMORPH_DIVIDER]

	for(var/obj/item/organ/O in new_organs)
		D.post_organ_rejuvenate(O)

	H.update_body()

	//Transfer our player
	mind.transfer_to(H)

	//Apply debuffs
	set_extension(H, /datum/extension/divider_puppet)

	//Wake me up inside
	H.resurrect()

	//Delete this mob
	qdel(src)


/*
	Puppet extension, permanant effect on the controlled mob
	Applies various penalties
		-20 ranged accuracy
		clumsy mutation (includes a farther -15 accuracy)
		-30% movespeed
		Chance to lurch when moving
		higher chance to lurch when bumping into things
*/
/datum/extension/divider_puppet
	var/mob/living/carbon/human/H
	flags = EXTENSION_FLAG_IMMEDIATE
	var/screen_rotated = FALSE
	statmods = list(STATMOD_RANGED_ACCURACY = -20,
	STATMOD_MOVESPEED_MULTIPLICATIVE = 0.70)

/datum/extension/divider_puppet/New(var/mob/newholder)
	.=..()
	H = newholder
	if (H.client)
		screen_rotation()

	H.mutations.Add(CLUMSY)
	GLOB.moved_event.register(H, src, /datum/extension/divider_puppet/proc/holder_moved)
	GLOB.bump_event.register(H, src, /datum/extension/divider_puppet/proc/holder_bump)

/datum/extension/divider_puppet/proc/holder_moved()
	if (prob(3))
		H.visible_message("[H] lurches around awkwardly")
		H.lurch()

/datum/extension/divider_puppet/proc/holder_bump(var/mover, var/obstacle)
	if (prob(10))
		H.visible_message("[H] bumps into [obstacle] and staggers off")
		H.lurch(get_dir(obstacle, H))

/datum/extension/divider_puppet/proc/screen_rotation()
	/*
	if (!H.client || screen_rotated)
		return

	screen_rotated = TRUE

	//Lets do some cool camera tricks
	var/matrix/M = matrix()
	M = M.Turn(rand(160, 200))
	H.client.transform = M
	spawn(50)
		if (H && H.client)
			H.visible_message("[H] adjusts its head upon the new body")
			animate(H.client, transform = matrix(), time = 2 SECONDS)
	*/


//TODO: Remove this
/client/verb/divider_and_corpse()
	new /mob/living/carbon/human/necromorph/divider(mob.loc)

	var/mob/living/carbon/human/H = new(mob.loc)
	var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
	head.droplimb()