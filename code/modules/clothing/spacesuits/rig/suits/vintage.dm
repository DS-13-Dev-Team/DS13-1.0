/obj/item/rig/vintage
	name = "Antique CEC RIG"
	desc = "An extremely bulky, durable vintage suit that has mostly been replaced by sleeker modern designs. Some collectors still value the good old days though."
	icon_state = "vintage_rig"
	armor = list(melee = 66.5, bullet = 70, laser = 57.5, energy = 25, bomb = 90, bio = 100, rad = 70)
	offline_slowdown = RIG_VERY_HEAVY
	online_slowdown = RIG_SUPER_HEAVY

	max_health = 4000

	chest_type = /obj/item/clothing/suit/space/rig/vintage
	helm_type =  /obj/item/clothing/head/helmet/space/rig/vintage
	boot_type =  /obj/item/clothing/shoes/magboots/rig/vintage
	glove_type = /obj/item/clothing/gloves/rig/vintage

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson
		)

/obj/item/clothing/suit/space/rig/vintage
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/head/helmet/space/rig/vintage
	name = "helmet"

/obj/item/clothing/gloves/rig/vintage
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/vintage
	name = "boots"

/obj/item/rig/vintage/heavy
	name = "Antique Heavy-Duty CEC RIG"
	desc = "The heavy-duty vintage CEC RIG is used in the most hazardous engineering operations aboard CEC vessels. Its heavier armor plating can withstand more blunt damage than most CEC suits, and can withstand radiation just as well. As working conditions on CEC ships have improved, this RIG has been discontinued, but some heavy variants can still be found on old planet crackers."
	icon_state = "vintage_suit"

/obj/item/rig/vintage/sea
	name = "Hazard Diving RIG"
	desc = "The heavy-duty hazard diving RIG is the standard among CEC deep sea mining operations. It's plating has been reinforced to withstand extreme undersea pressures and concussive forces."
	icon_state = "heavy_diving_rig"

