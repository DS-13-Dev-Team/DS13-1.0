/obj/item/weapon/spacecash
	name = "credits"
	desc = "It's worth something. Probably."
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash"
	force = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_TINY
	var/worth = 0
	var/coin_icons = TRUE


/obj/item/weapon/spacecash/minercash
	name = "merits"
	icon_state = "minercash"
	coin_icons = FALSE


/obj/item/weapon/spacecash/Destroy()
	worth = 0
	. = ..()


/obj/item/weapon/spacecash/update_icon()
	cut_overlays()
	icon_state = initial(icon_state)
	var/remaining_worth = worth
	var/iteration = 0
	var/coins_only = TRUE
	var/list/coin_denominations = list(10, 5, 1)
	var/list/banknote_denominations = list(1000, 500, 200, 100, 50, 20)
	for(var/i in banknote_denominations)
		while(remaining_worth >= i && iteration < 50)
			remaining_worth -= i
			iteration++
			var/image/banknote = image('icons/obj/items.dmi', "[icon_state][i]")
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			banknote.transform = M
			overlays += banknote
			coins_only = FALSE

	if(remaining_worth)
		for(var/i in coin_denominations)
			while(remaining_worth >= i && iteration < 50)
				remaining_worth -= i
				iteration++
				var/image/coin = image('icons/obj/items.dmi', "[icon_state][i]")
				var/matrix/M = matrix()
				M.Translate(rand(-6, 6), rand(-4, 8))
				coin.transform = M
				overlays += coin

	if(coins_only && coin_icons)
		if(worth == 1)
			name = "coin"
			desc = "A single credit."
			gender = NEUTER
		else
			name = "coins"
			desc = "Total of [worth] credits."
			gender = PLURAL
	else
		name = "[worth] [initial(name)]" // 123 credits/merits
		desc = "Cold hard cash."
		gender = NEUTER
	icon_state = ""

/obj/item/weapon/spacecash/attackby(obj/item/weapon/spacecash/S, mob/living/carbon/human/H)
	if(ispath(S.type, type))
		worth += S.worth
		update_icon()
		to_chat(H, SPAN_NOTICE("You add [S.name] to the bundle.<br>It holds [name] now."))
		H.unEquip(S)
		qdel(S)


/obj/item/weapon/spacecash/attack_self(mob/user)
	var/amount = input(user, "How many credits do you want to take? (0 to [worth])", "Take Money", 20) as num
	amount = round(CLAMP(amount, 0, worth))
	if(!amount)
		return

	worth -= amount
	if(!worth)
		user.unEquip(src)
		qdel(src)

	var/obj/item/weapon/spacecash/S
	if(istype(src, /obj/item/weapon/spacecash/minercash))
		S = new /obj/item/weapon/spacecash/minercash(user.loc)
	else
		S = new(user.loc)
	S.worth = amount
	S.update_icon()
	user.put_in_hands(S)
	update_icon()


/obj/item/weapon/spacecash/Initialize()
	. = ..()
	update_icon()


/obj/item/weapon/spacecash/proc/getMoneyImages()
	if(icon_state)
		return list(icon_state)


/obj/item/weapon/spacecash/c1
	worth = 1

/obj/item/weapon/spacecash/c10
	worth = 10

/obj/item/weapon/spacecash/c20
	worth = 20

/obj/item/weapon/spacecash/c50
	worth = 50

/obj/item/weapon/spacecash/c100
	worth = 100

/obj/item/weapon/spacecash/c200
	worth = 200

/obj/item/weapon/spacecash/c500
	worth = 500

/obj/item/weapon/spacecash/c1000
	worth = 1000

/obj/item/weapon/spacecash/c10000
	worth = 10000


/proc/spawn_money(sum, spawnloc, mob/living/carbon/human/H)
	if(sum <= 0)
		return
	var/obj/item/weapon/spacecash/S = new(spawnloc)
	S.worth = sum
	S.update_icon()
	if(istype(H) && !H.get_active_hand())
		H.put_in_hands(S)


/proc/spawn_miner_money(sum, spawnloc, mob/living/carbon/human/H)
	var/obj/item/weapon/spacecash/minercash/S = new(spawnloc)
	S.worth = sum
	S.update_icon()
	if(istype(H) && !H.get_active_hand())
		H.put_in_hands(S)
