/datum/absorbed_dna
	var/name
	var/datum/dna/dna
	var/speciesName
	var/list/languages

/datum/absorbed_dna/New(var/newName, newDNA, newSpecies, newLanguages)
	..()
	name = newName
	dna = newDNA
	speciesName = newSpecies
	languages = newLanguages
