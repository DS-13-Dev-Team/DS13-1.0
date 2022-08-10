/obj/machinery/store
	var/obj/item/spacecash/ewallet/chip = null


//How many credits are available for purchase in total, between inserted chip + rig account
/obj/machinery/store/proc/get_available_credits()
	. = 0
	if(chip)
		. += chip.worth

	if(occupant && occupant.wearing_rig)
		. += occupant.wearing_rig.get_account_balance()

	for(var/obj/item/spacecash/S in deposit_box.contents)
		. += S.worth

	var/datum/money_account/A = occupant?.get_account()
	if(A)
		. += A.money

//Can the occupant afford to pay a cost ? True/false
/obj/machinery/store/proc/occupant_can_afford(var/cost)
	if (!occupant)
		return FALSE

	if (cost == null && current_design)
		cost = current_design.get_price(occupant)

	return (get_available_credits() >= cost)


//Deducts credits
/obj/machinery/store/proc/occupant_pay_credits(left_to_pay)
	if(!occupant || !occupant_can_afford())
		return FALSE

	if(chip)
		if(chip.worth <= left_to_pay)
			left_to_pay -= chip.worth
			chip.worth = 0
			chip.update_icon()
		else
			chip.worth -= left_to_pay
			chip.update_icon()
			return TRUE

	if(occupant && occupant.wearing_rig)
		var/pay_amount = min(occupant.wearing_rig.get_account_balance(), left_to_pay)
		var/obj/item/rig/R = occupant.wearing_rig
		R.charge_to_rig_account(src, "Store Purchase", machine_id, -pay_amount)
		left_to_pay -= pay_amount

	if(left_to_pay)
		for(var/i in deposit_box.contents)
			if(istype(i, /obj/item/spacecash))
				var/obj/item/spacecash/S = i
				if(S.worth <= left_to_pay)
					left_to_pay -= S.worth
					qdel(S)
					deposit_box.update_ui_data()
				else
					S.worth -= left_to_pay
					S.update_icon()
					deposit_box.update_ui_data()
					return TRUE

	var/datum/money_account/A = occupant?.get_account()
	if(A)
		A.money -= left_to_pay

	return TRUE


//Buys and returns the current item, don't call this directly
/obj/machinery/store/proc/buy_current()
	if(!occupant || !occupant_pay_credits(current_design.get_price(occupant)))
		return

	playsound(src, sound_vend, VOLUME_MID, TRUE)
	return current_design.CreatedInStore(src)

/obj/machinery/store/proc/store_or_drop(var/obj/item/I)
	if (!istype(I) || !deposit_box.store_item(I))
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
	for (var/atom/movable/I in things)

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
	if(occupant.back && !occupant.wearing_rig)
		store_or_drop(occupant.back)
	var/obj/item/rig/R = locate(/obj/item/rig) in things
	if(R) //If they bought a module, R will be null and it'll just attempt to install all the modules from the deposit box
		start_transfer(R)
		things -= R
	for(var/i in things)
		store_or_drop(i)


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

	var/withdrawal_amount = tgui_input_number(user,"Welcome to the CEC Employee Checking Account withdrawal interface. \n\
	Currently Available Balance:	[available_balance]	credits \n\
	Enter the amount you wish to withdraw. Please note, deposits are not available, this account is withdrawal-only."
	,"CEC Employee Checking Account", available_balance, available_balance, 0)



	var/question = 	list()
	rig_account ? (question += "Withdraw to RIG") : null
	chip ? (question += "Withdraw to Credit Chip") : null
	question += "Cancel"
	var/response = tgui_alert(user, "Welcome to the CEC Employee Checking Account withdrawal interface. \n\
	Currently Available Balance:	[available_balance]	credits \n\
	You are withdrawing: [withdrawal_amount] credits. Please select the location to withdraw to.",
	"CEC Employee Checking Account",
	question)

	//We need to recheck things to prevent exploits now
	if (!ECA)
		return
	available_balance = ECA.money

	withdrawal_amount = Clamp(withdrawal_amount, 0, available_balance)

	if (!withdrawal_amount)
		return

	switch (response)
		if ("Withdraw to RIG")
			charge_to_account(rig_account.account_number, machine_id, "Credit Withdrawal", machine_id, withdrawal_amount)
			charge_to_account(ECA.account_number, machine_id, "Credit Withdrawal", machine_id, -withdrawal_amount)
			to_chat(user, "Withdrawal successful. [withdrawal_amount] credits moved to rig account")

		if ("Withdraw to Credit Chip")
			charge_to_account(ECA.account_number, machine_id, "Credit Withdrawal", machine_id, -withdrawal_amount)
			chip.modify_worth(withdrawal_amount)
			to_chat(user, "Withdrawal successful. [withdrawal_amount] credits moved to chip")