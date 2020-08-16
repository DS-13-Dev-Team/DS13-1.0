/decl/hierarchy/supply_pack/mining
	name = "Mining"

/decl/hierarchy/supply_pack/supply/minergear
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

/decl/hierarchy/supply_pack/supply/minersuits
	name = "Planet Cracker suits"
	contains = list(/obj/item/clothing/suit/space/void/mining,
			/obj/item/clothing/head/helmet/space/void/mining,
			/obj/item/clothing/shoes/magboots)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "\improper Planet Cracker suits"
	access = access_mining