/obj/effect/effect/expanding_circle
	alpha = 100
	var/lifespan
	var/expansion_rate
	icon_state = "circle"
	icon = 'icons/effects/effects_256.dmi'
	pixel_x = -112
	pixel_y = -112


/obj/effect/effect/expanding_circle/New(var/atom/loc, var/_expansion_rate = 2, var/_lifespan = 2 SECOND, var/_color = "#ffffff")
	lifespan = _lifespan
	expansion_rate = _expansion_rate //What scale multiplier to gain per second
	color = _color
	world << "Color is [color]"
	..()

/obj/effect/effect/expanding_circle/Initialize()
	.=..()
	transform = transform.Scale(0.01)//Start off tiny
	var/matrix/M = new
	animate(src, transform = M.Scale(1 + (expansion_rate * (lifespan*0.1))), alpha = 0, time = lifespan)
	QDEL_IN(src, lifespan)
	world << "Color2 is [color]"
	spawn(3)
		world << "Color3 is [color]"