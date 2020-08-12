/*
	This file handles meta-things related to donor status and donor perks
*/



/hook/startup/proc/loadDonors()
	load_donors()
	return 1

//load text from file
/proc/load_donors()
	var/list/Lines = file2list("config/donors.txt")

	for(var/line in Lines)
		if(!length(line))
			continue
		if(copytext(line,1,2) == "#")
			continue

		var/list/line_list = splittext(line, "    ")
		if(!line_list.len)
			continue

		//We now have a list containing two things:
			//1. Ckey of a donor player
			//2. The date up to which their donor status lasts

		if (is_past_date(line_list[2]))
			//Their donor status has expired!
			continue

		//Donor status is still valid!
		GLOB.donor_keys += lowertext(line_list[1])