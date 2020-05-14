// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data
	var/stored_data = "" 			// Stored data in string format.
	filetype = "DAT"
	var/block_size = 250
	var/do_not_edit = 0				// Whether the user will be reminded that the file probably shouldn't be edited.

/datum/computer_file/data/clone()
	var/datum/computer_file/data/temp = ..()
	temp.stored_data = stored_data
	return temp

// Calculates file size from amount of characters in saved string
/datum/computer_file/data/proc/calculate_size()
	size = max(1, round(length(stored_data) / block_size))

/datum/computer_file/data/logfile
	filetype = "LOG"

/datum/computer_file/data/text
	filetype = "TXT"

/datum/computer_file/data/text/manual/surgery
	filename = "Surgical Guide"
	stored_data = " \[h1\]Surgical Overview\[/h1\] A step by step guide on various surgeries\[br\] \[i\]Brain, Eyes - Head\[/i\]\[br\] \[i\]Heart, Lungs - Chest\[/i\]\[br\] \[i\]Liver, Kidneys, Appendix - groin\[/i\]\[br\]\[br\] \[h3\]Facial Reconstruction\[/h3\] \[list\] \[*\]1) Make an incision on the mouth with a scalpel to cut open the face\[br\] \[*\]2) Mend the vocal chords with a hemostat\[br\] \[*\]3) Pull the skin back into place with a retractor\[br\] \[*\]4) Cauterize the incision \[/list\]\[br\] \[h3\]Shrapnel Removal\[/h3\] \[list\] \[*\]1) Make an incision with a scalpel\[br\] \[*\]2) Use a hemostat to clamp the bleeders\[br\] \[*\]3) Use a retractor to open the incision\[br\] \[*\]4) Search the cavity with a hemostat\[br\] \[*\]5) Cauterize the incision\[br\] \[/list\]\[br\] \[h3\]Limb Amputation\[/h3\] \[list\] \[*\]1) Cut through the limb with a circular saw\[br\] \[/list\]\[br\] \[h3\]Limb Replacement & Reattachment\[/h3\] \[list\] \[*\]1) Affix the replacement limb to the patient\[br\] \[*\]2) Use a hemostat to reconnect the tendons and muscles\[br\] \[/list\]\[br\] \[h3\]Bone Repair\[/h3\] \[list\] \[*\]1) Make an incision with a scalpel\[br\] \[*\]2) Use a hemostat to clamp the bleeders\[br\] \[*\]3) Use a retractor to open the incision\[br\] \[*\]4) Smear bone gel on the broken bones\[br\] \[*\]5) Use a bone setter to reposition the bones\[br\] \[*\]6) Cauterize the incision\[br\] \[/list\]\[br\] \[h3\]Organ Repair\[/h3\] \[i\]Necrotic organs need to be replaced\[/i\]\[br\] \[list\] \[*\]1) Make an incision with a scalpel\[br\] \[*\]2) Use a hemostat to clamp the bleeders\[br\] \[*\]3) Use a retractor to open the incision\[br\] \[*\]4) \[b\](HEAD/CHEST ONLY)\[/b\] Use a circular saw to cut through the bones\[br\] \[*\]5) Patch up the damaged organ with a dropper of peridaxon or a trauma pack\[br\] \[*\]6) \[b\](HEAD/CHEST ONLY)\[/b\] Smear bone gel on the sawed through bones\[br\] \[*\]7) \[b\](HEAD/CHEST ONLY)\[/b\] Use a bone setter to reposition the bones\[br\] \[*\]8) Cauterize the incision\[br\] \[/list\]\[br\] \[h3\]Organ Replacement Surgery\[/h3\] \[i\]This is a complicated surgery. Get a surgeon to do this\[/i\]\[br\] \[list\] \[*\]1) Make an incision with a scalpel\[br\] \[*\]2) Use a hemostat to clamp the bleeders\[br\] \[*\]3) Use a retractor to open the incision\[br\] \[*\]4) \[b\](HEAD/CHEST ONLY)\[/b\] Use a circular saw to cut through the bones\[br\] \[*\]5) Detach the organ with a scalpel\[br\] \[*\]6) Remove the organ with a hemostat\[br\] \[*\]7) Place the new organ in the patient\[br\] \[*\]8) Reconnect the organ using a Fix O' Vein\[br\] \[*\]9) Repair any injuries from the surgery with a trauma pack\[br\] \[*\]10) \[b\](HEAD/CHEST ONLY)\[/b\] Smear bone gel on the sawed through bones\[br\] \[*\]11) \[b\](HEAD/CHEST ONLY)\[/b\] Use a bone setter to reposition the bones\[br\] \[*\]12) Cauterize the incision\[br\] \[/list\]\[br\] \[h3\]Torn Tendons & Internal Bleeding\[/h3\] \[list\] \[*\]1) Make an incision with a scalpel\[br\] \[*\]2) Use a hemostat to clamp the bleeders\[br\] \[*\]3) Use a retractor to open the incision\[br\] \[*\]4) Use a Fix O' Vein to patch the damage\[br\] \[*\]5) Cauterize the incision\[br\] \[/list\]"