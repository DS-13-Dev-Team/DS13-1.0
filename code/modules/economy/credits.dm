/obj/item/weapon/spacecash/ewallet
	name = "Credit Chip"
	desc = "A digital store of EarthGov ration seals, the universally recognized unit of exchange in EarthGov territories, ships, colonies and stations. "
	icon = 'icons/obj/economy.dmi'
	icon_state = "grey"
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/weapon/spacecash/ewallet/examine(mob/user)
	. = ..(user)
	if((user == loc) || (user in oview(2)))
		to_chat(user, SPAN_NOTICE("Chip's owner: [owner_name]. Credits remaining: [worth]."))

/obj/item/weapon/spacecash/ewallet/proc/set_worth(var/newval)
	worth = newval
	update_icon()

/obj/item/weapon/spacecash/ewallet/proc/modify_worth(var/newval)
	worth += newval
	update_icon()


/obj/item/weapon/spacecash/ewallet/update_icon()
	switch(worth)
		if(0)
			icon_state = "grey"
		if(1 to 500)
			icon_state = "gold"
		if(501 to 1000)
			icon_state = "green"
		if(1001 to 5000)
			icon_state = "blue"
		if(5001 to 10000)
			icon_state = "purple"
		if(10001 to INFINITY)
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

//Giving credits to a mob
/mob/proc/recieve_credits(var/amount, var/sender, var/origin_account, var/reason)
	var/datum/money_account/ECA = get_account()
	if (ECA)
		charge_to_account(ECA.account_number, sender, reason, sender, amount)
		return

	//Last fallback, create a new chip and give it to the mob
	var/obj/item/weapon/spacecash/ewallet/C = new /obj/item/weapon/spacecash/ewallet
	C.set_worth(amount)

	equip_to_storage_or_hands(C)
