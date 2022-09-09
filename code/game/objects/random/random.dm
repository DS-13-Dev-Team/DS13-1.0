/obj/random
	name = "random object"
	icon = 'icons/misc/landmarks.dmi'
	alpha = 100 //Or else they cover half of the map
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/min_amount = 1
	var/max_amount = 1
	var/spread_range = 0
	var/has_postspawn = FALSE

	var/possible_spawns = list()

	//Used only in subtypes. Items in this list are subtracted from possible spawns
	var/list/exclusions

	//Used only in subtypes. Items in this list are added to possible spawns
	var/list/additions

	can_block_movement = FALSE

// creates a new object and deletes itself
/obj/random/Initialize()
	..()

	if (exclusions)
		possible_spawns -= exclusions

	if (additions)
		possible_spawns += additions

	if(!prob(spawn_nothing_percentage))
		var/list/spawns = spawn_item()
		if (has_postspawn && spawns.len)
			post_spawn(spawns)

	return INITIALIZE_HINT_QDEL

// this function should return a specific item to spawn
/obj/random/proc/item_to_spawn()
	return pickweight(possible_spawns)

// this function should return a specific item to spawn
/obj/random/proc/post_spawn(var/list/spawns)
	return


// creates the random item
/obj/random/proc/spawn_item()
	var/list/points_for_spawn = list()
	var/list/spawns = list()
	if (spread_range && istype(loc, /turf))
		for(var/turf/T in RANGE_TURFS(src.loc, spread_range))
			//if (!T.is_wall && !T.is_hole)
			points_for_spawn += T
	else
		points_for_spawn += loc //We do not use get turf here, so that things can spawn inside containers
	for(var/i in 1 to rand(min_amount, max_amount))
		var/build_path = item_to_spawn()
		if (!build_path)
			return list()
		if(!points_for_spawn.len)
			log_debug("Spawner \"[type]\" ([x],[y],[z]) try spawn without free space around!")
			break
		var/atom/T = pick(points_for_spawn)
		var/atom/A = new build_path(T)
		spawns.Add(A)
	return spawns


/obj/random/single
	name = "randomly spawned object"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return ispath(spawn_object) ? spawn_object : text2path(spawn_object)

/obj/randomcatcher
	name = "Random Catcher Object"
	desc = "You should not see this."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"

/obj/randomcatcher/proc/get_item(type)
	new type(src)
	if (contents.len)
		. = pick(contents)
	else
		return null
/*


/obj/random
	name = "random object"
	desc = "This item type is used to spawn random objects at round-start."
	icon = 'icons/misc/mark.dmi'
	icon_state = "rup"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything

	var/spawn_method = /obj/random/proc/spawn_item

// creates a new object and deletes itself
/obj/random/Initialize()
	..()
	call(src, spawn_method)()
	return INITIALIZE_HINT_QDEL

// creates the random item
/obj/random/proc/spawn_item()
	if(prob(spawn_nothing_percentage))
		return

	if(isnull(loc))
		return

	var/build_path = pickweight(item_to_spawn())

	var/atom/A = new build_path(src.loc)
	if(pixel_x || pixel_y)
		A.pixel_x = pixel_x
		A.pixel_y = pixel_y

// Returns an associative list in format path:weight
/obj/random/proc/item_to_spawn()
	return pickweight(list()

/obj/random/single
	name = "randomly spawned object"
	desc = "This item type is used to randomly spawn a given object at round-start."
	icon_state = "x3"
	var/spawn_object = null

/obj/random/single/item_to_spawn()
	return pickweight(list(spawn_object)
*/


/obj/random/technology_scanner
	name = "random scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/items.dmi'
	icon_state = "atmos"

/obj/random/technology_scanner/item_to_spawn()
	return pickweight(list(/obj/item/t_scanner = 5,
				/obj/item/radio = 2,
				/obj/item/analyzer = 5))

/obj/random/powercell
	name = "random powercell"
	desc = "This is a random powercell."
	icon = 'icons/obj/power.dmi'
	icon_state = "hcell"

/obj/random/powercell/item_to_spawn()
	return pickweight(list(/obj/item/cell/crap = 1,
				/obj/item/cell = 8,
				/obj/item/cell/high = 5,
				/obj/item/cell/super = 2,
				/obj/item/cell/hyper = 1,
				/obj/item/cell/device/standard = 7,
				/obj/item/cell/device/high = 5))

/obj/random/bomb_supply
	name = "bomb supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "signaller"

/obj/random/bomb_supply/item_to_spawn()
	return pickweight(list(/obj/item/assembly/igniter,
				/obj/item/assembly/prox_sensor,
				/obj/item/assembly/signaler,
				/obj/item/assembly/timer,
				/obj/item/tool/multitool))




/obj/random/tech_supply
	name = "random tech supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50

/obj/random/tech_supply/item_to_spawn()
	return pickweight(list(/obj/random/powercell = 3,
				/obj/random/technology_scanner = 2,
				/obj/item/stack/package_wrap/twenty_five = 1,
				/obj/item/hand_labeler = 1,
				/obj/random/bomb_supply = 2,
				/obj/item/extinguisher = 1,
				/obj/item/clothing/gloves/insulated/cheap = 1,
				/obj/item/stack/cable_coil/random = 2,
				/obj/random/toolbox = 2,
				/obj/item/storage/belt/utility = 2,
				/obj/item/storage/belt/utility/atmostech = 1,
				/obj/random/tool = 5,
				/obj/item/tool/tape_roll = 2))

/obj/random/medical
	name = "Random Medical equipment"
	desc = "This is a random medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "traumakit"

/obj/random/medical/item_to_spawn()
	return pickweight(list(/obj/random/medical/lite = 21,
				/obj/item/bodybag = 2,
				/obj/item/reagent_containers/glass/bottle/inaprovaline = 2,
				/obj/item/reagent_containers/glass/bottle/antitoxin = 2,
				/obj/item/storage/pill_bottle = 2,
				/obj/item/storage/pill_bottle/tramadol = 1,
				/obj/item/storage/pill_bottle/citalopram = 2,
				/obj/item/storage/pill_bottle/dexalin_plus = 1,
				/obj/item/storage/pill_bottle/dermaline = 1,
				/obj/item/storage/pill_bottle/bicaridine = 1,
				/obj/item/reagent_containers/syringe/antitoxin = 2,
				/obj/item/reagent_containers/syringe/antiviral = 1,
				/obj/item/reagent_containers/syringe/inaprovaline = 2,
				/obj/item/storage/box/freezer = 1,
				/obj/item/stack/nanopaste = 1))

/obj/random/medical/lite
	name = "Random Medicine"
	desc = "This is a random simple medical item."
	icon = 'icons/obj/items.dmi'
	icon_state = "brutepack"
	spawn_nothing_percentage = 0

/obj/random/medical/lite/item_to_spawn()
	return pickweight(list(/obj/item/stack/medical/bruise_pack = 4,
				/obj/item/stack/medical/ointment = 4,
				/obj/item/storage/pill_bottle/antidexafen = 2,
				/obj/item/storage/pill_bottle/paracetamol = 2,
				/obj/item/stack/medical/advanced/bruise_pack = 2,
				/obj/item/stack/medical/advanced/ointment = 2,
				/obj/item/stack/medical/splint = 1,
				/obj/item/bodybag/cryobag = 1,
				/obj/item/reagent_containers/hypospray/autoinjector = 3,
				/obj/item/storage/pill_bottle/kelotane = 2,
				/obj/item/storage/pill_bottle/antitox = 2,
				/obj/item/storage/pill_bottle/inaprovaline = 2,
				/obj/item/storage/med_pouch/trauma = 2,
				/obj/item/storage/med_pouch/burn = 2,
				/obj/item/storage/med_pouch/toxin = 2,
				/obj/item/storage/med_pouch/radiation = 2,
				/obj/item/storage/med_pouch/oxyloss = 2))

/obj/random/firstaid
	name = "Random First Aid Kit"
	desc = "This is a random first aid kit."
	icon = 'icons/obj/storage.dmi'
	icon_state = "firstaid"

/obj/random/firstaid/item_to_spawn()
	return pickweight(list(/obj/item/storage/firstaid/regular = 4,
				/obj/item/storage/firstaid/trauma = 3,
				/obj/item/storage/firstaid/toxin = 3,
				/obj/item/storage/firstaid/o2 = 3,
				/obj/item/storage/firstaid/stab = 2,
				/obj/item/storage/firstaid/adv = 2,
				/obj/item/storage/firstaid/combat = 1,
				/obj/item/storage/firstaid/empty = 2,
				/obj/item/storage/firstaid/fire = 3))

/obj/random/contraband
	name = "Random Illegal Item"
	desc = "Hot Stuff."
	icon = 'icons/obj/items.dmi'
	icon_state = "purplecomb"
	spawn_nothing_percentage = 50

/obj/random/contraband/item_to_spawn()
	return pickweight(list(/obj/item/haircomb = 4,
				/obj/item/storage/pill_bottle/tramadol = 3,
				/obj/item/storage/pill_bottle/happy = 2,
				/obj/item/storage/pill_bottle/zoom = 2,
				/obj/item/contraband/poster = 5,
				/obj/item/material/butterfly = 2,
				/obj/item/material/butterflyblade = 3,
				/obj/item/material/butterflyhandle = 3,
				/obj/item/material/wirerod = 3,
				/obj/item/baton/cattleprod = 1,
				/obj/item/material/butterfly/switchblade = 1,
				/obj/item/storage/secure/briefcase/money = 0.01,
				/obj/item/reagent_containers/syringe = 3,
				/obj/item/reagent_containers/syringe/steroid = 2,
				/obj/item/reagent_containers/syringe/drugs = 1))

/obj/random/drinkbottle
	name = "random drink"
	desc = "This is a random drink."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"

/obj/random/drinkbottle/item_to_spawn()
	return pickweight(list(/obj/item/reagent_containers/food/drinks/bottle/whiskey,
				/obj/item/reagent_containers/food/drinks/bottle/gin,
				/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
				/obj/item/reagent_containers/food/drinks/bottle/vodka,
				/obj/item/reagent_containers/food/drinks/bottle/tequilla,
				/obj/item/reagent_containers/food/drinks/bottle/absinthe,
				/obj/item/reagent_containers/food/drinks/bottle/wine,
				/obj/item/reagent_containers/food/drinks/bottle/cognac,
				/obj/item/reagent_containers/food/drinks/bottle/rum,
				/obj/item/reagent_containers/food/drinks/bottle/patron))




/obj/random/action_figure
	name = "random action figure"
	desc = "This is a random action figure."
	icon = 'icons/obj/toy.dmi'
	icon_state = "assistant"

/obj/random/action_figure/item_to_spawn()
	return pickweight(list(/obj/item/toy/figure/cmo,
				/obj/item/toy/figure/assistant,
				/obj/item/toy/figure/atmos,
				/obj/item/toy/figure/bartender,
				/obj/item/toy/figure/borg,
				/obj/item/toy/figure/gardener,
				/obj/item/toy/figure/captain,
				/obj/item/toy/figure/cargotech,
				/obj/item/toy/figure/ce,
				/obj/item/toy/figure/chaplain,
				/obj/item/toy/figure/chef,
				/obj/item/toy/figure/chemist,
				/obj/item/toy/figure/clown,
				/obj/item/toy/figure/corgi,
				/obj/item/toy/figure/detective,
				/obj/item/toy/figure/dsquad,
				/obj/item/toy/figure/engineer,
				/obj/item/toy/figure/geneticist,
				/obj/item/toy/figure/hop,
				/obj/item/toy/figure/hos,
				/obj/item/toy/figure/qm,
				/obj/item/toy/figure/janitor,
				/obj/item/toy/figure/agent,
				/obj/item/toy/figure/librarian,
				/obj/item/toy/figure/md,
				/obj/item/toy/figure/mime,
				/obj/item/toy/figure/miner,
				/obj/item/toy/figure/ninja,
				/obj/item/toy/figure/wizard,
				/obj/item/toy/figure/rd,
				/obj/item/toy/figure/roboticist,
				/obj/item/toy/figure/scientist,
				/obj/item/toy/figure/syndie,
				/obj/item/toy/figure/secofficer,
				/obj/item/toy/figure/warden,
				/obj/item/toy/figure/psychologist,
				/obj/item/toy/figure/paramedic,
				/obj/item/toy/figure/ert))


/obj/random/plushie
	name = "random plushie"
	desc = "This is a random plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nymphplushie"

/obj/random/plushie/item_to_spawn()
	return pickweight(list(/obj/item/toy/plushie/nymph,
				/obj/item/toy/plushie/mouse,
				/obj/item/toy/plushie/kitten,
				/obj/item/toy/plushie/lizard,
				/obj/item/toy/plushie/spider))

/obj/random/plushie/large
	name = "random large plushie"
	desc = "This is a random large plushie."
	icon = 'icons/obj/toy.dmi'
	icon_state = "droneplushie"

/obj/random/plushie/large/item_to_spawn()
	return pickweight(list(/obj/structure/plushie/ian,
				/obj/structure/plushie/drone,
				/obj/structure/plushie/carp,
				/obj/structure/plushie/beepsky,
				/obj/structure/plushie/crow,
				/obj/structure/plushie/peng
				))

/obj/random/junk //Broken items, or stuff that could be picked up
	name = "random junk"
	desc = "This is some random junk."
	icon = 'icons/obj/trash.dmi'
	icon_state = "trashbag3"

/obj/random/junk/item_to_spawn()
	return get_random_junk_type()

/obj/random/trash //Mostly remains and cleanable decals. Stuff a janitor could clean up
	name = "random trash"
	desc = "This is some random trash."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/random/trash/item_to_spawn()
	return pickweight(list(/obj/item/remains/lizard,
				/obj/effect/decal/cleanable/blood/gibs/robot,
				/obj/effect/decal/cleanable/blood/oil,
				/obj/effect/decal/cleanable/blood/oil/streak,
				/obj/item/remains/mouse,
				/obj/effect/decal/cleanable/vomit,
				/obj/effect/decal/cleanable/blood/splatter,
				/obj/effect/decal/cleanable/ash,
				/obj/effect/decal/cleanable/generic,
				/obj/effect/decal/cleanable/flour,
				/obj/effect/decal/cleanable/dirt))


//Random closet is being repurposed as a more generic random large/dense object spawner.
//The path wont be changed for now to prevent breaking the map
obj/random/closet
	name = "random dense object"
	desc = "This is a dense object."
	icon = 'icons/obj/closet.dmi'
	icon_state = "syndicate1"

obj/random/closet/item_to_spawn()
	return pickweight(list(/obj/structure/closet,
				/obj/structure/closet/firecloset,
				/obj/structure/closet/emcloset,
				/obj/structure/closet/jcloset,
				/obj/structure/closet/toolcloset,
				/obj/structure/closet/crate,
				/obj/structure/closet/crate/freezer,
				/obj/structure/closet/crate/freezer/rations,
				/obj/structure/closet/crate/internals,
				/obj/structure/closet/crate/trashcart,
				/obj/structure/closet/crate/medical,
				/obj/structure/largecrate,
				/obj/structure/reagent_dispensers/fueltank = 0.5))

/obj/random/coin
	name = "random coin"
	desc = "This is a random coin."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin"

/obj/random/coin/item_to_spawn()
	return pickweight(list(/obj/item/coin/gold = 3,
				/obj/item/coin/silver = 4,
				/obj/item/coin/diamond = 2,
				/obj/item/coin/iron = 4,
				/obj/item/coin/uranium = 3,
				/obj/item/coin/platinum = 1,
				/obj/item/coin/phoron = 1))

/obj/random/toy
	name = "random toy"
	desc = "This is a random toy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"

/obj/random/toy/item_to_spawn()
	return pickweight(list(/obj/item/toy/bosunwhistle,
				/obj/item/toy/therapy_red,
				/obj/item/toy/therapy_purple,
				/obj/item/toy/therapy_blue,
				/obj/item/toy/therapy_yellow,
				/obj/item/toy/therapy_orange,
				/obj/item/toy/therapy_green,
				/obj/item/toy/cultsword,
				/obj/item/toy/katana,
				/obj/item/toy/snappop,
				/obj/item/toy/sword,
				/obj/item/toy/water_balloon,
				/obj/item/toy/crossbow,
				/obj/item/toy/blink,
				/obj/item/reagent_containers/spray/waterflower,
				/obj/item/toy/prize/ripley,
				/obj/item/toy/prize/fireripley,
				/obj/item/toy/prize/deathripley,
				/obj/item/toy/prize/gygax,
				/obj/item/toy/prize/durand,
				/obj/item/toy/prize/honk,
				/obj/item/toy/prize/marauder,
				/obj/item/toy/prize/seraph,
				/obj/item/toy/prize/mauler,
				/obj/item/toy/prize/odysseus,
				/obj/item/toy/prize/phazon,
				/obj/item/deck/cards))

/obj/random/tank
	name = "random tank"
	desc = "This is a tank."
	icon = 'icons/obj/tank.dmi'
	icon_state = "canister"

/obj/random/tank/item_to_spawn()
	return pickweight(list(/obj/item/tank/oxygen = 5,
				/obj/item/tank/oxygen/yellow = 4,
				/obj/item/tank/oxygen/red = 4,
				/obj/item/tank/air = 3,
				/obj/item/tank/emergency/oxygen = 4,
				/obj/item/tank/emergency/oxygen/engi = 3,
				/obj/item/tank/emergency/oxygen/double = 2,
				/obj/item/tank/emergency/nitrogen = 2,
				/obj/item/tank/emergency/nitrogen/double = 1,
				/obj/item/tank/nitrogen = 1,
				/obj/item/suit_cooling_unit = 1))

/obj/random/material //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"

/obj/random/material/item_to_spawn()
	return pickweight(list(/obj/item/stack/material/steel/ten,
				/obj/item/stack/material/glass/ten,
				/obj/item/stack/material/glass/reinforced/ten,
				/obj/item/stack/material/plastic/ten,
				/obj/item/stack/material/wood/ten,
				/obj/item/stack/material/cardboard/ten,
				/obj/item/stack/rods/ten,
				/obj/item/stack/material/plasteel/ten = 0.5,
				/obj/item/stack/material/steel/fifty = 0.2,
				/obj/item/stack/material/glass/fifty = 0.2,
				/obj/item/stack/material/glass/reinforced/fifty = 0.2,
				/obj/item/stack/material/plastic/fifty = 0.2,
				/obj/item/stack/material/wood/fifty = 0.2,
				/obj/item/stack/material/cardboard/fifty = 0.2,
				/obj/item/stack/rods/fifty = 0.2,
				/obj/item/stack/material/plasteel/fifty = 0.1))


/obj/random/material/rare //Random materials for building stuff
	name = "random material"
	desc = "This is a random material."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet-metal"

/obj/random/material/rare/item_to_spawn()
	return	pickweight(list(/obj/item/stack/material/diamond/ten = 7,
				/obj/item/stack/material/glass/phoronrglass/ten = 7,
				/obj/item/stack/material/phoron/ten = 7,
				/obj/item/stack/material/gold/ten = 7,
				/obj/item/stack/material/silver/ten = 7,
				/obj/item/stack/material/osmium/ten = 7,
				/obj/item/stack/material/platinum/ten = 8,
				/obj/item/stack/material/tritium/ten = 7,
				/obj/item/stack/material/mhydrogen/ten = 6,
				/obj/item/stack/material/plasteel/ten = 9,))


/obj/random/soap
	name = "Random Cleaning Supplies"
	desc = "This is a random bar of soap. Soap! SOAP?! SOAP!!!"
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"

/obj/random/soap/item_to_spawn()
	return pickweight(list(/obj/item/soap = 4,
				/obj/item/soap/deluxe = 3,
				/obj/item/soap/gold = 1))

obj/random/obstruction //Large objects to block things off in maintenance
	name = "random obstruction"
	desc = "This is a random obstruction."
	icon = 'icons/obj/cult.dmi'
	icon_state = "cultgirder"
	alpha = 128

obj/random/obstruction/item_to_spawn()
	return pickweight(list(/obj/structure/barricade,
				/obj/structure/girder,
				/obj/structure/girder/displaced,
				/obj/structure/girder/reinforced,
				/obj/structure/grille,
				/obj/structure/grille/broken,
				/obj/structure/foamedmetal,
				/obj/structure/inflatable/wall,
				/obj/structure/inflatable/door))

/obj/random/assembly
	name = "random assembly"
	desc = "This is a random circuit assembly."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1"

/obj/random/assembly/item_to_spawn()
	return pickweight(list(/obj/item/electronic_assembly/calc,
				/obj/item/electronic_assembly/clam,
				/obj/item/electronic_assembly/default,
				/obj/item/electronic_assembly/drone/android,
				/obj/item/electronic_assembly/drone/arms,
				/obj/item/electronic_assembly/drone/default,
				/obj/item/electronic_assembly/drone/genbot,
				/obj/item/electronic_assembly/drone/genbot,
				/obj/item/electronic_assembly/drone/medbot,
				/obj/item/electronic_assembly/drone/secbot,
				/obj/item/electronic_assembly/hook,
				/obj/item/electronic_assembly/pda,
				/obj/item/electronic_assembly/simple,
				/obj/item/electronic_assembly/medium/box,
				/obj/item/electronic_assembly/medium/clam,
				/obj/item/electronic_assembly/medium/default,
				/obj/item/electronic_assembly/medium/gun,
				/obj/item/electronic_assembly/medium/medical,
				/obj/item/electronic_assembly/medium/radio,
				/obj/item/electronic_assembly/large/arm,
				/obj/item/electronic_assembly/large/default,
				/obj/item/electronic_assembly/large/industrial,
				/obj/item/electronic_assembly/large/scope,
				/obj/item/electronic_assembly/large/tall,
				/obj/item/electronic_assembly/large/terminal,
				/obj/item/electronic_assembly/wallmount/heavy,
				/obj/item/electronic_assembly/wallmount/light))

/obj/random/advdevice
	name = "random advanced device"
	desc = "This is a random advanced device."
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"

/obj/random/advdevice/item_to_spawn()
	return pickweight(list(/obj/item/flashlight/lantern,
				/obj/item/flashlight/flare,
				/obj/item/flashlight/pen,
				/obj/item/toner,
				/obj/item/destTagger,
				/obj/item/handcuffs,
				/obj/item/camera_assembly,
				/obj/item/camera,
				/obj/item/modular_computer/pda,
				/obj/item/radio/headset,
				/obj/item/flashlight/flare/glowstick/yellow,
				/obj/item/flashlight/flare/glowstick/orange,
				/obj/item/oxycandle))


/obj/random/light
	name = "random light"
	desc = "This is a random advanced device."
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"

/obj/random/light/item_to_spawn()
	return pickweight(list(/obj/item/flashlight/lantern,
			/obj/item/flashlight/flare,
			/obj/item/flashlight/pen,
			/obj/item/storage/box/glowsticks,
			/obj/item/flashlight/upgraded = 0.5,
			/obj/item/flashlight/maglight,
			/obj/item/flashlight/lamp,
			/obj/item/flashlight/lamp = 0.5,
			/obj/item/flashlight = 2))


/obj/random/smokes
	name = "random smokeable"
	desc = "This is a random smokeable item."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "Bpacket"

/obj/random/smokes/item_to_spawn()
	return pickweight(list(/obj/item/storage/fancy/cigarettes = 5,
				/obj/item/storage/fancy/cigarettes/dromedaryco = 4,
				/obj/item/storage/fancy/cigarettes/killthroat = 1,
				/obj/item/storage/fancy/cigarettes/luckystars = 3,
				/obj/item/storage/fancy/cigarettes/jerichos = 3,
				/obj/item/storage/fancy/cigarettes/menthols = 2,
				/obj/item/storage/fancy/cigarettes/carcinomas = 3,
				/obj/item/storage/fancy/cigarettes/professionals = 2))

/obj/random/masks
	name = "random mask"
	desc = "This is a random face mask."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "gas_mask"

/obj/random/masks/item_to_spawn()
	return pickweight(list(/obj/item/clothing/mask/gas = 4,
				/obj/item/clothing/mask/gas/half = 5,
				/obj/item/clothing/mask/breath = 6,
				/obj/item/clothing/mask/breath/medical = 4,
				/obj/item/clothing/mask/balaclava = 3,
				/obj/item/clothing/mask/surgical = 4))

/obj/random/snack
	name = "random snack"
	desc = "This is a random snack item."
	icon = 'icons/obj/food.dmi'
	icon_state = "sosjerky"

/obj/random/snack/item_to_spawn()
	return pickweight(list(/obj/item/reagent_containers/food/snacks/liquidfood,
				/obj/item/reagent_containers/food/snacks/candy,
				/obj/item/reagent_containers/food/drinks/dry_ramen,
				/obj/item/reagent_containers/food/snacks/chips,
				/obj/item/reagent_containers/food/snacks/sosjerky,
				/obj/item/reagent_containers/food/snacks/no_raisin,
				/obj/item/reagent_containers/food/snacks/spacetwinkie,
				/obj/item/reagent_containers/food/snacks/cheesiehonkers,
				/obj/item/reagent_containers/food/snacks/tastybread,
				/obj/item/reagent_containers/food/snacks/candy/proteinbar,
				/obj/item/reagent_containers/food/snacks/donut,
				/obj/item/reagent_containers/food/snacks/donut/cherryjelly,
				/obj/item/reagent_containers/food/snacks/donut/jelly,
				/obj/item/pizzabox/meat,
				/obj/item/pizzabox/vegetable,
				/obj/item/pizzabox/margherita,
				/obj/item/pizzabox/mushroom))


/obj/random/storage
	name = "random storage item"
	desc = "This is a storage item."
	icon = 'icons/obj/storage.dmi'
	icon_state = "idOld"

/obj/random/storage/item_to_spawn()
	return pickweight(list(/obj/item/storage/secure/briefcase = 2,
				/obj/item/storage/briefcase = 4,
				/obj/item/storage/briefcase/inflatable = 3,
				/obj/item/storage/backpack = 5,
				/obj/item/storage/backpack/satchel = 5,
				/obj/item/storage/backpack/dufflebag = 2,
				/obj/item/storage/box = 5,
				/obj/item/storage/box/donkpockets = 3,
				/obj/item/storage/box/donut = 2,
				/obj/item/storage/box/cups = 3,
				/obj/item/storage/box/mousetraps = 4,
				/obj/item/storage/box/engineer = 3,
				/obj/item/storage/box/autoinjectors = 2,
				/obj/item/storage/box/beakers = 3,
				/obj/item/storage/box/syringes = 3,
				/obj/item/storage/box/gloves = 3,
				/obj/item/storage/box/large = 2,
				/obj/item/storage/box/glowsticks = 3,
				/obj/item/storage/wallet = 1,
				/obj/item/storage/ore = 2,
				/obj/item/storage/belt/utility/full = 2,
				/obj/item/storage/belt/medical = 2,
				/obj/item/storage/belt/holster/security = 2,
				/obj/item/storage/belt/holster/security/tactical = 1))

/obj/random/shoes
	name = "random footwear"
	desc = "This is a random pair of shoes."
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "boots"

/obj/random/shoes/item_to_spawn()
	return pickweight(list(/obj/item/clothing/shoes/workboots = 3,
				/obj/item/clothing/shoes/combat = 1,
				/obj/item/clothing/shoes/magboots = 1,
				/obj/item/clothing/shoes/laceup = 4,
				/obj/item/clothing/shoes/black = 4,
				/obj/item/clothing/shoes/jungleboots = 3,
				/obj/item/clothing/shoes/desertboots = 3,
				/obj/item/clothing/shoes/dutyboots = 3,
				/obj/item/clothing/shoes/tactical = 1,
				/obj/item/clothing/shoes/dress = 3,
				/obj/item/clothing/shoes/dress/white = 3,
				/obj/item/clothing/shoes/sandal = 3,
				/obj/item/clothing/shoes/brown = 4,
				/obj/item/clothing/shoes/leather = 4))

/obj/random/gloves
	name = "random gloves"
	desc = "This is a random pair of gloves."
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "rainbow"

/obj/random/gloves/item_to_spawn()
	return pickweight(list(/obj/item/clothing/gloves/insulated = 3,
				/obj/item/clothing/gloves/thick = 6,
				/obj/item/clothing/gloves/latex = 4,
				/obj/item/clothing/gloves/thick/swat = 3,
				/obj/item/clothing/gloves/thick/combat = 3,
				/obj/item/clothing/gloves/white = 5,
				/obj/item/clothing/gloves/duty = 5,
				/obj/item/clothing/gloves/tactical = 3,
				/obj/item/clothing/gloves/insulated/cheap = 5))

/obj/random/glasses
	name = "random eyewear"
	desc = "This is a random pair of glasses."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "glasses"

/obj/random/glasses/item_to_spawn()
	return pickweight(list(/obj/item/clothing/glasses/sunglasses = 3,
				/obj/item/clothing/glasses/regular = 7,
				/obj/item/clothing/glasses/meson = 5,
				/obj/item/clothing/glasses/meson/prescription = 4,
				/obj/item/clothing/glasses/science = 6,
				/obj/item/clothing/glasses/material = 5,
				/obj/item/clothing/glasses/welding = 3,
				/obj/item/clothing/glasses/hud/health = 4,
				/obj/item/clothing/glasses/hud/health/prescription = 3,
				/obj/item/clothing/glasses/hud/security = 4,
				/obj/item/clothing/glasses/hud/security/prescription = 3,
				/obj/item/clothing/glasses/sunglasses/sechud = 2,
				/obj/item/clothing/glasses/sunglasses/sechud/toggle = 3,
				/obj/item/clothing/glasses/tacgoggles = 1))

/obj/random/hat
	name = "random headgear"
	desc = "This is a random hat of some kind."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "tophat"

/obj/random/hat/item_to_spawn()
	return pickweight(list(/obj/item/clothing/head/helmet = 2,
				/obj/item/clothing/head/helmet/space/void = 1,
				/obj/item/clothing/head/bio_hood/general = 1,
				/obj/item/clothing/head/hardhat = 4,
				/obj/item/clothing/head/hardhat/orange = 4,
				/obj/item/clothing/head/hardhat/red = 4,
				/obj/item/clothing/head/hardhat/dblue = 4,
				/obj/item/clothing/head/welding = 2))

/obj/random/suit
	name = "random suit"
	desc = "This is a random piece of outerwear."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "firesuit"

/obj/random/suit/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/storage/hazardvest = 4,
				/obj/item/clothing/suit/storage/toggle/labcoat = 4,
				/obj/item/clothing/suit/space/void = 1,
				/obj/item/clothing/suit/armor/vest = 4,
				/obj/item/clothing/suit/storage/vest/tactical = 1,
				/obj/item/clothing/suit/storage/vest = 3,
				/obj/item/clothing/suit/storage/toggle/bomber = 3,
				/obj/item/clothing/suit/chef/classic = 3,
				/obj/item/clothing/suit/apron/overalls = 3,
				/obj/item/clothing/suit/bio_suit/general = 1,
				/obj/item/clothing/suit/storage/toggle/hoodie/black = 3,
				/obj/item/clothing/suit/storage/toggle/brown_jacket = 3,
				/obj/item/clothing/suit/storage/leather_jacket = 3,
				/obj/item/clothing/suit/apron = 4))

/obj/random/clothing
	name = "random clothes"
	desc = "This is a random piece of clothing."
	icon = 'icons/obj/clothing/uniforms.dmi'
	icon_state = "grey"

/obj/random/clothing/item_to_spawn()
	return pickweight(list(/obj/item/clothing/under/hazard = 4,
				/obj/item/clothing/under/sterile = 4,
				/obj/item/clothing/under/casual_pants/camo = 2,
				/obj/item/clothing/under/harness = 2,
				/obj/item/clothing/under/rank/medical/paramedic = 2,
				/obj/item/clothing/ears/earmuffs = 2,
				/obj/item/clothing/under/tactical = 1))

/obj/random/accessory
	name = "random accessory"
	desc = "This is a random utility accessory."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "horribletie"

/obj/random/accessory/item_to_spawn()
	return pickweight(list(/obj/item/clothing/accessory/storage/webbing = 3,
				/obj/item/clothing/accessory/storage/webbing_large = 3,
				/obj/item/clothing/accessory/storage/black_vest = 2,
				/obj/item/clothing/accessory/storage/brown_vest = 2,
				/obj/item/clothing/accessory/storage/white_vest = 2,
				/obj/item/clothing/accessory/storage/bandolier = 1,
				/obj/item/clothing/accessory/storage/holster/thigh = 1,
				/obj/item/clothing/accessory/storage/holster/hip = 1,
				/obj/item/clothing/accessory/storage/holster/waist = 1,
				/obj/item/clothing/accessory/storage/holster/armpit = 1,
				/obj/item/clothing/accessory/kneepads = 3,
				/obj/item/clothing/accessory/stethoscope = 2))

/obj/random/cash
	name = "random currency"
	desc = "LOADSAMONEY!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"

/obj/random/cash/item_to_spawn()
	return pickweight(list(/obj/item/spacecash/ewallet/random/c200 = 8,
				/obj/item/spacecash/ewallet/random/c500 = 6,
				/obj/item/spacecash/ewallet/random/c1000 = 4,
				/obj/item/spacecash/ewallet/random/c5000 = 2,
				/obj/item/spacecash/ewallet/random/c10000 = 1))

/obj/random/cash_poor
	name = "lesser random currency"
	desc = "LOADSAMONEY!"
	icon = 'icons/obj/items.dmi'
	icon_state = "spacecash1"

/obj/random/cash_poor/item_to_spawn()
	return pickweight(list(/obj/item/spacecash/ewallet/random/c200 = 9,
				/obj/item/spacecash/ewallet/random/c500 = 1))

/obj/random/voidhelmet
	name = "Random Voidsuit Helmet"
	desc = "This is a random voidsuit helmet."
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "void"

/obj/random/voidhelmet/item_to_spawn()
	return pickweight(list(/obj/item/clothing/head/helmet/space/void,
				/obj/item/clothing/head/helmet/space/void/engineering,
				/obj/item/clothing/head/helmet/space/void/engineering/alt,
				/obj/item/clothing/head/helmet/space/void/engineering/salvage,
				/obj/item/clothing/head/helmet/space/void/mining,
				/obj/item/clothing/head/helmet/space/void/mining/alt,
				/obj/item/clothing/head/helmet/space/void/security,
				/obj/item/clothing/head/helmet/space/void/security/alt,
				/obj/item/clothing/head/helmet/space/void/atmos,
				/obj/item/clothing/head/helmet/space/void/merc,
				/obj/item/clothing/head/helmet/space/void/medical,
				/obj/item/clothing/head/helmet/space/void/medical/alt))

/obj/random/voidsuit
	name = "Random Voidsuit"
	desc = "This is a random voidsuit."
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "void"

/obj/random/voidsuit/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/space/void,
				/obj/item/clothing/suit/space/void/engineering,
				/obj/item/clothing/suit/space/void/engineering/alt,
				/obj/item/clothing/suit/space/void/engineering/salvage,
				/obj/item/clothing/suit/space/void/mining,
				/obj/item/clothing/suit/space/void/mining/alt,
				/obj/item/clothing/suit/space/void/security,
				/obj/item/clothing/suit/space/void/security/alt,
				/obj/item/clothing/suit/space/void/atmos,
				/obj/item/clothing/suit/space/void/merc,
				/obj/item/clothing/suit/space/void/medical,
				/obj/item/clothing/suit/space/void/medical/alt))



var/list/multi_point_spawns

/obj/random_multi
	name = "random object spawn point"
	desc = "This item type is used to spawn random objects at round-start. Only one spawn point for a given group id is selected."
	icon = 'icons/misc/mark.dmi'
	icon_state = "x3"
	invisibility = INVISIBILITY_MAXIMUM
	var/id     // Group id
	var/weight // Probability weight for this spawn point

/obj/random_multi/Initialize()
	. = ..()
	weight = max(1, round(weight))

	if(!multi_point_spawns)
		multi_point_spawns = list()
	var/list/spawnpoints = multi_point_spawns[id]
	if(!spawnpoints)
		spawnpoints = list()
		multi_point_spawns[id] = spawnpoints
	spawnpoints[src] = weight

/obj/random_multi/Destroy()
	var/list/spawnpoints = multi_point_spawns[id]
	spawnpoints -= src
	if(!spawnpoints.len)
		multi_point_spawns -= id
	. = ..()

/obj/random_multi/proc/generate_items()
	return

/obj/random_multi/single_item
	var/item_path  // Item type to spawn

/obj/random_multi/single_item/generate_items()
	new item_path(loc)

/hook/roundstart/proc/generate_multi_spawn_items()
	for(var/id in multi_point_spawns)
		var/list/spawn_points = multi_point_spawns[id]
		var/obj/random_multi/rm = pickweight(spawn_points)
		rm.generate_items()
		for(var/entry in spawn_points)
			qdel(entry)
	return 1

/obj/random_multi/single_item/captains_spare_id
	name = "Multi Point - Captain's Spare"
	id = "Captain's spare id"
	item_path = /obj/item/card/id/captains_spare

var/list/random_junk_
var/list/random_useful_
/proc/get_random_useful_type()
	if(!random_useful_)
		random_useful_ = list()
		random_useful_ += /obj/item/pen/crayon/random
		random_useful_ += /obj/item/pen
		random_useful_ += /obj/item/pen/blue
		random_useful_ += /obj/item/pen/red
		random_useful_ += /obj/item/pen/multi
		random_useful_ += /obj/item/storage/box/matches
		random_useful_ += /obj/item/stack/material/cardboard
		random_useful_ += /obj/item/storage/fancy/cigarettes
		random_useful_ += /obj/item/deck/cards
	return pick(random_useful_)

/proc/get_random_junk_type()
	if(prob(20)) // Misc. clutter
		return /obj/effect/decal/cleanable/generic

	// 80% chance that we reach here
	if(prob(95)) // Misc. junk
		if(!random_junk_)
			random_junk_ = subtypesof(/obj/item/trash)
			random_junk_ += typesof(/obj/item/cigbutt)
			random_junk_ += /obj/item/remains/mouse
			random_junk_ += /obj/item/paper/crumpled
			random_junk_ += /obj/item/inflatable/torn
			random_junk_ += /obj/effect/decal/cleanable/molten_item
			random_junk_ += /obj/item/material/shard
			random_junk_ += /obj/item/hand/missing_card

			random_junk_ -= /obj/item/trash/plate
			random_junk_ -= /obj/item/trash/snack_bowl
			random_junk_ -= /obj/item/trash/tray
		return pick(random_junk_)

	// Misc. actually useful stuff or perhaps even food
	// 4% chance that we reach here
	if(prob(75))
		return get_random_useful_type()

	// 1% chance that we reach here
	var/lunches = lunchables_lunches()
	return lunches[pick(lunches)]
