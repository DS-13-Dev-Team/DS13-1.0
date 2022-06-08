/datum/build_mode/light_maker
	name = "Light Maker"
	icon_state = "buildmode8"

	var/light_range = 3
	var/light_power = 3
	var/light_color = COLOR_WHITE
	var/light_on = TRUE

/datum/build_mode/light_maker/Help()
	to_chat(usr, "<span class='notice'>***********************************************************</span>")
	to_chat(usr, "<span class='notice'>Left Click                       = Make it glow</span>")
	to_chat(usr, "<span class='notice'>Right Click                      = Reset glow</span>")
	to_chat(usr, "<span class='notice'>Right Click on Build Mode Button = Change glow properties</span>")
	to_chat(usr, "<span class='notice'>***********************************************************</span>")

/datum/build_mode/light_maker/Configurate()
	var/choice = tgui_alert(usr, "Change the new light range, power, color or turn it on?", "Light Maker", list("Range", "Power", "Color", "Light On", "Cancel"))
	switch(choice)
		if("Range")
			var/input = input("New light range.", name, light_range) as null|num
			if(input)
				light_range = input
		if("Power")
			var/input = input("New light power.", name, light_power) as null|num
			if(input)
				light_power = input
		if("Color")
			var/input = input("New light color.", name, light_color) as null|color
			if(input)
				light_color = input
		if("Light On")
			var/input = input("Turn on light.", name, light_on) as null|num
			if(input)
				light_on = TRUE
			else
				light_on = FALSE

/datum/build_mode/light_maker/OnClick(var/atom/A, var/list/parameters)
	if(parameters["left"])
		if(A)
			A.set_light_power(light_power)
			A.set_light_range(light_range)
			A.set_light_color(light_color)
			A.set_light_on(light_on)
	if(parameters["right"])
		if(A)
			A.set_light_power(initial(A.light_power))
			A.set_light_range(initial(A.light_range))
			A.set_light_color(initial(A.light_color))
			A.set_light_on(initial(A.light_on))
