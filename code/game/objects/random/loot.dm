//Spawn nothing chances
#define USUALLY	15
#define OFTEN	40
#define SOMETIMES	60
#define RARELY	85


#define FEW	4
#define SOME	8
#define MANY	15

GLOBAL_LIST_EMPTY(loot_locations)
/*
	Main loot table.
	Most random items are distributed using this entry point
*/
/obj/random/loot
	icon_state = "randomloot"
	possible_spawns = list(/obj/random/common_loot = 74,
				/obj/random/uncommon_loot = 20,
				/obj/random/rare_loot = 6.2)

/obj/random/loot/Initialize()
	GLOB.loot_locations |= get_turf(src)
	.=..()

/obj/random/loot/usually
	spawn_nothing_percentage = USUALLY

/obj/random/loot/usually/few
	max_amount = FEW

/obj/random/loot/usually/some
	max_amount = SOME

/obj/random/loot/usually/many
	max_amount = MANY





/obj/random/loot/often
	spawn_nothing_percentage = OFTEN

/obj/random/loot/often/few
	max_amount = FEW

/obj/random/loot/often/some
	max_amount = SOME

/obj/random/loot/often/many
	max_amount = MANY







/obj/random/loot/sometimes
	spawn_nothing_percentage = SOMETIMES

/obj/random/loot/sometimes/few
	max_amount = FEW

/obj/random/loot/sometimes/some
	max_amount = SOME

/obj/random/loot/sometimes/many
	max_amount = MANY




/obj/random/loot/rarely
	spawn_nothing_percentage = RARELY

/obj/random/loot/rarely/few
	max_amount = FEW

/obj/random/loot/rarely/some
	max_amount = SOME

/obj/random/loot/rarely/many
	max_amount = MANY



/obj/random/common_loot
	possible_spawns = list(/obj/random/ammo = 1.4,
				/obj/random/tool = 2.75,
				/obj/random/lathe_disk = 1,
				/obj/random/powercell = 1,
				/obj/random/tech_supply = 1,
				/obj/random/medical/lite= 1,
				/obj/random/drinkbottle = 1,
				/obj/random/material = 2,
				/obj/random/smokes= 1,
				/obj/random/snack = 1,
				/obj/random/storage = 1,
				/obj/random/cash = 0.5,
				/obj/random/light = 2
				)




/obj/random/uncommon_loot
	possible_spawns = list(
	/obj/random/tool_upgrade = 3,
	/obj/random/gun_tool = 0.65,//Only tool-like guns are randomly spawned, the military weapons stay in the armoury. More for theming than for balance
	/obj/random/firstaid = 2,
	/obj/random/glasses = 1,
	/obj/random/clothing = 1,
	/obj/random/accessory = 1,
	/obj/random/voidsuit = 0.2,
	/obj/random/armor = 1,
	/obj/random/pouch = 2,
	/obj/random/tool/advanced = 1,
	/obj/random/toolbox = 1,
	/obj/random/rig_module = 0.5)

/obj/random/rare_loot
	icon_state = "rareloot"


/obj/random/rare_loot
	possible_spawns = list(
	/obj/item/stack/power_node = 3,
	/obj/item/store_schematic = 0.8,
	/obj/random/material/rare = 1,
	/obj/random/tool/modded = 1,
	/obj/random/material/rare = 1,
	/obj/random/hardsuit = 0.5,
	/obj/random/rig_module/rare = 1,
	/obj/item/weapon/peng = 1)

//Subtype that cannot spawn power nodes
/obj/random/rare_loot/nodeless
	exclusions = list(/obj/item/stack/power_node)

//Subtype that spawns *some* suits.

/obj/random/rare_loot/rig
	possible_spawns = list(
	/obj/item/weapon/rig/vintage = 0.1,
	/obj/item/weapon/rig/riot = 0.1,
	/obj/item/weapon/rig/advanced = 0.1,
	/obj/item/weapon/rig/patrol = 0.1
	)


/obj/random/rare_loot/pengless
	exclusions = list(/obj/item/weapon/peng)

/obj/random/rare_loot/usually
	spawn_nothing_percentage = USUALLY

/obj/random/rare_loot/often
	spawn_nothing_percentage = OFTEN

/obj/random/rare_loot/sometimes
	spawn_nothing_percentage = SOMETIMES

/obj/random/rare_loot/rarely
	spawn_nothing_percentage = RARELY