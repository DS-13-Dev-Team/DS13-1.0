/obj/machinery/cooker/candy
	name = "candy machine"
	desc = "Get yer candied cheese wheels here!"
	icon_state = "mixer_off"
	off_icon = "mixer_off"
	on_icon = "mixer_on"
	cook_type = "candied"

	output_options = list(
		"Jawbreaker" = /obj/item/weapon/reagent_containers/food/snacks/variable/jawbreaker,
		"Candy Bar" = /obj/item/weapon/reagent_containers/food/snacks/variable/candybar,
		"Sucker" = /obj/item/weapon/reagent_containers/food/snacks/variable/sucker,
		"Jelly" = /obj/item/weapon/reagent_containers/food/snacks/variable/jelly
		)

/obj/machinery/cooker/candy/Initialize()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/candymaker(null)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)

/obj/machinery/cooker/candy/change_product_appearance(obj/item/weapon/reagent_containers/food/snacks/product)
	food_color = get_random_colour(1)
	return ..()
