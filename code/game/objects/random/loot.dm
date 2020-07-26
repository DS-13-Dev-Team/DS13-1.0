//Spawn nothing chances
#define USUALLY	15
#define OFTEN	40
#define SOMETIMES	60
#define RARELY	85


#define FEW	4
#define SOME	8
#define MANY	15
/*
	Main loot table.
	Most random items are distributed using this entry point
*/
/obj/random/loot
	icon_state = "randomloot"
/obj/random/loot/item_to_spawn()
	return pickweight(list(/obj/random/common_loot = 74,
				/obj/random/uncommon_loot = 20,
				/obj/random/rare_loot = 6))

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



/obj/random/common_loot/item_to_spawn()
	return pickweight(list(/obj/random/ammo = 1,
				/obj/random/tool = 3,
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
				))




/obj/random/uncommon_loot/item_to_spawn()
	return pickweight(list(/obj/random/tool_upgrade = 3,
	/obj/random/gun_tool = 0.5,//Only tool-like guns are randomly spawned, the military weapons stay in the armoury. More for theming than for balance
	/obj/random/firstaid = 2,
	/obj/random/glasses = 1,
	/obj/random/clothing = 1,
	/obj/random/accessory = 1,
	/obj/random/voidsuit = 0.2,
	/obj/random/armor = 1,
	/obj/random/pouch = 2,
	/obj/random/tool/advanced = 1,
	/obj/random/toolbox = 1,
	/obj/random/rig_module = 0.5))

/obj/random/rare_loot
	icon_state = "rareloot"


/obj/random/rare_loot/item_to_spawn()
	return pickweight(list( /obj/item/stack/power_node = 3,
	/obj/random/material/rare = 1))
	/obj/random/tool/modded = 1,
	/obj/random/material/rare = 1,
	/obj/random/hardsuit = 0.5))


/obj/random/rare_loot/usually
	spawn_nothing_percentage = USUALLY

/obj/random/rare_loot/often
	spawn_nothing_percentage = OFTEN

/obj/random/rare_loot/sometimes
	spawn_nothing_percentage = SOMETIMES

/obj/random/rare_loot/rarely
	spawn_nothing_percentage = RARELY