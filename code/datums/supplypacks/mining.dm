/decl/hierarchy/supply_pack/mining
	name = "Mining"

/decl/hierarchy/supply_pack/mining/minergear
	name = "Planet Cracker equipment"
	contains = list(/obj/item/storage/backpack/industrial,
					/obj/item/storage/backpack/satchel_eng,
					/obj/item/radio/headset/headset_mining,
					/obj/item/clothing/under/deadspace/planet_cracker,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/dutyboots,
					/obj/item/analyzer,
					/obj/item/storage/ore,
					/obj/item/flashlight/lantern,
					/obj/item/tool/shovel,
					/obj/item/tool/pickaxe/laser,
					/obj/item/mining_scanner,
					/obj/item/clothing/glasses/meson)
	cost = 15
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Planet Cracker equipment"
	access = access_mining

/decl/hierarchy/supply_pack/mining/minersuits
	name = "Planet Cracker suits"
	contains = list(/obj/item/clothing/suit/space/void/mining,
			/obj/item/clothing/head/helmet/space/void/mining,
			/obj/item/clothing/shoes/magboots)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Planet Cracker suits"
	access = access_mining


/decl/hierarchy/supply_pack/mining/mining_cutter
	name = "Mining Tool - Mining Cutter"
	contains = list(/obj/item/cell/plasmacutter = 2,
	/obj/item/gun/energy/cutter/empty = 1)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "\improper mining cutter crate"

/decl/hierarchy/supply_pack/mining/plasma_energy
	name = "Mining - Plasma Energy Cells"
	contains = list(/obj/item/cell/plasmacutter = 4)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "\improper plasma energy crate"


/decl/hierarchy/supply_pack/mining/line_cutter
	name = "Mining Tool - Line Cutter"
	contains = list(/obj/item/ammo_magazine/lineracks = 2,
	/obj/item/gun/projectile/linecutter/empty = 1)
	cost = 90
	containertype = /obj/structure/closet/crate
	containername = "\improper Line Cutter crate"

/decl/hierarchy/supply_pack/mining/line_racks
	name = "Mining - Line Racks"
	contains = list(/obj/item/ammo_magazine/lineracks = 4)
	cost = 90
	containertype = /obj/structure/closet/crate
	containername = "\improper line rack crate"


/decl/hierarchy/supply_pack/mining/force_gun
	name = "Mining Tool - Graviton Accelerator"
	contains = list(/obj/item/cell/force = 2,
	/obj/item/gun/energy/forcegun/empty = 1)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper Graviton Accelerator crate"

/decl/hierarchy/supply_pack/mining/force_energy
	name = "Mining - Force Energy Cells"
	contains = list(/obj/item/cell/force = 4)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper force energy crate"


/decl/hierarchy/supply_pack/mining/ripper
	name = "Mining Tool - RC-DS Disc Ripper"
	contains = list(/obj/item/ammo_magazine/sawblades = 3,
	/obj/item/gun/projectile/ripper = 1)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper Disc Ripper crate"

/decl/hierarchy/supply_pack/mining/ripper_blades
	name = "Mining - Sawblades"
	contains = list(/obj/item/ammo_magazine/sawblades = 6)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper sawblade crate"


/decl/hierarchy/supply_pack/mining/contact_beam
	name = "Mining Tool - C99 Supercollider Contact Beam"
	contains = list(/obj/item/gun/projectile/javelin_gun/empty = 2,
	/obj/item/ammo_magazine/javelin = 2)
	cost = 120
	containertype = /obj/structure/closet/crate
	containername = "\improper javelin launcher crate"

/decl/hierarchy/supply_pack/mining/javelin_spears
	name = "Mining - Javelin Spears"
	contains = list(/obj/item/ammo_magazine/javelin = 4)
	cost = 120
	containertype = /obj/structure/closet/crate
	containername = "\improper javelin spears crate"


/decl/hierarchy/supply_pack/mining/detonator
	name = "Mining Tool - Detonator Mine Launcher"
	contains = list(/obj/item/ammo_casing/tripmine = 6,
	/obj/item/gun/projectile/detonator = 1)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper detonator crate"

/decl/hierarchy/supply_pack/mining/detonator_mines
	name = "Mining - Detonator Charges"
	contains = list(/obj/item/ammo_casing/tripmine = 12)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper detonator charges crate"


/decl/hierarchy/supply_pack/mining/hydrazine_torch
	name = "Mining Tool - Hydrazine Torch"
	contains = list(/obj/item/gun/spray/hydrazine_torch = 1,
	/obj/item/reagent_containers/glass/fuel_tank/fuel = 2)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper Hydrazine Torch crate"

/decl/hierarchy/supply_pack/mining/torch_fuel
	name = "Torch Fuel Canisters"
	contains = list(/obj/item/reagent_containers/glass/fuel_tank/fuel = 4)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper Torch Fuel Canisters crate"

//Crazy expensive for just ONE tank of hydrazine. Cargo is not a convenient source for it
/decl/hierarchy/supply_pack/mining/torch_hydrazine
	name = "Torch Hydrazine Canister"
	contains = list(/obj/item/reagent_containers/glass/fuel_tank/hydrazine = 1)
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "\improper Torch Fuel Canisters crate"