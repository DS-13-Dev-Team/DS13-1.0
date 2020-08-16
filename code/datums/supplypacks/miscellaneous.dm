/decl/hierarchy/supply_pack/miscellaneous
	name = "Miscellaneous"

/decl/hierarchy/supply_pack/miscellaneous/llamps
	num_contained = 3
	contains = list(/obj/item/device/flashlight/lamp/lava,
					/obj/item/device/flashlight/lamp/lava/red,
					/obj/item/device/flashlight/lamp/lava/orange,
					/obj/item/device/flashlight/lamp/lava/yellow,
					/obj/item/device/flashlight/lamp/lava/green,
					/obj/item/device/flashlight/lamp/lava/cyan,
					/obj/item/device/flashlight/lamp/lava/blue,
					/obj/item/device/flashlight/lamp/lava/purple,
					/obj/item/device/flashlight/lamp/lava/pink)
	name = "Lava lamps"
	cost = 10
	containername = "\improper Lava lamp crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/miscellaneous/officetoys
	name = "Office toys"
	contains = list(/obj/item/toy/desk/newtoncradle,
					/obj/item/toy/desk/fan,
					/obj/item/toy/desk/officetoy,
					/obj/item/toy/desk/dippingbird)
	cost = 15
	containername = "\improper Office toys crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetbrown
	name = "Brown carpet"
	contains = list(/obj/item/stack/tile/carpet/fifty)
	cost = 15
	containername = "\improper Brown carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetblue
	name = "Blue and gold carpet"
	contains = list(/obj/item/stack/tile/carpetblue/fifty)
	cost = 15
	containername = "\improper Blue and gold carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetblue2
	name = "Blue and silver carpet"
	contains = list(/obj/item/stack/tile/carpetblue2/fifty)
	cost = 15
	containername = "\improper Blue and silver carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetpurple
	name = "Purple carpet"
	contains = list(/obj/item/stack/tile/carpetpurple/fifty)
	cost = 15
	containername = "\improper Purple carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetorange
	name = "Orange carpet"
	contains = list(/obj/item/stack/tile/carpetorange/fifty)
	cost = 15
	containername = "\improper Orange carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetgreen
	name = "Green carpet"
	contains = list(/obj/item/stack/tile/carpetgreen/fifty)
	cost = 15
	containername = "\improper Green carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/carpetred
	name = "Red carpet"
	contains = list(/obj/item/stack/tile/carpetred/fifty)
	cost = 15
	containername = "\improper Red carpet crate"

/decl/hierarchy/supply_pack/miscellaneous/linoleum
	name = "Linoleum"
	contains = list(/obj/item/stack/tile/linoleum/fifty)
	cost = 15
	containername = "\improper Linoleum crate"

/decl/hierarchy/supply_pack/miscellaneous/white_tiles
	name = "White floor tiles"
	contains = list(/obj/item/stack/tile/floor_white/fifty)
	cost = 15
	containername = "\improper White floor tile crate"

/decl/hierarchy/supply_pack/miscellaneous/dark_tiles
	name = "Dark floor tiles"
	contains = list(/obj/item/stack/tile/floor_dark/fifty)
	cost = 15
	containername = "\improper Dark floor tile crate"

/decl/hierarchy/supply_pack/miscellaneous/freezer_tiles
	name = "Freezer floor tiles"
	contains = list(/obj/item/stack/tile/floor_freezer/fifty)
	cost = 15
	containername = "\improper Freezer floor tile crate"

/decl/hierarchy/supply_pack/miscellaneous/card_packs
	num_contained = 5
	contains = list(/obj/item/weapon/pack/cardemon,
					/obj/item/weapon/pack/spaceball,
					/obj/item/weapon/deck/holder)
	name = "\improper Trading Card Crate"
	cost = 20
	containername = "\improper cards crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/miscellaneous/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "EFTPOS scanner"
	cost = 10
	containername = "\improper EFTPOS crate"

/decl/hierarchy/supply_pack/miscellaneous/cardboard_sheets
	name = "50 cardboard sheets"
	contains = list(/obj/item/stack/material/cardboard/fifty)
	cost = 10
	containername = "\improper Cardboard sheets crate"

/decl/hierarchy/supply_pack/miscellaneous/chaplaingear
	name = "Chaplain equipment"
	contains = list(/obj/item/clothing/under/rank/chaplain,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/suit/nun,
					/obj/item/clothing/head/nun_hood,
					/obj/item/clothing/suit/chaplain_hoodie,
					/obj/item/clothing/head/chaplain_hood,
					/obj/item/clothing/suit/holidaypriest,
					/obj/item/clothing/under/wedding/bride_white,
					/obj/item/weapon/storage/backpack/cultpack,
					/obj/item/weapon/storage/fancy/candle_box = 3)
	cost = 10
	containername = "\improper Chaplain equipment crate"

/decl/hierarchy/supply_pack/miscellaneous/mousetrap
	num_contained = 3
	contains = list(/obj/item/weapon/storage/box/mousetraps)
	name = "\improper Pest Control Crate"
	cost = 10
	containername = "\improper Pest Control Crate"

/decl/hierarchy/supply_pack/miscellaneous/illuminate
	name = "Illumination grenades"
	contains = list(/obj/item/weapon/grenade/light = 8)
	cost = 20
	containername = "\improper Illumination grenade crate"


//A crate of completely random stuff for cargo to sort
/decl/hierarchy/supply_pack/miscellaneous/stuff
	name = "Mystery Crate"
	contains = list(/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,
					/obj/random/loot,)
	cost = 20
	containername = "\improper Mystery"