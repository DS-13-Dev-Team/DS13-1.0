/obj/random/armor/item_to_spawn()
	return pickweight(
	list(/obj/random/legguard = 5,
	/obj/random/armguard  = 5,

	/obj/item/clothing/accessory/armorplate = 4,
	/obj/item/clothing/accessory/armorplate/medium = 3,
	/obj/item/clothing/accessory/armorplate/tactical = 2,
	/obj/item/clothing/accessory/armorplate/merc = 1,

	//Vests
	/obj/item/clothing/suit/armor/vest/handmade = 5,
	/obj/item/clothing/suit/armor/vest = 1,
	/obj/item/clothing/suit/armor/pcarrier/medium = 0.5,
	/obj/item/clothing/suit/armor/pcarrier/light = 1,
	/obj/item/clothing/suit/armor/riot/vest = 0.5,
	/obj/item/clothing/suit/armor/bulletproof/vest = 0.5,

	//Head
	/obj/item/clothing/head/hardhat = 6,
	/obj/item/clothing/head/helmet = 1,
	/obj/item/clothing/head/helmet/handmade = 1,
	/obj/item/clothing/head/helmet/riot = 1,
	/obj/item/clothing/head/helmet/ballistic = 1,

	))

/obj/random/armguard/item_to_spawn()
	return pickweight(list(/obj/item/clothing/accessory/armguards,
	/obj/item/clothing/accessory/armguards/blue,
	/obj/item/clothing/accessory/armguards/navy,
	/obj/item/clothing/accessory/armguards/green,
	/obj/item/clothing/accessory/armguards/tan,
	/obj/item/clothing/accessory/armguards/merc,
	/obj/item/clothing/accessory/armguards/riot,
	/obj/item/clothing/accessory/armguards/ballistic,
	/obj/item/clothing/accessory/armguards/ablative))

/obj/random/legguard/item_to_spawn()
	return pickweight(list(/obj/item/clothing/accessory/legguards,
	/obj/item/clothing/accessory/legguards/blue,
	/obj/item/clothing/accessory/legguards/navy,
	/obj/item/clothing/accessory/legguards/green,
	/obj/item/clothing/accessory/legguards/tan,
	/obj/item/clothing/accessory/legguards/merc,
	/obj/item/clothing/accessory/legguards/riot,
	/obj/item/clothing/accessory/legguards/ballistic,
	/obj/item/clothing/accessory/legguards/ablative))