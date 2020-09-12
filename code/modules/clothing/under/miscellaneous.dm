/obj/item/clothing/under/pj/red
	name = "red pj's"
	desc = "Sleepwear."
	icon_state = "red_pyjamas"
	worn_state = "red_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/pj/blue
	name = "blue pj's"
	desc = "Sleepwear."
	icon_state = "blue_pyjamas"
	worn_state = "blue_pyjamas"
	item_state = "w_suit"

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon_state = "sl_suit"
	worn_state = "sl_suit"
	item_state = "sl_suit"

/obj/item/clothing/under/waiter
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tip."
	icon_state = "waiter"
	item_state = "waiter"
	worn_state = "waiter"

//This set of uniforms looks fairly fancy and is generally used for high-ranking NT personnel from what I've seen, so lets give them appropriate ranks.
/obj/item/clothing/under/rank/centcom
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain.\"."
	name = "\improper Officer's Dress Uniform"
	icon_state = "officer"
	item_state = "lawyer_black"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_officer
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral.\"."
	name = "\improper Officer's Dress Uniform"
	icon_state = "officer"
	item_state = "lawyer_black"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_captain
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral-Executive.\"."
	name = "\improper Officer's Dress Uniform"
	icon_state = "centcom"
	item_state = "lawyer_black"
	worn_state = "centcom"
	displays_id = 0

/obj/item/clothing/under/ert
	name = "ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon_state = "ert_uniform"
	item_state = "bl_suit"
	worn_state = "ert_uniform"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "black"
	item_state = "bl_suit"
	worn_state = "black"
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	desc = "it's a cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(melee = 100, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/under/cloud
	name = "cloud"
	icon_state = "cloud"
	worn_state = "cloud"

/obj/item/clothing/under/rigunder
	name = "rig undersuit"
	desc = "A tight bodysuit designed to be worn under a RIG suit in order to protect the less armoured areas of the body from heat and exposure to the elements."
	icon_state = "ds_rigunder"
	worn_state = "ds_rigunder"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	permeability_coefficient = 0.75
	armor = list(melee = 15, bullet = 15, laser = 5,energy = 10, bomb = 15, bio = 20, rad = 30)

/obj/item/clothing/under/gentlesuit
	name = "gentlemans suit"
	desc = "A silk black shirt with a white tie and a matching gray vest and slacks. Feels proper."
	icon_state = "gentlesuit"
	item_state = "gy_suit"
	worn_state = "gentlesuit"

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state = "bl_suit"
	worn_state = "black_suit"

/obj/item/clothing/under/suit_jacket/really_black
	name = "executive suit"
	desc = "A formal black suit and red tie, intended for the galaxy's finest."
	icon_state = "really_black_suit"
	item_state = "jensensuit"
	worn_state = "black_suit"

/obj/item/clothing/under/suit_jacket/female
	name = "executive suit"
	desc = "A formal trouser suit for women, intended for the galaxy's finest."
	icon_state = "black_suit_fem"
	item_state = "lawyer_black"
	worn_state = "black_suit_fem"

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	worn_state = "red_suit"

/obj/item/clothing/under/blackskirt
	name = "black skirt"
	desc = "A black skirt, very fancy!"
	icon_state = "blackskirt"
	item_state = "bl_suit"
	worn_state = "blackskirt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "sl_suit"
	worn_state = "pirate"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

//dress
/obj/item/clothing/under/dress
	name = "dress"
	desc = "A fancy dress."
	icon_state = "dress_fire"
	worn_state = "dress_fire"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/blackjumpskirt
	name = "black jumpskirt"
	desc = "A black jumpskirt, with a pink undershirt."
	icon_state = "blackjumpskirt"
	item_state = "bl_suit"
	worn_state = "blackjumpskirt"

/obj/item/clothing/under/shortjumpskirt
	name = "short jumpskirt"
	desc = "A slimming, short jumpskirt."
	icon_state = "shortjumpskirt"
	item_state = "w_suit"
	worn_state = "shortjumpskirt"

/obj/item/clothing/under/captainformal
	name = "captain's formal uniform"
	desc = "A captain's formal-wear, for special occasions."
	icon_state = "captain_formal"
	item_state = "b_suit"
	worn_state = "captain_formal"

/obj/item/clothing/under/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon_state = "assistant_formal"
	item_state = "gy_suit"
	worn_state = "assistant_formal"

/obj/item/clothing/under/suit_jacket/dom
	name = "director of mining's formal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon_state = "charcoal_suit"
	item_state = "bl_suit"
	worn_state = "charcoal_suit"
	starting_accessories = list(/obj/item/clothing/accessory/red, /obj/item/clothing/accessory/toggleable/charcoal_jacket)

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the galaxy's finest."
	icon_state = "navy_suit"
	item_state = "bl_suit"
	worn_state = "navy_suit"
	starting_accessories = list(/obj/item/clothing/accessory/red, /obj/item/clothing/accessory/toggleable/navy_jacket)

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state = "r_suit"
	worn_state = "burgundy_suit"
	starting_accessories = list(/obj/item/clothing/accessory/black, /obj/item/clothing/accessory/toggleable/burgundy_jacket)

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state = "gy_suit"
	worn_state = "checkered_suit"
	starting_accessories = list(/obj/item/clothing/accessory/black, /obj/item/clothing/accessory/toggleable/checkered_jacket)

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit. Smart, but casual."
	icon_state = "tan_suit"
	item_state = "lb_suit"
	worn_state = "tan_suit"
	starting_accessories = list(/obj/item/clothing/accessory/yellow, /obj/item/clothing/accessory/toggleable/tan_jacket)

/obj/item/clothing/under/serviceoveralls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic"
	item_state = "mechanic"
	worn_state = "mechanic"

/obj/item/clothing/under/blazer
	name = "blue blazer"
	desc = "A bold but yet conservative outfit, red corduroys, navy blazer and a tie."
	icon_state = "blue_blazer"
	item_state = "blue_blazer"
	worn_state = "blue_blazer"

/obj/item/clothing/under/harness
	name = "gear harness"
	desc = "How... minimalist."
	icon_state = "gear_harness"
	worn_state = "gear_harness"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/under/pcrc
	name = "\improper PCRC uniform"
	desc = "A uniform belonging to Proxima Centauri Risk Control, a private security firm."
	icon_state = "pcrc"
	item_state = "jensensuit"
	worn_state = "pcrc"

/obj/item/clothing/under/pcrcsuit
	name = "\improper PCRC suit"
	desc = "A suit belonging to Proxima Centauri Risk Control, a private security firm. This one looks more formal than its utility counterpart."
	icon_state = "pcrcsuit"
	item_state = "jensensuit"
	worn_state = "pcrcsuit"

/obj/item/clothing/under/foreman
	name = "\improper Foreman's overalls"
	desc = "A set of overalls that seem nicer than the average planet cracker's."
	icon_state = "mechanic"
	worn_state = "mechanic"

// Replace this with actual uniform when someone wants to sprite one
/obj/item/clothing/under/confederacy
	name = "\improper Confederate uniform"
	desc = "A military uniform belonging to the Terran Colonial Confederation, an independent human government."
	icon_state = "confed"
	worn_state = "confed"

/obj/item/clothing/under/saare
	name = "\improper SAARE uniform"
	desc = "A uniform belonging to Strategic Assault and Asset Retention Enterprises, a minor private military corporation."
	icon_state = "saare"
	worn_state = "saare"

/obj/item/clothing/under/rank/psych/sweater
	desc = "A warm looking sweater and a pair of dark blue slacks."
	name = "sweater"
	icon_state = "turtleneck"
	worn_state = "turtleneck"

/obj/item/clothing/under/wetsuit
	name = "tactical wetsuit"
	desc = "For when you want to scuba dive your way into an enemy base but still want to show off a little skin."
	icon_state = "wetsuit"
	item_state = "wetsuit"
	worn_state = "wetsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon_state = "hazard"
	item_state = "engi_suit"
	worn_state = "hazard"
	siemens_coefficient = 0.8
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 0, rad = 20)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon_state = "sterile"
	item_state = "w_suit"
	worn_state = "sterile"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)