GLOBAL_VAR_INIT(asteroid_cannon, null)
GLOBAL_LIST_EMPTY(asteroids)

/obj/machinery/asteroidcannon
	name = "Asteroid Defense System"
	desc = "A huge machine that shoots down oncoming asteroids."
	icon = 'icons/obj/asteroidcannon.dmi'
	icon_state = "asteroidgun"
	bound_height = 128
	bound_width = 128
	density = TRUE
	anchored = TRUE
	dir = EAST //Ship faces east, so does big mega gun.
	var/lead_distance = 0 //How aggressively to lead each shot. If set to 0 the bullets become hitscan.
	var/bullet_origin_offset = 4 //+/-x. Offsets the bullet so it can shoot "through the wall" to more closely mirror the source material's gun.
	var/firing_arc = 180
	var/fire_sound = 'sound/weapons/taser2.ogg'
	var/datum/extension/asteroidcannon/AC = null
	var/next_shot = 0
	var/fire_delay = 0.10 SECONDS

/obj/machinery/asteroidcannon/proc/is_operational()
	return TRUE

/obj/machinery/asteroidcannon/ex_act(severity)
	return FALSE

/obj/item/projectile/bullet/pellet/asteroidcannon
	name = "Accelerated Tungsten Slug"
	icon_state = "asteroidcannon"
	damage = 100
	step_delay = 0
	pellets = 2
	range_step = 3
	spread_step = 3

/obj/item/projectile/bullet/pellet/asteroidcannon/Bump(atom/A, forced)
	. = ..()
	if(istype(A, /obj/effect/meteor))
		var/obj/effect/meteor/M = A
		M.visible_message("<span class='danger'>\The [M] breaks into dust!</span>")
		M.make_debris()
		qdel(M)
		qdel(src)

/obj/machinery/asteroidcannon/proc/fire_at(atom/T)
	if(Get_Angle(src, T) > firing_arc || world.time < next_shot)
		return FALSE
	next_shot = world.time + fire_delay
	var/obj/item/projectile/bullet/pellet/asteroidcannon/bullet = new (get_turf(locate(src.x+bullet_origin_offset, src.y, src.z)))
	playsound(src, fire_sound, 100, 1)
	//And apply the bullet offset... Gunners don't get hitscan bullets
	if(lead_distance <= 0)
		bullet.hitscan = TRUE
	bullet.launch(T)

/obj/machinery/asteroidcannon/attack_hand(mob/user)
	start_gunning(user)

/obj/machinery/asteroidcannon/proc/start_gunning(mob/user)
	if(!isliving(user) || user.is_necromorph())
		return FALSE //No.
	AC.set_gunner(user)

/obj/machinery/asteroidcannon/Initialize(mapload, d)
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
	var/obj/machinery/asteroidcannon/gun = null
	var/mob/living/carbon/human/gunner = null
	var/mob/observer/eye/asteroidcannon/eyeobj = null

/mob/observer/eye/asteroidcannon
	var/obj/machinery/asteroidcannon/gun = null

/mob/observer/eye/asteroidcannon/EyeMove(direct)
	if((direct == WEST) && (src.x < gun.x)) //No looking behind you...
		setLoc(get_turf(locate(gun.x, y)))
		return FALSE
	. = ..()

/mob/observer/eye/asteroidcannon/Destroy()
	gun = null
	. = ..()

/datum/extension/asteroidcannon/Process()
	if(gunner) //We've got a gunner, don't fire.
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
	gunner.set_dir(8)
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
	if(!istype(holder, /obj/machinery/asteroidcannon))
		return FALSE
	gun = holder
	START_PROCESSING(SSfastprocess, src)

// Asteroid cannon console.
/obj/machinery/computer/asteroidcannon
	name = "Asteroid Defense Mainframe"
	desc = "A console used to control the ship's automated asteroid defense systems."
	var/ui_template = "asteroidcannon.tmpl"
	var/obj/machinery/asteroidcannon/gun = null
	var/reboot_step = 0
	var/time_per_step = 10 SECONDS

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
	data["magaccelerators"] = reboot_step == 0
	data["is_operational"] = gun?.is_operational()
	data["cannon_status"] =  data["is_operational"] ? "ONLINE" : "OFFLINE"
	return data

/obj/machinery/computer/asteroidcannon/proc/handle_topic_href(var/datum/shuttle/autodock/shuttle, var/list/href_list, var/user)
	if(!gun)
		return TOPIC_NOACTION

	if(href_list["magaccelerators"])
		to_chat(world, "bing")
		return TOPIC_REFRESH