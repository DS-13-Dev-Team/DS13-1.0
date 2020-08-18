/decl/hierarchy/supply_pack/science
	name = "Science"

/decl/hierarchy/supply_pack/science/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "\improper coolant tank crate"

/decl/hierarchy/supply_pack/science/phoron
	name = "Phoron assembly crate"
	contains = list(/obj/item/weapon/tank/phoron = 3,
					/obj/item/device/assembly/igniter = 3,
					/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/device/assembly/timer = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "\improper Phoron assembly crate"
	access = access_research

/decl/hierarchy/supply_pack/science/scanner_module
	name = "Reagent scanner module crate"
	contains = list(/obj/item/weapon/computer_hardware/scanner/reagent = 4)
	cost = 20
	containername = "\improper Reagent scanner module crate"