GLOBAL_VAR_INIT(asteroid_cannon, null)
GLOBAL_LIST_EMPTY(asteroids)

/**

Asteroid cannon!

Links to a control console, can be sabotaged by hitting it a bunch of times.

If the cannon goes offline, you need to repair it with a welder to ensure it won't instantly offline again, then reboot its ADS systems with the console
You'll need two people to do this, one to man the gun while it goes down, one to do the actual repairs.


*/
/obj/structure/asteroidcannon
	name = "Asteroid Defense System"
	desc = "A huge machine that shoots down oncoming asteroids."
	icon = 'icons/obj/asteroidcannon.dmi'
	icon_state = "asteroidgun"
	bound_height = 128
	bound_width = 128
	density = TRUE
	anchored = TRUE
	dir = EAST //Ship faces east, so does big mega gun.
	light_color="#ff0000" //Glows red when it's out of commission...
	health = 200
	max_health = 200 //Takes a lot of effort to take out.
	var/lead_distance = 0 //How aggressively to lead each shot. If set to 0 the bullets become hitscan.
	var/bullet_origin_offset = 4 //+/-x. Offsets the bullet so it can shoot "through the wall" to more closely mirror the source material's gun.
	var/firing_arc = 220
	var/fire_sound = 'sound/effects/asteroidcannon_fire.ogg'
	var/datum/extension/asteroidcannon/AC = null
	var/next_shot = 0
	var/fire_delay = 0.10 SECONDS
	var/operational = TRUE //Is it online?
	var/reboot_step = 0
	var/last_offline = 0 //When was it last taken offline? Used to spawn meteors when it's taken offline. Spite!

/obj/structure/asteroidcannon/attackby(obj/item/C, mob/user)
	. = ..()
	if(health < max_health)
		if(isWelder(C))
			if( C.use_tool(user, src, WORKTIME_NORMAL, QUALITY_WELDING, FAILCHANCE_NORMAL))
				to_chat(user, "<span class='notice'>You repair [src] with your welder...</span>")
				health = CLAMP(health, 0, max_health)

/obj/structure/asteroidcannon/take_damage(amount, damtype, user, used_weapon, bypass_resist)
	//The cannon can't be destroyed, but you can sure as hell knock it offline..
	if(health < amount)
		health = 10
		operational = FALSE
		visible_message("<span class='warning'>[src] sparks wildly!</span>")
		playsound(src, 'sound/effects/caution.ogg', 100, TRUE)
		//sparks
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, loc)
		spark_system.start()
		playsound(loc, "sparks", 50, 1)
		set_light(1)
		if(world.time >= last_offline + 5 MINUTES)
			var/datum/event/meteor_wave/E = new /datum/event/meteor_wave(new /datum/event_meta(pick(EVENT_LEVEL_MUNDANE, EVENT_LEVEL_MODERATE, EVENT_LEVEL_MAJOR))) //Don't let this thing get taken out.
			E.announce()
			last_offline = world.time
		return FALSE
	. = ..()

/obj/structure/asteroidcannon/proc/is_operational()
	return operational

/obj/structure/asteroidcannon/ex_act(severity)
	return FALSE

/obj/item/projectile/bullet/asteroidcannon
	name = "Accelerated Tungsten Slug"
	icon_state = "asteroidcannon"
	damage = 100
	step_delay = 0

/obj/item/projectile/bullet/asteroidcannon/Bump(atom/A, forced)
	. = ..()
	if(istype(A, /obj/effect/meteor))
		var/obj/effect/meteor/M = A
		M.visible_message("<span class='danger'>\The [M] breaks into dust!</span>")
		M.make_debris()
		qdel(M)
		qdel(src)

/obj/structure/asteroidcannon/proc/fire_at(atom/T)
	var/turf/out = get_turf(locate(src.x+bullet_origin_offset, src.y, src.z))
	if(Get_Angle(out, T) > firing_arc || world.time < next_shot || get_dist(out, src) <= 3)
		return FALSE
	flick("asteroidgun_firing", src)
	next_shot = world.time + fire_delay
	var/obj/item/projectile/bullet/asteroidcannon/bullet = new(out)
	playsound(src, fire_sound, 100, 1)
	//And apply the bullet offset... Gunners don't get hitscan bullets
	if(lead_distance <= 0)
		bullet.hitscan = TRUE
	bullet.launch(T)

/obj/structure/asteroidcannon/attack_hand(mob/user)
	start_gunning(user)

/obj/structure/asteroidcannon/proc/start_gunning(mob/user)
	if(!isliving(user) || user.is_necromorph())
		return FALSE //No.
	AC.set_gunner(user)

/obj/structure/asteroidcannon/Initialize(mapload, d)
	. = ..()
	if(GLOB.asteroid_cannon)
		message_admins("Duplicate asteroid cannon at [get_area(src)], [x], [y], [z] spawned!")
		return INITIALIZE_HINT_QDEL
	GLOB.asteroid_cannon = src
	//Sets up the overlay
	var/obj/asteroidover = new()
	asteroidover.forceMove(src)
	asteroidover.mouse_opacity = FALSE //Just a fluff overlay.
	asteroidover.layer = layer + 0.1
	asteroidover.icon = icon
	asteroidover.icon_state = "asteroidgun_over"
	vis_contents += asteroidover
	//Give it the shooty bit
	set_extension(src, /datum/extension/asteroidcannon)
	AC = get_extension(src, /datum/extension/asteroidcannon) //Cached for later.

/datum/extension/asteroidcannon
	var/obj/structure/asteroidcannon/gun = null
	var/mob/living/carbon/human/gunner = null
	var/mob/observer/eye/asteroidcannon/eyeobj = null

/mob/observer/eye/asteroidcannon
	var/obj/structure/asteroidcannon/gun = null

/mob/observer/eye/asteroidcannon/EyeMove(direct)
	if((direct == WEST) && (src.x < gun.x)) //No looking behind you...
		setLoc(get_turf(locate(gun.x, y)))
		return FALSE
	. = ..()

/mob/observer/eye/asteroidcannon/Destroy()
	gun = null
	. = ..()

/datum/extension/asteroidcannon/Process()
	if(gunner || !gun?.operational) //We've got a gunner, don't fire.
		return
	if(!GLOB.asteroids || !GLOB.asteroids.len)
		return
	//Meteor targeting!
	var/obj/effect/meteor/ME = pick(GLOB.asteroids)
	//Lead your shots.
	var/turf/aim_at = get_turf(ME)
	if(ME.velocity && gun.lead_distance > 0)
		aim_at = get_turf(locate(ME.x - (ME.velocity.x * gun.lead_distance), ME.y - (ME.velocity.y * gun.lead_distance), ME.z))
	else
		aim_at = ME
	gun.fire_at(aim_at)

/mob/living/carbon/human/proc/stop_gunning()
	set name = "Stop Gunning"
	set category = "Asteroid Defense System"
	var/datum/extension/asteroidcannon/AC = get_extension(GLOB.asteroid_cannon, /datum/extension/asteroidcannon)
	AC.remove_gunner()

/mob/living/carbon/human/proc/recenter_gunning()
	set name = "Jump To Cannon"
	set category = "Asteroid Defense System"
	var/datum/extension/asteroidcannon/AC = get_extension(GLOB.asteroid_cannon, /datum/extension/asteroidcannon)
	AC.recenter()

/datum/extension/asteroidcannon/proc/target_click(var/mob/user, var/atom/target, var/params)
	gun.fire_at(get_turf(target))

/datum/click_handler/target/asteroidcannon/stop()
	var/mob/living/carbon/human/H = user
	H.stop_gunning()
	. = ..()

/**
	Sets up the cannon for manual aiming, removes the autofire ability.
*/
/datum/extension/asteroidcannon/proc/set_gunner(mob/living/carbon/human/gunner)
	if(src.gunner)
		remove_gunner()
	src.gunner = gunner
	gunner.verbs |= /mob/living/carbon/human/proc/stop_gunning
	gunner.verbs |= /mob/living/carbon/human/proc/recenter_gunning
	gunner.forceMove(gun)
	gunner.pixel_x = 32
	gunner.pixel_y = 32
	gunner.set_dir(EAST)
	gunner.PushClickHandler(/datum/click_handler/target/asteroidcannon, CALLBACK(src, /datum/extension/asteroidcannon/proc/target_click, gunner))
	gun.vis_contents += gunner
	gun.lead_distance = 1 //Gunners don't get hitscan...
	eyeobj = new /mob/observer/eye/asteroidcannon(get_turf(gun))
	eyeobj.gun = gun
	eyeobj.acceleration = FALSE
	eyeobj.possess(gunner)

/datum/extension/asteroidcannon/proc/recenter()
	eyeobj?.setLoc(get_turf(gun))

/datum/extension/asteroidcannon/proc/remove_gunner()
	qdel(eyeobj)
	gun.lead_distance = initial(gun.lead_distance) //Gunners don't get hitscan...
	gunner.verbs -= /mob/living/carbon/human/proc/stop_gunning
	gunner.verbs -= /mob/living/carbon/human/proc/recenter_gunning
	gunner.eyeobj = null
	gunner.forceMove(get_turf(gun))
	gunner.pixel_x = 0
	gunner.pixel_y = 0
	gun.vis_contents -= gunner
	gunner = null

/datum/extension/asteroidcannon/New(datum/holder)
	if(!istype(holder, /obj/structure/asteroidcannon))
		return FALSE
	gun = holder
	START_PROCESSING(SSfastprocess, src)

// Asteroid cannon console.
/obj/machinery/computer/asteroidcannon
	name = "Asteroid Defense Mainframe"
	desc = "A console used to control the ship's automated asteroid defense systems."
	//circuit = /obj/item/weapon/circuitboard/asteroidcannon You know what. Gonna say no to this one. It'd be too easy to just decon the ADS console and dispose of the board.
	var/ui_template = "asteroidcannon.tmpl"
	var/obj/structure/asteroidcannon/gun = null
	var/time_per_step = 20 SECONDS

/obj/machinery/computer/asteroidcannon/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if (!gun)
		to_chat(user,"<span class='warning'>Unable to establish link with the asteroid cannon.</span>")
		return

	var/list/data = get_ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, ui_template, "[name]", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)

/obj/machinery/computer/asteroidcannon/attack_hand(user as mob)
	if(..(user))
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return TRUE

	ui_interact(user)

/obj/machinery/computer/asteroidcannon/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/asteroidcannon/LateInitialize()
	. = ..()
	gun = GLOB.asteroid_cannon

/obj/machinery/computer/asteroidcannon/proc/get_ui_data()
	var/list/data = list()
	data["can_magaccelerators"] = gun.reboot_step == 0
	data["can_fluxalignment"] = gun.reboot_step == 1
	data["can_targetingmatrix"] = gun.reboot_step == 2
	data["can_reboot"] = gun.reboot_step == 3
	data["is_operational"] = gun?.is_operational()
	data["cannon_status"] =  data["is_operational"] ? "ONLINE" : "OFFLINE"
	data["reboot_status"] = gun.reboot_step == -1 ? "REBOOTING...." : "IDLE" //It's set to -1 when it's "busy"
	return data

/obj/machinery/computer/asteroidcannon/OnTopic(user, href_list)
	if(!gun)
		return TOPIC_NOACTION

	if(href_list["magaccelerators"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/set_repair_step, 1), time_per_step)
		return TOPIC_REFRESH
	if(href_list["fluxalignment"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/set_repair_step, 2), time_per_step)
		return TOPIC_REFRESH
	if(href_list["targetingmatrix"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/set_repair_step, 3), time_per_step)
		return TOPIC_REFRESH
	if(href_list["reboot"])
		gun.reboot_step = -1
		addtimer(CALLBACK(src, .proc/reactivate_gun), time_per_step*2)
		return TOPIC_REFRESH

/obj/machinery/computer/asteroidcannon/proc/set_repair_step(step)
	gun?.reboot_step = step

/obj/machinery/computer/asteroidcannon/proc/reactivate_gun()
	gun?.operational = TRUE
	gun?.reboot_step = 0
	gun.set_light(0)
	playsound(src, 'sound/effects/compbeep5.ogg', 100, TRUE)