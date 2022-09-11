/datum/preferences
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/nanotrasen_relation = "Neutral"
	var/memory = ""

	//Some faction information.
	var/home_system = "Unset"           //System of birth.
	var/citizenship = "None"            //Current home system.
	var/faction = "None"                //Antag faction/general associated faction.
	var/religion = "None"               //Religious association.

	//Background Skills
	var/education = "Military college"
	var/lifestyle = "Lazy"
	var/hobby = "Smart"

/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5

/datum/category_item/player_setup_item/general/background/load_character(var/savefile/S)
	READ_FILE(S["med_record"],pref.med_record)
	READ_FILE(S["sec_record"],pref.sec_record)
	READ_FILE(S["gen_record"],pref.gen_record)
	READ_FILE(S["home_system"],pref.home_system)
	READ_FILE(S["citizenship"],pref.citizenship)
	READ_FILE(S["faction"],pref.faction)
	READ_FILE(S["religion"],pref.religion)
	READ_FILE(S["nanotrasen_relation"],pref.nanotrasen_relation)
	READ_FILE(S["memory"],pref.memory)
	READ_FILE(S["education"],pref.education)
	READ_FILE(S["lifestyle"],pref.lifestyle)
	READ_FILE(S["hobby"],pref.hobby)

/datum/category_item/player_setup_item/general/background/save_character(var/savefile/S)
	WRITE_FILE(S["med_record"],pref.med_record)
	WRITE_FILE(S["sec_record"],pref.sec_record)
	WRITE_FILE(S["gen_record"],pref.gen_record)
	WRITE_FILE(S["home_system"],pref.home_system)
	WRITE_FILE(S["citizenship"],pref.citizenship)
	WRITE_FILE(S["faction"],pref.faction)
	WRITE_FILE(S["religion"],pref.religion)
	WRITE_FILE(S["nanotrasen_relation"],pref.nanotrasen_relation)
	WRITE_FILE(S["memory"],pref.memory)
	WRITE_FILE(S["education"],pref.education)
	WRITE_FILE(S["lifestyle"],pref.lifestyle)
	WRITE_FILE(S["hobby"],pref.hobby)

/datum/category_item/player_setup_item/general/background/sanitize_character()
	if(!pref.home_system) pref.home_system = "Unset"
	if(!pref.citizenship) pref.citizenship = "None"
	if(!pref.faction)     pref.faction =     "None"
	if(!pref.religion)    pref.religion =    "None"
	if(!pref.education)	  pref.education = 	 "Military college"
	if(!pref.lifestyle)   pref.lifestyle =   "Lazy"
	if(!pref.hobby)		  pref.hobby = 		 "Smart"

	pref.nanotrasen_relation = sanitize_inlist(pref.nanotrasen_relation, COMPANY_ALIGNMENTS, initial(pref.nanotrasen_relation))

/datum/category_item/player_setup_item/general/background/content(var/mob/user)
	. += "<b>Background Information</b><br>"
	. += "EarthGov Relation: <a href='?src=\ref[src];nt_relation=1'>[pref.nanotrasen_relation]</a><br/>"
	. += "Home System: <a href='?src=\ref[src];home_system=1'>[pref.home_system]</a><br/>"
	. += "Citizenship: <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
	. += "Faction: <a href='?src=\ref[src];faction=1'>[pref.faction]</a><br/>"
	. += "Religion: <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"
	. += "Education: <a href='?src=\ref[src];education=1'>[pref.education]</a> <a href ='?src=\ref[src];e_info=1'>\[?\]</a><br/>"
	. += "Lifestyle: <a href='?src=\ref[src];lifestyle=1'>[pref.lifestyle]</a> <a href ='?src=\ref[src];l_info=1'>\[?\]</a><br/>"
	. += "Hobby: <a href='?src=\ref[src];hobby=1'>[pref.hobby]</a> <a href ='?src=\ref[src];h_info=1'>\[?\]</a><br/>"

	. += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		. += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		. += "Medical Records:<br>"
		. += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><br><br>"
		. += "Employment Records:<br>"
		. += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><br><br>"
		. += "Security Records:<br>"
		. += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><br>"
		. += "Memory:<br>"
		. += "<a href='?src=\ref[src];set_memory=1'>[TextPreview(pref.memory,40)]</a><br>"

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["nt_relation"])
		var/new_relation = input(user, "Choose your relation to [GLOB.using_map.company_name]. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.nanotrasen_relation)  as null|anything in COMPANY_ALIGNMENTS
		if(new_relation && CanUseTopic(user))
			pref.nanotrasen_relation = new_relation
			return TOPIC_REFRESH

	else if(href_list["home_system"])
		var/choice = input(user, "Please choose a home system.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.home_system) as null|anything in GLOB.using_map.home_system_choices + list("Unset","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a home system.", CHARACTER_PREFERENCE_INPUT_TITLE)  as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.home_system = raw_choice
		else
			pref.home_system = choice
		return TOPIC_REFRESH

	else if(href_list["citizenship"])
		var/choice = input(user, "Please choose your current citizenship.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.citizenship) as null|anything in GLOB.using_map.citizenship_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter your current citizenship.", CHARACTER_PREFERENCE_INPUT_TITLE) as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				pref.citizenship = raw_choice
		else
			pref.citizenship = choice
		return TOPIC_REFRESH

	else if(href_list["faction"])
		var/choice = input(user, "Please choose a faction to work for.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.faction) as null|anything in GLOB.using_map.faction_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a faction.", CHARACTER_PREFERENCE_INPUT_TITLE)  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.faction = raw_choice
		else
			pref.faction = choice
		return TOPIC_REFRESH

	else if(href_list["religion"])
		var/choice = input(user, "Please choose a religion.", CHARACTER_PREFERENCE_INPUT_TITLE, pref.religion) as null|anything in GLOB.using_map.religion_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a religon.", CHARACTER_PREFERENCE_INPUT_TITLE)  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				pref.religion = raw_choice
		else
			pref.religion = choice
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	else if(href_list["set_memory"])
		var/memes = sanitize(input(user,"Enter memorized information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.memory)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(memes) && CanUseTopic(user))
			pref.memory = memes
		return TOPIC_REFRESH

	else if(href_list["education"])
		var/new_education = input(user, "Your education is...", "Backgrounds") as null|anything in GLOB.education_list
		if(new_education)
			pref.education = new_education
		return TOPIC_REFRESH

	else if(href_list["lifestyle"])
		var/new_lifestyle = input(user, "Your lifestyle is...", "Backgrounds") as null|anything in GLOB.lifestyle_list
		if(new_lifestyle)
			pref.lifestyle = new_lifestyle
		return TOPIC_REFRESH

	else if(href_list["hobby"])
		var/new_hobby = input(user, "Your hobby is...", "Backgrounds") as null|anything in GLOB.hobby_list
		if(new_hobby)
			pref.hobby = new_hobby
		return TOPIC_REFRESH

	else if(href_list["e_info"])
		var/datum/background/education/E = GLOB.education_list[pref.education]
		to_chat(user, "<span class='info'><b>Education: [E.name]</b><br>\
							[E.info]</span>")

	else if(href_list["l_info"])
		var/datum/background/lifestyle/L = GLOB.lifestyle_list[pref.lifestyle]
		to_chat(user,"<span class='info'><b>Lifestyle: [L.name]</b><br>\
							[L.info]</span>")

	else if(href_list["h_info"])
		var/datum/background/hobby/H = GLOB.hobby_list[pref.hobby]
		to_chat(user,"<span class='info'><b>Hobby: [H.name]</b><br>\
							[H.info]</span>")

	return ..()
