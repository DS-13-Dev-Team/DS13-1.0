//Alloys that contain subsets of each other's ingredients must be ordered in the desired sequence
//eg. steel comes after plasteel because plasteel's ingredients contain the ingredients for steel and
//it would be impossible to produce.

/datum/alloy
	var/list/requires
	var/product_mod = 1
	var/product
	var/metaltag

/datum/alloy/plasteel
	metaltag = MATERIAL_PLASTEEL
	requires = list(
		/ore/iron = 1,
		/ore/coal = 2,
		/ore/platinum = 2
		)
	product_mod = 0.3
	product = /obj/item/stack/material/plasteel


/datum/alloy/steel
	metaltag = MATERIAL_STEEL
	requires = list(
		/ore/coal = 1,
		/ore/hematite = 1
		)
	product = /obj/item/stack/material/steel

/datum/alloy/borosilicate
	metaltag = MATERIAL_PLASMAGLASS
	requires = list(
		/ore/platinum = 1,
		/ore/glass = 2
		)
	product = /obj/item/stack/material/glass/phoronglass
