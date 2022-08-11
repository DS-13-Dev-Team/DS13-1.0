GLOBAL_LIST_INIT(peng_slogans, list("I Want More Peng!",
"There's Always Peng!",
"Peng Me Again!",
"I give great peng!",
"The one, the only..",
"Relax",
"Just for you",
"I love my Peng",
"Everyone wants Peng",
"Delicious Peng",
"There's something about Peng"))
GLOBAL_DATUM(peng, /obj/item/peng)
#define PENG_BOUNTY	10000

//Only one peng can exist at a time until it is claimed
/obj/item/peng
	name = "Peng"
	icon = 'icons/obj/economy.dmi'

	var/claimed = FALSE
	force = 25	//Its pretty good to whack people with
	throwforce = 25
	w_class = ITEM_SIZE_HUGE //Cumbersome, just because
	mass = 20
	attack_verb = list("smashed", "beaten", "slammed", "smacked", "struck", "battered", "bonked")
	hitsound = 'sound/weapons/genhit3.ogg'

/obj/item/peng/Initialize()
	.=..()
	//If there's an existing unclaimed peng, then cancel this
	if (GLOB.peng && !GLOB.peng.claimed)
		//Replace with normal loot
		new /obj/random/rare_loot/pengless(loc)
		return INITIALIZE_HINT_QDEL

	GLOB.peng = src
	desc = pick(GLOB.peng_slogans)
	icon_state = pick("peng1","peng2","peng3","peng4","peng5","peng6","peng7", "pengmatic")
	log_admin("Peng spawned at [jumplink(src)]")

/obj/item/peng/pickup(var/mob/living/user as mob)
	if (user)
		claim(user)

/obj/item/peng/proc/claim(var/mob/living/user)
	if (claimed)
		return

	claimed = TRUE
	visible_message("Congratulations! You've found peng. Turn her in at a store to redeem a reward.")
	command_announcement.Announce("Peng has been found by [user.real_name] at [loctext(user)], please congratulate them. But remember, there's always More Peng!\n\
	 This has been a cross-promotional announcement from Peng corp.", desc)

	//Lets make a new Peng
	var/turf/T = pick(GLOB.loot_locations)
	new /obj/item/peng(T)