/decl/hierarchy/supply_pack/supply
	name = "Supply"

/decl/hierarchy/supply_pack/supply/food
	name = "Kitchen supply crate"
	contains = list(/obj/item/reagent_containers/food/condiment/flour = 6,
					/obj/item/reagent_containers/food/drinks/milk = 4,
					/obj/item/reagent_containers/food/drinks/soymilk = 2,
					/obj/item/storage/fancy/egg_box = 2,
					/obj/item/reagent_containers/food/snacks/tofu = 2,
					/obj/item/reagent_containers/food/snacks/rawbacon = 8,
					/obj/item/reagent_containers/food/snacks/meat = 4
					)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Food crate"

/decl/hierarchy/supply_pack/supply/toner
	name = "Toner cartridges"
	contains = list(/obj/item/toner = 6)
	cost = 10
	containername = "\improper Toner cartridges"

/decl/hierarchy/supply_pack/supply/janitor
	name = "Janitorial supplies"
	contains = list(/obj/item/reagent_containers/glass/bucket,
					/obj/item/mop,
					/obj/item/caution = 4,
					/obj/item/storage/bag/trash,
					/obj/item/lightreplacer,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/reagent_containers/glass/rag,
					/obj/item/grenade/chem_grenade/cleaner = 3,
					/obj/structure/mopbucket)
	cost = 10
	containertype = /obj/structure/closet/crate/large
	containername = "\improper Janitorial supplies"

/decl/hierarchy/supply_pack/supply/boxes
	name = "Empty boxes"
	contains = list(/obj/item/storage/box = 10)
	cost = 10
	containername = "\improper Empty box crate"

/decl/hierarchy/supply_pack/supply/bureaucracy
	contains = list(/obj/item/clipboard,
					/obj/item/clipboard,
					/obj/item/pen/red,
					/obj/item/pen/blue,
					/obj/item/pen/green,
					/obj/item/camera_film,
					/obj/item/folder/blue,
					/obj/item/folder/red,
					/obj/item/folder/yellow,
					/obj/item/hand_labeler,
					/obj/item/tool/tape_roll,
					/obj/structure/filingcabinet/chestdrawer{anchored = 0},
					/obj/item/paper_bin)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate/large
	containername = "\improper Office supplies crate"

/decl/hierarchy/supply_pack/supply/scanner_module
	name = "Paper scanner module crate"
	contains = list(/obj/item/computer_hardware/scanner/paper = 4)
	cost = 20
	containername = "\improper Paper scanner module crate"

/decl/hierarchy/supply_pack/supply/spare_pda
	name = "Spare PDAs"
	contains = list(/obj/item/modular_computer/pda = 3)
	cost = 10
	containername = "\improper Spare PDA crate"

/decl/hierarchy/supply_pack/supply/spare_id
	name = "Spare IDs"
	contains = list(/obj/item/storage/box/holoids = 3)
	cost = 10
	containername = "\improper Spare ID crate"