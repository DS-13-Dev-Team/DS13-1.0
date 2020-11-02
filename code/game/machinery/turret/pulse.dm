/obj/machinery/turret/covered/pulse
	shot_sound='sound/weapons/guns/fire/pulse_shot.ogg'
	eshot_sound='sound/weapons/guns/fire/pulse_shot.ogg'
	projectile = /obj/item/projectile/bullet/pulse
	eprojectile = /obj/item/projectile/bullet/pulse
	fire_delay = 1.05	//8 shots per second --- Not accurate. Decreased by 15% to provide more opportunity for crew as of 02-NOV-2020.
	desc = "A fully automated ballistic turret which fires pulse rounds at 480 RPM. It is somewhat inaccurate, but draws from the ship storage to have effectively unlimited ammunition."

/obj/machinery/turret/covered/pulse/active
	enabled = TRUE