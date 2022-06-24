#include "errant_pisces_areas.dm"

/obj/effect/overmap/ship/errant_pisces
	name = "XCV Ahab's Harpoon"
	desc = "Sensors detect civilian vessel with unusual signs of life aboard."
	color = "#bd6100"
	vessel_mass = 150
	default_delay = 20 SECONDS
	speed_mod = 10 SECONDS
	burn_delay = 15 SECONDS

/datum/map_template/ruin/away_site/errant_pisces
	name = "Errant Pisces"
	id = "awaysite_errant_pisces"
	description = "Xynergy carp trawler"
	suffixes = list("errant_pisces/errant_pisces.dmm")
	cost = 1

/mob/living/simple_animal/hostile/carp/shark // generally stronger version of a carp that doesn't die from a mean look. Fance new sprites included, credits to F-Tang Steve
	name = "cosmoshark"
	desc = "Enormous creature that resembles a shark with magenta glowing lines along its body and set of long deep-purple teeth."
	icon = 'maps/away/errant_pisces/errant_pisces_sprites.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_gib = "shark_dead"
	turns_per_move = 8
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	speed = 8
	max_health = 75
	health = 75
	harm_intent_damage = 20
	melee_damage_lower = 20
	melee_damage_upper = 20
	break_stuff_probability = 25
	faction = "shark"

/mob/living/simple_animal/hostile/carp/shark/death()
	..()
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/datum/gas_mixture/sharkmaw_phoron = new
		sharkmaw_phoron.adjust_gas(MATERIAL_PHORON,  10)
		environment.merge(sharkmaw_phoron)
		visible_message("<span class='warning'>\The [src]'s body releases some gas from the gills with a quiet fizz!</span>")

/mob/living/simple_animal/hostile/carp/shark/AttackingTarget()
	set waitfor = 0//to deal with sleep() possibly stalling other procs
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(25))//if one is unlucky enough, they get tackled few tiles away
			L.visible_message("<span class='danger'>\The [src] tackles [L]!</span>")
			var/tackle_length = rand(3,5)
			for (var/i = 1 to tackle_length)
				var/turf/T = get_step(L.loc, dir)//on a first step of tackling standing mob would block movement so let's check if there's something behind it. Works for consequent moves too
				if (T.density || LinkBlocked(L.loc, T) || TurfBlockedNonWindow(T) || DirBlocked(T, GLOB.flip_dir[dir]))
					break
				sleep(2)
				forceMove(T)//maybe there's better manner then just forceMove() them
				L.forceMove(T)
			visible_message("<span class='danger'>\The [src] releases [L].</span>")

/obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	name = "cosmoshark fillet"
	desc = "A fillet of cosmoshark meat."
	icon_state = "fishfillet"
	filling_color = "#cecece"
	center_of_mass = "x=17;y=13"

/obj/item/weapon/reagent_containers/food/snacks/sharkmeat/New()
	..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)
	reagents.add_reagent(/datum/reagent/space_drugs, 1)
	reagents.add_reagent(/datum/reagent/toxin/phoron, 1)
	src.bitesize = 8



/obj/item/clothing/under/carp//as far as I know sprites are taken from /tg/
	name = "space carp suit"
	desc = "A suit in a shape of a space carp. Usually worn by corporate interns who are sent to entertain children during HQ excursions."
	icon_state = "carp_suit"
	icon = 'maps/away/errant_pisces/errant_pisces_sprites.dmi'
	item_icons = list(slot_w_uniform_str = 'maps/away/errant_pisces/errant_pisces_sprites.dmi')

/obj/effect/landmark/corpse/carp_fisher
	name = "carp fisher"
	corpse_outfits = list(/decl/hierarchy/outfit/corpse/carp_fisher)
	species = list(SPECIES_HUMAN = 70, SPECIES_IPC = 20, SPECIES_UNATHI = 10)

/decl/hierarchy/outfit/corpse/carp_fisher
	name = "Dead carp fisher"
	uniform = /obj/item/clothing/under/color/green
	suit = /obj/item/clothing/suit/apron/overalls
	belt = /obj/item/weapon/material/hatchet/tacknife
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/hardhat/dblue
