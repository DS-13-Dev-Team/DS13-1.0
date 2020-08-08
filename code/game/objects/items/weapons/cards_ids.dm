/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/device.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/associated_account_number = 0
	var/list/associated_email_login = list("login" = "", "password" = "")

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.SetName(text("data disk- '[]'", t))
	else
		src.SetName("data disk")
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

var/const/NO_EMAG_ACT = -50
/obj/item/weapon/card/emag/resolve_attackby(atom/A, mob/user)
	var/used_uses = A.emag_act(uses, user, src)
	if(used_uses == NO_EMAG_ACT)
		return ..(A, user)

	uses -= used_uses
	A.add_fingerprint(user)
	if(used_uses)
		log_and_message_admins("emagged \an [A].")

	if(uses<1)
		user.visible_message("<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access."
	icon_state = "id"
	item_state = "card-id"

	var/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

	var/job_access_type     // Job type to acquire access rights from, if any

	var/datum/mil_branch/military_branch = null //Vars for tracking branches and ranks on multi-crewtype maps
	var/datum/mil_rank/military_rank = null

/obj/item/weapon/card/id/New()
	..()
	if(job_access_type)
		var/datum/job/j = job_master.GetJobByType(job_access_type)
		if(j)
			rank = j.title
			assignment = rank
			access |= j.get_access()

/obj/item/weapon/card/id/CanUseTopic(var/user)
	if(user in view(get_turf(src)))
		return STATUS_INTERACTIVE

/obj/item/weapon/card/id/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["look_at_id"])
		if(istype(user))
			user.examinate(src)
			return TOPIC_HANDLED

/obj/item/weapon/card/id/examine(mob/user)
	..()
	to_chat(user, "It says '[get_display_name()]'.")
	if(in_range(user, src))
		show(user)

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/proc/show(mob/user as mob)
	if(front && side)
		user << browse_rsc(front, "front.png")
		user << browse_rsc(side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/card/id/proc/get_display_name()
	. = registered_name
	if(military_rank && military_rank.name_short)
		. = military_rank.name_short + " " + .
	if(assignment)
		. += ", [assignment]"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	id_card.age = age

	if(GLOB.using_map.flags & MAP_HAS_BRANCH)
		id_card.military_branch = char_branch

	if(GLOB.using_map.flags & MAP_HAS_RANK)
		id_card.military_rank = char_rank

/obj/item/weapon/card/id/proc/dat()
	var/list/dat = list("<table><tr><td>")
	dat += text("Name: []</A><BR>", registered_name)
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)

	if(GLOB.using_map.flags & MAP_HAS_BRANCH)
		dat += text("Branch: []</A><BR>\n", military_branch ? military_branch.name : "\[UNSET\]")
	if(GLOB.using_map.flags & MAP_HAS_RANK)
		dat += text("Rank: []</A><BR>\n", military_rank ? military_rank.name : "\[UNSET\]")

	dat += text("Assignment: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4><img src=side.png height=80 width=80 border=4></td>"
	dat += "</tr></table>"
	return jointext(dat,null)

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: \icon[src] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: \icon[src] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetIdCard()
	return src

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment))
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")
	return

/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = MATERIAL_SILVER
	item_state = "silver_id"
	job_access_type = /datum/job/fl

/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = MATERIAL_GOLD
	item_state = "gold_id"
	job_access_type = /datum/job/cap


/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = MATERIAL_GOLD
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for lawed synthetics."
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/New()
	access = get_all_station_access()// + access_synth
	..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
/obj/item/weapon/card/id/centcom/New()
	access = get_all_centcom_access()
	..()

/obj/item/weapon/card/id/centcom/station/New()
	..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"

/obj/item/weapon/card/id/centcom/ERT/New()
	..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/all_access
	name = "\improper Administrator's spare ID"
	desc = "The spare ID of the Lord of Lords himself."
	icon_state = "data"
	item_state = "tdgreen"
	registered_name = "Administrator"
	assignment = "Administrator"
/obj/item/weapon/card/id/all_access/New()
	access = get_access_ids()
	..()

// Department-flavor IDs
/obj/item/weapon/card/id/medical
	name = "identification card"
	desc = "A card issued to medical staff."
	icon_state = "med"
	job_access_type = /datum/job/md

/obj/item/weapon/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	icon_state = "medGold"
	job_access_type = /datum/job/smo

/obj/item/weapon/card/id/security
	name = "identification card"
	desc = "A card issued to security staff."
	icon_state = "sec"
	job_access_type = /datum/job/security_officer

/obj/item/weapon/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	icon_state = "secGold"
	job_access_type = /datum/job/cseco

/obj/item/weapon/card/id/engineering
	name = "identification card"
	desc = "A card issued to engineering staff."
	icon_state = "eng"
	job_access_type = null

/obj/item/weapon/card/id/engineering/atmos
	job_access_type = null

/obj/item/weapon/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	icon_state = "engGold"
	job_access_type = null

/obj/item/weapon/card/id/science
	name = "identification card"
	desc = "A card issued to science staff."
	icon_state = "sci"
	job_access_type = null

/obj/item/weapon/card/id/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	icon_state = "sciGold"
	job_access_type = null

/obj/item/weapon/card/id/cargo
	name = "identification card"
	desc = "A card issued to cargo staff."
	icon_state = "cargo"
	job_access_type = /datum/job/serviceman

/obj/item/weapon/card/id/cargo/mining
	name = "identification card"
	desc = "A card issued to miners."
	job_access_type = /datum/job/planet_cracker

/obj/item/weapon/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	icon_state = "cargoGold"
	job_access_type = /datum/job/so

/obj/item/weapon/card/id/civilian
	name = "identification card"
	desc = "A card issued to civilian staff."
	icon_state = "civ"
	job_access_type = null

/obj/item/weapon/card/id/civilian/bartender
	job_access_type = /datum/job/bar

/obj/item/weapon/card/id/civilian/chef
	job_access_type = /datum/job/line_cook

/obj/item/weapon/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	icon_state = "civGold"




//////////////////////////////////////////////////
///////DEAD SPACE GENERAL SHIP/COLONY IDS/////////
//////////////////////////////////////////////////

/obj/item/weapon/card/id/holo
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = null

/obj/item/weapon/card/id/holo/cargo
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Cargo Serviceman."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/serviceman

/obj/item/weapon/card/id/holo/cargo/supply_officer
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Supply Officer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/so

/obj/item/weapon/card/id/holo/civilian
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one is a general issue badge that is temporarily given to those missing ID badges or for guests."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = null

/obj/item/weapon/card/id/holo/civilian/bartender
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Bartender."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/bar

/obj/item/weapon/card/id/holo/civilian/line_cook
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Line Cook."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/line_cook

/obj/item/weapon/card/id/holo/command
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Bridge Ensign."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/bo

/obj/item/weapon/card/id/holo/command/captain
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Ishimura's Captain."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/cap

/obj/item/weapon/card/id/holo/command/first_lieutenant
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Ishimura's First Lieutenant."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/fl

/obj/item/weapon/card/id/holo/mining
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Planet Cracker."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/planet_cracker

/obj/item/weapon/card/id/holo/mining/director
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the CEC Director of Mining."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/dom

/obj/item/weapon/card/id/holo/mining/foreman
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Mining Foreman."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/foreman

/obj/item/weapon/card/id/holo/engineering
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Technical Engineer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/tech_engineer

/obj/item/weapon/card/id/holo/engineering/chief_engineer
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Ishimura's Chief Engineer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/ce

/obj/item/weapon/card/id/holo/medical
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Medical Doctor."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/md

/obj/item/weapon/card/id/holo/medical/smo
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Ishimura's Senior Medical Officer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/smo

/obj/item/weapon/card/id/holo/medical/surgeon
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Surgeon."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/surg

/obj/item/weapon/card/id/holo/science
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a Research Assistant."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/ra

/obj/item/weapon/card/id/holo/science/cscio
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Ishimura's Chief Science Officer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/cscio

/obj/item/weapon/card/id/holo/security
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to an Ishimura Security Officer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/security_officer

/obj/item/weapon/card/id/holo/security/cseco
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Ishimura's Chief Security Officer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/cseco

/obj/item/weapon/card/id/holo/security/sso
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to the Ishimura's Senior Security Officer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/sso

/*/obj/item/weapon/card/id/holoiddeadofficer
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with RIG clothing. This one belongs to a PSEC Security Officer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	job_access_type = /datum/job/ds13psecsecurityofficer*/

//////////////////////////////////////////////////
///////DEAD SPACE EDF/UNI/KELLION IDS BELOW///////
//////////////////////////////////////////////////


//edf//

/obj/item/weapon/card/id/holo/edf
	name = "EDF marine's holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as a Marine in the Earth Defense Force's Uxor Battalion."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/edf/medic
	name = "EDF medic's holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as a Medic in the Earth Defense Force's Uxor Battalion."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/edf/engineer
	name = "EDF engineer's holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as an Engineer in the Earth Defense Force's Uxor Battalion."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/edf/commander
	name = "EDF lieutenant's holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as a Lieutenant in the Earth Defense Force's Uxor Battalion."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

//uni//

/obj/item/weapon/card/id/holo/unitologist
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one bears no official markings but contains unitologist iconography. It has the word 'Faithful' scratched on it."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/berserker
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one bears no official markings but contains unitologist iconography. It has the word 'Berserker' scratched in."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/mechanic
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one bears no official markings but contains unitologist iconography. It has the word 'Mechanic' scratched in."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/healer
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one bears no official markings but contains unitologist iconography. It has the word 'Healer' scratched in."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/deacon
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one bears no official markings but contains unitologist iconography. It has the word 'Deacon' scratched in."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

//kellion//

/obj/item/weapon/card/id/holo/isaac
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as a C.E.C. Maintenance Team Engineer."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/kellion_sec
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as a C.E.C. Maintenance Team Security Grunt."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/kellion_sec_leader
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as a C.E.C. Maintenance Team Security Leader."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)

/obj/item/weapon/card/id/holo/kendra
	name = "holographic id"
	desc = "A holographic identification badge used in conjunction with a RIG identification system. This particular one denotes the bearer as a C.E.C. Maintenance Team Technician."
	icon_state = "holowarrant_filled"
	item_state = "holowarrant_filled"
	access = list(access_bridge, access_security, access_armory, access_service, access_cargo,
				access_mining, access_engineering, access_external_airlocks,
				access_medical, access_research, access_chemistry,
				access_surgery, access_maint_tunnels, access_keycard_auth)
