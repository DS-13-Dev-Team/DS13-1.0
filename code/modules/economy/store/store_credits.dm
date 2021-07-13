/obj/machinery/store
	var/obj/item/weapon/spacecash/ewallet/chip = null


//How many credits are available for purchase in total, between inserted chip + rig account
/obj/machinery/store/proc/get_available_credits()
	.=0
	if (chip)
		.+= chip.worth

	if (occupant && occupant.wearing_rig)
		.+=occupant.wearing_rig.get_account_balance()


//Can the occupant afford to pay a cost ? True/false
/obj/machinery/store/proc/occupant_can_afford(var/cost)
	if (!occupant)
		return FALSE

	if (cost == null && current_design)
		cost = current_design.get_price(occupant)

	return (get_available_credits() >= cost)




//Deducts credits
/obj/machinery/store/proc/occupant_pay_credits(var/cost, var/safety = TRUE)
	if (safety && (!occupant || !occupant_can_afford()))
		return FALSE


	var/pay_amount
	if (chip)
		pay_amount = min(cost, chip.worth)
		if (chip.pay_into(pay_amount, src))
			cost -= pay_amount

	if (cost <= 0)
		return TRUE

	//Alright now we pay whatever is leftover from the rig account



	if (cost > 0)
		if (occupant && occupant.wearing_rig)
			pay_amount = min(occupant.wearing_rig.get_account_balance(), cost)
		var/obj/item/weapon/rig/R = occupant.wearing_rig
		R.charge_to_rig_account(src, "Store Purchase", machine_id, -pay_amount)
		cost -= pay_amount


	if (cost <= 0)
		return TRUE



//Buys and returns the current item, don't call this directly
/obj/machinery/store/proc/buy_current()
	if (!occupant)
		return
	var/cost = current_design.get_price(occupant)

	if (!occupant_pay_credits(cost))
		return


	playsound(src, sound_vend, VOLUME_MID, TRUE)
	return current_design.Fabricate(src, 1, src)

/obj/machinery/store/proc/store_or_drop(var/obj/item/I)
	if (!deposit_box.store_item(I))
		I.forceMove(get_turf(src))



/*
	Buying Modes

*/

/*
	This attempts to place items into the purchaser's rig storage, or any other suitable storage slot
	If that fails it goes in their hands
	if that fails, it goes in deposit box
	if THAT fails it is dropped on the floor
*/
/obj/machinery/store/proc/buy_to_occupant()
	var/list/things = list() + buy_current()
	for (var/obj/item/I in things)
		var/atom/destination = occupant.equip_to_storage_or_hands(I)
		if(!destination)
			destination = store_or_drop(I)

		if (istype(destination, /atom))
			to_chat(occupant, "[I] vended to [destination]")

/*
	This attempts to place items into the internal deposit box, for later collection
	if THAT fails it is dropped on the floor
*/
/obj/machinery/store/proc/buy_to_deposit()
	var/list/things = list() + buy_current()
	for (var/obj/item/I in things)
		store_or_drop(I)


/*
	Used when buying a rig or a rig module.
	Immediately transfers into the new thing if rig, or installs the module
*/
/obj/machinery/store/proc/buy_and_transfer()
	var/list/things = list() + buy_current()
	var/obj/item/weapon/rig/R
	for (var/obj/item/I in things)
		if (isrig(I))
			R = I
		store_or_drop(I)

	//If they bought a module, R will be null and it'll just attempt to install all the modules from the deposit box
	start_transfer(R)




//Withdrawing credits from your employee account to something
//You can either withdraw to your rig or to a slotted chip
/obj/machinery/store/proc/handle_withdraw(var/mob/living/carbon/human/user)
	var/datum/money_account/ECA = user.get_account()
	if (!ECA)
		to_chat(user, "ERROR: No Employee Checking Account found on record.")
		return

	var/datum/money_account/rig_account = user.wearing_rig?.get_account()


	if (!rig_account && !chip)
		to_chat(user, "ERROR: No Withdrawal destination found. Please wear a RIG or insert a credit chip")
		return

	var/available_balance = ECA.money

	var/withdrawal_amount = input(user,"Welcome to the CEC Employee Checking Account withdrawal interface. \n\
	Currently Available Balance:	[available_balance]	credits \n\
	Enter the amount you wish to withdraw. Please note, deposits are not available, this account is withdrawal-only."
	,"CEC Employee Checking Account",available_balance) as num | null




	var/response = alert(user, "Welcome to the CEC Employee Checking Account withdrawal interface. \n\
	Currently Available Balance:	[available_balance]	credits \n\
	You are withdrawing: [withdrawal_amount] credits. Please select the location to withdraw to.",
	"CEC Employee Checking Account",
	(rig_account ? "Withdraw to RIG" : null),
	(chip ? "Withdraw to Credit Chip" : null),
	"Cancel")

	//We need to recheck things to prevent exploits now
	if (!ECA)
		return
	available_balance = ECA.money

	withdrawal_amount = Clamp(withdrawal_amount, 0, available_balance)

	if (!withdrawal_amount)
		return

	switch (response)
		if ("Cancel")
			return

		if ("Withdraw to RIG")
			charge_to_account(rig_account.account_number, machine_id, "Credit Withdrawal", machine_id, withdrawal_amount)
			charge_to_account(ECA.account_number, machine_id, "Credit Withdrawal", machine_id, -withdrawal_amount)
			to_chat(user, "Withdrawal successful. [withdrawal_amount] credits moved to rig account")

		if ("Withdraw to Credit Chip")
			charge_to_account(ECA.account_number, machine_id, "Credit Withdrawal", machine_id, -withdrawal_amount)
			chip.modify_worth(withdrawal_amount)
			to_chat(user, "Withdrawal successful. [withdrawal_amount] credits moved to chip")