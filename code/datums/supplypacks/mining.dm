/decl/hierarchy/supply_pack/mining
	name = "Mining"

/decl/hierarchy/supply_pack/mining/minergear
	name = "Planet Cracker equipment"
	contains = list(/obj/item/weapon/storage/backpack/industrial,
					/obj/item/weapon/storage/backpack/satchel_eng,
					/obj/item/device/radio/headset/headset_mining,
					/obj/item/clothing/under/miner/deadspace,
					/obj/item/clothing/gloves/thick,
					/obj/item/clothing/shoes/dutyboots,
					/obj/item/device/analyzer,
					/obj/item/weapon/storage/ore,
					/obj/item/device/flashlight/lantern,
					/obj/item/weapon/tool/shovel,
					/obj/item/weapon/tool/pickaxe/laser,
					/obj/item/weapon/mining_scanner,
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

/decl/hierarchy/supply_pack/mining/line_racks
	name = "Line Racks"
	contains = list(/obj/item/ammo_magazine/lineracks = 4)
	cost = 90
	containertype = /obj/structure/closet/crate
	containername = "\improper line rack crate"


/decl/hierarchy/supply_pack/mining/line_cutter
	name = "Mining Tool - Line Cutter"
	contains = list(/obj/item/ammo_magazine/lineracks = 2,
	/obj/item/weapon/gun/projectile/linecutter/empty = 1)
	cost = 90
	containertype = /obj/structure/closet/crate
	containername = "\improper Line Cutter crate"