GLOBAL_LIST_EMPTY(education_list)

GLOBAL_LIST_EMPTY(lifestyle_list)

GLOBAL_LIST_EMPTY(hobby_list)

/proc/init_backgrounds_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()

	for(var/path in subtypesof(prototype))
		var/datum/background/D = new path()

		L[D.name] = D

	return L

/proc/background_value(client/given_client, skill_id)
	var/datum/background/education/E = GLOB.education_list[given_client.prefs.education]
	var/datum/background/lifestyle/L = GLOB.lifestyle_list[given_client.prefs.lifestyle]
	var/datum/background/hobby/H = GLOB.hobby_list[given_client.prefs.hobby]
	switch(skill_id)
		if("EVA")
			return E.rig_zero_gravity + L.rig_zero_gravity + H.rig_zero_gravity
		if("hauling")
			return E.hauling + L.hauling + H.hauling
		if("athletics")
			return E.atletics + L.atletics + H.atletics
		if("computer")
			return E.information_technology + L.information_technology + H.information_technology
		if("devices")
			return E.complex_devices + L.complex_devices + H.complex_devices
		if("cooking")
			return E.cooking + L.cooking + H.cooking
		if("botany")
			return E.botany + L.botany + H.botany
		if("combat")
			return E.close_combat + L.close_combat + H.close_combat
		if("weapons")
			return E.weapon_expertise + L.weapon_expertise + H.weapon_expertise
		if("forensics")
			return E.forensics + L.forensics + H.forensics
		if("construction")
			return E.construction + L.construction + H.construction
		if("electrical")
			return E.electrical_engineering + L.electrical_engineering + H.electrical_engineering
		if("medical")
			return E.medicine + L.medicine + H.medicine
		if("anatomy")
			return E.anatomy + L.anatomy + H.anatomy
	return 0

/datum/background
	var/name = "None" 				// Name of the bakcground. This is what the player sees.
	var/info = "Info bakcground" 	// Generic description of this bakcground.

// General
	var/rig_zero_gravity = 0
	var/manipulation = 0
	var/atletics = 0
	var/information_technology = 0
	var/hauling = 0

//Enginering
	var/construction = 0
	var/electrical_engineering = 0

//Medical
	var/anatomy = 0
	var/medicine = 0

//Research
	var/complex_devices = 0

//Security
	var/close_combat = 0
	var/forensics = 0
	var/weapon_expertise = 0

//Service
	var/botany = 0
	var/cooking = 0


// EDUCATION

/datum/background/education/student
	name = "Diligent student"
	info = "You have studied well, gaining knowledge of many subjects, although you aren't very proficient in anything specific. Maybe some of that knowledge will be useful in Zone."
	rig_zero_gravity = 1
	information_technology = 2
	complex_devices = 1
	cooking = 2
	botany = 1

/datum/background/education/techie
	name = "Erudite technician"
	info = "You always had an opinion that classical education sucks. Well, now is your chance to proof that your knowledge of engineering and physics has it's uses."
	rig_zero_gravity = 2
	information_technology = 2
	construction = 2
	complex_devices = 1
	electrical_engineering = 1

/datum/background/education/medic
	name = "Educated medic"
	info = "Your studies were more specific - you have impressive skills of swining your scalpel around as well as using it for surgeries."
	anatomy = 2
	medicine = 2
	botany = 2
	close_combat = 1

/datum/background/education/army
	name = "Military college"
	info = "You have spent your youth in the military college, going through the basic training and learning more about the modern weaponary. You don't have high combat skills, but that's better than nothing."
	weapon_expertise = 3
	close_combat = 2

/datum/background/education/badboy
	name = "Young recidivist"
	info = "Your youth was full of crime. The experience of getting arrested and doing illegal business made you stronger and taught how to fight for yourself, but it wasn't the best way to spend your young years.."
	weapon_expertise = 2
	atletics = 1

/datum/background/education/country
	name = "Countryside inhabitant"
	info = "There never were any colleges or universities in your countryside, so you had to spend your time with parents growing crops and having premature sex in the barn. You don't have any special knowledge, but your body is strong and tough."
	anatomy = 1
	forensics = 1
	close_combat = 1

// LIFESTYLE

/datum/background/lifestyle/normal
	name = "Average"
	info = "You're an average man. A lot of people are jealous of your balanced lifestyle."

/datum/background/lifestyle/lazy
	name = "Lazy"
	info = "You never liked physical activities, preferring to surf the internet instead of doing sports. You are slightly out of shape, but some of the knowledge you gained oughta help you..."
	close_combat = -1
	weapon_expertise = -1
	information_technology = 2
	manipulation = 2
	rig_zero_gravity = 2

/datum/background/lifestyle/intelligent
	name = "Intellectual"
	info = "You focused heavily on the intellectual improvement since your childhood. It's hard to say if your weakened body is worth it, but you really are smart."
	close_combat = -2
	information_technology = 2
	complex_devices = 2
	botany = 2
	atletics = -1

/datum/background/lifestyle/athletic
	name = "Athletic"
	info = "Doing sports and eating healthy made you into a nice, fit man. Sadly enough, you never had enough time to improve yourself mentally."
	close_combat = 1
	anatomy = 1
	medicine = 1
	information_technology = -1
	complex_devices = -1

/datum/background/lifestyle/bodybuilder
	name = "Bobybuilder"
	info = "Dangerous synthetic stimulators and constant training turned you into a real fuckin' terminator! Although the amount of drugs you took made your muscles stiff and slow, worsening your agility."
	close_combat = 4
	atletics = -2

/datum/background/lifestyle/acrobatic
	name = "Acrobatic"
	info = "You spent many years practicing the different exercises to improve your dexterity and flexibility. You are very agile, but your strength and health are significantly worse than of any other man."
	close_combat = -2
	anatomy = -2
	medicine = -2
	atletics = 3

// Hobby

/datum/background/hobby/muscular
	name = "Muscular"
	info = "You are stronk, yes. You can feel your muscles growing stronker."
	close_combat = 2

/datum/background/hobby/sturdy
	name = "Sturdy"
	info = "Your endurance is higher than average."
	anatomy = 2
	medicine = 2
	botany = 2

/datum/background/hobby/smart
	name = "Smart"
	info = "Your smarts are sharper than average."
	information_technology = 2
	complex_devices = 2
	rig_zero_gravity = 1
	manipulation = 2

/datum/background/hobby/agile
	name = "Gymnast"
	info = "Your body is more agile than average."
	atletics = 2

/datum/background/hobby/medex
	name = "Anatomy expert"
	info = "From different sources, you gained knowledge of the human anatomy. Your medical and melee skills are improved."
	anatomy = 2
	medicine = 2
	close_combat = 2

/datum/background/hobby/mechanic
	name = "Experienced mechanic"
	info = "You spent many years studying mechanics. Your skills with mechanics and technical devices are improved."
	construction = 2
	electrical_engineering = 2

/datum/background/hobby/gunnut
	name = "Gun nut"
	info = "You have experience with different firearms, gained from the shooting clubs and simulators. You have slightly improved skills with most guns."
	weapon_expertise = 6

/datum/background/hobby/heavyhand
	name = "Heavy hand"
	info = "You are stronger and have greater skills in melee combat."
	close_combat = 2
	anatomy = 1

/datum/background/hobby/hunter
	name = "Hunter"
	info = "You have a lot of hunting experience. Your skills with shotguns are improved, as well as your knowledge of traps."
	weapon_expertise = 4
	construction = 2

/datum/background/hobby/pistoleer
	name = "Pistoleer"
	info = "You are some kind of a soy kid, thus you really don't like weapons heavier than a handgun. Your skill with pistols is improved."
	weapon_expertise = 1
	atletics = 2
