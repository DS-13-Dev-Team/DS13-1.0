//Splits the text of a file at seperator and returns them in a list.
/world/proc/file2list(filename, seperator="\n")
	return splittext(file2text(filename), seperator)


//Writes a list into a specified file
/proc/list2file(var/list/textlist, var/filename)
	var/text = ""
	for (var/line in textlist)
		text += "[line]\n"

	text2file(text, filename)