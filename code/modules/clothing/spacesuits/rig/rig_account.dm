/*
	RIGs have an embedded bank account. This is canon

	Credits are mostly transferred in and out of it using credit chips, or store machines

	For conserving memory the account is only made when necessary
*/
#define RIG_ACCOUNT_CREATE	if (!account)	account = create_account(new_owner_name = (wearer ? wearer.name : "Generic"))
/obj/item/weapon/rig
	var/datum/money_account/account


/obj/item/weapon/rig/proc/get_account()
	RIG_ACCOUNT_CREATE
	return account

/obj/item/weapon/rig/proc/get_account_balance()
	//We don't need to create the account for this if it doesn't exist yet
	if (!account)
		return 0
	return account.money

/obj/item/weapon/rig/proc/charge_to_rig_account(var/source, var/purpose, var/terminal_id, var/amount)



	charge_to_account(get_account().account_number, source, purpose, terminal_id, amount)
	//TODO: Inform the reciever it recieved money
	return TRUE



/obj/item/weapon/rig/credits_recieved(var/balance, var/datum/source)
	RIG_ACCOUNT_CREATE

/obj/item/weapon/rig/proc/handle_credit_chip(W, user)
	var/obj/item/weapon/spacecash/ewallet/chip = W
	var/response = alert(user, "What are you trying to do with this chip?", "Credit Chip Interface", "Deposit", "Withdraw", "Store")
	var/cashflow_direction = 0	//What direction are we trying to move money?
		//1 = Deposit
		//-1 = Withdraw
		//0 = no movement, cancel
	switch (response)
		if ("Store")
			return TRUE	//This will allow the rig to place the chip inside storage
		if ("Deposit")
			cashflow_direction = 1
		if ("Withdraw")
			cashflow_direction = -1

	//They cancelled?
	if (!cashflow_direction)
		return

	var/amount = input(user, "Current balances: \n\
	RIG: [get_account_balance()]\n\
	Chip: [chip.worth]\n\
	\n\
	How many credits would you like to [(cashflow_direction == 1 ? "deposit into" : "withdraw from")] the RIG?") as num|null
	if (!isnum(amount))
		return

	//Now we need to sanitize
	if (cashflow_direction == 1)
		//Cant deposit more than the chip has
		amount = clamp(amount, 0, chip.worth)

	else if (cashflow_direction == -1)
		//Cant take more than the RIG has
		amount = clamp(amount, 0, get_account_balance())

	//Alright we are ready to do this
	charge_to_rig_account(chip, (cashflow_direction == 1 ? "Deposit" : "Withdrawal"), chip, amount*cashflow_direction)
	chip.modify_worth((-amount)*cashflow_direction)
	to_chat(user, "Transferred [amount] credits [(cashflow_direction == 1 ? "to" : "from")] RIG")

/*
	Some Helpers
*/
/mob/proc/get_rig_balance()
	return 0


/mob/living/carbon/human/get_rig_balance()
	if (wearing_rig)
		return wearing_rig.get_account_balance()

	return 0