/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 *		Excavation Closet
 *		Shipping Supplies Closet
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	icon_state = "emergency"
	icon_closed = "emergency"
	icon_opened = "emergencyopen"

/obj/structure/closet/emcloset/New()
	..()
	new /obj/random/loot/often(src)
	if (prob(20))
		new /obj/item/rig_remover(src)
	switch (pickweight(list("small" = 50, "aid" = 25, "tank" = 10, "large" = 5, "both" = 10)))
		if ("small")
			new /obj/item/tank/emergency/oxygen(src)
			new /obj/item/tank/emergency/oxygen(src)
			new /obj/item/rig/emergency(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/mask/breath(src)
			if (prob(70))
				new /obj/item/tool/tape_roll(src)
		if ("aid")
			new /obj/item/tank/emergency/oxygen(src)
			new /obj/item/storage/toolbox/emergency(src)
			new /obj/item/rig/emergency(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/storage/firstaid/o2(src)
		if ("tank")
			new /obj/item/tank/emergency/oxygen/engi(src)
			new /obj/item/tank/emergency/oxygen/engi(src)
			new /obj/item/rig/emergency/astro(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/random/tool_upgrade(src)
		if ("large")
			new /obj/item/tank/emergency/oxygen/double(src)
			new /obj/item/tank/emergency/oxygen/double(src)
			new /obj/item/rig/emergency/astro(src)
			new /obj/item/clothing/mask/gas(src)
			new /obj/item/clothing/mask/gas(src)
			new /obj/item/oxycandle(src)
		if ("both")
			new /obj/item/storage/toolbox/emergency(src)
			new /obj/item/tank/emergency/oxygen/engi(src)
			new /obj/item/tank/emergency/oxygen/engi(src)
			new /obj/item/rig/emergency/astro(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/storage/firstaid/o2(src)
			new /obj/item/oxycandle(src)
			new /obj/random/tool_upgrade(src)
			if (prob(50))
				new /obj/item/tool/tape_roll(src)
			if (prob(50))
				new /obj/item/tool/tape_roll(src)

/obj/structure/closet/emcloset/legacy/New()
	.=..()
	new /obj/item/tank/oxygen(src)
	new /obj/item/clothing/mask/gas(src)

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "firecloset"
	icon_closed = "firecloset"
	icon_opened = "fireclosetopen"

/obj/structure/closet/firecloset/WillContain()
	var/list/things = list(
		/obj/item/storage/med_pouch/burn,
		/obj/item/clothing/suit/fire,
		/obj/item/clothing/mask/gas,
		/obj/item/flashlight,
		/obj/item/tank/oxygen/red,
		/obj/item/extinguisher,
		/obj/item/clothing/head/hardhat/red,
		/obj/random/armor,
		/obj/random/loot/often)
	if (prob(10))
		things += /obj/item/rig/firesuit
	return things

/obj/structure/closet/firecloset/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/toolcloset/New()
	..()
	new /obj/random/tool(src)
	new /obj/random/tool(src)
	new /obj/random/tool(src)
	new /obj/random/loot/often(src)
	new /obj/random/tool_upgrade(src) //Guaranteeed toolmod
	if(prob(50))
		new /obj/random/tool_upgrade(src)//Good chance for another
	if(prob(10))
		new /obj/random/tool_upgrade(src)//Small chance for a third

	if(prob(40))
		new /obj/item/clothing/suit/storage/hazardvest(src)
	if(prob(50))
		new /obj/item/flashlight(src)
	if(prob(50))
		new /obj/item/tool/screwdriver(src)
	if(prob(50))
		new /obj/item/tool/wrench(src)
	if(prob(50))
		new /obj/item/tool/weldingtool(src)
	if(prob(50))
		new /obj/item/tool/crowbar(src)
	if(prob(50))
		new /obj/item/tool/wirecutters(src)
	if(prob(50))
		new /obj/item/t_scanner(src)
	if(prob(20))
		new /obj/item/storage/belt/utility(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(20))
		new /obj/item/tool/multitool(src)
	if(prob(5))
		new /obj/item/clothing/gloves/insulated(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "radsuitcloset"
	icon_opened = "toolclosetopen_old"
	icon_closed = "radsuitcloset"

/obj/structure/closet/radiation/WillContain()
	return list(
		/obj/item/storage/med_pouch/toxin = 2,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/geiger = 2,
		/obj/random/tool)

/obj/structure/closet/radiation/security
	name = "radiation security suit closet"
	desc = "It's a storage unit containing rad-protective suits for security officers."
	icon_state = "radsuitcloset_sec"
	icon_opened = "radsuitcloset_sec_open"
	icon_closed = "radsuitcloset_sec"

/obj/structure/closet/radiation/WillContain()
	return list(
		/obj/item/storage/med_pouch/toxin = 2,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/geiger = 2)
/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bombsuit"
	icon_closed = "bombsuit"
	icon_opened = "bombsuitopen"

/obj/structure/closet/bombcloset/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/bomb_hood)


/obj/structure/closet/bombclosetsecurity
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bombsuitsec"
	icon_closed = "bombsuitsec"
	icon_opened = "bombsuitsecopen"

/obj/structure/closet/bombclosetsecurity/WillContain()
	return list(
		/obj/item/clothing/suit/bomb_suit/security,
		/obj/item/clothing/head/bomb_hood/security)

/*
 * Hydrant
 */
/obj/structure/closet/hydrant //wall mounted fire closet
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "hydrant"
	icon_closed = "hydrant"
	icon_opened = "hydrant_open"
	anchored = 1
	density = 0
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	setup = 0

/obj/structure/closet/hydrant/WillContain()
	return list(
		/obj/item/storage/med_pouch/burn = 2,
		/obj/item/clothing/suit/fire,
		/obj/item/clothing/mask/gas/half,
		/obj/item/flashlight,
		/obj/item/tank/oxygen/red,
		/obj/item/extinguisher,
		/obj/item/clothing/head/hardhat/red,
		/obj/random/armor = 1,
		/obj/random/loot/often)

/*
 * First Aid
 */
/obj/structure/closet/medical_wall //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's a wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_first_aid"
	icon_closed = "medical_wall_first_aid"
	icon_opened = "medical_wall_first_aid_open"
	anchored = 1
	density = 0
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	setup = 0

/obj/structure/closet/medical_wall/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/medical_wall/filled/WillContain()
	return list(
		/obj/random/firstaid,
		/obj/random/medical/lite = 12)

/obj/structure/closet/shipping_wall
	name = "shipping supplies closet"
	desc = "It's a wall-mounted storage unit containing supplies for preparing shipments."
	icon_state = "shipping_wall"
	icon_closed = "shipping_wall"
	icon_opened = "shipping_wall_open"
	anchored = 1
	density = 0
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	setup = 0

/obj/structure/closet/shipping_wall/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/shipping_wall/filled/WillContain()
	return list(
		/obj/item/stack/material/cardboard/ten,
		/obj/item/destTagger,
		/obj/item/stack/package_wrap/twenty_five)