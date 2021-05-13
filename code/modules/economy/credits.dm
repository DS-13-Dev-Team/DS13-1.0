/obj/item/weapon/spacecash/ewallet
	name = "Credit Chip"
	desc = "A digital store of EarthGov ration seals, the universally recognized unit of exchange in EarthGov territories, ships, colonies and stations. "
	icon_state = "efundcard"
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.

/obj/item/weapon/spacecash/ewallet/examine(mob/user)
	. = ..(user)
	if (!(user in view(2)) && user!=src.loc) return
	to_chat(user, "<span class='notice'>Chip's owner: [src.owner_name]. Credits remaining: [src.worth].</span>")


/*
	Random credit chips used in loot
*/
/obj/item/weapon/spacecash/ewallet/random/Initialize()
	.=..()
	worth = round(rand_between(initial(worth)*0.5, initial(worth)*1.5), 1)

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