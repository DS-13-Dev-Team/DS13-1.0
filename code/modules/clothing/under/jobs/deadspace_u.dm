//Dead Space//
/*
 * Command
 */
/obj/item/clothing/under/captain/deadspace
	name = "captain's uniform"
	desc = "A neatly pressed, blue uniform with navy blue patches on each shoulder and pure gold cuffs. Looks fancy!"
	item_state = "ds_captain"
	worn_state = "ds_captain"
	icon_state = "ds_captain"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/first_lieutenant
	name = "first lieutenant's uniform"
	desc = "A neatly pressed, blue uniform with dark, green patches on each shoulder and gold cuffs with green highlights. Looks fancy!"
	item_state = "ds_firstlieutenant"
	worn_state = "ds_firstlieutenant"
	icon_state = "ds_firstlieutenant"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/bridge_officer
	name = "ensign's uniform"
	desc = "A neatly pressed, blue uniform with burgundy patches on each shoulder. This uniform is typically worn by ensigns manning the bridge."
	item_state = "ds_bridgeensign"
	worn_state = "ds_bridgeensign"
	icon_state = "ds_bridgeensign"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)


/*
 * Engineering
 */

/obj/item/clothing/under/d_engineer
	name = "engineer's uniform"
	desc = "A sleek, navy blue uniform issued to engineering department. Typically, a vest is worn over top of this uniform."
	item_state = "ds_engineer"
	worn_state = "ds_engineer"
	icon_state = "ds_engineer"
	permeability_coefficient = 0.50

/*
 * Medical
 */
/obj/item/clothing/under/senior_medical_officer/deadspace
	name = "senior medical officer's uniform"
	desc = "A white uniform with a bright blue collar, symbolizing this uniform belongs to the Senior Medical Officer.."
	item_state = "ds_senior_med_officer"
	worn_state = "ds_senior_med_officer"
	icon_state = "ds_senior_med_officer"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/medical_doctor
	name = "medical doctor's uniform"
	desc = "A white uniform with a standard, gray collar, symbolizing this uniform belongs to the medical department."
	item_state = "ds_med_doctor"
	worn_state = "ds_med_doctor"
	icon_state = "ds_med_doctor"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/surgeon
	name = "surgeon's uniform"
	desc = "A white uniform with a red collar, this uniform is worn by surgeons of the Ishimura medical department."
	item_state = "ds_surgeon"
	worn_state = "ds_surgeon"
	icon_state = "ds_surgeon"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/*
 * Research
 */
/obj/item/clothing/under/chief_science_officer
	name = "chief science officer's uniform"
	desc = "A neatly pressed, white uniform with light green patches on each shoulder and burgundy cuffs."
	item_state = "ds_chief_sci_officer"
	worn_state = "ds_chief_sci_officer"
	icon_state = "ds_chief_sci_officer"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/under/research_assistant
	name = "research assistant's uniform"
	desc = "A white uniform with a purple collar, symbolizing this uniform belongs to the research department."
	item_state = "ds_research_assistant"
	worn_state = "ds_research_assistant"
	icon_state = "ds_research_assistant"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 10, rad = 0)

/*
 * Spare Uniforms
 */
/obj/item/clothing/under/cargo_deadspace
	name = "cargo uniform"
	desc = "A white uniform with a dull, yellow collar, symbolizing this uniform belongs to the cargo department."
	item_state = "ds_cargo"
	worn_state = "ds_cargo"
	icon_state = "ds_cargo"

/obj/item/clothing/under/dsspareishimura2
	name = "crew uniform"
	item_state = "ds_spare2"
	worn_state = "ds_spare2"
	icon_state = "ds_spare2"

/*
 * Mining
 */
/obj/item/clothing/under/miner/deadspace
	name = "miner's overalls"
	desc = "A loose pair of overalls and a olive wifebeater, designed for blue-collar workers to labor in."
	item_state = "ds_miner"
	worn_state = "ds_miner"
	icon_state = "ds_miner"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/*
 * Security
 */
/obj/item/clothing/under/security/deadspace
	name = "security jumpsuit"
	desc = "A dark brown uniform issued to security officers. It offers some light ballistic protection due to the light armor plates sewn into the chest and thighs."
	item_state = "ds_securityjumpsuit"
	worn_state = "ds_securityjumpsuit"
	icon_state = "ds_securityjumpsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.25
	armor = list(melee = 35, bullet = 55, laser = 0, energy = 20, bomb = 45, bio = 0, rad = 0)
