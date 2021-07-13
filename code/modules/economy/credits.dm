/obj/item/weapon/spacecash/ewallet
	name = "Credit Chip"
	desc = "A digital store of EarthGov ration seals, the universally recognized unit of exchange in EarthGov territories, ships, colonies and stations. "
	icon = 'icons/obj/economy.dmi'
	icon_state = "grey"
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

//When a credit chip is picked up or dropped, we need to flag the holding mob as having possibly changed their wealth
/obj/item/weapon/spacecash/ewallet/Initialize()
	.=..()
	//Note that these are imperfect, if people start putting chips into containers then passing those around things might get out of sync
	GLOB.item_equipped_event.register(src, src, /obj/item/weapon/spacecash/ewallet/proc/on_equip)
	GLOB.item_unequipped_event.register(src, src, /obj/item/weapon/spacecash/ewallet/proc/on_equip)

/obj/item/weapon/spacecash/ewallet/proc/on_equip()
	world << "Credits moved [worth]"
	credits_changed()

/obj/item/weapon/spacecash/ewallet/examine(mob/user)
	. = ..(user)
	if (!(user in view(2)) && user!=src.loc) return
	to_chat(user, "<span class='notice'>Chip's owner: [src.owner_name]. Credits remaining: [src.worth].</span>")

/obj/item/weapon/spacecash/ewallet/proc/set_worth(var/newval)
	worth = newval
	update_icon()

/obj/item/weapon/spacecash/ewallet/proc/modify_worth(var/newval)
	worth += newval
	update_icon()


/obj/item/weapon/spacecash/ewallet/update_icon()
	icon_state = "grey"
	switch(worth)
		if (1 to 500)
			icon_state = "gold"
		if (501 to 1000)
			icon_state = "green"
		if (1001 to 5000)
			icon_state = "blue"
		if (5001 to 10000)
			icon_state = "purple"
		if (10001 to INFINITY)
			icon_state = "orange"

/*
	Random credit chips used in loot
*/
/obj/item/weapon/spacecash/ewallet/random/Initialize()
	.=..()
	set_worth(round(rand_between(initial(worth)*0.5, initial(worth)*1.5), 1))

/obj/item/weapon/spacecash/ewallet/random/c200
	worth = 200

/obj/item/weapon/spacecash/ewallet/random/c500
	worth = 500

/obj/item/weapon/spacecash/ewallet/random/c1000
	worth = 1000

/obj/item/weapon/spacecash/ewallet/random/c5000
	worth = 5000

/obj/item/weapon/spacecash/ewallet/random/c10000
	worth = 10000









//Helpers
/datum/proc/credits_recieved(var/balance, var/datum/source)
	return TRUE


/mob/proc/get_carried_credits()
	. = 0



	for (var/obj/item/weapon/spacecash/ewallet/C as anything in get_carried_credit_chips())
		. += C.worth

/mob/living/carbon/human/get_carried_credits()
	.=..()
	if (wearing_rig)
		. += wearing_rig.get_account_balance()

/mob/proc/get_carried_credit_chips()
	//Get everything we're carrying recursively
	var/list/things = src.get_contents()
	. = list()
	for (var/obj/item/weapon/spacecash/ewallet/C in things)
		. += C


//Giving credits to a mob
/mob/proc/recieve_credits(var/amount, var/sender, var/origin_account, var/reason)
	var/datum/money_account/ECA = get_account()
	if (ECA)
		charge_to_account(ECA.account_number, sender, reason, sender, amount)
		return

	var/datum/money_account/rig_account = get_rig_account()
	if (rig_account)
		charge_to_account(rig_account.account_number, sender, reason, sender, amount)
		return


	var/list/chips = get_carried_credit_chips()
	for (var/obj/item/weapon/spacecash/ewallet/C in chips)
		C.modify_worth(amount)
		return


	//Last fallback, create a new chip and give it to the mob
	var/obj/item/weapon/spacecash/ewallet/C = new /obj/item/weapon/spacecash/ewallet
	C.set_worth(amount)

	equip_to_storage_or_hands(C)